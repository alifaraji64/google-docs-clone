class ErrorModel {
  bool isError;
  String message;
  dynamic data;
  ErrorModel({
    required this.isError,
    required this.message,
    this.data,
  });
}
