import 'package:attendance_app_training/constants.dart';
import 'package:attendance_app_training/core/singleton/dio_client.dart';
import 'package:attendance_app_training/models/login_model.dart';
import 'package:dio/dio.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  final Dio _dio;

  factory AuthService() {
    return _instance;
  }

  AuthService._internal() : _dio = DioClient().dio;

  Future<LoginModel?> login(String email, String password) async {
    try {
      final response = await _dio.post(
        Constants.authUrl,
        data: {"email": email, "password": password},
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
