import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/task.dart';

class TaskController {
  final CollectionReference _taskCollection =
      FirebaseFirestore.instance.collection('tasks');

  Future<void> addTask(Task task) async {
    try {
      await _taskCollection.add(task.toMap());
    } catch (e) {
      throw Exception('Error adding task: $e');
    }
  }
}
