import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screens/products_overview_screen.dart';
import './screens/product_detail_screen.dart';
import './screens/cart_screen.dart';
import './screens/orders_screen.dart';
import './screens/user_products_screen.dart';
import './screens/edit_product_screen.dart';
import './screens/auth_screen.dart';
import './screens/splash_screen.dart';

import './providers/products_providers.dart';
import './providers/cart_providers.dart';
import './providers/orders_providers.dart';
import './providers/auth_providers.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // return ChangeNotifierProvider(
    //   builder: (ctx)=>ProductsProviders(),
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: AuthProviders(),
        ),
        ChangeNotifierProxyProvider<AuthProviders, ProductsProviders>(
          builder: (ctx, auth, previousProducts) => ProductsProviders(
              auth.token,
              auth.userId,
              previousProducts == null ? [] : previousProducts.items),
        ),
        // ChangeNotifierProvider.value(
        //   value: ProductsProviders(),
        // ),
        ChangeNotifierProvider.value(
          value: CartProviders(),
        ),
        ChangeNotifierProxyProvider<AuthProviders, OrdersProviders>(
          builder: (ctx, auth, previousOrders) => OrdersProviders(auth.token,
              auth.userId, previousOrders == null ? [] : previousOrders.orders),
        ),
      ],
      child: Consumer<AuthProviders>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'MyShop',
          theme: ThemeData(
            primarySwatch: Colors.purple,
            accentColor: Colors.deepOrange,
            fontFamily: 'Lato',
          ),
          home: auth.isAuth
              ? ProductsOverviewScreens()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (ctx, authResultSnapshot) =>
                      authResultSnapshot.connectionState ==
                              ConnectionState.waiting
                          ? SplashScreen()
                          : AuthScreen(),
                ),
          routes: {
            ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
            CartScreen.routName: (ctx) => CartScreen(),
            OrdersScreen.routName: (ctx) => OrdersScreen(),
            UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
            EditProductScreen.routeName: (ctx) => EditProductScreen(),
          },
        ),
      ),
    );
  }
}
