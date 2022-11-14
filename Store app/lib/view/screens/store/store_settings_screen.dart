import 'package:sixam_mart_store/controller/store_controller.dart';
import 'package:sixam_mart_store/controller/splash_controller.dart';
import 'package:sixam_mart_store/data/model/response/config_model.dart';
import 'package:sixam_mart_store/data/model/response/profile_model.dart' as Profile;
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/images.dart';
import 'package:sixam_mart_store/util/styles.dart';
import 'package:sixam_mart_store/view/base/custom_app_bar.dart';
import 'package:sixam_mart_store/view/base/custom_button.dart';
import 'package:sixam_mart_store/view/base/custom_drop_down.dart';
import 'package:sixam_mart_store/view/base/custom_snackbar.dart';
import 'package:sixam_mart_store/view/base/my_text_field.dart';
import 'package:sixam_mart_store/view/base/switch_button.dart';
import 'package:sixam_mart_store/view/screens/store/widget/daily_time_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StoreSettingsScreen extends StatefulWidget {
  final Profile.Store store;
  StoreSettingsScreen({@required this.store});

  @override
  State<StoreSettingsScreen> createState() => _StoreSettingsScreenState();
}

class _StoreSettingsScreenState extends State<StoreSettingsScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _orderAmountController = TextEditingController();
  final TextEditingController _deliveryFeeController = TextEditingController();
  final TextEditingController _processingTimeController = TextEditingController();
  final TextEditingController _gstController = TextEditingController();
  final TextEditingController _minimumController = TextEditingController();
  final TextEditingController _maximumController = TextEditingController();
  final FocusNode _nameNode = FocusNode();
  final FocusNode _contactNode = FocusNode();
  final FocusNode _addressNode = FocusNode();
  final FocusNode _orderAmountNode = FocusNode();
  final FocusNode _deliveryFeeNode = FocusNode();
  final FocusNode _minimumNode = FocusNode();
  final FocusNode _maximumNode = FocusNode();
  Profile.Store _store;
  Module _module = Get.find<SplashController>().configModel.moduleConfig.module;

  @override
  void initState() {
    super.initState();

    Get.find<StoreController>().initStoreData(widget.store);

    _nameController.text = widget.store.name;
    _contactController.text = widget.store.phone;
    _addressController.text = widget.store.address;
    _orderAmountController.text = widget.store.minimumOrder.toString();
    _deliveryFeeController.text = widget.store.deliveryCharge.toString();
    _gstController.text = widget.store.gstCode;
    _processingTimeController.text = widget.store.orderPlaceToScheduleInterval.toString();
    if(widget.store.deliveryTime != null && widget.store.deliveryTime.isNotEmpty) {
      try {
        List<String> _typeList = widget.store.deliveryTime.split(' ');
        List<String> _timeList = _typeList[0].split('-');
        _minimumController.text = _timeList[0];
        _maximumController.text = _timeList[1];
        Get.find<StoreController>().setDurationType(Get.find<StoreController>().durations.indexOf(_typeList[1]) + 1, false);
      }catch(e) {}
    }
    _store = widget.store;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: _module.showRestaurantText ? 'restaurant_settings'.tr : 'store_settings'.tr),
      body: GetBuilder<StoreController>(builder: (storeController) {
        return Column(children: [

          Expanded(child: SingleChildScrollView(
            padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
            physics: BouncingScrollPhysics(),
            child: Column(children: [

              Row(children: [
                Text(
                  'logo'.tr,
                  style: robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL, color: Theme.of(context).disabledColor),
                ),
                SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                Text(
                  '(${'max_size_2_mb'.tr})',
                  style: robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL, color: Theme.of(context).errorColor),
                ),
              ]),
              SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
              Align(alignment: Alignment.center, child: Stack(children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                  child: storeController.rawLogo != null ? Image.memory(
                    storeController.rawLogo, width: 150, height: 120, fit: BoxFit.cover,
                  ) : FadeInImage.assetNetwork(
                    placeholder: Images.placeholder,
                    image: '${Get.find<SplashController>().configModel.baseUrls.storeImageUrl}/${widget.store.logo}',
                    height: 120, width: 150, fit: BoxFit.cover,
                    imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholder, height: 120, width: 150, fit: BoxFit.cover),
                  ),
                ),
                Positioned(
                  bottom: 0, right: 0, top: 0, left: 0,
                  child: InkWell(
                    onTap: () => storeController.pickImage(true, false),
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

              MyTextField(
                hintText: _module.showRestaurantText ? 'restaurant_name'.tr : 'store_name'.tr,
                controller: _nameController,
                focusNode: _nameNode,
                nextFocus: _contactNode,
                capitalization: TextCapitalization.words,
                inputType: TextInputType.name,
              ),
              SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

              MyTextField(
                hintText: 'contact_number'.tr,
                controller: _contactController,
                focusNode: _contactNode,
                nextFocus: _addressNode,
                inputType: TextInputType.phone,
              ),
              SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

              MyTextField(
                hintText: 'address'.tr,
                controller: _addressController,
                focusNode: _addressNode,
                nextFocus: _orderAmountNode,
                inputType: TextInputType.streetAddress,
              ),
              SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

              Row(children: [
                Expanded(child: MyTextField(
                  hintText: 'minimum_order_amount'.tr,
                  controller: _orderAmountController,
                  focusNode: _orderAmountNode,
                  nextFocus: _store.selfDeliverySystem == 1 ? _deliveryFeeNode : _minimumNode,
                  inputType: TextInputType.number,
                  isAmount: true,
                )),
                SizedBox(width: _store.selfDeliverySystem == 1 ? Dimensions.PADDING_SIZE_SMALL : 0),
                _store.selfDeliverySystem == 1 ? Expanded(child: MyTextField(
                  hintText: 'delivery_fee'.tr,
                  controller: _deliveryFeeController,
                  focusNode: _deliveryFeeNode,
                  nextFocus: _minimumNode,
                  inputType: TextInputType.number,
                  isAmount: true,
                )) : SizedBox(),
              ]),
              SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

              Align(alignment: Alignment.centerLeft, child: Text(
                'approximate_delivery_time'.tr,
                style: robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL, color: Theme.of(context).disabledColor),
              )),
              SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
              Row(children: [
                Expanded(child: MyTextField(
                  hintText: 'minimum'.tr,
                  controller: _minimumController,
                  focusNode: _minimumNode,
                  nextFocus: _maximumNode,
                  inputType: TextInputType.number,
                  isNumber: true,
                  title: false,
                )),
                SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                Expanded(child: MyTextField(
                  hintText: 'maximum'.tr,
                  controller: _maximumController,
                  focusNode: _maximumNode,
                  inputAction: TextInputAction.done,
                  inputType: TextInputType.number,
                  isNumber: true,
                  title: false,
                )),
                SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                Expanded(child: CustomDropDown(
                  value: storeController.durationIndex.toString(), title: null,
                  dataList: storeController.durations, onChanged: (String value) {
                    storeController.setDurationType(int.parse(value), true);
                  },
                )),
              ]),
              SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

              _module.orderPlaceToScheduleInterval ? MyTextField(
                hintText: 'minimum_processing_time'.tr,
                controller: _processingTimeController,
                inputAction: TextInputAction.done,
                inputType: TextInputType.number,
                isAmount: true,
              ) : SizedBox(),
              SizedBox(height: _module.orderPlaceToScheduleInterval ? Dimensions.PADDING_SIZE_LARGE : 0),

              (_module.vegNonVeg && Get.find<SplashController>().configModel.toggleVegNonVeg) ? Align(alignment: Alignment.centerLeft, child: Text(
                'item_type'.tr,
                style: robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL, color: Theme.of(context).disabledColor),
              )) : SizedBox(),
              (_module.vegNonVeg && Get.find<SplashController>().configModel.toggleVegNonVeg) ? Row(children: [
                Expanded(child: InkWell(
                  onTap: () => storeController.setStoreVeg(!storeController.isStoreVeg, true),
                  child: Row(children: [
                    Checkbox(
                      value: storeController.isStoreVeg,
                      onChanged: (bool isActive) => storeController.setStoreVeg(isActive, true),
                      activeColor: Theme.of(context).primaryColor,
                    ),
                    Text('veg'.tr),
                  ]),
                )),
                SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                Expanded(child: InkWell(
                  onTap: () => storeController.setStoreNonVeg(!storeController.isStoreNonVeg, true),
                  child: Row(children: [
                    Checkbox(
                      value: storeController.isStoreNonVeg,
                      onChanged: (bool isActive) => storeController.setStoreNonVeg(isActive, true),
                      activeColor: Theme.of(context).primaryColor,
                    ),
                    Text('non_veg'.tr),
                  ]),
                )),
              ]) : SizedBox(),
              SizedBox(height: (_module.vegNonVeg && Get.find<SplashController>().configModel.toggleVegNonVeg)
                  ? Dimensions.PADDING_SIZE_LARGE : 0),

              Row(children: [
                Expanded(child: Text(
                  'gst'.tr,
                  style: robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL, color: Theme.of(context).disabledColor),
                )),
                Switch(
                  value: storeController.isGstEnabled,
                  activeColor: Theme.of(context).primaryColor,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  onChanged: (bool isActive) => storeController.toggleGst(),
                ),
              ]),
              MyTextField(
                hintText: 'gst'.tr,
                controller: _gstController,
                inputAction: TextInputAction.done,
                title: false,
                isEnabled: storeController.isGstEnabled,
              ),
              SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

              _module.alwaysOpen ? SizedBox() : Align(alignment: Alignment.centerLeft, child: Text(
                'daily_schedule_time'.tr,
                style: robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL, color: Theme.of(context).disabledColor),
              )),
              SizedBox(height: _module.alwaysOpen ? 0 : Dimensions.PADDING_SIZE_EXTRA_SMALL),
              _module.alwaysOpen ? SizedBox() : ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: 7,
                itemBuilder: (context, index) {
                  return DailyTimeWidget(weekDay: index);
                },
              ),
              SizedBox(height: _module.alwaysOpen ? 0 : Dimensions.PADDING_SIZE_LARGE),

              Get.find<SplashController>().configModel.scheduleOrder ? SwitchButton(
                icon: Icons.alarm_add, title: 'schedule_order'.tr, isButtonActive: widget.store.scheduleOrder, onTap: () {
                  _store.scheduleOrder = !_store.scheduleOrder;
                },
              ) : SizedBox(),
              SizedBox(height: Get.find<SplashController>().configModel.scheduleOrder ? Dimensions.PADDING_SIZE_SMALL : 0),

              SwitchButton(icon: Icons.delivery_dining, title: 'delivery'.tr, isButtonActive: widget.store.delivery, onTap: () {
                _store.delivery = !_store.delivery;
              }),
              SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

              SwitchButton(icon: Icons.house_siding, title: 'take_away'.tr, isButtonActive: widget.store.takeAway, onTap: () {
                _store.takeAway = !_store.takeAway;
              }),
              SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

              Stack(children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                  child: storeController.rawCover != null ? Image.memory(
                    storeController.rawCover, width: context.width, height: 170, fit: BoxFit.cover,
                  ) : FadeInImage.assetNetwork(
                    placeholder: Images.restaurant_cover,
                    image: '${Get.find<SplashController>().configModel.baseUrls.storeCoverPhotoUrl}/${widget.store.coverPhoto}',
                    height: 170, width: context.width, fit: BoxFit.cover,
                    imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholder, height: 170, width: context.width, fit: BoxFit.cover),
                  ),
                ),
                Positioned(
                  bottom: 0, right: 0, top: 0, left: 0,
                  child: InkWell(
                    onTap: () => storeController.pickImage(false, false),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.3), borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                        border: Border.all(width: 1, color: Theme.of(context).primaryColor),
                      ),
                      child: Container(
                        margin: EdgeInsets.all(25),
                        decoration: BoxDecoration(
                          border: Border.all(width: 3, color: Colors.white),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.camera_alt, color: Colors.white, size: 50),
                      ),
                    ),
                  ),
                ),
              ]),

            ]),
          )),

          !storeController.isLoading ? CustomButton(
            margin: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
            onPressed: () {
              String _name = _nameController.text.trim();
              String _contact = _contactController.text.trim();
              String _address = _addressController.text.trim();
              String _minimumOrder = _orderAmountController.text.trim();
              String _deliveryFee = _deliveryFeeController.text.trim();
              String _minimum = _minimumController.text.trim();
              String _maximum = _maximumController.text.trim();
              String _processingTime = _processingTimeController.text.trim();
              String _gstCode = _gstController.text.trim();
              bool _showRestaurantText = _module.showRestaurantText;
              if(_name.isEmpty) {
                showCustomSnackBar(_showRestaurantText ? 'enter_your_restaurant_name'.tr : 'enter_your_store_name');
              }else if(_contact.isEmpty) {
                showCustomSnackBar(_showRestaurantText ? 'enter_restaurant_contact_number'.tr : 'enter_store_contact_number'.tr);
              }else if(_address.isEmpty) {
                showCustomSnackBar(_showRestaurantText ? 'enter_restaurant_address'.tr : 'enter_store_address'.tr);
              }else if(_minimumOrder.isEmpty) {
                showCustomSnackBar('enter_minimum_order_amount'.tr);
              }else if(_store.selfDeliverySystem == 1 && _deliveryFee.isEmpty) {
                showCustomSnackBar('enter_delivery_fee'.tr);
              }else if(_minimum.isEmpty) {
                showCustomSnackBar('enter_minimum_delivery_time'.tr);
              }else if(_maximum.isEmpty) {
                showCustomSnackBar('enter_maximum_delivery_time'.tr);
              }else if(storeController.durationIndex == 0) {
                showCustomSnackBar('select_delivery_time_type'.tr);
              }else if(_module.orderPlaceToScheduleInterval && _processingTime.isEmpty) {
                showCustomSnackBar('enter_minimum_processing_time'.tr);
              }else if(!storeController.isStoreVeg && !storeController.isStoreNonVeg){
                showCustomSnackBar('select_at_least_one_item_type'.tr);
              }else if(_module.orderPlaceToScheduleInterval && _processingTime.isEmpty) {
                showCustomSnackBar('enter_minimum_processing_time'.tr);
              }else if(storeController.isGstEnabled && _gstCode.isEmpty) {
                showCustomSnackBar('enter_gst_code'.tr);
              }else {
                _store.name = _name;
                _store.phone = _contact;
                _store.address = _address;
                _store.minimumOrder = double.parse(_minimumOrder);
                _store.gstStatus = storeController.isGstEnabled;
                _store.gstCode = _gstCode;
                _store.orderPlaceToScheduleInterval = _module.orderPlaceToScheduleInterval
                    ? double.parse(_processingTimeController.text).toInt() : 0;
                _store.deliveryCharge = double.parse(_deliveryFee);
                _store.veg = (_module.vegNonVeg && storeController.isStoreVeg) ? 1 : 0;
                _store.nonVeg = (!_module.vegNonVeg || storeController.isStoreNonVeg) ? 1 : 0;
                storeController.updateStore(
                  _store, _minimum, _maximum, storeController.durations[storeController.durationIndex-1],
                );
              }
            },
            buttonText: 'update'.tr,
          ) : Center(child: CircularProgressIndicator()),

        ]);
      }),
    );
  }
}
