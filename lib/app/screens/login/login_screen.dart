import 'package:flutter/material.dart';
import 'package:project_2/app/common/widgets/main_elevated_button.dart';
import 'package:project_2/app/screens/login/widgets/login_text_field.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 40.0),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 214, 101, 192),
              Color.fromARGB(255, 148, 243, 241)
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Text(
              'LOGIN',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 50,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              child: Column(
                children: [
                  LoginTextField(
                      label: 'Name',
                      onChanged: (value) => {},
                      obscureText: true),
                  LoginTextField(
                      label: 'Surname',
                      onChanged: (value) => {},
                      obscureText: true),
                  LoginTextField(
                      label: 'Phone number',
                      onChanged: (value) => {},
                      obscureText: true),
                ],
              ),
            ),
            MainElevatedButton(onButtonPressed: () {}, title: 'Submit')
          ],
        ),
      ),
    );
  }
}
