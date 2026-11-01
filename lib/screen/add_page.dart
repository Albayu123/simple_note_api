import 'package:flutter/material.dart';
import '../service/todo_service.dart';
import '../theme/app_colors.dart';
import '../utils/snackbar_helper.dart';

class AddToDoPage extends StatefulWidget {
  final Map? todo;
  const AddToDoPage({super.key, this.todo});

  @override
  State<AddToDoPage> createState() => _AddToDoPageState();
}

class _AddToDoPageState extends State<AddToDoPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;

  bool _isEdit = false;
  bool _isCompleted = false;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    final todo = widget.todo;
    _isEdit = todo != null;
    _titleController = TextEditingController(text: todo?['title'] ?? '');
    _descriptionController =
        TextEditingController(text: todo?['description'] ?? '');
    _isCompleted = todo?['is_completed'] == true ||
        todo?['is_completed'] == 'true' ||
        todo?['completed'] == true;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEdit ? 'Edit Catatan' : 'Tambah Catatan Baru'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          tooltip: 'Kembali',
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Info header card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.primaryDark.withValues(alpha: 0.25)
                        : const Color(0xFFCCFBF1),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isDark
                          ? AppColors.primary.withValues(alpha: 0.3)
                          : const Color(0xFF99F6E4),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _isEdit
                            ? Icons.edit_note_rounded
                            : Icons.tips_and_updates_outlined,
                        color: isDark
                            ? AppColors.secondary
                            : AppColors.primary,
                        size: 26,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _isEdit
                            ? 'Perbarui detail catatan di bawah ini.'
                            : 'Tuliskan judul dan deskripsi catatan secara ringkas dan jelas.',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: isDark
                                ? AppColors.darkTextSecondary
                                : const Color(0xFF134E4A),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Title Input
                Text(
                  'Judul Catatan',
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _titleController,
                  textInputAction: TextInputAction.next,
                  maxLength: 100,
                  decoration: const InputDecoration(
                    hintText: 'Misal: Belajar Flutter UI/UX',
                    prefixIcon: Icon(Icons.title_rounded, size: 22),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Judul catatan tidak boleh kosong';
                    }
                    if (value.trim().length < 3) {
                      return 'Judul minimal 3 karakter';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Description Input
                Text(
                  'Deskripsi Catatan',
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _descriptionController,
                  keyboardType: TextInputType.multiline,
                  minLines: 4,
                  maxLines: 8,
                  maxLength: 500,
                  decoration: const InputDecoration(
                    hintText: 'Tuliskan detail catatan atau langkah-langkah di sini...',
                    alignLabelWithHint: true,
                    prefixIcon: Padding(
                      padding: EdgeInsets.only(bottom: 80),
                      child: Icon(Icons.notes_rounded, size: 22),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Status Switch
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.darkSurface
                        : AppColors.lightSurface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isDark
                          ? AppColors.darkBorder
                          : AppColors.lightBorder,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _isCompleted
                            ? Icons.check_circle_rounded
                            : Icons.pending_outlined,
                        color: _isCompleted
                            ? AppColors.success
                            : (isDark
                                ? AppColors.darkTextMuted
                                : AppColors.lightTextMuted),
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Status Selesai',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              _isCompleted
                                  ? 'Catatan ditandai telah selesai'
                                  : 'Catatan masih aktif/dalam proses',
                              style: TextStyle(
                                fontSize: 12,
                                color: isDark
                                    ? AppColors.darkTextMuted
                                    : AppColors.lightTextMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Switch(
                        value: _isCompleted,
                        activeThumbColor: AppColors.primary,
                        onChanged: (val) {
                          setState(() {
                            _isCompleted = val;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Submit Button
                ElevatedButton(
                  onPressed: _isSubmitting ? null : _saveData,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: AppColors.accent.withValues(alpha: 0.5),
                  ),
                  child: _isSubmitting
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: Colors.white,
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              _isEdit
                                  ? Icons.save_rounded
                                  : Icons.add_task_rounded,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              _isEdit ? 'Simpan Perubahan' : 'Tambah Catatan',
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _saveData() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isSubmitting = true);

    final title = _titleController.text.trim();
    final description = _descriptionController.text.trim();

    final body = {
      "title": title,
      "description": description,
      "is_completed": _isCompleted,
    };

    try {
      if (_isEdit) {
        final todo = widget.todo!;
        final id = (todo['_id'] ?? todo['id']).toString();
        final isSuccess = await ToDoService.updateToDo(id, body);
        if (!mounted) return;

        setState(() => _isSubmitting = false);
        if (isSuccess) {
          showSuccMessage(context, message: 'Catatan berhasil diperbarui');
          Navigator.pop(context, true);
        } else {
          showErrMessage(context, message: 'Gagal memperbarui catatan');
        }
      } else {
        final isSuccess = await ToDoService.addToDo(body);
        if (!mounted) return;

        setState(() => _isSubmitting = false);
        if (isSuccess) {
          showSuccMessage(context, message: 'Catatan berhasil ditambahkan');
          Navigator.pop(context, true);
        } else {
          showErrMessage(context, message: 'Gagal menambahkan catatan');
        }
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _isSubmitting = false);
      showErrMessage(context, message: 'Terjadi kesalahan: $e');
    }
  }
}
