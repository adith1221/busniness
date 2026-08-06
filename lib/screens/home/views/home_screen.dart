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
  late List<_DeliveryAddress> _addresses;
  late int _selectedAddressIndex;

  @override
  void initState() {
    super.initState();
    _collectionsFuture = ShopifyService().fetchCollections();
    _addresses = _buildDummyAddresses();
    _selectedAddressIndex = 0;
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
                selectedAddress: _selectedAddressLabel,
                onLocationTap: _showDeliveryAddressSheet,
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

  Future<void> _showDeliveryAddressSheet() async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return _DeliveryAddressBottomSheet(
          addresses: _addresses,
          selectedIndex: _selectedAddressIndex,
          onSelect: (index) {
            setState(() => _selectedAddressIndex = index);
            Navigator.of(sheetContext).pop();
          },
          onAddNew: () async {
            Navigator.of(sheetContext).pop();
            await Navigator.pushNamed(context, addressesScreenRoute);
            if (mounted) {
              setState(() => _addresses = _buildDummyAddresses());
            }
          },
        );
      },
    );
  }

  String get _selectedAddressLabel {
    if (_addresses.isEmpty) {
      return 'your selected location';
    }

    final selectedAddress = _addresses[_selectedAddressIndex];
    return selectedAddress.label;
  }

  List<_DeliveryAddress> _buildDummyAddresses() {
    return [
      _DeliveryAddress(
        label: 'Home',
        recipientName: 'Sepide Rahimi',
        phoneNumber: '+1 555 123 4567',
        fullAddress: '123 Market Street, New York, NY 10001',
        icon: Icons.home_rounded,
        isDefault: true,
      ),
      _DeliveryAddress(
        label: 'Work',
        recipientName: 'Sepide Rahimi',
        phoneNumber: '+1 555 987 6543',
        fullAddress: '88 Ocean Avenue, Los Angeles, CA 90001',
        icon: Icons.work_rounded,
      ),
      _DeliveryAddress(
        label: 'Other',
        recipientName: 'Sepide Rahimi',
        phoneNumber: '+1 555 222 3333',
        fullAddress: '12 Willow Road, Chicago, IL 60601',
        icon: Icons.location_on_rounded,
      ),
    ];
  }
}

class _BabyHomeHeader extends StatelessWidget {
  _BabyHomeHeader({
    required this.onSearch,
    required this.selectedAddress,
    required this.onLocationTap,
  });

  final VoidCallback onSearch;
  final String selectedAddress;
  final VoidCallback onLocationTap;

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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Mimsico',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(height: 3),
                    InkWell(
                      onTap: onLocationTap,
                      borderRadius: BorderRadius.circular(14),
                      child: Row(
                        children: [
                          const Icon(Icons.location_on_rounded, size: 17),
                          const SizedBox(width: 3),
                          Expanded(
                            child: Text(
                              'Delivering to $selectedAddress',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style:
                                  const TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                          const Icon(Icons.keyboard_arrow_down_rounded,
                              size: 19),
                        ],
                      ),
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

class _DeliveryAddressBottomSheet extends StatelessWidget {
  const _DeliveryAddressBottomSheet({
    required this.addresses,
    required this.selectedIndex,
    required this.onSelect,
    required this.onAddNew,
  });

  final List<_DeliveryAddress> addresses;
  final int selectedIndex;
  final ValueChanged<int> onSelect;
  final VoidCallback onAddNew;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SafeArea(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.82,
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              defaultPadding,
              defaultPadding,
              defaultPadding,
              defaultPadding,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Select Delivery Address',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close_rounded),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
                const SizedBox(height: defaultPadding),
                Flexible(
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: addresses.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: defaultPadding),
                    itemBuilder: (context, index) {
                      final address = addresses[index];
                      return _AddressCard(
                        address: address,
                        isSelected: index == selectedIndex,
                        onTap: () => onSelect(index),
                      );
                    },
                  ),
                ),
                const SizedBox(height: defaultPadding),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: onAddNew,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                      backgroundColor: primaryColor,
                      foregroundColor: whiteColor,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(defaultBorderRadious),
                      ),
                    ),
                    icon: const Icon(Icons.add_rounded),
                    label: const Text('+ Add New Address'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AddressCard extends StatelessWidget {
  const _AddressCard({
    required this.address,
    required this.isSelected,
    required this.onTap,
  });

  final _DeliveryAddress address;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final borderColor =
        isSelected ? primaryColor : Theme.of(context).dividerColor;
    final iconColor = isSelected ? primaryColor : const Color(0xFF6E6870);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(defaultBorderRadious),
      child: Container(
        padding: const EdgeInsets.all(defaultPadding),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFFF6F3FF)
              : Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(defaultBorderRadious),
          border: Border.all(color: borderColor),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF0F7),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(address.icon, color: iconColor, size: 24),
            ),
            const SizedBox(width: defaultPadding),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          address.label,
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                      ),
                      if (address.isDefault)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE8F8EE),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: const Text(
                            'Default',
                            style: TextStyle(
                              color: successColor,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    address.recipientName,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    address.phoneNumber,
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).textTheme.bodyMedium!.color,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    address.fullAddress,
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).textTheme.bodyMedium!.color,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: defaultPadding / 2),
            Radio<int>(
              value: 1,
              groupValue: isSelected ? 1 : 0,
              onChanged: (_) => onTap(),
              activeColor: primaryColor,
            ),
          ],
        ),
      ),
    );
  }
}

class _DeliveryAddress {
  const _DeliveryAddress({
    required this.label,
    required this.recipientName,
    required this.phoneNumber,
    required this.fullAddress,
    required this.icon,
    this.isDefault = false,
  });

  final String label;
  final String recipientName;
  final String phoneNumber;
  final String fullAddress;
  final IconData icon;
  final bool isDefault;
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
                      collectionHandle: collection.handle,
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
