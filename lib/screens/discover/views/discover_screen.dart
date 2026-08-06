import 'package:flutter/material.dart';
import 'package:busniness/components/custom_modal_bottom_sheet.dart';
import 'package:busniness/components/product/product_card.dart';
import 'package:busniness/constants.dart';
import 'package:busniness/models/product_model.dart';
import 'package:busniness/route/route_constants.dart';
import 'package:busniness/screens/discover/views/components/filter_bottom_sheet.dart';
import 'package:busniness/screens/search/views/components/search_form.dart';
import 'package:busniness/services/shopify_service.dart';

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  late final Future<List<ShopifyCollection>> _collectionsFuture;
  late final Future<List<ProductModel>> _productsFuture;
  Map<String, String?> _activeFilters = {};

  @override
  void initState() {
    super.initState();
    final shopifyService = ShopifyService();
    _collectionsFuture = shopifyService.fetchCollections();
    _productsFuture = shopifyService.fetchProducts(first: 20);
  }

  List<FilterSectionData> _buildFilterSections(
      List<ShopifyCollection> collections) {
    final collectionOptions = collections
        .map(
          (collection) => FilterOptionData(
            id: collection.handle,
            label: collection.title,
            value: collection.handle,
          ),
        )
        .toList();

    return [
      const FilterSectionData(
        id: 'sort',
        title: 'Sort by',
        options: [
          FilterOptionData(
              id: 'featured', label: 'Featured', value: 'featured'),
          FilterOptionData(
            id: 'price_asc',
            label: 'Price: Low to High',
            value: 'price_asc',
          ),
          FilterOptionData(
            id: 'price_desc',
            label: 'Price: High to Low',
            value: 'price_desc',
          ),
        ],
      ),
      if (collectionOptions.isNotEmpty)
        FilterSectionData(
          id: 'category',
          title: 'Categories',
          options: [
            const FilterOptionData(
              id: 'all',
              label: 'All',
              value: 'all',
            ),
            ...collectionOptions,
          ],
        ),
    ];
  }

  Future<void> _openFilterSheet() async {
    final collections = await _collectionsFuture;

    if (!mounted) {
      return;
    }

    final result = await customModalBottomSheet<Map<String, String?>>(
      context,
      height: MediaQuery.of(context).size.height * 0.72,
      child: FilterBottomSheet(
        sections: _buildFilterSections(collections),
        initialSelection: _activeFilters,
        onApply: (selection) {
          if (mounted) {
            setState(() {
              _activeFilters = selection;
            });
          }
        },
      ),
    );

    if (result != null && mounted) {
      setState(() {
        _activeFilters = result;
      });
    }
  }

  List<ProductModel> _applyFilters(List<ProductModel> products) {
    final filteredProducts = List<ProductModel>.from(products);

    final selectedCategory = _activeFilters['category'];
    if (selectedCategory != null && selectedCategory != 'all') {
      filteredProducts.removeWhere((product) {
        final haystack =
            '${product.title} ${product.brandName} ${product.description ?? ''}'
                .toLowerCase();
        return !haystack.contains(selectedCategory.toLowerCase());
      });
    }

    switch (_activeFilters['sort']) {
      case 'price_asc':
        filteredProducts.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'price_desc':
        filteredProducts.sort((a, b) => b.price.compareTo(a.price));
        break;
      default:
        break;
    }

    return filteredProducts;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              automaticallyImplyLeading: false,
              elevation: 0,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              titleSpacing: 0,
              toolbarHeight: 92,
              title: Padding(
                padding: const EdgeInsets.fromLTRB(
                  defaultPadding,
                  8,
                  defaultPadding,
                  8,
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: SearchForm(
                    onTabFilter: _openFilterSheet,
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: defaultPadding,
                  vertical: defaultPadding / 2,
                ),
                child: Text(
                  'Categories',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
            ),
            FutureBuilder<List<ShopifyCollection>>(
              future: _collectionsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(defaultPadding),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  );
                }

                if (snapshot.hasError || (snapshot.data ?? []).isEmpty) {
                  return const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: defaultPadding),
                      child: Text('No categories available'),
                    ),
                  );
                }

                final collections = snapshot.data!;
                return SliverPadding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: defaultPadding),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final collection = collections[index];
                        final isLast = index == collections.length - 1;

                        return Column(
                          children: [
                            ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Text(collection.title),
                              trailing:
                                  const Icon(Icons.arrow_forward_ios, size: 16),
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  collectionProductsScreenRoute,
                                  arguments: collection.handle,
                                );
                              },
                            ),
                            if (!isLast) const Divider(height: 1),
                          ],
                        );
                      },
                      childCount: collections.length,
                    ),
                  ),
                );
              },
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: defaultPadding,
                  vertical: defaultPadding / 2,
                ),
                child: Row(
                  children: [
                    Text(
                      'All Products',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const Spacer(),
                    if (_activeFilters.isNotEmpty)
                      Text(
                        'Filtered',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                      ),
                  ],
                ),
              ),
            ),
            FutureBuilder<List<ProductModel>>(
              future: _productsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(defaultPadding),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  );
                }

                if (snapshot.hasError || (snapshot.data ?? []).isEmpty) {
                  return const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(defaultPadding),
                      child: Center(child: Text('No products available')),
                    ),
                  );
                }

                final products = _applyFilters(snapshot.data!);
                return SliverPadding(
                  padding: const EdgeInsets.all(defaultPadding),
                  sliver: SliverGrid.builder(
                    itemCount: products.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.7,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return ProductCard(
                        image: product.image,
                        brandName: product.brandName,
                        title: product.title,
                        price: product.price,
                        priceAfetDiscount: product.priceAfetDiscount,
                        dicountpercent: product.dicountpercent,
                        shopifyId: product.shopifyId,
                        description: product.description,
                        images: product.images,
                        isBookmarked: product.isBookmarked,
                        press: () {
                          Navigator.pushNamed(
                            context,
                            productDetailsScreenRoute,
                            arguments: product,
                          );
                        },
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
