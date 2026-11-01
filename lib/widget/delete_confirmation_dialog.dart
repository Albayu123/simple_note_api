import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

Future<bool> showDeleteConfirmationDialog(
  BuildContext context, {
  required String title,
}) async {
  final isDark = Theme.of(context).brightness == Brightness.dark;

  final result = await showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
        actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        icon: Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF451A1A) : AppColors.destructiveBg,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.delete_outline_rounded,
            color: AppColors.destructive,
            size: 28,
          ),
        ),
        title: const Text(
          'Hapus Catatan?',
          textAlign: TextAlign.center,
        ),
        content: Text(
          title.isNotEmpty
              ? 'Apakah kamu yakin ingin menghapus "$title"? Tindakan ini tidak dapat dibatalkan.'
              : 'Apakah kamu yakin ingin menghapus catatan ini? Tindakan ini tidak dapat dibatalkan.',
          textAlign: TextAlign.center,
        ),
        actions: [
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context, false),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                    side: BorderSide(
                      color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('Batal'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton(
                  onPressed: () => Navigator.pop(context, true),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.destructive,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('Hapus'),
                ),
              ),
            ],
          ),
        ],
      );
    },
  );

  return result ?? false;
}
