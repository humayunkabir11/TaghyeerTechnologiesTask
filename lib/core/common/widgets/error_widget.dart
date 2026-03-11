import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../error/failures.dart';
import '../../config/theme/style.dart';

class AppErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  final bool isNoInternet;

  const AppErrorWidget({
    super.key,
    required this.message,
    required this.onRetry,
    this.isNoInternet = false,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isNoInternet ? Icons.wifi_off : Icons.error_outline,
              size: 60,
              color: Colors.grey,
            ),
            const Gap(16),
            Text(
              isNoInternet ? "No Internet Connection" : message,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
            const Gap(20),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              ),
              child: const Text("Retry"),
            ),
          ],
        ),
      ),
    );
  }
}
