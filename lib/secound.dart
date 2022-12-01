import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

// import 'package:getwidget/getwidget.dart';
import 'package:getwidget/getwidget.dart';

import 'package:on_audio_query/on_audio_query.dart';

class secound extends StatefulWidget {
  int index;
  List<SongModel> songs;

  secound(this.index, this.songs);

  @override
  State<secound> createState() => _secoundState();
}

class _secoundState extends State<secound> {
  PageController pageController = PageController();
  double current_time = 0;
  final player = AudioPlayer();
  bool play = false;

//===========================convert bmilisecound to hour =================================

  @override
  void initState() {
    super.initState();
    print("${widget.songs[widget.index].title}");

    player.onPositionChanged.listen((Duration p) {
      print('Current position: $p');
      setState(() {
        current_time = p.inMilliseconds.toDouble();
      });
    });
  }

  @override
  Widget build(BuildContext context) {

    String printDuration(Duration duration) {
      String twoDigits(int n) {
        if (n >= 10) return "$n";
        return "0$n";
      }

      String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
      String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
      if (duration.inHours > 0)
        return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
      else
        return "$twoDigitMinutes:$twoDigitSeconds";
    }


    return Scaffold(
      appBar: AppBar(
        title: Text("Show_Data"),
      ),
      body: PageView.builder(
        itemCount: widget.songs.length,
        scrollDirection: Axis.horizontal,
        controller: pageController,
        onPageChanged: (value) {
          setState(() {
            widget.index = value;
          });
        },
        itemBuilder: (BuildContext context, int index) {
          return Column(
            children: [
              SizedBox(
                height: 10,
              ),
              Text(
                "${widget.index}",
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
              ),
              Text("${widget.songs[widget.index].title}",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black)),
              Container(
                  height: 200,
                  width: 400,
                  margin: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("image/song.jpeg"),
                          fit: BoxFit.cover))),
              SizedBox(
                height: 10,
              ),
             Row(
               mainAxisAlignment: MainAxisAlignment.spaceAround,
               children: [

                 Text(printDuration(Duration(milliseconds:current_time.toInt()))),
                 Slider(
                   value: current_time,
                   onChanged: (value) async {
                     await player.seek(Duration(milliseconds: value.toInt()));
                   },
                   min: 0,
                   max: widget.songs[widget.index].duration!.toDouble(),
                 ),
                 Text(printDuration(Duration(milliseconds: widget.songs[widget.index].duration!.toInt())-Duration(milliseconds:current_time.toInt()))),
               ],
             ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GFButton(
                    onPressed: () {
                      setState(() {
                        if (widget.index >= 0) {
                          widget.index--;
                        }
                      });
                    },
                    text: "",
                    icon: Icon(Icons.arrow_back),
                    type: GFButtonType.outline,
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        if (play) {
                          await player.pause();
                        } 
                        else {
                          
                          String path = widget.songs[widget.index].data;
                          await player.play(DeviceFileSource(path));
                        }
                        setState(() {
                          play =! play;
                        });
                      },
                      child: play?Icon(Icons.pause):Icon(Icons.play_arrow)),
                  GFButton(
                    onPressed: () {
                      if (widget.index <= widget.songs.length) {
                        setState(() {
                          widget.index++;
                        });
                      }
                    },
                    text: "",
                    icon: Icon(Icons.arrow_forward_rounded),
                    type: GFButtonType.outline,
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
