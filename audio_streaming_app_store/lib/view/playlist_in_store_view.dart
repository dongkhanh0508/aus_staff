import 'package:flutter/material.dart';
import 'package:audio_streaming_app_store/bloc/media_bloc.dart';
import 'package:audio_streaming_app_store/bloc/playlist_bloc.dart';
import 'package:audio_streaming_app_store/bloc/playlist_in_store_bloc.dart';
import 'package:audio_streaming_app_store/bloc/stores_bloc.dart';
import 'package:audio_streaming_app_store/events/home_page_event.dart';
import 'package:audio_streaming_app_store/events/media_event.dart';
import 'package:audio_streaming_app_store/events/playlist_in_store_event.dart';
import 'package:audio_streaming_app_store/model/category_media.dart';
import 'package:audio_streaming_app_store/model/category_playlist.dart';
import 'package:audio_streaming_app_store/model/current_media.dart';
import 'package:audio_streaming_app_store/model/media.dart';
import 'package:audio_streaming_app_store/model/playlist.dart';
import 'package:audio_streaming_app_store/model/playlist_in_store.dart';
import 'package:audio_streaming_app_store/network_provider/authentication_network_provider.dart';
import 'package:audio_streaming_app_store/repository/current_media_repository.dart';
import 'package:audio_streaming_app_store/repository/media_repository.dart';
import 'package:audio_streaming_app_store/repository/playlist_in_store_repository.dart';

import 'home_view.dart';
import 'media_view.dart';

class PlaylistInStoreStateless extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Audio Streaming',
      theme: new ThemeData(
          brightness: Brightness.dark,
          primaryColorBrightness: Brightness.dark,
          scaffoldBackgroundColor: Colors.transparent,
          canvasColor: Colors.black54),
      home: new PlaylistInStoreView(),
    );
  }
}

class PlaylistInStoreView extends StatefulWidget {
  @override
  _PlaylistInStoreState createState() => _PlaylistInStoreState();
}

class _PlaylistInStoreState extends State<PlaylistInStoreView> {
  PlaylistInStoreBloc _playlistInStoreBloc;
  List<PlaylistInStore> listPIS;
  List<CurrentMedia> listCurrentMedia;
  @override
  void initState() {
    super.initState();
    _playlistInStoreBloc = PlaylistInStoreBloc(
        playlistInStoreRepo: PlaylistInStoreRepository(),
        currentMediaRepo: CurrentMediaRepository());
    _playlistInStoreBloc.add(PageCreatePIS(store: checkedInStore));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: new AppBar(
          title: new Text("Playlist in store"),
          leading: new IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
              );
            },
          ),
        ),
        body: new Column(children: <Widget>[
          new Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(
                        "assets/pngtree-purple-brilliant-background-image_257402.jpg"),
                    fit: BoxFit.cover)),
            child: new Column(
              children: <Widget>[
                new Container(
                  alignment: Alignment.topCenter,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.25,
                  decoration: new BoxDecoration(
                    image: new DecorationImage(
                      image: AssetImage(
                          "assets/pngtree-purple-brilliant-background-image_257402.jpg"),
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ),
                new Container(
                  decoration: new BoxDecoration(
                      color: Color.fromARGB(100, 187, 171, 201)),
                  padding: EdgeInsets.fromLTRB(32, 10, 30, 10),
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      new Text(
                        checkedInStore.StoreName,
                        style: TextStyle(fontSize: 26.0),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          StreamBuilder(
                    stream: _playlistInStoreBloc.currentMedia_stream,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        listCurrentMedia=snapshot.data;
                        print("object");
                        print(listCurrentMedia[0].playlistId);
                        return new Container();
                      } else if (snapshot.hasError) {
                        return Text(snapshot.error.toString());
                      }
                      return Center(child: CircularProgressIndicator());
                    },
                  ),
          StreamBuilder(
            stream: _playlistInStoreBloc.pis_stream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                
                listPIS = snapshot.data;
                return buildList(snapshot);
              } else if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              }
              return Center(child: CircularProgressIndicator());
            },
          ),
        ]),
        bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            title: Text('Business'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            title: Text('School'),
          ),
        ],
        // currentIndex: _selectedIndex,
        // selectedItemColor: Colors.amber[800],
        // onTap: _onItemTapped,
        ),
        );
  }

  Widget buildList(snapshot) {
    return Expanded(
      child: ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: listPIS.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                decoration:
                    new BoxDecoration(color: Color.fromARGB(50, 187, 171, 201)),
                child: new ListTile(
                  title: new Text(
                      (index + 1).toString() +
                          ". " +
                          listPIS[index].playlistName,
                      style: TextStyle(
                          fontSize: 17.0, fontWeight: FontWeight.bold)),
                  subtitle: getCategory(listPIS[index].listCategoryPlaylists),
                  leading: Icon(Icons.library_music),
                  trailing: currentPlay(listCurrentMedia[0], listPIS[index]),
                  onTap: (){
                    Playlist playlist =new Playlist(
                      Id: listPIS[index].playlistId,
                      PlaylistName: listPIS[index].playlistName,
                      ImageUrl: listPIS[index].imageUrl,                     
                    );
                    int x=2;
                    Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  MediaPage(playlist: playlist,curentMedia: listCurrentMedia[0],page: x)),
                        );
                  },
                ));
          }),
    );
  }

  Text getCategory(List<CategoryPlaylist> listCategoryMedia) {
    String s = "#";
    listCategoryMedia.forEach((e) {
      s += e.listCategory[0].getName + " #";
    });
    String s1 = s.substring(0, s.length - 1);
    return Text(
      s1,
      style: TextStyle(fontSize: 12),
    );
  }
  Icon currentPlay(CurrentMedia currentMedia,PlaylistInStore list){
    if(list.playlistId == currentMedia.playlistId){
      return new Icon(Icons.play_arrow, color: Colors.red, size: 40,);
    }else{
      return new Icon(Icons.play_arrow, color: Colors.white, size: 40,);
    }
  }
}
