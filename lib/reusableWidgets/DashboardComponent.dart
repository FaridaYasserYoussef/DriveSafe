import 'dart:ffi';

import 'package:flutter/material.dart';

class DashboardComponent extends StatelessWidget {
final String compValue;
final IconData icon;
final String description;
final double dim;
final double valueSize;
final double iconSize;
final double descriptionSize;
  const DashboardComponent({
    super.key, required this.compValue, required this.icon, required this.description, required this.dim,
    required this.valueSize, required this.iconSize, required this.descriptionSize

  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
       width: dim,
      height: dim,
      decoration: new BoxDecoration(
        color: Colors.white,
        shape: BoxShape.rectangle,
        border: Border.all(
      color: Color(0xFF2b7f70), // Change to the color you desire
      width: 2.0,),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
       Text(compValue, style: TextStyle(
        fontSize: valueSize,
        color: Color(0xFF2b7f70)
       ),),

       Icon(
  icon, 
  size: iconSize, 
  color: Color(0xFF2b7f70),
  
),

Text(description, style: TextStyle(
        fontSize: descriptionSize,
        color: Colors.grey
       ),),
      ]),
      ),
    );
  }
}