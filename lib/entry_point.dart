import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:busniness/constants.dart';
import 'package:busniness/route/screen_export.dart';

class EntryPoint extends StatefulWidget {
  const EntryPoint({super.key, this.initialIndex = 0});

  final int initialIndex;

  @override
  State<EntryPoint> createState() => _EntryPointState();
}

class _EntryPointState extends State<EntryPoint> {
  final List _pages = const [
    HomeScreen(),
    DiscoverScreen(),
    BookmarkScreen(),
    // EmptyCartScreen(), // if Cart is empty
    CartScreen(),
    ProfileScreen(),
  ];
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Each main page owns its header; the home page uses a full baby-store
      // header modeled after the supplied reference.
      // body: _pages[_currentIndex],
      body: PageTransitionSwitcher(
        duration: defaultDuration,
        transitionBuilder: (child, animation, secondAnimation) {
          return FadeThroughTransition(
            animation: animation,
            secondaryAnimation: secondAnimation,
            child: child,
          );
        },
        child: _pages[_currentIndex],
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          height: 76,
          margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 7),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: const [
              BoxShadow(
                color: Color(0x220E5D4F),
                blurRadius: 18,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            children: [
              _CuteNavItem(
                label: 'Home',
                icon: Icons.home_rounded,
                selected: _currentIndex == 0,
                onTap: () => setState(() => _currentIndex = 0),
              ),
              _CuteNavItem(
                label: 'Browse',
                icon: Icons.grid_view_rounded,
                selected: _currentIndex == 1,
                onTap: () => setState(() => _currentIndex = 1),
              ),
              _CuteNavItem(
                label: 'Picks',
                icon: Icons.auto_awesome_rounded,
                selected: _currentIndex == 2,
                onTap: () => setState(() => _currentIndex = 2),
              ),
              _CuteNavItem(
                label: 'Cart',
                icon: Icons.shopping_bag_rounded,
                selected: _currentIndex == 3,
                isCart: true,
                onTap: () => setState(() => _currentIndex = 3),
              ),
              _CuteNavItem(
                label: 'Me',
                icon: Icons.face_rounded,
                selected: _currentIndex == 4,
                onTap: () => setState(() => _currentIndex = 4),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CuteNavItem extends StatelessWidget {
  const _CuteNavItem({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
    this.isCart = false,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final bool isCart;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    const pink = Color(0xFFE85D92);
    final iconColor = selected ? pink : const Color(0xFF6E6870);

    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: AnimatedContainer(
          duration: defaultDuration,
          height: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 4),
          decoration: BoxDecoration(
            color: selected ? const Color(0xFFFFE7F0) : Colors.transparent,
            borderRadius: BorderRadius.circular(22),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(isCart ? 8 : 4),
                decoration: BoxDecoration(
                  color: isCart
                      ? (selected ? pink : const Color(0xFFFFD9E8))
                      : Colors.transparent,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: isCart ? 22 : 23,
                  color: isCart ? (selected ? Colors.white : pink) : iconColor,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: TextStyle(
                  color: iconColor,
                  fontSize: 10,
                  fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
