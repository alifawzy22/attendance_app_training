class Constants {
  static const String isUserLoggedIn = 'isLoggedIn';
  static const String kAccessToken = "accessToken";
  static const String kRefreshToken = "refreshToken";
  static const String baseUrl =
      // "http://api_reqaba.pm/api/";
      'https://pmis_api_st.digitalegypt.gov.eg/api/';
  static const String authUrl = "Oauth/login";
  static const String dropDownsUrl =
      "TrainingRegistrations/LookupsForDropdowns";
  static const String checkBoxAttendanceUrl =
      "TrainingRegistrations/UpdateAttendance";

  static const String updateDataTable = 'TrainingRegistrations/All';
  static const String getAttendance = 'TrainingRegistrations/attendance';
}
