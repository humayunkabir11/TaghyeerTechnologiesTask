import 'package:flutter/material.dart';

import 'geo_fency_bottom.dart';

void showGeoFenceWarning(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
    ),
    builder: (context) {
      return GeoFancyBottom();
    },
  );
}
