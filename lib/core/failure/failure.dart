class AppFailure {
  final String message;

  const AppFailure({this.message = "Some Failure is occurred"});

  @override
  String toString() => "AppFailure(message: $message)";
}
