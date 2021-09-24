
import 'dart:convert';

import 'package:chat_app/global/enviroment.dart';
import 'package:chat_app/models/login_response.dart';
import 'package:chat_app/models/usuario.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:http/http.dart' as http;

class AuthService with ChangeNotifier {

  Usuario? usuario;
  bool _autenticando = false;

  final _storage = new FlutterSecureStorage();

  bool get autenticando => this._autenticando;
  set autenticando( bool valor ) {
    this._autenticando = valor;
    notifyListeners();
  }

  static Future<String?> getToken() async {
    final _storage = new FlutterSecureStorage();
    final token = await _storage.read(key: 'token');
    return token;
  }

  static Future<void> deleteToken() async {
    final _storage = new FlutterSecureStorage();
    await _storage.delete(key: 'token');
  }

  Future<bool> login( String email, String password ) async {

    this.autenticando = true;

    final data = {
      'email': email,
      'password': password
    };

    final uri = Uri.parse('${ Enviroment.apiUrl }/login');

    final resp = await http.post(uri, 
      body: jsonEncode(data),
      headers: {
        'Content-Type': 'application/json'
      }
    );

    print( resp.body );
    this.autenticando = false;

    if(resp.statusCode == 200) {
      final loginReponse = loginReponseFromJson( resp.body );
      this.usuario = loginReponse.usuario;

      await this._guardarToken(loginReponse.token);

      return true;
    } else {
      return false;
    }
  }

  Future register( String nombre, String email, String password ) async {

    this.autenticando = true;

    final data = {
      'nombre': nombre,
      'email': email,
      'password': password
    };

    final uri = Uri.parse('${ Enviroment.apiUrl }/login/new');

    final resp = await http.post(uri, 
      body: jsonEncode(data),
      headers: {
        'Content-Type': 'application/json'
      }
    );

    print( resp.body );
    this.autenticando = false;

    if(resp.statusCode == 200) {
      final loginReponse = loginReponseFromJson( resp.body );
      this.usuario = loginReponse.usuario;

      await this._guardarToken(loginReponse.token);

      return true;
    } else {
      final respBody = jsonDecode(resp.body);
      return respBody['msg'];
    }
  }

  Future<bool> isLoggedIn() async {
    final token = await this._storage.read(key: 'token') ?? '';

    final uri = Uri.parse('${ Enviroment.apiUrl }/login/renew');

    final resp = await http.get(uri, 
      headers: {
        'Content-Type': 'application/json',
        'x-token': token
      }
    );

    print( resp.body );

    if(resp.statusCode == 200) {
      final loginReponse = loginReponseFromJson( resp.body );
      this.usuario = loginReponse.usuario;

      await this._guardarToken(loginReponse.token);

      return true;
    } else {
      this.logout();
      return false;
    }

    
  }

  Future _guardarToken( String token ) async {
    return await _storage.write(key: 'token', value: token);
  }

  Future logout() async {
    await _storage.delete(key: 'token');
  }
}