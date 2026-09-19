import 'package:easy_rpc/easy_rpc.dart';
import 'package:easy_rpc/src/mobile/fetch_transport.dart';

/// Web: fetch-based transport; the browser trust store is used, so [caPem] is
/// ignored (kept for signature parity with the native transport). Uses fetch +
/// the built-in metadata/deadline interceptors (the dart:io-based `connect()`
/// composition root is not web-compatible).
Transport buildAgentTransport({
  required String baseUrl,
  String token = '',
  String? caPem,
  int timeoutMs = 0,
}) {
  final inner = FetchTransport(baseUrl: baseUrl);
  final ics = <Interceptor>[
    if (token.isNotEmpty) MetadataInterceptor({'authorization': ['Bearer $token']}),
    if (timeoutMs > 0) TimeoutInterceptor(timeoutMs),
  ];
  return ics.isEmpty ? inner : InterceptorTransport(ics, inner);
}
