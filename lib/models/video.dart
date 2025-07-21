class Video {
  final String id;
  final String title;
  final String athleteName;
  final String event;
  final String uploadDate;
  final String? thumbnailUrl;
  final String? videoUrl;
  final String coachId;

  Video({
    required this.id,
    required this.title,
    required this.athleteName,
    required this.event,
    required this.uploadDate,
    this.thumbnailUrl,
    this.videoUrl,
    required this.coachId,
  });

  factory Video.fromMap(Map<String, dynamic> map, String id) {
    return Video(
      id: id,
      title: map['title'] ?? '',
      athleteName: map['athleteName'] ?? '',
      event: map['event'] ?? '',
      uploadDate: map['uploadDate'] ?? '',
      thumbnailUrl: map['thumbnailUrl'],
      videoUrl: map['videoUrl'],
      coachId: map['coachId'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'athleteName': athleteName,
      'event': event,
      'uploadDate': uploadDate,
      'thumbnailUrl': thumbnailUrl,
      'videoUrl': videoUrl,
      'coachId': coachId,
    };
  }
} 