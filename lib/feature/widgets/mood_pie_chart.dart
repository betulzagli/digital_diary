import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../models/mood.dart';

class MoodSliceData {
  final Mood mood;
  final int count;
  final double percentage;

  const MoodSliceData({
    required this.mood,
    required this.count,
    required this.percentage,
  });
}

class MoodPieChart extends StatelessWidget {
  final List<MoodSliceData> slices;
  final Mood? selectedMood;
  final ValueChanged<Mood> onSliceSelected;

  const MoodPieChart({
    super.key,
    required this.slices,
    required this.selectedMood,
    required this.onSliceSelected,
  });

  @override
  Widget build(BuildContext context) {
    if (slices.isEmpty) {
      return const SizedBox(
        height: 220,
        child: Center(
          child: Text(
            'Henüz analiz edilecek veri bulunmuyor.',
            style: TextStyle(fontSize: 13),
          ),
        ),
      );
    }

    return Column(
      children: [
        SizedBox(
          height: 200,
          width: 200,
          child: GestureDetector(
            onTapUp: (details) => _handleTap(details, const Size(200, 200)),
            child: CustomPaint(
              painter: _PieChartPainter(
                slices: slices,
                selectedMood: selectedMood,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        _buildLegend(),
      ],
    );
  }

  void _handleTap(TapUpDetails details, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final touchPosition = details.localPosition;
    final dx = touchPosition.dx - center.dx;
    final dy = touchPosition.dy - center.dy;
    final distance = math.sqrt(dx * dx + dy * dy);

    if (distance > size.width / 2) return;

    var touchAngle = math.atan2(dy, dx);
    if (touchAngle < -math.pi / 2) {
      touchAngle += 2 * math.pi;
    }
    touchAngle += math.pi / 2;
    if (touchAngle >= 2 * math.pi) {
      touchAngle -= 2 * math.pi;
    }

    double currentAngle = 0;
    for (final slice in slices) {
      final sweepAngle = (slice.percentage / 100) * 2 * math.pi;
      if (touchAngle >= currentAngle && touchAngle <= currentAngle + sweepAngle) {
        onSliceSelected(slice.mood);
        break;
      }
      currentAngle += sweepAngle;
    }
  }

  Widget _buildLegend() {
    return Wrap(
      spacing: 12,
      runSpacing: 8,
      alignment: WrapAlignment.center,
      children: slices.map((slice) {
        final isSelected = slice.mood == selectedMood;
        return InkWell(
          onTap: () => onSliceSelected(slice.mood),
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: isSelected ? slice.mood.color.withValues(alpha: 0.2) : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isSelected ? slice.mood.color : Colors.transparent,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: slice.mood.color,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  '${slice.mood.label} (%${slice.percentage.toStringAsFixed(1)})',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _PieChartPainter extends CustomPainter {
  final List<MoodSliceData> slices;
  final Mood? selectedMood;

  _PieChartPainter({
    required this.slices,
    required this.selectedMood,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    double startAngle = -math.pi / 2;

    for (final slice in slices) {
      final sweepAngle = (slice.percentage / 100) * 2 * math.pi;
      final isSelected = slice.mood == selectedMood;

      final paint = Paint()
        ..color = isSelected ? slice.mood.color : slice.mood.color.withValues(alpha: 0.85)
        ..style = PaintingStyle.fill;

      if (isSelected) {
        canvas.save();
        final midAngle = startAngle + sweepAngle / 2;
        final offset = Offset(math.cos(midAngle) * 6, math.sin(midAngle) * 6);
        canvas.translate(offset.dx, offset.dy);
        canvas.drawArc(rect, startAngle, sweepAngle, true, paint);
        canvas.restore();
      } else {
        canvas.drawArc(rect, startAngle, sweepAngle, true, paint);
      }

      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant _PieChartPainter oldDelegate) {
    return oldDelegate.slices != slices || oldDelegate.selectedMood != selectedMood;
  }
}
