
import 'package:audio_streaming_app_store/model/store.dart';
import 'package:audio_streaming_app_store/network_provider/store_network_provider.dart';

class StoresRepository {
  StoresNetWorkProvider storesNetWorkProvider = StoresNetWorkProvider();

  Future<Store> getMediaByplaylistId(String storeId) async{
   return await storesNetWorkProvider.getStoreById(storeId);
  }
  
}