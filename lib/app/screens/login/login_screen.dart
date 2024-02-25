import 'package:flutter/material.dart';
import 'package:project_2/app/common/modals/modal_bottom_sheet/modal_bottom_sheet_content_data.dart';
import 'package:project_2/app/common/modals/modals_service.dart';
import 'package:project_2/app/common/modals/pop_up_dialog/pop_up_dialog_data.dart';
import 'package:project_2/app/common/widgets/main_elevated_button.dart';
import 'package:project_2/app/screens/login/login_view_model.dart';
import 'package:project_2/app/common/widgets/main_text_field.dart';
import 'package:project_2/app/screens/login/widgets/custom_container.dart';
import 'package:project_2/app/theming/app_colors.dart';

class LoginScreen extends StatelessWidget {
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
            const Positioned(
              top: 100,
              left: 20,
              child: Text(
                'Plant app',
                style: TextStyle(
                    color: AppColors.lightMentolGreenColor,
                    fontSize: 50,
                    fontWeight: FontWeight.bold),
              ),
            ),
            const Positioned(
              top: 300,
              left: 20,
              child: Text(
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
                height: MediaQuery.of(context).size.height - 200,
                child: CustomPaint(
                  painter: CustomContainer(),
                ),
              ),
            ),
            Positioned(
                left: 200,
                bottom: -30,
                child: Image.asset(
                  'assets/images/plant_transp.png',
                  height: MediaQuery.of(context).size.height - 300,
                )),
            Positioned(
              bottom: MediaQuery.of(context).size.height - 400,
              left: 20,
              height: 50,
              width: MediaQuery.of(context).size.width - 200,
              child: MainElevatedButton(
                  icon: const Icon(
                    Icons.sms,
                    color: AppColors.whiteColor,
                  ),
                  onButtonPressed: () {
                    ModalsService.showBottomModal(
                        context: context,
                        data: ModalBottomSheetContentData(
                          title: 'Авторизація за SMS',
                          firstLabel: "Ім'я",
                          secondLabel: "Номер телефону",
                          buttonTitle: "Надіслати код",
                          onFirstTextFieldChanged: (value) =>
                              loginViewModel.name = value,
                          onSecondTextFieldChanged: (value) =>
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
                                            onChanged: (value) =>
                                                loginViewModel.otp = value,
                                            obscureText: false),
                                        actions: [
                                          MainElevatedButton(
                                              onButtonPressed: loginViewModel
                                                  .onLoginOtpButtonPressed,
                                              title: 'Підтвердити')
                                        ]))
                              }
                          },
                        ));
                  },
                  title: 'SMS'),
            ),
            Positioned(
              bottom: MediaQuery.of(context).size.height - 480,
              left: 20,
              height: 50,
              width: MediaQuery.of(context).size.width - 200,
              child: MainElevatedButton(
                  icon: const Icon(
                    Icons.g_mobiledata_outlined,
                    size: 40,
                    color: AppColors.whiteColor,
                  ),
                  onButtonPressed: loginViewModel.onLoginGoogleButtonPressed,
                  title: 'Google'),
            ),
          ],
        ),
      ),
    );
  }
}
