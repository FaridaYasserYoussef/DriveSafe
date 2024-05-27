import 'package:flutter/material.dart';

class ViewTripEvents extends StatelessWidget {
  const ViewTripEvents({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Define a list of trips
    final List<Trip> trips = [
      Trip(
        incident: 'Speed Bump Passing',
        time: '12:00 PM',
        imageUrl: 'https://static.thenounproject.com/png/887016-200.png',
      ),
      Trip(
        incident: 'Zigzag Driving',
        time: '          11:55 PM',
        imageUrl:'data:image/png;base64,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'

      ),
      Trip(
        incident: '    Pothhole Passing',
        time: ' 12:30 PM',
        imageUrl:
            'data:image/jpeg;base64,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',
      ),
    ];

    return MaterialApp(
      home: Container(
        padding: EdgeInsets.fromLTRB(20.0, 40.0, 20.0, 20.0),
        child: Scaffold(
          body: SizedBox(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10.0,
                    vertical: 20.0,
                  ),
                  child: Center(
                    child: Text(
                      'Trip#128',
                      style: Theme.of(context).textTheme.headline6!.copyWith(
                            color: Color(0xFF2b7f70),
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: trips.length,
                    itemBuilder: (BuildContext context, int index) {
                      final trip = trips[index];

                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color(0xffd2e4e1),
                            border: Border.all(
                              color: Color.fromARGB(255, 25, 75, 66),
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Container(
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    image: DecorationImage(
                                      image: NetworkImage(trip.imageUrl),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(width: 90.0),
                                    Column(
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 15.0),
                                          child: Text(
                                            'Incident',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 22,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 14.0),
                                          child: Text(
                                            trip.incident,
                                            style: TextStyle(fontSize: 23),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(width: 50.0),
                                    Column(
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 15.0),
                                          child: Text(
                                            'Time',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 22,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 14.0),
                                          child: Text(
                                            trip.time,
                                            style: TextStyle(fontSize: 23),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Trip {
  final String incident;
  final String time;
  final String imageUrl;

  Trip({
    required this.incident,
    required this.time,
    required this.imageUrl,
  });
}
