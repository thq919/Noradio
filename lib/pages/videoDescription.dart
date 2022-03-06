import 'package:flutter/material.dart';
// import 'package:noradio/listVideoProvider/listVideoProvider.dart';
// import 'package:noradio/widgets/bottom_menu/customBottomSheet.dart';
// import 'package:provider/provider.dart';
// import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class VideoDescription extends StatelessWidget {
  const VideoDescription({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)?.settings.arguments as Map;
    Video videoToShow = arguments['videoDescriptionOf'] as Video;
    
    return Scaffold(
        appBar: AppBar(),
        body: Container(
          child: Column(children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  ListView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    // padding: const EdgeInsets.all(8),
                    children: [
                      Container(
                        child: Image.network(videoToShow.thumbnails.highResUrl),
                      ),
                      Text(videoToShow.title),
                      Text(videoToShow.author),
                    ],
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Container(
                      decoration: const BoxDecoration(
                          border: Border.fromBorderSide(
                              BorderSide(color: Colors.black12)),
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20))),
                      child: ButtonBar(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.comment),
                            onPressed: () {
                              Navigator.pushNamed(context, '/videoCommentary',
                                  arguments: {
                                    'videoCommentaryOf': videoToShow
                                  });

                              //Открыть новую страницу с комментариями наподобии VideoList
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.flip_to_front),
                            onPressed: () {
                              canLaunch(videoToShow.url)
                                  .then((canLaunch) async {
                                if (canLaunch) {
                                  await launch(videoToShow.url);
                                }
                              });
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.description),
                            onPressed: () {
                              //Показать страницу с описанием видео
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.share),
                            onPressed: () {
                              //Скачать модуль и расшарить с другим приложением
                            },
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            )
          ]),
        ));
  }
}


