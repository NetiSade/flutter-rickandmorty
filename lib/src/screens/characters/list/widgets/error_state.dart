import 'package:flutter/material.dart';

class ErrorState extends StatelessWidget {
  const ErrorState({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Center(
        child: Text('Failed to load characters, please try again'));
  }
}
