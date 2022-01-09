// import 'dart:async';
import 'package:flutter/material.dart';
import 'package:telematch/GUI/video_single_shelf.dart';
import 'package:telematch/YT/youtube_handler.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class CustomBottomSheet extends StatefulWidget {
  Video currentVideo;
  int currentVideoIndex;
  AudioOnlyStreamInfo streamInfo;

  CustomBottomSheet(this.currentVideo, this.currentVideoIndex, this.streamInfo,
      {Key? key})
      : super(key: key);

  @override
  State<CustomBottomSheet> createState() => CustomBottomSheetState();
}

class CustomBottomSheetState extends State<CustomBottomSheet> {
  MainPlayer player = MainPlayer();
  late Video currentVideo = widget.currentVideo;
  late int currentVideoIndex = widget.currentVideoIndex;

  //  late Duration currentPosition;

  @override
  void didUpdateWidget(covariant CustomBottomSheet oldWidget) {
    setState(() {
      currentVideo = widget.currentVideo;
      currentVideoIndex = widget.currentVideoIndex;
    });
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      // height: MediaQuery.of(context).size.height / 4,
      child: Column(children: [
        Container(child: DynamicSlider(player)),
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
                icon: Icon(Icons.pause_outlined),
                onPressed: () => player.pause(),
              ),
              IconButton(
                icon: const Icon(Icons.play_arrow),
                onPressed: () => player.play(),
              )
            ],
          ),
        ]),
        VideoSingleShelf(currentVideo)
      ]),
    );
  }
}

class DynamicSlider extends StatefulWidget {
  final MainPlayer player;
  // final Video currentVideo;
  // final AudioOnlyStreamInfo streamInfo;

  const DynamicSlider(this.player, {Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _DynamicSliderState();
}

class _DynamicSliderState extends State<DynamicSlider> {
  double currentPosition = 1;

  @override
  void didUpdateWidget(covariant DynamicSlider oldWidget) {
    setState(() {
      currentPosition = 1;
    });
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return SliderTheme(
      data: SliderThemeData(
        overlayShape: SliderComponentShape.noOverlay,
      ),
      child: Slider(
          value: listenToSteps(),
          min: 0,
          max: widget.player.getVideoDuration()!.inSeconds.toDouble(),
          onChanged: (value) {
            setState(() {
              currentPosition = value;
            });
          },
          onChangeEnd: (double value) {
            widget.player.playPosition(value.toInt());
          }),
    );
  }

  double listenToSteps() {
    widget.player.getPositionedStream().listen((event) {
      setState(() {
        currentPosition = event.inSeconds.toDouble();
      });
    });
    return currentPosition;
  }
}
