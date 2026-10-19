# Deary - Dijital Günlük Uygulaması
Bu doküman Flutter projesinde geliştirme yapacak olan ajan (antigravity) yapay zeka ve yazılım geliştiriciler için bağlayıcı bir kılavuzdur. Projede üretilen her kod satırı buradaki kurallara UYMAK ZORUNDADIR. 

## 1. Proje Özeti ve Teknolojiler
- **Uygulama Adı:** Deary (Takvim bazlı günlük ve dijital anı defteri)
- **Uygulamanın Özeti:** Kullanıcılar bu uygulama aracılığıyla günlük kayıtları oluşturabilir, ruh hâllerini belirtebilir, geçmiş kayıtlarını takvim üzerinden bulabilir, günlüklerinde arama yapabilir ve açık/koyu tema arasında geçiş yapabilir.
- **Uygulama arayüzü:** Uygulamanın arayüzü sade, huzurlu, kişisel kullanıma uygun ve kolay anlaşılır olmalıdır.
- **Uygulama Logosu:** Büyülü gözüken mor bir defter ve defterin yanında mavi tüyden bir kalem
- **Hedef Platformlar:** İos ve android öncelikli ardından web ve masaüstü platformlar
- **Flutter SDK:** Flutter 3.28.0
- **Dil:** Dart 3.12.2
- **Mimari:** Clean Architecture
- **Animasyon:** Rive (İkon ve durum geçiş animasyonları için)
- **Tema Yönetimi:** ValueNotifier tabanlı reaktif tema geçişi (harici paket olmadan çekirdek API ile)

## 2. Geliştirme Kuralları
- Kod okunabilir ve modüler olmalı.

- Her ekran ayrı bir dosyada tutulmalı

- Widget'lar gereksiz yere karmaşıklaştırılmamalı.

- Kod yapısını anlaşılır ve bakımı kolay olmalı.

- Gereksiz paketlerden ve karmaşık mimarilerden kaçınılmalı.

- kodlar kesinlikle tek bir yerde toplanmayacaktır. her modül feature klasöründe kodlanacaktır.

## 3. Projede Kullanılacak Teknolojiler
* **Mobil Uygulama Çatısı:** Flutter
* **Programlama Dili:** Dart
* **Arayüz:** Material Design 3
* **Başlangıç Durum Yönetimi:** setState
* **Veri Saklama Yöntemi:** Yerel
* **Test Yapısı:** Flutter Test Çerçevesi

Flutter'ın yerleşik özellikleri yeterli olduğunda öncelikle bu özellikler kullanılmalıdır.Onay alınmadan yeni bir durum yönetimi paketi eklenmemeli veya kalıcı veri saklama yöntemi kesinleştirilmemelidir.

## 4. Klasör ve Dosya Düzeni

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
        entry_detail_screen.dart
        settings.dart
    widgets/
        diary_entry_card.dart
        mood_selector.dart
    utils/
        date_utils.dart
main.dart
```
## 5. Veri Modeli
Her günlük kaydı aşağıdaki alanları içermelidir.

1. id: kaydın benzersiz kimliği
2. title: günlük başlığı
3. content: günlük içeriği
4. createdAt: oluşturulma tarihi
5. updatedAt: son düzenleme tarihi
6. mood: isteğe bağlı ruh hali 

## 6. Ruh Hali Seçenekleri
1. Mutlu
2. Sakin
3. Nötr
4. Üzgün
5. Stresli

## 7. Mimari Kurallar
- Uygulama küçük ve anlaşılır bir dosya yapısına sahip olmalıdır.

- Her ekran kendi dosyasında bulunmalıdır.

- Tekrarlanan arayüz bileşenleri widgets/ klasöründe tutulmalıdır.

- Günlük kaydı ve ruh hâli modelleri models/ klasöründe bulunmalıdır.

- Tarih işlemleri gibi yardımcı fonksiyonlar utils/ klasöründe tutulmalıdır.

- Paylaşılan günlük kayıtları ve tema durumu merkezi bir noktadan yönetilmelidir.

- Aynı veri farklı ekranlarda birbirinden bağımsız kopyalar olarak tutulmamalıdır.

## 8. Kırmızı Çizgiler ve Kod Kalite Standartları
1- **State Yönetim Standartları:** 
sayfa düzeyinde ağır `setState`KULLANILMAYACAKTIR.
Sadece yerel arayüz durumunu yöneten (örneğin buton animasyonları vb.) StatefulWidget kabul edilir.

2- **UI ve Performans Kuralları:**
Statik tüm widget'larda `const`zorunludur. 
Renk ve metin skilleri kesinlikle tema dosyalarına yazılacaktır.
Büyük build metotları yasaktır. 40 satırı geçen build metotları özel widget yazılacaktır.

3- **Yasaklı Paketler:**
projeye onay almadan harici ağır state paketleri EKLENMEYECEKTİR.
Dart'ın ve Flutter'ın yerel çekirdek apilerini kullanmak esastır.

## 9. Geliştirme Analiz ve Test Komutları
Ajan yaptığı herhangi bir kod değişikliğinden sonra mutlaka alttaki komutların çalıştığını doğrulamalıdır. 

* **Statik kod analizi (0 uyarı ve 0 hata şart):**
```bash
flutter anaylze 
```

* **Birim ve widget testleri:**
```bash
flutter test
```

* **Projeyi Çalıştırma:**
```bash
flutter run
```

## 10. Ajanın çıktı verme ve yanıt verme standartları
**Açıklamalar:** Türkçe teknik terimlerin özünü bozmadan net ve doğrudan olacaktır.

**Değişiklik sunumları:** örnek 500 satırlık bir dosyada 3 satır değiştiyse tüm dosyayı baştan sona basma; hedef satırları ve diff yapısını göster.

**Dosya yolları:** Bahsedilen ve üretilen her dosya için mutlaka projeye göre tıklanabilir link ver.

**Doğrulama:** Kod yazdıktan sonra kullanıcıya "Şimdi flutter analiz ile kontrol edebilirsin" şeklinde doğrulama yönergeleri ver.

