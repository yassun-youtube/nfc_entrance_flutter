import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoadingOverlay extends StatelessWidget {
  final bool isLoading;
  final Widget child;

  const LoadingOverlay({Key? key, required this.isLoading, required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Container(
            color: Colors.black.withOpacity(0.5), // 半透明の黒
            child: Center(
                child: Text('Loading...',
                    style: TextStyle(
                        fontSize: 24,
                        color: Colors.black54,
                        decoration: TextDecoration.none))),
          ),
      ],
    );
  }
}
