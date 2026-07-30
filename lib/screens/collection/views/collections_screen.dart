import 'package:flutter/material.dart';
import 'package:busniness/components/network_image_with_loader.dart';
import 'package:busniness/constants.dart';
import 'package:busniness/route/route_constants.dart';
import 'package:busniness/services/shopify_service.dart';

class CollectionsScreen extends StatefulWidget {
  const CollectionsScreen({super.key});

  @override
  State<CollectionsScreen> createState() => _CollectionsScreenState();
}

class _CollectionsScreenState extends State<CollectionsScreen> {
  late final Future<List<ShopifyCollection>> _collectionsFuture;

  @override
  void initState() {
    super.initState();
    _collectionsFuture = ShopifyService().fetchCollections();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('All Collections')),
      body: FutureBuilder<List<ShopifyCollection>>(
        future: _collectionsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final collections = snapshot.data ?? [];
          if (collections.isEmpty) {
            return const Center(child: Text('No collections available yet'));
          }

          return GridView.builder(
            padding: const EdgeInsets.all(defaultPadding),
            itemCount: collections.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: .82,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemBuilder: (context, index) {
              final collection = collections[index];
              return InkWell(
                onTap: () => Navigator.pushNamed(
                  context,
                  collectionProductsScreenRoute,
                  arguments: collection.handle,
                ),
                borderRadius: BorderRadius.circular(18),
                child: Ink(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x16000000),
                        blurRadius: 10,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(7),
                    child: Column(
                      children: [
                        Expanded(
                          child: collection.imageUrl.isEmpty
                              ? const DecoratedBox(
                                  decoration: BoxDecoration(
                                    color: Color(0xFFFFEAF2),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(13),
                                    ),
                                  ),
                                  child: Center(
                                    child: Icon(
                                      Icons.category_rounded,
                                      size: 42,
                                    ),
                                  ),
                                )
                              : NetworkImageWithLoader(
                                  collection.imageUrl,
                                  radius: 13,
                                ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          collection.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.w800),
                        ),
                        const SizedBox(height: 2),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
