# Dijital Günlük Uygulaması Tasarım Kuralları (Design Guidelines)

## 1. Tasarım Vizyonu:
Uygulama kullanıcıya huzurlu ve büyülü hissettirmeli. Kullanıcının gözünü yormamalı. Kullanıcı uygulamayı açtığında kendisine ait özel bir alanda olduğunu hissetmelidir. Tasarım, günlük yazmayı kolaylaştırmalı ve dikkat dağıtan unsurlardan kaçınmalıdır.

## Tasarım Dili

- Gereksiz dekoratif öğeler ekleme.

- Ekranlarda tutarlı bir görsel dil kullan.

- İçerik ile dekorasyon arasında denge kur.

- Kullanıcıyı günlük yazmaya teşvik eden sakin bir atmosfer oluştur.

## Renk Paleti
Uygulama belirgin şekilde mor rengi ağırlıklı olmalıdır. Beyaz ve nötr arka planlar yerine morun huzurlu açık lavanta (soft lilac/lavender) ve zengin mor tonları baskın kılınmalıdır. Arka plandan kartlara, gezinme çubuklarından başlıklara kadar morun uyumlu açık ve koyu tonları atmosferi büyülü ve kişisel hissettirmelidir. Morun yanında az miktarda altın rengi (amber/gold) sadece özel anları, yıldızlı anıları veya önemli günlükleri vurgulamak için kullanılmalıdır. Neon renkler yerine dingin pastel mor, leylak ve erguvan tonları tercih edilmelidir.

Seçilen mor renk ailesi hem açık (lavanta/lila zeminli) hem de koyu (gece moru/derin mor) temaya kusursuz şekilde uyarlanmalıdır.

Renkleri merkezi bir tema yapılandırmasında tanımla. Widget'ların içinde aynı renkleri tekrar tekrar sabit kodlama.


## Uyulması Gereken Kurallar
- Başlıklarda belirgin ve okunabilir yazı boyutları kullan.

- Günlük içeriklerinde rahat okunabilen metinler tercih et.

- Tarih ve yardımcı bilgiler ana içerikten daha küçük olmalıdır.

- Metinlerin ekran sınırlarını aşmasını önle.

- Aynı seviyedeki başlıklarda tutarlı yazı stilleri kullan.

- Gereksiz yere çok sayıda farklı yazı boyutu kullanma.

- Bu tasarım rehberini bütün ekranlarda uygula.

- Mevcut tasarım sistemini değiştirmeden önce ilgili dosyaları incele.

- Yeni bir renk veya tasarım değeri eklemek gerekiyorsa önce mevcut sistemde uygun bir değer olup olmadığını kontrol et.

Tasarım değişikliklerinde uygulamanın genel tutarlılığını koru.

## Açık ve Koyu Tema
- Flutter'ın ThemeData ve ThemeMode yapılarını kullan.

- Tema değiştirildiğinde tüm ekranlar güncellenmelidir.

- Her iki temada da metinlerin okunabilirliğini koru.

- Kart, buton, form ve takvim bileşenleri her iki temayla uyumlu olmalıdır.

## Kaçınılması Gerekenler
- Gereksiz animasyonlar

- Aşırı gölge ve dekorasyon

- Tutarsız renkler ve yazı boyutları

- Küçük veya okunması zor metinler

- Ekran dışına taşan içerikler

- Her widget içinde tekrar tanımlanan renkler

- Kullanıcının günlük yazmasını zorlaştıran karmaşık düzenler

##