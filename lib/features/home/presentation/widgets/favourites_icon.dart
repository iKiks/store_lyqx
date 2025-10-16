import 'package:store_lyqx/lyqx_core.dart';
import 'package:flutter/material.dart';

class FavouritesIcon extends StatefulWidget {
  final int productId;
  const FavouritesIcon({super.key, required this.productId});

  @override
  State<FavouritesIcon> createState() => _FavouritesIconState();
}

class _FavouritesIconState extends State<FavouritesIcon> {
  bool _isFav = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final fav = await AppStorage.isFavorite(widget.productId);
    if (!mounted) return;
    setState(() => _isFav = fav);
  }

  Future<void> _toggle() async {
    await AppStorage.toggleFavorite(widget.productId);
    _load();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggle,
      child: Container(
        height: ResponsiveSize.height(36),
        width: ResponsiveSize.width(36),
        decoration: BoxDecoration(
          color: AppColors.transparentColor,
          borderRadius: BorderRadius.circular(ResponsiveSize.width(8)),
        ),
        child: Icon(
          _isFav ? Icons.favorite : Icons.favorite_border,
          size: ResponsiveSize.height(18),
          color: _isFav ? Colors.red : null,
        ),
      ),
    );
  }
}
