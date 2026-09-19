import 'dart:convert';

/// Local storage scope: a short, stable id derived from the ACTIVE connection
/// (gateway base URL + bearer token).
///
/// WHY: the tenant lives inside the token (the client can never name it), and
/// one gateway host can serve several tenants. Every per-connection cache —
/// the sqlite mirror (sessions/messages/drafts/read watermarks) and the
/// persisted read watermarks — is therefore keyed by this scope, so switching
/// users (i.e. token) starts from a clean slate instead of leaking another
/// tenant's sessions or unread badges.
///
/// The algorithm only needs to be stable on THIS device (each client owns its
/// own local store), but it is written to be exact in every language:
/// djb2 modulo 2^31, so each step stays inside the float-exact range even on
/// the web (Flutter web ints are doubles).
String scopeOf(String baseUrl, String token) {
  var h = 5381;
  for (final b in utf8.encode('$baseUrl\n$token')) {
    h = ((h * 33) + b) & 0x7fffffff;
  }
  return h.toRadixString(16).padLeft(8, '0');
}
