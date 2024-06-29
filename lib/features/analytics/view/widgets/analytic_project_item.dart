import 'package:flutter/material.dart';
import 'package:project_management_app/features/projects/model/project_model.dart';

class AnalyticProjectItem extends StatelessWidget {
  final ProjectModel projectModel;
  final VoidCallback? onPress;

  const AnalyticProjectItem({
    super.key,
    required this.projectModel,
    required this.onPress,
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
          ],
        ),
      ),
    );
  }
}
