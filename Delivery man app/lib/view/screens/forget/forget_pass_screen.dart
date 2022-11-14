import 'package:country_code_picker/country_code.dart';
import 'package:sixam_mart_delivery/controller/auth_controller.dart';
import 'package:sixam_mart_delivery/controller/splash_controller.dart';
import 'package:sixam_mart_delivery/helper/route_helper.dart';
import 'package:sixam_mart_delivery/util/dimensions.dart';
import 'package:sixam_mart_delivery/util/images.dart';
import 'package:sixam_mart_delivery/util/styles.dart';
import 'package:sixam_mart_delivery/view/base/custom_app_bar.dart';
import 'package:sixam_mart_delivery/view/base/custom_button.dart';
import 'package:sixam_mart_delivery/view/base/custom_snackbar.dart';
import 'package:sixam_mart_delivery/view/base/custom_text_field.dart';
import 'package:sixam_mart_delivery/view/screens/auth/widget/code_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phone_number/phone_number.dart';

class ForgetPassScreen extends StatefulWidget {
  @override
  State<ForgetPassScreen> createState() => _ForgetPassScreenState();
}

class _ForgetPassScreenState extends State<ForgetPassScreen> {
  final TextEditingController _numberController = TextEditingController();
  String _countryDialCode = CountryCode.fromCountryCode(Get.find<SplashController>().configModel.country).dialCode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'forgot_password'.tr),
      body: SafeArea(child: Center(child: Scrollbar(child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
        child: Center(child: SizedBox(width: 1170, child: Column(children: [

          Image.asset(Images.forgot, height: 220),

          Padding(
            padding: EdgeInsets.all(30),
            child: Text('please_enter_mobile'.tr, style: robotoRegular, textAlign: TextAlign.center),
          ),

          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
              color: Theme.of(context).cardColor,
            ),
            child: Row(children: [
              CodePickerWidget(
                onChanged: (CountryCode countryCode) {
                  _countryDialCode = countryCode.dialCode;
                },
                initialSelection: _countryDialCode,
                favorite: [_countryDialCode],
                showDropDownButton: true,
                padding: EdgeInsets.zero,
                showFlagMain: true,
                textStyle: robotoRegular.copyWith(
                  fontSize: Dimensions.FONT_SIZE_LARGE, color: Theme.of(context).textTheme.bodyText1.color,
                ),
              ),
              Expanded(child: CustomTextField(
                controller: _numberController,
                inputType: TextInputType.phone,
                inputAction: TextInputAction.done,
                hintText: 'phone'.tr,
                onSubmit: (text) => GetPlatform.isWeb ? _forgetPass(_countryDialCode) : null,
              )),
            ]),
          ),
          SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

          GetBuilder<AuthController>(builder: (authController) {
            return !authController.isLoading ? CustomButton(
              buttonText: 'next'.tr,
              onPressed: () => _forgetPass(_countryDialCode),
            ) : Center(child: CircularProgressIndicator());
          }),

        ]))),
      )))),
    );
  }

  void _forgetPass(String countryCode) async {
    String _phone = _numberController.text.trim();

    String _numberWithCountryCode = countryCode+_phone;
    bool _isValid = false;
    try {
      PhoneNumber phoneNumber = await PhoneNumberUtil().parse(_numberWithCountryCode);
      _numberWithCountryCode = '+'+phoneNumber.countryCode+phoneNumber.nationalNumber;
      _isValid = true;
    }catch(e) {}

    if (_phone.isEmpty) {
      showCustomSnackBar('enter_phone_number'.tr);
    }else if (!_isValid) {
      showCustomSnackBar('invalid_phone_number'.tr);
    }else {
      Get.find<AuthController>().forgetPassword(_numberWithCountryCode).then((status) async {
        if (status.isSuccess) {
          Get.toNamed(RouteHelper.getVerificationRoute(_numberWithCountryCode));
        }else {
          showCustomSnackBar(status.message);
        }
      });
    }
  }
}