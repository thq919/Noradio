import 'package:flutter/material.dart';
import 'package:noradio/YT/mainPlayer.dart';
import 'package:noradio/utils.dart';
import 'package:noradio/widgets/video/videoSingleShelf.dart';
import 'package:provider/src/provider.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:noradio/listVideoProvider/listVideoProvider.dart';
import 'dynamicSlider.dart';

class CustomBottomSheet extends StatefulWidget {
  final bool showVideoShelf;
  const CustomBottomSheet({Key? key, required this.showVideoShelf})
      : super(key: key);

  @override
  State<CustomBottomSheet> createState() => CustomBottomSheetState();
}

class CustomBottomSheetState extends State<CustomBottomSheet> {
  MainPlayer player = MainPlayer();

  @override
  Widget build(BuildContext context) {
    ListVideoProviderModel model = context.watch<ListVideoProviderModel>();

    late Video? currentVideo;
    late int? currentVideoIndex;
    late AudioOnlyStreamInfo? streamInfo;

    if (model.isVideoExist()) {
      currentVideo = model.video;
      currentVideoIndex = model.index;
      streamInfo = model.streamInfo;
    }
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
          if (model.isVideoExist()) DynamicSlider(player),
          if (model.isVideoExist()) const Divider(),
          if (model.isVideoExist()) VideoSingleShelf(currentVideo as Video),
        ]),
      ),
    );
  }
}
