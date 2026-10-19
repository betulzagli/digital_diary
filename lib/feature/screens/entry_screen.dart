import 'package:flutter/material.dart';
import '../../core/storage/diary_controller.dart';
import '../../core/theme/app_colors.dart';
import '../models/diary_entry.dart';
import '../models/mood.dart';
import '../utils/date_utils.dart';
import '../widgets/mood_selector.dart';

class EntryScreen extends StatefulWidget {
  const EntryScreen({super.key});

  @override
  State<EntryScreen> createState() => _EntryScreenState();
}

class _EntryScreenState extends State<EntryScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  Mood _selectedMood = Mood.notr;

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _saveEntry() {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();

    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen günlük başlığı girin.')),
      );
      return;
    }

    final newEntry = DiaryEntry(
      id: 'entry-${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      content: content,
      createdAt: _selectedDate,
      updatedAt: DateTime.now(),
      mood: _selectedMood,
    );

    DiaryController.instance.addEntry(newEntry);

    _titleController.clear();
    _contentController.clear();
    setState(() {
      _selectedDate = DateTime.now();
      _selectedMood = Mood.notr;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Kaydınız başarıyla oluşturulmuştur.'),
        backgroundColor: AppColors.primaryPurple,
      ),
    );
  }

  void _insertFormatting(String prefix, String suffix) {
    final text = _contentController.text;
    final selection = _contentController.selection;
    final start = selection.start >= 0 ? selection.start : text.length;
    final end = selection.end >= 0 ? selection.end : text.length;
    final selectedText = text.substring(start, end);
    final newText = text.replaceRange(start, end, '$prefix$selectedText$suffix');

    _contentController.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: start + prefix.length + selectedText.length),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Yeni Günlük'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildDatePicker(context),
            const SizedBox(height: 14),
            _buildTitleField(),
            const SizedBox(height: 14),
            _buildToolbar(),
            const SizedBox(height: 6),
            _buildContentField(),
            const SizedBox(height: 16),
            MoodSelector(
              selectedMood: _selectedMood,
              onMoodSelected: (m) => setState(() => _selectedMood = m),
            ),
            const SizedBox(height: 24),
            _buildSaveButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildDatePicker(BuildContext context) {
    return InkWell(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: _selectedDate,
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );
        if (picked != null) {
          setState(() => _selectedDate = picked);
        }
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.dividerColor),
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_month_rounded, color: AppColors.primaryPurple, size: 20),
            const SizedBox(width: 10),
            Text(
              'Tarih: ${AppDateUtils.formatFullDate(_selectedDate)}',
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
            const Spacer(),
            const Icon(Icons.arrow_drop_down, color: AppColors.lightTextSecondary),
          ],
        ),
      ),
    );
  }

  Widget _buildTitleField() {
    return TextField(
      controller: _titleController,
      decoration: const InputDecoration(
        labelText: 'Günlük Başlığı',
        hintText: 'Bugünü anlatan bir başlık...',
      ),
    );
  }

  Widget _buildToolbar() {
    return Row(
      children: [
        IconButton(
          tooltip: 'Kalın',
          icon: const Icon(Icons.format_bold_rounded, size: 20),
          onPressed: () => _insertFormatting('**', '**'),
        ),
        IconButton(
          tooltip: 'İtalik',
          icon: const Icon(Icons.format_italic_rounded, size: 20),
          onPressed: () => _insertFormatting('*', '*'),
        ),
        IconButton(
          tooltip: 'Madde İşareti',
          icon: const Icon(Icons.format_list_bulleted_rounded, size: 20),
          onPressed: () => _insertFormatting('\n• ', ''),
        ),
      ],
    );
  }

  Widget _buildContentField() {
    return TextField(
      controller: _contentController,
      maxLines: 8,
      decoration: const InputDecoration(
        labelText: 'İçerik',
        hintText: 'Neler hissettin, neler yaşadın?...',
        alignLabelWithHint: true,
      ),
    );
  }

  Widget _buildSaveButton() {
    return ElevatedButton(
      onPressed: _saveEntry,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryPurple,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      child: const Text(
        'Günlüğü Kaydet',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    );
  }
}
