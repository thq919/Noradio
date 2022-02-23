/* import 'package:flutter/material.dart';
import 'package:noradio/pages/videoList.dart';
import 'package:noradio/widgets/searchBar/searchbarprovider.dart';
import 'package:provider/provider.dart';

class SearchBar extends StatelessWidget {
  const SearchBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<SearchBarModel>(builder: (context, model, child) {
      return TextFormField(
          controller: TextEditingController(
              text: context.watch<SearchBarModel>().searchQue),
          enableSuggestions: true,
          onFieldSubmitted: (searchQue) {
            context.read<SearchBarModel>().makeSearchQue(searchQue);
            context.findAncestorStateOfType<VideoListState>()?.fillListAndSetState(searchQue);
          });
    });
  }
} */
