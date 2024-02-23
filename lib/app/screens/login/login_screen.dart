import 'package:flutter/material.dart';
import 'package:project_2/app/common/widgets/main_elevated_button.dart';
import 'package:project_2/app/screens/login/login_view_model.dart';
import 'package:project_2/app/screens/login/widgets/login_text_field.dart';
import 'package:project_2/app/theming/app_colors.dart';

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
            colors: [AppColors.yellowColor, AppColors.oliveGreenColor],
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
                      errorText: loginViewModel.nameError,
                      obscureText: false),
                  LoginTextField(
                      label: 'Surname',
                      errorText: loginViewModel.surnameError,
                      onChanged: (value) => loginViewModel.surname = value,
                      obscureText: false),
                  LoginTextField(
                      label: 'Phone number',
                      errorText: loginViewModel.phoneNumberError,
                      onChanged: (value) => loginViewModel.phoneNumber = value,
                      obscureText: false),
                ],
              ),
            ),
            MainElevatedButton(
                onButtonPressed: () {
                  loginViewModel.onSendOtpButtonPressed();
                  if (loginViewModel.isFormDataValid) {
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
                  }
                },
                title: 'Send code')
          ],
        ),
      ),
    );
  }
}
