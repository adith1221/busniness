import 'package:flutter/material.dart';
import 'package:busniness/components/network_image_with_loader.dart';
import 'package:busniness/constants.dart';
import 'package:busniness/route/route_constants.dart';
import 'package:busniness/screens/collection/views/collection_products_screen.dart';
import 'package:busniness/screens/profile/views/profile_screen.dart';
import 'package:busniness/services/shopify_service.dart';

import 'components/best_sellers.dart';
import 'components/categories.dart';
import 'components/flash_sale.dart';
import 'components/most_popular.dart';
import 'components/popular_products.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final Future<List<ShopifyCollection>> _collectionsFuture;

  @override
  void initState() {
    super.initState();
    _collectionsFuture = ShopifyService().fetchCollections();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFDFC),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: _BabyHomeHeader(
                onSearch: () => Navigator.pushNamed(context, searchScreenRoute),
              ),
            ),
            const SliverToBoxAdapter(child: Categories()),
            SliverToBoxAdapter(
              child: _RestockBanner(
                onTap: () => _openCategory('All Category'),
              ),
            ),
            SliverToBoxAdapter(
              child: FutureBuilder<List<ShopifyCollection>>(
                future: _collectionsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 38),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  final collections = snapshot.data ?? [];
                  return _CollectionGrid(collections: collections);
                },
              ),
            ),
            const SliverToBoxAdapter(child: PopularProducts()),
            const SliverPadding(
              padding: EdgeInsets.symmetric(vertical: defaultPadding * 1.5),
              sliver: SliverToBoxAdapter(child: FlashSale()),
            ),
            const SliverToBoxAdapter(child: BestSellers()),
            const SliverToBoxAdapter(child: MostPopular()),
          ],
        ),
      ),
    );
  }

  void _openCategory(String title, {String? tag}) {
    Navigator.pushNamed(
      context,
      collectionProductsScreenRoute,
      arguments: CategoryProductsArguments(title: title, tag: tag),
    );
  }
}

class _BabyHomeHeader extends StatelessWidget {
  const _BabyHomeHeader({
    required this.onSearch,
  });

  final VoidCallback onSearch;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      decoration: const BoxDecoration(
        color: Color(0xFFFFDDE9),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(22)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Mimsico',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
                    ),
                    SizedBox(height: 3),
                    Row(
                      children: [
                        Icon(Icons.location_on_rounded, size: 17),
                        SizedBox(width: 3),
                        Expanded(
                          child: Text(
                            'Delivering to your selected location',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                        Icon(Icons.keyboard_arrow_down_rounded, size: 19),
                      ],
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () => Navigator.pushNamed(context, profileScreenRoute),
                borderRadius: BorderRadius.circular(24),
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.person_outline_rounded, size: 27),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          InkWell(
            onTap: onSearch,
            borderRadius: BorderRadius.circular(18),
            child: Container(
              height: 58,
              padding: const EdgeInsets.symmetric(horizontal: 17),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(18)),
              child: const Row(
                children: [
                  Icon(Icons.search_rounded, size: 30),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Search toys, clothes, baby care...',
                      style: TextStyle(color: Color(0xFF82797E), fontSize: 16),
                    ),
                  ),
                  Icon(Icons.mic_none_rounded),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}

class _RestockBanner extends StatelessWidget {
  const _RestockBanner({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Ink(
        height: 178,
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          gradient:
              LinearGradient(colors: [Color(0xFFFFE2A7), Color(0xFFFFB9D2)]),
        ),
        child: Stack(
          children: [
            const Positioned(
              right: 2,
              bottom: -12,
              child:
                  Icon(Icons.toys_rounded, size: 148, color: Color(0x55AA497B)),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'RESTOCK\nRUSH',
                  style: TextStyle(
                      fontSize: 34, height: .85, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 10),
                const Text('Fresh favourites for your little one',
                    style: TextStyle(fontWeight: FontWeight.w700)),
                const Spacer(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                      color: const Color(0xFF402534),
                      borderRadius: BorderRadius.circular(18)),
                  child: const Text('Shop now',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CollectionGrid extends StatelessWidget {
  const _CollectionGrid({required this.collections});

  final List<ShopifyCollection> collections;
  static const _previewCount = 6;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 22, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Shop by category',
                  style: TextStyle(fontSize: 23, fontWeight: FontWeight.w900),
                ),
              ),
              if (collections.length > _previewCount)
                TextButton(
                  onPressed: () => Navigator.pushNamed(
                    context,
                    collectionsScreenRoute,
                  ),
                  child: const Text('View all'),
                ),
            ],
          ),
          const SizedBox(height: 14),
          if (collections.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 18),
              child:
                  Center(child: Text('No Shopify collections available yet')),
            )
          else
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: collections.length > _previewCount
                  ? _previewCount
                  : collections.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: .66,
                crossAxisSpacing: 13,
                mainAxisSpacing: 15,
              ),
              itemBuilder: (context, index) {
                final collection = collections[index];
                return _PhotoCategoryCard(
                  title: collection.title,
                  image: collection.imageUrl,
                  onTap: () => Navigator.pushNamed(
                    context,
                    collectionProductsScreenRoute,
                    arguments: CategoryProductsArguments(
                      title: collection.title,
                      tag: collection.handle,
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}

class _PhotoCategoryCard extends StatelessWidget {
  const _PhotoCategoryCard({
    required this.title,
    required this.image,
    required this.onTap,
  });

  final String title;
  final String image;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Ink(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
                color: Color(0x18000000), blurRadius: 9, offset: Offset(0, 3))
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Column(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: image.isEmpty
                      ? const ColoredBox(
                          color: Color(0xFFFFF0F5),
                          child: Center(
                              child: Icon(Icons.child_care_rounded, size: 40)),
                        )
                      : Stack(
                          fit: StackFit.expand,
                          children: [
                            NetworkImageWithLoader(image, radius: 15),
                            const Align(
                              alignment: Alignment.bottomCenter,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.transparent,
                                      Color(0x99000000)
                                    ],
                                  ),
                                ),
                                child: SizedBox.expand(),
                              ),
                            ),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: 7),
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style:
                    const TextStyle(fontSize: 12, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 2),
            ],
          ),
        ),
      ),
    );
  }
}
