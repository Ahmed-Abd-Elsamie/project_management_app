class ProjectModel {
  String? id;
  String? title;
  String? description;
  String? userId;
  List<String?>? projectUsers;

  ProjectModel({
    this.id,
    this.title,
    this.description,
    this.userId,
    this.projectUsers,
  });

  factory ProjectModel.fromJson(dynamic json) {
    return ProjectModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      userId: json['userId'],
      projectUsers: json['projectUsers'].toString().split(",").toList(),
    );
  }

  Map<String, String> toJson() {
    return {
      'id': id!,
      'title': title!,
      'description': description!,
      'userId': userId!,
      'projectUsers': projectUsers!.join(","),
    };
  }
}
