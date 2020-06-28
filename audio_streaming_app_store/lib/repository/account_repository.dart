import 'dart:async';
import 'package:audio_streaming_app_store/model/account.dart';
import 'package:audio_streaming_app_store/network_provider/authentication_network_provider.dart';

class AccountRepository{
  FirebaseNetworkProvider firebaseNetworkProvider = new FirebaseNetworkProvider();
  AccountNetworkProvider accountNetworkProvider = new AccountNetworkProvider();


  Future<UserAuthenticated> SignInWithGoogle() async{
    return await firebaseNetworkProvider.signInWithGoogle();
  }
  Future<UserAuthenticated> LogInWithFacebook() async{
    return await firebaseNetworkProvider.loginWithFacebook();
  }
  Future<bool> SignOut() async{
    return await firebaseNetworkProvider.logout();
  }
  Future<bool> CheckLogin() async{
    return await firebaseNetworkProvider.checkLogin();
  }
  //  Future<UserAuthenticated> fetchUser() async{
  //   return await accountNetworkProvider.fetchUser();
  // }
}