class Ayah {
  final int numberInSurah;
  final String arab;
  final String translationId;
  final String? audioUrl;

  Ayah(
      {required this.numberInSurah,
      required this.arab,
      required this.translationId,
      this.audioUrl});

  factory Ayah.fromSutanlab(Map<String, dynamic> json) {
    return Ayah(
      numberInSurah: json['number']['inSurah'] as int,
      arab: json['text']['arab'] as String,
      translationId: json['translation']['id'] as String,
      audioUrl:
          (json['audio']?['primary'] as String?) ?? (json['audio'] as String?),
    );
  }
}
