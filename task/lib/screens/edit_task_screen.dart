import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditTaskScreen extends StatefulWidget {
  final String taskId;
  final String currentTaskName;
  final String currentTaskDetails;
  final String currentPriority;

  const EditTaskScreen({
    required this.taskId,
    required this.currentTaskName,
    required this.currentTaskDetails,
    required this.currentPriority,
  });

  @override
  _EditTaskScreenState createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  late TextEditingController _taskNameController;
  late TextEditingController _taskDetailsController;
  late String _selectedPriority;

  @override
  void initState() {
    super.initState();
    _taskNameController = TextEditingController(text: widget.currentTaskName);
    _taskDetailsController = TextEditingController(text: widget.currentTaskDetails);
    _selectedPriority = widget.currentPriority;
  }

  @override
  void dispose() {
    _taskNameController.dispose();
    _taskDetailsController.dispose();
    super.dispose();
  }

  // Update task in Firestore
  Future<void> _updateTask() async {
    try {
      await FirebaseFirestore.instance.collection('tasks').doc(widget.taskId).update({
        'taskName': _taskNameController.text,
        'taskDetails': _taskDetailsController.text,
        'priority': _selectedPriority,
      });
      Navigator.pop(context); // Go back to previous screen after update
    } catch (e) {
      print("Error updating task: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _taskNameController,
              decoration: const InputDecoration(labelText: 'Task Name'),
            ),
            TextField(
              controller: _taskDetailsController,
              decoration: const InputDecoration(labelText: 'Task Details'),
            ),
            DropdownButton<String>(
              value: _selectedPriority,
              onChanged: (String? newPriority) {
                setState(() {
                  _selectedPriority = newPriority!;
                });
              },
              items: ['High', 'Medium', 'Low']
                  .map((priority) => DropdownMenuItem<String>(
                value: priority,
                child: Text(priority),
              ))
                  .toList(),
            ),
            ElevatedButton(
              onPressed: _updateTask,
              child: const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
