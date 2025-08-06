import 'package:flutter/material.dart';
import 'package:flutter_application_btk/SoruEkrani.dart';
import 'package:google_fonts/google_fonts.dart';

class GirisEkrani extends StatefulWidget {
  const GirisEkrani({super.key});

  @override
  State<StatefulWidget> createState() => _GirisEkraniState();
}

class _GirisEkraniState extends State<GirisEkrani> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SoruEkrani()),
          );
        },
        child: Text(
          "TIKLA",
          style: GoogleFonts.pangolin(
            fontSize: 40,
            fontWeight: FontWeight.w500,
            color: const Color.fromARGB(255, 195, 133, 163),
          ),
        ),
      ),
    );
  }
}
