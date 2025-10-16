# Store LYQX — Flutter E‑Commerce App

This is a clean-architecture Flutter E‑Commerce test project that replicates the provided Figma design and integrates with the Fake Store API.

APK: The release APK is attached with this submission.

Figma: The UI was replicated 100% according to the design.

Links:
- Figma: https://www.figma.com/design/3aiy97FCil69hNohf8w9AU/Fake-Store-LYQX?node-id=0-1
- API: https://fakestoreapi.com/

## Features

- Welcome & Login
	- Validates inputs, with show/hide password
	- Calls POST login using Fake Store API (credentials from spec) and persists the logged-in user

- Product Listing
	````markdown
	# store_lyqx — Flutter E‑Commerce (Fake Store API)

	Summary
	-------
	store_lyqx is a small clean-architecture Flutter demo that integrates with the Fake Store API to demonstrate common e‑commerce flows: product listing, product details, cart management, login, and a local wishlist. The UI follows a provided Figma reference and the app is structured for maintainability and testability.

	Time spent
	----------
	The work on this repository took approximately one and a half days (1.5 days).

	Links
	-----
	- Figma (reference): https://www.figma.com/design/3aiy97FCil69hNohf8w9AU/Fake-Store-LYQX?node-id=0-1
	- API: https://fakestoreapi.com/

	Highlights / Features
	---------------------
	- Welcome & Login
	  - Form validation, show/hide password
	  - Login flow using the Fake Store API (persisted user session)

	- Product Listing
	  - GET /products via Dio
	  - Product cards show title, image, category, price, rating
	  - Infinite scroll / lazy loading (loads more results as the user scrolls)

	- Product Details
	  - Full details view with image, description, rating and a fixed bottom bar for Add to Cart

	- Cart Management
	  - Add/remove items, quantity updates, live total price
	  - Handles the Fake Store API’s non-persistent cart behavior by merging server and local cache

	# store_lyqx — Flutter E‑Commerce (Fake Store API)

	## Summary

	store_lyqx is a clean-architecture Flutter demo that integrates with the Fake Store API to demonstrate common e‑commerce flows: product listing, product details, cart management, login, and a local wishlist. The UI follows a provided Figma reference and the app is structured for maintainability and testability.

	## Time spent

	This work took approximately one and a half days (1.5 days).

	## Links

	- Figma (reference): https://www.figma.com/design/3aiy97FCil69hNohf8w9AU/Fake-Store-LYQX?node-id=0-1
	- API: https://fakestoreapi.com/

	## Highlights / Features

	- Welcome & Login
	  - Form validation, show/hide password
	  - Login flow using the Fake Store API (persisted user session)

	- Product Listing
	  - GET /products via Dio
	  - Product cards show title, image, category, price, rating
	  - Infinite scroll / lazy loading (loads more results as the user scrolls)

	- Product Details
	  - Full details view with image, description, rating and a fixed bottom bar for Add to Cart

	- Cart Management
	  - Add/remove items, quantity updates, live total price
	  - Handles the Fake Store API’s non-persistent cart behavior by merging server and local cache

	- Wishlist (local)
	  - Add/remove favorites and view favorites list
	  - Stored locally using SharedPreferences via the `AppStorage` helper

	## Project Structure & Architecture

	The project follows a layered clean architecture to separate concerns:

	- `lib/core`: shared utilities, theming, widgets, and the `AppStorage` helper
	- `lib/features`: feature folders for `home`, `cart`, `login`, `wishlist`, each containing data/domain/presentation layers
	- data layer: remote data sources (Dio-based ApiClient) and repository implementations
	- domain layer: entities, repository interfaces, and use cases (fpdart Either for errors)
	- presentation layer: BLoC (flutter_bloc) for state management, with screens/widgets under presentation

	### Dependency Injection & Routing

	- DI: `get_it` + `injectable` with generated wiring in `lib/injection.config.dart`.
	- Routing: `go_router` with a `ShellRoute` used for the bottom navigation and nested routes.

	### State Management

	- BLoC (`flutter_bloc`) is used for product listing/details, login, and cart.
	- Wishlist operations are lightweight and backed by `AppStorage` (SharedPreferences).

	### Local Storage

	- `SharedPreferences` via `AppStorage` is used for:
	  - Persisting logged-in user info
	  - Caching the cart per user to work around backend non-persistence
	  - Storing wishlist item IDs

	## Tech Stack

	- Flutter / Dart
	- Dio — HTTP client
	- flutter_bloc — BLoC pattern for state
	- get_it + injectable — dependency injection
	- go_router — declarative routing
	- shared_preferences — lightweight local storage
	- fpdart — functional Either type for error handling

	## How to run

	Prerequisites:
	- Flutter SDK (stable channel)
	- Dart SDK (bundled with Flutter)

	Install dependencies:

	```powershell
	flutter pub get
	```

	Run the app (example):

	```powershell
	flutter run
	```

	Build a release APK:

	```powershell
	flutter build apk --release
	```

	## API Endpoints Used

	- GET /products — listing and pagination
	- GET /products/{id} — product details
	- POST /auth/login (or direct user lookup) — login flow
	- Cart-related endpoints when applicable (note: Fake Store API may be non-persistent)

	## Important notes & implementation details

	- Cart merging: Because the Fake Store API does not persist cart changes in all endpoints, the app maintains a local per-user cart cache. The Cart BLoC merges backend responses with local cache to provide a consistent UX.

	- Shared bloc instances: Product listing and product details currently share a `ProductBloc` instance in the app. That design keeps a single source of truth but requires the UI to handle both list and detail states carefully. If you prefer separation of concerns, a `ProductListBloc` and `ProductDetailsBloc` can be introduced.

	- Error handling: Network and domain errors are returned as `Failure` objects (fpdart Either), which the BLoCs map to `ProductError` / `CartError` etc. UI shows SnackBars or inline error messages based on the state.

	## Credentials (example used during testing)

	```
	email: john@gmail.com
	username: johnd
	password: m38rmF$
	```

	## Time log

	- Total time spent porting and adapting this project: ~1.5 days (one and a half days). This includes wiring DI, routing, BLoC state, implementing network/data layers, and finishing UI polish to match the reference.
