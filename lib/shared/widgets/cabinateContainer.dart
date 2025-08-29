import 'package:flutter/material.dart';
import 'package:meditrack/shared/constants/Colors.dart';
import 'package:percent_indicator/percent_indicator.dart';

Widget cabinateContainer(
  String tabletName,
  int tabletAmount,
  int totalTablet,
  String subtitle,
) {
  return Container(
    // height: 100,
    width: 200,
    decoration: BoxDecoration(
      color: CustomColors.cardLightPink,
      // color: Colors.amber,x
      borderRadius: BorderRadius.circular(20),
    ),
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            spacing: 5,
            children: [
              CircularPercentIndicator(
                radius: 23,
                lineWidth: 3,
                progressColor: CustomColors.primaryPurple,
                animation: true,
                animationDuration: 2000,
                percent: tabletAmount / totalTablet,
                center: SizedBox(
                  height: double.maxFinite,
                  child: Image.asset("assets/icons/capsule.png"),
                ),
              ),
              Text(
                tabletName,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: CustomColors.textDark,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          Row(
            // crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                tabletAmount.toString() + " Pills",
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: CustomColors.primaryPurple,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                " - " + totalTablet.toString(),
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: CustomColors.textSub,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          Text(
            subtitle,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: CustomColors.textDark,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    ),
  );
}
