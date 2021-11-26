import 'dart:convert' as convert;

import 'package:happy_care/core/utils/shared_pref.dart';
import 'package:happy_care/data/models/user.dart';
import 'package:happy_care/data/services/user_api.dart';
import 'package:happy_care/data/socket/socket_io_service.dart';

class UserRepository {
  final SocketIOService? _ioService;
  UserRepository({SocketIOService? ioService}) : _ioService = ioService;

  Future<bool> createNewUser(
      {required String email, required String password}) async {
    try {
      await UserApi().createNewUser(email, password);
      return true;
    } catch (_) {
      print(_ as Exception);
      return false;
    }
  }

  Future<bool> signIn({required String email, required String password}) async {
    try {
      String response = await UserApi().signIn(email, password);
      var result = convert.jsonDecode(response);
      String token = result['data']['token'];
      await SharedPrefUtils.setStringKey('token', token);
      return true;
    } catch (_) {
      print(_ as Exception);
      return false;
    }
  }

  Future<bool> signOut() async {
    try {
      String token = await SharedPrefUtils.getStringKey('token');
      _ioService!.signOut();
      await UserApi().signOut(token: token);
      return true;
    } catch (_) {
      return false;
    } finally {
      await SharedPrefUtils.removeStringKey('token');
    }
  }

  Future<User> getUserData() async {
    try {
      String token = await SharedPrefUtils.getStringKey('token');
      final response = await UserApi().getDataInformation(token);
      var result = convert.jsonDecode(response);
      print("===========CHECK CREATING USER============\n");
      print(User.fromJson(result['data']['user']));
      return User.fromJson(result['data']['user']);
    } catch (_) {
      await SharedPrefUtils.removeStringKey('token');
      throw Exception(_);
    }
  }

  Future<bool> updateInformation(
      {String? fullname, int? age, String? phone, String? address}) async {
    Map<String, dynamic> body = {
      "fullname": fullname,
      "age": age,
      "phone": phone,
      "address": address
    };

    String token = await SharedPrefUtils.getStringKey('token');
    return await UserApi().updateUserInformation(token: token, body: body);
  }
}
