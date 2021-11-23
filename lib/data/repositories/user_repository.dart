import 'dart:convert' as convert;

import 'package:happy_care/core/utils/shared_pref.dart';
import 'package:happy_care/data/models/user.dart';
import 'package:happy_care/data/services/user_api.dart';

class UserRepository {


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
      print(User.fromJson(result['data']['user']));
      return User.fromJson(result['data']['user']);
    } catch (_) {
      throw Exception("Can't get user information");
    }
  }
}
