import 'dart:io';
import 'package:dio/dio.dart';
import '../../error/failures.dart';

class AppErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    Failure failure;

    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
          failure = Failure.timeout();
        break;
      case DioExceptionType.badResponse:
        final statusCode = err.response?.statusCode;
        final message = err.response?.data?['message'] ?? err.message;
        failure = Failure(
          message: message ?? 'Server error',
          statusCode: statusCode,
        );
        break;
      case DioExceptionType.cancel:
        failure = Failure(message: 'Request cancelled');
        break;
      case DioExceptionType.connectionError:
          failure = Failure.noInternet();
        break;
      case DioExceptionType.unknown:
        if (err.error is SocketException) {
          failure = Failure.noInternet();
        } else {
          failure = Failure(message: 'Something went wrong');
        }
        break;
      default:
        failure = Failure(message: 'Unexpected error');
    }

    // Wrap the original error with our Failure
    final newErr = DioException(
      requestOptions: err.requestOptions,
      error: failure,
      type: err.type,
      response: err.response,
    );

    return handler.next(newErr);
  }
}
