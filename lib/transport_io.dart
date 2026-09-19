import 'dart:convert';
import 'dart:io' as io;

import 'package:cronet_http/cronet_http.dart';
import 'package:easy_rpc/easy_rpc.dart';
import 'package:easy_rpc/src/mobile/cronet_http_transport.dart';

/// Build the platform transport for a direct agent connection.
///
/// **Android** uses the system HTTP stack (Chromium *Cronet*) via the
/// `cronet_http` plugin: HTTP/1+2+3 negotiated by the platform, and — the
/// reason it exists here — Cronet verifies TLS through Android's
/// `network_security_config.xml`, so the bundled private ingress CA is trusted
/// exactly as on the Compose client. (The pure-Dart h2 adapter dials with
/// `SecureSocket`, which would need the CA threaded in and does no HTTP/3.)
///
/// **Other native targets** (Linux/macOS/Windows) keep the Dart h2 adapter with
/// a `SecurityContext` carrying the CA.
///
/// easy-rpc is transport-agnostic: both branches hand the composed transport to
/// the same generated client.
Transport buildAgentTransport({
  required String baseUrl,
  String token = '',
  String? caPem,
  int timeoutMs = 0,
}) {
  final trimmed = baseUrl.endsWith('/')
      ? baseUrl.substring(0, baseUrl.length - 1)
      : baseUrl;

  if (io.Platform.isAndroid) {
    final engine = CronetEngine.build(
      cacheMode: CacheMode.memory,
      cacheMaxSize: 2 * 1024 * 1024,
      enableHttp2: true,
      enableQuic: true,
      enableBrotli: true,
      userAgent: 'Easy Agent',
    );
    final client = CronetClient.fromCronetEngine(engine, closeEngine: true);
    return connect(
      baseUrl: trimmed,
      token: token,
      timeoutMs: timeoutMs,
      transport: CronetHttpTransport(client: client, baseUrl: trimmed),
    );
  }

  final sc = io.SecurityContext(withTrustedRoots: true);
  if (caPem != null && caPem.isNotEmpty) {
    sc.setTrustedCertificatesBytes(utf8.encode(caPem));
  }
  // The SecurityContext must be threaded through explicitly: the http2 adapter
  // dials with SecureSocket, so a client carrying the CA is NOT enough.
  return connect(
    baseUrl: trimmed,
    token: token,
    mode: TransportMode.http2,
    timeoutMs: timeoutMs,
    httpClient: io.HttpClient(context: sc),
    securityContext: sc,
  );
}
