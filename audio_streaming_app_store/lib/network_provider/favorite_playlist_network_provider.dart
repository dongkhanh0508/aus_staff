import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:audio_streaming_app_store/model/media.dart';
import 'package:audio_streaming_app_store/network_provider/authentication_network_provider.dart';
import 'package:audio_streaming_app_store/setting/setting.dart';

class FavoritePlaylistNetWorkProvider {
  String baseUrl =
      Setting.baseUrl+'FavoritePlaylists/';

  Future<bool> addFavoritePlaylist(String playlistId, String accountId) async{
    String jsonString = '{' +
        '"playlistId": "' +
        playlistId +
        '",' +
        '"accountId": "' +
        accountId +
        '"' +
        '}';
        final http.Response response =await http.post(baseUrl, headers: {
          HttpHeaders.contentTypeHeader: 'application/json'
        }, body: jsonString);
        if(response.statusCode == 200){
          return true;
        }else{
          return false;
        }
  }
  Future<bool> deleteFavoritePlaylist(String playlistId, String accountId) async{
        String url = baseUrl + playlistId + "/"+accountId;
        final http.Response response =await http.delete(url, headers: {
          HttpHeaders.contentTypeHeader: 'application/json'
        }, );
        if(response.statusCode == 200){
          return true;
        }else{
          return false;
        }
  }
}
