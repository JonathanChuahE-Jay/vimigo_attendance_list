import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late VideoPlayerController _controller;
  late ChewieController _chewieController;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/Video/tutorial.mp4');
    _chewieController = ChewieController(
      videoPlayerController: _controller,
      autoPlay: true,
      looping: true,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  void navigateToAttendanceList() {
    Navigator.pushNamed(context, '/display');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[600],
        title: const Text('Welcome to vimigo attendance app'),
        centerTitle: true,
        elevation: 0,
        leading: Container(),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(
          vertical: 0.0,
          horizontal: 30.0,
        ),
        child: Column(
          children: <Widget>[
            Image.network(
              'https://vimigotech.com/wp-content/uploads/2021/06/vimigoTechnologies_partner_vimigo_colour@2x.png',
            ),
            const SizedBox(height: 16.0),
            Text(
              'Example video of how to operate this application',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                letterSpacing: 2.0,
                color: Colors.orange[600],
                fontFamily: 'IndieFlower',
              ),
            ),
            const SizedBox(height: 20.0),
            Expanded(
              child: Chewie(
                controller: _chewieController,
              ),
            ),
            const SizedBox(height: 16.0),
            GestureDetector(
              onTap: navigateToAttendanceList,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.account_box_outlined,
                    color: Colors.orange[600],
                  ),
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: Text(
                      'Click the icon to go to the attendance list!',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.orange[600],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
