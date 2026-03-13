<a name="readme-top"></a>

<div align="center">
  
  <h1>🎮 Tutorial Game Development 2025/2026</h1>

  <p>
	<b>Brenda Po Lok Fahida</b> • 2306152304
  </p>

</div>

<br>

<div align="center">

[![TUTORIAL CSUI](https://img.shields.io/badge/-TUTORIAL_CSUI-EDC5BB?style=for-the-badge&logoColor=white)](https://csui-game-development.github.io/)
[![GODOT DOCS](https://img.shields.io/badge/-GODOT_DOCS-6B7F7E?style=for-the-badge&logo=godotengine&logoColor=white)](https://docs.godotengine.org/en/stable/getting_started/introduction/)
[![GITHUB](https://img.shields.io/badge/GitHub-181717?style=for-the-badge&logo=github&logoColor=white)](https://github.com/bddaax/Game-Development-Tutorial-3)

</div>

<br>

<details>
<summary><h2>Tutorial 5: Eksplorasi Animasi Spritesheet dan Audio</h2></summary>

Pada bagian Latihan Mandiri di Tutorial 5 ini, saya melakukan eksplorasi dan implementasi sistem animasi berbasis *spritesheet* serta integrasi audio ke dalam permainan *platformer*. Karakter utama (`Mr_Player`) diganti dengan aset *spritesheet* baru dari koleksi Kenney, dilengkapi dengan sistem pergerakan, animasi, interaksi objek baru, dan *audio feedback*.

### Implementasi Objek Baru: Player2 (Alien Pink)

Objek baru yang ditambahkan adalah **Player2**, sebuah karakter NPC berbasis `CharacterBody2D` yang menggunakan *spritesheet* `alienPink` dari koleksi aset gratis Kenney. Player2 berfungsi sebagai rintangan bergerak yang berpatroli secara otomatis di dalam level.

**Animasi Player2** menggunakan `AnimatedSprite2D` dengan tiga *state* animasi:

| Animasi | Kondisi |
| :--- | :--- |
| `stand` | Berhenti di ujung patrol atau saat pertama muncul (1 detik) |
| `walk` | Bergerak patroli kiri-kanan sepanjang 8 tile |
| `hurt` | Ketika bertabrakan dengan `Mr_Player` |

**Mekanika Patrol Player2:**
- Bergerak bolak-balik sejauh **8 tile (560px)** secara otomatis
- Diawali dengan animasi `stand` selama 1 detik
- Setiap kali sampai di ujung patrol → `stand` 1 detik → balik arah
- Dilengkapi deteksi tepi menggunakan *raycast* agar tidak jatuh dari platform
- Setelah kena *hit*, mundur sesaat → `stand` 0.5 detik → lanjut patroli ke arah semula

### Implementasi Fitur Mr_Player (Karakter Baru)

Karakter utama diganti dengan *spritesheet* baru dan sistem pergerakan yang diperluas:

| Fitur / Aksi | Tombol Input | Deskripsi |
| :--- | :---: | :--- |
| **Berjalan (*Walk*)** | <kbd>Kiri</kbd> / <kbd>Kanan</kbd> | Bergerak horizontal, sprite otomatis `flip_h` sesuai arah |
| **Lari (*Run*)** | Double tap <kbd>Kiri</kbd> / <kbd>Kanan</kbd> | Kecepatan 2x lipat selama ±0.8 detik, animasi dipercepat |
| **Multi-Jump** | <kbd>Atas</kbd> (max 5x) | Dapat melompat berulang kali di udara, maksimal 5 kali |
| **Climb** | Masuk area tangga + <kbd>Atas</kbd>/<kbd>Bawah</kbd> | Naik/turun tangga saat berada di `Area2D` bertanda ladder |
| **Hurt** | Tabrakan dengan Player2 | Animasi `hurt` + *knockback* mundur, lalu bisa bergerak kembali |

### Implementasi Interaksi Objek

Interaksi antara `Mr_Player` dan `Player2` dideteksi melalui `get_slide_collision()` pada `_physics_process`. Saat bertabrakan:

1. Kedua karakter memainkan animasi `hurt`
2. Keduanya mendapat *knockback* ke arah berlawanan (Mr_Player lebih jauh)
3. Terdapat *hit cooldown* 1 detik untuk mencegah *spam* tabrakan
4. Setelah animasi `hurt` selesai, keduanya kembali ke aktivitas normal

### Implementasi Audio

| Audio | Node | Kondisi Pemutaran |
| :--- | :--- | :--- |
| `opening.wav` | `AudioStreamPlayer` (Root) | Diputar otomatis saat game pertama dimulai |
| `background.mp3` | `BackgroundMusic` (Root) | Musik latar yang diputar terus-menerus (*loop*) selama game berjalan |
| `jump.wav` | `JumpSound` (Mr_Player) | Diputar setiap kali Mr_Player melompat (termasuk multi-jump) |
| `hurt.mp3` | `HurtSound` (Mr_Player) | Diputar saat Mr_Player bertabrakan dengan Player2 |

### Implementasi Fall Zone

Area jatuh diimplementasikan menggunakan `Area2D` bernama `Fall` yang diletakkan di bawah level. Saat `Mr_Player` memasuki area ini:

1. Input diblokir (*freeze*)
2. Animasi `jump` diputar sebagai efek jatuh
3. Player di-*respawn* ke posisi awal yang disimpan otomatis saat `_ready()`

### Referensi

[![CharacterBody2D](https://img.shields.io/badge/-CharacterBody2D-808080?style=for-the-badge&logo=godotengine&logoColor=white)](https://docs.godotengine.org/en/stable/classes/class_characterbody2d.html)
[![AnimatedSprite2D](https://img.shields.io/badge/-AnimatedSprite2D-808080?style=for-the-badge&logo=godotengine&logoColor=white)](https://docs.godotengine.org/en/stable/classes/class_animatedsprite2d.html)
[![AudioStreamPlayer](https://img.shields.io/badge/-AudioStreamPlayer-808080?style=for-the-badge&logo=godotengine&logoColor=white)](https://docs.godotengine.org/en/stable/classes/class_audiostreamplayer.html)
[![Area2D](https://img.shields.io/badge/-Area2D-808080?style=for-the-badge&logo=godotengine&logoColor=white)](https://docs.godotengine.org/en/stable/classes/class_area2d.html)
[![Kenney Assets](https://img.shields.io/badge/-Kenney_Assets-F7C948?style=for-the-badge&logoColor=black)](https://kenney.nl/assets)

</details>