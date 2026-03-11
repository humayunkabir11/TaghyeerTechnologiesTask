import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hrx/core/config/util/style.dart';

class GeoFancyBottom extends StatelessWidget {
  const GeoFancyBottom({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(40),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: Column(
       mainAxisSize: MainAxisSize.min,
        children:  [
          SvgPicture.asset("assets/icons/alert_ic.svg"),
          SizedBox(height: 30),
          Text(
            "You Are Outside Of Your \nOffice Area !",
            textAlign: TextAlign.center,
            style: latoBold.copyWith(
              color: Color(0xFF444444),
              fontFamily: 'Lato',
              fontSize: 20,
              height: 1.6,
            ),
          ),

          Text(
            "Please go Office area to check in.",
            textAlign: TextAlign.center,
            style: latoRegular.copyWith(
              color: Color(0xFF444444),
              fontFamily: 'Lato',
              fontSize: 14,
              height: 1.6,
            ),
          ),
        ],
      ),
    )
    ;
  }
}
