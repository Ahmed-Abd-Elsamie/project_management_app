import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:project_management_app/core/helpers/app_exception_messages.dart';
import 'package:project_management_app/core/utils/app_exception.dart';
import 'package:project_management_app/core/utils/debug_prints.dart';
import 'package:project_management_app/features/auth/model/user_model.dart';
import 'package:project_management_app/features/projects/model/project_model.dart';
import 'package:project_management_app/features/projects/model/project_users_response.dart';

abstract class ProjectRepository {
  Future<Either<AppException, List<ProjectModel>>> getAllProjects();

  Future<Either<AppException, Unit>> createProject(ProjectModel projectModel);

  Future<Either<AppException, Unit>> updateProject(ProjectModel projectModel);

  Future<Either<AppException, Unit>> deleteProject(String id);

  Future<Either<AppException, ProjectUsersResponse>> getProjectUsers(
      [List<String?>? usersIds]);
}

class ProjectRepositoryImpl implements ProjectRepository {
  final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Future<Either<AppException, List<ProjectModel>>> getAllProjects() async {
    try {
      final res = await _databaseReference.child("projects").get();
      List<ProjectModel> projects = List<ProjectModel>.from(
          res.children.map((e) => ProjectModel.fromJson(e.value)));
      String uid = _auth.currentUser!.uid;
      projects = projects
          .where((element) =>
              (element.userId == uid || element.projectUsers!.contains(uid)))
          .toList();
      return Right(projects);
    } on FirebaseException catch (e) {
      return Left(handleFirebaseDatabaseExceptionMessages(e));
    } catch (e) {
      printError('Error getting data: $e');
      return Left(AppException(errorMessage: "Error getting data: $e"));
    }
  }

  @override
  Future<Either<AppException, Unit>> createProject(
      ProjectModel projectModel) async {
    try {
      String? id = _databaseReference.child("projects").push().key;
      String userId = _auth.currentUser!.uid;
      projectModel.id = id;
      projectModel.userId = userId;
      await _databaseReference
          .child("projects")
          .child(id!)
          .set(projectModel.toJson());
      return const Right(unit);
    } on FirebaseException catch (e) {
      return Left(handleFirebaseDatabaseExceptionMessages(e));
    } catch (e) {
      printError('Error getting data: $e');
      return Left(AppException(errorMessage: "Error getting data: $e"));
    }
  }

  @override
  Future<Either<AppException, Unit>> updateProject(
      ProjectModel projectModel) async {
    try {
      await _databaseReference
          .child("projects")
          .child(projectModel.id!)
          .update(projectModel.toJson());
      return const Right(unit);
    } on FirebaseException catch (e) {
      return Left(handleFirebaseDatabaseExceptionMessages(e));
    } catch (e) {
      printError('Error getting data: $e');
      return Left(AppException(errorMessage: "Error getting data: $e"));
    }
  }

  @override
  Future<Either<AppException, Unit>> deleteProject(String id) async {
    try {
      await _databaseReference.child("projects").child(id).remove();
      return const Right(unit);
    } on FirebaseException catch (e) {
      return Left(handleFirebaseDatabaseExceptionMessages(e));
    } catch (e) {
      printError('Error getting data: $e');
      return Left(AppException(errorMessage: "Error getting data: $e"));
    }
  }

  @override
  Future<Either<AppException, ProjectUsersResponse>> getProjectUsers(
      [List<String?>? usersIds]) async {
    try {
      final res = await _databaseReference.child("users").get();
      List<UserModel> users = List<UserModel>.from(
          res.children.map((e) => UserModel.fromJson(e.value)));
      List<UserModel> selectedUsers = [];
      if (usersIds != null) {
        for (var element in res.children) {
          UserModel um = UserModel.fromJson(element.value);
          if (usersIds.contains(um.id)) {
            selectedUsers.add(um);
          }
        }
      }
      return Right(
          ProjectUsersResponse(allUsers: users, selectedUsers: selectedUsers));
    } on FirebaseException catch (e) {
      return Left(handleFirebaseDatabaseExceptionMessages(e));
    } catch (e) {
      printError('Error getting data: $e');
      return Left(AppException(errorMessage: "Error getting data: $e"));
    }
  }
}
