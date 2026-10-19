import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../models/diary_entry.dart';
import '../models/mood.dart';
import '../utils/date_utils.dart';

class MonthlyCalendarWidget extends StatelessWidget {
  final DateTime currentMonth;
  final DateTime? selectedDate;
  final List<DiaryEntry> entries;
  final ValueChanged<DateTime> onMonthChanged;
  final ValueChanged<DateTime?> onDateSelected;

  const MonthlyCalendarWidget({
    super.key,
    required this.currentMonth,
    required this.selectedDate,
    required this.entries,
    required this.onMonthChanged,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Column(
          children: [
            _buildHeader(context),
            const SizedBox(height: 8),
            _buildWeekdayLabels(),
            const SizedBox(height: 6),
            _buildDaysGrid(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left_rounded, size: 22),
          onPressed: () {
            onMonthChanged(DateTime(currentMonth.year, currentMonth.month - 1));
          },
        ),
        Text(
          AppDateUtils.formatMonthYear(currentMonth),
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
        ),
        IconButton(
          icon: const Icon(Icons.chevron_right_rounded, size: 22),
          onPressed: () {
            onMonthChanged(DateTime(currentMonth.year, currentMonth.month + 1));
          },
        ),
      ],
    );
  }

  Widget _buildWeekdayLabels() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: List.generate(7, (index) {
        return SizedBox(
          width: 32,
          child: Text(
            AppDateUtils.getWeekdayShort(index + 1),
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.lightTextSecondary,
            ),
          ),
        );
      }),
    );
  }

  Widget _buildDaysGrid(BuildContext context) {
    final firstDayOfMonth = DateTime(currentMonth.year, currentMonth.month, 1);
    final daysInMonth = DateTime(currentMonth.year, currentMonth.month + 1, 0).day;
    final startingWeekday = firstDayOfMonth.weekday; // 1 = Pazartesi ... 7 = Pazar
    final totalCells = ((startingWeekday - 1) + daysInMonth <= 35) ? 35 : 42;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: totalCells,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        childAspectRatio: 1.1,
      ),
      itemBuilder: (context, index) {
        final dayNumber = index - (startingWeekday - 2);
        if (dayNumber < 1 || dayNumber > daysInMonth) {
          return const SizedBox.shrink();
        }

        final cellDate = DateTime(currentMonth.year, currentMonth.month, dayNumber);
        final isSelected = selectedDate != null && AppDateUtils.isSameDay(selectedDate!, cellDate);
        final dayMood = _findMoodForDate(cellDate);

        return _buildDayCell(cellDate, dayNumber, isSelected, dayMood);
      },
    );
  }

  Widget _buildDayCell(DateTime cellDate, int dayNumber, bool isSelected, Mood? dayMood) {
    final hasMood = dayMood != null;

    return InkWell(
      onTap: () {
        if (selectedDate != null && AppDateUtils.isSameDay(selectedDate!, cellDate)) {
          onDateSelected(null); // Seçimi kaldır
        } else {
          onDateSelected(cellDate);
        }
      },
      borderRadius: BorderRadius.circular(10),
      child: Container(
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryPurple.withValues(alpha: 0.25)
              : (hasMood ? dayMood.color.withValues(alpha: 0.15) : Colors.transparent),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected
                ? AppColors.primaryPurple
                : (hasMood ? dayMood.color.withValues(alpha: 0.5) : Colors.transparent),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$dayNumber',
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected || hasMood ? FontWeight.w700 : FontWeight.normal,
              ),
            ),
            if (hasMood)
              Container(
                margin: const EdgeInsets.only(top: 2),
                width: 5,
                height: 5,
                decoration: BoxDecoration(
                  color: dayMood.color,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Mood? _findMoodForDate(DateTime date) {
    for (final entry in entries) {
      if (AppDateUtils.isSameDay(entry.createdAt, date) && entry.mood != null) {
        return entry.mood;
      }
    }
    return null;
  }
}
