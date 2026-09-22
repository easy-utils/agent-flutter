// Behavioural conformance: replay the SHARED scenario manifest (vendored from
// easy-utils/agent-tools/conformance/scenarios.json) through the REAL
// MessagesController against a scripted fake AgentBindApi, then compare a
// normalized state snapshot. This proves the state machine behaves like the
// webui reference (abcp-sdk/webui/src/lib/messages.test.ts) — the string guards
// cannot. Every scenario id in the manifest appears below.
import 'dart:async';

import 'package:agent_app/api.dart';
import 'package:agent_app/messages.dart';
import 'package:agent_app/models.dart';
import 'package:flutter_test/flutter_test.dart';

/// A faithful in-memory fake: the persisted chain + a push stream controller.
class _FakeServer {
  final chain = <Message>[];
  final ctrl = StreamController<StreamEvent>.broadcast();
  String? promptErr;
  String status = 'idle';

  void failPrompt(String msg) => promptErr = msg;
  void clearPromptError() => promptErr = null;
  void persist(Message m) => chain.add(m);
  void push(StreamEvent e) => ctrl.add(e);
}

class _FakeApi extends AgentBindApi {
  _FakeApi(this.server) : super(baseUrl: 'test', token: 'test');
  final _FakeServer server;

  @override
  Future<String> prompt(String id, String prompt,
      {List<String>? attachments}) async {
    if (server.promptErr != null) throw Exception(server.promptErr);
    return 'accepted';
  }

  @override
  Future<(List<Message>, bool)> messages(String id,
          {String? before, int limit = 30}) async =>
      ([...server.chain], false);

  @override
  Future<({List<Message> messages, bool resync, String tipId})> messagesAfter(
      String id, String after,
      {int limit = 200}) async {
    final tip = server.chain.isEmpty ? '' : server.chain.last.id;
    if (after.isEmpty) {
      return (messages: [...server.chain], resync: false, tipId: tip);
    }
    final i = server.chain.indexWhere((m) => m.id == after);
    if (i < 0) return (messages: [...server.chain], resync: true, tipId: tip);
    return (messages: server.chain.sublist(i + 1), resync: false, tipId: tip);
  }

  @override
  Future<(String, List<dynamic>)> state(String id) async =>
      (server.status, <dynamic>[]);

  @override
  Stream<StreamEvent> streamEvents(String sessionId, {String since = ''}) =>
      server.ctrl.stream;
}

// ---- scenario manifest (mirrors conformance/scenarios.json) ----
const _scenarioIds = [
  'boot_empty',
  'happy_path',
  'replay_reorder',
  'multi_step',
  'eid_dedup',
  'reconnect_persisted',
  'tool_error',
  'model_error',
  'send_failure',
  'error_transient',
];

int _eid = 0;
StreamEvent _ev(String event, Map<String, dynamic> params,
        {String? eid}) =>
    StreamEvent(event, params, eid: eid ?? 'e${_eid++}', runId: 'r1');

Message _msg(String id, String role, String prevId, List<MessagePart> parts) =>
    Message(id: id, role: role, prevId: prevId, parts: parts);

MessagePart _text(String id, String t) =>
    MessagePart(id: id, type: 'text', text: t);
MessagePart _reasoning(String id, String t) =>
    MessagePart(id: id, type: 'reasoning', text: t);

/// The domain part the real mapper produces from a persisted `tool_result`.
MessagePart _tool(String id, String name) => MessagePart(
    id: id,
    type: 'tool',
    tool: name,
    state: ToolState(status: 'complete'));

/// Boot the real controller, drive one scenario, snapshot its messages.
Future<List<ChatMessage>> _replay(String id) async {
  final server = _FakeServer();
  final ctrl = MessagesController(api: _FakeApi(server), getSessionId: () => 's1');
  ctrl.init();
  await _settle();

  Future<void> send(String text) async {
    await ctrl.send(text);
    await _settle();
  }

  switch (id) {
    case 'boot_empty':
      await _settle();
      expect(ctrl.messages.length, 0, reason: id);
      expect(ctrl.sending, false, reason: id);

    case 'happy_path':
      await send('hi');
      server.push(_ev('status', {'type': 'busy'}));
      server.persist(_msg('u1', 'user', '', [_text('p0', 'hi')]));
      server.push(_ev('message-added',
          {'message_id': 'u1', 'prev_id': '', 'role': 'user'}));
      server.push(_ev('message-added', {
        'message_id': 'a1',
        'prev_id': 'u1',
        'role': 'assistant',
        'streaming': true
      }));
      server.push(_ev('text-start', {'id': 't0', 'message_id': 'a1'}));
      server.push(_ev('text-delta', {'id': 't0', 'text': 'Hello'}));
      server.push(_ev('text-delta', {'id': 't0', 'text': ' world'}));
      server.push(_ev('tool-input-start', {'id': 'tc1', 'toolName': 'web.search'}));
      server.push(_ev('tool-input-delta', {'id': 'tc1', 'delta': '{"q":"x"}'}));
      server.push(_ev('tool-call', {
        'toolCallId': 'tc1',
        'toolName': 'web.search',
        'input': {'q': 'x'}
      }));
      server.push(_ev('tool-result', {'toolCallId': 'tc1', 'output': 'found 1'}));
      await _settle();
      // Mid-stream checkpoint.
      expect(ctrl.messages.map((m) => m.id).toList(), ['u1', 'a1'], reason: id);
      final mid = ctrl.messages.firstWhere((m) => m.id == 'a1');
      expect(mid.status, 'streaming', reason: id);
      expect(mid.parts.firstWhere((p) => p.type == 'text').text, 'Hello world',
          reason: id);
      final toolPart = mid.parts.firstWhere((p) => p.type == 'tool');
      expect(toolPart.state?.status, 'complete', reason: id);
      expect(toolPart.state?.output, 'found 1', reason: id);
      expect(ctrl.sending, true, reason: id);

      server.persist(_msg('a1', 'assistant', 'u1',
          [_text('t0', 'Hello world'), _tool('tc1', 'web.search')]));
      server.push(_ev('turn-complete', {'reason': 'stop'}));
      await _settle();
      expect(ctrl.sending, false, reason: id);
      expect(ctrl.messages.map((m) => m.id).toList(), ['u1', 'a1'], reason: id);
      final a1 = ctrl.messages.firstWhere((m) => m.id == 'a1');
      expect(a1.status, 'complete', reason: id);
      expect(a1.isLocal, false, reason: id);
      expect(ctrl.messages.where((m) => m.id == 'a1').length, 1, reason: id);

    case 'replay_reorder':
      server.push(_ev('text-delta',
          {'id': 't0', 'text': 'Hi', 'message_id': 'a1'}));
      await _settle();
      expect(ctrl.messages.where((m) => m.id == 'a1').length, 1, reason: id);
      server.push(_ev('message-added', {
        'message_id': 'a1',
        'prev_id': '',
        'role': 'assistant',
        'streaming': true
      }));
      await _settle();
      final hits = ctrl.messages.where((m) => m.id == 'a1').toList();
      expect(hits.length, 1, reason: id);
      expect(hits[0].parts.map((p) => p.text).join(), 'Hi', reason: id);
      expect(hits[0].status, 'streaming', reason: id);

    case 'multi_step':
      server.push(_ev('message-added', {
        'message_id': 'a1',
        'prev_id': '',
        'role': 'assistant',
        'streaming': true
      }));
      server.push(_ev('text-delta',
          {'id': 't0', 'text': 'step one', 'message_id': 'a1'}));
      await _settle();
      expect(ctrl.messages.firstWhere((m) => m.id == 'a1').status, 'streaming',
          reason: id);
      server.persist(_msg('a1', 'assistant', '', [_text('t0', 'step one')]));
      server.push(_ev('message-added', {
        'message_id': 'a2',
        'prev_id': 'a1',
        'role': 'assistant',
        'streaming': true
      }));
      server.push(_ev('text-delta',
          {'id': 't1', 'text': 'step two', 'message_id': 'a2'}));
      await _settle();
      expect(ctrl.messages.firstWhere((m) => m.id == 'a1').status, 'complete',
          reason: id);
      expect(ctrl.messages.firstWhere((m) => m.id == 'a2').status, 'streaming',
          reason: id);
      server.persist(_msg('a2', 'assistant', 'a1', [_text('t1', 'step two')]));
      server.push(_ev('turn-complete', {'reason': 'stop'}));
      await _settle();
      expect(ctrl.messages.map((m) => m.id).toList(), ['a1', 'a2'], reason: id);
      expect(ctrl.messages.every((m) => m.status == 'complete'), true,
          reason: id);
      expect(ctrl.messages.every((m) => !m.isLocal), true, reason: id);

    case 'eid_dedup':
      server.push(_ev('message-added', {
        'message_id': 'a1',
        'prev_id': '',
        'role': 'assistant',
        'streaming': true
      }));
      server.push(_ev('text-delta', {'id': 't0', 'text': 'Ha'}, eid: 'dup-eid'));
      server.push(_ev('text-delta', {'id': 't0', 'text': 'Ha'}, eid: 'dup-eid'));
      server.push(_ev('text-delta', {'id': 't0', 'text': 'Ha'}, eid: 'dup-eid'));
      await _settle();
      expect(ctrl.messages.where((m) => m.id == 'a1').length, 1, reason: id);
      expect(
          ctrl.messages
              .firstWhere((m) => m.id == 'a1')
              .parts
              .map((p) => p.text)
              .join(),
          'Ha',
          reason: id);

    case 'reconnect_persisted':
      server.push(_ev('message-added', {
        'message_id': 'a1',
        'prev_id': '',
        'role': 'assistant',
        'streaming': true
      }));
      server.push(_ev('text-delta',
          {'id': 't0', 'text': 'Hello', 'message_id': 'a1'}));
      server.push(_ev('reasoning-delta',
          {'id': 'r0', 'text': 'think', 'message_id': 'a1'}));
      await _settle();
      server.persist(_msg('a1', 'assistant', '',
          [_text('srv-t0', 'Hello'), _reasoning('srv-r0', 'think')]));
      server.push(_ev('turn-complete', {'reason': 'stop'}));
      await _settle();
      final before = ctrl.messages.firstWhere((m) => m.id == 'a1');
      expect(before.isLocal, false, reason: id);
      expect(before.parts.length, 2, reason: id);
      // Reconnect: the SAME deltas (stream ids) must be ignored.
      server.push(_ev('text-delta',
          {'id': 't0', 'text': 'Hello', 'message_id': 'a1'}));
      server.push(_ev('reasoning-delta',
          {'id': 'r0', 'text': 'think', 'message_id': 'a1'}));
      await _settle();
      final after = ctrl.messages.firstWhere((m) => m.id == 'a1');
      expect(after.parts.length, 2, reason: id);
      expect(after.parts.where((p) => p.type == 'reasoning').length, 1,
          reason: id);
      expect(
          after.parts
              .where((p) => p.type == 'text')
              .map((p) => p.text)
              .join(),
          'Hello',
          reason: id);

    case 'tool_error':
      server.push(_ev('message-added', {
        'message_id': 'a1',
        'prev_id': '',
        'role': 'assistant',
        'streaming': true
      }));
      server.push(_ev('tool-call', {'toolCallId': 'tc9', 'toolName': 'boom'}));
      server.push(_ev('tool-error', {
        'toolCallId': 'tc9',
        'error': {'message': 'kaput'}
      }));
      await _settle();
      final toolPart = ctrl.messages
          .firstWhere((m) => m.id == 'a1')
          .parts
          .firstWhere((p) => p.id == 'tc9');
      expect(toolPart.state?.status, 'error', reason: id);
      expect(toolPart.state?.error, 'kaput', reason: id);

    case 'model_error':
      server.push(_ev('status', {'type': 'busy'}));
      server.push(_ev('message-added', {
        'message_id': 'a1',
        'prev_id': '',
        'role': 'assistant',
        'streaming': true
      }));
      await _settle();
      expect(ctrl.sending, true, reason: id);
      server.push(_ev('error', {
        'error': {'message': 'upstream 500'}
      }));
      await _settle();
      expect(ctrl.sending, false, reason: id);
      final err = ctrl.messages.firstWhere((m) => m.role == 'error');
      expect(err.status, 'error', reason: id);
      expect(err.isLocal, true, reason: id);
      expect(err.errorKind, 'model', reason: id);
      expect(err.parts.first.text.contains('upstream 500'), true, reason: id);

    case 'send_failure':
      server.failPrompt('mailbox down');
      await send('hi');
      expect(ctrl.sending, false, reason: id);
      final err = ctrl.messages.firstWhere((m) => m.role == 'error');
      expect(err.errorKind, 'send', reason: id);
      expect(err.parts.first.text.contains('mailbox down'), true, reason: id);

    case 'error_transient':
      server.failPrompt('mailbox down');
      await send('hi');
      expect(ctrl.messages.any((m) => m.role == 'error'), true, reason: id);
      server.clearPromptError();
      await send('again');
      expect(ctrl.messages.where((m) => m.role == 'error').length, 0,
          reason: id);
  }

  final out = [...ctrl.messages];
  ctrl.dispose();
  await server.ctrl.close();
  return out;
}

/// Let queued microtasks / timers settle.
Future<void> _settle() async {
  for (var i = 0; i < 20; i++) {
    await Future<void>.delayed(Duration.zero);
  }
}

void main() {
  for (final id in _scenarioIds) {
    test('conformance: $id', () async {
      await _replay(id);
    });
  }
}
