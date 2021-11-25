import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class Video_single_shelf extends StatefulWidget {
  Video video;

  @override
  State<Video_single_shelf> createState() => Video_single_shelf_state();

  Video_single_shelf(this.video, {Key? key}) : super(key: key) {}
}
// пример содержания
// Video._internal(id: 6MsCsEhyvjI,
// title: Sarmat strategic missile system,
// author: Минобороны России,
// channelId: UCQGqX5Ndpm4snE0NTjyOJnA,
// uploadDate: 2018-11-25 10:37:29.793049,
// publishDate: null,
// description: ,
// duration: 0:00:51.000000,
// thumbnails: ThumbnailSet(videoId: 6MsCsEhyvjI),: [], engagement: Engagement(viewCount: 99071, likeCount: null, dislikeCount: null), isLive: false, watchPage: null

class Video_single_shelf_state extends State<Video_single_shelf> {
  late Video video = widget.video;
  late VideoId videoId = video.id;
  late String title = video.title;
  late String author = video.author;
  late ChannelId channelID = video.channelId;
  late DateTime? uploadDate = video.uploadDate;
  late DateTime? publishDate = video.publishDate;
  late Duration? duration = video.duration;
  late ThumbnailSet thumbnail = video.thumbnails;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Row(children: [
      Container(
        child: Image.network(thumbnail.lowResUrl),
        constraints: BoxConstraints(maxHeight: 100),
      ),
      Container(
          child: Text(title), constraints: BoxConstraints(maxHeight: 100)),
      Container(
          child: Text(author), constraints: BoxConstraints(maxHeight: 100)),
      Container(
          child: Text(duration.toString()),
          constraints: BoxConstraints(maxHeight: 100))
    ])
    );
  }
}
