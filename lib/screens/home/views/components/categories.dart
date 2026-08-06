import 'package:flutter/material.dart';
import 'package:busniness/route/route_constants.dart';
import 'package:busniness/services/shopify_service.dart';
import '../../../../constants.dart';
import '../../../collection/views/collection_products_screen.dart';

class Categories extends StatefulWidget {
  const Categories({super.key});

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  late final Future<List<ShopifyCollection>> _collectionsFuture;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _collectionsFuture = ShopifyService().fetchCollections();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ShopifyCollection>>(
      future: _collectionsFuture,
      builder: (context, snapshot) {
        final collections = snapshot.data ?? const <ShopifyCollection>[];
        final categories = <_HomeCategory>[
          const _HomeCategory(label: 'All', icon: Icons.storefront_rounded),
          ...collections.map(
            (collection) => _HomeCategory(
              label: collection.title,
              icon: Icons.category_rounded,
              tag: collection.handle,
            ),
          ),
        ];

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(
              categories.length,
              (index) {
                final category = categories[index];
                return Padding(
                  padding: EdgeInsets.only(
                    left: index == 0 ? defaultPadding : 6,
                    right: index == categories.length - 1 ? defaultPadding : 0,
                  ),
                  child: CategoryBtn(
                    category: category.label,
                    icon: category.icon,
                    isActive: _selectedIndex == index,
                    press: () {
                      setState(() => _selectedIndex = index);
                      Navigator.pushNamed(
                        context,
                        collectionProductsScreenRoute,
                        arguments: CategoryProductsArguments(
                          title: category.label,
                          collectionHandle: category.tag,
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}

class _HomeCategory {
  const _HomeCategory({
    required this.label,
    required this.icon,
    this.tag,
  });

  final String label;
  final IconData icon;
  final String? tag;
}

class CategoryBtn extends StatelessWidget {
  const CategoryBtn({
    super.key,
    required this.category,
    this.icon,
    required this.isActive,
    required this.press,
  });

  final String category;
  final IconData? icon;
  final bool isActive;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: press,
      borderRadius: const BorderRadius.all(Radius.circular(12)),
      child: Container(
        width: 86,
        height: 82,
        padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 4),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isActive ? const Color(0xFFE85D92) : Colors.transparent,
              width: 3,
            ),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null)
              Icon(
                icon,
                size: 29,
                color: isActive
                    ? const Color(0xFFE85D92)
                    : const Color(0xFF383238),
              ),
            if (icon != null) const SizedBox(height: 5),
            Text(
              category,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11,
                height: 1,
                fontWeight: isActive ? FontWeight.w800 : FontWeight.w600,
                color: isActive
                    ? const Color(0xFFE85D92)
                    : const Color(0xFF383238),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
