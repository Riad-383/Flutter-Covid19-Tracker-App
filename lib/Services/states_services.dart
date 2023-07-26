import 'dart:convert';

import 'package:covid_tracker/Modal/worldstate_model.dart';
import 'package:covid_tracker/Services/Utilities/app_url.dart';
import 'package:http/http.dart' as http;

class StateServices {
  Future<WorldstateModel> getWorldStates() async {
    final respond = await http.get(Uri.parse(AppUrl.worldStatesApi));

    if (respond.statusCode == 200) {
      var data = jsonDecode(respond.body);
      return WorldstateModel.fromJson(data);
    } else {
      throw Exception('Error');
    }
  }
  Future<List<dynamic>> getCountryList() async {
  var data;
  final respond = await http.get(Uri.parse(AppUrl.countriesList));

  if (respond.statusCode == 200) {
     data = jsonDecode(respond.body);
    return data;
  } else {
    throw Exception('Error');
  }
}
}


