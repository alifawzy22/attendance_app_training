import 'package:attendance_app_training/constants.dart';
import 'package:attendance_app_training/models/attendance_model.dart';
import 'package:attendance_app_training/models/drop_down_changed_model.dart';
import 'package:attendance_app_training/models/drop_downs_model.dart';
import 'package:attendance_app_training/models/filter_data_model.dart';
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

  // Update  Data table
  Future<List<FilterDataModel>> updateDataTable({
    required DropDownChangedModel? dropDownChangedModel,
  }) async {
    try {
      final response = await _dio.get(
        '${Constants.baseUrl}${Constants.updateDataTable}',
        queryParameters: dropDownChangedModel == null
            ? {}
            : dropDownChangedModel.tojson(),
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        return (response.data['data'] as List).isEmpty
            ? []
            : (response.data['data'] as List)
                  .map((item) => FilterDataModel.fromJson(item))
                  .toList();
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

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

  // Update Attendance
  Future<bool> updateAttendance({
    required List<Map<String, dynamic>> checkBoxAttendanceList,
  }) async {
    try {
      final response = await _dio.put(
        '${Constants.baseUrl}${Constants.checkBoxAttendanceUrl}',
        data: checkBoxAttendanceList,
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  // get  Attendance
  Future<List<AttendanceModel>> getAttandance({
    required DropDownChangedModel dropDownChangedModel,
  }) async {
    try {
      final response = await _dio.get(
        '${Constants.baseUrl}${Constants.getAttendance}',
        queryParameters: dropDownChangedModel.tojson(),
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        return (response.data['data'] as List).isEmpty
            ? []
            : (response.data['data'] as List)
                  .map((item) => AttendanceModel.fromJson(item))
                  .toList();
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }
}
