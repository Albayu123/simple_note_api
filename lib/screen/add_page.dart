import 'package:flutter/material.dart';
import '../service/todo_service.dart';
import '../utils/snackbar_helper.dart';

class AddToDoPage extends StatefulWidget {
  final Map? todo;
  const AddToDoPage({super.key, this.todo});

  @override
  State<AddToDoPage> createState() => _AddToDoPageState();
}

class _AddToDoPageState extends State<AddToDoPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  bool isEdit = false;

  @override
  void initState() {
    super.initState();
    final todo = widget.todo;
    if (todo != null) {
      isEdit = true;
      titleController.text = todo['title'] ?? '';
      descriptionController.text = todo['description'] ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit ToDo' : 'Add ToDo'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextField(
            controller: titleController,
            decoration: const InputDecoration(hintText: 'Title'),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: descriptionController,
            decoration: const InputDecoration(hintText: 'Description'),
            keyboardType: TextInputType.multiline,
            minLines: 5,
            maxLines: 8,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: isEdit ? updateData : submitData,
            child: Text(isEdit ? 'Update' : 'Submit'),
          )
        ],
      ),
    );
  }

  Future<void> submitData() async {
    final title = titleController.text;
    final description = descriptionController.text;
    final body = {
      "title": title,
      "description": description,
      "is_completed": false,
    };

    final isSuccess = await ToDoService.addToDo(body);
    if (!mounted) return;

    if (isSuccess) {
      titleController.text = '';
      descriptionController.text = '';
      showSuccMessage(context, message: 'Creation Success');
    } else {
      showErrMessage(context, message: 'Creation Failed');
    }
  }

  Future<void> updateData() async {
    final todo = widget.todo;
    if (todo == null) return;

    final id = (todo['_id'] ?? todo['id']).toString();
    final title = titleController.text;
    final description = descriptionController.text;
    final body = {
      "title": title,
      "description": description,
      "is_completed": false,
    };

    final isSuccess = await ToDoService.updateToDo(id, body);
    if (!mounted) return;

    if (isSuccess) {
      showSuccMessage(context, message: 'Update Success');
    } else {
      showErrMessage(context, message: 'Update Failed');
    }
  }
}