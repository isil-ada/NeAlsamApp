import 'package:flutter/material.dart';
import 'package:flutter_application_btk/oneri.dart';
import 'package:url_launcher/url_launcher.dart';

class UrunSecDialog extends StatefulWidget {
  final Oneri oneri;

  const UrunSecDialog({super.key, required this.oneri});

  @override
  State<UrunSecDialog> createState() => _UrunSecDialogState();
}

class _UrunSecDialogState extends State<UrunSecDialog> {
  String secilenSite = '';

  final Map<String, String> siteAramaLinkleri = {
    'trendyol': 'https://www.trendyol.com/sr?q=',
    'amazon': 'https://www.amazon.com.tr/s?k=',
    'hepsiburada': 'https://www.hepsiburada.com/ara?q=',
    'n11': 'https://www.n11.com/arama?q=',
    'aliexpress': 'https://www.aliexpress.com/wholesale?SearchText=',
    'cimri': 'https://www.cimri.com/arama?q=',
    'google': 'https://www.google.com/search?q=',
  };

  List<String> get siteler => siteAramaLinkleri.keys
      .map((e) => e[0].toUpperCase() + e.substring(1))
      .toList();

  String _getAramaLink(String site, String urunAdi) {
    final query = Uri.encodeComponent(urunAdi);
    final key = site.toLowerCase().trim();

    return siteAramaLinkleri[key] != null
        ? '${siteAramaLinkleri[key]}$query'
        : '';
  }

  void _olusturVeGit() async {
    if (secilenSite.isEmpty) return;

    final link = _getAramaLink(secilenSite, widget.oneri.baslik);
    final uri = Uri.parse(link);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("🔗 Link açılamadı: $link")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Ürünü Hangi Sitede Aramak İstersin?"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButton<String>(
            hint: Text("Site Seç"),
            value: secilenSite.isEmpty ? null : secilenSite,
            onChanged: (value) {
              setState(() {
                secilenSite = value!;
              });
            },
            items: siteler.map((site) {
              return DropdownMenuItem<String>(value: site, child: Text(site));
            }).toList(),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text("İptal"),
        ),
        ElevatedButton(onPressed: _olusturVeGit, child: Text("Siteye Git")),
      ],
    );
  }
}
