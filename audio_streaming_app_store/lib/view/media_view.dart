import 'package:flutter/material.dart';
import 'package:audio_streaming_app_store/bloc/media_bloc.dart';
import 'package:audio_streaming_app_store/bloc/playlist_bloc.dart';
import 'package:audio_streaming_app_store/events/media_event.dart';
import 'package:audio_streaming_app_store/model/category_media.dart';
import 'package:audio_streaming_app_store/model/current_media.dart';
import 'package:audio_streaming_app_store/model/media.dart';
import 'package:audio_streaming_app_store/model/playlist.dart';
import 'package:audio_streaming_app_store/model/playlist_in_store.dart';
import 'package:audio_streaming_app_store/network_provider/authentication_network_provider.dart';
import 'package:audio_streaming_app_store/repository/media_repository.dart';
import 'package:audio_streaming_app_store/view/playlist_in_store_view.dart';

import 'home_view.dart';

class MediaPage extends StatelessWidget {
  Playlist playlist;
  CurrentMedia curentMedia;
  int page;
  MediaPage(
      {Key key,
      @required this.playlist,
      @required this.curentMedia,
      @required this.page})
      : super(key: key);

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
      home: new MediaView(
          playlist: playlist, curentMedia: curentMedia, page: page),
    );
  }
}

class MediaView extends StatefulWidget {
  Playlist playlist;
  CurrentMedia curentMedia;
  int page;
  MediaView(
      {Key key,
      @required this.playlist,
      @required this.curentMedia,
      @required this.page})
      : super(key: key);
  @override
  _MediaViewState createState() => _MediaViewState();
}

class _MediaViewState extends State<MediaView> {
  MediaBloc _mediaBloc;
  List<Media> listMedia = new List();
  HomePageBloc _homePageBloc;

  bool isPress = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _mediaBloc = MediaBloc(mediaRepository: MediaRepository());
    _mediaBloc.add(PageCreateMedia(playlist: widget.playlist));
  }

  @override
  Widget build(BuildContext context) {
    print("aaa");
    if (widget.curentMedia != null) {
      print(widget.curentMedia.mediaId);
    }
    print(widget.page);
    return new WillPopScope(
      child: new Scaffold(
          // backgroundColor: Colors.blue[1000],
          resizeToAvoidBottomPadding: false,
          appBar: new AppBar(
              title: new Text(widget.playlist.PlaylistName),
              leading: new IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(
                    context,
                  );
                },
              ),
              backgroundColor: Colors.black26),
          backgroundColor: Colors.transparent,
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
                        image: NetworkImage(widget.playlist.ImageUrl),
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
                          widget.playlist.PlaylistName,
                          style: TextStyle(fontSize: 26.0),
                        ),
                        StreamBuilder(
                          stream: _mediaBloc.addPlaylist_stream,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return buildBt(snapshot.data);
                            } else if (snapshot.hasError) {
                              return Text(snapshot.error.toString());
                            }
                            return Center(child: CircularProgressIndicator());
                          },
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            StreamBuilder(
              stream: _mediaBloc.media_stream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  listMedia = snapshot.data;
                  return buildList(snapshot);
                } else if (snapshot.hasError) {
                  return Text(snapshot.error.toString());
                }
                return Center(child: CircularProgressIndicator());
              },
            ),
          ])),
      onWillPop: () async {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
        return true;
      },
    );
  }

  Widget buildList(snapshot) {
    return Expanded(
      child: ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: listMedia.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                decoration: new BoxDecoration(
                    border: Border(
                        bottom: BorderSide(width: 1, color: Colors.black)),
                    color: Color.fromARGB(255, 255, 255, 255)),
                child: new ListTile(
                  title: new Text(
                      (index + 1).toString() +
                          ". " +
                          listMedia[index].MusicName,
                      style: TextStyle(
                          fontSize: 17.0, fontWeight: FontWeight.bold,color: Colors.black)),
                  subtitle: new Text(
                    "  singer: " +
                        listMedia[index].Singer +
                        " ,author: " +
                        listMedia[index].Author,
                    style: TextStyle(fontSize: 14.0,color: Colors.black),
                  ),
                  // leading: Icon(Icons.library_music),
                  leading: currentPlay(widget.curentMedia, widget.playlist.Id,
                      listMedia[index].Id),
                  trailing: getCategory(listMedia[index].getListCategoryMedia),
                ));
          }),
    );
  }

  Widget buildBt(snapshot) {
    return new FlatButton(
      color: snapshot ? Colors.green : Colors.red,
      disabledColor: Colors.grey,
      disabledTextColor: Colors.black,
      padding: EdgeInsets.all(8.0),
      splashColor: Colors.blueAccent,
      onPressed: () {
        _mediaBloc.add(AddPlaylistToMyList(
            isMyList: snapshot,
            playlist: widget.playlist,
            accountId: currentUserWithToken.Id));
      },
      child: Text(
        snapshot ? "Remove Playlist" : "+Add Playlist",
        style: TextStyle(fontSize: 20.0),
      ),
    );
  }

  Text getCategory(List<CategoryMedia> listCategoryMedia) {
    String s = "#";
    listCategoryMedia.forEach((e) {
      s += e.getListCategory[0].getName + " #";
    });
    String s1 = s.substring(0, s.length - 1);
    return Text(
      s1,
      style: TextStyle(fontSize: 12),
    );
  }

  Icon currentPlay(
      CurrentMedia currentMedia, String playlisID, String mediaID) {
    if (currentMedia != null) {
      if (playlisID == currentMedia.playlistId &&
          mediaID == currentMedia.mediaId) {
        return new Icon(
          Icons.play_arrow,
          color: Colors.red,
          size: 40,
        );
      } else {
        return new Icon(
          Icons.play_arrow,
          color: Colors.white,
          size: 40,
        );
      }
    } else {
      return Icon(Icons.library_music, color: Colors.black,);
    }
  }
}
