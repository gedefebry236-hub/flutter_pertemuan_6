# Course Data Manager (2415051009 - Febrian)

Aplikasi manajemen mata kuliah berbasis Flutter dengan integrasi database *real-time*.

## Cara Menjalankan
1. Pastikan Flutter SDK sudah terpasang.
2. Jalankan perintah `flutter pub get` di terminal.
3. Jalankan aplikasi dengan `flutter run -d chrome`.

## Arsitektur & Backend
*   **Backend:** Supabase (PostgreSQL & RESTful API).
*   **Arsitektur:** Menggunakan pemisahan struktur (UI Screens, Providers untuk State Management, Repositories, dan Services/Data Source).