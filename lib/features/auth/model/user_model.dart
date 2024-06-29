class UserModel {
  String? id;
  String? fullName;
  String? email;

  UserModel({
    this.id,
    this.fullName,
    this.email,
  });

  factory UserModel.fromJson(dynamic json) {
    return UserModel(
      id: json['id'],
      fullName: json['fullName'],
      email: json['email'],
    );
  }

  Map<String, String> toJson() {
    return {
      "id": id!,
      "fullName": fullName!,
      "email": email!,
    };
  }
}
