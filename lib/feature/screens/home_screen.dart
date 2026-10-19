import 'package:flutter/material.dart';
import '../../core/storage/diary_controller.dart';
import '../models/diary_entry.dart';
import '../models/mood.dart';
import '../widgets/app_logo_widget.dart';
import '../widgets/diary_entry_card.dart';
import '../widgets/monthly_calendar_widget.dart';
import '../widgets/search_bar_widget.dart';
import 'entry_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  final Mood? initialMoodFilter;

  const HomeScreen({
    super.key,
    this.initialMoodFilter,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  DateTime _currentMonth = DateTime.now();
  DateTime? _selectedDate;
  Mood? _moodFilter;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _moodFilter = widget.initialMoodFilter;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppLogoWidget(size: 32, borderRadius: 8),
            SizedBox(width: 10),
            Text('Deary'),
          ],
        ),
      ),
      body: ValueListenableBuilder<List<DiaryEntry>>(
        valueListenable: DiaryController.instance.entriesNotifier,
        builder: (context, allEntries, _) {
          final filteredEntries = DiaryController.instance.searchAndFilter(
            query: _searchQuery,
            selectedDate: _selectedDate,
            moodFilter: _moodFilter,
          );

          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: MonthlyCalendarWidget(
                  currentMonth: _currentMonth,
                  selectedDate: _selectedDate,
                  entries: allEntries,
                  onMonthChanged: (m) => setState(() => _currentMonth = m),
                  onDateSelected: (d) => setState(() => _selectedDate = d),
                ),
              ),
              SliverToBoxAdapter(
                child: DiarySearchBarWidget(
                  controller: _searchController,
                  onChanged: (val) => setState(() => _searchQuery = val),
                  onClear: () {
                    _searchController.clear();
                    setState(() => _searchQuery = '');
                  },
                ),
              ),
              if (_moodFilter != null)
                SliverToBoxAdapter(
                  child: _buildMoodFilterChip(),
                ),
              _buildEntriesList(filteredEntries),
            ],
          );
        },
      ),
    );
  }

  Widget _buildMoodFilterChip() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: [
          Chip(
            avatar: Icon(_moodFilter!.icon, size: 16, color: _moodFilter!.color),
            label: Text('${_moodFilter!.label} Filtresi'),
            onDeleted: () => setState(() => _moodFilter = null),
          ),
        ],
      ),
    );
  }

  Widget _buildEntriesList(List<DiaryEntry> entries) {
    if (entries.isEmpty) {
      return const SliverFillRemaining(
        hasScrollBody: false,
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Text(
              'Aramanıza veya seçilen güne uygun günlük bulunamadı.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14),
            ),
          ),
        ),
      );
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final entry = entries[index];
          return DiaryEntryCard(
            entry: entry,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => EntryDetailScreen(entryId: entry.id),
                ),
              );
            },
          );
        },
        childCount: entries.length,
      ),
    );
  }
}
