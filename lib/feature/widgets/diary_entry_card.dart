import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../models/diary_entry.dart';
import '../utils/date_utils.dart';

class DiaryEntryCard extends StatelessWidget {
  final DiaryEntry entry;
  final VoidCallback onTap;

  const DiaryEntryCard({
    super.key,
    required this.entry,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final moodColor = entry.mood?.color ?? AppColors.primaryPurpleLight;
    final isEdited = entry.updatedAt.isAfter(entry.createdAt.add(const Duration(minutes: 1)));

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildMoodIndicator(moodColor),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTitle(theme),
                    const SizedBox(height: 4),
                    _buildContentPreview(theme),
                    const SizedBox(height: 8),
                    _buildDates(theme, isEdited),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.primaryPurpleLight,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMoodIndicator(Color moodColor) {
    return Container(
      width: 14,
      height: 14,
      margin: const EdgeInsets.only(top: 4),
      decoration: BoxDecoration(
        color: moodColor,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: moodColor.withValues(alpha: 0.4),
            blurRadius: 6,
            spreadRadius: 1,
          ),
        ],
      ),
    );
  }

  Widget _buildTitle(ThemeData theme) {
    return Text(
      entry.title,
      style: theme.textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.w600,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildContentPreview(ThemeData theme) {
    return Text(
      entry.content,
      style: theme.textTheme.bodySmall?.copyWith(
        color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.8),
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildDates(ThemeData theme, bool isEdited) {
    final createdText = AppDateUtils.formatDate(entry.createdAt);
    final updatedText = AppDateUtils.formatDate(entry.updatedAt);

    return Wrap(
      spacing: 8,
      children: [
        Text(
          'Oluşturulma: $createdText',
          style: theme.textTheme.labelSmall?.copyWith(
            color: AppColors.lightTextSecondary,
          ),
        ),
        if (isEdited)
          Text(
            '• Düzenlendi: $updatedText',
            style: theme.textTheme.labelSmall?.copyWith(
              color: AppColors.goldAccent,
              fontWeight: FontWeight.w500,
            ),
          ),
      ],
    );
  }
}
