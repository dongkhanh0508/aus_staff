import 'package:audio_streaming_app_store/model/current_media.dart';
import 'package:audio_streaming_app_store/network_provider/current_media_network_provider.dart';

class CurrentMediaRepository {
  CurrentMediaNetWorkProvider currentMediaNetWorkProvider =CurrentMediaNetWorkProvider();

  Future<List<CurrentMedia>> getCurrentMediabyStoreId(String storeId) async{
   return await currentMediaNetWorkProvider.getCurrentMediabyStoreId(storeId);
  }
  
}