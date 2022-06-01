import 'package:flutter/material.dart';

import 'roundedbutton.dart';

class ServiceCard extends StatelessWidget {
  final String title;
  final String subTitle;
//  final Animatable Animation;
  final Function infoPage;
  final String mainImage;
  final double serviceAmount;
  final String displayedServiceAmount;
  final Function servicePicture;
  final double minimum;
  final double maximum;
  final String units;
  final int sections;
  final Function addService;

  ServiceCard({
    this.title,
    this.subTitle,
    this.infoPage,
    this.mainImage,
    this.serviceAmount,
    this.displayedServiceAmount,
    this.servicePicture,
    this.minimum,
    this.maximum,
    this.units,
    this.sections,
    this.addService,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5.0,
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text(
              title,
              style: TextStyle(fontSize: 25.0),
            ),
            subtitle: Text(
              subTitle,
              style: TextStyle(fontSize: 25.0),
            ),
            trailing: IconButton(
              icon: Icon(
                Icons.info_outline,
                size: 30.0,
              ),
              onPressed: infoPage,
            ),
          ),
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: 151.0,
              minHeight: 150.0,
            ),
            child: Image.asset(
              mainImage,
            ),
          ),
          Text(
            "$displayedServiceAmount $units",
            style: TextStyle(fontSize: 30.0),
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 15.0,
              //trackShape: SliderComponentShape(),
              inactiveTrackColor: Color(0xFFF6F6F6),
              activeTrackColor: Colors.purpleAccent,
              thumbColor: Colors.purple,
              overlayColor: Color(0x29EB1555),
              thumbShape: RoundSliderThumbShape(enabledThumbRadius: 15.0),
              overlayShape: RoundSliderOverlayShape(overlayRadius: 30.0),
            ),
            child: Slider(
              value: serviceAmount,
              min: minimum,
              max: maximum,
              onChanged: servicePicture,
              divisions: sections,
            ),
          ),
          RoundedButton(
            onPressed: addService,
            colour: Colors.purple,
            title: "Add Service",
          ),
        ],
      ),
    );
  }
}
