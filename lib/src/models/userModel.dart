class UserModel {
  User _user;

  UserModel.userFromJson(Map<String, dynamic> parsedJson) {
    _user = User(parsedJson['Item']);
  }

  User get user => _user;
}

class User{
  String username;
  String name;
  String surnames;

  User(user){
    username = user['username'];
    name = user['name'];
    surnames = user['surnames'];
  }

}