import 'package:project_management_app/features/auth/model/user_model.dart';

class ProjectUsersResponse {
  List<UserModel>? allUsers;
  List<UserModel>? selectedUsers;

  ProjectUsersResponse({
    this.allUsers,
    this.selectedUsers,
  });
}
