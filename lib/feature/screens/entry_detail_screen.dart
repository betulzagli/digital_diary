import 'package:flutter/material.dart';
import '../../core/storage/diary_controller.dart';
import '../../core/theme/app_colors.dart';
import '../models/diary_entry.dart';
import '../models/mood.dart';
import '../utils/date_utils.dart';
import '../widgets/mood_selector.dart';

class EntryDetailScreen extends StatefulWidget {
  final String entryId;

  const EntryDetailScreen({super.key, required this.entryId});

  @override
  State<EntryDetailScreen> createState() => _EntryDetailScreenState();
}

class _EntryDetailScreenState extends State<EntryDetailScreen> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  DiaryEntry? _entry;
  Mood? _selectedMood;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _loadEntry();
  }

  void _loadEntry() {
    final entries = DiaryController.instance.entriesNotifier.value;
    final found = entries.firstWhere((e) => e.id == widget.entryId);
    _entry = found;
    _titleController = TextEditingController(text: found.title);
    _contentController = TextEditingController(text: found.content);
    _selectedMood = found.mood ?? Mood.notr;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _saveChanges() {
    if (_entry == null) return;

    final updated = _entry!.copyWith(
      title: _titleController.text.trim(),
      content: _contentController.text.trim(),
      updatedAt: DateTime.now(), // updatedAt güncellenir, createdAt korunur
      mood: _selectedMood,
    );

    DiaryController.instance.updateEntry(updated);
    setState(() {
      _entry = updated;
      _isEditing = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Günlük başarıyla güncellendi.'),
        backgroundColor: AppColors.primaryPurple,
      ),
    );
  }

  void _deleteEntry() {
    DiaryController.instance.deleteEntry(widget.entryId);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    if (_entry == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Günlük')),
        body: const Center(child: Text('Kayıt bulunamadı.')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Düzenle' : 'Günlük Detayı'),
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.check_rounded : Icons.edit_rounded),
            onPressed: () {
              if (_isEditing) {
                _saveChanges();
              } else {
                setState(() => _isEditing = true);
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline_rounded),
            onPressed: _deleteEntry,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildMetaInfo(),
            const SizedBox(height: 16),
            if (_isEditing) ...[
              _buildEditFields(),
            ] else ...[
              _buildViewContent(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildMetaInfo() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.primaryPurple.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (_entry!.mood != null) ...[
                Icon(_entry!.mood!.icon, color: _entry!.mood!.color, size: 20),
                const SizedBox(width: 8),
                Text(
                  _entry!.mood!.label,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: _entry!.mood!.color,
                  ),
                ),
                const Spacer(),
              ],
              Text(
                'Oluşturulma: ${AppDateUtils.formatFullDate(_entry!.createdAt)}',
                style: const TextStyle(fontSize: 12, color: AppColors.lightTextSecondary),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Son Değişiklik: ${AppDateUtils.formatFullDate(_entry!.updatedAt)}',
            style: const TextStyle(fontSize: 11, color: AppColors.goldAccent),
          ),
        ],
      ),
    );
  }

  Widget _buildEditFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: _titleController,
          decoration: const InputDecoration(labelText: 'Başlık'),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _contentController,
          maxLines: 10,
          decoration: const InputDecoration(labelText: 'İçerik'),
        ),
        const SizedBox(height: 14),
        MoodSelector(
          selectedMood: _selectedMood ?? Mood.notr,
          onMoodSelected: (m) => setState(() => _selectedMood = m),
        ),
      ],
    );
  }

  Widget _buildViewContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _entry!.title,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
        ),
        const Divider(height: 24),
        Text(
          _entry!.content,
          style: const TextStyle(fontSize: 15, height: 1.6),
        ),
      ],
    );
  }
}
