import 'package:flutter/material.dart';

class VehiclesFragmentScreen extends StatefulWidget {
  const VehiclesFragmentScreen({Key? key}) : super(key: key);

  @override
  _VehiclesFragmentScreenState createState() => _VehiclesFragmentScreenState();
}

class _VehiclesFragmentScreenState extends State<VehiclesFragmentScreen> {
  // Declare the list of vehicles as a static variable
  List<Map<String, String>> vehicles = [
    {
      'Type': 'Car',
      'Plate Number': '#1234 أ ب ت',
      'Owner Username': 'JohnDoe',
    },
    {
      'Type': 'Bus',
      'Plate Number': '#5678 ج ح خ',
      'Owner Username': 'JaneDoe',
    },
    {
      'Type': 'Truck',
      'Plate Number': '#9012 ر ز س',
      'Owner Username': 'AliceSmith',
    },
    {
      'Type': 'SUV',
      'Plate Number': '#3456 ل م ن',
      'Owner Username': 'BobJohnson',
    },
    {
      'Type': 'Motorcycle',
      'Plate Number': '#7890 ص ض ط',
      'Owner Username': 'EveAnderson',
    },
    {
      'Type': 'Van',
      'Plate Number': '#2345 ظ ع غ',
      'Owner Username': 'DavidWilliams',
    },
    {
      'Type': 'Taxi',
      'Plate Number': '#6789 ف ق ك',
      'Owner Username': 'SarahBrown',
    },
    {
      'Type': 'Ambulance',
      'Plate Number': '#0123 ل م ن',
      'Owner Username': 'MichaelJones',
    },
    {
      'Type': 'Fire Truck',
      'Plate Number': '#4567 ه و ي',
      'Owner Username': 'LauraLee',
    },
    {
      'Type': 'Police Car',
      'Plate Number': '#8901 آ إ أ',
      'Owner Username': 'PeterGreen',
    },
  ];

  String _plateNumberFilter = '';

  void _editVehicle(int index) {
    showDialog(
      context: context,
      builder: (_) {
        TextEditingController plateNumberController = TextEditingController(text: vehicles[index]['Plate Number']);
        TextEditingController ownerUsernameController = TextEditingController(text: vehicles[index]['Owner Username']);
        String selectedType = vehicles[index]['Type']!;

        return AlertDialog(
          backgroundColor: Color(0xFF2b7f70),
          title: Text(
            'Edit Vehicle',
            style: TextStyle(color: Colors.white),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                value: selectedType,
                items: ['Car', 'Bus', 'Truck', 'SUV', 'Motorcycle', 'Van', 'Taxi', 'Ambulance', 'Fire Truck', 'Police Car'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                }).toList(),
                onChanged: (String? value) {
                  setState(() {
                    selectedType = value!;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Type of Vehicle',
                  labelStyle: TextStyle(color: Colors.white),
                ),
                dropdownColor: Color(0xFF2b7f70),
              ),
              TextField(
                controller: plateNumberController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(labelText: 'Plate number'),
              ),
              TextField(
                controller: ownerUsernameController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(labelText: 'Username of Vehicle Owner'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  vehicles[index]['Type'] = selectedType;
                  vehicles[index]['Plate Number'] = plateNumberController.text;
                  vehicles[index]['Owner Username'] = ownerUsernameController.text;
                });
                Navigator.pop(context);
              },
              child: Text(
                'Save',
                style: TextStyle(color: Colors.white),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  List<Map<String, String>> getFilteredVehicles() {
    if (_plateNumberFilter.isEmpty) {
      return vehicles;
    } else {
      return vehicles.where((vehicle) {
        final plateNumber = vehicle['Plate Number']!;
        return plateNumber.contains(_plateNumberFilter);
      }).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Vehicles',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Color(0xFF2b7f70),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) {
                  return AlertDialog(
                    backgroundColor: Color(0xFF2b7f70),
                    title: Text(
                      'Search by Plate Number',
                      style: TextStyle(color: Colors.white),
                    ),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: TextField(
                                onChanged: (value) {
                                  setState(() {
                                    _plateNumberFilter = value;
                                  });
                                },
                                style: TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  labelText: 'Plate Number (e.g., 1234)',
                                  labelStyle: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            Flexible(
                              child: TextField(
                                onChanged: (value) {
                                  setState(() {
                                    _plateNumberFilter = value;
                                  });
                                },
                                style: TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  labelText: 'Arabic Letters',
                                  labelStyle: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _plateNumberFilter = '';
                          });
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Clear Filter',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Search',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
            icon: Icon(Icons.search),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: getFilteredVehicles().length,
              itemBuilder: (context, index) {
                final vehicle = getFilteredVehicles()[index];
                IconData iconData;
                switch (vehicle['Type']) {
                  case 'Car':
                    iconData = Icons.directions_car;
                    break;
                  case 'Bus':
                    iconData = Icons.directions_bus;
                    break;
                  case 'Truck':
                    iconData = Icons.local_shipping;
                    break;
                  case 'SUV':
                    iconData = Icons.directions_car;
                    break;
                  case 'Motorcycle':
                    iconData = Icons.motorcycle;
                    break;
                  case 'Van':
                    iconData = Icons.directions_car;
                    break;
                  case 'Taxi':
                    iconData = Icons.local_taxi;
                    break;
                  case 'Ambulance':
                    iconData = Icons.local_hospital;
                    break;
                  case 'Fire Truck':
                    iconData = Icons.local_fire_department;
                    break;
                  case 'Police Car':
                    iconData = Icons.local_police;
                    break;
                  default:
                    iconData = Icons.directions_car;
                }
                return Card(
                  elevation: 3,
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  color: Color(0xFF2b7f70),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(iconData, color: Colors.white),
                            SizedBox(width: 8),
                            Text(
                              'Type of Vehicle: ',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              vehicle['Type']!,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.format_list_numbered, color: Colors.white),
                            SizedBox(width: 8),
                            Text(
                              'Plate number: ',
                              style: TextStyle(
                                fontSize: 16,
                                fontStyle: FontStyle.italic,
                                color: Colors.white,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                vehicle['Plate Number']!,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF2b7f70),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.person, color: Colors.white),
                            SizedBox(width: 8),
                            Text(
                              'Owner Username: ',
                              style: TextStyle(
                                fontSize: 16,
                                fontStyle: FontStyle.italic,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              vehicle['Owner Username']!,
                              style: TextStyle(
                                fontSize: 16,
                                fontStyle: FontStyle.italic,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              onPressed: () {
                                _editVehicle(index);
                              },
                              icon: Icon(Icons.edit, color: Colors.white),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

