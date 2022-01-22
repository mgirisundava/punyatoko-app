import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/orders_provider.dart';
import 'package:shop_app/theme.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/order_item.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = "orders";

  const OrdersScreen({Key key}) : super(key: key);

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  // var _isLoading = false;
  Future _ordersFuture;
  Future _obtainOrdersFuture() {
    return Provider.of<OrdersProvider>(context, listen: false)
        .fetchAndSetOrders();
  }

  @override
  void initState() {
    // setState(() {
    //   _isLoading = true;
    // });
    // Provider.of<OrdersProvider>(context, listen: false)
    //     .fetchAndSetOrders()
    //     .then((_) {
    //   setState(() {
    //     _isLoading = false;
    //   });
    // });
    _ordersFuture = _obtainOrdersFuture();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final ordersData = Provider.of<OrdersProvider>(context);
    return Scaffold(
        backgroundColor: kBlueColor,
        appBar: AppBar(
          backgroundColor: kBlueColor,
          title: Text(
            "Your Orders",
            style: kPunyatokoTextStyle.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          elevation: 0,
        ),
        drawer: const AppDrawer(),
        body: FutureBuilder(
          future: _ordersFuture,
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
                return Consumer<OrdersProvider>(
                  builder: (ctx, ordersData, child) {
                    return ListView.builder(
                      itemCount: ordersData.orders.length,
                      itemBuilder: (ctx, i) => OrderItem(
                        order: ordersData.orders[i],
                      ),
                    );
                  },
                );
              }
            }
          },
        ));
  }
}
