import 'package:stream_state/store/account.dart';

class Success<T> {
  T data;
  Success({this.data});
}

class Error {
  Error(String error);
}

/// Response from API calls
/// ```dart
/// final response = CallResponse(success: Success<String>("It worked!"));
/// response.successful; // => true
/// final errorResponse = CallResponse(error: Error("Oops :("));
/// errorResponse.error; // => Oops :(
/// ```
class CallResponse {
  Success success;
  Error error;

  CallResponse({
    this.success,
    this.error,
  });

  bool get successful => success != null;
  bool get hasError => error != null;
}

class AccountService {
  AccountService();

  Future<CallResponse> subscribe(Account account) async {
    await Future.delayed(Duration(seconds: 2));
    return CallResponse(success: Success(data: "Success"));
  }

  Future<CallResponse> unSubscribe(Account account) async {
    await Future.delayed(Duration(seconds: 2));
    return CallResponse(success: Success(data: "Success"));
  }
}
