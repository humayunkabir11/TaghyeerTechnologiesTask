import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class GlobalConnectionWrapper extends StatefulWidget {
  final Widget child;

  const GlobalConnectionWrapper({super.key, required this.child});

  @override
  State<GlobalConnectionWrapper> createState() =>
      _GlobalConnectionWrapperState();
}

class _GlobalConnectionWrapperState extends State<GlobalConnectionWrapper> {
  bool _hasInternet = true;
  bool _wasOffline = false;
  final Connectivity _connectivity = Connectivity();

  @override
  void initState() {
    super.initState();
    _checkInitialConnection();
    _connectivity.onConnectivityChanged.listen((result) {
      if (mounted) {
        final currentlyHasInternet = !result.contains(ConnectivityResult.none);
        
        if (currentlyHasInternet && _wasOffline) {
          Fluttertoast.showToast(
            msg: "Internet connected successfully",
            backgroundColor: Colors.green,
            textColor: Colors.white,
          );
        }

        setState(() {
          _hasInternet = currentlyHasInternet;
          if (!currentlyHasInternet) {
            _wasOffline = true;
          } else {
             _wasOffline = false;
          }
        });
      }
    });
  }

  Future<void> _checkInitialConnection() async {
    final result = await _connectivity.checkConnectivity();
    if (mounted) {
      final currentlyHasInternet = !result.contains(ConnectivityResult.none);
      setState(() {
        _hasInternet = currentlyHasInternet;
        if (!currentlyHasInternet) {
           _wasOffline = true;
        }
      });
    }
  }

  void _retryConnection() {
    _checkInitialConnection();
  }

  @override
  Widget build(BuildContext context) {
    return _hasInternet
        ? widget.child
        : Directionality(
            textDirection: TextDirection.ltr,
            child: Stack(
              children: [
                widget.child,
                Container(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.cloud_off_rounded,
                            color: Colors.grey.shade500,
                            size: 100,
                          ),
                          const SizedBox(height: 24),
                          Text(
                            'No internet connection',
                            style: TextStyle(
                              color: Theme.of(context).textTheme.bodyLarge?.color,
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.none,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Please check your network settings and try again.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7),
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                              height: 1.4,
                              decoration: TextDecoration.none,
                            ),
                          ),
                          const SizedBox(height: 32),
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: OutlinedButton(
                              onPressed: _retryConnection,
                              style: OutlinedButton.styleFrom(
                                foregroundColor: const Color(0xFF0A66C2), // LinkedIn Blue
                                side: const BorderSide(
                                  color: Color(0xFF0A66C2),
                                  width: 1.5,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                              ),
                              child: const Text(
                                'Retry',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
  }
}
