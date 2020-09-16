import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutterappfdp/src/models/userModel.dart';
import 'package:flutterappfdp/src/services/user_repository.dart';
import 'package:http/http.dart';

class UsersApiProvider{

  String apiURL = "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX";

  Future<Map> getUsersBeginningWithGivenString(String username) async{
    String jwt = await UserRepository.getToken();
    final response = await get(apiURL + "users?username=" + username,
        headers: {'Content-Type': 'application/json', 'Authorization': jwt});
    final decoded = json.decode(utf8.decode(response.bodyBytes));
    return {"statusCode": response.statusCode, "items": decoded["Items"]};
  }

  Future<int> addAttendeeToEvent({@required String username, @required String eventId}) async{
    String jwt = await UserRepository.getToken();
    String body = json.encode({"username":username});
    final response = await post(apiURL + "events/attendees/" + eventId,
        headers: {'Content-Type': 'application/json', 'Authorization': jwt}, body: body);
    return response.statusCode;
  }

  Future<User> getUserByUsername({@required String username}) async{
    String jwt = await UserRepository.getToken();
    final response = await get(apiURL + "users/" + username,
        headers: {'Content-Type': 'application/json', 'Authorization': jwt});
    print(response.statusCode);
    if (response.statusCode == 200)
      return UserModel.userFromJson(json.decode(utf8.decode(response.bodyBytes))).user;
    else
      throw Exception('Failed to get Data\n' + json.decode(utf8.decode(response.bodyBytes)).toString());
  }

}