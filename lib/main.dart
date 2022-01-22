// ignore_for_file: deprecated_member_use, missing_required_param, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/helpers/custom_route.dart';
import 'package:shop_app/providers/auth_provider.dart';
import 'package:shop_app/providers/orders_provider.dart';
import 'package:shop_app/screens/auth_screen.dart';
import 'package:shop_app/screens/edit_product_screen.dart';
import 'package:shop_app/screens/orders_screen.dart';
import 'package:shop_app/screens/product_overview_screen.dart';
import 'package:shop_app/screens/splash_screen.dart';
import 'package:shop_app/screens/user_products_screen.dart';
import '../providers/cart_provider.dart';
import '../screens/cart_screen.dart';
import '../providers/products_provider.dart';
import '../screens/product_detail.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => AuthProvider(),
        ),
        ChangeNotifierProxyProvider<AuthProvider, ProductsProvider>(
          update: (ctx, auth, previousProducts) => ProductsProvider(
              auth.token,
              auth.userId,
              previousProducts == null ? [] : previousProducts.items),
        ),
        ChangeNotifierProvider(
          create: (ctx) => CartProvider(),
        ),
        ChangeNotifierProxyProvider<AuthProvider, OrdersProvider>(
          update: (ctx, auth, previousOrders) => OrdersProvider(auth.token,
              auth.userId, previousOrders == null ? [] : previousOrders.orders),
        ),
      ],
      child: Consumer<AuthProvider>(builder: (context, auth, _) {
        ifAuth(targetScreen) => auth.isAuth
            ? targetScreen
            : FutureBuilder(
                future: auth.tryAutoLogin(),
                builder: (ctx, authResultSnapshot) =>
                    authResultSnapshot.connectionState ==
                            ConnectionState.waiting
                        ? const SplashScreen()
                        : const AuthScreen(),
              );
        return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'MyShop',
            theme: ThemeData(
              primarySwatch: Colors.indigo,
              accentColor: Colors.amber,
              fontFamily: GoogleFonts.lato().toString(),
              pageTransitionsTheme: PageTransitionsTheme(builders: {
                TargetPlatform.android: CustomPageTransitionBuilder(),
                TargetPlatform.iOS: CustomPageTransitionBuilder(),
              }),
            ),
            home:
                // SplashScreen(),
                ifAuth(ProductOverviewScreen()),
            routes: {
              ProductDetailScreen.routeName: (ctx) =>
                  ifAuth(ProductDetailScreen()),
              CartScreen.routeName: (ctx) => ifAuth(CartScreen()),
              OrdersScreen.routeName: (ctx) => ifAuth(OrdersScreen()),
              UserProductsScreen.routeName: (ctx) =>
                  ifAuth(UserProductsScreen()),
              EditProductScreen.routeName: (ctx) => ifAuth(EditProductScreen()),
            });
      }),
    );
  }
}
