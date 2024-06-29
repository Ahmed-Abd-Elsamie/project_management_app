class TaskModel {
  String? taskId;
  String? taskName;
  String? taskDescription;
  String? projectId;
  String? createdAt;
  String? deadLine;
  String? userId;
  String? assignedTo;
  String? state;

  TaskModel({
    this.taskId,
    this.taskName,
    this.taskDescription,
    this.projectId,
    this.createdAt,
    this.deadLine,
    this.userId,
    this.assignedTo,
    this.state,
  });

  factory TaskModel.fromJson(dynamic json) {
    return TaskModel(
      taskId: json['taskId'],
      taskName: json['taskName'],
      taskDescription: json['taskDescription'],
      projectId: json['projectId'],
      createdAt: json['createdAt'],
      deadLine: json['deadLine'],
      userId: json['userId'],
      assignedTo: json['assignedTo'],
      state: json['state'],
    );
  }

  Map<String, String> toJson() {
    return {
      "taskId": taskId!,
      "taskName": taskName!,
      "taskDescription": taskDescription!,
      "projectId": projectId!,
      "createdAt": createdAt!,
      "deadLine": deadLine!,
      "userId": userId!,
      "assignedTo": assignedTo!,
      "state": state!,
    };
  }
}
