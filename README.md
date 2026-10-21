# Course Explorer v2 - Flutter Pertemuan 6
**Nama:** Febrian  
**NIM:** 2415051009  

## Struktur Arsitektur Project (`lib/`)

- **`models/`**: Menampung *data class* (`Course`) beserta fungsi *parsing* JSON (`fromJson`).
- **`services/`**: Menangani pembacaan data mentah (`CourseService`), seperti membaca file `student_data.json` menggunakan `rootBundle`.
- **`repositories/`**: Menjadi abstraksi data (`CourseRepository`) yang menghubungkan *Service* ke *Provider*.
- **`providers/`**: Mengelola *asynchronous state* dan *favorites* (`CourseProvider`), serta memicu pembaruan UI via `notifyListeners()`.
- **`screens/`**: Menampilkan halaman/layar utama aplikasi (`MainScreen`, `HomePage`, `CourseDetailPage`, `FavoritesPage`).
- **`widgets/`**: Menampung komponen UI yang dapat digunakan kembali (*reusable*), seperti `CourseCardReusable`.