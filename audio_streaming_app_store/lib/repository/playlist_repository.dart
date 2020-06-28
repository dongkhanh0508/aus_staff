
import 'package:audio_streaming_app_store/model/playlist.dart';
import 'package:audio_streaming_app_store/network_provider/playlist_network_provider.dart';



class PlaylistRepository {
  PlayListNetWorkProvider playListNetWorkProvider = PlayListNetWorkProvider();

  Future<List<Playlist>> getUserFavoritesPlaylist() async{
   return await playListNetWorkProvider.getUserFavoritePlaylists();
  }
  Future<List<Playlist>> getTop3Playlists() async{
   return await playListNetWorkProvider.getTop3Playlists();
  }
  Future<List<Playlist>> getPlaylists(int page) async{
   return await playListNetWorkProvider.getPlaylists(page);
  }
   Future<List<Playlist>> getPlaylistsBySearchKey(String searchKey) async{
   return await playListNetWorkProvider.getPlaylistsBySearchkey(searchKey);
  }
}