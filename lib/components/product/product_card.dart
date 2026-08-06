import 'package:flutter/material.dart';

import '../../constants.dart';
import '../../models/product_model.dart';
import '../../services/picks_service.dart';
import '../network_image_with_loader.dart';

class ProductCard extends StatefulWidget {
  const ProductCard({
    super.key,
    required this.image,
    required this.brandName,
    required this.title,
    required this.price,
    this.priceAfetDiscount,
    this.dicountpercent,
    this.shopifyId,
    this.description,
    this.images = const [],
    this.isBookmarked = false,
    this.onBookmarkChanged,
    required this.press,
  });

  final String image;
  final String brandName;
  final String title;
  final double price;
  final double? priceAfetDiscount;
  final int? dicountpercent;
  final String? shopifyId;
  final String? description;
  final List<String> images;
  final bool isBookmarked;
  final ValueChanged<bool>? onBookmarkChanged;
  final VoidCallback press;

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  final PicksService _picksService = PicksService();
  late bool _isBookmarked;
  bool _isBookmarkBusy = false;

  @override
  void initState() {
    super.initState();
    _isBookmarked = widget.isBookmarked;
  }

  @override
  void didUpdateWidget(covariant ProductCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isBookmarked != widget.isBookmarked) {
      _isBookmarked = widget.isBookmarked;
    }
  }

  ProductModel _toProductModel() {
    return ProductModel(
      image: widget.image,
      brandName: widget.brandName,
      title: widget.title,
      price: widget.price,
      images: widget.images.isEmpty ? [widget.image] : widget.images,
      shopifyId: widget.shopifyId,
      priceAfetDiscount: widget.priceAfetDiscount,
      dicountpercent: widget.dicountpercent,
      description: widget.description,
      isBookmarked: _isBookmarked,
    );
  }

  Future<void> _toggleBookmark() async {
    if (_isBookmarkBusy) {
      return;
    }

    setState(() {
      _isBookmarkBusy = true;
    });

    final previous = _isBookmarked;
    final product = _toProductModel();

    try {
      if (_isBookmarked) {
        await _picksService.removePick(product);
      } else {
        await _picksService.addPick(product);
      }

      if (!mounted) {
        return;
      }
      setState(() {
        _isBookmarked = !previous;
      });
      widget.onBookmarkChanged?.call(_isBookmarked);
    } catch (error) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            error.toString().replaceFirst('Exception: ', ''),
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isBookmarkBusy = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: widget.press,
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(140, 220),
        maximumSize: const Size(140, 220),
        padding: const EdgeInsets.all(8),
      ),
      child: Column(
        children: [
          AspectRatio(
            aspectRatio: 1.15,
            child: Stack(
              children: [
                NetworkImageWithLoader(widget.image,
                    radius: defaultBorderRadious),
                Positioned(
                  left: defaultPadding / 2,
                  top: defaultPadding / 2,
                  child: Material(
                    color: Colors.white.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(defaultBorderRadious),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(defaultBorderRadious),
                      onTap: _toggleBookmark,
                      child: Padding(
                        padding: const EdgeInsets.all(6),
                        child: _isBookmarkBusy
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child:
                                    CircularProgressIndicator(strokeWidth: 2),
                              )
                            : Icon(
                                _isBookmarked
                                    ? Icons.bookmark_rounded
                                    : Icons.bookmark_border_rounded,
                                size: 18,
                                color: _isBookmarked
                                    ? Theme.of(context).colorScheme.primary
                                    : Theme.of(context).iconTheme.color,
                              ),
                      ),
                    ),
                  ),
                ),
                if (widget.dicountpercent != null)
                  Positioned(
                    right: defaultPadding / 2,
                    top: defaultPadding / 2,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: defaultPadding / 2,
                      ),
                      height: 16,
                      decoration: const BoxDecoration(
                        color: errorColor,
                        borderRadius: BorderRadius.all(
                          Radius.circular(defaultBorderRadious),
                        ),
                      ),
                      child: Text(
                        "${widget.dicountpercent}% off",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: defaultPadding / 2,
                vertical: defaultPadding / 2,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.brandName.toUpperCase(),
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(fontSize: 10),
                  ),
                  const SizedBox(height: defaultPadding / 2),
                  Text(
                    widget.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall!
                        .copyWith(fontSize: 12),
                  ),
                  const Spacer(),
                  widget.priceAfetDiscount != null
                      ? Row(
                          children: [
                            Text(
                              "₹${widget.priceAfetDiscount}",
                              style: const TextStyle(
                                color: Color(0xFF31B0D8),
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(width: defaultPadding / 4),
                            Text(
                              "₹${widget.price}",
                              style: TextStyle(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .color,
                                fontSize: 10,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          ],
                        )
                      : Text(
                          "₹${widget.price}",
                          style: const TextStyle(
                            color: Color(0xFF31B0D8),
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                          ),
                        ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
