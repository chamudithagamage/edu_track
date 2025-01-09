import 'package:cloud_firestore/cloud_firestore.dart';

class ProgressTrackerController {
  // Function to calculate progress for a task name
  Future<Map<String, double>> calculateTaskProgress() async {
    // Query the Firestore collection for tasks
    QuerySnapshot tasksSnapshot = await FirebaseFirestore.instance.collection('tasks').get();
    var tasks = tasksSnapshot.docs;

    Map<String, int> taskCount = {};
    Map<String, int> taskCompletedCount = {};

    for (var taskDoc in tasks) {
      var task = taskDoc.data() as Map<String, dynamic>;
      String taskName = task['taskName'] ?? 'Unknown Task';
      bool isCompleted = task['completed'] ?? false;

      // Count total tasks and completed tasks per task name
      taskCount[taskName] = (taskCount[taskName] ?? 0) + 1;
      if (isCompleted) {
        taskCompletedCount[taskName] = (taskCompletedCount[taskName] ?? 0) + 1;
      }
    }

    // Calculate progress for each task name
    Map<String, double> taskProgress = {};
    taskCount.forEach((taskName, totalTasks) {
      int completedTasks = taskCompletedCount[taskName] ?? 0;
      double progress = (totalTasks > 0) ? (completedTasks / totalTasks) * 100 : 0;
      taskProgress[taskName] = progress;
    });

    return taskProgress;
  }
}
