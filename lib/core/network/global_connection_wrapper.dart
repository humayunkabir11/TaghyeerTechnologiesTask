import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class GlobalConnectionWrapper extends StatefulWidget {
  final Widget child;

  const GlobalConnectionWrapper({super.key, required this.child});

  @override
  State<GlobalConnectionWrapper> createState() =>
      _GlobalConnectionWrapperState();
}

class _GlobalConnectionWrapperState extends State<GlobalConnectionWrapper> {
  bool _hasInternet = true;
  final Connectivity _connectivity = Connectivity();

  @override
  void initState() {
    super.initState();
    _checkInitialConnection();
    _connectivity.onConnectivityChanged.listen((result) {
      if (mounted) {
        setState(() {
          _hasInternet = !result.contains(ConnectivityResult.none);
        });
      }
    });
  }

  Future<void> _checkInitialConnection() async {
    final result = await _connectivity.checkConnectivity();
    if (mounted) {
      setState(() {
        _hasInternet = !result.contains(ConnectivityResult.none);
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
                  color: Colors.black.withOpacity(0.8),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.wifi_off,
                          color: Colors.white,
                          size: 50,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'No Internet Connection',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _retryConnection,
                          child: const Text('RETRY'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
  }
}
