import 'dart:collection';

import 'package:flutter/foundation.dart';

import 'services.dart';

class ServicesData extends ChangeNotifier {
  List<Services> _services = [];

  UnmodifiableListView<Services> get services {
    return UnmodifiableListView(_services);
  }

  int get servicesCount {
    return _services.length;
  }

  List<String> get listOfDemands {
    List<String> demands = [];
    for (int i = 0; i < _services.length; i++) {
      demands.add(_services[i].servicesImage);
      demands.add(_services[i].servicesTitle);
      demands.add(_services[i].servicesAmount);
      demands.add(_services[i].servicesQuantifiedAmount);
    }
    return demands;
  }

  void addServices(
      {String newServiceTitle,
      String newServiceAmount,
      String newServicesImage,
      String newServicesQuantifiedAmount}) {
    final services = Services(
        servicesTitle: newServiceTitle,
        servicesAmount: newServiceAmount,
        servicesImage: newServicesImage,
        servicesQuantifiedAmount: newServicesQuantifiedAmount);
    _services.add(services);
    //_services.insert(0, services);
    notifyListeners();
  }

  void deleteServices(Services services) {
    _services.remove(services);
    notifyListeners();
  }
}
