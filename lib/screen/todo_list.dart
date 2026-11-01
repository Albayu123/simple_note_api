import 'package:flutter/material.dart';
import '../service/todo_service.dart';
import '../theme/app_colors.dart';
import '../theme/theme_controller.dart';
import '../utils/snackbar_helper.dart';
import '../widget/empty_state.dart';
import '../widget/skeleton_loader.dart';
import '../widget/todo_card.dart';
import 'add_page.dart';

enum TodoFilter { all, active, completed }

class ToDoListPage extends StatefulWidget {
  const ToDoListPage({super.key});

  @override
  State<ToDoListPage> createState() => _ToDoListPageState();
}

class _ToDoListPageState extends State<ToDoListPage> {
  bool isLoading = true;
  List items = [];
  TodoFilter currentFilter = TodoFilter.all;
  String searchQuery = '';
  bool isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchTodo();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List get filteredItems {
    return items.where((item) {
      final title = (item['title'] ?? '').toString().toLowerCase();
      final desc = (item['description'] ?? '').toString().toLowerCase();
      final isCompleted = item['is_completed'] == true ||
          item['is_completed'] == 'true' ||
          item['completed'] == true;

      // Filter by status
      if (currentFilter == TodoFilter.active && isCompleted) return false;
      if (currentFilter == TodoFilter.completed && !isCompleted) return false;

      // Filter by query
      if (searchQuery.isNotEmpty) {
        final query = searchQuery.toLowerCase();
        return title.contains(query) || desc.contains(query);
      }

      return true;
    }).toList();
  }

  int get totalCount => items.length;
  int get completedCount => items.where((item) {
        return item['is_completed'] == true ||
            item['is_completed'] == 'true' ||
            item['completed'] == true;
      }).length;
  int get activeCount => totalCount - completedCount;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final displayItems = filteredItems;

    return Scaffold(
      appBar: AppBar(
        title: isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Cari catatan...',
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.close_rounded),
                    tooltip: 'Hapus pencarian',
                    onPressed: () {
                      if (_searchController.text.isNotEmpty) {
                        _searchController.clear();
                        setState(() => searchQuery = '');
                      } else {
                        setState(() {
                          isSearching = false;
                          searchQuery = '';
                        });
                      }
                    },
                  ),
                ),
                onChanged: (val) {
                  setState(() => searchQuery = val);
                },
              )
            : Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.primary.withValues(alpha: 0.2)
                          : const Color(0xFFCCFBF1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.note_alt_rounded,
                      color: isDark ? AppColors.secondary : AppColors.primary,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text('Simple Note'),
                ],
              ),
        actions: [
          if (!isSearching)
            IconButton(
              icon: const Icon(Icons.search_rounded),
              tooltip: 'Cari catatan',
              onPressed: () {
                setState(() => isSearching = true);
              },
            ),
          IconButton(
            icon: Icon(
              isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
            ),
            tooltip: isDark ? 'Beralih ke mode terang' : 'Beralih ke mode gelap',
            onPressed: () {
              ThemeController.instance.toggleTheme(context);
            },
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: Column(
        children: [
          // Filter Chips Row
          if (!isLoading && items.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildFilterChip(
                      label: 'Semua ($totalCount)',
                      filter: TodoFilter.all,
                      isSelected: currentFilter == TodoFilter.all,
                    ),
                    const SizedBox(width: 8),
                    _buildFilterChip(
                      label: 'Aktif ($activeCount)',
                      filter: TodoFilter.active,
                      isSelected: currentFilter == TodoFilter.active,
                    ),
                    const SizedBox(width: 8),
                    _buildFilterChip(
                      label: 'Selesai ($completedCount)',
                      filter: TodoFilter.completed,
                      isSelected: currentFilter == TodoFilter.completed,
                    ),
                  ],
                ),
              ),
            ),

          // Main Content
          Expanded(
            child: isLoading
                ? const SkeletonLoader(itemCount: 6)
                : RefreshIndicator(
                    color: AppColors.primary,
                    onRefresh: fetchTodo,
                    child: items.isEmpty
                        ? EmptyStateWidget(
                            title: 'Belum Ada Catatan',
                            message:
                                'Mulai buat catatan atau tugas baru untuk mengatur harimu lebih produktif.',
                            buttonText: 'Buat Catatan Pertama',
                            onButtonPressed: navigateToAddPage,
                          )
                        : displayItems.isEmpty
                            ? EmptyStateWidget(
                                icon: Icons.search_off_rounded,
                                title: 'Catatan Tidak Ditemukan',
                                message:
                                    'Tidak ada catatan yang sesuai dengan filter atau kata kunci saat ini.',
                                buttonText: 'Reset Filter',
                                onButtonPressed: () {
                                  setState(() {
                                    searchQuery = '';
                                    _searchController.clear();
                                    currentFilter = TodoFilter.all;
                                  });
                                },
                              )
                            : ListView.separated(
                                padding: const EdgeInsets.fromLTRB(16, 8, 16, 80),
                                itemCount: displayItems.length,
                                separatorBuilder: (context, index) =>
                                    const SizedBox(height: 12),
                                itemBuilder: (context, index) {
                                  final item = displayItems[index] as Map;
                                  return ToDoCard(
                                    key: ValueKey(
                                      item['_id'] ?? item['id'] ?? index,
                                    ),
                                    index: index,
                                    item: item,
                                    navigateEdit: navigateToEditPage,
                                    deleteById: deleteById,
                                    onToggleStatus: handleToggleStatus,
                                  );
                                },
                              ),
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: navigateToAddPage,
        icon: const Icon(Icons.add_rounded),
        label: const Text(
          'Catat Baru',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required TodoFilter filter,
    required bool isSelected,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          setState(() => currentFilter = filter);
        }
      },
      selectedColor: isDark
          ? AppColors.primaryDark.withValues(alpha: 0.6)
          : const Color(0xFFCCFBF1),
      labelStyle: TextStyle(
        fontSize: 13,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
        color: isSelected
            ? (isDark ? AppColors.secondary : AppColors.primary)
            : (isDark
                ? AppColors.darkTextSecondary
                : AppColors.lightTextSecondary),
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
        showErrMessage(
          context,
          message: 'Gagal mengambil data / Server tidak merespon',
        );
        setState(() => isLoading = false);
      }
    } catch (e) {
      if (!mounted) return;
      showErrMessage(context, message: 'Terjadi kesalahan: $e');
      setState(() => isLoading = false);
    }
  }

  Future<void> handleToggleStatus(String id, bool isCompleted) async {
    // Optimistic UI Update
    final index = items.indexWhere(
      (element) => (element['_id'] ?? element['id']).toString() == id,
    );
    if (index == -1) return;

    final originalItem = items[index];
    final updatedItem = Map<String, dynamic>.from(originalItem);
    updatedItem['is_completed'] = isCompleted;

    setState(() {
      items[index] = updatedItem;
    });

    final isSuccess = await ToDoService.toggleStatus(id, originalItem, isCompleted);
    if (!mounted) return;

    if (!isSuccess) {
      // Revert if API failed
      setState(() {
        items[index] = originalItem;
      });
      showErrMessage(context, message: 'Gagal mengubah status catatan');
    } else {
      showSuccMessage(
        context,
        message: isCompleted
            ? 'Catatan ditandai selesai'
            : 'Catatan dikembalikan ke aktif',
      );
    }
  }

  Future<void> navigateToAddPage() async {
    final route = MaterialPageRoute(builder: (context) => const AddToDoPage());
    final result = await Navigator.push(context, route);
    if (result == true) {
      fetchTodo();
    }
  }

  Future<void> navigateToEditPage(Map item) async {
    final route = MaterialPageRoute(
      builder: (context) => AddToDoPage(todo: item),
    );
    final result = await Navigator.push(context, route);
    if (result == true) {
      fetchTodo();
    }
  }

  Future<void> deleteById(String id) async {
    // Optimistic UI removal
    final itemIndex = items.indexWhere(
      (element) => (element['_id'] ?? element['id']).toString() == id,
    );
    if (itemIndex == -1) return;

    final removedItem = items[itemIndex];
    setState(() {
      items.removeAt(itemIndex);
    });

    final isSuccess = await ToDoService.deleteById(id);
    if (!mounted) return;

    if (isSuccess) {
      showSuccMessage(context, message: 'Catatan berhasil dihapus');
    } else {
      // Revert
      setState(() {
        items.insert(itemIndex, removedItem);
      });
      showErrMessage(context, message: 'Gagal menghapus catatan');
    }
  }
}
