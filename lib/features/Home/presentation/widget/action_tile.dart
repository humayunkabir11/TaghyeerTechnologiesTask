import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import '../../../../core/config/util/style.dart';
class ActionTile extends StatelessWidget {
  final String bgCardPath;
  final Widget icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const ActionTile({
    super.key,
    required this.bgCardPath,
    required this.icon,
    required this.title,
    required this.subtitle, required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        height: 80,
        child: Stack(
          alignment: Alignment.centerLeft,
          children: [
            SvgPicture.asset(bgCardPath, height: 80),

            Positioned(
              top: 8,
              bottom: 8,
              left: 8,
              right: 8,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      icon,
                      const Gap(6),
                      Text(
                        title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: latoBold.copyWith(
                          fontSize: 16,
                          color: Colors.white,
                          letterSpacing: 0,
                        ),
                      ),
                    ],
                  ),
                  const Gap(8),
                  Text(
                    subtitle,
                    style: latoRegular.copyWith(
                      fontSize: 12,
                      color: Colors.white,
                      letterSpacing: 0,
                      height: 0,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
