import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../services/auth.dart';

class SignIn extends StatelessWidget {
  const SignIn({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    AuthService _user = Provider.of<AuthService>(context, listen: true);
    
    Future logAnon({required String action}) async {
      
      if(action == 'login') {
        User? result = await _user.signInAnon();
        if(result != null) {
          print('Login successfull: ${result.uid}');
        } else {
          print('Could not connect anon !');
        }
      }

      if(action == 'logout') {
        Null result = await _user.signOut();
        print('Logout successfull');
      }

  }

    return Scaffold(
      appBar: AppBar(
          title: Text('Log In'),
      ),
      body: Center(
        child: Padding(
            padding: const EdgeInsets.fromLTRB(40, 40, 40, 40),
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Log In path: ${GoRouter.of(context).location}'),
              Text('Logged In ?: ${_user.user?.uid}'),
              const SizedBox(height: 50),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                ),
                onPressed: () async {
                   await logAnon(action: 'login');
                   //context.go('/');
                },
                child: const Text('Log In'),
              ),
              const SizedBox(height: 50),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                ),
                onPressed: () async {
                   await logAnon(action: 'logout');
                },
                child: const Text('Log Out'),
              ),
            ],
              ),
        ),
      ),
    );
  }
}