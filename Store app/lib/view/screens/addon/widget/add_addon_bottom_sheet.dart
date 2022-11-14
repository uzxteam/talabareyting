import 'package:sixam_mart_store/controller/addon_controller.dart';
import 'package:sixam_mart_store/controller/splash_controller.dart';
import 'package:sixam_mart_store/data/model/response/config_model.dart';
import 'package:sixam_mart_store/data/model/response/item_model.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/view/base/custom_button.dart';
import 'package:sixam_mart_store/view/base/custom_snackbar.dart';
import 'package:sixam_mart_store/view/base/my_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddAddonBottomSheet extends StatefulWidget {
  final AddOns addon;
  AddAddonBottomSheet({@required this.addon});

  @override
  State<AddAddonBottomSheet> createState() => _AddAddonBottomSheetState();
}

class _AddAddonBottomSheetState extends State<AddAddonBottomSheet> {
  final List<TextEditingController> _nameControllers = [];
  final TextEditingController _priceController = TextEditingController();
  final List<FocusNode> _nameNodes = [];
  final FocusNode _priceNode = FocusNode();
  List<Language> _languageList = Get.find<SplashController>().configModel.language;

  @override
  void initState() {
    super.initState();

    if(widget.addon != null) {
      for(int index=0; index<_languageList.length; index++) {
        _nameControllers.add(TextEditingController(text: widget.addon.translations[widget.addon.translations.length-1].value));
        _nameNodes.add(FocusNode());
        for(Translation translation in widget.addon.translations) {
          if(_languageList[index].key == translation.locale && translation.key == 'name') {
            _nameControllers[index] = TextEditingController(text: translation.value);
            break;
          }
        }
      }
      _priceController.text = widget.addon.price.toString();
    }else {
      _languageList.forEach((language) {
        _nameControllers.add(TextEditingController());
        _nameNodes.add(FocusNode());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(Dimensions.RADIUS_LARGE)),
      ),
      child: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, children: [

        ListView.builder(
          itemCount: _languageList.length,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_LARGE),
              child: MyTextField(
                hintText: '${'addon_name'.tr} (${_languageList[index].value})',
                controller: _nameControllers[index],
                focusNode: _nameNodes[index],
                nextFocus: index != _languageList.length-1 ? _nameNodes[index+1] : _priceNode,
                inputType: TextInputType.name,
                capitalization: TextCapitalization.words,
              ),
            );
          },
        ),

        MyTextField(
          hintText: 'price'.tr,
          controller: _priceController,
          focusNode: _priceNode,
          inputAction: TextInputAction.done,
          inputType: TextInputType.number,
          isAmount: true,
          amountIcon: true,
        ),
        SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_LARGE),

        GetBuilder<AddonController>(builder: (addonController) {
          return !addonController.isLoading ? CustomButton(
            onPressed: () {
              String _name = _nameControllers[0].text.trim();
              String _price = _priceController.text.trim();
              if(_name.isEmpty) {
                showCustomSnackBar('enter_addon_name'.tr);
              }else if(_price.isEmpty) {
                showCustomSnackBar('enter_addon_price'.tr);
              }else {
                List<Translation> _nameList = [];
                for(int index=0; index<_languageList.length; index++) {
                  _nameList.add(Translation(
                    locale: _languageList[index].key, key: 'name',
                    value: _nameControllers[index].text.trim().isNotEmpty ? _nameControllers[index].text.trim()
                        : _nameControllers[0].text.trim(),
                  ));
                }
                AddOns _addon = AddOns(name: _name, price: double.parse(_price), translations: _nameList);
                if(widget.addon != null) {
                  _addon.id = widget.addon.id;
                  addonController.updateAddon(_addon);
                }else {
                  addonController.addAddon(_addon);
                }
              }
            },
            buttonText: widget.addon != null ? 'update'.tr : 'submit'.tr,
          ) : Center(child: CircularProgressIndicator());
        }),

      ])),
    );
  }
}
