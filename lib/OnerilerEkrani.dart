import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_application_btk/oneri.dart';
import 'package:flutter_application_btk/UrunSecDialog.dart';

class OnerilerEkrani extends StatelessWidget {
  const OnerilerEkrani({super.key, required this.oneriler});

  final List<Oneri> oneriler;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.card_giftcard, color: Colors.white),
            SizedBox(width: 8),
            Text(
              "Öneriler",
              style: GoogleFonts.pangolin(
                fontSize: 30,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 195, 133, 163),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.purple.shade50, Colors.pink.shade50],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                "🎁 Hediye Önerileri",
                style: GoogleFonts.pangolin(
                  fontSize: 25,
                  fontWeight: FontWeight.w500,
                  color: const Color.fromARGB(255, 160, 58, 51),
                ),
              ),
              SizedBox(height: 16),
              Expanded(
                child: oneriler.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error_outline,
                              size: 64,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 16),
                            Text(
                              "Henüz öneri yok",
                              style: GoogleFonts.pangolin(
                                fontSize: 20,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: oneriler.length,
                        itemBuilder: (context, index) {
                          final oneri = oneriler[index];
                          return Card(
                            margin: EdgeInsets.symmetric(vertical: 8),
                            elevation: 8,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [Colors.white, Colors.purple.shade50],
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 6,
                                          ),
                                          decoration: BoxDecoration(
                                            color: const Color.fromARGB(
                                              255,
                                              195,
                                              133,
                                              163,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
                                          ),
                                          child: Text(
                                            "${index + 1}",
                                            style: GoogleFonts.pangolin(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 12),
                                        Expanded(
                                          child: Text(
                                            oneri.baslik,
                                            style: GoogleFonts.pangolin(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w600,
                                              color: const Color.fromARGB(
                                                255,
                                                116,
                                                17,
                                                10,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 12),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.network(
                                        oneri.gorselUrl,
                                        height: 150,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                              return Container(
                                                height: 150,
                                                width: double.infinity,
                                                color: Colors.grey.shade200,
                                                child: Icon(
                                                  Icons.image_not_supported,
                                                  size: 50,
                                                  color: Colors.grey,
                                                ),
                                              );
                                            },
                                        loadingBuilder:
                                            (context, child, loadingProgress) {
                                              if (loadingProgress == null)
                                                return child;
                                              return Container(
                                                height: 150,
                                                width: double.infinity,
                                                color: Colors.grey.shade200,
                                                child: Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                        color:
                                                            const Color.fromARGB(
                                                              255,
                                                              195,
                                                              133,
                                                              163,
                                                            ),
                                                      ),
                                                ),
                                              );
                                            },
                                      ),
                                    ),
                                    SizedBox(height: 12),
                                    Text(
                                      oneri.aciklama,
                                      style: GoogleFonts.pangolin(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    SizedBox(height: 16),
                                    ElevatedButton.icon(
                                      icon: Icon(Icons.shopping_cart_outlined),
                                      label: Text(
                                        "Ürüne Git",
                                        style: GoogleFonts.pangolin(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (_) =>
                                              UrunSecDialog(oneri: oneri),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
