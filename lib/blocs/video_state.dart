import 'package:stream_video/models/video.dart';

abstract class VideoState {}

class VideoLoading extends VideoState {}

class VideoLoaded extends VideoState {
  final List<Video> videos;
  VideoLoaded(this.videos);
}

class VideoError extends VideoState {
  final String error;
  VideoError(this.error);
}
