import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/theme.dart';
import 'package:shop_app/widgets/cart_item.dart';
import '../providers/cart_provider.dart' show CartProvider;
import '../providers/orders_provider.dart';

class CartScreen extends StatelessWidget {
  static const routeName = "cart-screen";

  const CartScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        foregroundColor: kWhiteColor,
        backgroundColor: kBlueColor,
        title: Text(
          "Cart",
          style: kPunyatokoTextStyle.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
      ),
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
                    const Spacer(),
                    Container(
                      width: 300,
                      height: 300,
                      decoration: BoxDecoration(
                        color: kDarkBlueColor,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(100),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: cart.items.length,
                  itemBuilder: (ctx, i) => CartItem(
                    id: cart.items.values.toList()[i].id,
                    title: cart.items.values.toList()[i].title,
                    price: cart.items.values.toList()[i].price,
                    qty: cart.items.values.toList()[i].quantity,
                    productId: cart.items.keys.toList()[i],
                  ),
                ),
              )
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              height: 80,
              decoration: BoxDecoration(
                color: kWhiteColor,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 18,
                  horizontal: 15,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "TOTAL",
                          style: kBlackTextStyle.copyWith(
                            color: kBlackColor.withOpacity(0.5),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          NumberFormat.currency(
                                  locale: "en_US",
                                  symbol: "\$ ",
                                  decimalDigits: 2)
                              .format(cart.totalAmount),
                          style: kOrangeTextStyle.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                    OrderButton(cart: cart),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key key,
    @required this.cart,
  }) : super(key: key);

  final CartProvider cart;

  @override
  State<OrderButton> createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: 155,
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        color: kYellowColor,
        child: _isLoading
            ? const CircularProgressIndicator()
            : Text(
                "ORDER NOW",
                style: widget.cart.totalAmount <= 0
                    ? kWhiteTextStyle.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      )
                    : kBlackTextStyle.copyWith(
                        color: kBlackColor.withOpacity(0.8),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
              ),
        onPressed: (widget.cart.totalAmount <= 0 || _isLoading)
            ? null
            : () async {
                setState(() {
                  _isLoading = true;
                });
                await Provider.of<OrdersProvider>(context, listen: false)
                    .addOrder(
                  widget.cart.items.values.toList(),
                  widget.cart.totalAmount,
                );
                setState(() {
                  _isLoading = false;
                });
                widget.cart.clear();
              },
      ),
    );
  }
}
