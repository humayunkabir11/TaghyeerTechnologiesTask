import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../core/config/color/custom_color.dart';
import '../../../../core/config/util/style.dart';

class SummaryTile extends StatelessWidget {
  final String ? label;
  final String title;
  final String subtitle;
  final Widget icon;
  final Color ? circleColor;
  final Color ? dotColor;
  final VoidCallback? onTap;
  const SummaryTile({
    super.key,
     this.label,
    required this.title,
    required this.subtitle,
    required this.icon,
     this.circleColor ,
     this.dotColor ,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16),
        height: 115,
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          shadows: [
            BoxShadow(
              color: Color(0x19D6D6D6),
              blurRadius: 10,
              offset: Offset(0, 0),
              spreadRadius: 9,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              spacing: 8,
              children: [
                Container(
                  height: 32,
                  width: 32,
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: circleColor,
                  ),
                  child: icon,
                ),
                Expanded(
                  child: Row(
                    spacing: 4,
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                    dotColor==null?  Container(
                        height: 8,
                        width: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: circleColor,
                        ),
                      ) : SizedBox(),
                      Flexible(
                        child: Text(
                          label ?? "",
                          maxLines: 1,
                          textAlign: TextAlign.end,
                          overflow: TextOverflow.ellipsis,
                          style: latoRegular.copyWith(
                            fontSize: 12,
                            color: AppColors.primaryTextColor,
                            letterSpacing: 0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            ///--------------------title & subtitle
            const Gap(8),
            Expanded(
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: latoBold.copyWith(
                  fontSize: 16,
                  color: AppColors.primaryTextColor,
                  letterSpacing: 0,
                ),
              ),
            ),

            Expanded(
              child: Text(
                subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: latoMedium.copyWith(
                  fontSize: 12,
                  color: AppColors.blurryWhite,
                  letterSpacing: 0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
