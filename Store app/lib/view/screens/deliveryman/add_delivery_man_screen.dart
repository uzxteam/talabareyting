import 'dart:typed_data';

import 'package:country_code_picker/country_code.dart';
import 'package:sixam_mart_store/controller/auth_controller.dart';
import 'package:sixam_mart_store/controller/delivery_man_controller.dart';
import 'package:sixam_mart_store/controller/splash_controller.dart';
import 'package:sixam_mart_store/data/model/response/delivery_man_model.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/images.dart';
import 'package:sixam_mart_store/util/styles.dart';
import 'package:sixam_mart_store/view/base/custom_app_bar.dart';
import 'package:sixam_mart_store/view/base/custom_button.dart';
import 'package:sixam_mart_store/view/base/custom_image.dart';
import 'package:sixam_mart_store/view/base/custom_snackbar.dart';
import 'package:sixam_mart_store/view/base/my_text_field.dart';
import 'package:sixam_mart_store/view/screens/deliveryman/widget/code_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phone_number/phone_number.dart';

class AddDeliveryManScreen extends StatefulWidget {
  final DeliveryManModel deliveryMan;
  AddDeliveryManScreen({@required this.deliveryMan});

  @override
  State<AddDeliveryManScreen> createState() => _AddDeliveryManScreenState();
}

class _AddDeliveryManScreenState extends State<AddDeliveryManScreen> {
  final TextEditingController _fNameController = TextEditingController();
  final TextEditingController _lNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _identityNumberController = TextEditingController();
  final FocusNode _fNameNode = FocusNode();
  final FocusNode _lNameNode = FocusNode();
  final FocusNode _emailNode = FocusNode();
  final FocusNode _phoneNode = FocusNode();
  final FocusNode _passwordNode = FocusNode();
  final FocusNode _identityNumberNode = FocusNode();
  bool _update;
  DeliveryManModel _deliveryMan;
  String _countryDialCode;

  @override
  void initState() {
    super.initState();

    _deliveryMan = widget.deliveryMan;
    _update = widget.deliveryMan != null;
    _countryDialCode = CountryCode.fromCountryCode(Get.find<SplashController>().configModel.country).dialCode;
    Get.find<DeliveryManController>().pickImage(false, true);
    if(_update) {
      _fNameController.text = _deliveryMan.fName;
      _lNameController.text = _deliveryMan.lName;
      _emailController.text = _deliveryMan.email;
      _phoneController.text = _deliveryMan.phone;
      _identityNumberController.text = _deliveryMan.identityNumber;
      Get.find<DeliveryManController>().setIdentityTypeIndex(_deliveryMan.identityType, false);
      _splitPhone(_deliveryMan.phone);
    }else {
      _deliveryMan = DeliveryManModel();
      Get.find<DeliveryManController>().setIdentityTypeIndex(Get.find<DeliveryManController>().identityTypeList[0], false);
      Get.find<DeliveryManController>().setIdentityTypeIndex(Get.find<DeliveryManController>().identityTypeList[0], false);
    }
  }

  void _splitPhone(String phone) async {
    if(!GetPlatform.isWeb) {
      try {
        PhoneNumber phoneNumber = await PhoneNumberUtil().parse(phone);
        _countryDialCode = '+' + phoneNumber.countryCode;
        _phoneController.text = phoneNumber.nationalNumber;
        setState(() {});
      } catch (e) {}
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: widget.deliveryMan != null ? 'update_delivery_man'.tr : 'add_delivery_man'.tr),
      body: GetBuilder<DeliveryManController>(builder: (dmController) {
        return Column(children: [

          Expanded(child: SingleChildScrollView(
            padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
            physics: BouncingScrollPhysics(),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

              Align(alignment: Alignment.center, child: Text(
                'delivery_man_image'.tr,
                style: robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL, color: Theme.of(context).disabledColor),
              )),
              SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
              Align(alignment: Alignment.center, child: Text(
                '(${'max_size_2_mb'.tr})',
                style: robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL, color: Theme.of(context).errorColor),
              )),
              SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
              Align(alignment: Alignment.center, child: Stack(children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                  child: dmController.pickedImage != null ? Image.memory(
                    dmController.pickedImage, width: 150, height: 120, fit: BoxFit.cover,
                  ) : FadeInImage.assetNetwork(
                    placeholder: Images.placeholder,
                    image: '${Get.find<SplashController>().configModel.baseUrls.deliveryManImageUrl}/${_deliveryMan.image != null ? _deliveryMan.image : ''}',
                    height: 120, width: 150, fit: BoxFit.cover,
                    imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholder, height: 120, width: 150, fit: BoxFit.cover),
                  ),
                ),
                Positioned(
                  bottom: 0, right: 0, top: 0, left: 0,
                  child: InkWell(
                    onTap: () => dmController.pickImage(true, false),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.3), borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                        border: Border.all(width: 1, color: Theme.of(context).primaryColor),
                      ),
                      child: Container(
                        margin: EdgeInsets.all(25),
                        decoration: BoxDecoration(
                          border: Border.all(width: 2, color: Colors.white),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.camera_alt, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ])),
              SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

              Row(children: [
                Expanded(child: MyTextField(
                  hintText: 'first_name'.tr,
                  controller: _fNameController,
                  capitalization: TextCapitalization.words,
                  inputType: TextInputType.name,
                  focusNode: _fNameNode,
                  nextFocus: _lNameNode,
                )),
                SizedBox(width: Dimensions.PADDING_SIZE_SMALL),

                Expanded(child: MyTextField(
                  hintText: 'last_name'.tr,
                  controller: _lNameController,
                  capitalization: TextCapitalization.words,
                  inputType: TextInputType.name,
                  focusNode: _lNameNode,
                  nextFocus: _emailNode,
                )),
              ]),
              SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

              MyTextField(
                hintText: 'email'.tr,
                controller: _emailController,
                focusNode: _emailNode,
                nextFocus: _phoneNode,
                inputType: TextInputType.emailAddress,
              ),
              SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

              Row(children: [
                Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                    boxShadow: [BoxShadow(color: Colors.grey[Get.isDarkMode ? 800 : 200], spreadRadius: 1, blurRadius: 5, offset: Offset(0, 5))],
                  ),
                  child: CodePickerWidget(
                    onChanged: (CountryCode countryCode) {
                      _countryDialCode = countryCode.dialCode;
                    },
                    initialSelection: _countryDialCode,
                    favorite: [_countryDialCode],
                    showDropDownButton: true,
                    padding: EdgeInsets.zero,
                    showFlagMain: true,
                    flagWidth: 30,
                    textStyle: robotoRegular.copyWith(
                      fontSize: Dimensions.FONT_SIZE_LARGE, color: Theme.of(context).textTheme.bodyText1.color,
                    ),
                  ),
                ),
                SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                Expanded(flex: 1, child: MyTextField(
                  hintText: 'phone'.tr,
                  controller: _phoneController,
                  focusNode: _phoneNode,
                  nextFocus: _passwordNode,
                  inputType: TextInputType.phone,
                  title: false,
                )),
              ]),
              SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

              MyTextField(
                hintText: 'password'.tr,
                controller: _passwordController,
                focusNode: _passwordNode,
                nextFocus: _identityNumberNode,
                inputType: TextInputType.visiblePassword,
                isPassword: true,
              ),
              SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

              Row(children: [

                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(
                    'identity_type'.tr,
                    style: robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL, color: Theme.of(context).disabledColor),
                  ),
                  SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                      boxShadow: [BoxShadow(color: Colors.grey[Get.isDarkMode ? 800 : 200], spreadRadius: 2, blurRadius: 5, offset: Offset(0, 5))],
                    ),
                    child: DropdownButton<String>(
                      value: dmController.identityTypeList[dmController.identityTypeIndex],
                      items: dmController.identityTypeList.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value.tr),
                        );
                      }).toList(),
                      onChanged: (value) {
                        dmController.setIdentityTypeIndex(value, true);
                      },
                      isExpanded: true,
                      underline: SizedBox(),
                    ),
                  ),
                ])),
                SizedBox(width: Dimensions.PADDING_SIZE_SMALL),

                Expanded(child: MyTextField(
                  hintText: 'identity_number'.tr,
                  controller: _identityNumberController,
                  focusNode: _identityNumberNode,
                  inputAction: TextInputAction.done,
                )),

              ]),
              SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

              _update ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Text(
                    'identity_images'.tr,
                    style: robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL, color: Theme.of(context).disabledColor),
                  ),
                  SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                  Text(
                    '(${'previously_added'.tr})',
                    style: robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL, color: Theme.of(context).primaryColor),
                  ),
                ]),
                SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                SizedBox(
                  height: 120,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    physics: BouncingScrollPhysics(),
                    itemCount: _deliveryMan.identityImage.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: EdgeInsets.only(right: Dimensions.PADDING_SIZE_SMALL),
                        decoration: BoxDecoration(
                          border: Border.all(color: Theme.of(context).primaryColor, width: 2),
                          borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                          child: CustomImage(
                            image: '${Get.find<SplashController>().configModel.baseUrls.deliveryManImageUrl}/${_deliveryMan.identityImage[index]}',
                            width: 150, height: 120, fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
              ]) : SizedBox(),

              Text(
                'identity_images'.tr,
                style: robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL, color: Theme.of(context).disabledColor),
              ),
              SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
              SizedBox(
                height: 120,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: BouncingScrollPhysics(),
                  itemCount: dmController.pickedIdentities.length+1,
                  itemBuilder: (context, index) {
                    Uint8List _file = index == dmController.pickedIdentities.length ? null : dmController.pickedIdentities[index];
                    if(index == dmController.pickedIdentities.length) {
                      return InkWell(
                        onTap: () {
                          if(dmController.pickedIdentities.length < 6) {
                            dmController.pickImage(false, false);
                          }else {
                            showCustomSnackBar('maximum_image_limit_is_6'.tr);
                          }
                        },
                        child: Container(
                          height: 120, width: 150, alignment: Alignment.center, decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                            border: Border.all(color: Theme.of(context).primaryColor, width: 2),
                          ),
                          child: Container(
                            padding: EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT),
                            decoration: BoxDecoration(
                              border: Border.all(width: 2, color: Theme.of(context).primaryColor),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.camera_alt, color: Theme.of(context).primaryColor),
                          ),
                        ),
                      );
                    }
                    return Container(
                      margin: EdgeInsets.only(right: Dimensions.PADDING_SIZE_SMALL),
                      decoration: BoxDecoration(
                        border: Border.all(color: Theme.of(context).primaryColor, width: 2),
                        borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                      ),
                      child: Stack(children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                          child: Image.memory(
                            _file, width: 150, height: 120, fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          right: 0, top: 0,
                          child: InkWell(
                            onTap: () => dmController.removeIdentityImage(index),
                            child: Padding(
                              padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                              child: Icon(Icons.delete_forever, color: Colors.red),
                            ),
                          ),
                        ),
                      ]),
                    );
                  },
                ),
              ),

            ]),
          )),

          !dmController.isLoading ? CustomButton(
            buttonText: _update ? 'update'.tr : 'add'.tr,
            margin: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
            height: 50,
            onPressed: () => _addDeliveryMan(dmController),
          ) : Center(child: CircularProgressIndicator()),

        ]);
      }),
    );
  }

  void _addDeliveryMan(DeliveryManController dmController) async {
    String _fName = _fNameController.text.trim();
    String _lName = _lNameController.text.trim();
    String _email = _emailController.text.trim();
    String _phone = _phoneController.text.trim();
    String _password = _passwordController.text.trim();
    String _identityNumber = _identityNumberController.text.trim();

    String _numberWithCountryCode = _countryDialCode+_phone;
    bool _isValid = GetPlatform.isWeb ? true : false;
    if(!GetPlatform.isWeb) {
      try {
        PhoneNumber phoneNumber = await PhoneNumberUtil().parse(_numberWithCountryCode);
        _numberWithCountryCode = '+' + phoneNumber.countryCode + phoneNumber.nationalNumber;
        _isValid = true;
      } catch (e) {}
    }
    if(_fName.isEmpty) {
      showCustomSnackBar('enter_delivery_man_first_name'.tr);
    }else if(_lName.isEmpty) {
      showCustomSnackBar('enter_delivery_man_last_name'.tr);
    }else if(_email.isEmpty) {
      showCustomSnackBar('enter_delivery_man_email_address'.tr);
    }else if(!GetUtils.isEmail(_email)) {
      showCustomSnackBar('enter_a_valid_email_address'.tr);
    }else if(_phone.isEmpty) {
      showCustomSnackBar('enter_delivery_man_phone_number'.tr);
    }else if(!_isValid) {
      showCustomSnackBar('enter_a_valid_phone_number'.tr);
    }else if(_password.isEmpty) {
      showCustomSnackBar('enter_password_for_delivery_man'.tr);
    }else if(_password.length < 6) {
      showCustomSnackBar('password_should_be'.tr);
    }else if(_identityNumber.isEmpty) {
      showCustomSnackBar('enter_delivery_man_identity_number'.tr);
    }else if(!_update && dmController.pickedImage == null) {
      showCustomSnackBar('upload_delivery_man_image'.tr);
    }else {
      _deliveryMan.fName = _fName;
      _deliveryMan.lName = _lName;
      _deliveryMan.email = _email;
      _deliveryMan.phone = _numberWithCountryCode;
      _deliveryMan.identityType = dmController.identityTypeList[dmController.identityTypeIndex];
      _deliveryMan.identityNumber = _identityNumber;
      dmController.addDeliveryMan(
        _deliveryMan, _password, Get.find<AuthController>().getUserToken(), widget.deliveryMan == null,
      );
    }
  }
}
