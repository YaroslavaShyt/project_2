import 'package:flutter/material.dart';
import 'package:project_2/app/common/widgets/main_elevated_button.dart';
import 'package:project_2/app/screens/login/login_view_model.dart';
import 'package:project_2/app/screens/login/widgets/login_text_field.dart';

class LoginScreen extends StatelessWidget {
  final LoginViewModel loginViewModel;
  const LoginScreen({super.key, required this.loginViewModel});

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
                      onChanged: (value) => loginViewModel.name = value,
                      obscureText: false),
                  LoginTextField(
                      label: 'Surname',
                      onChanged: (value) => loginViewModel.surname = value,
                      obscureText: false),
                  LoginTextField(
                      label: 'Phone number',
                      onChanged: (value) => loginViewModel.phoneNumber = value,
                      obscureText: false),
                ],
              ),
            ),
            MainElevatedButton(
                onButtonPressed: () {
                  loginViewModel.onSendOtpButtonPressed();
                  showDialog(
                      context: context,
                      builder: (context) {
                        final TextEditingController controller =
                            TextEditingController();
                        return AlertDialog(
                          title: const Text('Your code'),
                          content: TextField(
                            controller: controller,
                          ),
                          actions: [
                            ElevatedButton(
                                onPressed: () {
                                  loginViewModel
                                      .onLoginButtonPressed(controller.text);
                                  
                                },
                                child: const Text('Submit'))
                          ],
                        );
                      });
                },
                title: 'Send code')
          ],
        ),
      ),
    );
  }
}
