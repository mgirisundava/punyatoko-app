import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/auth_provider.dart';
import 'package:shop_app/screens/orders_screen.dart';
import 'package:shop_app/screens/user_products_screen.dart';
import 'package:shop_app/theme.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isLogOut = false;
    bool isLoading = false;

    return Drawer(
      child: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: kWhiteColor,
          ),
          Column(
            children: [
              AppBar(
                title: Text(
                  "Hello Friend!",
                  style: kPunyatokoTextStyle.copyWith(
                    fontWeight: FontWeight.bold,
                    color: kBlackColor,
                  ),
                ),
                automaticallyImplyLeading: false,
                backgroundColor: kWhiteColor,
                elevation: 0,
              ),
              ListTile(
                leading: const Icon(Icons.shop),
                title: Text(
                  "Shop",
                  style: kBlackTextStyle.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onTap: () {
                  Navigator.pushReplacementNamed(context, "/");
                  // Navigator.of(context).pushReplacement(
                  //   CustomRoute(
                  //     builder: (ctx) => ProductOverviewScreen(),
                  // ),
                  // );
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.payment),
                title: Text(
                  "Orders",
                  style: kBlackTextStyle.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onTap: () {
                  Navigator.pushReplacementNamed(
                      context, OrdersScreen.routeName);
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.edit),
                title: Text(
                  "Manage Products",
                  style: kBlackTextStyle.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onTap: () {
                  Navigator.pushReplacementNamed(
                      context, UserProductsScreen.routeName);
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.exit_to_app),
                title: Text(
                  "Logout",
                  style: kBlackTextStyle.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onTap: () async {
                  await showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text("Logout"),
                      content: const Text("Are you sure?"),
                      actions: [
                        TextButton(
                          onPressed: () {
                            isLogOut = false;
                            Navigator.pop(context);
                          },
                          child: const Text("NO"),
                        ),
                        TextButton(
                          onPressed: () {
                            isLogOut = true;
                            Navigator.pop(context);
                            Navigator.pushReplacementNamed(context, '/');
                            Provider.of<AuthProvider>(context, listen: false)
                                .logOut();
                          },
                          child: const Text("YES"),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const Divider(),
            ],
          ),
        ],
      ),
    );
  }
}
