---
name: deary-flutter-agent-skill
description: Deary (Dijital Günlük Uygulaması) projesinde Flutter ile geliştirme yaparken uyulması gereken mimari kuralları, dosya yapısını ve kod standartlarını belirler.
---

# Deary Flutter Geliştirme İskeleti (Agent Kılavuzu)
Bu yetenek, Deary dijital günlük uygulamasında yeni bir ekran, model veya widget geliştirirken `project.md` ve `screens.md` dosyalarındaki kurallara tam uyulmasını garanti altına alır.

## İlgili Dosyalar ve Referanslar
- **Proje Geliştirme Kuralları:** `project.md`
- **Ekran Gereksinimleri ve UI Kuralları:** `screens.md`

## Temel Kurallar
1. **Dosya ve Modül Ayrımı:** Kodlar kesinlikle tek bir yerde toplanmayacaktır. Her modül `feature` klasöründe kodlanacaktır.
2. **Durum Yönetimi (State Management):** Harici ağır paketler (Provider, GetX, vb.) onay alınmadan KULLANILMAYACAKTIR. Sayfa düzeyinde yerel durumlar için `setState`, reaktif tema geçişi gibi merkezi durumlar için çekirdek API olan `ValueNotifier` kullanılacaktır.
3. **Const ve UI Performansı:** Statik tüm widget'larda `const` zorunludur. Renk ve metin stilleri kesinlikle tema dosyalarına yazılacaktır.
4. **Build Metodu Sınırı:** 40 satırı geçen `build` metotları yasaktır, ilgili arayüz parçaları özel widget olarak `widgets/` klasörüne bölünecektir.

## Adım Adım Uygulama Akışı

### Adım 1: Klasör Yapısını Doğrulama ve Oluşturma
Yeni bir kod yazmadan önce yapının aşağıdaki hiyerarşiye uygun olduğundan emin ol:

```text
lib/
  core/
  feature/
    models/
      diary_entry.dart
      mood.dart
    screens/
      home_screen.dart
      entry_screen.dart
      mood_report_screen.dart
      settings_screen.dart
    widgets/
      diary_entry_card.dart
      mood_selector.dart
    utils/
      date_utils.dart
main.dart
```

### Adım 2: Model Dosyalarını Oluşturma (`feature/models/`)
Modeller belirtilen tüm alanları içermelidir:

```dart
// lib/feature/models/mood.dart
enum Mood {
  mutlu,
  sakin,
  notr,
  uzgun,
  stresli
}

// lib/feature/models/diary_entry.dart
import 'mood.dart';

class DiaryEntry {
  final String id;
  final String title;
  final String content;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Mood? mood;

  const DiaryEntry({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    this.mood,
  });

  DiaryEntry copyWith({
    String? id,
    String? title,
    String? content,
    DateTime? createdAt,
    DateTime? updatedAt,
    Mood? mood,
  }) {
    return DiaryEntry(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      mood: mood ?? this.mood,
    );
  }
}
```

### Adım 3: Yardımcı Fonksiyonları Oluşturma (`feature/utils/`)
Tarih işlemleri gibi merkezi metotlar `utils` klasöründe tutulmalıdır.

```dart
// lib/feature/utils/date_utils.dart
class DateUtils {
  static String formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }
}
```

### Adım 4: Ekranları (Screens) Geliştirme (`feature/screens/`)
Ekranlar sade tutulmalı, tasarım `screens.md` dosyasına ve `ValueNotifier` tabanlı tema yapısına uygun olmalıdır.

```dart
// lib/feature/screens/home_screen.dart
import 'package:flutter/material.dart';
import '../widgets/diary_entry_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Deary'),
      ),
      body: Column(
        children: [
          // Yerleşik aylık takvim (screens.md'ye göre)
          const Placeholder(fallbackHeight: 200),
          // Arama çubuğu
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Kayıt başlığı veya tarihe göre ara...',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 10,
              itemBuilder: (context, index) {
                return const DiaryEntryCard(
                  title: 'Örnek Günlük',
                  date: '19/10/2026',
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
```

### Adım 5: Tekrar Kullanılabilir Widget'lar (`feature/widgets/`)
Karmaşık yapılar veya tekrarlayan arayüzler `widgets/` altında toplanmalıdır.

```dart
// lib/feature/widgets/diary_entry_card.dart
import 'package:flutter/material.dart';

class DiaryEntryCard extends StatelessWidget {
  final String title;
  final String date;

  const DiaryEntryCard({
    Key? key,
    required this.title,
    required this.date,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: Colors.blue, // Ruh haline göre renk (screens.md)
        ),
        title: Text(title),
        subtitle: Text(date),
        onTap: () {
          // Detay sayfasına yönlendir
        },
      ),
    );
  }
}
```

## Geliştirme, Kontrol ve Test Süreci
Ajan yaptığı herhangi bir kod değişikliğinden sonra mutlaka alttaki standartlara uymalıdır:

```bash
# Statik kod analizi (0 uyarı ve 0 hata şart):
flutter analyze 

# Birim ve widget testleri:
flutter test

# Projeyi Çalıştırma:
flutter run
```

### Ajan Çıktı Standartları
- **Değişiklik Sunumları:** 500 satırlık bir dosyada 3 satır değiştiyse tüm dosyayı baştan sona basma; hedef satırları ve `diff` yapısını göster.
- **Dosya Yolları:** Bahsedilen ve üretilen her dosya için mutlaka projeye göre tıklanabilir link ver.
- **Doğrulama Yönergesi:** Kod yazdıktan sonra kullanıcıya mutlaka: `"Şimdi flutter analyze ile kontrol edebilirsin."` şeklinde yönerge ver.

## SSS (Sıkça Sorulan Sorular)

### Soru: Harici bir State Management paketi (örn: GetX, Provider) ekleyebilir miyim?
**Cevap:** Hayır. `project.md` kuralı gereği Flutter'ın yerleşik özellikleri (setState, ValueNotifier) kullanılacaktır. Onay alınmadan paket eklenemez.

### Soru: Build metodu 40 satırı geçtiğinde ne yapmalıyım?
**Cevap:** Build metodu 40 satırı geçtiği an ilgili bölümü `feature/widgets/` altına ayrı bir `StatelessWidget` veya `StatefulWidget` olarak taşımalısın.

### Soru: Günlük kayıtları ve tema durumu nasıl yönetilmeli?
**Cevap:** `ValueNotifier` tabanlı reaktif tema geçişi kullanılarak merkezi bir noktadan yönetilmeli, aynı veri farklı ekranlarda birbirinden bağımsız kopyalar olarak tutulmamalıdır.
````<FollowUp>