# CryptoWise Flutter App

Aplikasi Mobile edukasi aset kripto berbasis gamifikasi dan simulasi trading real-time yang interaktif dan aman dengan tema dark gold.

## Struktur Project

```
lib/
├── main.dart                        # Entry point
├── theme/
│   └── app_theme.dart               # Warna, teks style, konstanta
├── widgets/
│   └── common_widgets.dart          # Widget reusable (Button, TextField, dll)
└── screens/
    ├── onboarding_screen.dart       # Db1 & Db2 - swipeable onboarding
    ├── login_screen.dart            # Halaman Login
    └── register_screen.dart         # Halaman Daftar Akun + success banner
```

## Cara Menjalankan

### 1. Install dependencies
```bash
flutter pub get
```

### 2. Jalankan di emulator/device
```bash
flutter run
```

### 3. Build APK
```bash
flutter build apk --release
```

## Dependencies
- `smooth_page_indicator` - Untuk dot indicator di onboarding
- `google_fonts` - Font Playfair Display & Lato
- `fl_chart` - Untuk Menampilkan Chart Real-Time
- `webview_flutter` - Untuk Menampilkan Artikel 

## Screen yang sudah dibuat
- ✅ Onboarding Db1 (Invest in Cryptocurrency)
- ✅ Onboarding Db2 (Saving in Cryptocurrency)  
- ✅ Login Screen
- ✅ Daftar Akun (Register)
- ✅ Daftar Akun Success (banner hijau)
- ✅ Dashboard utama
- ✅ News / News Story
- ✅ News / Article
- ✅ Trade / Holdings
- ✅ Trade Chart
- ✅ Search
- ✅ Profile & Edit Profile
- ✅ Achievement
- ✅ Contact Support

## Backend berikutnya (perlu screenshot dari Figma)
- Login Screen
- Daftar Akun (Register)
- Profile & Edit Profile


## Color Palette
| Nama | Hex |
|------|-----|
| Background | #0A0A0A |
| Gold Primary | #B8860B |
| Gold Light | #D4A017 |
| Gold Bright | #FFD700 |
| Surface | #1A1A1A |
| Success | #4CAF50 |
