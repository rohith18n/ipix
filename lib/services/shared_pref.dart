import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  SharedPref._();
  static final SharedPref _instence = SharedPref._();
  static SharedPref get instence => _instence;

  static const String name1 = 'name';

  late SharedPreferences sharedPref;

  initStorage() async {
    sharedPref = await SharedPreferences.getInstance();
  }

  setName(String name) async {
    await sharedPref.setString(name1, name);
  }

  signout() {
    log("signing out");

    sharedPref.remove(name1);
    log("signing out name1");
  }

  String? getName() => sharedPref.getString(name1);
}
