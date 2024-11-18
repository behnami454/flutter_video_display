import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stream_video/blocs/video_bloc.dart';
import 'package:stream_video/blocs/video_event.dart';
import 'package:stream_video/blocs/video_state.dart';
import 'package:stream_video/ui/widgets/video_card_widget.dart';

class VideoListScreen extends StatelessWidget {
  const VideoListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    context.read<VideoBloc>().add(LoadVideos());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Video List'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      labelText: 'Search Videos',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.search),
                    ),
                    onChanged: (query) {
                      if (query.isEmpty) {
                        context.read<VideoBloc>().add(LoadVideos());
                      } else {
                        context.read<VideoBloc>().add(SearchVideos(query));
                      }
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: DropdownButton<String>(
                      value: 'All',
                      icon: const Icon(Icons.filter_list, color: Colors.deepPurple),
                      iconSize: 24,
                      elevation: 16,
                      style: const TextStyle(color: Colors.deepPurple),
                      onChanged: (String? newValue) {
                        if (newValue == 'All') {
                          context.read<VideoBloc>().add(LoadVideos());
                        } else {
                          context.read<VideoBloc>().add(FilterVideosByCategory(newValue!));
                        }
                      },
                      items: <String>['All', 'Education', 'Entertainment', 'Music']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    )),
              ],
            ),
          ),
          // Video list grid
          Expanded(
            child: BlocBuilder<VideoBloc, VideoState>(
              builder: (context, state) {
                if (state is VideoLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is VideoLoaded) {
                  if (state.videos.isEmpty) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                        child: Text('No videos available', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    );
                  }

                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: GridView.builder(
                      itemCount: state.videos.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 0.75,
                      ),
                      itemBuilder: (context, index) {
                        final video = state.videos[index];
                        return VideoCard(video: video);
                      },
                    ),
                  );
                } else if (state is VideoError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error, size: 64, color: Colors.red),
                        const SizedBox(height: 16),
                        Text(
                          'Error: ${state.error}',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            context.read<VideoBloc>().add(LoadVideos());
                          },
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                } else {
                  return const Center(child: Text('Unknown state'));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
