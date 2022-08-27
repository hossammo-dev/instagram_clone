import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/shared/network/local/cache_helper.dart';

import '../../../models/user_model.dart';
import '../../constants.dart';
import '../../network/remote/firebase_services.dart';
import '../../widgets/components.dart';
import 'auth_states.dart';

class AuthCubit extends Cubit<AuthStates> {
  AuthCubit() : super(AuthInitState());

  static AuthCubit get(BuildContext context) => BlocProvider.of(context);

  bool _isLogin = true;
  bool get isLogin => _isLogin;

  bool _showPass = true;
  bool get showPass => _showPass;

  //log user in
  Future<bool> logUserIn(
      {required String email, required String password}) async {
    late bool _success;
    await FirebaseServices.login(email: email, password: password).then((user) {
      Constants.userId = user.user!.uid;
      CacheHelper.save(key: 'uid', data: Constants.userId);
      debugPrint('-- ${Constants.userId}');
      emit(AuthLoginSuccessState());
      _success = true;
    }).catchError(
      (error) {
        defaultToast(
          message: error.toString(),
          bgColor: Colors.red,
          txColor: Colors.white,
        );
        emit(AuthLoginErrorState());
        _success = false;
      },
    );
    return _success;
  }

  //create new user
  Future<bool> createNewUser({
    required String email,
    required String password,
    required String username,
    required String phoneNumber,
  }) async {
    late bool _success;
    await FirebaseServices.register(email: email, password: password)
        .then((user) {
      Constants.userId = user.user!.uid;
      CacheHelper.save(key: 'uid', data: Constants.userId);
      UserModel _user = UserModel(
        uid: Constants.userId,
        username: username,
        email: email,
        phoneNumber: phoneNumber,
        avatarUrl: Constants.userImage,
        bio: '',
        posts: [],
        likedPosts: [],
        bookmarks: [],
      );
      FirebaseServices.save(
        collection: 'users',
        docId: Constants.userId,
        data: _user.toJson(),
      );
      defaultToast(
        message: 'User created successfully',
        bgColor: Colors.green,
        txColor: Colors.white,
      );
      emit(AuthRegisterSuccessState());
      _success = true;
    }).catchError(
      (error) {
        defaultToast(
          message: error.toString(),
          bgColor: Colors.red,
          txColor: Colors.white,
        );
        emit(AuthRegisterErrorState());
        _success = false;
      },
    );
    return _success;
  }

  //log user out
  Future<void> logUserOut() async {
    await FirebaseServices.logout().then((_) {
      emit(AuthLogoutSuccessState());
    }).catchError((error) {
      debugPrint(error.toString());
      emit(AuthLogoutSuccessState());
    });
  }

  //change pass state
  void changePassVisibility() {
    _showPass = !_showPass;
    emit(AuthChangePassState());
  }

  //change page state
  void changePageState() {
    _isLogin = !_isLogin;
    emit(AuthChangePageState());
  }
}
