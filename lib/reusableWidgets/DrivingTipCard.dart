import 'package:flutter/material.dart';

class DrivingTipCard extends StatelessWidget {
  final String? messageContent;

  const DrivingTipCard({this.messageContent});


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
    
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              Icon(Icons.tips_and_updates),
              SizedBox(width: 15,),
              Text(this.messageContent!)
            ],
          ),
        ),
 
        decoration: BoxDecoration(color: Color(0xffd2e4e1),
        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                              offset: Offset(0, 3),
                              blurRadius: 6,
                              color: Color(0xFF2b7f70)
                          )
                        ],
                        border: Border.all(
        color: Color(0xFF2b7f70), // Change to the color you desire
        width: 2.0,)
        ),
      ),
    );
  }
}