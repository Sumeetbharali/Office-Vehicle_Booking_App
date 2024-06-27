import 'dart:convert';

bool isTokenExpired(String token) {
  final parts = token.split('.');
  if (parts.length != 3) {
    return true; // Invalid token format
  }

  final payload = utf8.decode(base64Url.decode(base64Url.normalize(parts[1])));
  final payloadMap = json.decode(payload);

  if (payloadMap is! Map<String, dynamic>) {
    return true;
  }

  final exp = payloadMap['exp'];
  if (exp is! int) {
    return true;
  }

  final expirationDate = DateTime.fromMillisecondsSinceEpoch(exp * 1000);
  return DateTime.now().isAfter(expirationDate);
}
