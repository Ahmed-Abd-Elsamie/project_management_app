import 'package:flutter/material.dart';
import 'package:project_management_app/features/projects/model/project_model.dart';
import 'package:project_management_app/services/local/auth_local_data_source.dart';

class ProjectItem extends StatelessWidget {
  final ProjectModel projectModel;
  final VoidCallback? onPress;
  final VoidCallback? onEditPress;

  const ProjectItem({
    super.key,
    required this.projectModel,
    required this.onPress,
    required this.onEditPress,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
          shape: MaterialStatePropertyAll(RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          )),
          backgroundColor: const MaterialStatePropertyAll(Colors.black12)),
      onPressed: onPress,
      child: Padding(
        padding: const EdgeInsets.only(top: 10, left: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              width: double.maxFinite,
            ),
            Text(
              projectModel.title!,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              projectModel.description!,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 8),
            AuthLocalDataSource.getUserData()['id'] == projectModel.userId
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                          onPressed: onEditPress, icon: const Icon(Icons.edit))
                    ],
                  )
                : const SizedBox()
          ],
        ),
      ),
    );
  }
}
