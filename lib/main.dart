// import 'dart:async';

// import 'package:ecommerce_app/src/app.dart';
// import 'package:ecommerce_app/src/localization/string_hardcoded.dart';
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';

// void main() async {
//   // * For more info on error handling, see:
//   // * https://docs.flutter.dev/testing/errors
//   await runZonedGuarded(() async {
//     WidgetsFlutterBinding.ensureInitialized();
//      GoRouter.setUrlPathStrategy(UrlPathStrategy.path);
//     // * Entry point of the app
//     runApp(const ProviderScope(child: MyApp()));

//     // * This code will present some error UI if any uncaught exception happens
//     FlutterError.onError = (FlutterErrorDetails details) {
//       FlutterError.presentError(details);
//     };
//     ErrorWidget.builder = (FlutterErrorDetails details) {
//       return Scaffold(
//         appBar: AppBar(
//           backgroundColor: Colors.red,
//           title: Text('An error occurred'.hardcoded),
//         ),
//         body: Center(child: Text(details.toString())),
//       );
//     };
//   }, (Object error, StackTrace stack) {
//     // * Log any errors to console
//     debugPrint(error.toString());
//   });
// }




import 'package:ecommerce_app/cart/data/local_cart_repo.dart';
import 'package:ecommerce_app/cart/data/sembast_cartRepo.dart';
import 'package:ecommerce_app/src/app.dart';
import 'package:ecommerce_app/src/features/product_page/add_to_cart/cart_sync_service.dart';
import 'package:ecommerce_app/src/localization/string_hardcoded.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ignore:depend_on_referenced_packages
import 'package:flutter_web_plugins/url_strategy.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // turn off the # in the URLs on the web
  usePathUrlStrategy();
  // * Register error handlers. For more info, see:
  // * https://docs.flutter.dev/testing/errors
  registerErrorHandlers();
  final localCartRepo = await SembastCartRepo.makeDefault();
final container = ProviderContainer(
    overrides: [localCartRepoProvider.overrideWithValue(localCartRepo)],
  );

  container.read(cartSyncServiceProvider);
  // * Entry point of the app
  runApp(UncontrolledProviderScope(
    container: container,
    child: MyApp(),
  ));
}

void registerErrorHandlers() {
  // * Show some error UI if any uncaught exception happens
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    debugPrint(details.toString());
  };
  // * Handle errors from the underlying platform/OS
  PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
    debugPrint(error.toString());
    return true;
  };
  // * Show some error UI when any widget in the app fails to build
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text('An error occurred'.hardcoded),
      ),
      body: Center(child: Text(details.toString())),
    );
  };
}
