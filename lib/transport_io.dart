import 'dart:convert';
import 'dart:io' as io;

import 'package:easy_rpc/easy_rpc.dart';

/// Build the platform transport for a direct agent connection. Native uses
/// HTTP/2 over TLS (ALPN `h2`) via the easy-rpc transport, trusting the bundled
/// self-signed CA. easy-rpc is transport-agnostic; callers may swap in the
/// `IoTransport`/`FetchTransport` adapters.
Transport buildAgentTransport({
  required String baseUrl,
  String token = '',
  String? caPem,
  int timeoutMs = 0,
}) {
  final sc = io.SecurityContext(withTrustedRoots: true);
  if (caPem != null && caPem.isNotEmpty) {
    sc.setTrustedCertificatesBytes(utf8.encode(caPem));
  }
  // Composition root: pick the adapter (`TransportMode.http2` today; switching
  // to `io` is a one-line change) and install metadata/deadline interceptors.
  return connect(
    baseUrl: baseUrl,
    token: token,
    mode: TransportMode.http2,
    timeoutMs: timeoutMs,
    httpClient: io.HttpClient(context: sc),
  );
}
