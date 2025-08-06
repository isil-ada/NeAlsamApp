import 'package:flutter_application_btk/oneri.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_application_btk/image_search_service.dart';

class GeminiService {
  static const String apiKey = API_KEY;

  static final GenerativeModel _model = GenerativeModel(
    model: 'gemini-1.5-flash',
    apiKey: apiKey,
  );

  static Future<List<Oneri>> hediyeOnerisi({
    required String alici,
    required String neden,
    required String yas,
    required String cinsiyet,
    required List<String> ilgiAlanlari,
    required String butce,
  }) async {
    final prompt =
        '''
      Kime: $alici  
      Neden: $neden  
      Yaş: $yas  
      Cinsiyet: $cinsiyet  
      İlgi alanları: ${ilgiAlanlari.join(", ")}  
      Bütçe: $butce  

      Sadece 3 hediye önerisi ver. Her biri şu formatta olsun:

      1. Türkçe Ürün Adı  
      İngilizce ürün adı
      Ürün Açıklama: 3-5 kelimelik kısa açıklama

      2. Türkçe Ürün Adı  
      İngilizce ürün adı
      Ürün Açıklama: 3-5 kelimelik kısa açıklama

      3. Türkçe Ürün Adı  
      İngilizce ürün adı
      Ürün Açıklama: 3-5 kelimelik kısa açıklama

      ❗ Format dışına çıkma. Sadece başlık ve açıklama olsun.  
      ❗ Ürün adı ve açıklama dışında ekstra açıklama, numaralandırma veya sembol kullanma.  
      ❗ Kime, Neden, Yaş, Cinsiyet, İlgi Alanları ve Bütçe bilgileri eksik olsa bile, mevcut bilgilerle en uygun hediye önerilerini sun / varsayılanı gönderme.

      ''';

    try {
      final response = await _model.generateContent([Content.text(prompt)]);
      final text = response.text ?? "";
      print("HEY BURASI $text");
      return await _parseOnerilerWithImageSearch(text);
    } catch (e) {
      print("Hata: $e");
      return await _getOrnek3OneriWithImages(ilgiAlanlari);
    }
  }

  static Future<List<Oneri>> _parseOnerilerWithImageSearch(String metin) async {
    final lines = metin
        .split('\n')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    final List<Oneri> oneriler = [];

    for (int i = 0; i + 2 < lines.length; i += 3) {
      try {
        final baslik = lines[i].replaceFirst(RegExp(r'^\d+\.\s*'), '');

        final enBaslik = lines[i + 1];

        final aciklama = lines[i + 2].replaceFirst(
          RegExp(r'^\d+\.\s*Ürün Açıklama:\s*'),
          '',
        );

        final gorselUrl = await ImageSearchService.findGiftImage(enBaslik);

        oneriler.add(
          Oneri(baslik: baslik, gorselUrl: gorselUrl, aciklama: aciklama),
        );

        if (oneriler.length >= 3) break;
      } catch (_) {
        continue;
      }
    }

    return oneriler.isEmpty ? await _getOrnek3OneriWithImages([]) : oneriler;
  }

  static Future<List<Oneri>> _getOrnek3OneriWithImages(
    List<String> ilgiAlanlari,
  ) async {
    final ornekler = [
      {"baslik": "Bluetooth Kulaklık", "aciklama": "Kablosuz müzik keyfi"},
      {"baslik": "Kupa Bardak", "aciklama": "Sıcak içecekler için"},
      {"baslik": "Ajanda Seti", "aciklama": "Planlı bir yıl için"},
    ];

    return Future.wait(
      ornekler.map((ornek) async {
        final url = await ImageSearchService.findGiftImage(ornek["baslik"]!);
        return Oneri(
          baslik: ornek["baslik"]!,
          gorselUrl: url,
          aciklama: ornek["aciklama"]!,
        );
      }),
    );
  }
}
