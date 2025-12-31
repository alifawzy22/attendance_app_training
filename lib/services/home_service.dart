import 'package:attendance_app_training/constants.dart';
import 'package:attendance_app_training/core/singleton/dio_client.dart';
import 'package:attendance_app_training/models/attendance_model.dart';
import 'package:attendance_app_training/models/drop_down_changed_model.dart';
import 'package:attendance_app_training/models/drop_downs_model.dart';
import 'package:attendance_app_training/models/filter_data_model.dart';
import 'package:dio/dio.dart';

class HomeService {
  static final HomeService _instance = HomeService._internal();
  final Dio _dio;

  factory HomeService() {
    return _instance;
  }

  HomeService._internal() : _dio = DioClient().dio;

  // Update Data table
  Future<List<FilterDataModel>> updateDataTable({
    required DropDownChangedModel? dropDownChangedModel,
  }) async {
    try {
      final response = await _dio.get(
        Constants.updateDataTable,
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
        Constants.dropDownsUrl,
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
        Constants.checkBoxAttendanceUrl,
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

  // get Attendance
  Future<List<AttendanceModel>> getAttandance({
    required DropDownChangedModel? dropDownChangedModel,
  }) async {
    try {
      final response = await _dio.get(
        Constants.getAttendance,
        queryParameters: dropDownChangedModel == null
            ? {}
            : dropDownChangedModel.tojson(),
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
