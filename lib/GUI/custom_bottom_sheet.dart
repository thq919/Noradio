import 'package:flutter/material.dart';

class Custom_bottom_sheet extends StatefulWidget {
  @override
  State<Custom_bottom_sheet> createState() => Custom_bottom_sheet_state();
}

class Custom_bottom_sheet_state extends State<Custom_bottom_sheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white60,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height / 8,
        child: ButtonBar(
          alignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: const Icon(Icons.volume_up),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.pause_outlined),
              onPressed: null,
            ),
            IconButton(
              icon: const Icon(Icons.play_arrow),
              onPressed: () {},
            )
          ],
        ));
  }
}
