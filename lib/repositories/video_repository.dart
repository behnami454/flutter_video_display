import 'package:stream_video/models/video.dart';

class VideoRepository {
  Future<List<Video>> getVideos() async {
    final mockData = [
      {'id': 1, 'title': 'Video 1', 'path': 'assets/videos/video1.mp4', 'category': 'Education'},
      {'id': 2, 'title': 'Video 2', 'path': 'assets/videos/video2.mp4', 'category': 'Entertainment'},
      {'id': 3, 'title': 'Video 3', 'path': 'assets/videos/video3.mp4', 'category': 'Music'},
      {'id': 4, 'title': 'Video 4', 'path': 'assets/videos/video4.mp4', 'category': 'Education'},
    ];
    return mockData.map((data) => Video.fromJson(data)).toList();
  }
}
