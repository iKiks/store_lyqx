import 'package:store_lyqx/lyqx_core.dart';
// Reads favorites directly from storage
import 'package:flutter/material.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  List<Map<String, dynamic>> _products = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    setState(() {
      _loading = true;
    });

    final favs = await AppStorage.getFavorites();

    if (favs.isEmpty) {
      setState(() {
        _products = [];
        _loading = false;
      });
      return;
    }

    // Fetch product details using local repo stack
    final apiClient = ApiClient();
    final remote = RemoteDataSourceImpl(apiClient);
    final repo = ProductRepositoryImpl(remote);
    final getById = GetProductsById(repo);

    final futures = favs.map((id) async {
      final res = await getById(GetProductsByIdParams(id: id));
      return res.match((l) => null, (product) => product);
    }).toList();

    final results = await Future.wait(futures);
    final list = <Map<String, dynamic>>[];
    for (final p in results) {
      if (p == null) continue;
      list.add({
        'id': p.id,
        'title': p.title,
        'price': '\$${p.price.toStringAsFixed(2)}',
        'category': p.category,
        'image': p.image,
      });
    }

    if (!mounted) return;
    setState(() {
      _products = list;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGreyColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppTexts(
                    'Wishlist',
                    fontSize: ResponsiveSize.fontSize(24),
                    fontWeight: FontWeight.w600,
                  ),

                  const LogoutButton(clearCart: true),
                ],
              ),

              SizedBox(height: ResponsiveSize.height(20)),

              Expanded(
                child: _loading
                    ? const Center(child: CircularProgressIndicator())
                    : _products.isEmpty
                    ? Center(
                        child: AppTexts(
                          'No favorites yet',
                          fontSize: ResponsiveSize.fontSize(16),
                        ),
                      )
                    : ListView.separated(
                        itemCount: _products.length,
                        separatorBuilder: (_, __) =>
                            SizedBox(height: ResponsiveSize.height(12)),
                        itemBuilder: (context, index) {
                          final it = _products[index];
                          return WishlistProductCard(
                            id: it['id'] as int,
                            title: it['title'] as String,
                            category: it['category'] as String,
                            rating: '4.25',
                            price: it['price'] as String,
                            imageUrl: (it['image'] as String?) ?? '',
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
