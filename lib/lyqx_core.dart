// Central barrel for core utilities/widgets/etc.
// Export minimal core modules used across the app.

// Theme
export 'core/theme/app_colors.dart';

// Responsiveness/utilities
export 'core/utils/responsiveness/app_responsiveness.dart';

// Storage/networking
export 'core/storage/app_storage.dart';
export 'core/network/api_client.dart';
export 'package:dio/dio.dart';
export 'dart:convert';

// Widgets
export 'core/widgets/texts/app_texts.dart';
export 'core/widgets/buttons/app_buttons.dart';
export 'core/widgets/root_shell.dart';
export 'core/widgets/logout_button.dart';

// Cart entities
export 'features/cart/domain/entities/cart_item.dart';
export 'features/cart/domain/entities/cart_model.dart';

// Home feature
export 'features/home/domain/entities/product_entity.dart';
export 'features/home/data/models/product_model.dart';
export 'features/home/data/datasources/remote_datasource.dart';
export 'features/home/data/repositories/product_repository_impl.dart';
export 'features/home/domain/repository/product_repository.dart';
export 'features/home/domain/usecases/get_all_product.dart';
export 'features/home/domain/usecases/get_products_by_id.dart';
export 'features/home/presentation/bloc/product_bloc.dart';
export 'features/home/presentation/widgets/product_card.dart';
export 'features/home/presentation/widgets/favourites_icon.dart';

// Cart feature
export 'features/cart/data/datasources/cart_remote_datasource.dart';
export 'features/cart/data/repositories/cart_repository_impl.dart';
export 'features/cart/domain/repositories/cart_repository.dart';
export 'features/cart/domain/usecases/get_cart.dart';
export 'features/cart/domain/usecases/get_cart_by_user.dart';
export 'features/cart/domain/usecases/create_cart.dart';
export 'features/cart/domain/usecases/update_cart.dart';
export 'features/cart/domain/usecases/delete_cart.dart';
export 'features/cart/presentation/bloc/cart_bloc.dart';
export 'features/cart/presentation/bloc/cart_event.dart';
export 'features/cart/presentation/bloc/cart_state.dart';
export 'features/cart/presentation/widgets/cart_item_card.dart';
export 'features/cart/presentation/widgets/cart_total_bar.dart';
export 'features/cart/presentation/widgets/quantity_selector.dart';

// Common types
export 'core/error/failures.dart';
export 'core/common/usecases/usecase.dart';

// Add more exports here as needed to keep imports minimal in feature files.

// Re-export common packages so features can import this barrel only.
export 'package:flutter_bloc/flutter_bloc.dart';
export 'package:go_router/go_router.dart';

// Login feature exports
export 'features/login/presentation/widgets/authfields.dart';
export 'features/login/presentation/bloc/login_bloc.dart';
export 'features/login/presentation/bloc/login_event.dart';
export 'features/login/presentation/bloc/login_state.dart';
export 'features/login/data/datasources/auth_remote_datasource.dart';
export 'features/login/data/repositories/auth_repository_impl.dart';
export 'features/login/domain/usecases/login_user.dart';
export 'features/login/domain/entities/user_entity.dart';
export 'features/login/domain/repositories/auth_repository.dart';
export 'features/login/data/models/user_model.dart';

// Wishlist feature
export 'features/wishlist/presentation/widgets/product_card.dart'
    show WishlistProductCard;

// Screens
export 'package:store_lyqx/features/home/presentation/screens/home_screen.dart';
export 'package:store_lyqx/features/home/presentation/screens/product_details_screen.dart';
export 'package:store_lyqx/features/login/presentation/screens/login_screen.dart';
export 'package:store_lyqx/features/splash/presentation/splash_screen.dart';
export 'package:store_lyqx/features/wishlist/presentation/screens/wishlist_screen.dart';
export 'package:store_lyqx/features/cart/presentation/screens/cart_screen.dart';