import 'package:flutter/material.dart';
import '../../core/storage/diary_controller.dart';
import '../../core/theme/app_colors.dart';
import '../models/diary_entry.dart';
import '../models/mood.dart';
import '../widgets/mood_pie_chart.dart';
import 'home_screen.dart';

class MoodReportScreen extends StatefulWidget {
  const MoodReportScreen({super.key});

  @override
  State<MoodReportScreen> createState() => _MoodReportScreenState();
}

class _MoodReportScreenState extends State<MoodReportScreen> {
  Mood? _selectedMood;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ruh Hali Raporu'),
      ),
      body: ValueListenableBuilder<List<DiaryEntry>>(
        valueListenable: DiaryController.instance.entriesNotifier,
        builder: (context, entries, _) {
          final slices = _calculateMoodSlices(entries);
          final stats = _calculateMoodStats(slices);

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                MoodPieChart(
                  slices: slices,
                  selectedMood: _selectedMood,
                  onSliceSelected: (mood) {
                    setState(() => _selectedMood = mood);
                    _navigateToFilteredHome(context, mood);
                  },
                ),
                const SizedBox(height: 16),
                _buildStatsSection(stats),
                const SizedBox(height: 16),
                _buildRecommendations(stats.mostFrequent),
              ],
            ),
          );
        },
      ),
    );
  }

  void _navigateToFilteredHome(BuildContext context, Mood mood) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => HomeScreen(initialMoodFilter: mood),
      ),
    );
  }

  Widget _buildStatsSection(_MoodStats stats) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            title: 'En Çok Hissedilen',
            mood: stats.mostFrequent,
            emptyText: 'Veri yok',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            title: 'En Az Hissedilen',
            mood: stats.leastFrequent,
            emptyText: 'Veri yok',
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String title,
    required Mood? mood,
    required String emptyText,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 11, color: AppColors.lightTextSecondary),
            ),
            const SizedBox(height: 6),
            if (mood != null)
              Row(
                children: [
                  Icon(mood.icon, color: mood.color, size: 20),
                  const SizedBox(width: 6),
                  Text(
                    mood.label,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: mood.color,
                    ),
                  ),
                ],
              )
            else
              Text(
                emptyText,
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendations(Mood? dominantMood) {
    final recommendation = _getRecommendationText(dominantMood);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.auto_awesome_rounded, color: AppColors.goldAccent, size: 18),
                SizedBox(width: 8),
                Text(
                  'Ruh Halini İyileştirme Önerileri',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              recommendation,
              style: const TextStyle(fontSize: 13, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }

  String _getRecommendationText(Mood? mood) {
    switch (mood) {
      case Mood.mutlu:
        return 'Harika bir dönemdesin! Bu enerjini sevdiklerinle paylaş ve seni mutlu eden anların detaylarını günlüğüne yazarak ölümsüzleştir.';
      case Mood.sakin:
        return 'İç huzurun dengeli görünüyor. Sakinliğini korumak için doğa yürüyüşlerine ve kitap okuma alışkanlığına devam edebilirsin.';
      case Mood.stresli:
        return 'Son zamanlarda biraz stresli hissetmişsin. Gün içinde 10 dakikalık derin nefes egzersizleri yapmayı ve kendine mola vermeyi unutma.';
      case Mood.uzgun:
        return 'Bazen hüzün hissetmek çok doğaldır. Duygularını bastırmadan günlüğe dökmek ve sevdiğin bir müzik eşliğinde dinlenmek sana iyi gelecektir.';
      case Mood.notr:
      default:
        return 'Rutin bir akıştasın. Yeni bir hobi edinmek ya da günlük rutinine küçük bir yürüyüş eklemek gününe farklı bir renk katabilir.';
    }
  }

  List<MoodSliceData> _calculateMoodSlices(List<DiaryEntry> entries) {
    final moodEntries = entries.where((e) => e.mood != null).toList();
    if (moodEntries.isEmpty) return [];

    final counts = <Mood, int>{};
    for (final entry in moodEntries) {
      final m = entry.mood!;
      counts[m] = (counts[m] ?? 0) + 1;
    }

    final total = moodEntries.length;
    return counts.entries.map((item) {
      final percent = (item.value / total) * 100;
      return MoodSliceData(
        mood: item.key,
        count: item.value,
        percentage: percent,
      );
    }).toList();
  }

  _MoodStats _calculateMoodStats(List<MoodSliceData> slices) {
    if (slices.isEmpty) return _MoodStats(mostFrequent: null, leastFrequent: null);

    slices.sort((a, b) => b.count.compareTo(a.count));
    final most = slices.first.mood;
    final least = slices.last.mood;
    return _MoodStats(mostFrequent: most, leastFrequent: least);
  }
}

class _MoodStats {
  final Mood? mostFrequent;
  final Mood? leastFrequent;

  _MoodStats({required this.mostFrequent, required this.leastFrequent});
}
