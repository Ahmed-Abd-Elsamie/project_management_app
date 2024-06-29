import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:project_management_app/core/helpers/app_exception_messages.dart';
import 'package:project_management_app/core/utils/app_exception.dart';
import 'package:project_management_app/core/utils/debug_prints.dart';
import 'package:project_management_app/features/auth/model/user_model.dart';
import 'package:project_management_app/features/tasks/model/task_model.dart';

abstract class TaskRepository {
  Future<Either<AppException, List<TaskModel>>> getAllTasks();

  Future<Either<AppException, List<TaskModel>>> getTasksByProjectId(String id);

  Future<Either<AppException, Unit>> createTask(TaskModel task);

  Future<Either<AppException, Unit>> updateTask(TaskModel task);

  Future<Either<AppException, Unit>> deleteTask(String id);

  Future<Either<AppException, List<UserModel>>> getTaskUsers();

  Future<Either<AppException, Unit>> markTaskDone(String taskId);
}

class TaskRepositoryImpl implements TaskRepository {
  final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Future<Either<AppException, Unit>> createTask(TaskModel task) async {
    try {
      String? id = _databaseReference.child("tasks").push().key;
      String userId = _auth.currentUser!.uid;
      task.taskId = id;
      task.userId = userId;
      task.createdAt = DateTime.now().toString();
      await _databaseReference.child("tasks").child(id!).set(task.toJson());
      return const Right(unit);
    } on FirebaseException catch (e) {
      return Left(handleFirebaseDatabaseExceptionMessages(e));
    } catch (e) {
      printError('Error getting data: $e');
      return Left(AppException(errorMessage: "Error getting data: $e"));
    }
  }

  @override
  Future<Either<AppException, Unit>> deleteTask(String id) async {
    try {
      await _databaseReference.child("tasks").child(id).remove();
      return const Right(unit);
    } on FirebaseException catch (e) {
      return Left(handleFirebaseDatabaseExceptionMessages(e));
    } catch (e) {
      printError('Error getting data: $e');
      return Left(AppException(errorMessage: "Error getting data: $e"));
    }
  }

  @override
  Future<Either<AppException, List<TaskModel>>> getAllTasks() async {
    try {
      final res = await _databaseReference
          .child("tasks")
          .orderByChild("userId")
          .equalTo(_auth.currentUser!.uid)
          .get();
      List<TaskModel> tasks = List<TaskModel>.from(
          res.children.map((e) => TaskModel.fromJson(e.value)));
      return Right(tasks);
    } on FirebaseException catch (e) {
      return Left(handleFirebaseDatabaseExceptionMessages(e));
    } catch (e) {
      printError('Error getting data: $e');
      return Left(AppException(errorMessage: "Error getting data: $e"));
    }
  }

  @override
  Future<Either<AppException, List<UserModel>>> getTaskUsers() async {
    try {
      final res = await _databaseReference.child("users").get();
      List<UserModel> users = List<UserModel>.from(
          res.children.map((e) => UserModel.fromJson(e.value)));
      return Right(users);
    } on FirebaseException catch (e) {
      return Left(handleFirebaseDatabaseExceptionMessages(e));
    } catch (e) {
      printError('Error getting data: $e');
      return Left(AppException(errorMessage: "Error getting data: $e"));
    }
  }

  @override
  Future<Either<AppException, Unit>> updateTask(TaskModel task) async {
    try {
      await _databaseReference
          .child("tasks")
          .child(task.taskId!)
          .update(task.toJson());
      return const Right(unit);
    } on FirebaseException catch (e) {
      return Left(handleFirebaseDatabaseExceptionMessages(e));
    } catch (e) {
      printError('Error getting data: $e');
      return Left(AppException(errorMessage: "Error getting data: $e"));
    }
  }

  @override
  Future<Either<AppException, List<TaskModel>>> getTasksByProjectId(
      String id) async {
    try {
      final res = await _databaseReference
          .child("tasks")
          .orderByChild("userId")
          .equalTo(_auth.currentUser!.uid)
          .get();
      List<TaskModel> tasks = List<TaskModel>.from(
              res.children.map((e) => TaskModel.fromJson(e.value)))
          .where((element) => element.projectId == id)
          .toList();
      return Right(tasks);
    } on FirebaseException catch (e) {
      return Left(handleFirebaseDatabaseExceptionMessages(e));
    } catch (e) {
      printError('Error getting data: $e');
      return Left(AppException(errorMessage: "Error getting data: $e"));
    }
  }

  @override
  Future<Either<AppException, Unit>> markTaskDone(String taskId) async {
    try {
      await _databaseReference
          .child("tasks")
          .child(taskId)
          .update({"state": "1"});
      return const Right(unit);
    } on FirebaseException catch (e) {
      return Left(handleFirebaseDatabaseExceptionMessages(e));
    } catch (e) {
      printError('Error getting data: $e');
      return Left(AppException(errorMessage: "Error getting data: $e"));
    }
  }
}
