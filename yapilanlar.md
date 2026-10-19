# Deary - Yapılan Geliştirmeler ve Kod Mimarisi Detay Raporu

Bu doküman, **Deary (Takvim Bazlı Dijital Günlük ve Anı Defteri)** projesinde başlangıçtan itibaren yapılan tüm çalışmaları, mimari kararları ve `lib/` klasörü altındaki **bütün dosyaları, sınıfları, fonksiyonları ve metotları** hiçbir detayı atlamadan, kullanım nedenleriyle birlikte açıklamaktadır.

---

## 1. Genel Proje Özeti ve Mimari İlkeler

Proje, [project.md](file:///c:/Users/Betul/Desktop/digital_diary/project.md), [design.md](file:///c:/Users/Betul/Desktop/digital_diary/design.md), [screens.md](file:///c:/Users/Betul/Desktop/digital_diary/screens.md) ve [SKILL.md](file:///c:/Users/Betul/Desktop/digital_diary/SKILL.md) yönergelerine tam uyumlu olarak geliştirilmiştir:
- **Clean Architecture & Modülerlik:** Kodlar tek bir dosyada toplanmamış; `core` (çekirdek servis ve temalar), `models` (veri yapıları), `screens` (sayfalar), `widgets` (tekrar kullanılabilir parçalar) ve `utils` (yardımcı fonksiyonlar) olarak ayrılmıştır.
- **Harici Durum Paketi Olmadan Çekirdek API Kullanımı:** Ağır harici durum paketleri (Bloc, Provider, GetX vb.) yerine, Flutter'ın yerleşik ve performanslı `ValueNotifier` ve `ValueListenableBuilder` API'leri kullanılmıştır.
- **40 Satır Kuralı:** Hiçbir `build` metodunun 40 satırı aşmasına izin verilmemiş, büyük arayüz parçaları alt widget fonksiyonlarına veya özel bileşenlere bölünmüştür.
- **Performans & Const:** Gereksiz `rebuild`'lerin önüne geçmek amacıyla tüm statik yapılarda `const` anahtar kelimesi zorunlu tutulmuştur.
- **Tasarım Dili:** Beyaz baskınlığı kırılarak huzurlu pastel lavanta, dingin leylak ve zengin mor tonları hâkim kılınmış; özel anlar için altın vurgular eklenmiştir.

---

## 2. `lib/` Klasörü Altındaki Tüm Dosyalar, Sınıflar ve Fonksiyonlar

---

### 2.1. `lib/main.dart`
Uygulamanın başlangıç noktası ve kök widget yapılandırmasıdır.

- **`void main()`**:
  - *Neden yazıldı:* Flutter motorunu başlatmak (`WidgetsFlutterBinding.ensureInitialized()`), kullanıcının uygulamayı ilk açtığında zengin bir içerikle karşılaşması için başlangıç örnek verilerini hafızaya yüklemek (`DiaryController.instance.initSampleData()`) ve uygulamayı ayağa kaldırmak (`runApp`) için kullanılır.
- **`DearyApp` (StatelessWidget)**:
  - *Neden yazıldı:* Uygulamanın en tepesindeki `MaterialApp` çatısını kurar.
  - *`build(BuildContext context)`*: `DiaryController.instance.themeModeNotifier` nesnesini `ValueListenableBuilder` ile dinler. Tema modu (Açık/Koyu) değiştiğinde tüm uygulamayı anında yeniden render ederek pürüzsüz bir tema geçişi sağlar. `theme: AppTheme.lightTheme` ve `darkTheme: AppTheme.darkTheme` tanımlarını bağlar.

---

### 2.2. `lib/core/storage/diary_controller.dart`
Uygulamanın veri saklama, CRUD operasyonları, arama/filtreleme ve tema durumunu tek bir noktadan yöneten Singleton kontrolcüsüdür.

- **`DiaryController` Sınıfı**:
  - *`DiaryController._()` ve `static final instance`*: Singleton tasarım kalıbıdır. Uygulamanın her yerinden aynı veri havuzuna erişilmesini sağlar; verilerin ekranlar arasında bağımsız kopyalar halinde tutulmasını engeller.
  - *`themeModeNotifier` (ValueNotifier<ThemeMode>)*: Uygulamanın aktif tema modunu (Light/Dark) saklar ve reaktif olarak UI'a yayınlar.
  - *`entriesNotifier` (ValueNotifier<List<DiaryEntry>>)*: Tüm günlük kayıtlarının listesini reaktif olarak tutar. Liste güncellendiğinde dinleyen tüm ekranlar anında yenilenir.
  - *`initSampleData()`*: Kullanıcı ilk kez girdiğinde takvimde, günlük listesinde ve pasta grafiğinde zengin ve estetik bir deneyim görebilsin diye örnek 5 adet günlük kaydını hazırlar.
  - *`toggleTheme(bool isDark)`*: Koyu tema anahtarına basıldığında `themeModeNotifier` değerini `ThemeMode.dark` veya `ThemeMode.light` olarak günceller.
  - *`addEntry(DiaryEntry entry)`*: Yeni bir günlük kaydını listenin başına ekler, listeyi `createdAt` tarihine göre yeniden sıralar ve `entriesNotifier` üzerinden tüm ekranları uyarır.
  - *`updateEntry(DiaryEntry updated)`*: Mevcut bir günlük güncellendiğinde id eşleşmesi yaparak eski kaydı yenisiyle değiştirir (`updatedAt` güncellenirken `createdAt` korunur).
  - *`deleteEntry(String id)`*: Belirtilen `id`'ye sahip günlüğü listeden çıkarır ve listeyi günceller.
  - *`resetAllEntries()`*: Ayarlar sayfasından onay koduyla çağrıldığında hafızadaki tüm günlük kayıtlarını sıfırlar.
  - *`searchAndFilter({String query, DateTime? selectedDate, Mood? moodFilter})`*: Ana sayfada ve rapor sayfasında kullanılır. Günlükleri aynı anda arama metnine (başlık, içerik, tarih), takvimden seçilen spesifik bir güne ve seçilen ruh haline göre süzerek döndürür.

---

### 2.3. `lib/core/theme/app_colors.dart`
Uygulamanın renk sistemini merkezi olarak barındıran sabitler sınıfıdır.

- **`AppColors` Sınıfı**:
  - *Neden yazıldı:* Widget'lar içinde renk kodlarının hardcoded (sabit) yazılmasını engellemek, [design.md](file:///c:/Users/Betul/Desktop/digital_diary/design.md) kurallarına uygun olarak mor/lavanta ağırlıklı bir palet sunmak için.
  - *`primaryPurple` & `primaryPurpleDark` & `primaryPurpleLight` & `deepPurple`*: Uygulamanın ana kimliğini oluşturan asil mor tonları.
  - *`softLilac`*: Seçim göstergelerinde ve hafif vurgularda kullanılan yumuşak leylak rengi.
  - *`goldAccent` & `softGold`*: Özel anları, yıldızlı hatıraları ve düzenleme tarihlerini vurgulamak için ayrılan altın sarısı tonları.
  - *`lightBackground` (`#F1EDFB`)*: Beyazın göz yoran parlaklığını kıran, sakinleştirici açık lavanta arka plan.
  - *`lightSurface` (`#FAF7FF`)*: Kartların ve form elemanlarının zemininde kullanılan pürüzsüz leylak yüzey.
  - *`lightCardBorder` (`#DDD5F7`)*: Kartlara derinlik katan lavanta sınır çizgisi.
  - *`lightTextPrimary` & `lightTextSecondary`*: Okunabilirliği yüksek koyu patlıcan moru ve orta mor-gri metin renkleri.
  - *`darkBackground` (`#100C1E`) & `darkSurface` (`#1B1430`)*: Koyu tema için tasarlanmış derin gece moru ve ametist tonları.
  - *`dividerColor`*: İnce ayırıcı çizgiler için transparan mor tonu.

---

### 2.4. `lib/core/theme/app_theme.dart`
Material 3 standartlarına uygun Açık ve Koyu `ThemeData` yapılandırmasını kuran sınıftır.

- **`AppTheme` Sınıfı**:
  - *`static ThemeData get lightTheme`*: Açık tema yapılandırmasıdır. `ColorScheme.light`, lavanta zemin rengi, şeffaf mor başlıklı `appBarTheme`, yuvarlatılmış köşeli ve lavanta sınırlı `cardTheme` (`CardThemeData`), yumuşak leylak göstergeli `navigationBarTheme` ve mor odak çizgili `inputDecorationTheme` tanımlar.
  - *`static ThemeData get darkTheme`*: Gece modu yapılandırmasıdır. Gözü yormayan koyu ametist zeminler, açık mor metinler ve koyu mor kart sınırlarıyla zengin bir gece deneyimi sunar.

---

### 2.5. `lib/feature/models/diary_entry.dart`
Günlük kayıtlarının veri yapısını temsil eden modeldir.

- **`DiaryEntry` Sınıfı**:
  - *Alanlar:* `id` (benzersiz kimlik), `title` (başlık), `content` (içerik), `createdAt` (oluşturulma tarihi), `updatedAt` (son düzenlenme tarihi), `mood` (isteğe bağlı ruh hali).
  - *`DiaryEntry(...)`*: Değişmez (immutable) yapıcı metot (`const`).
  - *`copyWith(...)`*: Günlük düzenlenirken `createdAt` tarihini değiştirmeden sadece `title`, `content`, `updatedAt` veya `mood` alanlarını güncelleyip yeni bir kopya üretmek için kullanılır.
  - *`toMap()` ve `fromMap(...)`*: İleride yerel depolama (JSON/SharedPreferences/SQLite) veya dışa aktarma işlemleri için veri serileştirme desteği sağlar.

---

### 2.6. `lib/feature/models/mood.dart`
Uygulamada desteklenen ruh hallerini ve bunlara bağlı görsel özellikleri yöneten enum yapısıdır.

- **`Mood` Enum**:
  - *Değerler:* `mutlu`, `sakin`, `notr`, `uzgun`, `stresli`.
  - *`String get label`*: Ruh halinin Türkçe metin karşılığını döner ("Mutlu", "Sakin", vb.).
  - *`Color get color`*: Her ruh haline özel pastel ve huzur verici renk kodunu döner (Yeşil, Mavi, Gri, Mor, Mercan).
  - *`IconData get icon`*: Ruh haline karşılık gelen yuvarlak hatlı Material duygu ikonunu döner.

---

### 2.7. `lib/feature/utils/date_utils.dart`
Tarih formatlama, takvim hesaplamaları ve Türkçe gün/ay isimlerini sağlayan yardımcı sınıftır.

- **`AppDateUtils` Sınıfı**:
  - *`_months` & `_weekdays`*: Türkçe ay (Ocak...Aralık) ve gün (Pzt...Paz) isim listeleridir.
  - *`formatDate(DateTime date)`*: Tarihi `GG/AA/YYYY` formatında döner (Kartlarda ve aramalarda kullanılır).
  - *`formatFullDate(DateTime date)`*: Tarihi `19 Ekim 2026` gibi uzun ve okunaklı formatta döner (Detay ekranında kullanılır).
  - *`formatMonthYear(DateTime date)`*: Aylık takvim başlığı için `Ekim 2026` formatını üretir.
  - *`getWeekdayShort(int weekday)`*: Takvim gün sütunları için kısa gün adını döner.
  - *`isSameDay(DateTime a, DateTime b)`*: İki `DateTime` nesnesinin saatlerine bakılmaksızın aynı takvim gününe denk gelip gelmediğini kontrol eder.

---

### 2.8. `lib/feature/widgets/app_logo_widget.dart`
Uygulamanın özel marka kimliğini (büyülü mor defter ve mavi tüylü kalem) ekranda gösteren bileşendir.

- **`AppLogoWidget` (StatelessWidget)**:
  - *Parametreler:* `size`, `borderRadius`, `showShadow`.
  - *`build(BuildContext context)`*: `assets/images/logo.png` görselini yuvarlatılmış köşeler ve mor ışıltılı bir gölge ile çizer. Olası varlık yükleme sorunlarına karşı zarif bir yedek ikon fallback mekanizması içerir.

---

### 2.9. `lib/feature/widgets/diary_entry_card.dart`
Ana sayfadaki kaydırılabilir listede her bir günlüğü görselleştiren kart bileşenidir.

- **`DiaryEntryCard` (StatelessWidget)**:
  - *`build(BuildContext context)`*: 40 satır sınırını aşmamak adına alt parçalara bölünmüştür. Kart tıklandığında detay sayfasına yönlendirir (`onTap`).
  - *`_buildMoodIndicator(Color moodColor)`*: Günlüğün ruh haline göre sol tarafta parlayan renkli bir çember çizer.
  - *`_buildTitle(ThemeData theme)`*: Günlük başlığını tek satır ve taşma korumalı (`ellipsis`) olarak basar.
  - *`_buildContentPreview(ThemeData theme)`*: Günlük içeriğinden 2 satırlık bir önizleme gösterir.
  - *`_buildDates(ThemeData theme, bool isEdited)`*: Oluşturulma tarihini, eğer sonradan düzenlendiyse yanına altın rengiyle son düzenlenme tarihini basar.

---

### 2.10. `lib/feature/widgets/monthly_calendar_widget.dart`
Ana sayfanın üst kısmında yer alan, günleri ruh hali renkleriyle boyayan interaktif takvim bileşenidir.

- **`MonthlyCalendarWidget` (StatelessWidget)**:
  - *`build(BuildContext context)`*: Başlık, haftanın günleri ve gün hücreleri ızgarasını bir kart içinde toplar.
  - *`_buildHeader(BuildContext context)`*: Ay ve yıl metnini gösterir; önceki/sonraki ay geçiş butonlarını barındırır.
  - *`_buildWeekdayLabels()`*: Pzt, Sal, Çar vb. gün başlıklarını eşit aralıklarla çizer.
  - *`_buildDaysGrid(BuildContext context)`*: O ayın gün sayısını ve ilk günün haftanın hangi gününe denk geldiğini hesaplayarak 7 sütunlu ızgara üretir.
  - *`_buildDayCell(...)`*: Her bir takvim hücresini oluşturur. Seçili ise mor kutuyla vurgular; o gün girilmiş bir günlük varsa ruh halinin rengiyle nokta veya zemin renklendirmesi yapar. Tıklandığında ana sayfadaki listeyi o güne göre filtreler.
  - *`_findMoodForDate(DateTime date)`*: Belirli bir takvim gününde kaydedilmiş bir günlük ve ruh hali olup olmadığını kontrol eder.

---

### 2.11. `lib/feature/widgets/mood_selector.dart`
Günlük ekleme ve düzenleme ekranlarında kullanıcının 5 duygu durumundan birini seçmesini sağlayan yatay çip seçicidir.

- **`MoodSelector` (StatelessWidget)**:
  - *`build(BuildContext context)`*: Başlık ve yatay kaydırılabilir ruh hali çiplerini sunar.
  - *`_buildMoodChip(BuildContext context, Mood mood, bool isSelected)`*: Her bir duygu durumunu ikonu, rengi ve etiketiyle butonlaştırır. Seçili olan çip, kendi renginde şık bir dolgu ve çerçeve animasyonu kazanır.

---

### 2.12. `lib/feature/widgets/mood_pie_chart.dart`
Rapor sayfasında ruh hali dağılımlarını görselleştiren, dokunmatik algılamaya sahip özel pasta grafik bileşenidir.

- **`MoodSliceData` Sınıfı**:
  - *Neden yazıldı:* Her bir duygu diliminin modunu, adetini ve toplam içindeki yüzdesini taşımak için.
- **`MoodPieChart` (StatelessWidget)**:
  - *`build(BuildContext context)`*: Dilim verisi boşsa bilgilendirme metni; doluysa `CustomPaint` ile çizilen grafik alanını ve altına renk açıklamalarını (`legend`) basar.
  - *`_handleTap(TapUpDetails details, Size size)`*: Kullanıcının pasta grafiğinde dokunduğu noktanın koordinatlarından (`dx`, `dy`) trigonometrik açı (`atan2`) hesabı yapar. Dokunulan açının hangi ruh hali dilimine denk geldiğini bularak `onSliceSelected` callback'ini tetikler.
  - *`_buildLegend()`*: Pasta grafiğinin altında her rengin hangi duyguya ve yüzdeye ait olduğunu gösteren tıklanabilir etiket listesini oluşturur.
- **`_PieChartPainter` (CustomPainter)**:
  - *`paint(Canvas canvas, Size size)`*: `canvas.drawArc` kullanarak dilimleri saat yönünde ve yüzdelerine göre çizer. Seçili dilim varsa, dilimi merkezden hafifçe dışarı kaydırarak (offset) öne çıkarır.
  - *`shouldRepaint(...)`*: Sadece dilim verileri veya seçili ruh hali değiştiğinde yeniden çizim yaparak performansı korur.

---

### 2.13. `lib/feature/widgets/search_bar_widget.dart`
Ana sayfada takvimin altında yer alan canlı arama giriş alanıdır.

- **`DiarySearchBarWidget` (StatelessWidget)**:
  - *`build(BuildContext context)`*: Arama ikonlu `TextField` oluşturur. Metin yazıldığında anında `onChanged` tetiklenir; metin varsa sağda beliren temizleme butonu ile arama sıfırlanabilir (`onClear`).

---

### 2.14. `lib/feature/screens/main_navigation_screen.dart`
Uygulamanın 4 ana ekranı arasında geçişi yöneten kök navigasyon scaffold'ıdır.

- **`MainNavigationScreen` (StatefulWidget)**:
  - *`_currentIndex`*: Seçili olan sekmenin indeksini tutar (0: Günlük, 1: Yaz, 2: Rapor, 3: Ayarlar).
  - *`build(BuildContext context)`*: Sayfaların durumunu ve kaydırma pozisyonlarını kaybetmemesi için `IndexedStack` kullanır.
  - *`_buildBottomNav()`*: Material 3 `NavigationBar` bileşeni ile 4 ana sayfanın ikon ve etiketlerini mor gösterge animasyonu eşliğinde sunar.

---

### 2.15. `lib/feature/screens/home_screen.dart`
Uygulamanın ana ekranıdır; takvim, arama çubuğu ve kronolojik günlük akışını bir araya getirir.

- **`HomeScreen` (StatefulWidget)**:
  - *`initialMoodFilter`*: Rapor ekranındaki pasta grafiğine tıklandığında filtrelenmiş olarak açılabilmesini sağlar.
  - *`initState()` & `dispose()`*: Arama metin kontrolcüsünü ve başlangıç filtrelerini yönetir.
  - *`build(BuildContext context)`*: `DiaryController.instance.entriesNotifier`'ı dinler. Takvim, arama çubuğu ve günlük listesini yüksek performanslı `CustomScrollView` ve `SliverList` yapılarıyla ekrana çizer.
  - *`_buildMoodFilterChip()`*: Eğer bir duygu filtresi aktifse, listenin üstünde kapatılabilir bir filtre çipi gösterir.
  - *`_buildEntriesList(List<DiaryEntry> entries)`*: Filtrelere uyan kayıtları `DiaryEntryCard` ile listeler; kayıt yoksa kullanıcıyı sakin bir mesajla karşılar. Kart tıklandığında `EntryDetailScreen`'e yönlendirir.

---

### 2.16. `lib/feature/screens/entry_screen.dart`
Kullanıcının yeni bir günlük kaydı girmesini sağlayan ekrandır.

- **`EntryScreen` (StatefulWidget)**:
  - *`_titleController` & `_contentController`*: Başlık ve içerik alanlarının metin yönetimini sağlar.
  - *`_selectedDate` & `_selectedMood`*: Seçilen tarihi (varsayılan bugün) ve ruh halini (varsayılan nötr) tutar.
  - *`_saveEntry()`*: Başlık boşluk kontrolünü yapar, yeni bir `DiaryEntry` nesnesi oluşturup `DiaryController`'a ekler, formu temizler ve *"Kaydınız başarıyla oluşturulmuştur."* bildirimini gösterir.
  - *`_insertFormatting(String prefix, String suffix)`*: Seçili metnin başına ve sonuna Markdown işaretleri ekleyerek metni kalın (`**`), italik (`*`) yapar veya liste maddesi (`• `) ekler.
  - *`build(BuildContext context)`*: 40 satır sınırına uygun olarak alt fonksiyonlara ayrılmış form düzenini sunar.
  - *`_buildDatePicker(BuildContext context)`*: Tıklandığında açılır takvim penceresi (`showDatePicker`) ile geçmiş veya gelecek bir tarih seçtirir.
  - *`_buildTitleField()` & `_buildContentField()`*: Günlük başlığı ve içerik giriş alanlarını oluşturur.
  - *`_buildToolbar()`*: Kalın, italik ve liste ekleme butonlarını içeren biçimlendirme araç çubuğunu çizer.
  - *`_buildSaveButton()`*: Günlüğü kaydeden mor renkli geniş aksiyon butonunu oluşturur.

---

### 2.17. `lib/feature/screens/entry_detail_screen.dart`
Kaydedilmiş bir günlüğün tüm detaylarını görüntüleme, düzenleme ve silme ekranıdır.

- **`EntryDetailScreen` (StatefulWidget)**:
  - *`entryId`*: Hangi günlüğün incelendiğini belirten kimlik parametresidir.
  - *`_isEditing`*: Ekranın okuma modunda mı yoksa düzenleme modunda mı olduğunu kontrol eder.
  - *`_loadEntry()`*: `DiaryController` üzerinden günlüğün en güncel halini çeker ve form kontrolcülerine aktarır.
  - *`_saveChanges()`*: [screens.md](file:///c:/Users/Betul/Desktop/digital_diary/screens.md) kuralı gereğince `createdAt` oluşturulma tarihine dokunmadan `updatedAt` tarihini `DateTime.now()` yaparak kaydı günceller ve okuma moduna döner.
  - *`_deleteEntry()`*: Günlüğü hafızadan siler ve önceki ekrana döner.
  - *`build(BuildContext context)`*: AppBar üzerinde düzenleme (`edit`/`check`) ve silme ikonları ile gövde içeriğini yönetir.
  - *`_buildMetaInfo()`*: Ruh hali rozetini, oluşturulma tarihini ve varsa son değişiklik tarihini gösteren üst bilgi kutusunu çizer.
  - *`_buildEditFields()`*: Düzenleme modunda başlık, içerik ve ruh hali seçicisini gösterir.
  - *`_buildViewContent()`*: Okuma modunda günlüğün başlığını ve gövde metnini rahat okunabilir tipografiyle gösterir.

---

### 2.18. `lib/feature/screens/mood_report_screen.dart`
Girilen günlüklerin duygu durumlarını analiz eden ve kullanıcıya tavsiyeler sunan ekrandır.

- **`MoodReportScreen` (StatefulWidget)**:
  - *`_selectedMood`*: Pasta grafiğinde seçilen ruh halini tutar.
  - *`build(BuildContext context)`*: `DiaryController` kayıtlarını dinleyerek yüzdeleri hesaplar ve grafik, istatistik ile öneri bileşenlerini bir araya getirir.
  - *`_navigateToFilteredHome(BuildContext context, Mood mood)`*: Pasta grafiğinde bir dilime tıklandığında ana sayfayı o ruh haline göre filtrelenmiş olarak açar.
  - *`_buildStatsSection(_MoodStats stats)`*: En çok ve en az hissedilen duygu durumlarını yan yana iki kartta sunar.
  - *`_buildStatCard(...)`*: İlgili duygunun ikonunu, adını ve rengini gösteren estetik istatistik kartıdır.
  - *`_buildRecommendations(Mood? dominantMood)`*: Kullanıcının en çok hissettiği duygu durumuna göre hazırlanan iyileştirici öneri kartıdır.
  - *`_getRecommendationText(Mood? mood)`*: Mutlu, sakin, stresli, üzgün veya nötr ruh haline göre özel olarak yazılmış psikolojik rahatlama ve farkındalık metinlerini döner.
  - *`_calculateMoodSlices(List<DiaryEntry> entries)`*: Tüm kayıtları tarayarak ruh hallerinin adet ve yüzdelik oranlarını hesaplar.
  - *`_calculateMoodStats(List<MoodSliceData> slices)`*: Yüzdelere göre en çok ve en az hissedilen duyguyu belirler.
- **`_MoodStats` Sınıfı**: En çok ve en az hissedilen iki modu bir arada taşımak için yazılmış veri taşıyıcı sınıftır.

---

### 2.19. `lib/feature/screens/settings_screen.dart`
Uygulama tercihlerini, tema geçişini ve güvenlikli sıfırlama mekanizmasını barındıran ekrandır.

- **`SettingsScreen` (StatelessWidget)**:
  - *`build(BuildContext context)`*: Avatar, tema kartı ve sıfırlama kartını dikey düzende toplar.
  - *`_buildUserAvatar()`*: Sayfanın tepesinde mor defter ve mavi tüylü kalem logomuzu, altında ise uygulama adını ve açıklamasını sergiler.
  - *`_buildThemeCard()`*: `DiaryController.instance.themeModeNotifier`'ı dinleyen bir `Switch` içerir. Açık ve Koyu tema arasında geçiş yapılmasını sağlar.
  - *`_buildResetCard(BuildContext context)`*: Kırmızı renkli uyarıcı başlıkla sıfırlama aksiyonunu sunar.
  - *`_showResetConfirmationDialog(BuildContext context)`*: [screens.md](file:///c:/Users/Betul/Desktop/digital_diary/screens.md) kuralı gereğince açılan popup içinde gösterilen rastgele güvenlik şifresinin (`SIFIRLA123`) kullanıcı tarafından kutuya elle doğru yazılmasını şart koşar. Yanlış yazılırsa hata uyarısı verir, doğru yazılırsa tüm kayıtları sıfırlar.

---

## 3. Web & Varlık (Asset) Entegrasyonu

- **`pubspec.yaml`**: `assets/images/` dizini eklenerek `logo.png` projenin yerleşik varlığı haline getirilmiştir.
- **`web/index.html`**: Sayfa başlığı `Deary - Dijital Günlük` olarak güncellenmiş; web açılışında Flutter logosu yerine mor defter ve mavi tüylü kalem logomuzun belirdiği özel bir `#loading` animasyonu eklenmiştir.
- **`web/manifest.json`**: Uygulama adı ve tema renkleri mor/lavanta tonlarıyla senkronize edilmiştir.
- **`web/favicon.png` & `web/icons/`**: Varsayılan Flutter logolarının tümü Deary logosu ile değiştirilmiştir.

---

## 4. Testler ve Doğrulama Raporu

Projede yapılan tüm kodlamalar kalite standartları kapsamında doğrulanmıştır:
1. **Statik Kod Analizi (`flutter analyze`):**
   ```text
   Analyzing digital_diary...
   No issues found! (0 hata, 0 uyarı)
   ```
2. **Widget Testleri (`flutter test`):**
   - [widget_test.dart](file:///c:/Users/Betul/Desktop/digital_diary/test/widget_test.dart) dosyasında navigasyon ve sayfa render testleri çalıştırılmış, `All tests passed!` sonucu alınmıştır.
3. **Canlı Doğrulama:**
   - Uygulama `flutter run -d chrome` ile derlenmiş ve tarayıcıda hatasız olarak test edilmiştir.
