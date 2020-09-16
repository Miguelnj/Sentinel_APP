import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterappfdp/src/blocs/register/register_events.dart';
import 'package:flutterappfdp/src/blocs/register/resgister_states.dart';
import 'package:flutterappfdp/src/services/user_repository.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final UserRepository userRepository = UserRepository();

  @override
  RegisterState get initialState => RegisterInitial();

  @override
  Stream<RegisterState> mapEventToState(RegisterEvent event) async* {
    yield RegisterLoadingState();
    if (event is SignUpSubmitButtonPressed) {
      final response = await userRepository.registerUser(
          username: event.username,
          password: event.password,
          name: event.name,
          surname: event.surname);
      if (response == 1) yield RegisterSuccessfulState();
      else if(response == -1) yield UsernameAlreadyExistsState();
    }
  }
}
