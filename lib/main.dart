import 'package:flutter/material.dart';
import 'package:noradio/pages/videoDescription.dart';
import 'package:noradio/theme.dart';
import 'package:provider/provider.dart';
import 'listVideoProvider/listVideoProvider.dart';
import 'pages/homepage.dart';

void main() {
  runApp(const MyApp());
}



ListVideoProviderModel model = ListVideoProviderModel();
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
   
    return ChangeNotifierProvider(
     
            create: (_) => model,
  
      child: MaterialApp(
          title: 'TeleMatch',
          theme: MainTheme(),
          initialRoute: '/',
          routes: {
            '/': (context) => HomePage(title: 'main screen', model: model),
            '/videoDescription': (context) => const VideoDescription(),
          }),
    );
  }

}
