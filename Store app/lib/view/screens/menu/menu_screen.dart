import 'package:sixam_mart_store/controller/auth_controller.dart';
import 'package:sixam_mart_store/controller/splash_controller.dart';
import 'package:sixam_mart_store/data/model/response/menu_model.dart';
import 'package:sixam_mart_store/helper/route_helper.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/images.dart';
import 'package:sixam_mart_store/view/screens/menu/widget/menu_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MenuScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<MenuModel> _menuList = [
      MenuModel(icon: '', title: 'profile'.tr, route: RouteHelper.getProfileRoute()),
      MenuModel(icon: Images.credit_card, title: 'bank_info'.tr, route: RouteHelper.getBankInfoRoute()),
      MenuModel(
        icon: Images.add_food, title: 'add_item'.tr, route: RouteHelper.getItemRoute(null),
        isBlocked: !Get.find<AuthController>().profileModel.stores[0].itemSection,
      ),
      MenuModel(icon: Images.campaign, title: 'campaign'.tr, route: RouteHelper.getCampaignRoute()),
      MenuModel(icon: Images.categories, title: 'categories'.tr, route: RouteHelper.getCategoriesRoute()),
      MenuModel(icon: Images.language, title: 'language'.tr, route: RouteHelper.getLanguageRoute('menu')),
      MenuModel(icon: Images.policy, title: 'privacy_policy'.tr, route: RouteHelper.getPrivacyRoute()),
      MenuModel(icon: Images.terms, title: 'terms_condition'.tr, route: RouteHelper.getTermsRoute()),
      MenuModel(icon: Images.log_out, title: 'logout'.tr, route: ''),
    ];
    if(Get.find<AuthController>().profileModel.stores[0].selfDeliverySystem == 1) {
      _menuList.insert(5, MenuModel(icon: Images.delivery_man, title: 'delivery_man'.tr, route: RouteHelper.getDeliveryManRoute()));
    }
    if(Get.find<SplashController>().configModel.moduleConfig.module.addOn) {
      _menuList.insert(6, MenuModel(icon: Images.addon, title: 'addons'.tr, route: RouteHelper.getAddonsRoute()));
    }

    return Container(
      padding: EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(Dimensions.RADIUS_EXTRA_LARGE)),
        color: Theme.of(context).cardColor,
      ),
      child: Column(mainAxisSize: MainAxisSize.min, children: [

        InkWell(
          onTap: () => Get.back(),
          child: Icon(Icons.keyboard_arrow_down_rounded, size: 30),
        ),
        SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),

        GridView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4, childAspectRatio: (1/1.2),
            crossAxisSpacing: Dimensions.PADDING_SIZE_EXTRA_SMALL, mainAxisSpacing: Dimensions.PADDING_SIZE_EXTRA_SMALL,
          ),
          itemCount: _menuList.length,
          itemBuilder: (context, index) {
            return MenuButton(menu: _menuList[index], isProfile: index == 0, isLogout: index == _menuList.length-1);
          },
        ),
        SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

      ]),
    );
  }
}
