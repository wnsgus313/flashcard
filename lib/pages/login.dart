import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // google 로그인
  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
    await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          children: <Widget>[
            const SizedBox(height: 80.0),
            const SizedBox(height: 120.0),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.red[100]),
                foregroundColor: MaterialStateProperty.all(Colors.white),
              ),
              onPressed: () async {
                await signInWithGoogle();
                Navigator.pushNamedAndRemoveUntil(
                  context, '/home', (_) => false
                );
                // Navigator.of(context).pushNamed('/home');

                final database = FirebaseFirestore.instance;
                User userInfo = FirebaseAuth.instance.currentUser!;

                if(!userInfo.isAnonymous) {
                  database.collection('user').doc(userInfo.uid).set({
                    'email': userInfo.email,
                    'name': userInfo.displayName,
                    'uid': userInfo.uid,
                  });
                }
              },
              child: const Text('GOOGLE'),
            ),
          ],
        ),
      ),
    );
  }
}