abstract class AuthStates{}

class AuthInitState extends AuthStates{}
class AuthLoadingState extends AuthStates{}
class AuthChangePageState extends AuthStates{}
class AuthChangePassState extends AuthStates{}

//login states
class AuthLoginSuccessState extends AuthStates{}
class AuthLoginErrorState extends AuthStates{}

//register states
class AuthRegisterSuccessState extends AuthStates{}
class AuthRegisterErrorState extends AuthStates{}

//log use out states
class AuthLogoutSuccessState extends AuthStates{}
class AuthLogoutErrorState extends AuthStates{}
