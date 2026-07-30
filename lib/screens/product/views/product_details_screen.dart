import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:busniness/components/buy_full_ui_kit.dart';
import 'package:busniness/components/cart_button.dart';
import 'package:busniness/components/custom_modal_bottom_sheet.dart';
import 'package:busniness/components/product/product_card.dart';
import 'package:busniness/constants.dart';
import 'package:busniness/models/product_model.dart';
import 'package:busniness/screens/product/views/product_returns_screen.dart';
import 'package:busniness/route/screen_export.dart';
import 'package:busniness/services/shopify_service.dart';

import 'components/notify_me_card.dart';
import 'components/product_images.dart';
import 'components/product_info.dart';
import 'components/product_list_tile.dart';
import '../../../components/review_card.dart';
import 'product_buy_now_screen.dart';

class ProductDetailsScreen extends StatefulWidget {
  const ProductDetailsScreen({
    super.key,
    this.product,
    this.isProductAvailable = true,
  });

  final ProductModel? product;
  final bool isProductAvailable;

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  final ShopifyService _shopifyService = ShopifyService();
  late Future<List<ProductModel>> _relatedProductsFuture;

  @override
  void initState() {
    super.initState();
    _relatedProductsFuture = _shopifyService.fetchProducts(first: 12);
  }

  @override
  void didUpdateWidget(covariant ProductDetailsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.product?.shopifyId != oldWidget.product?.shopifyId) {
      // If the product changes, you might want to refetch related products
      // or just ensure the UI rebuilds with the new product data.
      // For now, we are just rebuilding.
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedProduct = widget.product ??
        ProductModel(
          image: '',
          brandName: 'Shopify',
          title: 'Product',
          price: 0,
          images: const [],
        );

    final galleryImages = selectedProduct.images.isNotEmpty
        ? selectedProduct.images
        : (selectedProduct.image.isNotEmpty
            ? [selectedProduct.image]
            : [productDemoImg1]);

    return Scaffold(
      bottomNavigationBar: widget.isProductAvailable
          ? CartButton(
              price: selectedProduct.priceAfetDiscount ?? selectedProduct.price,
              press: () {
                customModalBottomSheet(
                  context,
                  height: MediaQuery.of(context).size.height * 0.92,
                  child: ProductBuyNowScreen(product: selectedProduct),
                );
              },
            )
          :

          /// If profuct is not available then show [NotifyMeCard]
          NotifyMeCard(isNotify: false, onChanged: (value) {}),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              floating: true,
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: SvgPicture.asset(
                    "assets/icons/Bookmark.svg",
                    colorFilter: ColorFilter.mode(
                      Theme.of(context).textTheme.bodyLarge!.color!,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ],
            ),
            ProductImages(images: galleryImages),
            ProductInfo(
              brand: selectedProduct.brandName.toUpperCase(),
              title: selectedProduct.title,
              isAvailable: widget.isProductAvailable,
              description: selectedProduct.description ??
                  "A cool gray cap in soft corduroy. Watch me.' By buying cotton products from Lindex, you’re supporting more responsibly...",
              rating: 4.4,
              numOfReviews: 126,
            ),
            ProductListTile(
              svgSrc: "assets/icons/Product.svg",
              title: "Product Details",
              press: () {
                customModalBottomSheet(
                  context,
                  height: MediaQuery.of(context).size.height * 0.92,
                  child: const BuyFullKit(
                    images: ["assets/screens/Product detail.png"],
                  ),
                );
              },
            ),
            ProductListTile(
              svgSrc: "assets/icons/Delivery.svg",
              title: "Shipping Information",
              press: () {
                customModalBottomSheet(
                  context,
                  height: MediaQuery.of(context).size.height * 0.92,
                  child: const BuyFullKit(
                    images: ["assets/screens/Shipping information.png"],
                  ),
                );
              },
            ),
            ProductListTile(
              svgSrc: "assets/icons/Return.svg",
              title: "Returns",
              isShowBottomBorder: true,
              press: () {
                customModalBottomSheet(
                  context,
                  height: MediaQuery.of(context).size.height * 0.92,
                  child: const ProductReturnsScreen(),
                );
              },
            ),
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(defaultPadding),
                child: ReviewCard(
                  rating: 4.3,
                  numOfReviews: 128,
                  numOfFiveStar: 80,
                  numOfFourStar: 30,
                  numOfThreeStar: 5,
                  numOfTwoStar: 4,
                  numOfOneStar: 1,
                ),
              ),
            ),
            ProductListTile(
              svgSrc: "assets/icons/Chat.svg",
              title: "Reviews",
              isShowBottomBorder: true,
              press: () {
                Navigator.pushNamed(context, productReviewsScreenRoute);
              },
            ),
            SliverPadding(
              padding: const EdgeInsets.all(defaultPadding),
              sliver: SliverToBoxAdapter(
                child: Text(
                  "You may also like",
                  style: Theme.of(context).textTheme.titleSmall!,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: FutureBuilder<List<ProductModel>>(
                future: _relatedProductsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SizedBox(
                      height: 220,
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  final products = snapshot.data ?? [];

                  bool isCurrentProduct(ProductModel item) {
                    if (selectedProduct.shopifyId != null &&
                        item.shopifyId != null) {
                      return item.shopifyId == selectedProduct.shopifyId;
                    }
                    return item.title == selectedProduct.title &&
                        item.brandName == selectedProduct.brandName;
                  }

                  final relatedProducts = products
                      .where((item) => !isCurrentProduct(item))
                      .take(5)
                      .toList();

                  if (relatedProducts.isEmpty) {
                    return const SizedBox.shrink();
                  }

                  return SizedBox(
                    height: 220,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: relatedProducts.length,
                      itemBuilder: (context, index) => Padding(
                        padding: EdgeInsets.only(
                          left: defaultPadding,
                          right: index == relatedProducts.length - 1
                              ? defaultPadding
                              : 0,
                        ),
                        child: ProductCard(
                          image: relatedProducts[index].image,
                          title: relatedProducts[index].title,
                          brandName: relatedProducts[index].brandName,
                          price: relatedProducts[index].price,
                          priceAfetDiscount:
                              relatedProducts[index].priceAfetDiscount,
                          dicountpercent: relatedProducts[index].dicountpercent,
                          press: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProductDetailsScreen(
                                  key: ValueKey(
                                      relatedProducts[index].shopifyId),
                                  product: relatedProducts[index],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: defaultPadding)),
          ],
        ),
      ),
    );
  }
}
