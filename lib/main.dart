import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'modules/splash/splash_screen.dart';
import 'shared/cubit/auth_cubit/auth_cubit.dart';
import 'shared/cubit/main_cubit/main_cubit.dart';
import 'shared/network/local/cache_helper.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  await CacheHelper.init();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => MainCubit()),
        BlocProvider(create: (context) => AuthCubit()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: Colors.black,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.black,
          ),
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
