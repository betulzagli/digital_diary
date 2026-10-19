import 'package:flutter/material.dart';
import '../../core/storage/diary_controller.dart';
import '../../core/theme/app_colors.dart';
import '../widgets/app_logo_widget.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ayarlar'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          children: [
            _buildUserAvatar(),
            const SizedBox(height: 20),
            _buildThemeCard(),
            const SizedBox(height: 14),
            _buildResetCard(context),
          ],
        ),
      ),
    );
  }

  Widget _buildUserAvatar() {
    return const Center(
      child: Column(
        children: [
          AppLogoWidget(size: 80, borderRadius: 22),
          SizedBox(height: 10),
          Text(
            'Deary - Dijital Günlük',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
          Text(
            'Kişisel Huzur ve Anı Defteri',
            style: TextStyle(fontSize: 12, color: AppColors.lightTextSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildThemeCard() {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: DiaryController.instance.themeModeNotifier,
      builder: (context, currentMode, _) {
        final isDark = currentMode == ThemeMode.dark;
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                      color: AppColors.goldAccent,
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Koyu Tema',
                          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                        ),
                        Text(
                          isDark ? 'Koyu mod aktif' : 'Açık mod aktif',
                          style: const TextStyle(fontSize: 12, color: AppColors.lightTextSecondary),
                        ),
                      ],
                    ),
                  ],
                ),
                Switch(
                  value: isDark,
                  activeThumbColor: AppColors.primaryPurple,
                  onChanged: (val) => DiaryController.instance.toggleTheme(val),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildResetCard(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.delete_forever_rounded, color: Colors.redAccent),
        title: const Text(
          'Tüm Günlükleri Sıfırla',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Colors.redAccent),
        ),
        subtitle: const Text(
          'Tüm kayıtları kalıcı olarak temizler.',
          style: TextStyle(fontSize: 12),
        ),
        onTap: () => _showResetConfirmationDialog(context),
      ),
    );
  }

  void _showResetConfirmationDialog(BuildContext context) {
    const confirmationCode = 'SIFIRLA123';
    final textController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogCtx) {
        return AlertDialog(
          title: const Text('Emin misiniz?'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Bu işlem geri alınamaz. Devam etmek için aşağıdaki onay şifresini kutuya yazınız:',
                style: TextStyle(fontSize: 13),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primaryPurple.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Onay Şifresi: $confirmationCode',
                  style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.primaryPurple),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: textController,
                decoration: const InputDecoration(
                  hintText: 'Şifreyi buraya yazın',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogCtx).pop(),
              child: const Text('Vazgeç'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
              onPressed: () {
                if (textController.text.trim() == confirmationCode) {
                  DiaryController.instance.resetAllEntries();
                  Navigator.of(dialogCtx).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Tüm günlük kayıtları sıfırlandı.')),
                  );
                } else {
                  ScaffoldMessenger.of(dialogCtx).showSnackBar(
                    const SnackBar(content: Text('Hatalı onay şifresi!')),
                  );
                }
              },
              child: const Text('Sıfırla', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
}
