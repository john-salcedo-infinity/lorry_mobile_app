import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

class BallBeatLoading extends StatelessWidget {
  const BallBeatLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 50,
      height: 20,
      child: LoadingIndicator(
        indicatorType: Indicator.ballBeat,
        strokeWidth: 3.0,
        colors: [Colors.white],
      ),
    );
  }
}
