import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class EducasiScreen extends StatelessWidget {
  EducasiScreen({super.key});

  final Color mainColor = const Color.fromARGB(255, 119, 23, 245);

  Widget sectionTitle(String icon, String title) {
    return Row(
      children: [
        SvgPicture.asset(icon, width: 28),
        const SizedBox(width: 10),
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      appBar: AppBar(
        title: Text(
          'Education',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: mainColor,
        elevation: 2,
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),

        children: [
          /// 🎯 CARD TIPS — dibuat glossy + lembut
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white,
                  Colors.grey.shade100,
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withOpacity(.7)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(.06),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            padding: const EdgeInsets.all(16),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                sectionTitle("assets/svg/book.svg", "Tips Belajar Singkat"),
                const SizedBox(height: 12),

                tipBubble("Buat jadwal belajar 20–30 menit."),
                tipBubble("Belajar aktif, bukan hanya membaca."),
                tipBubble("Istirahat sebentar agar tetap fokus."),
              ],
            ),
          ),

          const SizedBox(height: 24),

          /// 🔥 HEADER KONSEP
          sectionTitle("assets/svg/math.svg", "Konsep Materi"),
          const SizedBox(height: 8),

          /// 📘 MATERIAL LIST — dibuat lebih hidup
          infoTile(
            icon: Icons.calculate,
            title: "Matematika — Pecahan",
            text:
                "Pecahan adalah bagian dari keseluruhan. Untuk penjumlahan, samakan penyebut terlebih dahulu.",
          ),

          infoTile(
            icon: Icons.edit_note,
            title: "Bahasa Indonesia — Menulis Ringkas",
            text:
                "Ambil poin utama saja dan tulis dengan kalimat singkat dan jelas.",
          ),

          infoTile(
            icon: Icons.science,
            title: "IPA — Metode Ilmiah",
            text: "Amati → Hipotesis → Uji → Analisis → Kesimpulan.",
          ),

          const SizedBox(height: 20),

          bottomCard(context),
        ],
      ),
    );
  }

  /// ✨ TIP BUBBLE LUCUT
  Widget tipBubble(String text) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300.withOpacity(.6)),
      ),
      child: Text(
        text,
        style: GoogleFonts.poppins(fontSize: 13.5),
      ),
    );
  }

  /// 📌 EXPANSION TILE CUSTOM
  Widget infoTile({
    required IconData icon,
    required String title,
    required String text,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white,
            Colors.grey.shade100,
          ],
        ),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.05),
            blurRadius: 15,
            offset: const Offset(0, 8),
          )
        ],
      ),

      child: Card(
        color: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),

        child: ExpansionTile(
          leading: Icon(icon, color: mainColor),
          title: Text(
            title,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              fontSize: 14.5,
            ),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                text,
                style: GoogleFonts.poppins(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 🎯 BOTTOM CTA CARD
  Widget bottomCard(BuildContext context) {
    return Card(
      color: Colors.blueGrey.shade50,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,

      child: Padding(
        padding: const EdgeInsets.all(18),

        child: Column(
          children: [
            Text(
              "Siap Belajar?",
              style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 6),

            Text(
              "Silakan pilih materi pada menu utama.",
              style: GoogleFonts.poppins(fontSize: 13),
            ),

            const SizedBox(height: 14),

            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: mainColor,
                padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),

              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Mulai belajar")),
                );
              },

              icon: const Icon(Icons.play_arrow),
              label: const Text("Mulai"),
            ),
          ],
        ),
      ),
    );
  }
}
