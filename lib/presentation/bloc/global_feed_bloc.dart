import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart';

import '../../data/constants.dart';
import '../../data/models/GlobalFeedModel.dart';

class GlobalFeedBloc {
  GlobalFeedModel? _globalFeedModel;

  //fetch data url
  Future<GlobalFeedModel?> fetchGlobalFeedFromURL() async {
    //get and store login details
    Map<String, String> headers = {
      "Accept": "*/*",
      "content-type": "application/json",
      "X-APP-AUTH-TOKEN": AppConstants.apiKey,
      "X-DEVICE-ID": AppConstants.deviceId,
    };
    //connected
    Response response = await post(Uri.parse(AppUrls.globalFeed), headers: headers);
    if (AppSettings.kDebugMode) {
      print("response: ${AppUrls.globalFeed}");
      print("response: ${response.headers}");
      print("response: ${response.body}");
      print("headers: $headers");
    }
    if (response.statusCode == 200) {
      //mad response to model
      Map json = jsonDecode(response.body);
      _globalFeedModel =  GlobalFeedModel.fromJson(json);

      return _globalFeedModel;
    } else {
        throw Exception('Failed to load news items');
    }
  }
}
