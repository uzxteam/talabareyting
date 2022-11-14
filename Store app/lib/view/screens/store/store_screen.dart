import 'package:sixam_mart_store/controller/auth_controller.dart';
import 'package:sixam_mart_store/controller/store_controller.dart';
import 'package:sixam_mart_store/controller/splash_controller.dart';
import 'package:sixam_mart_store/data/model/response/profile_model.dart';
import 'package:sixam_mart_store/helper/price_converter.dart';
import 'package:sixam_mart_store/helper/route_helper.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/images.dart';
import 'package:sixam_mart_store/util/styles.dart';
import 'package:sixam_mart_store/view/base/custom_image.dart';
import 'package:sixam_mart_store/view/base/custom_snackbar.dart';
import 'package:sixam_mart_store/view/screens/store/widget/item_view.dart';
import 'package:sixam_mart_store/view/screens/store/widget/review_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StoreScreen extends StatefulWidget {
  @override
  State<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  TabController _tabController;
  bool _review = Get.find<AuthController>().profileModel.stores[0].reviewsSection;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: _review ? 2 : 1, initialIndex: 0, vsync: this);
    _tabController.addListener(() {
      Get.find<StoreController>().setTabIndex(_tabController.index);
    });
    Get.find<StoreController>().getItemList('1', 'all');
    Get.find<StoreController>().getStoreReviewList(Get.find<AuthController>().profileModel.stores[0].id);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<StoreController>(builder: (storeController) {
      return GetBuilder<AuthController>(builder: (authController) {
        Store _store = authController.profileModel != null ? authController.profileModel.stores[0] : null;

        return Scaffold(
          backgroundColor: Theme.of(context).cardColor,

          floatingActionButton: storeController.tabIndex == 0 ? FloatingActionButton(
            heroTag: 'nothing',
            onPressed: () {
              if(Get.find<AuthController>().profileModel.stores[0].itemSection) {
                if (_store != null) {
                  Get.toNamed(RouteHelper.getItemRoute(null));
                }
              }else {
                showCustomSnackBar('this_feature_is_blocked_by_admin'.tr);
              }
            },
            backgroundColor: Theme.of(context).primaryColor,
            child: Icon(Icons.add_circle_outline, color: Theme.of(context).cardColor, size: 30),
          ) : null,

          body: _store != null ? CustomScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            controller: _scrollController,
            slivers: [

              SliverAppBar(
                expandedHeight: 230, toolbarHeight: 50,
                pinned: true, floating: false,
                backgroundColor: Theme.of(context).primaryColor,
                actions: [IconButton(
                  icon: Container(
                    height: 50, width: 50, alignment: Alignment.center,
                    padding: EdgeInsets.all(7),
                    decoration: BoxDecoration(color: Theme.of(context).primaryColor, borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL)),
                    child: Image.asset(Images.edit),
                  ),
                  onPressed: () => Get.toNamed(RouteHelper.getStoreSettingsRoute(_store)),
                )],
                flexibleSpace: FlexibleSpaceBar(
                  background: CustomImage(
                    fit: BoxFit.cover, placeholder: Images.restaurant_cover,
                    image: '${Get.find<SplashController>().configModel.baseUrls.storeCoverPhotoUrl}/${_store.coverPhoto}',
                  ),
                ),
              ),

              SliverToBoxAdapter(child: Center(child: Container(
                width: 1170,
                padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                color: Theme.of(context).cardColor,
                child: Column(children: [
                  Row(children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                      child: CustomImage(
                        image: '${Get.find<SplashController>().configModel.baseUrls.storeImageUrl}/${_store.logo}',
                        height: 40, width: 50, fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(
                        _store.name, style: robotoMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE),
                        maxLines: 1, overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        _store.address ?? '', maxLines: 1, overflow: TextOverflow.ellipsis,
                        style: robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL, color: Theme.of(context).disabledColor),
                      ),
                    ])),
                  ]),
                  SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),

                  // _restaurant.availableTimeStarts != null ? Row(children: [
                  //   Text('daily_time'.tr, style: robotoRegular.copyWith(
                  //     fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL, color: Theme.of(context).disabledColor,
                  //   )),
                  //   SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                  //   Text(
                  //     '${DateConverter.convertStringTimeToTime(_restaurant.availableTimeStarts)}'
                  //         ' - ${DateConverter.convertStringTimeToTime(_restaurant.availableTimeEnds)}',
                  //     style: robotoMedium.copyWith(fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL, color: Theme.of(context).primaryColor),
                  //   ),
                  // ]) : SizedBox(),
                  // SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),

                  Row(children: [
                    Icon(Icons.star, color: Theme.of(context).primaryColor, size: 18),
                    Text(
                      _store.avgRating.toStringAsFixed(1),
                      style: robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL),
                    ),
                    SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                    Text(
                      '${_store.ratingCount} ${'ratings'.tr}',
                      style: robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL, color: Theme.of(context).disabledColor),
                    ),
                  ]),
                  SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

                  _store.discount != null ? Container(
                    width: context.width,
                    margin: EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_SMALL),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL), color: Theme.of(context).primaryColor),
                    padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Text(
                        _store.discount.discountType == 'percent' ? '${_store.discount.discount}% ${'off'.tr}'
                            : '${PriceConverter.convertPrice(_store.discount.discount)} ${'off'.tr}',
                        style: robotoMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE, color: Theme.of(context).cardColor),
                      ),
                      Text(
                        _store.discount.discountType == 'percent'
                            ? '${'enjoy'.tr} ${_store.discount.discount}% ${'off_on_all_categories'.tr}'
                            : '${'enjoy'.tr} ${PriceConverter.convertPrice(_store.discount.discount)}'
                            ' ${'off_on_all_categories'.tr}',
                        style: robotoMedium.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL, color: Theme.of(context).cardColor),
                      ),
                      SizedBox(height: (_store.discount.minPurchase != 0 || _store.discount.maxDiscount != 0) ? 5 : 0),
                      _store.discount.minPurchase != 0 ? Text(
                        '[ ${'minimum_purchase'.tr}: ${PriceConverter.convertPrice(_store.discount.minPurchase)} ]',
                        style: robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL, color: Theme.of(context).cardColor),
                      ) : SizedBox(),
                      _store.discount.maxDiscount != 0 ? Text(
                        '[ ${'maximum_discount'.tr}: ${PriceConverter.convertPrice(_store.discount.maxDiscount)} ]',
                        style: robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL, color: Theme.of(context).cardColor),
                      ) : SizedBox(),
                    ]),
                  ) : SizedBox(),

                  (_store.delivery && _store.freeDelivery) ? Text(
                    'free_delivery'.tr,
                    style: robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL, color: Theme.of(context).primaryColor),
                  ) : SizedBox(),

                ]),
              ))),

              SliverPersistentHeader(
                pinned: true,
                delegate: SliverDelegate(child: Center(child: Container(
                  width: 1170,
                  decoration: BoxDecoration(color: Theme.of(context).cardColor),
                  child: TabBar(
                    controller: _tabController,
                    indicatorColor: Theme.of(context).primaryColor,
                    indicatorWeight: 3,
                    labelColor: Theme.of(context).primaryColor,
                    unselectedLabelColor: Theme.of(context).disabledColor,
                    unselectedLabelStyle: robotoRegular.copyWith(color: Theme.of(context).disabledColor, fontSize: Dimensions.FONT_SIZE_SMALL),
                    labelStyle: robotoBold.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL, color: Theme.of(context).primaryColor),
                    tabs: _review ? [
                      Tab(text: 'all_items'.tr),
                      Tab(text: 'reviews'.tr),
                    ] : [
                      Tab(text: 'all_items'.tr),
                    ],
                  ),
                ))),
              ),

              SliverToBoxAdapter(child: AnimatedBuilder(
                animation: _tabController.animation,
                builder: (context, child) {
                  if (_tabController.index == 0) {
                    return ItemView(scrollController: _scrollController, type: storeController.type, onVegFilterTap: (String type) {
                      Get.find<StoreController>().getItemList('1', type);
                    });
                  } else {
                    return storeController.storeReviewList != null ? storeController.storeReviewList.length > 0 ? ListView.builder(
                      itemCount: storeController.storeReviewList.length,
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                      itemBuilder: (context, index) {
                        return ReviewWidget(
                          review: storeController.storeReviewList[index], fromStore: true,
                          hasDivider: index != storeController.storeReviewList.length-1,
                        );
                      },
                    ) : Padding(
                      padding: EdgeInsets.only(top: Dimensions.PADDING_SIZE_LARGE),
                      child: Center(child: Text('no_review_found'.tr, style: robotoRegular.copyWith(color: Theme.of(context).disabledColor))),
                    ) : Padding(
                      padding: EdgeInsets.only(top: Dimensions.PADDING_SIZE_LARGE),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                },
              )),
            ],
          ) : Center(child: CircularProgressIndicator()),
        );
      });
    });
  }
}

class SliverDelegate extends SliverPersistentHeaderDelegate {
  Widget child;

  SliverDelegate({@required this.child});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => 50;

  @override
  double get minExtent => 50;

  @override
  bool shouldRebuild(SliverDelegate oldDelegate) {
    return oldDelegate.maxExtent != 50 || oldDelegate.minExtent != 50 || child != oldDelegate.child;
  }
}