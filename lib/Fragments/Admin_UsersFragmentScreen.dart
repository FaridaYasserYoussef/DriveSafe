import 'package:flutter/material.dart';

class UsersFragmentScreen extends StatefulWidget {
  const UsersFragmentScreen({Key? key}) : super(key: key);

  @override
  _UsersFragmentScreenState createState() => _UsersFragmentScreenState();
}

class _UsersFragmentScreenState extends State<UsersFragmentScreen> {
  // Declare the list of users as a static variable
  List<Map<String, String>> users = [
    {
      'Username': 'JohnDoe',
      'Email': 'john@example.com',
      'Password': 'password123',
      'Age': '30',
      'Gender': 'Male',
    },
    {
      'Username': 'JaneDoe',
      'Email': 'jane@example.com',
      'Password': 'qwerty',
      'Age': '25',
      'Gender': 'Female',
    },
    // Add more users as needed
    {
      'Username': 'AliceSmith',
      'Email': 'alice@example.com',
      'Password': 'alice123',
      'Age': '35',
      'Gender': 'Female',
    },
    {
      'Username': 'BobJohnson',
      'Email': 'bob@example.com',
      'Password': 'bob456',
      'Age': '40',
      'Gender': 'Male',
    },
    {
      'Username': 'EveAnderson',
      'Email': 'eve@example.com',
      'Password': 'eve789',
      'Age': '28',
      'Gender': 'Female',
    },
    {
      'Username': 'DavidWilliams',
      'Email': 'david@example.com',
      'Password': 'david1011',
      'Age': '45',
      'Gender': 'Male',
    },
    {
      'Username': 'SarahBrown',
      'Email': 'sarah@example.com',
      'Password': 'sarah1213',
      'Age': '32',
      'Gender': 'Female',
    },
    {
      'Username': 'MichaelJones',
      'Email': 'michael@example.com',
      'Password': 'michael1415',
      'Age': '50',
      'Gender': 'Male',
    },
    {
      'Username': 'LauraLee',
      'Email': 'laura@example.com',
      'Password': 'laura1617',
      'Age': '27',
      'Gender': 'Female',
    },
    {
      'Username': 'PeterGreen',
      'Email': 'peter@example.com',
      'Password': 'peter1819',
      'Age': '33',
      'Gender': 'Male',
    },
  ];

  void _editUser(int index) {
    showDialog(
      context: context,
      builder: (_) {
        TextEditingController usernameController = TextEditingController(text: users[index]['Username']);
        TextEditingController emailController = TextEditingController(text: users[index]['Email']);
        TextEditingController ageController = TextEditingController(text: users[index]['Age']);
        String selectedGender = users[index]['Gender']!;

        return AlertDialog(
          backgroundColor: Color(0xFF2b7f70),
          title: Text(
            'Edit User',
            style: TextStyle(color: Colors.white),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: usernameController,
                style: TextStyle(color: Colors.white), // Set text color to white
                decoration: InputDecoration(labelText: 'Username'),
              ),
              TextField(
                controller: emailController,
                style: TextStyle(color: Colors.white), // Set text color to white
                decoration: InputDecoration(labelText: 'Email'),
              ),
              TextField(
                controller: ageController,
                style: TextStyle(color: Colors.white), // Set text color to white
                decoration: InputDecoration(labelText: 'Age'),
              ),
              DropdownButtonFormField<String>(
                value: selectedGender,
                items: ['Male', 'Female'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: TextStyle(color: Colors.white), // Set text color to white
                    ),
                  );
                }).toList(),
                onChanged: (String? value) {
                  setState(() {
                    selectedGender = value!;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Gender',
                  labelStyle: TextStyle(color: Colors.white), // Set label color to white
                ),
                dropdownColor: Color(0xFF2b7f70), // Set dropdown background color
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  users[index]['Username'] = usernameController.text;
                  users[index]['Email'] = emailController.text;
                  users[index]['Age'] = ageController.text;
                  users[index]['Gender'] = selectedGender;
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

  List<Map<String, String>> getFilteredUsers(String searchText) {
    if (searchText.isEmpty) {
      return users;
    } else {
      return users.where((user) {
        final username = user['Username']!.toLowerCase();
        final email = user['Email']!.toLowerCase();
        return username.contains(searchText.toLowerCase()) || email.contains(searchText.toLowerCase());
      }).toList();
    }
  }

  String _searchText = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Users',
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
                      'Search Users',
                      style: TextStyle(color: Colors.white),
                    ),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          onChanged: (value) {
                            setState(() {
                              _searchText = value;
                            });
                          },
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            labelText: 'Search by Username or Email',
                            labelStyle: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _searchText = '';
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
              itemCount: getFilteredUsers(_searchText).length,
              itemBuilder: (context, index) {
                final user = getFilteredUsers(_searchText)[index];
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
                            Text(
                              'Username: ',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              user['Username']!,
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
                            Text(
                              'Email: ',
                              style: TextStyle(
                                fontSize: 16,
                                fontStyle: FontStyle.italic,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              user['Email']!,
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
                          children: [
                            Icon(Icons.lock, color: Colors.white),
                            SizedBox(width: 8),
                            GestureDetector(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                    backgroundColor: Color(0xFF2b7f70),
                                    title: Text(
                                      'Password',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    content: Text(
                                      user['Password']!,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text(
                                          'Close',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              child: Text(
                                'Tap to reveal',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.cake, color: Colors.white),
                            SizedBox(width: 8),
                            Text(
                              'Age: ${user['Age']}',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
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
                              'Gender: ${user['Gender']}',
                              style: TextStyle(
                                fontSize: 16,
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
                                _editUser(index);
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

