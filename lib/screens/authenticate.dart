import 'package:flutter/material.dart';
import 'package:motusv2/model/motus_data.dart';
import 'package:motusv2/services/auth.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

class Authenticate extends StatelessWidget {
  const Authenticate({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AuthService _user = Provider.of<AuthService>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
          title: Text('Authenticate'),
      ),
      body: Center(
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
                   context.push('/auth/signin');
                },
                child: const Text('Sign In'),
              ),
              const SizedBox(height: 50),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                ),
                onPressed: () {
                   context.go('/');
                },
                child: const Text('Sign Up'),
              ),
              const SizedBox(height: 50),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                ),
                onPressed: () {
                  _user.signOut();
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