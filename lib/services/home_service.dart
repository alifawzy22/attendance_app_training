import 'package:attendance_app_training/constants.dart';
import 'package:attendance_app_training/models/drop_downs_model.dart';
import 'package:attendance_app_training/models/check_box_attendance_model.dart';
import 'package:dio/dio.dart';

class HomeService {
  final Dio _dio;

  HomeService({Dio? dio})
    : _dio =
          dio ??
          Dio(
            BaseOptions(
              baseUrl: Constants.baseUrl,
              headers: {'Content-Type': 'application/json'},
            ),
          );

  // Get DropDowns Data
  Future<DropDownsModel?> getDropDownsData() async {
    try {
      final response = await _dio.get(
        '${Constants.baseUrl}${Constants.dropDownsUrl}',
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        return DropDownsModel.fromJson(response.data);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  //  Update Attendance
  Future<List<CheckBoxAttendanceModel>> updateAttendance({
    required String id,
    bool? morning,
    bool? night,
    int? attendacePeriod,
  }) async {
    final path = '${Constants.baseUrl}${Constants.checkBoxAttendanceUrl}';

    final Map<String, dynamic> body = {
      "id": id,
      if (morning != null) "morningattendacePeriod": morning,
      if (night != null) "nightattendacePeriod": night,
      if (attendacePeriod != null) "attendacePeriod": attendacePeriod,
    };

    try {
      final response = await _dio.put(path, data: body);

      if (response.statusCode == 200) {
        final data = response.data;

        if (data is List) {
          return data
              .map<CheckBoxAttendanceModel>(
                (e) => CheckBoxAttendanceModel.fromJson(e),
              )
              .toList();
        } else {
          throw Exception("Unexpected response format: $data");
        }
      } else {
        throw Exception(
          "Unexpected status code: ${response.statusCode}, data: ${response.data}",
        );
      }
    } on DioException catch (e) {
      print('DioException: ${e.message}');
      if (e.response != null) {
        print('Status: ${e.response?.statusCode}');
        print('Data: ${e.response?.data}');
      }
      rethrow;
    } catch (e) {
      print('Unknown error: $e');
      rethrow;
    }
  }
}
