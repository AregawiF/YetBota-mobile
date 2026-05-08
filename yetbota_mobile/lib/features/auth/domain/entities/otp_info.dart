class OtpInfo {
  const OtpInfo({
    required this.requestCount,
    required this.maxRequests,
    required this.errorCount,
    required this.maxErrors,
  });

  final int requestCount;
  final int maxRequests;
  final int errorCount;
  final int maxErrors;
}
