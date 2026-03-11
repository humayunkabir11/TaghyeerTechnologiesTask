class Failure {
  final String message;
  final int? statusCode;
  final String? constrain;

  Failure({
    required this.message,
    this.statusCode,
    this.constrain,
  });

  factory Failure.noInternet() => Failure(
        message: 'No Internet Connection',
        statusCode: 0,
        constrain: 'NO_INTERNET',
      );

  factory Failure.serverError([String? message]) => Failure(
        message: message ?? 'Server Error, please try again later',
        statusCode: 500,
      );

  factory Failure.timeout() => Failure(
        message: 'Connection Timeout',
        statusCode: 408,
      );

  bool get isNoInternet => constrain == 'NO_INTERNET';

  @override
  String toString() {
    return 'Failure(message: $message, statusCode: $statusCode, constrain: $constrain)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Failure &&
        other.message == message &&
        other.statusCode == statusCode &&
        other.constrain == constrain;
  }

  @override
  int get hashCode {
    return message.hashCode ^ statusCode.hashCode ^ constrain.hashCode;
  }
}
