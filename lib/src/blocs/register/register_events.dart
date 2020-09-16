abstract class RegisterEvent {}

class SignUpSubmitButtonPressed extends RegisterEvent {
  final String username;
  final String password;
  final String name;
  final String surname;


  SignUpSubmitButtonPressed({this.username, this.password, this.name,
    this.surname}) :
        assert(username!=null,password!=null), assert(name != null, surname);

}