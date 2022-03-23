import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'screens/authenticate.dart';
import 'screens/show_result.dart';
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

      redirect: (state) {
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
      },
      

      routes: <GoRoute>[
        GoRoute(
          path: '/',
          builder: (BuildContext context, GoRouterState state) => MyHomePage(),
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

class MyHomePage extends StatelessWidget {
  MyHomePage({Key? key}) : super(key: key);

  final title = 'Motus 2.0';
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    MotusGrid _grid = Provider.of<MotusGrid>(context);
    InputValidation _validationService = Provider.of<InputValidation>(context);
    MotusData _db = Provider.of<MotusData>(context);

    // Triggers player input validation
    validateForm(String wordAllCaps) async {
      bool playerPropositionExists = false;
      if (_validationService.input.value != null) {
        // Checking if user proposition is an existing word
        playerPropositionExists = await _db
            .checkIfExists(_validationService.input.value!.toUpperCase());
      }

      // Injecting word to be found in validation service
      _validationService.setWordToFind(wordAllCaps);
      // Checking player proposition
      dynamic _result =
          _validationService.validateInput(context, playerPropositionExists);
      // Updating grid result in grid
      _grid.updateGrid(_result);

      // The form field is cleared only when a valid proposition has been entered
      if (_validationService.input.error == null) {
        _controller.clear();
      }

      // Is this the end of the game ?
      if (_grid.tryNum > 6 || _validationService.playerHasWon) {
        // Showing popup with result
        ShowResult(context, _validationService.playerHasWon, _db.wordSmallCaps);

        // Intializing new game
        _grid.initGrid();
        _validationService.initForm();
        _validationService.setWordToFind(await _db.getWordToFind());
      }
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
        body: Padding(
            padding: const EdgeInsets.fromLTRB(40, 10, 40, 10),
            child: ListView(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: 200,
                    child: TextField(
                      controller: _controller,
                      maxLength: 5,
                      onChanged: (String value) {
                        _validationService.changeInput(value, null);
                      },
                      decoration: InputDecoration(
                        labelText: 'Votre proposition:',
                        errorText: _validationService.input.error,
                        hintText: 'Entrez un mot de 5 lettres',
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                      onPressed: () {
                        FocusManager.instance.primaryFocus?.unfocus();
                        validateForm(_db.wordAllCaps);
                      },
                      child: const Text('Envoi')
                  ),
                ],
              ),
              const SizedBox(height: 20),
              GridView.count(
                shrinkWrap: true,
                crossAxisCount: 5,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 1,
                children: _grid.lstSquaresWidgets,
              ),
              const SizedBox(height: 20),
            ])));
  }
}
