import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../services/local_storage.dart';
import '../utils/size_config.dart';

class PageDataUsageResume extends StatelessWidget {
  const PageDataUsageResume({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String usageMo =
        double.parse((LocalStorage.getDateUsageBytes / 1000000).toString())
            .toStringAsFixed(1);
    DateTime today = DateTime.now();

    DateTime firstUsageDate = LocalStorage.dateFirstUsage();

    bool firstDayUse = firstUsageDate.day == today.day &&
        firstUsageDate.month == today.month &&
        firstUsageDate.year == today.year;

    return Material(
      child: Padding(
        padding: const EdgeInsets.only(left: 45, right: 45),
        child: SafeArea(
            child: Column(
          children: [
            Container(
              height: SizeConfig.screenHeight / 12,
            ),
            SizedBox(
              height: SizeConfig.screenHeight / 3,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    usageMo,
                    style: TextStyle(
                        fontFamily: "Poppins",
                        decoration: TextDecoration.overline,
                        decorationColor: Colors.teal,
                        fontWeight: usageMo.length <= 2
                            ? FontWeight.w600
                            : usageMo.length == 3
                                ? FontWeight.w500
                                : usageMo.length == 4
                                    ? FontWeight.w400
                                    : FontWeight.w300,
                        letterSpacing: 9,
                        fontSize:
                            getProportionateScreenWidth(usageMo.length <= 2
                                ? 126
                                : usageMo.length == 3
                                    ? 108
                                    : usageMo.length == 4
                                        ? 87
                                        : 69)),
                  ),
                  Text(
                    "Mo",
                    style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: getProportionateScreenWidth(45)),
                  )
                ],
              ),
            ),
            SizedBox(
              height: SizeConfig.screenHeight / 6,
              child: Center(
                child: Text(
                  firstDayUse
                      ? "Aujourd'hui"
                      : "Du ${DateFormat.yMMMMEEEEd('fr').format(firstUsageDate)}",
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontSize: getProportionateScreenWidth(24),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: SizeConfig.screenHeight / 6,
              child: Center(
                child: Text(
                  firstDayUse ? " " : "au",
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontSize: getProportionateScreenWidth(96),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: SizeConfig.screenHeight / 12,
              child: Center(
                child: Text(
                  firstDayUse
                      ? " "
                      : "${DateFormat.yMMMMEEEEd('fr').format(today)}.",
                  style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: getProportionateScreenWidth(18)),
                ),
              ),
            ),
            SizedBox(
              height: SizeConfig.screenHeight / 12,
              child: Center(
                child: Text(
                  firstDayUse
                      ? " "
                      : "(${today.difference(firstUsageDate).inDays} jours)",
                  style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: getProportionateScreenWidth(9)),
                ),
              ),
            ),
          ],
        )),
      ),
    );
  }
}
