import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_merger/widgets/video_player_widget.dart';

class VideoTile extends StatefulWidget {
  final XFile videoFile;
  final String fileName;
  final VoidCallback onDelete;
  const VideoTile({
    super.key,
    required this.videoFile,
    required this.fileName,
    required this.onDelete,
  });

  @override
  State<VideoTile> createState() => _VideoTileState();
}

class _VideoTileState extends State<VideoTile> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                VideoPlayerWidget(videoPath: widget.videoFile.path),
          ),
        );
      },
      child: Container(
        height: 75,
        padding: const EdgeInsets.all(10),
        margin: EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.blue,
              spreadRadius: 1,
              blurRadius: 5,
            ),
          ],
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(15),
              child: Icon(
                Icons.videocam_rounded,
                color: Colors.blue,
                size: 30,
              ),
            ),
            SizedBox(
              width: size.width - 135,
              child: Text(
                widget.fileName.split('.mp4').first,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Spacer(),
            GestureDetector(
              onTap: () {
                widget.onDelete();
              },
              child: Icon(
                Icons.delete,
                color: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
