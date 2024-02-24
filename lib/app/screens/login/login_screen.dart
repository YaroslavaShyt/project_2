import 'package:flutter/material.dart';
import 'package:project_2/app/common/modals/modals_service.dart';
import 'package:project_2/app/common/modals/pop_up_dialog/pop_up_dialog_data.dart';
import 'package:project_2/app/common/widgets/main_elevated_button.dart';
import 'package:project_2/app/screens/login/login_view_model.dart';
import 'package:project_2/app/common/widgets/main_text_field.dart';
import 'package:project_2/app/theming/app_colors.dart';

class LoginScreen extends StatefulWidget {
  final LoginViewModel loginViewModel;
  const LoginScreen({super.key, required this.loginViewModel});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

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
                  MainTextField(
                      label: 'Name',
                      onChanged: (value) => widget.loginViewModel.name = value,
                      errorText: widget.loginViewModel.nameError,
                      obscureText: false),
                  MainTextField(
                      label: 'Surname',
                      errorText: widget.loginViewModel.surnameError,
                      onChanged: (value) =>
                          widget.loginViewModel.surname = value,
                      obscureText: false),
                  MainTextField(
                      label: 'Phone number',
                      errorText: widget.loginViewModel.phoneNumberError,
                      onChanged: (value) =>
                          widget.loginViewModel.phoneNumber = value,
                      obscureText: false),
                ],
              ),
            ),
            MainElevatedButton(
                onButtonPressed: () {
                  widget.loginViewModel.onSendOtpButtonPressed();
                  if (widget.loginViewModel.isFormDataValid) {
                    ModalsService.showPopUpModal(
                        context: context,
                        data: PopUpDialogData(
                            title: 'Введіть код',
                            content: MainTextField(
                                label: 'Код',
                                onChanged: (value) {},
                                obscureText: false),
                            actions: [
                              MainElevatedButton(
                                  onButtonPressed: () => widget.loginViewModel
                                      .onLoginButtonPressed(controller.text),
                                  title: 'Підтвердити')
                            ]));
                  }
                },
                title: 'Send code')
          ],
        ),
      ),
    );
  }
}
