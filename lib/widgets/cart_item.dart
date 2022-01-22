import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart_provider.dart';
import 'package:shop_app/theme.dart';

class CartItem extends StatelessWidget {
  final double price;
  final String title;
  final int qty;
  final String id;
  final String productId;

  const CartItem({
    Key key,
    @required this.id,
    @required this.price,
    @required this.title,
    @required this.qty,
    @required this.productId,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Are you sure?"),
            content:
                const Text("Do you want to remove the item from the cart?"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: const Text("NO"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: const Text("YES"),
              )
            ],
          ),
        );
      },
      onDismissed: (direction) {
        Provider.of<CartProvider>(context, listen: false).removeItem(productId);
      },
      background: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).errorColor,
        ),
        child: const Padding(
          padding: EdgeInsets.only(right: 20),
          child: Icon(
            Icons.delete,
            size: 30,
            color: Colors.white,
          ),
        ),
        alignment: Alignment.centerRight,
      ),
      direction: DismissDirection.endToStart,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
        height: 95,
        decoration: BoxDecoration(
          color: kWhiteColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            const Expanded(
              child: SizedBox(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  Container(
                    width: 75,
                    height: 75,
                    decoration: BoxDecoration(
                      color: kBlueColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        NumberFormat.currency(
                          locale: "en_US",
                          symbol: "\$",
                          decimalDigits: 2,
                        ).format(price),
                        style: kWhiteTextStyle.copyWith(
                            fontWeight: FontWeight.w500, fontSize: 18),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 18,
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: kBlackTextStyle.copyWith(
                            fontWeight: FontWeight.w500,
                            fontSize: 20,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                        Text(
                          NumberFormat.currency(
                            locale: "en_US",
                            symbol: "\$",
                            decimalDigits: 2,
                          ).format(price),
                          style: kOrangeTextStyle.copyWith(
                              fontWeight: FontWeight.w500, fontSize: 18),
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                        Row(
                          children: [
                            const Spacer(),
                            Text(
                              "$qty x",
                              style: kBlackTextStyle.copyWith(fontSize: 20),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
            // ListTile(
            //   leading: Container(
            //     width: 75,
            //     height: 75,
            //     decoration: BoxDecoration(color: kBlueColor),
            //   ),
            //   title: Text(title),
            //   subtitle: Text(
            //     "Total : ${NumberFormat.currency(
            //       locale: "en_US",
            //       decimalDigits: 2,
            //       symbol: "\$",
            //     ).format(
            //       price * qty,
            //     )}",
            //   ),
            //   trailing: SizedBox(
            //     child: Text(
            //       "$qty x",
            //       style: const TextStyle(fontSize: 20),
            //     ),
            //   ),
            // ),
            ,
            const Expanded(
              child: SizedBox(),
            ),
          ],
        ),
      ),
    );
  }
}
