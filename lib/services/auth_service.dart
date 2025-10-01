import 'package:attendance_app_training/models/login_model.dart';
import 'package:dio/dio.dart';

class AuthService {
  final Dio _dio = Dio();

  static const String baseUrl = "http://api_reqaba.pm/api/Oauth/login";

  Future<LoginModel?> login(String email, String password) async {
    try {
      final response = await _dio.post(
        baseUrl,
        data: {"email": email, "password": password},
        options: Options(headers: {"Content-Type": "application/json"}),
      );

      if (response.statusCode == 200) {
        return LoginModel.fromJson(response.data);
      } else {
        throw Exception("خطأ في تسجيل الدخول: ${response.statusCode}");
      }
    } on DioException catch (e) {
      print("❌ Dio Error: ${e.message}");
      print("⚠️ Unexpected Status Code: ${e.response?.statusCode}");

      rethrow;
    } catch (e) {
      print("🔥 Unexpected Error: $e");
      rethrow;
    }
  }
}
