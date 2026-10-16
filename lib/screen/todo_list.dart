import 'package:flutter/material.dart';
import '../service/todo_service.dart';
import '../utils/snackbar_helper.dart';
import '../widget/todo_card.dart';
import 'add_page.dart';

class ToDoListPage extends StatefulWidget {
  const ToDoListPage({super.key});

  @override
  State<ToDoListPage> createState() => _ToDoListPageState();
}

class _ToDoListPageState extends State<ToDoListPage> {
  bool isLoading = true;
  List items = [];

  @override
  void initState() {
    super.initState();
    fetchTodo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
      ),
      body: Visibility(
        visible: isLoading,
        replacement: RefreshIndicator(
          onRefresh: fetchTodo,
          child: Visibility(
            visible: items.isNotEmpty,
            replacement: Center(
              child: Text(
                'No ToDo Item',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
            child: ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index] as Map;
                return ToDoCard(
                  index: index,
                  item: item,
                  navigateEdit: navigateToEditPage,
                  deleteById: deleteById,
                );
              },
            ),
          ),
        ),
        child: const Center(child: CircularProgressIndicator()),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: navigateToAddPage,
        label: const Text('Add Todo'),
      ),
    );
  }

  Future<void> fetchTodo() async {
    setState(() => isLoading = true);
    try {
      final response = await ToDoService.fetchToDo();
      if (!mounted) return;

      if (response != null) {
        setState(() {
          items = response;
          isLoading = false;
        });
      } else {
        showErrMessage(context, message: 'Gagal mengambil data / Server tidak merespon');
        setState(() => isLoading = false);
      }
    } catch (e) {
      if (!mounted) return;
      showErrMessage(context, message: 'Terjadi kesalahan: $e');
      setState(() => isLoading = false);
    }
  }

  Future<void> navigateToAddPage() async {
    final route = MaterialPageRoute(builder: (context) => const AddToDoPage());
    await Navigator.push(context, route);
    setState(() => isLoading = true);
    fetchTodo();
  }

  Future<void> navigateToEditPage(Map item) async {
    final route = MaterialPageRoute(builder: (context) => AddToDoPage(todo: item));
    await Navigator.push(context, route);
    setState(() => isLoading = true);
    fetchTodo();
  }

  Future<void> deleteById(String id) async {
    final isSuccess = await ToDoService.deleteById(id);
    if (!mounted) return;

    if (isSuccess) {
      final filtered = items.where((element) => (element['_id'] ?? element['id']).toString() != id).toList();
      setState(() => items = filtered);
    } else {
      showErrMessage(context, message: 'Deletion Failed');
    }
  }
}