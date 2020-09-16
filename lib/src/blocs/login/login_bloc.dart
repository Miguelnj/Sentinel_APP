import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterappfdp/src/blocs/auth/auth_bloc.dart';
import 'package:flutterappfdp/src/blocs/auth/auth_events.dart';
import 'package:flutterappfdp/src/services/user_repository.dart';
import 'login_events.dart';
import 'login_states.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final UserRepository userRepository = UserRepository();
  final AuthenticationBloc authenticationBloc;

  LoginBloc(this.authenticationBloc) : assert(authenticationBloc != null);

  @override
  LoginState get initialState => LoginInitial();

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is LoginButtonPressed) {
      yield LoginLoading();
      try {
        final response = await userRepository.authenticate(
          username: event.username,
          password: event.password,
        );
        if (response.indexOf('{') == -1) {
          authenticationBloc.add(LoggedInEvent(token: response));
          userRepository.persistUsername(event.username);
          yield LoginSucceed();
        } else
          yield LoginFailure(error: "Username or password is incorrect");
      } catch (error) {
        yield LoginFailure(error: error.toString());
      }
    }
  }
}
