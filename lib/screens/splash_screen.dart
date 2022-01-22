import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/theme.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBlueColor,
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                const Spacer(),
                Container(
                  width: 172,
                  height: 172,
                  decoration: BoxDecoration(
                    color: kDarkBlueColor,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(100),
                    ),
                  ),
                ),
              ],
            ),
            const Expanded(
              child: SizedBox(),
            ),
            Text(
              "Punyatoko",
              style: kPunyatokoTextStyle.copyWith(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Expanded(
              child: SizedBox(),
            ),
            Row(
              children: [
                Container(
                  width: 172,
                  height: 172,
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
    );
  }
}
