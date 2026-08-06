import 'package:flutter/material.dart';
import 'package:busniness/components/product/product_card.dart';
import 'package:busniness/constants.dart';
import 'package:busniness/models/product_model.dart';
import 'package:busniness/services/shopify_service.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late final Future<List<ProductModel>> _productsFuture;
  final TextEditingController _controller = TextEditingController();
  String _query = '';

  @override
  void initState() {
    super.initState();
    _productsFuture = ShopifyService().fetchProducts(first: 20);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<ProductModel> _filterProducts(List<ProductModel> products) {
    final query = _query.trim().toLowerCase();
    if (query.isEmpty) {
      return products;
    }
    return products
        .where((product) => product.title.toLowerCase().contains(query))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(defaultPadding),
              child: TextField(
                controller: _controller,
                onChanged: (value) {
                  setState(() {
                    _query = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Search products',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16)),
                ),
              ),
            ),
            Expanded(
              child: FutureBuilder<List<ProductModel>>(
                future: _productsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return const Center(child: Text('Could not load products'));
                  }

                  final products =
                      _filterProducts(snapshot.data ?? <ProductModel>[]);
                  if (products.isEmpty) {
                    return const Center(child: Text('No matching products'));
                  }

                  final tags = products
                      .map((product) => product.brandName.trim())
                      .where((tag) => tag.isNotEmpty)
                      .toSet()
                      .take(4)
                      .toList();

                  return Column(
                    children: [
                      if (tags.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: defaultPadding),
                          child: Wrap(
                            spacing: 8,
                            children: tags
                                .map(
                                  (tag) => ChoiceChip(
                                    label: Text(tag),
                                    selected: false,
                                    onSelected: (_) {
                                      _controller.text = tag;
                                      setState(() {
                                        _query = tag;
                                      });
                                    },
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      const SizedBox(height: defaultPadding),
                      Expanded(
                        child: GridView.builder(
                          padding: const EdgeInsets.symmetric(
                            horizontal: defaultPadding,
                          ),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.7,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                          ),
                          itemCount: products.length,
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
                              press: () {},
                            );
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
