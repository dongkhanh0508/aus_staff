import 'package:audio_streaming_app_store/model/brand.dart';
import 'package:audio_streaming_app_store/network_provider/brand_network_provider.dart';

class BrandRepository{
  BrandNetWorkProvider _brandNetWorkProvider = BrandNetWorkProvider();

  Future<List<Brand>> getBrandWithPlaylists(int page) async{
    return await _brandNetWorkProvider.getBrandsWithPlaylists(page);
  }
}
  