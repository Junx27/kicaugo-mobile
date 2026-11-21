import '../constants/app_constants.dart';
import '../error/failure.dart';

/// Pembaca JSON yang melempar [DataFailure] bila bentuknya tidak sesuai kontrak.
abstract final class JsonMapper {
  static Map<String, dynamic> object(Object? value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) return Map<String, dynamic>.from(value);
    throw const DataFailure(AppConstants.apiInvalidResponse);
  }

  static String string(Map<String, dynamic> json, String field) {
    final value = json[field];
    if (value is String && value.isNotEmpty) return value;
    throw const DataFailure(AppConstants.apiInvalidResponse);
  }

  static List<String> strings(Map<String, dynamic> json, String field) {
    final value = json[field];
    if (value is! List) {
      throw const DataFailure(AppConstants.apiInvalidResponse);
    }
    final result = <String>[];
    for (final item in value) {
      if (item is! String || item.isEmpty) {
        throw const DataFailure(AppConstants.apiInvalidResponse);
      }
      result.add(item);
    }
    return result;
  }

  static int integer(Map<String, dynamic> json, String field) {
    final value = json[field];
    if (value is int) return value;
    throw const DataFailure(AppConstants.apiInvalidResponse);
  }

  static List<Object?> list(Map<String, dynamic> json, String field) {
    final value = json[field];
    if (value is List) return List<Object?>.from(value);
    throw const DataFailure(AppConstants.apiInvalidResponse);
  }

  static T enumValue<T extends Enum>(
    Map<String, dynamic> json,
    String field,
    List<T> values,
  ) {
    final name = string(json, field);
    for (final value in values) {
      if (value.name == name) return value;
    }
    throw const DataFailure(AppConstants.apiInvalidResponse);
  }
}
