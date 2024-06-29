import 'package:flutter/material.dart';
import 'package:project_management_app/features/tasks/model/task_model.dart';
import 'package:project_management_app/services/local/auth_local_data_source.dart';

class TaskItem extends StatelessWidget {
  final TaskModel task;
  final VoidCallback? onPress;
  final VoidCallback? onEditPress;
  final VoidCallback? onDonePress;

  const TaskItem({
    super.key,
    required this.task,
    this.onPress,
    this.onEditPress,
    this.onDonePress,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
        shape: MaterialStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        backgroundColor: const MaterialStatePropertyAll(Colors.black12),
      ),
      onPressed: onPress,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              task.taskName ?? 'No Task Name',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              task.taskDescription ?? 'No Task Description',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 16),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Text(
                      'Created At: ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(task.createdAt ?? 'Unknown'),
                  ],
                ),
                Row(
                  children: [
                    const Text(
                      'Deadline: ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(task.deadLine ?? 'Unknown'),
                  ],
                )
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text("State : "),
                Text(
                  task.state == '0' ? 'Pending' : 'Completed',
                  style: TextStyle(
                      color: task.state == '0' ? Colors.orange : Colors.green),
                )
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                AuthLocalDataSource.getUserData()['id'] == task.userId
                    ? IconButton(
                        onPressed: onEditPress,
                        icon: const Icon(
                          Icons.edit,
                        ))
                    : const SizedBox(),
                task.state == "0"
                    ? IconButton(
                        onPressed: onDonePress,
                        icon: const Icon(
                          Icons.done_outline,
                        ))
                    : const SizedBox(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
