import 'package:audioplayer/secound.dart';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

class home_page extends StatefulWidget {

  @override
  State<home_page> createState() => _home_pageState();
}

class _home_pageState extends State<home_page> {

  

  @override
  Widget build(BuildContext context) {
//=========================================================================
    OnAudioQuery  _audioQuery =OnAudioQuery();
    
    //Get Song.............

    Future<List<SongModel>> get_song()async {
      List<SongModel> songList=await _audioQuery.querySongs();
      // print(songList);
      return songList;
    }
//======================================================================

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
        title: Text(
          "AudioPlayer",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
      ),

      body:FutureBuilder(future: get_song(),builder: (context, snapshot) {
        if(snapshot.connectionState==ConnectionState.done)
          {
            List<SongModel> songs=snapshot.data as List<SongModel>;

            return ListView.builder(shrinkWrap: true,itemCount: songs.length,itemBuilder: (context, index) {
              SongModel s=songs[index];
               return InkWell(
                 onTap:() {
                   Navigator.push(context,MaterialPageRoute(builder: (context) {
                     return secound(index,songs);
                   },));
                 },
                 child: Card(
                   elevation: 10,
                   child: ListTile(
                     title: Text("${s.title}"),
                     subtitle: Text(printDuration(Duration(milliseconds: s.duration!.toInt()))),
                   ),
                 ),
               );
            },);
          }
        else
          {
            return Center(child: CircularProgressIndicator());
          }
      },),
    );
  }


}
