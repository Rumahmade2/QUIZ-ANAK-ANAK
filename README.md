
Kuis anak-anak sederhana (materi contoh)

Project ini adalah contoh aplikasi kuis sederhana untuk anak-anak. Terdapat:

- Beranda: grid mata pelajaran
- Layar kuis: pertanyaan pilihan ganda, feedback langsung, dan skor

Cara menjalankan:

1. Pastikan Flutter sudah terpasang.
2. Jalankan: `flutter pub get` lalu `flutter run`.

File penting:
- `lib/screens/home_screen.dart` – beranda
- `lib/screens/quiz_screen.dart` – layar kuis
- `lib/data/sample_data.dart` – contoh pertanyaan
- **Fitur baru:** menyimpan riwayat skor (`shared_preferences`), timer per soal, layar hasil rinci (`lib/screens/history_screen.dart`, `lib/screens/result_screen.dart`), _dan pengaturan_ (`lib/screens/settings_screen.dart`)

Tambahan terbaru:
- Confetti saat hasil >= 80% (`confetti` package)
- Ekspor riwayat ke CSV (`lib/services/storage_service.dart` memakai `path_provider`)
- Dukungan multi-user sederhana: atur nama pengguna di Pengaturan (disimpan di `shared_preferences`)


## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

---

## Web troubleshooting (blank page / resource fetch errors)

If the Flutter web app shows a blank/white page or you see "Failed to fetch" errors in the browser console for fonts (fonts.gstatic.com) or CanvasKit (www.gstatic.com/flutter-canvaskit/...):

- Check DevTools Console and Network tabs for blocked requests (fonts or CanvasKit). If requests are blocked the engine may not initialize.
- Try opening the resource URL directly (e.g., a Roboto .woff2 or the CanvasKit JS file) to confirm whether your network / proxy / firewall / browser extension is blocking it.
- Try running with the HTML renderer (avoids CanvasKit) using a dart-define:

  flutter run -d chrome --dart-define=FLUTTER_WEB_USE_SKIA=false

- Or build the web app without using CDN-hosted web resources so the build bundles them locally:

  flutter build web --no-web-resources-cdn

  and then serve the `build/web/` directory with a simple static server (e.g., `python -m http.server 8000`).

- Try disabling adblocker/privacy extensions or running the browser in Incognito and retry.
- If the problem persists on your network, try tethering to a phone hotspot as a quick check.

These steps should resolve most blank/white pages caused by missing remote web assets.
