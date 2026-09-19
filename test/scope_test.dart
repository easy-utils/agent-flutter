import 'package:agent_app/scope.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('scope is stable and per (baseUrl, token)', () {
    final a = scopeOf('https://gw.example', 'tok-a');
    final b = scopeOf('https://gw.example', 'tok-b'); // same host, other tenant
    final c = scopeOf('https://other.example', 'tok-a');
    expect(a, scopeOf('https://gw.example', 'tok-a'));
    expect(a, isNot(b));
    expect(a, isNot(c));
    expect(a.length, 8);
    expect(RegExp(r'^[0-9a-f]{8}$').hasMatch(a), isTrue);
    // Exact expected value (the same djb2 all four clients implement).
    expect(a, '1a5c49ae');
  });
}
