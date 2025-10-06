import 'package:attendance_app_training/constants.dart';
import 'package:attendance_app_training/models/login_model.dart';
import 'package:dio/dio.dart';

class AuthService {
  final Dio _dio = Dio();

  Future<LoginModel?> login(String email, String password) async {
    try {
      final response = await _dio.post(
        '${Constants.baseUrl}${Constants.authUrl}',
        data: {"email": email, "password": password},
        options: Options(headers: {"Content-Type": "application/json"}),
      );

      if (response.statusCode == 200) {
        return LoginModel.fromJson(response.data);
      } else {
        throw Exception("خطأ في تسجيل الدخول: ${response.statusCode}");
      }
    } catch (e) {
      rethrow;
    }
  }
}
