import 'package:sixam_mart_store/controller/store_controller.dart';
import 'package:sixam_mart_store/controller/splash_controller.dart';
import 'package:sixam_mart_store/data/model/response/category_model.dart';
import 'package:sixam_mart_store/helper/route_helper.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/styles.dart';
import 'package:sixam_mart_store/view/base/custom_app_bar.dart';
import 'package:sixam_mart_store/view/base/custom_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoryScreen extends StatelessWidget {
  final CategoryModel categoryModel;
  CategoryScreen({@required this.categoryModel});

  @override
  Widget build(BuildContext context) {
    bool _isCategory = categoryModel == null;
    if(_isCategory) {
      Get.find<StoreController>().getCategoryList(null);
    }else {
      Get.find<StoreController>().getSubCategoryList(categoryModel.id, null);
    }

    return Scaffold(
      appBar: CustomAppBar(title: _isCategory ? 'categories'.tr : categoryModel.name),
      body: GetBuilder<StoreController>(builder: (storeController) {
        List<CategoryModel> _categories;
        if(_isCategory && storeController.categoryList != null) {
          _categories = [];
          _categories.addAll(storeController.categoryList);
        }else if(!_isCategory && storeController.subCategoryList != null) {
          _categories = [];
          _categories.addAll(storeController.subCategoryList);
        }
        return _categories != null ? _categories.length > 0 ? RefreshIndicator(
          onRefresh: () async {
            if(_isCategory) {
              await Get.find<StoreController>().getCategoryList(null);
            }else {
              await Get.find<StoreController>().getSubCategoryList(categoryModel.id, null);
            }
          },
          child: ListView.builder(
            physics: AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
            padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
            itemCount: _categories.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  if(_isCategory) {
                    Get.toNamed(RouteHelper.getSubCategoriesRoute(_categories[index]));
                  }
                },
                child: Container(
                  margin: EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_SMALL),
                  padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                    color: Theme.of(context).cardColor,
                    boxShadow: [BoxShadow(color: Colors.grey[Get.isDarkMode ? 700 : 300], spreadRadius: 1, blurRadius: 5)],
                  ),
                  child: Row(children: [

                    _isCategory ? ClipRRect(
                      borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                      child: CustomImage(
                        image: '${Get.find<SplashController>().configModel.baseUrls.categoryImageUrl}/${_categories[index].image}',
                        height: 55, width: 65, fit: BoxFit.cover,
                      ),
                    ) : SizedBox(),
                    SizedBox(width: _isCategory ? Dimensions.PADDING_SIZE_SMALL : 0),

                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(_categories[index].name, style: robotoRegular, maxLines: 1, overflow: TextOverflow.ellipsis),
                      SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                      Text(
                        '${'id'.tr}: ${_categories[index].id}',
                        style: robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL, color: Theme.of(context).disabledColor),
                      ),
                    ])),

                  ]),
                ),
              );
            },
          ),
        ) : Center(
          child: Text(_isCategory ? 'no_category_found'.tr : 'no_subcategory_found'.tr),
        ) : Center(child: CircularProgressIndicator());
      }),
    );
  }
}
