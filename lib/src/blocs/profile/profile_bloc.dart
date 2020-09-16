import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterappfdp/src/blocs/profile/profile_events.dart';
import 'package:flutterappfdp/src/blocs/profile/profile_states.dart';
import 'package:flutterappfdp/src/models/userModel.dart';
import 'package:flutterappfdp/src/services/user_repository.dart';
import 'package:flutterappfdp/src/services/upload_s3.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final UserRepository _userRepository = UserRepository();

  @override
  void onTransition(
      Transition<ProfileEvent, ProfileState> transition) {
    super.onTransition(transition);
  }

  @override
  ProfileState get initialState => InitState();

  @override
  Stream<ProfileState> mapEventToState(ProfileEvent event) async* {
    User _user;
    yield LoadingState();
    if(event is FetchUserEvent){
      String username = await _userRepository.getUsername();
      _user = await _userRepository.getUserByUsername(username: username);
      if(_user == null) yield ErrorFetchingState();
      else yield FetchedUserState(user: _user);
    }else if(event is IndexImageEvent){
      String username = await _userRepository.getUsername();
      final statusCode = await uploadFile(event.image, username + ".jpg");
      print("Response status for upload image: $statusCode");
      yield SuccessUploadIndexFaceState();
    }
  }
}
