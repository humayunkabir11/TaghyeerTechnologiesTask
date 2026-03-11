

import '../../extensions/custom_extentions.dart';

class ApiEndpoint {

/// FakeStore base URL — all endpoints are relative to this.
  static const String baseUrl = "https://dummyjson.com/";
  static const String imageBaseUrl = "";


  ///--------------------------auth apis
  static String login = "auth/login".baseUrl;
  ///--------------------------user apis
  static String users = "users";
  ///--------------------------product apis
  static String products = "products";

}
