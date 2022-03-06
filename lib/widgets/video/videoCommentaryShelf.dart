import 'package:flutter/material.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';


class CommentaryPageSingleShelf extends StatelessWidget {
  const CommentaryPageSingleShelf(this.comment, {Key? key}) : super(key: key);
  final Comment comment;

  @override
  Widget build(BuildContext context) {  
    return ListTile(
      
      title: Text(comment.author),
      subtitle: Text(comment.text),
    );
  }
}
