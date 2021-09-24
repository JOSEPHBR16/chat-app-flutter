import 'dart:io';

class Enviroment {
  static String apiUrl = Platform.isAndroid
      ? 'https://chat-app-server-tr.herokuapp.com/api'
      : 'https://chat-app-server-tr.herokuapp.com/api';
  static String socketUrl =
      Platform.isAndroid ? 'https://chat-app-server-tr.herokuapp.com' : 'https://chat-app-server-tr.herokuapp.com';
}
