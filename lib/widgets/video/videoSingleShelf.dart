import 'package:flutter/material.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';


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

class VideoSingleShelf extends StatelessWidget {
  const VideoSingleShelf(this.video, {Key? key}) : super(key: key);
  final Video video;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.network(video.thumbnails.lowResUrl),
      title: Text(video.title),
      subtitle: Text(video.author +
          "  " +
          video.duration!.toString().replaceAll('.000000', '').replaceAll('0:', '')),
    );
  }
}
