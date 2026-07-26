import 'dart:async';

import 'package:flutter/material.dart';
import 'package:busniness/components/Banner/S/banner_s_style_1.dart';
import 'package:busniness/components/Banner/S/banner_s_style_5.dart';
import 'package:busniness/constants.dart';
import 'package:busniness/route/screen_export.dart';
import 'package:busniness/services/shopify_service.dart';

import 'components/best_sellers.dart';
import 'components/flash_sale.dart';
import 'components/most_popular.dart';
import 'components/offer_carousel_and_categories.dart';
import 'components/popular_products.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final Future<List<ShopifyCollection>> _collectionsFuture;
  final PageController _pageController = PageController();
  Timer? _autoScrollTimer;
  int _currentPage = 0;
  int _bannerCount = 0;

  @override
  void initState() {
    super.initState();
    _collectionsFuture = ShopifyService().fetchCollections();
  }

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoScroll(List<ShopifyCollection> collections) {
    final count = collections.length;
    if (count < 2) {
      _bannerCount = count;
      _autoScrollTimer?.cancel();
      _autoScrollTimer = null;
      return;
    }

    if (_bannerCount == count && _autoScrollTimer != null) {
      return;
    }

    _bannerCount = count;
    _autoScrollTimer?.cancel();
    _autoScrollTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!mounted || _bannerCount < 2 || !_pageController.hasClients) {
        return;
      }
      final nextPage = (_currentPage + 1) % _bannerCount;
      _pageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            const SliverToBoxAdapter(child: OffersCarouselAndCategories()),
            const SliverToBoxAdapter(child: PopularProducts()),
            const SliverPadding(
              padding: EdgeInsets.symmetric(vertical: defaultPadding * 1.5),
              sliver: SliverToBoxAdapter(child: FlashSale()),
            ),
            SliverToBoxAdapter(
              child: Column(
                children: [
                  // While loading use 👇
                  // const BannerMSkelton(),‚
                  BannerSStyle1(
                    title: "New \narrival",
                    subtitle: "SPECIAL OFFER",
                    discountParcent: 50,
                    press: () {
                      Navigator.pushNamed(context, onSaleScreenRoute);
                    },
                  ),
                  const SizedBox(height: defaultPadding / 4),
                  // We have 4 banner styles, all in the pro version
                ],
              ),
            ),
            const SliverToBoxAdapter(child: BestSellers()),
            const SliverToBoxAdapter(child: MostPopular()),
            SliverToBoxAdapter(
              child: FutureBuilder<List<ShopifyCollection>>(
                future: _collectionsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: defaultPadding),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  final collections = snapshot.data ?? [];
                  _startAutoScroll(collections);

                  if (collections.isEmpty) {
                    return const SizedBox.shrink();
                  }

                  return Column(
                    children: [
                      const SizedBox(height: defaultPadding * 1.5),
                      SizedBox(
                        height: 180,
                        child: PageView.builder(
                          controller: _pageController,
                          itemCount: collections.length,
                          onPageChanged: (index) {
                            setState(() {
                              _currentPage = index;
                            });
                          },
                          itemBuilder: (context, index) {
                            final collection = collections[index];
                            final title = collection.title.toUpperCase();
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: defaultPadding,
                              ),
                              child: AspectRatio(
                                aspectRatio: 1.00,
                                child: BannerSStyle5(
                                  image: collection.imageUrl.isNotEmpty
                                      ? collection.imageUrl
                                      : null,
                                  title: title,
                                  subtitle: 'Shop collection',
                                  bottomText: 'Explore'.toUpperCase(),
                                  press: () {
                                    Navigator.pushNamed(
                                      context,
                                      collectionProductsScreenRoute,
                                      arguments: collection.handle,
                                    );
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: defaultPadding / 4),
                    ],
                  );
                },
              ),
            ),
            const SliverToBoxAdapter(child: BestSellers()),
          ],
        ),
      ),
    );
  }
}
