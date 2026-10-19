import 'package:flutter/material.dart';
import '../../feature/models/diary_entry.dart';
import '../../feature/models/mood.dart';
import '../../feature/utils/date_utils.dart';

class DiaryController {
  DiaryController._();
  static final DiaryController instance = DiaryController._();

  final ValueNotifier<ThemeMode> themeModeNotifier = ValueNotifier<ThemeMode>(ThemeMode.light);

  final ValueNotifier<List<DiaryEntry>> entriesNotifier = ValueNotifier<List<DiaryEntry>>([]);

  void initSampleData() {
    if (entriesNotifier.value.isNotEmpty) return;

    final now = DateTime.now();
    entriesNotifier.value = [
      DiaryEntry(
        id: 'entry-1',
        title: 'Büyülü Bir Sabah',
        content: 'Bugün erken uyandım. Mor gökyüzü ve serin hava bana inanılmaz bir huzur verdi. Kahvemi içerken yeni planlarımı not aldım.',
        createdAt: now.subtract(const Duration(hours: 3)),
        updatedAt: now.subtract(const Duration(hours: 3)),
        mood: Mood.sakin,
      ),
      DiaryEntry(
        id: 'entry-2',
        title: 'Verimli Çalışma Günü',
        content: 'Tüm hedeflerimi bir bir tamamladım. Kendimi çok enerjik ve mutlu hissediyorum.',
        createdAt: now.subtract(const Duration(days: 1, hours: 2)),
        updatedAt: now.subtract(const Duration(days: 1, hours: 2)),
        mood: Mood.mutlu,
      ),
      DiaryEntry(
        id: 'entry-3',
        title: 'Sakin Akşam Yürüyüşü',
        content: 'Sahilde dalgaların sesini dinleyerek uzun bir yürüyüş yaptım. Zihnim dinlendi.',
        createdAt: now.subtract(const Duration(days: 2, hours: 5)),
        updatedAt: now.subtract(const Duration(days: 2, hours: 5)),
        mood: Mood.sakin,
      ),
      DiaryEntry(
        id: 'entry-4',
        title: 'Biraz Yoğun ve Stresli',
        content: 'Teslim tarihi yaklaşan projeler beni biraz zorladı ancak derin bir nefes alıp sırayla çözmeye başladım.',
        createdAt: now.subtract(const Duration(days: 4, hours: 1)),
        updatedAt: now.subtract(const Duration(days: 4, hours: 1)),
        mood: Mood.stresli,
      ),
      DiaryEntry(
        id: 'entry-5',
        title: 'Olağan Bir Gün',
        content: 'Günlük rutinlerimi tamamladım. Ekstra bir olay olmadı, sakin ve nötr bir gündü.',
        createdAt: now.subtract(const Duration(days: 6, hours: 4)),
        updatedAt: now.subtract(const Duration(days: 6, hours: 4)),
        mood: Mood.notr,
      ),
    ];
  }

  void toggleTheme(bool isDark) {
    themeModeNotifier.value = isDark ? ThemeMode.dark : ThemeMode.light;
  }

  void addEntry(DiaryEntry entry) {
    final currentList = List<DiaryEntry>.from(entriesNotifier.value);
    currentList.insert(0, entry);
    // Sıralama: Yakın tarihten uzak tarihe
    currentList.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    entriesNotifier.value = currentList;
  }

  void updateEntry(DiaryEntry updated) {
    final currentList = List<DiaryEntry>.from(entriesNotifier.value);
    final index = currentList.indexWhere((e) => e.id == updated.id);
    if (index != -1) {
      currentList[index] = updated;
      currentList.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      entriesNotifier.value = currentList;
    }
  }

  void deleteEntry(String id) {
    final currentList = List<DiaryEntry>.from(entriesNotifier.value);
    currentList.removeWhere((e) => e.id == id);
    entriesNotifier.value = currentList;
  }

  void resetAllEntries() {
    entriesNotifier.value = [];
  }

  List<DiaryEntry> searchAndFilter({
    String query = '',
    DateTime? selectedDate,
    Mood? moodFilter,
  }) {
    return entriesNotifier.value.where((entry) {
      // Tarih filtrelemesi
      if (selectedDate != null && !AppDateUtils.isSameDay(entry.createdAt, selectedDate)) {
        return false;
      }
      // Ruh hali filtrelemesi
      if (moodFilter != null && entry.mood != moodFilter) {
        return false;
      }
      // Arama metni filtrelemesi (Başlık, içerik veya tarih)
      if (query.trim().isNotEmpty) {
        final q = query.toLowerCase().trim();
        final matchTitle = entry.title.toLowerCase().contains(q);
        final matchContent = entry.content.toLowerCase().contains(q);
        final matchDate = AppDateUtils.formatDate(entry.createdAt).contains(q);
        return matchTitle || matchContent || matchDate;
      }
      return true;
    }).toList();
  }
}
