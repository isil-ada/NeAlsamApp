
# 🎁 Ne Alsam? - Hediye Öneri Mobil Uygulaması

![screenshot](./public/screenshots/ss1.png)
![screenshot](./public/screenshots/ss2.png)
![screenshot](./public/screenshots/ss3.png)
![screenshot](./public/screenshots/ss4.png)


Bu proje, Flutter kullanılarak geliştirilmiş bir mobil uygulamadır. Uygulamanın amacı, kullanıcıdan alınan bilgiler doğrultusunda **yapay zeka (Gemini API)** aracılığıyla kişiye özel hediye önerileri sunmaktır. Uygulama aynı zamanda her öneri için görsel arama yaparak kullanıcıya zengin bir deneyim sağlar. Kullanıcılar ayrıca önerilen ürünlere ait detaylı filtrelemeler yapabilir ve ilgili ürün sayfalarına yönlendirilir.

---

## 📌 Projenin Amacı

Hayatın birçok anında karşımıza çıkan “ne hediye alsam?” sorusuna akıllı ve kullanıcı dostu bir çözüm sunmak. Kullanıcı, birkaç basit soruya cevap verdikten sonra, kişiselleştirilmiş hediye önerileri ile karşılaşır. Bu öneriler sadece metinle sınırlı kalmaz, aynı zamanda gerçek görseller ve satın alma bağlantılarını da içerir.

---

## 🚀 Uygulama Özellikleri

- 📋 Stepper (adım adım) form yapısı ile kullanıcıdan bilgi alma
- 🤖 Gemini API ile kişisel verilere göre yapay zeka destekli öneriler
- 🖼️ Google görsel arama servisleri ile öneri görseli bulma
- 🛍️ Ürün adı, açıklama ve görsel içeren kart yapısı
- 🔍 Kullanıcıya puan, yorum sayısı ve fiyat gibi sorularla filtreleme sunma
- 🌐 Filtre sonuçlarına göre ilgili alışveriş sitesine yönlendirme

---

## 📂 Proje Dosya Yapısı

| Dosya                    | Açıklama |
|--------------------------|----------|
| `main.dart`              | Uygulamanın başlangıç noktası ve yönlendirme ayarları |
| `GirisEkrani.dart`       | Kullanıcının giriş yaptığı ekran |
| `SoruEkrani.dart`        | Kullanıcıdan bilgi alındığı adım adım ilerleyen form ekranı |
| `gemini_api.dart`        | Google Gemini API üzerinden hediye önerisi alınmasını sağlayan servis |
| `image_search_service.dart` | Girilen hediye adına göre ilgili görseli otomatik arayan servis |
| `oneri.dart`             | Öneri model sınıfı, önerilerin yapısını tanımlar |
| `OnerilerEkrani.dart`    | Yapay zekadan gelen önerilerin kullanıcıya gösterildiği ekran |
| `UrunSecDialog.dart`     | Ürün seçimi sonrası filtreleme (puan, fiyat vs.) ve link yönlendirme işlemleri yapılan dialog ekranı |

---

## ⚙️ Kurulum ve Çalıştırma

1. Gerekli bağımlılıkları yükleyin:
   ```bash
   flutter pub get
   ```

2. Uygulamayı çalıştırın:
   ```bash
   flutter run
   ```

3. API anahtarınızı `gemini_api.dart` içinde güncelleyin:
   ```dart
   static const String apiKey = "YOUR_GEMINI_API_KEY_HERE";
   ```

4. `url_launcher`, `google_fonts` ve `http` gibi kütüphanelerin `pubspec.yaml` dosyasında tanımlı olduğundan emin olun.

---

## 🔐 Kullanıcıdan Alınan Bilgiler

- 🎯 Kime hediye alınacak?
- 🎉 Hangi sebeple (doğum günü, yılbaşı, kutlama...)?
- 📅 Yaşı?
- 🚻 Cinsiyeti?
- 🎨 İlgi alanları (spor, kitap, müzik, vb.)
- 💸 Bütçe

---

## 🤖 Yapay Zeka Entegrasyonu (Gemini API)

Girilen kullanıcı verileri kullanılarak Gemini AI API’ye özel bir prompt gönderilir. Öneri şu formatta alınır:

```
Ürün Başlığı
https://gorsel.link
3-5 kelimelik kısa açıklama
```

---

## 🖼️ Görsel Arama Servisi

Gemini'den gelen ürün adıyla birlikte, `image_search_service.dart` dosyası:

- Önce kategoriye göre eşleşme yapar.
- Uygun görsel bulunamazsa Pexels API veya Lorem Picsum kullanır.
- `image.network(...)` içinde doğrudan gösterilir.

---

## 🧪 Öneriler Ekranı (OnerilerEkrani.dart)

Her öneri şu şekilde gösterilir:

- 🟣 Başlık (buton şeklinde tıklanabilir)
- 🖼️ Ürün görseli
- 📝 Kısa açıklama
- 🔗 Detay butonuna basıldığında: puan, yorum ve fiyat bilgisi istenir.
- 🌍 Seçilen bilgilere göre internetten alışveriş sitesine yönlendirme yapılır.

---

## 📌 Geliştirme Bilgileri

- Flutter SDK: 3.x
- Minimum desteklenen platform: Android 5.0+
- Durum yönetimi: `setState` kullanılarak yapılmaktadır.
- Firebase entegrasyonu isteğe bağlıdır ve ileride eklenebilir.

---

## 📣 Katkıda Bulun

Eğer projeye katkıda bulunmak isterseniz `fork` edip `pull request` gönderebilir veya `issue` açarak geliştirme sürecine destek olabilirsiniz.

---

## 🧑‍💻 Hazırlayan

- **Geliştirici:** Işıl Ada Yiğit
- **Proje Teması:** Kişiye özel hediye öneri sistemi
- **Teknolojiler:** Flutter, Gemini API, Google Görsel Arama, URL yönlendirme
- **Tarih:** Ağustos 2025
