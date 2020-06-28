import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:audio_streaming_app_store/model/playlist.dart';
import 'package:audio_streaming_app_store/network_provider/authentication_network_provider.dart';
import 'package:audio_streaming_app_store/setting/setting.dart';

class PlayListNetWorkProvider {
  String baseUrl =
      Setting.baseUrl+'Playlists';

  List<Playlist> userFavoritePlaylists = new List();
  List<Playlist> top3playlist = new List();
  List<Playlist> playlists10 = new List();
  List<Playlist> seatchResult = new List();


  Future<List<Playlist>> getUserFavoritePlaylists() async {
    String url =
       baseUrl+'/users';
    final http.Response response = await http.get(url, headers: {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: 'Bearer ' + currentUserWithToken.Token
    });

    if (response.statusCode == 200) {
      List<dynamic> values = new List<dynamic>();
      values = json.decode(response.body);
      userFavoritePlaylists = new List();
      if (values.length > 0) {
        for (int i = 0; i < values.length; i++) {
          if (values[i] != null) {
            Map<String, dynamic> map = values[i];
            userFavoritePlaylists.add(Playlist.fromJson(map));
          }
        }
      }
      return userFavoritePlaylists;
    } else {
      throw Exception('Failed to load playlist');
    }
  }

  Future<List<Playlist>> getTop3Playlists() async {
    String url = baseUrl +
        '?IsSort=true&IsDescending=true&IsPaging=true&PageNumber=0&PageLimitItem=3&OrderBy=PlaylistName';
    final http.Response response = await http.get(url, headers: {
      HttpHeaders.contentTypeHeader: 'application/json',
    });
    if (response.statusCode == 200) {
      List<dynamic> values = new List<dynamic>();
      values = json.decode(response.body);
      top3playlist = new List();
      if (values.length > 0) {
        for (int i = 0; i < values.length; i++) {
          if (values[i] != null) {
            Map<String, dynamic> map = values[i];
            top3playlist.add(Playlist.fromJson(map));
          }
          
        }
      }
      return top3playlist;
    } else {
      throw Exception('Failed to load playlist');
    }
  }

  Future<List<Playlist>> getPlaylists(int page) async {
    String url = baseUrl +
        '?IsSort=false&IsDescending=false&IsPaging=true&PageNumber='+ page.toString() +'&PageLimitItem=10&OrderBy=PlaylistName';
    final http.Response response = await http.get(url, headers: {
      HttpHeaders.contentTypeHeader: 'application/json',
    });
    if (response.statusCode == 200) {
      List<dynamic> values = new List<dynamic>();
      values = json.decode(response.body);
      playlists10 = new List();
      if (values.length > 0) {
        for (int i = 0; i < values.length; i++) {
          if (values[i] != null) {
            Map<String, dynamic> map = values[i];
            playlists10.add(Playlist.fromJson(map));
          }
        }
      }
      return playlists10;
    } else {
      throw Exception('Failed to load playlist');
    }
  }
  Future<List<Playlist>> getPlaylistsBySearchkey(String searchkey) async {
    String url = baseUrl +
         '?IsSort=false&IsDescending=false&IsPaging=true&PageNumber=0&PageLimitItem=10&OrderBy=PlaylistName&SearchKey='+searchkey;
    final http.Response response = await http.get(url, headers: {
      HttpHeaders.contentTypeHeader: 'application/json',
    });
    if (response.statusCode == 200) {
      List<dynamic> values = new List<dynamic>();
      values = json.decode(response.body);
      seatchResult = new List();
      if (values.length > 0) {
        for (int i = 0; i < values.length; i++) {
          if (values[i] != null) {
            Map<String, dynamic> map = values[i];
            seatchResult.add(Playlist.fromJson(map));
          }
        }
      }
      return seatchResult;
    } else {
      throw Exception('Failed to load playlist');
    }
  }
}
