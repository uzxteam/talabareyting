import 'package:sixam_mart_store/controller/delivery_man_controller.dart';
import 'package:sixam_mart_store/controller/splash_controller.dart';
import 'package:sixam_mart_store/data/model/response/delivery_man_model.dart';
import 'package:sixam_mart_store/helper/route_helper.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/images.dart';
import 'package:sixam_mart_store/util/styles.dart';
import 'package:sixam_mart_store/view/base/confirmation_dialog.dart';
import 'package:sixam_mart_store/view/base/custom_app_bar.dart';
import 'package:sixam_mart_store/view/base/custom_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DeliveryManScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Get.find<DeliveryManController>().getDeliveryManList();

    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,

      appBar: CustomAppBar(title: 'delivery_man'.tr),

      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed(RouteHelper.getAddDeliveryManRoute(null)),
        backgroundColor: Theme.of(context).primaryColor,
        child: Icon(Icons.add_circle_outline, color: Theme.of(context).cardColor, size: 30),
      ),

      body: GetBuilder<DeliveryManController>(builder: (dmController) {
        return dmController.deliveryManList != null ? dmController.deliveryManList.length > 0 ? ListView.builder(
          physics: AlwaysScrollableScrollPhysics(),
          itemCount: dmController.deliveryManList.length,
          padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
          itemBuilder: (context, index) {
            DeliveryManModel _deliveryMan = dmController.deliveryManList[index];
            return InkWell(
              onTap: () => Get.toNamed(RouteHelper.getDeliveryManDetailsRoute(_deliveryMan)),
              child: Column(children: [

                Row(children: [

                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: _deliveryMan.active == 1 ? Colors.green : Colors.red, width: 2),
                      shape: BoxShape.circle,
                    ),
                    child: ClipOval(child: CustomImage(
                      image: '${Get.find<SplashController>().configModel.baseUrls.deliveryManImageUrl}/${_deliveryMan.image ?? ''}',
                      height: 50, width: 50, fit: BoxFit.cover,
                    )),
                  ),
                  SizedBox(width: Dimensions.PADDING_SIZE_SMALL),

                  Expanded(child: Text(
                    '${_deliveryMan.fName} ${_deliveryMan.lName}', maxLines: 2, overflow: TextOverflow.ellipsis,
                    style: robotoMedium,
                  )),
                  SizedBox(width: Dimensions.PADDING_SIZE_SMALL),

                  IconButton(
                    onPressed: () => Get.toNamed(RouteHelper.getAddDeliveryManRoute(_deliveryMan)),
                    icon: Icon(Icons.edit, color: Colors.blue),
                  ),

                  IconButton(
                    onPressed: () {
                      Get.dialog(ConfirmationDialog(
                        icon: Images.warning, description: 'are_you_sure_want_to_delete_this_delivery_man'.tr,
                        onYesPressed: () => Get.find<DeliveryManController>().deleteDeliveryMan(_deliveryMan.id),
                      ));
                    },
                    icon: Icon(Icons.delete_forever, color: Colors.red),
                  ),

                ]),

                Padding(
                  padding: EdgeInsets.only(left: 60),
                  child: Divider(
                    color: index == dmController.deliveryManList.length-1 ? Colors.transparent : Theme.of(context).disabledColor,
                  ),
                ),

              ]),
            );
          },
        ) : Center(child: Text('no_delivery_man_found'.tr)) : Center(child: CircularProgressIndicator());
      }),
    );
  }
}
