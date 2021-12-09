import 'package:flutter/material.dart';
import 'package:telematch/GUI/videoSingleShelf.dart';
import 'package:telematch/YT/youtubeHandler.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class CustomBottomSheet extends StatefulWidget {
  Video currentVideo;
  int currentVideoIndex;

  CustomBottomSheet(this.currentVideo, this.currentVideoIndex, {Key? key})
      : super(key: key);

  @override
  State<CustomBottomSheet> createState() => CustomBottomSheetState();
}

class CustomBottomSheetState extends State<CustomBottomSheet> {
  MainPlayer player = MainPlayer();
  bool IsVideoExist = false;

  late Video currentVideo = widget.currentVideo;
  late int currentVideoIndex = widget.currentVideoIndex;

  @override
  void didUpdateWidget(covariant CustomBottomSheet oldWidget) {
    setState(() {
      currentVideo = widget.currentVideo;
      currentVideoIndex = widget.currentVideoIndex;
    });
    super.didUpdateWidget(oldWidget);
  }

  void setVideo(Video currentVideo, int currentVideoIndex) {
    setState(() {
      this.currentVideo = currentVideo;
      this.currentVideoIndex = currentVideoIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      // height: MediaQuery.of(context).size.height / 8,
      child: Column(children: [
        Row(children: [
          ButtonBar(
            alignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(currentVideo.id.toString()),
              IconButton(
                icon: const Icon(Icons.volume_up),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.pause_outlined),
                onPressed: null,
              ),
              IconButton(
                icon: const Icon(Icons.play_arrow),
                onPressed: () {},
              )
            ],
          ),
        ]),
        VideoSingleShelf(currentVideo)
      ]),
    );

    // return Container(
    //     color: Colors.white60,
    //     width: MediaQuery.of(context).size.width,
    //     height: MediaQuery.of(context).size.height / 8,
    //     child: Column(
    //       children: [
    //         ButtonBar(
    //           alignment: MainAxisAlignment.spaceEvenly,
    //           children: [
    //             Text(currentVideo.id.toString()),
    //             IconButton(
    //               icon: const Icon(Icons.volume_up),
    //               onPressed: () {},
    //             ),
    //             IconButton(
    //               icon: const Icon(Icons.pause_outlined),
    //               onPressed: null,
    //             ),
    //             IconButton(
    //               icon: const Icon(Icons.play_arrow),
    //               onPressed: () {},
    //             )
    //           ],
    //         )
    //       ],
    //     ));
  }
}
