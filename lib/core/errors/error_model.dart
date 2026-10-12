class ErrorModel {
  final int? statusCode;
  final bool succeeded;
  final String errorMessage;
  final String? errorCode;
  final List<String> errors;
  final dynamic data;

  const ErrorModel({
    this.statusCode,
    this.succeeded = false,
    required this.errorMessage,
    this.errorCode,
    this.errors = const [],
    this.data,
  });

  factory ErrorModel.fromJson(Map<String, dynamic> json) {
    // 1. Extract error code & description if nested in 'error' object
    String? code;
    String? errorDesc;
    if (json['error'] is Map<String, dynamic>) {
      final errMap = json['error'] as Map<String, dynamic>;
      code = errMap['code'] as String?;
      errorDesc = errMap['description'] as String?;
    }

    // 2. Extract errors list
    final List<String> errorsList = [];
    if (json['errors'] is List) {
      for (final e in json['errors'] as List) {
        if (e != null) errorsList.add(e.toString());
      }
    } else if (json['errors'] is Map) {
      // Model validation errors map (e.g. ASP.NET ModelState dictionary)
      final map = json['errors'] as Map;
      for (final entry in map.entries) {
        if (entry.value is List) {
          for (final msg in entry.value as List) {
            errorsList.add(msg.toString());
          }
        } else {
          errorsList.add('${entry.key}: ${entry.value}');
        }
      }
    }

    // 3. Determine best error message
    final String message = errorDesc ??
        (errorsList.isNotEmpty ? errorsList.first : null) ??
        json['message'] as String? ??
        json['title'] as String? ??
        'An unexpected server error occurred';

    return ErrorModel(
      statusCode: json['statusCode'] as int? ?? json['status'] as int?,
      succeeded: json['succeeded'] as bool? ?? false,
      errorMessage: message,
      errorCode: code,
      errors: errorsList,
      data: json['data'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'statusCode': statusCode,
      'succeeded': succeeded,
      'message': errorMessage,
      if (errorCode != null) 'errorCode': errorCode,
      'errors': errors,
      if (data != null) 'data': data,
    };
  }
}
