import 'package:flutter/material.dart';

import '../i18n.dart';

import '../icons.dart';
import '../models.dart';
import '../store.dart';
import '../theme/app_theme.dart';

/// The chat-tab mailbox overlay: newest-first, paged backward for infinite
/// scroll. Each entry is classified by (msgType, source) so a human prompt is
/// distinguishable from another session's hand-off or automation.
class MailboxOverlay extends StatefulWidget {
  final AppStore store;
  const MailboxOverlay({super.key, required this.store});

  @override
  State<MailboxOverlay> createState() => _MailboxOverlayState();
}

class _MailboxOverlayState extends State<MailboxOverlay> {
  static const int _pageSize = 30;
  AppStore get store => widget.store;
  final List<MailboxEntry> _entries = [];
  bool _hasMore = false;
  bool _loading = false;
  bool _loadingMore = false;
  int _rev = -1;

  @override
  void initState() {
    super.initState();
    store.addListener(_onStore);
    _load();
  }

  @override
  void dispose() {
    store.removeListener(_onStore);
    super.dispose();
  }

  void _onStore() {
    if (store.sessionRevision != _rev) {
      _rev = store.sessionRevision;
      _load();
    }
  }

  Future<void> _load() async {
    final sid = store.activeSessionId;
    if (sid == null) return;
    setState(() => _loading = true);
    try {
      final page = await store.api.mailbox(sid, limit: _pageSize);
      if (!mounted) return;
      setState(() {
        _entries
          ..clear()
          ..addAll(page.entries);
        _hasMore = page.hasMore;
        _loading = false;
      });
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _loadMore() async {
    final sid = store.activeSessionId;
    if (sid == null || _loadingMore || !_hasMore || _entries.isEmpty) return;
    setState(() => _loadingMore = true);
    try {
      final page =
          await store.api.mailbox(sid, before: _entries.last.id, limit: _pageSize);
      if (!mounted) return;
      setState(() {
        _entries.addAll(page.entries);
        _hasMore = page.hasMore;
        _loadingMore = false;
      });
    } catch (_) {
      if (mounted) setState(() => _loadingMore = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = colorsOf(context);
    final text = textOf(context);
    if (_entries.isEmpty) {
      return Center(
          child: _loading
              ? const CircularProgressIndicator()
              : Text(context.l10n.noMessages,
                  style: TextStyle(color: colors.mutedForeground)));
    }
    return NotificationListener<ScrollNotification>(
      onNotification: (n) {
        if (n.metrics.pixels >= n.metrics.maxScrollExtent - 120) {
          _loadMore();
        }
        return false;
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(AppSpacing.md),
        itemCount: _entries.length + 1,
        itemBuilder: (_, i) {
          if (i >= _entries.length) {
            return Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Center(
                child: _loadingMore
                    ? const CircularProgressIndicator()
                    : _hasMore
                        ? TextButton(
                            onPressed: _loadMore,
                            child: Text(context.l10n.loadEarlier),
                          )
                        : Text(context.l10n.noMoreMessages,
                            style: text.micro
                                .copyWith(color: colors.mutedForeground)),
              ),
            );
          }
          final e = _entries[i];
          final consumed = e.consumedAt != null;
          final meta = _metaOf(context, e.msgType, e.source);
          return Card(
            margin: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.sm),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: meta.color.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(meta.icon, size: 12, color: meta.color),
                            const SizedBox(width: 4),
                            Text(meta.label,
                                style: text.micro.copyWith(
                                    color: meta.color,
                                    fontWeight: FontWeight.w600)),
                            if (meta.origin.isNotEmpty)
                              Text(' · ${meta.origin}',
                                  style: text.micro.copyWith(
                                      color: meta.color.withValues(alpha: 0.8))),
                          ],
                        ),
                      ),
                      const Spacer(),
                      Text(
                        consumed ? context.l10n.consumed : context.l10n.pending,
                        style: text.micro.copyWith(
                            color:
                                consumed ? colors.success : colors.mutedForeground),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  SelectableText(
                      e.payload.length > 500
                          ? '${e.payload.substring(0, 500)}…'
                          : e.payload,
                      style: text.mono.copyWith(
                          fontSize: 11, color: colors.mutedForeground)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  /// Map (msgType, source) to an icon + localized label + accent. `source` is
  /// an open string: `user` | `session:{name}` | `system:{name}` | other.
  _MailboxMeta _metaOf(BuildContext context, String msgType, String source) {
    final colors = colorsOf(context);
    if (msgType == 'interrupt') {
      return _MailboxMeta(AppIcons.stop, context.l10n.mailboxInterrupt,
          colors.destructive);
    }
    if (msgType != 'trigger') {
      return _MailboxMeta(
          AppIcons.bolt, context.l10n.mailboxEvent, colors.warning);
    }
    if (source == 'user') {
      return _MailboxMeta(
          AppIcons.user, context.l10n.mailboxPrompt, colors.primary);
    }
    if (source.startsWith('session:')) {
      return _MailboxMeta(AppIcons.chat, context.l10n.mailboxFromSession,
          const Color(0xFF0284C7),
          origin: source.substring('session:'.length));
    }
    if (source.startsWith('system:')) {
      return _MailboxMeta(
          AppIcons.bolt, context.l10n.mailboxFromSystem, const Color(0xFF7C3AED),
          origin: source.substring('system:'.length));
    }
    return _MailboxMeta(
        AppIcons.bolt, context.l10n.mailboxPrompt, colors.primary,
        origin: source);
  }
}

class _MailboxMeta {
  final IconData icon;
  final String label;
  final Color color;
  final String origin;
  const _MailboxMeta(this.icon, this.label, this.color, {this.origin = ''});
}
