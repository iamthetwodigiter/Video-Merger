import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_merger/widgets/video_tile.dart';

class MergedList extends StatefulWidget {
  const MergedList({super.key});

  @override
  State<MergedList> createState() => _MergedListState();
}

class _MergedListState extends State<MergedList> {
  @override
  void initState() {
    super.initState();
    _loadMergedVideos();
  }

  List<XFile> videoPaths = [];

  void _loadMergedVideos() async {
    await getExternalStorageDirectory();
    if (!Directory('/storage/emulated/0/Documents/MergedVideos/')
        .existsSync()) {
      Directory('/storage/emulated/0/Documents/MergedVideos/')
          .createSync(recursive: true);
    }
    final result = await getVideosFromDirectory(
        '/storage/emulated/0/Documents/MergedVideos/');
    setState(() => videoPaths = result);
  }

  getVideosFromDirectory(String path) {
    final directory = Directory(path);
    final videos = directory
        .listSync(recursive: true)
        .where((e) => e.path.endsWith('.mp4'))
        .map((e) => XFile(e.path))
        .toList();
    return videos;
  }

  void _showDeleteDialog(String path, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Video'),
        content: Text('Are you sure you want to delete this video?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              File(path).deleteSync();
              setState(() => videoPaths.removeAt(index));
              Navigator.pop(context);
            },
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return videoPaths.isEmpty
        ? const Center(
            child: Text(
              'No videos merged yet',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        : Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Merged Videos',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    itemCount: videoPaths.length,
                    itemBuilder: (context, index) {
                      return VideoTile(
                        videoFile: videoPaths[index],
                        fileName: videoPaths[index].path.split('/').last,
                        onDelete: () {
                          _showDeleteDialog(videoPaths[index].path, index);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          );
  }
}
