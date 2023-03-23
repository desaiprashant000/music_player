import 'package:flutter/material.dart';
import 'package:music_player/first.dart';
import 'package:on_audio_query/on_audio_query.dart';

void main() {
  runApp(MaterialApp(
    home: music(),
    debugShowCheckedModeBanner: false,
  ));
}

class music extends StatefulWidget {
  const music({Key? key}) : super(key: key);

  @override
  State<music> createState() => _musicState();
}

class _musicState extends State<music> {
  OnAudioQuery _audioQuery = OnAudioQuery();

  Future<List<SongModel>> getsong() async {
    List<SongModel> songlist = await _audioQuery.querySongs();
    return songlist;
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Music Player"),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.music_note_sharp))
        ],
      ),
      body: FutureBuilder(
        future: getsong(),
        builder: (context, snapshot) {
          print(snapshot.connectionState);
          if (snapshot.connectionState == ConnectionState.done) {
            List<SongModel> val = snapshot.data as List<SongModel>;
            return ListView.builder(
              itemBuilder: (context, index) {
                SongModel songModel = val[index];
                return ListTile(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return fullscreen(val, index);
                      },
                    ));
                  },
                  title: Text('${songModel.title}'),
                  subtitle: Text('${songModel.album}'),
                  trailing: Text(printDuration(
                      Duration(milliseconds: songModel.duration!))),
                );
              },
              itemCount: val.length,
            );
          } else {
            return Container(
              child: Text('hello'),
            );
          }
        },
      ),
    );
  }
}
