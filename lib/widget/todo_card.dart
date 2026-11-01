import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'delete_confirmation_dialog.dart';

class ToDoCard extends StatelessWidget {
  final int index;
  final Map item;
  final Function(Map) navigateEdit;
  final Function(String) deleteById;
  final Function(String, bool)? onToggleStatus;

  const ToDoCard({
    super.key,
    required this.index,
    required this.item,
    required this.navigateEdit,
    required this.deleteById,
    this.onToggleStatus,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final id = (item['_id'] ?? item['id'] ?? '').toString();
    final title = (item['title'] ?? '').toString().trim();
    final description = (item['description'] ?? '').toString().trim();
    final isCompleted = item['is_completed'] == true ||
        item['is_completed'] == 'true' ||
        item['completed'] == true;

    final textColor = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final secondaryTextColor = isDark
        ? AppColors.darkTextSecondary
        : AppColors.lightTextSecondary;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => navigateEdit(item),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Checkbox toggle button
                  Semantics(
                    label: isCompleted
                        ? 'Tandai belum selesai'
                        : 'Tandai selesai',
                    button: true,
                    child: IconButton(
                      iconSize: 24,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 44,
                        minHeight: 44,
                      ),
                      tooltip: isCompleted
                          ? 'Tandai belum selesai'
                          : 'Tandai selesai',
                      icon: Icon(
                        isCompleted
                            ? Icons.check_circle_rounded
                            : Icons.radio_button_unchecked_rounded,
                        color: isCompleted
                            ? (isDark ? AppColors.secondary : AppColors.primary)
                            : (isDark
                                ? AppColors.darkTextMuted
                                : AppColors.lightTextMuted),
                      ),
                      onPressed: onToggleStatus != null && id.isNotEmpty
                          ? () => onToggleStatus!(id, !isCompleted)
                          : null,
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Title and description
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title.isNotEmpty ? title : 'Tanpa Judul',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: isCompleted
                                ? (isDark
                                    ? AppColors.darkTextMuted
                                    : AppColors.lightTextMuted)
                                : textColor,
                            decoration: isCompleted
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                            decorationColor: isDark
                                ? AppColors.darkTextMuted
                                : AppColors.lightTextMuted,
                          ),
                        ),
                        if (description.isNotEmpty) ...[
                          const SizedBox(height: 6),
                          Text(
                            description,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: isCompleted
                                  ? (isDark
                                      ? AppColors.darkTextMuted
                                      : AppColors.lightTextMuted)
                                  : secondaryTextColor,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),

                  // Popup / action buttons
                  PopupMenuButton<String>(
                    tooltip: 'Pilihan opsi',
                    icon: Icon(
                      Icons.more_vert_rounded,
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    onSelected: (value) async {
                      if (value == 'edit') {
                        navigateEdit(item);
                      } else if (value == 'delete') {
                        final confirmed = await showDeleteConfirmationDialog(
                          context,
                          title: title,
                        );
                        if (confirmed) {
                          deleteById(id);
                        }
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit_outlined, size: 20),
                            SizedBox(width: 12),
                            Text('Edit'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(
                              Icons.delete_outline_rounded,
                              size: 20,
                              color: AppColors.destructive,
                            ),
                            SizedBox(width: 12),
                            Text(
                              'Hapus',
                              style: TextStyle(color: AppColors.destructive),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Badges footer
              Row(
                children: [
                  // Index badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.darkSurfaceVariant
                          : AppColors.lightSurfaceVariant,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '#${index + 1}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Status badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: isCompleted
                          ? (isDark
                              ? const Color(0xFF064E3B)
                              : AppColors.successBg)
                          : (isDark
                              ? const Color(0xFF422006)
                              : const Color(0xFFFEF3C7)),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      isCompleted ? 'Selesai' : 'Aktif',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: isCompleted
                            ? (isDark
                                ? const Color(0xFF6EE7B7)
                                : AppColors.success)
                            : (isDark
                                ? const Color(0xFFFCD34D)
                                : AppColors.warning),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
