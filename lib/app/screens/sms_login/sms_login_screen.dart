import 'package:flutter/material.dart';
import 'package:project_2/app/common/error_handling/error_handling_mixin.dart';
import 'package:project_2/app/common/widgets/main_elevated_button.dart';
import 'package:project_2/app/common/widgets/main_text_field.dart';
import 'package:project_2/app/screens/sms_login/widgets/add_photo_container.dart';
import 'package:project_2/app/screens/sms_login/sms_login_view_model.dart';
import 'package:project_2/app/theming/app_colors.dart';

class SMSLoginScreen extends StatelessWidget with ErrorHandlingMixin {
  final SMSLoginViewModel smsLoginViewModel;
  const SMSLoginScreen({super.key, required this.smsLoginViewModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.darkWoodGeenColor,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.whiteColor),
          onPressed: () {},
        ),
        title: const Text(
          'Авторизація',
          style: TextStyle(
              color: AppColors.whiteColor, fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              AddPhotoContainer(
                photoUrl: smsLoginViewModel.imageUrl,
                onAddPhotoButtonPressed: () =>
                    smsLoginViewModel.onAddPhotoButtonPressed(
                        onError: (err) => showErrorDialog(context, err)),
              ),
              MainTextField(
                  label: 'Ім\'я', onChanged: (value) {}, obscureText: false),
              SizedBox(
                  height: 55,
                  width: 320.0,
                  child: MainElevatedButton(
                      onButtonPressed: () =>
                          smsLoginViewModel.onLoginOtpButtonPressed(
                              onError: (err) => showErrorDialog(context, err)),
                      title: "Зберегти"))
            ],
          ),
        ),
      ),
      backgroundColor: AppColors.darkWoodGeenColor,
    );
  }
}
