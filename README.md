# Aplikasi Pemesanan Makanan Sederhana (Flutter BLoC/Cubit)

## Identitas Pembuat

| Keterangan | Detail |
| :--- | :--- |
| **Nama** | Luki Solihin |
| **NIM** | 23552011413 |
| **Departemen** | Teknik Informatika |
| **Kelas** | 23 CNS B |

---

## Soal Teori dan Jawaban

### 1. Jelaskan bagaimana state management dengan Cubit dapat membantu dalam pengelolaan transaksi yang memiliki logika diskon dinamis.

State management dengan Cubit sangat membantu dalam mengelola transaksi dengan logika diskon dinamis karena beberapa alasan utama:

* **Sentralisasi Logika Bisnis:** Cubit memungkinkan kita untuk memusatkan semua logika yang terkait dengan state (data pesanan) di satu tempat, yaitu di dalam `OrderCubit`. Logika diskon dinamis (seperti diskon 10% untuk total belanja di atas Rp100.000) dapat dengan mudah mengakses total harga dari Cubit dan menerapkannya di UI.
* **Pemisahan Tampilan dan Logika (Separation of Concerns):** Cubit memisahkan antara "apa yang ditampilkan" (UI/widget) dan "bagaimana data dikelola" (logika bisnis). Halaman `OrderSummaryPage` hanya perlu "mendengarkan" perubahan dari `OrderCubit`. Ketika state berubah, UI akan otomatis diperbarui untuk menampilkan total harga baru dan mengevaluasi kembali penerapan diskon total transaksi.
* **Reaktivitas dan Efisiensi:** Cubit secara efisien memberi tahu UI kapan harus membangun ulang. Hanya widget yang "mendengarkan" Cubit (seperti `BlocBuilder`) yang akan diperbarui saat state berubah. Ini memastikan perhitungan diskon dinamis selalu didasarkan pada data pesanan yang paling mutakhir.
* **Kemudahan Pengujian (Testability):** Karena logika bisnis terpusat di dalam Cubit dan terpisah dari UI, kita dapat dengan mudah membuat unit test untuk `OrderCubit` untuk memastikan semua fungsi, termasuk perhitungan diskun, berfungsi dengan benar dalam berbagai skenario.

### 2. Apa perbedaan antara diskon per item dan diskon total transaksi? Berikan contoh penerapannya dalam aplikasi kasir.

Perbedaan utamanya terletak pada **level penerapan diskon**:

| Jenis Diskon | Definisi | Contoh Penerapan di Proyek Ini | Contoh di Aplikasi Kasir |
| :--- | :--- | :--- | :--- |
| **Diskon Per Item** (Item-level Discount) | Diskon yang diterapkan pada satu atau beberapa item spesifik dalam sebuah transaksi. Diskon ini tidak bergantung pada total belanja. | Di `MenuModel`, ada properti `discount`. Misalnya, "Nasi Goreng" memiliki diskon 10%, yang langsung dipotong dari harganya. | Sebuah supermarket memberikan promo "Beli 1 Gratis 1" untuk produk sabun mandi, atau produk susu kaleng yang mendekati tanggal kedaluwarsa diberi diskon 50%. |
| **Diskon Total Transaksi** (Transaction-level Discount) | Diskon yang diterapkan pada subtotal dari keseluruhan transaksi setelah semua item dihitung. Biasanya, diskon ini memiliki syarat tertentu, seperti minimal total belanja. | Logika yang memberikan diskon 10% jika `subtotal` (total harga dari semua item) melebihi Rp100.000. | Pelanggan menggunakan kupon "Diskon 15% untuk total belanja di atas Rp500.000", atau potongan harga untuk pembayaran menggunakan kartu kredit Bank X dengan minimal transaksi Rp200.000. |

### 3. Jelaskan manfaat penggunaan widget Stack pada tampilan kategori menu di aplikasi Flutter.

Penggunaan widget `Stack` di `CategoryStackPage` untuk menampilkan menu berdasarkan kategori memberikan beberapa manfaat signifikan:

* **Efisiensi Penggunaan Ruang (Space Efficiency):** `Stack` memungkinkan beberapa widget (misalnya, `ListView` untuk setiap kategori menu) untuk ditumpuk di area yang sama. Dengan mengontrol visibilitasnya menggunakan widget `Offstage`, kita dapat menampilkan atau menyembunyikan daftar menu yang berbeda tanpa harus berpindah halaman.
* **Preservasi State (State Preservation):** Ini adalah manfaat terbesar dari penggunaan `Stack` dengan `Offstage`. Ketika sebuah widget disembunyikan oleh `Offstage`, **state** dari widget tersebut tetap terjaga. Jika pengguna telah menggulir ke bawah pada daftar 'Makanan', dan kemudian kembali lagi ke sana, posisi scroll akan dipertahankan.
* **Logika Navigasi yang Lebih Sederhana:** Daripada membuat rute navigasi terpisah untuk setiap kategori, kita dapat mengelola semuanya dalam satu halaman. Ini menyederhanakan logika navigasi dan pengelolaan state karena semua widget berbagi konteks `BlocProvider` yang sama.
* **Animasi dan Transisi yang Fleksibel:** `Stack` memberikan dasar yang kuat untuk menambahkan animasi transisi yang menarik saat beralih antar kategori, seperti efek *fade in/out* atau *slide*.

---
---

## Penjelasan Proyek Aplikasi

### Fitur Utama

1.  **Tampilan Menu Berdasarkan Kategori:** Pengguna dapat memilih antara kategori 'Makanan' dan 'Minuman'. Daftar menu akan berubah sesuai dengan kategori yang dipilih.
2.  **Manajemen Pesanan:** Pengguna dapat menambah atau mengurangi jumlah setiap item menu langsung dari kartu menu. Jumlah item yang dipesan akan ditampilkan di kartu menu.
3.  **Keranjang Belanja (Ringkasan Pesanan):** Pengguna dapat melihat semua item yang telah mereka pesan di halaman "Ringkasan Pesanan". Halaman ini dapat diakses melalui tombol ikon keranjang belanja.
4.  **Perhitungan Harga dan Diskon:** Aplikasi secara otomatis menghitung harga setelah diskon untuk setiap item. Jika total belanja melebihi Rp100.000, diskon tambahan sebesar 10% akan diterapkan secara otomatis pada total akhir.
5.  **Checkout:** Setelah memeriksa pesanan, pengguna dapat menekan tombol "Checkout", yang akan menghapus semua item dari keranjang dan menampilkan pesan konfirmasi.

### Struktur Proyek (State Management BLoC/Cubit)

| Folder/File | Deskripsi |
| :--- | :--- |
| `main.dart` | Titik masuk utama aplikasi, di mana state global (seperti `OrderCubit`) diinisialisasi dan halaman utama diatur. |
| `blocs/category_cubit.dart` | Mengelola state untuk kategori menu yang dipilih (Makanan/Minuman). |
| `blocs/order_cubit.dart` | Mengelola state untuk pesanan, termasuk daftar item, kuantitas, dan total harga. |
| `models/menu_model.dart` | Mendefinisikan model data untuk setiap item menu, termasuk properti seperti nama, harga, dan diskon. |
| `pages/category_stack_page.dart` | Halaman utama yang menampilkan kategori menu dan daftar item yang dapat dipesan. |
| `pages/order_summary_page.dart` | Halaman untuk melihat ringkasan pesanan, total harga, dan melakukan checkout. |
| `widgets/menu_card.dart` | Widget untuk menampilkan setiap item menu dalam bentuk kartu, lengkap dengan tombol untuk menambah atau mengurangi pesanan. |

### Alur Kerja Aplikasi

1.  Aplikasi dimulai di `CategoryStackPage`, menampilkan menu makanan secara default.
2.  Pengguna dapat beralih antara kategori "Makanan" dan "Minuman".
3.  Pengguna menambahkan item ke pesanan menggunakan tombol '+' pada `MenuCard`. Jumlah pesanan akan terlihat.
4.  Pengguna dapat mengurangi pesanan dengan tombol '-' atau menghapusnya dari pesanan jika jumlahnya menjadi nol.
5.  Pengguna menekan ikon keranjang belanja untuk pindah ke `OrderSummaryPage`.
6.  Di `OrderSummaryPage`, pengguna melihat rincian pesanan, subtotal, diskon (jika ada), dan total akhir.
7.  Pengguna menekan "Checkout" untuk menyelesaikan pesanan. Pesanan akan dikosongkan, dan pengguna akan kembali ke halaman menu.
