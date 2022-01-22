// ignore_for_file: deprecated_member_use, use_key_in_widget_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products_provider.dart';
import 'package:shop_app/screens/edit_product_screen.dart';
import 'package:shop_app/theme.dart';

class UserProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;

  const UserProductItem(this.id, this.title, this.imageUrl);

  @override
  Widget build(BuildContext context) {
    bool isDelete = false;
    bool isLoading = false;

    final scaffold = Scaffold.of(context);
    return SizedBox(
      height: 100,
      child: Card(
        elevation: 1,
        child: Column(
          children: [
            const Expanded(
              child: SizedBox(),
            ),
            ListTile(
              title: Text(
                title,
                style: kBlackTextStyle.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 3,
              ),
              leading: Container(
                height: 75,
                width: 75,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(imageUrl),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              trailing: SizedBox(
                width: 100,
                child: Row(
                  children: <Widget>[
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        Navigator.pushNamed(
                            context, EditProductScreen.routeName,
                            arguments: id);
                      },
                      color: Theme.of(context).primaryColor,
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () async {
                        try {
                          await showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text("Are you sure?"),
                              content: const Text(
                                  "Do you want to remove the item from the orders?"),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    isDelete = false;
                                    Navigator.pop(context);
                                  },
                                  child: const Text("NO"),
                                ),
                                TextButton(
                                  onPressed: () {
                                    isDelete = true;
                                    Navigator.pop(context);
                                    Provider.of<ProductsProvider>(context,
                                            listen: false)
                                        .deleteProduct(id);
                                  },
                                  child: const Text("YES"),
                                ),
                              ],
                            ),
                          );
                        } catch (e) {
                          scaffold.showSnackBar(
                            const SnackBar(
                              content: Text("Deleting failed!"),
                            ),
                          );
                        }
                      },
                      color: Theme.of(context).errorColor,
                    ),
                  ],
                ),
              ),
            ),
            const Expanded(
              child: SizedBox(),
            ),
          ],
        ),
      ),
    );
  }
}
