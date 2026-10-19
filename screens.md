# Ekranlar ve Gereksinimleri

## Genel Kurallar:

Uygulama 4 ana ekrandan oluşur.

1. Ana Sayfa
2. Günlük Ekleme/Düzenleme Sayfası
3. Girilen Günlüklerin Ruh Hali Durumlarına Göre Mod Rapor ve Öneriler Sayfası
4. Ayarlar Sayfası

Her ekran kendi screens/ dosyasında bulunmalıdır. Ekranların görsel tasarım kuralları design.md dosyasına göre uygulanmalıdır.

## 1. Ana Sayfa - home_screen.dart

### Amaç: 
Kullanıcının hem yerleşik aylık takvim hem de günlük listesi üzerinden kayıtları görüntülemesi ve kayıtlar arasında arama yapmasını sağlamak

### Arayüz Elemanları

1. Yerleşik aylık takvim
2. Kaydırılabilir yakın tarihten uzak tarihe göre sıralanmış kayıt listesi
3. Günlük başlıkları
4. Kayıt tarihleri
5. Varsa ruh hali bilgisi
6. Kayıt arama alanı

### İşlevler
* Yerleşik aylık takvim ekranda appBar'ın hemen altında bulunmalı ve o ay girilen kayıtların günlerini ruh hali renklerine göre boyamalı

* Aylık takvimin altında kayıt listesinin üstünde bir arama çubuğu olmalı ve kullanıcı ister tarihe göre ister kayıt başlığına göre arama yapabilmeli. arama metni değiştikçe liste güncellenmeli

* Kayıt listesi yakın tarihten uzak tarihe göre sıralanmalı

* Kayıt listesindeki her kayıt bir kartta gösterilmeli. Bu kart başlık, oluşturulma tarihi, son değişiklik tarihi, ruh hali varsa ruh haline göre renk alan bir daire içermeli.

*  Kartın üzerine basıldığında ilgili günlük detayı açılamalıdır. Kullanıcı isterse buradaki günlük detayını güncelleyebilmeli. Kayıtta değişiklik yapıldığında createdAt korunmalı, updatedAt güncellenmelidir.

## 2. Günlük Ekleme/Düzenleme Sayfası - entry_screen.dart

### Amaç: 
Yeni günlük kaydı oluşturmak.

### Arayüz Elemanları

1. En üstte tarih seçici

2. Yeni eklenmek istenen günlük kaydının başlık girme alanı

3. Ana günlük girdisi alanı

4. Ruh hali seçici

5. Kaydet butonu

### İşlevler
* En üstteki tarih seçicide default olarak mevcut günün tarihi girilmeli. Eğer kullanıcı isterse açılır bir takvim ekranından geçmiş veya gelecek bir gün için de kayıt girebilmeli.

* Başlık ve içerik alanları düzenlenebilmelidir.

* Ana günlük girdisi alanında basit metin düzenleme seçenekleri(kalın/italik metin , madde ve sıralı liste seçenekleri vb.) bulunmalı.

* Ruh hali seçicide default olarak nötr olmalı. Kullanıcı isterse diğer ruh hallerinden birini seçmeli. Ruh halleri project.md dosyasında belirtilmiştir.

* Başarılı kaydetme sonrasında ekran temizlenmeli ve aşağıda "Kaydınız başarıyla oluşturulmuştur." mesajı dönmelidir.

## 3. Girilen Günlüklerin Ruh Hali Durumlarına Göre Mod Rapor ve Öneriler Sayfası

### Amaç: 
Kayıtlara eklenen ruh halleri analizi yapıp kullanıcıya ruh halini iyileştirme üzerine öneriler yapmak

### Arayüz Ögeleri

1. Kullanıcının girdiği tüm ruh halleri yüzdelerine göre pasta grafiği

2. En çok girilen ruh hali

3. En az girilen ruh hali

4. Kullanıcıya ruh halini iyileştirme üzerine öneriler

### İşlevler

* pasta grafiği ruh hali yüzdelerine göre renklendirilmeli. her dilime tıklanabilmeli ve tıklanan dilimin yüzdesine göre o günlüklere yönlendirme yapmalı.

* En çok girilen ruh hali ve en az girilen ruh hali pasta grafiğinin altında gösterilmeli

* Kullanıcıya ruh halini iyileştirme üzerine öneriler pasta grafiğinin altında gösterilmeli


## 4. Ayarlar Sayfası - settings_screen.dart

### Amaç:
Kullanıcının uygulama ile ilgili ayarları yapması

### Arayüz Ögeleri

1. Tema ayarları

2. Günlük kayıtlarının hepsini sıfırlama butonu

3. sayfanın en üstünde kullanıcı avatarı

### İşlevler 
* Kullanıcı temayı açık veya koyu olarak seçebilmeli ve sayfa seçilen temaya göre düzenlenmeli

* Günlük kayıtlarını sıfırla butonuna tıklandığında ekrana uyarı vermeli ve şifre girilmesi istenmeli. girilecek şifre uyarı pop up'ının içinde yazılmalı. bir nevi eminlik kontrolü gibi.



