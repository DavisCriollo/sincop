import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sincop_app/src/utils/responsive.dart';
import 'package:sincop_app/src/utils/theme.dart';

class VideoScreenPage extends StatefulWidget {
  const VideoScreenPage({Key? key}) : super(key: key);

  @override
  State<VideoScreenPage> createState() => _VideoScreenPageState();
}

class _VideoScreenPageState extends State<VideoScreenPage> {
  @override
  Widget build(BuildContext context) {
    Responsive size = Responsive.of(context);
    final url = ModalRoute.of(context)!.settings.arguments;
    url as String;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        // backgroundColor: primaryColor,
        title: Text(
          'Video',
          style: GoogleFonts.lexendDeca(
              fontSize: size.iScreen(2.45),
              color: Colors.white,
              fontWeight: FontWeight.normal),
        ),
         flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomCenter,
                  colors: <Color>[
                    Color(0XFF153E76),
                    Color(0XFF0076A7),
                   
                   
                   
                    // Color(0XFF005B97),
                    // Color(0XFF0075BE),
                    // Color(0XFF1E9CD7),
                    // Color(0XFF3DA9F4),
                  ],
                ),
              ),
            ),
      ),
      body: Container(
        color: primaryColor,
        width: size.wScreen(100),
        height: size.hScreen(100),
        child: BetterPlayer.network(
          url,
          betterPlayerConfiguration: const BetterPlayerConfiguration(
            aspectRatio: 16 / 16,
          ),
        ),
      ),
    );
  }
}
