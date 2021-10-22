import 'package:flutter/material.dart';
import 'package:beautycon/utils/utils.dart';

abstract class MainViewModel{
  void processLogin(BuildContext context, GlobalKey<ScaffoldState> scaffoldKey);
  Future<LOGIN_STATE> checkLoginState(BuildContext context, bool fromLogin,
      GlobalKey<ScaffoldState> scaffoldState);
}