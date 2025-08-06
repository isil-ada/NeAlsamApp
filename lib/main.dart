import 'package:flutter/material.dart';
import 'package:flutter_application_btk/GirisEkrani.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(HediyeApp());
}

class HediyeApp extends StatelessWidget {
  const HediyeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          iconTheme: IconThemeData(color: Colors.white, size: 30),
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 195, 133, 163),
          centerTitle: true,
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.card_giftcard, color: Colors.white, size: 35),
              SizedBox(width: 8),
              Text(
                "NeAlsam?",
                style: GoogleFonts.pangolin(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        body: GirisEkrani(),
      ),
    );
  }
}
