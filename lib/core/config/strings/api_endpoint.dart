

import '../../extensions/custom_extentions.dart';

class ApiEndpoint {

/// FakeStore base URL — all endpoints are relative to this.
  static const String baseUrl = "https://dummyjson.com/";
  static const String imageBaseUrl = "";


  ///--------------------------auth apis
  static String login = "auth/login".baseUrl;

  ///--------------------------product apis
  static String products = "/products".baseUrl;
  ///--------------------------post apis
  static String posts = "posts".baseUrl;

}
