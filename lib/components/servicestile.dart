import 'package:flutter/material.dart';

class ServicesTile extends StatelessWidget {
  final Function longPressCallback;
  final String servicesImage;
  final String servicesTitle;
  final String servicesAmount;
  final String servicesQuantifiedAmount;

  ServicesTile(
      {this.longPressCallback,
      this.servicesImage,
      this.servicesTitle,
      this.servicesAmount,
      this.servicesQuantifiedAmount});

  @override
  Widget build(BuildContext context) {
    return ListTile(
        onLongPress: longPressCallback,
        leading: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: 76.0,
            minHeight: 75.0,
          ),
          child: Image.asset(
            servicesImage,
          ),
        ),
        title: Text(
          servicesTitle,
        ),
        subtitle: Text(servicesAmount),
        trailing: Text(servicesQuantifiedAmount));
  }
}
