class BannedWord {
    String id;
  final String word;
    final DateTime createdAt;

  BannedWord({
    required this.id,
    required this.word,
     required this.createdAt,
   });

  factory BannedWord.fromMap(Map<String, dynamic> map) {
    return BannedWord(
      id: map['id'] ?? '',
      word: map['word'] ?? '',
       createdAt: DateTime.parse(map['createdAt']),
     );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'word': word,
       'createdAt': createdAt.toIso8601String(),
     };
  }
}