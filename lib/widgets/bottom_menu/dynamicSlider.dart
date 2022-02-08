import 'package:flutter/material.dart';
import 'package:noradio/YT/mainPlayer.dart';

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
  Duration currentDuration = Duration(seconds: 1);



  @override
  Widget build(BuildContext context) {
    return SliderTheme(
      data: SliderThemeData(
        overlayShape: SliderComponentShape.noOverlay,
      ),
      child: Slider(
          divisions: widget.player.getVideoDuration()!.inSeconds,
          label: Duration(seconds: listenToSteps().toInt())
              .toString()
              .replaceAll('.000000', ''),
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
      if(currentPosition==event.inSeconds.toDouble()) {
        //skip setState()
      } else {
        setState(() {
          currentDuration = event;
          currentPosition = event.inSeconds.toDouble();
        }); }
    });
    return currentPosition;
  }
}