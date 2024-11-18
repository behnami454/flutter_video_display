abstract class VideoEvent {}

class LoadVideos extends VideoEvent {}

class SearchVideos extends VideoEvent {
  final String query;
  SearchVideos(this.query);
}

class FilterVideosByCategory extends VideoEvent {
  final String category;

  FilterVideosByCategory(this.category);
}
