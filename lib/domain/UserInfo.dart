class UserInfo {
  final String facilityName;
  final String userName;
  final String protectorName;
  final String userRole;

  const UserInfo({
    required this.facilityName,
    required this.userName,
    required this.protectorName,
    required this.userRole,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      facilityName: json['facility_name'],
      userName: json['user_name'],
      protectorName: json['user_protector_name'],
      userRole: json['userRole'],
    );
  }
}
