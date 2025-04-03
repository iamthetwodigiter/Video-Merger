import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_merger/widgets/video_tile.dart';

class VideoList extends StatefulWidget {
  final List<XFile> videoPaths;
  const VideoList({super.key, required this.videoPaths});

  @override
  State<VideoList> createState() => _VideoListState();
}

class _VideoListState extends State<VideoList> {
  @override
  Widget build(BuildContext context) {
    return widget.videoPaths.isEmpty
        ? const Center(
            child: Text(
              'No videos selected',
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
                  'Selected Videos',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    itemCount: widget.videoPaths.length,
                    itemBuilder: (context, index) {
                      return VideoTile(
                        videoFile: widget.videoPaths[index],
                        fileName: 'Video ${index + 1}',
                        onDelete: () {
                          setState(() => widget.videoPaths.removeAt(index));
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
