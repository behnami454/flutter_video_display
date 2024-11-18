import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';

class CameraRecordingScreen extends StatefulWidget {
  final CameraDescription camera;

  const CameraRecordingScreen({required this.camera, Key? key}) : super(key: key);

  @override
  State<CameraRecordingScreen> createState() => _CameraRecordingScreenState();
}

class _CameraRecordingScreenState extends State<CameraRecordingScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  bool _isRecording = false;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(widget.camera, ResolutionPreset.high);
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _startOrStopRecording() async {
    try {
      if (_isRecording) {
        final videoFile = await _controller.stopVideoRecording();
        setState(() {
          _isRecording = false;
        });

        final appDir = await getApplicationDocumentsDirectory();
        final newPath = '${appDir.path}/${DateTime.now().millisecondsSinceEpoch}.mp4';
        await videoFile.saveTo(newPath);

        Navigator.pop(context, newPath);
      } else {
        await _controller.prepareForVideoRecording();
        await _controller.startVideoRecording();
        setState(() {
          _isRecording = true;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to record video.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Record Video'),
        backgroundColor: Colors.deepPurple,
      ),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return CameraPreview(_controller);
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _startOrStopRecording,
        backgroundColor: Colors.red,
        child: Icon(_isRecording ? Icons.stop : Icons.circle),
      ),
    );
  }
}
