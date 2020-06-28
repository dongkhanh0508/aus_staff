import 'package:audio_streaming_app_store/model/playlist.dart';

class Store{
  String Id;
  String StoreName;
  String Address;
  String BrandId;

  Store({
    this.Id,
    this.StoreName,
    this.Address,
    this.BrandId,
  });
  factory Store.fromJson(Map<String, dynamic> json) {
    return new Store(
      Id: json['Id'],
      StoreName: json['StoreName'],
      Address: json['Address'],
      BrandId: json['BrandId'],
    );
  }

}