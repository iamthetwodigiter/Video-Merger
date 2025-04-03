import 'dart:io';
import 'package:easy_video_editor/easy_video_editor.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_merger/widgets/custom_button.dart';
import 'package:video_merger/widgets/merged_list.dart';
import 'package:video_merger/widgets/video_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<XFile> _videoFiles = [];
  bool _isMerging = false;

  bool _showMerged = false;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickVideo({ImageSource source = ImageSource.gallery}) async {
    final result = await _picker.pickVideo(source: source);
    if (result != null) {
      setState(() => _videoFiles.add(result));
    }
  }

  Future<void> _mergeVideos() async {
    setState(() {
      _isMerging = true;
    });

    try {
      final editor = VideoEditorBuilder(videoPath: _videoFiles.first.path)
          .merge(otherVideoPaths: [..._videoFiles.skip(1).map((e) => e.path)]);
      final output = await editor.export();

      File(output!).copySync(
        '/storage/emulated/0/Documents/MergedVideos/${output.split("/").last}',
      );
      setState(() {
        _showMerged = true;
        _videoFiles.clear();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Merged video saved to Documents'),
        ),
      );
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error occurred while merging videos'),
        ),
      );
    } finally {
      setState(() {
        _isMerging = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(240, 240, 240, 1),
      appBar: AppBar(
        title: const Text(
          'Video Merger',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Stack(
        children: [
          SafeArea(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                children: [
                  const SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    spacing: 10,
                    children: [
                      CustomButton(
                        text: 'Camera',
                        icon: Icons.camera_alt,
                        onPressed: () => _pickVideo(source: ImageSource.camera),
                      ),
                      CustomButton(
                        text: 'Gallery',
                        icon: Icons.photo,
                        onPressed: () =>
                            _pickVideo(source: ImageSource.gallery),
                      ),
                      CustomButton(
                        text: 'Merged',
                        icon: Icons.merge_rounded,
                        onPressed: () {
                          setState(() {
                            _showMerged = !_showMerged;
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  if (!_showMerged) VideoList(videoPaths: _videoFiles),
                  if (_showMerged) MergedList(),
                  if (_videoFiles.isNotEmpty && !_showMerged)
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        setState(() => _isMerging = true);
                        _mergeVideos();
                      },
                      child: Text('Merge'),
                    ),
                ],
              ),
            ),
          ),
          if (_isMerging)
            Container(
              color: Colors.black54,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}
