import 'package:http/http.dart' as http;

class ImageSearchService {
  static Future<String> findGiftImage(String englishProductTitle) async {
    print("🎁 '$englishProductTitle' için görsel aranıyor...");

    final kategoriResmi = _getImageByCategory(englishProductTitle);
    if (kategoriResmi != null) {
      print("✅ Kategori eşleştirmesi ile görsel bulundu");
      return kategoriResmi;
    }

    final pexelsResult = await _pexelsSearch(englishProductTitle);
    if (pexelsResult.isNotEmpty) {
      print("✅ Pexels'ten görsel bulundu");
      return pexelsResult;
    }

    final loremPicsumResult = _getLoremPicsumImage(englishProductTitle);
    print("✅ Lorem Picsum ile görsel oluşturuldu");
    return loremPicsumResult;
  }

  static String? _getImageByCategory(String keyword) {
    return null;
  }

  static Future<String> _pexelsSearch(String keyword) async {
    final url = Uri.parse(
      "https://www.pexels.com/search/${Uri.encodeComponent(keyword)}/",
    );
    final headers = {"User-Agent": "Mozilla/5.0"};

    try {
      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        final regex = RegExp(r'<img[^>]+src="([^">]+)"');
        final match = regex.firstMatch(response.body);
        if (match != null) {
          return match.group(1) ?? '';
        }
      }
    } catch (_) {}
    return '';
  }

  static String _getLoremPicsumImage(String seed) {
    return "https://picsum.photos/seed/${Uri.encodeComponent(seed)}/400/300";
  }
}
