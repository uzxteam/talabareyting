import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/controller/auth_controller.dart';
import 'package:sixam_mart/controller/parcel_controller.dart';
import 'package:sixam_mart/data/model/response/address_model.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/view/base/custom_button.dart';
import 'package:sixam_mart/view/base/custom_snackbar.dart';
import 'package:sixam_mart/view/base/footer_view.dart';
import 'package:sixam_mart/view/base/my_text_field.dart';
import 'package:sixam_mart/view/base/text_field_shadow.dart';
import 'package:sixam_mart/view/screens/location/pick_map_screen.dart';
import 'package:sixam_mart/view/screens/location/widget/serach_location_widget.dart';
import 'package:sixam_mart/view/screens/parcel/widget/address_dialog.dart';
class ParcelView extends StatefulWidget {
  final bool isSender ;
  final Widget bottomButton;
  final TextEditingController nameController;
  final TextEditingController phoneController;
  final TextEditingController streetController;
  final TextEditingController houseController;
  final TextEditingController floorController;

  ParcelView({
    Key key, @required this.isSender, @required this.nameController, @required this.phoneController,
    @required this.streetController, @required this.houseController, @required this.floorController, @required this.bottomButton
  }) : super(key: key);

  @override
  State<ParcelView> createState() => _ParcelViewState();
}

class _ParcelViewState extends State<ParcelView> {
  ScrollController scrollController = ScrollController();
  final FocusNode _streetNode = FocusNode();
  final FocusNode _houseNode = FocusNode();
  final FocusNode _floorNode = FocusNode();
  final FocusNode _nameNode = FocusNode();
  final FocusNode _phoneNode = FocusNode();

  @override
  void dispose() {
    super.dispose();

    scrollController?.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return SizedBox(width: Dimensions.WEB_MAX_WIDTH, child: GetBuilder<ParcelController>(builder: (parcelController) {

        return SingleChildScrollView(
          controller: ScrollController(),
          child: Center(child: FooterView(
            child: SizedBox(width: Dimensions.WEB_MAX_WIDTH, child: Padding(
              padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
              child: Column(children: [
                SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

                SearchLocationWidget(
                  mapController: null,
                  pickedAddress: parcelController.isSender ? parcelController.pickupAddress.address : parcelController.destinationAddress != null ? parcelController.destinationAddress.address : '',
                  isEnabled: widget.isSender ? parcelController.isPickedUp : !parcelController.isPickedUp,
                  isPickedUp: parcelController.isSender,
                  hint: parcelController.isSender ? 'pick_up'.tr : 'destination'.tr,
                ),
                SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

                Row(children: [
                  Expanded(flex: 4,
                    child: CustomButton(
                      buttonText: 'set_from_map'.tr,
                      onPressed: () => Get.toNamed(RouteHelper.getPickMapRoute('parcel', false), arguments: PickMapScreen(
                        fromSignUp: false, fromAddAddress: false, canRoute: false, route: '', onPicked: (AddressModel address) {
                        if(parcelController.isPickedUp) {
                          parcelController.setPickupAddress(address, true);
                        }else {
                          parcelController.setDestinationAddress(address);
                        }
                      },
                      )),
                    ),
                  ),
                  SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                  Expanded(flex: 6,
                      child: InkWell(
                        onTap: (){
                          if(Get.find<AuthController>().isLoggedIn()) {
                            Get.dialog(AddressDialog(onTap: (AddressModel address) {
                              widget.streetController.text = address.streetNumber ?? '';
                              widget.houseController.text = address.house ?? '';
                              widget.floorController.text = address.floor ?? '';
                            }));
                          }else {
                            showCustomSnackBar('you_are_not_logged_in'.tr);
                          }
                        },
                        child: Container(
                          height: ResponsiveHelper.isDesktop(context) ? 44 : 50,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL), border: Border.all(color: Theme.of(context).primaryColor, width: 1)),
                          child: Center(child: Text('set_from_saved_address'.tr, style: robotoBold.copyWith(color: Theme.of(context).primaryColor, fontSize: Dimensions.fontSizeLarge))),
                        ),
                      )
                  ),
                ]),

                SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                Column(children: [

                  Center(child: Text(parcelController.isSender ? 'sender_information'.tr : 'receiver_information'.tr, style: robotoMedium)),
                  SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),

                  TextFieldShadow(
                    child: MyTextField(
                      hintText: parcelController.isSender ? 'sender_name'.tr : 'receiver_name'.tr,
                      inputType: TextInputType.name,
                      controller: widget.nameController,
                      focusNode: _nameNode,
                      nextFocus: _phoneNode,
                      capitalization: TextCapitalization.words,
                    ),
                  ),
                  SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),

                  TextFieldShadow(
                    child: MyTextField(
                      hintText: parcelController.isSender ? 'sender_phone_number'.tr : 'receiver_phone_number'.tr,
                      inputType: TextInputType.phone,
                      focusNode: _phoneNode,
                      nextFocus: _streetNode,
                      controller: widget.phoneController,
                    ),
                  ),
                  SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),
                ]),

                Column(children: [

                  Center(child: Text(parcelController.isSender ? 'pickup_information'.tr : 'destination_information'.tr, style: robotoMedium)),
                  SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),

                  TextFieldShadow(
                    child: MyTextField(
                      hintText: "${'street_number'.tr} ",
                      inputType: TextInputType.streetAddress,
                      focusNode: _streetNode,
                      nextFocus: _houseNode,
                      controller: widget.streetController,
                    ),
                  ),
                  SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),

                  Row(children: [
                    Expanded(
                      child: TextFieldShadow(
                        child: MyTextField(
                          hintText: "${'house'.tr}",
                          inputType: TextInputType.text,
                          focusNode: _houseNode,
                          nextFocus: _floorNode,
                          controller: widget.houseController,
                        ),
                      ),
                    ),
                    SizedBox(width: Dimensions.PADDING_SIZE_SMALL),

                    Expanded(
                      child: TextFieldShadow(
                        child: MyTextField(
                          hintText: "${'floor'.tr}",
                          inputType: TextInputType.text,
                          focusNode: _floorNode,
                          inputAction: TextInputAction.done,
                          controller: widget.floorController,
                        ),
                      ),
                    ),
                  ]),
                  SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                ]),

                ResponsiveHelper.isDesktop(context) ? widget.bottomButton : SizedBox(),

              ]),
            )),
          )),
        );
        }
      ),
    );
  }
}
