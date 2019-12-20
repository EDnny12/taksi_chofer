import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:taksi_chofer/principal.dart';
import 'package:taksi_chofer/state/app_state.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController correo = TextEditingController();
  TextEditingController contra = TextEditingController();

  Future<void> _testSignInAnonymously() async {
    try {
      await _auth
          .signInWithEmailAndPassword(email: correo.text, password: contra.text)
          .then((user) async {
        assert(user.user.email != null);

        await _auth.currentUser().then((user) {
          Navigator.pushReplacement(
              context,
              CupertinoPageRoute(
                  builder: (context) => MultiProvider(
                        providers: [
                          ChangeNotifierProvider.value(value: AppState())
                        ],
                        child: Principal(),
                      )));
        });
      });
    } catch (Exception) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.90,
              child: Column(
                children: <Widget>[
                  const Icon(
                    Icons.person,
                    size: 350.0,
                  ),
                  TextFormField(
                    controller: correo,
                    decoration: InputDecoration(
                      hintText: "Correo",
                      border: const UnderlineInputBorder(),
                      filled: true,
                    ),
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                  TextFormField(
                    controller: contra,
                    obscureText: true,
                    decoration: InputDecoration(
                        hintText: "Contraseña",
                        border: const UnderlineInputBorder(),
                        filled: true,
                        suffixIcon: Icon(Icons.visibility_off)),
                  ),
                  RaisedButton(
                    onPressed: () {
                      _testSignInAnonymously();
                    },
                    child: const Text("Login"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
