class LaguModel {
  String? idLagu;
  String? judulLagu;
  String? artis;
  String? durasi;
  String? tahunRilis;
  String? foto;

  LaguModel(
      {required this.idLagu,
      required this.judulLagu,
      required this.artis,
      required this.durasi,
      required this.tahunRilis,
      required this.foto});

  LaguModel.fromJson(Map<String, dynamic> json) {
    idLagu = json['id_lagu'];
    judulLagu = json['judul_lagu'];
    artis = json['artis'];
    durasi = json['durasi'];
    tahunRilis = json['tahun_rilis'];
    foto = json['foto'];
  }
}
