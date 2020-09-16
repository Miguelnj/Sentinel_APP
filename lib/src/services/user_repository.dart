import 'package:flutter/foundation.dart';
import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:flutterappfdp/src/models/userModel.dart';
import 'package:flutterappfdp/src/services/users_api_provider.dart';

import '../../main.dart';

class UserRepository {
  final UsersApiProvider _usersApiProvider = UsersApiProvider();
  final userPool = new CognitoUserPool('USER POOL', 'COGNITO CLIENT ID');

  Future<String> authenticate({
    @required String username,
    @required String password,
  }) async {
    final cognitoUser = new CognitoUser(username, userPool);
    final authDetails = new AuthenticationDetails(
      username: username,
      password: password,
    );
    CognitoUserSession session;
    try {
      session = await cognitoUser.authenticateUser(authDetails);
    } on CognitoUserNewPasswordRequiredException catch (e) {
      session = await handleUserNewPasswordRequired(e, session, cognitoUser, password);
    } on CognitoUserMfaRequiredException catch (e) {
      print(e);
      return e.toString();
    } on CognitoUserSelectMfaTypeException catch (e) {
      print(e);
      return e.toString();
    } on CognitoUserMfaSetupException catch (e) {
      print(e);
      return e.toString();
    } on CognitoUserTotpRequiredException catch (e) {
      print(e);
      return e.toString();
    } on CognitoUserCustomChallengeException catch (e) {
      print(e);
      return e.toString();
    } on CognitoUserConfirmationNecessaryException catch (e) {
      print(e);
      return e.toString();
    } on CognitoClientException catch (e) {
      print(e.toString());
      return e.toString();
    } catch (e) {
      print(e);
      return e.toString();
    }
    return session.getIdToken().getJwtToken();
  }

  Future<CognitoUserSession> handleUserNewPasswordRequired(CognitoUserNewPasswordRequiredException e,
      CognitoUserSession session, CognitoUser cognitoUser, String password) async {
    if (e.requiredAttributes.isEmpty)
      session = await cognitoUser.sendNewPasswordRequiredAnswer(password);
    else {
      print(e.requiredAttributes);
      var attributes = {"family_name": "Unknown", "name": "Unkown"};
      session = await cognitoUser.sendNewPasswordRequiredAnswer(password, attributes);
    }
    return session;
  }

  Future<int> registerUser({@required username, @required password, @required name, @required surname}) async {
    final userAttributes = [
      new AttributeArg(name: 'family_name', value: surname),
      new AttributeArg(name: 'name', value: name),
    ];

    try {
      await userPool.signUp(username, password, userAttributes: userAttributes);
    } catch (e) {
      print(e);
      return -1;
    }
    return 1;
  }

  Future<void> deleteToken() async {
    await storage.delete(key: 'jwt');
    return;
  }

  Future<void> persistUsername(String username) async {
    await storage.write(key: 'username', value: username);
  }

  Future<String> getUsername() async {
    return await storage.read(key: 'username');
  }

  Future<void> persistToken(String token) async {
    await storage.write(key: 'jwt', value: token);
    return;
  }

  Future<bool> hasToken() async {
    String token = await storage.read(key: 'jwt');
    return token is String ? true : false;
  }

  static Future<String> getToken() async {
    return await storage.read(key: 'jwt');
  }

  Future<Map> getUsersBeginningWithGivenString(String username) =>
      _usersApiProvider.getUsersBeginningWithGivenString(username);

  Future<int> addAttendeeToEvent({@required String username, @required String eventId}) =>
      _usersApiProvider.addAttendeeToEvent(username: username, eventId: eventId);

  Future<User> getUserByUsername({@required String username}) =>
      _usersApiProvider.getUserByUsername(username: username);
}
