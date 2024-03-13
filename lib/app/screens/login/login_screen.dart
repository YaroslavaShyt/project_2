import 'package:flutter/material.dart';
import 'package:project_2/app/common/error_handling/error_handling_mixin.dart';
import 'package:project_2/app/common/widgets/modals/modal_bottom_sheet/modal_bottom_dialog_data.dart';
import 'package:project_2/app/common/widgets/modals/modals_service.dart';
import 'package:project_2/app/common/widgets/modals/pop_up_dialog/pop_up_dialog_data.dart';
import 'package:project_2/app/common/widgets/main_elevated_button.dart';
import 'package:project_2/app/screens/login/login_view_model.dart';
import 'package:project_2/app/common/widgets/main_text_field.dart';
import 'package:project_2/app/screens/login/widgets/custom_container.dart';
import 'package:project_2/app/theming/app_colors.dart';

class LoginScreen extends StatelessWidget with ErrorHandlingMixin {
  final LoginViewModel loginViewModel;
  const LoginScreen({super.key, required this.loginViewModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(color: AppColors.darkWoodGeenColor),
        child: Stack(
          children: [
            Positioned(
              top: MediaQuery.of(context).size.height * 0.1,
              left: MediaQuery.of(context).size.width * 0.1,
              child: const Text(
                'Plant app',
                style: TextStyle(
                    color: AppColors.lightMentolGreenColor,
                    fontSize: 50,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.25,
              left: MediaQuery.of(context).size.width * 0.1,
              child: const Text(
                'Авторизуватись через',
                style: TextStyle(
                    color: AppColors.lightMentolGreenColor,
                    fontSize: 20,
                    fontWeight: FontWeight.normal),
              ),
            ),
            Positioned(
              bottom: 0,
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.8,
                child: CustomPaint(
                  painter: CustomContainer(),
                ),
              ),
            ),
            Positioned(
                left: MediaQuery.of(context).size.height * 0.2,
                bottom: MediaQuery.of(context).size.height * -0.05,
                child: Image.asset(
                  'assets/images/plant_transp.png',
                  height: MediaQuery.of(context).size.height * 0.7,
                )),
            Positioned(
              bottom: MediaQuery.of(context).size.height * 0.6,
              left: MediaQuery.of(context).size.width * 0.1,
              height: 50,
              width: 200,
              child: MainElevatedButton(
                  icon: const Icon(
                    Icons.sms,
                    color: AppColors.whiteColor,
                  ),
                  onButtonPressed: () => _showLoginModal(context),
                  title: 'SMS'),
            ),
            Positioned(
              bottom: MediaQuery.of(context).size.height * 0.52,
              left: MediaQuery.of(context).size.width * 0.1,
              height: 50,
              width: 200,
              child: MainElevatedButton(
                  icon: const Icon(
                    Icons.g_mobiledata_outlined,
                    size: 40,
                    color: AppColors.whiteColor,
                  ),
                  onButtonPressed: () =>
                      loginViewModel.onLoginGoogleButtonPressed(
                          onError: (error) => showErrorDialog(context, error)),
                  title: 'Google'),
            ),
          ],
        ),
      ),
    );
  }

  void _showLoginModal(BuildContext context) {
    ModalsService.showBottomModal(
        context: context,
        data: ModalBottomDialogData(
          title: 'Авторизація за SMS',
          firstLabel: "Номер телефону",
          buttonTitle: "Надіслати код",
          onFirstTextFieldChanged: (value) =>
              loginViewModel.phoneNumber = value,
          onButtonPressed: () => {
            loginViewModel.onSendOtpButtonPressed(),
            if (loginViewModel.isFormDataValid)
              {
                ModalsService.showPopUpModal(
                    context: context,
                    data: PopUpDialogData(
                        title: 'Введіть код',
                        content: MainTextField(
                            label: 'Код',
                            onChanged: (value) => loginViewModel.otp = value,
                            obscureText: false),
                        actions: [
                          MainElevatedButton(
                              onButtonPressed: () =>
                                  loginViewModel.onLoginOtpButtonPressed(
                                      onError: (error) =>
                                          showErrorDialog(context, error)),
                              title: 'Увійти')
                        ]))
              }
          },
        ));
  }
}
