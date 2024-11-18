import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stream_video/repositories/video_repository.dart';
import 'video_event.dart';
import 'video_state.dart';

class VideoBloc extends Bloc<VideoEvent, VideoState> {
  final VideoRepository videoRepository;

  VideoBloc(this.videoRepository) : super(VideoLoading()) {
    on<LoadVideos>((event, emit) async {
      emit(VideoLoading());
      try {
        final videos = await videoRepository.getVideos();
        emit(VideoLoaded(videos));
      } catch (e) {
        emit(VideoError(e.toString()));
      }
    });

    on<SearchVideos>((event, emit) async {
      try {
        final allVideos = await videoRepository.getVideos();

        final filteredVideos = allVideos.where((video) {
          return video.title.toLowerCase().contains(event.query.toLowerCase());
        }).toList();

        emit(VideoLoaded(filteredVideos));
      } catch (e) {
        emit(VideoError('Failed to search videos.'));
      }
    });

    on<FilterVideosByCategory>((event, emit) async {
      try {
        final allVideos = await videoRepository.getVideos();
        final filteredVideos = allVideos.where((video) => video.category == event.category).toList();
        emit(VideoLoaded(filteredVideos));
      } catch (e) {
        emit(VideoError('Failed to load videos.'));
      }
    });
  }
}
