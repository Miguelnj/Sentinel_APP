import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterappfdp/src/blocs/auth/auth_events.dart';
import 'package:flutterappfdp/src/blocs/auth/auth_states.dart';
import 'package:flutterappfdp/src/services/user_repository.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState>{

  UserRepository userRepository = new UserRepository();

  @override
  AuthenticationState get initialState => AuthenticationUninitialized();

  @override
  void onTransition(
      Transition<AuthenticationEvent, AuthenticationState> transition) {
    super.onTransition(transition);
  }

  @override
  Stream<AuthenticationState> mapEventToState(AuthenticationEvent event) async* {
    if (event is AppStartedEvent) {
      final bool hasToken = await userRepository.hasToken();

      if (hasToken) yield AuthenticationAuthenticated();
      else yield AuthenticationUnauthenticated();
    }

    if (event is LoggedInEvent) {
      yield AuthenticationLoading();
      await userRepository.persistToken(event.token);
      yield AuthenticationAuthenticated();
    }

    if (event is LoggedOutEvent) {
      yield AuthenticationLoading();
      await userRepository.deleteToken();
      yield AuthenticationUnauthenticated();
    }
  }
}