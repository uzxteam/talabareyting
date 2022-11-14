import 'package:sixam_mart_store/controller/auth_controller.dart';
import 'package:sixam_mart_store/controller/splash_controller.dart';
import 'package:sixam_mart_store/data/model/response/menu_model.dart';
import 'package:sixam_mart_store/helper/route_helper.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/images.dart';
import 'package:sixam_mart_store/util/styles.dart';
import 'package:sixam_mart_store/view/base/confirmation_dialog.dart';
import 'package:sixam_mart_store/view/base/custom_image.dart';
import 'package:sixam_mart_store/view/base/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MenuButton extends StatelessWidget {
  final MenuModel menu;
  final bool isProfile;
  final bool isLogout;
  MenuButton({@required this.menu, @required this.isProfile, @required this.isLogout});

  @override
  Widget build(BuildContext context) {
    double _size = (context.width/4)-Dimensions.PADDING_SIZE_DEFAULT;

    return InkWell(
      onTap: () {
        if(menu.isBlocked) {
          showCustomSnackBar('this_feature_is_blocked_by_admin'.tr);
        }else {
          if (isLogout) {
            Get.back();
            if (Get.find<AuthController>().isLoggedIn()) {
              Get.dialog(ConfirmationDialog(icon: Images.support, description: 'are_you_sure_to_logout'.tr, isLogOut: true, onYesPressed: () {
                Get.find<AuthController>().clearSharedData();
                Get.offAllNamed(RouteHelper.getSignInRoute());
              }), useSafeArea: false);
            } else {
              Get.find<AuthController>().clearSharedData();
              Get.toNamed(RouteHelper.getSignInRoute());
            }
          } else {
            Get.offNamed(menu.route);
          }
        }
      },
      child: Column(children: [

        Container(
          height: _size-(_size*0.2),
          padding: EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT),
          margin: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
            color: isLogout ? Get.find<AuthController>().isLoggedIn() ? Colors.red : Colors.green : Theme.of(context).primaryColor,
            boxShadow: [BoxShadow(color: Colors.grey[Get.isDarkMode ? 800 : 200], spreadRadius: 1, blurRadius: 5)],
          ),
          alignment: Alignment.center,
          child: isProfile ? ProfileImageWidget(size: _size) : Image.asset(menu.icon, width: _size, height: _size, color: Colors.white),
        ),
        SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),

        Text(menu.title, style: robotoMedium.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL), textAlign: TextAlign.center),

      ]),
    );
  }
}

class ProfileImageWidget extends StatelessWidget {
  final double size;
  ProfileImageWidget({@required this.size});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(builder: (authController) {
      return Container(
        decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(width: 2, color: Colors.white)),
        child: ClipOval(
          child: CustomImage(
            image: '${Get.find<SplashController>().configModel.baseUrls.vendorImageUrl}'
                '/${(authController.profileModel != null && Get.find<AuthController>().isLoggedIn()) ? authController.profileModel.image ?? '' : ''}',
            width: size, height: size, fit: BoxFit.cover,
          ),
        ),
      );
    });
  }
}