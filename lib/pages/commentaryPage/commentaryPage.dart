import 'package:flutter/material.dart';
import 'package:noradio/YT/mainPlayer.dart';
import 'package:noradio/widgets/video/videoCommentaryShelf.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class CommentaryPage extends StatefulWidget {
  const CommentaryPage({Key? key}) : super(key: key);

  @override
  State<CommentaryPage> createState() => _CommentaryPageState();
}

class _CommentaryPageState extends State<CommentaryPage> {
  final MainPlayer player = MainPlayer();

  late ScrollController _scrollController;
  CommentsList? commenstList;
  Video? video;
  bool _initialListIsNotDone = true;

  @override
  void initState() {
    _scrollController = ScrollController(initialScrollOffset: 1000);
    _scrollController.addListener(_scrollListener);

    super.initState();
  }

  void getInitialCommentList(BuildContext context) {
    final arguments = ModalRoute.of(context)?.settings.arguments as Map;
    Video video = arguments['videoCommentaryOf'] as Video;
    player.getComments(video).then((list) {
      commenstList = list;
      setState(() {
        commenstList;
        _initialListIsNotDone = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Builder(
        builder: (context) {
          if (_initialListIsNotDone) {
            getInitialCommentList(context);
          }
          if (commenstList != null) {
            return Expanded(
                child: RefreshIndicator(
              onRefresh: _refreshIndicator,
              child: ListView.builder(
                  reverse: true,
                  controller: _scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: commenstList!.length,
                  itemBuilder: (context, int pos) {
                    return InkWell(
                        // onLongPress: () => seeVideoDescription(pos),
                        // onTap: () => _setCurrentAudioAndPlay(pos),
                        child: _buildVideoCommentarySingleShelf(pos));
                  }),
            ));
          } else {
            return Text('Комментариев нету');
          }
        },
      ),
    );
  }

  //to be done
  CommentaryPageSingleShelf _buildVideoCommentarySingleShelf(int pos) {
    return CommentaryPageSingleShelf(commenstList!.elementAt(pos));
  }

  Future<void> _refreshIndicator() async {
    player.getCommentaryNextPage(commenstList!).then((newList) {
      if (newList == null) {
        //
      } else {
        _scrollController
            .jumpTo(_scrollController.positions.first.maxScrollExtent);
        setState(() {
          commenstList = newList;
        });
      }
    });
  }

  _scrollListener() {}
}
