import 'package:choreyprototype0712/models/servicesdata.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'servicestile.dart';

class ServicesList extends StatelessWidget {
  final ScrollController scroll;

  ServicesList(this.scroll);

  @override
  Widget build(BuildContext context) {
    return Consumer<ServicesData>(
      builder: (context, servicesData, child) {
        return ListView.builder(
          itemBuilder: (context, index) {
            final services = servicesData.services[index];
            return ServicesTile(
              servicesTitle: services.servicesTitle,
              servicesAmount: services.servicesAmount,
              servicesImage: services.servicesImage,
              servicesQuantifiedAmount: services.servicesQuantifiedAmount,
              longPressCallback: () {
                servicesData.deleteServices(services);
              },
            );
          },
          itemCount: servicesData.servicesCount,
          controller: scroll,
        );
      },
    );
  }
}
