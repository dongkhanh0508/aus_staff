import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:audio_streaming_app_store/events/stores_event.dart';
import 'package:audio_streaming_app_store/model/store.dart';
import 'package:audio_streaming_app_store/repository/stores_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:audio_streaming_app_store/states/stores_state.dart';
import 'package:audio_streaming_app_store/utility/qr_scan.dart';
import 'package:shared_preferences/shared_preferences.dart';

Store checkedInStore = null;
class StoresBloc extends Bloc<StoresEvent, StoresState> {
  StoresRepository _storesRepository = StoresRepository();

  final _storeController = StreamController<Store>();
  StreamSink<Store> get store_sink => _storeController.sink;
  Stream<Store> get store_stream => _storeController.stream;

  final _statusCheckIn = StreamController();
  StreamSink get statusCheckIn_sink => _statusCheckIn.sink;
  Stream get statusCheckIn_stream => _statusCheckIn.stream;

  StoresBloc({@required StoresRepository storesRepository})
      : assert(storesRepository != null),
        _storesRepository = storesRepository;

  @override
  // TODO: implement initialState
  StoresState get initialState => Uninitialized();

  void getStatusForCheckin(){
    if(checkedInStore!=null){
      statusCheckIn_sink.add(true);
    }else{
      statusCheckIn_sink.add(false);
    }
  }

  @override
  Stream<StoresState> mapEventToState(StoresEvent event) async* {
    // TODO: implement mapEventToState
    if (event is QRCodeScan) {
      QRScan qrScan = QRScan();
      await qrScan.scan();
      String id = qrScan.barcode;
      if (id == '-1') {
        yield QRScanCancel(null);
      } else {

        final scanResult = await _storesRepository.getMediaByplaylistId(id);
        if (scanResult != null) {

          checkedInStore =scanResult;
        getStatusForCheckin();

          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString("storeId", scanResult.Id);
          store_sink.add(scanResult);
          yield QRScanSuccess(scanResult);
        } else {
          yield QRScanFail("Store QR Code is invalid!");
        }
      }
    }
    if(event is StatusCheckIn){
      await getStatusForCheckin();
      yield CheckIn(null);
    }
  }
}
