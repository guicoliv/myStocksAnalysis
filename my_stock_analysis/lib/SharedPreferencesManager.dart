import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesManager{

  static readSharedPreferencesEntries() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print("All the keys:${prefs.getKeys()}");
    return prefs.getKeys();
  }


  static save(String key, value) async  {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    print("saving: $value}");
    prefs.setString(key, json.encode(value));
  }

  static read(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String s = prefs.getString(key);
    if(s == null)
      return null;
    return json.decode(s);
  }

  static clean() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.clear();

  }

}