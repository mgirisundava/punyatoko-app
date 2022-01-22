// ignore_for_file: must_be_immutable, constant_identifier_names

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/theme.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import '../providers/cart_provider.dart';
import '/screens/cart_screen.dart';
import '../widgets/badge.dart';
import '../providers/products_provider.dart';
import '../widgets/products_grid.dart';

enum FilterOption { Favorites, All }

class ProductOverviewScreen extends StatefulWidget {
  const ProductOverviewScreen({Key key}) : super(key: key);

  @override
  State<ProductOverviewScreen> createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  bool showOnlyFavorites = false;

  Future _productsFuture;
  Future _obtainProductsFuture() {
    return Provider.of<ProductsProvider>(context, listen: false)
        .fetchAndSetProducts();
  }

  @override
  void initState() {
    // setState(() {
    //   _isLoading = true;
    // });
    // Provider.of<ProductsProvider>(context, listen: false)
    //     .fetchAndSetProducts()
    //     .then((_) {
    //   setState(() {
    //     _isLoading = false;
    //   });
    // });
    _productsFuture = _obtainProductsFuture();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      backgroundColor: kBlueColor,
      elevation: 0,
      centerTitle: true,
      title: Text(
        "Punyatoko",
        style: kPunyatokoTextStyle.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        PopupMenuButton(
          onSelected: (FilterOption selectedValue) {
            if (selectedValue == FilterOption.Favorites) {
              // productsData.showFavoritOnly();
              setState(() {
                showOnlyFavorites = true;
              });
            } else {
              // productsData.showAll();
              setState(() {
                showOnlyFavorites = false;
              });
            }
          },
          icon: const Icon(Icons.more_vert),
          itemBuilder: (_) => [
            const PopupMenuItem(
              child: Text("Show Favorites"),
              value: FilterOption.Favorites,
            ),
            const PopupMenuItem(
              child: Text("Show All"),
              value: FilterOption.All,
            ),
          ],
        ),
        Consumer<CartProvider>(
          builder: (_, cart, ch) => Badge(
            child: ch,
            value: cart.itemCount.toString(),
          ),
          child: IconButton(
            onPressed: () {
              Navigator.pushNamed(context, CartScreen.routeName);
            },
            icon: const Icon(Icons.shopping_cart),
          ),
        )
      ],
    );
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: appBar,
      drawer: const AppDrawer(),
      body: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(color: kBlueColor),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  children: [
                    Container(
                      width: 300,
                      height: 300,
                      decoration: BoxDecoration(
                        color: kDarkBlueColor,
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(100),
                        ),
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
              ],
            ),
          ),
          FutureBuilder(
            future: _productsFuture,
            builder: (ctx, dataSnapshot) {
              if (dataSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                if (dataSnapshot.error != null) {
                  return const Center(
                    child: Text("An error occured!"),
                  );
                } else {
                  return Consumer<ProductsProvider>(
                    builder: (ctx, productsData, child) {
                      return ProductsGrid(
                        showOnlyFavorites: showOnlyFavorites,
                      );
                    },
                  );
                }
              }
            },
          ),
        ],
      ),
    );
  }
}
