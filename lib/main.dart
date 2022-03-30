import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'screens/challenges.dart';
import 'screens/authenticate.dart';
import 'screens/game_arena.dart';
import 'screens/sign_in.dart';

import 'services/auth.dart';

import 'validation/input_validation.dart';

import 'model/motus_grid.dart';
import 'model/motus_data.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final _userPlayer = AuthService();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider<AuthService?>.value(value: _userPlayer),
          //StreamProvider<User?>(create: (_) => _userPlayer.user,initialData: null),
          ChangeNotifierProvider<MotusGrid>(create: (_) => MotusGrid()),
          ChangeNotifierProvider<InputValidation>(
              create: (_) => InputValidation()),
          ChangeNotifierProvider<MotusData>(create: (_) => MotusData()),
        ],
       
        child: MaterialApp.router(
          // Routing initialization
          routeInformationParser: _router.routeInformationParser,
          routerDelegate: _router.routerDelegate,
          // Hide the debug banner
          debugShowCheckedModeBanner: false,
          title: 'Motus 2.0',
          theme: ThemeData(primarySwatch: Colors.blueGrey)
        ),
      ),
    );
  }

// Routes definitions
  late final GoRouter _router = GoRouter(
      debugLogDiagnostics: true,
      //refreshListenable: GoRouterRefreshStream(_userPlayer.user),
      refreshListenable: _userPlayer,
      initialLocation: '/',

      /* redirect: (state) {
        // if the user is not logged in, they need to login
        final loggedIn = _userPlayer.isLoggedIn;
        print('\x1B[32misLoggedIn: $loggedIn\x1B[0m');
        final loggingIn = state.subloc == '/auth/signin';
        print('\x1B[32mstate.subloc: ${state.subloc}\x1B[0m');
        if (!loggedIn) return loggingIn ? null : '/auth/signin';

        // if the user is logged in but still on the login page, send them to
        // the home page
        if (loggingIn) return '/';

        // no need to redirect at all
        return null;
      }, */
      

      routes: <GoRoute>[
        GoRoute(
          path: '/',
          builder: (BuildContext context, GoRouterState state) => MyHomePage(),
        ),
        GoRoute(
          path: '/arena',
          builder: (BuildContext context, GoRouterState state) {
            final mode = state.queryParams['mode'];
            return GameArena(mode: mode);
          }
        ),
        GoRoute(
          path: '/challenges',
          builder: (BuildContext context, GoRouterState state) {
            return Challenges();
          }
        ),
        GoRoute(
          path: '/auth',
          builder: (BuildContext context, GoRouterState state) => Authenticate(),
          routes: [
            GoRoute(
              path: 'signin',
              builder: (BuildContext context, GoRouterState state) => SignIn(),
            )
          ]
          )
      ]
  );
}

class  MyHomePage extends StatelessWidget {
  const MyHomePage({ Key? key }) : super(key: key);
  final title = 'Motus 2.0';

  @override
  Widget build(BuildContext context) {
    AuthService _userPlayer = Provider.of<AuthService>(context);
  
    // Showing validation message in snackbar
    void showMessage(BuildContext context, String _message) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
            Text(
              _message,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
            ),
            duration: (const Duration(seconds: 3)),
            elevation: 0,
            backgroundColor: Colors.black,
          ),
        );
    }

    return Scaffold(
      appBar: AppBar(
          title: Text(title),
          actions: <Widget>[
          TextButton.icon(
            onPressed: () {
              context.push('/auth');
            },
            icon: const Icon(
              Icons.person,
              color: Colors.white,
            ),
            label: const Text(
              'Sign in / Sign up',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
        ),
        body: 
        Center(
        child: Padding(
            padding: const EdgeInsets.fromLTRB(40, 40, 40, 40),
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                ),
                onPressed: () {
                   context.push('/arena?mode=practice');
                },
                child: const Text('Mode Entrainement'),
              ),
              const SizedBox(height: 50),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                ),
                onPressed: () {
                  if(_userPlayer.isLoggedIn) {
                   context.push('/challenges');
                  } else {
                    showMessage(context, 'Vous devez vous authentifier afin de pouvoir accéder au mode challenge !');
                  }
                },
                child: const Text('Mode Challenge'),
              ),
            ],
              ),
        ),
      ),
    );
  }
}
