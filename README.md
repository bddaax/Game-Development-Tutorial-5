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
<summary><h2>Tutorial 3: Eksplorasi Mekanika Pergerakan Karakter</h2></summary>

Pada bagian Latihan Mandiri di Tutorial 3 ini, saya melakukan eksplorasi dan implementasi mekanika pergerakan karakter lanjutan (*Advanced 2D Movement*) untuk permainan tipe *platformer*. Entitas karakter utama (`Mr_player`) telah dikonfigurasi untuk menggunakan `AnimatedSprite2D` dengan transisi *state* animasi yang komprehensif serta ukuran *hitbox* yang bersifat dinamis.

### Implementasi Fitur dan Pemetaan Kontrol

Berikut adalah rincian mekanika pergerakan yang telah dikembangkan beserta pemetaan kontrol (*key mapping*) yang digunakan:

| Fitur / Aksi | Tombol Input | Deskripsi Implementasi Teknis |
| :--- | :---: | :--- |
| **Berjalan (*Walk*)** | <kbd>Kiri</kbd> / <kbd>Kanan</kbd> | Karakter bergerak secara horizontal dengan parameter kecepatan konstan. Orientasi visual karakter (*sprite*) akan dibalik secara otomatis (`flip_h`) menyesuaikan dengan arah vektor pergerakan. |
| **Lompat Udara (*Infinite Jump*)** | <kbd>Atas</kbd> | Karakter dapat melakukan lompatan, baik saat menyentuh pijakan (*floor*) maupun saat berada di udara tanpa batasan jumlah. Pemutaran animasi dimanipulasi melalui skrip untuk mengulang *frame* secara spesifik, sehingga menghasilkan efek visual berulang yang natural. |
| **Merunduk (*Crouch*)** | <kbd>Bawah</kbd> (Ditahan) | Karakter melakukan aksi merunduk. Secara teknis, dimensi vertikal pada objek `CollisionShape2D` (*hitbox*) direduksi secara dinamis menjadi 50% dari ukuran normalnya. Hal ini mengizinkan interaksi fisik karakter untuk melewati lorong atau celah rintangan yang sempit. |
| **Merangkak (*Crawl*)** | <kbd>Bawah</kbd> + <kbd>Kiri</kbd>/<kbd>Kanan</kbd> | Integrasi antara *state* merunduk dan pergerakan horizontal. Karakter tetap dapat berpindah posisi, namun dengan nilai translasi kecepatan yang telah dikalkulasi ulang dan direduksi (*crouch speed*). |
| **Melesat (*Dash*)** | <kbd>Shift</kbd> | Karakter mengabaikan limitasi kecepatan normal dan melesat maju selama 0.25 detik. Pada *state* ini, simulasi gravitasi dinonaktifkan sementara (`velocity.y = 0`), menghasilkan translasi horizontal murni ke arah hadap terakhir karakter. |

### Implementasi Visual Lingkungan
* **Infinite Parallax Background:** Latar belakang permainan diimplementasikan menggunakan arsitektur *node* `ParallaxBackground` dan `ParallaxLayer`. Menggunakan fitur *Mirroring*, tekstur latar belakang dirender secara berulang tanpa batas (*infinite loop*) menyesuaikan posisi kamera, sekaligus memberikan ilusi kedalaman spasial.

### Referensi Dokumentasi

[![CharacterBody2D](https://img.shields.io/badge/-CharacterBody2D-808080?style=for-the-badge&logo=godotengine&logoColor=white)](https://docs.godotengine.org/en/stable/classes/class_characterbody2d.html)
[![AnimatedSprite2D](https://img.shields.io/badge/-AnimatedSprite2D-808080?style=for-the-badge&logo=godotengine&logoColor=white)](https://docs.godotengine.org/en/stable/classes/class_animatedsprite2d.html)
[![ParallaxBackground](https://img.shields.io/badge/-ParallaxBackground-808080?style=for-the-badge&logo=godotengine&logoColor=white)](https://docs.godotengine.org/en/stable/classes/class_parallaxbackground.html)

</details>
</details>