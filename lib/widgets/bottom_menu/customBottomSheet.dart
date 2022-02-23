import 'package:flutter/material.dart';
import 'package:noradio/YT/mainPlayer.dart';
import 'package:noradio/utils.dart';
import 'package:noradio/widgets/video/videoSingleShelf.dart';
import 'package:provider/src/provider.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:noradio/listVideoProvider/listVideoProvider.dart';
import 'dynamicSlider.dart';

class CustomBottomSheet extends StatefulWidget {
  // final Video? currentVideo;
  // final int? currentVideoIndex;
  // final AudioOnlyStreamInfo? streamInfo;

  // const CustomBottomSheet(
  //     this.currentVideo, this.currentVideoIndex, this.streamInfo,
  //     {Key? key})
  //     : super(key: key);

  const CustomBottomSheet({Key? key}) : super(key: key);

  @override
  State<CustomBottomSheet> createState() => CustomBottomSheetState();
}

class CustomBottomSheetState extends State<CustomBottomSheet> {
  MainPlayer player = MainPlayer();
  //  late Video? currentVideo = widget.currentVideo;
  //  late int? currentVideoIndex = widget.currentVideoIndex;
  //  late Duration currentPosition;

  // @override
  // void didUpdateWidget(covariant CustomBottomSheet oldWidget) {
  //   currentVideo = widget.currentVideo;
  //   currentVideoIndex = widget.currentVideoIndex;
  //   super.didUpdateWidget(oldWidget);
  // }

  @override
  Widget build(BuildContext context) {
    ListVideoProviderModel model = context.watch<ListVideoProviderModel>();
    Video currentVideo = model.video;
    int currentVideoIndex = model.index;
    AudioOnlyStreamInfo streamInfo = model.streamInfo;

    return SizedBox(
      width: MediaQuery.of(context).size.width,
      // height: MediaQuery.of(context).size.height / 4,
      child: Container(
        decoration: const BoxDecoration(
            border: Border.fromBorderSide(BorderSide(color: Colors.black12)),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        child: Column(children: [
          Row(children: [
            ButtonBar(
              alignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: const Icon(Icons.downloading),
                  onPressed: () async {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      backgroundColor: Colors.grey,
                      content: Text('Аудиотрек: "' +
                          player.currentVideo.title +
                          '" сохраняется '),
                    ));
                    await saveToDir(player.currentVideo.title).then((isSaved) {
                      if (isSaved) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          backgroundColor: Colors.grey,
                          content: Text('Аудиотрек: "' +
                              player.currentVideo.title +
                              '" сохранен '),
                        ));
                      } else {
                        if (UtilsDebugMessage.runtimeType == String) {
                          var message = UtilsDebugMessage!;
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              backgroundColor: Colors.grey,
                              content: Text(
                                  ' При сохранении аудио произошла ошибка: $message')));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                              content: Text(
                                  ' При сохранении аудио произошла непридвиденная ошибка')));
                        }
                      }
                    });
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.volume_up),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.pause),
                  onPressed: () => player.pause(),
                ),
                IconButton(
                  icon: const Icon(Icons.play_arrow),
                  onPressed: () => player.play(),
                ),
              ],
            ),
          ]),
          DynamicSlider(player),
          const Divider(),
          VideoSingleShelf(currentVideo)
        ]),
      ),
    );
  }
}
