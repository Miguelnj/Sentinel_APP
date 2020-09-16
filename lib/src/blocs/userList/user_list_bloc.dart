import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterappfdp/src/blocs/userList/user_list_events.dart';
import 'package:flutterappfdp/src/blocs/userList/user_list_states.dart';
import 'package:flutterappfdp/src/services/user_repository.dart';

class UserListBloc extends Bloc<UserListEvent, UserListState> {
  final UserRepository _userRepository = UserRepository();

  @override
  void onTransition(
      Transition<UserListEvent, UserListState> transition) {
    super.onTransition(transition);
  }

  @override
  UserListState get initialState => UninitializedState();

  @override
  Stream<UserListState> mapEventToState(UserListEvent event) async* {
    if(event is SearchUsersGivenTextEvent){
      Map response = await _userRepository.getUsersBeginningWithGivenString(event.input);
      if(response["statusCode"] != 200) yield ListOfUsersFetchedState(listOfUserNames: []);
      else yield ListOfUsersFetchedState(listOfUserNames: getListOfUserNamesGivenListOfUsers(response["items"]));
    }else if(event is StoreSelectedUserEvent){
      int responseStatus = await _userRepository.addAttendeeToEvent(username: event.username, eventId: event.eventId);
      print(responseStatus);
    }
  }
}

List<String> getListOfUserNamesGivenListOfUsers(List<dynamic> items){
  List<String> userNames = List<String>();
  for(int i=0;i<items.length;i++) userNames.add(items[i]["username"]);
  return userNames;
}
