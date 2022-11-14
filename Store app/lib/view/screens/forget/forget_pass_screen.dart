import 'package:sixam_mart_store/controller/auth_controller.dart';
import 'package:sixam_mart_store/helper/route_helper.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/images.dart';
import 'package:sixam_mart_store/util/styles.dart';
import 'package:sixam_mart_store/view/base/custom_app_bar.dart';
import 'package:sixam_mart_store/view/base/custom_button.dart';
import 'package:sixam_mart_store/view/base/custom_snackbar.dart';
import 'package:sixam_mart_store/view/base/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgetPassScreen extends StatefulWidget {
  @override
  State<ForgetPassScreen> createState() => _ForgetPassScreenState();
}

class _ForgetPassScreenState extends State<ForgetPassScreen> {
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'forgot_password'.tr),
      body: SafeArea(child: Center(child: Scrollbar(child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
        child: Center(child: SizedBox(width: 1170, child: Column(children: [

          Text('please_enter_email'.tr, style: robotoRegular, textAlign: TextAlign.center),
          SizedBox(height: 50),

          CustomTextField(
            controller: _emailController,
            inputType: TextInputType.emailAddress,
            inputAction: TextInputAction.done,
            hintText: 'email'.tr,
            prefixIcon: Images.mail,
            onSubmit: (text) => GetPlatform.isWeb ? _forgetPass() : null,
          ),
          SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

          GetBuilder<AuthController>(builder: (authController) {
            return !authController.isLoading ? CustomButton(
              buttonText: 'next'.tr,
              onPressed: () => _forgetPass(),
            ) : Center(child: CircularProgressIndicator());
          }),

        ]))),
      )))),
    );
  }

  void _forgetPass() {
    String _email = _emailController.text.trim();
    if (_email.isEmpty) {
      showCustomSnackBar('enter_email_address'.tr);
    }else if (!GetUtils.isEmail(_email)) {
      showCustomSnackBar('enter_a_valid_email_address'.tr);
    }else {
      Get.find<AuthController>().forgetPassword(_email).then((status) async {
        if (status.isSuccess) {
          Get.toNamed(RouteHelper.getVerificationRoute(_email));
        }else {
          showCustomSnackBar(status.message);
        }
      });
    }
  }
}
