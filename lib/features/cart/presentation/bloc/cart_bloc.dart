import 'package:store_lyqx/lyqx_core.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final GetCart? getCart;
  final GetCartByUser? getCartByUser;
  final CreateCart? createCart;
  final UpdateCart? updateCart;
  final DeleteCart? deleteCart;
  final GetProductsById? getProductById;
  CartBloc({
    this.getCart,
    this.getCartByUser,
    this.createCart,
    this.updateCart,
    this.deleteCart,
    this.getProductById,
  }) : super(CartLoading()) {
    on<LoadCart>(_onLoadCart);
    on<AddItem>(_onAddItem);
    on<RemoveItem>(_onRemoveItem);
    on<UpdateQuantity>(_onUpdateQuantity);
    on<ClearCart>(_onClearCart);
  }

  /// Create a bloc seeded with items (preview/testing)
  factory CartBloc.withInitialItems(List<CartItem> items) {
    final bloc = CartBloc();
    // seed
    bloc.add(ClearCart());
    for (final it in items) {
      bloc.add(AddItem(it));
    }
    return bloc;
  }

  Future<void> _onLoadCart(LoadCart event, Emitter<CartState> emit) async {
    // Debug: loading cart
    // ignore: avoid_print
    print('CartBloc: _onLoadCart called with cartId=${event.cartId}');
    emit(CartLoading());
    try {
      // Prefer user-specific usecase when available
      if (getCartByUser != null) {
        final user = await AppStorage.getUserModel();
        final userId = user?.id;
        if (userId == null) {
          emit(CartError('No logged in user'));
          return;
        }
        final result = await getCartByUser!(userId);
        // Debug
        // ignore: avoid_print
        print('CartBloc: fetched cart by user result: $result');
        await result.match(
          (l) async {
            // Extract message if Failure exposes one
            String msg;
            try {
              msg = (l as dynamic).message as String? ?? l.toString();
            } catch (_) {
              msg = l.toString();
            }
            emit(CartError(msg));
          },
          (cart) async {
            // Debug: loaded
            // ignore: avoid_print
            print(
              'CartBloc: emitting CartLoaded with ${cart.products.length} items',
            );
            // Merge backend with locally saved items
            List<CartItem> merged = cart.products;
            try {
              merged = await _mergeWithLocal(userId, cart.products);
              // Save merged back to local storage
              await AppStorage.saveCartForUser(
                userId,
                jsonEncode({
                  'id': cart.id,
                  'userId': cart.userId,
                  'products': merged
                      .map(
                        (p) => {
                          'productId': p.productId,
                          'quantity': p.quantity,
                        },
                      )
                      .toList(),
                }),
              );
            } catch (e) {
              // Ignore merge/save errors (log)
              // ignore: avoid_print
              print('CartBloc: mergeWithLocal error: $e');
            }
            final enriched = await _enrichItems(merged);
            emit(CartLoaded(enriched));
          },
        );
        return;
      }

      // Fallback: getCart by id
      if (getCart == null) {
        emit(CartError('Not implemented'));
        return;
      }
      final result = await getCart!(event.cartId);
      // Debug
      // ignore: avoid_print
      print('CartBloc: fetched cart by id result: $result');
      await result.match(
        (l) async {
          String msg;
          try {
            msg = (l as dynamic).message as String? ?? l.toString();
          } catch (_) {
            msg = l.toString();
          }
          emit(CartError(msg));
        },
        (cart) async {
          // Debug: loaded
          // ignore: avoid_print
          print(
            'CartBloc: emitting CartLoaded with ${cart.products.length} items (by id)',
          );
          // Merge backend with locally saved items
          List<CartItem> merged = cart.products;
          try {
            merged = await _mergeWithLocal(cart.userId, cart.products);
            await AppStorage.saveCartForUser(
              cart.userId,
              jsonEncode({
                'id': cart.id,
                'userId': cart.userId,
                'products': merged
                    .map(
                      (p) => {'productId': p.productId, 'quantity': p.quantity},
                    )
                    .toList(),
              }),
            );
          } catch (e) {
            // ignore: avoid_print
            print('CartBloc: mergeWithLocal (by id) error: $e');
          }
          final enriched = await _enrichItems(merged);
          emit(CartLoaded(enriched));
        },
      );
    } catch (e) {
      // Debug: unexpected error
      // ignore: avoid_print
      print('CartBloc._onLoadCart unexpected error: $e');
      emit(CartError(e.toString()));
    }
  }

  Future<void> _onAddItem(AddItem event, Emitter<CartState> emit) async {
    final current = state;
    if (current is CartLoaded) {
      final items = List.of(current.items);
      final idx = items.indexWhere((i) => i.productId == event.item.productId);
      if (idx >= 0) {
        items[idx].quantity += event.item.quantity;
      } else {
        items.add(event.item);
      }
      emit(CartLoaded(items));

      // Persist to API and local storage
      try {
        // Debug: persisting after AddItem
        // ignore: avoid_print
        print('CartBloc: persist cart after AddItem; items=${items.length}');
        final user = await AppStorage.getUserModel();
        final userId = user?.id ?? 0;
        final cartModel = (await _buildCartModel(userId, items));
        if (createCart != null) {
          await createCart!(cartModel);
        } else if (updateCart != null) {
          await updateCart!(cartModel);
        }
        // Save local copy
        await AppStorage.saveCartForUser(
          userId,
          jsonEncode({
            'id': cartModel.id,
            'userId': cartModel.userId,
            'products': cartModel.products
                .map((p) => {'productId': p.productId, 'quantity': p.quantity})
                .toList(),
          }),
        );
      } catch (e) {
        // Ignore persistence errors
        // ignore: avoid_print
        print('CartBloc: persistence after AddItem failed: $e');
      }
    }
  }

  Future<void> _onRemoveItem(RemoveItem event, Emitter<CartState> emit) async {
    final current = state;
    if (current is CartLoaded) {
      final items = current.items
          .where((i) => i.productId != event.productId)
          .toList();
      emit(CartLoaded(items));
      try {
        // Debug: persisting after RemoveItem
        // ignore: avoid_print
        print('CartBloc: persist cart after RemoveItem; items=${items.length}');
        final user = await AppStorage.getUserModel();
        final userId = user?.id ?? 0;
        final cartModel = (await _buildCartModel(userId, items));
        if (updateCart != null) {
          await updateCart!(cartModel);
        }
        await AppStorage.saveCartForUser(
          userId,
          jsonEncode({
            'id': cartModel.id,
            'userId': cartModel.userId,
            'products': cartModel.products
                .map((p) => {'productId': p.productId, 'quantity': p.quantity})
                .toList(),
          }),
        );
      } catch (e) {
        // ignore: avoid_print
        print('CartBloc: persistence after RemoveItem failed: $e');
      }
    }
  }

  Future<void> _onUpdateQuantity(
    UpdateQuantity event,
    Emitter<CartState> emit,
  ) async {
    final current = state;
    if (current is CartLoaded) {
      final items = List.of(current.items);
      final idx = items.indexWhere((i) => i.productId == event.productId);
      if (idx >= 0) {
        items[idx].quantity = event.quantity;
      }
      emit(CartLoaded(items));
      try {
        // Debug: persisting after UpdateQuantity
        // ignore: avoid_print
        print(
          'CartBloc: persist cart after UpdateQuantity; items=${items.length}',
        );
        final user = await AppStorage.getUserModel();
        final userId = user?.id ?? 0;
        final cartModel = (await _buildCartModel(userId, items));
        if (updateCart != null) {
          await updateCart!(cartModel);
        }
        await AppStorage.saveCartForUser(
          userId,
          jsonEncode({
            'id': cartModel.id,
            'userId': cartModel.userId,
            'products': cartModel.products
                .map((p) => {'productId': p.productId, 'quantity': p.quantity})
                .toList(),
          }),
        );
      } catch (e) {
        // ignore: avoid_print
        print('CartBloc: persistence after UpdateQuantity failed: $e');
      }
    }
  }

  Future<void> _onClearCart(ClearCart event, Emitter<CartState> emit) async {
    emit(CartLoaded([]));
    try {
      // Debug: clearing cart
      // ignore: avoid_print
      print('CartBloc: ClearCart -> saving empty cart for user if available');
      final user = await AppStorage.getUserModel();
      final userId = user?.id;
      if (userId != null) {
        await AppStorage.saveCartForUser(userId, jsonEncode({'products': []}));
      }
    } catch (_) {}
  }

  Future<CartModel> _buildCartModel(int userId, List<CartItem> items) async {
    // Use id 0 for new carts; caller may replace after create
    final id = 0;
    return CartModel(id: id, userId: userId, products: items);
  }

  Future<List<CartItem>> _enrichItems(List<CartItem> items) async {
    if (getProductById == null) return items;
    final futures = items.map((it) async {
      try {
        final result = await getProductById!(
          GetProductsByIdParams(id: it.productId),
        );
        return await result.match(
          (l) async {
            // Failed to fetch product — return original item
            // ignore: avoid_print
            print(
              'CartBloc._enrichItems: failed to fetch product ${it.productId}: $l',
            );
            return it;
          },
          (product) async {
            // Map product fields into CartItem
            // ignore: avoid_print
            print(
              'CartBloc._enrichItems: fetched product ${product.id} -> title=${product.title}, image=${product.image}, price=${product.price}',
            );
            return CartItem(
              productId: it.productId,
              title: product.title,
              image: product.image,
              price: product.price,
              quantity: it.quantity,
            );
          },
        );
      } catch (e) {
        // ignore: avoid_print
        print('CartBloc._enrichItems unexpected error for ${it.productId}: $e');
        return it;
      }
    }).toList();

    final list = await Future.wait(futures);
    // Debug: final enriched list
    // ignore: avoid_print
    print(
      'CartBloc._enrichItems: enriched items=${list.map((e) => '${e.productId}:${e.title}').toList()}',
    );
    return list;
  }

  /// Merge backend with local items for [userId]; sum quantities
  Future<List<CartItem>> _mergeWithLocal(
    int userId,
    List<CartItem> backend,
  ) async {
    try {
      final raw = await AppStorage.getCartForUser(userId);
      if (raw == null) return backend;
      final decoded = jsonDecode(raw);
      List<dynamic> rawProducts = [];
      if (decoded is Map<String, dynamic>) {
        if (decoded['products'] is List) {
          rawProducts = List<dynamic>.from(decoded['products'] as List);
        }
      } else if (decoded is List) {
        // If list, try to find products list
        if (decoded.isNotEmpty &&
            decoded.first is Map &&
            decoded.first['products'] is List) {
          rawProducts = List<dynamic>.from(decoded.first['products'] as List);
        } else {
          // Assume it's a list of product entries
          rawProducts = List<dynamic>.from(decoded);
        }
      }

      final Map<int, CartItem> map = {
        for (final b in backend)
          b.productId: CartItem(
            productId: b.productId,
            title: b.title,
            image: b.image,
            price: b.price,
            quantity: b.quantity,
          ),
      };

      for (final p in rawProducts) {
        try {
          final pid = (p['productId'] is int)
              ? p['productId'] as int
              : int.parse('${p['productId']}');
          final qty = (p['quantity'] is int)
              ? p['quantity'] as int
              : int.parse('${p['quantity']}');
          if (map.containsKey(pid)) {
            map[pid]!.quantity += qty;
          } else {
            map[pid] = CartItem(
              productId: pid,
              title: '',
              image: '',
              price: 0.0,
              quantity: qty,
            );
          }
        } catch (_) {
          // Ignore malformed entries
        }
      }

      return map.values.toList();
    } catch (e) {
      // On parse error return backend
      // ignore: avoid_print
      print('CartBloc._mergeWithLocal parse error: $e');
      return backend;
    }
  }
}
