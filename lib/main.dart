import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final newText = newValue.text;
    if (oldValue.text.length >= newText.length) {
      return newValue;
    }

    var dateText = newText.replaceAll(RegExp(r'/'), '');
    if (dateText.length > 8) {
      // Limit to 8 characters (YYYYMMDD)
      dateText = dateText.substring(0, 8);
    }
    if (dateText.length > 4) {
      // Add slash after month (YYYY/MM)
      dateText = dateText.substring(0, 4) + '/' + dateText.substring(4, 6) + (dateText.length > 6 ? '/' + dateText.substring(6) : '');
    } else if (dateText.length > 2) {
      // Add slash after year (YYYY/)
      dateText = dateText.substring(0, 4) + (dateText.length > 4 ? '/' + dateText.substring(4) : '');
    }
    return newValue.copyWith(
      text: dateText,
      selection: TextSelection.collapsed(offset: dateText.length),
    );
  }
}

void main() => runApp(MaterialApp(
  home: Home(),
));

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _isLoading = false;

  void _toggleLoading() {
    setState(() {
      _isLoading = !_isLoading;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Image(
              image: AssetImage('assets/1.png'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _toggleLoading();
                // Simulate a delay to show the spinner
                Future.delayed(Duration(seconds: 1), () {
                  _toggleLoading();
                  // Navigate to the second page
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => SecondPage()));
                });
              },
              child: _isLoading
                  ? SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  strokeWidth: 2,
                ),
              )
                  : Text(
                'Commencer',
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                primary: Color(0xff7b3910),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: EdgeInsets.symmetric(horizontal: 100, vertical: 5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class SecondPage extends StatefulWidget {
  @override
  _SecondPageState createState() => _SecondPageState();
}
class ThirdPage extends StatefulWidget {
  @override
  _ThirdPageState createState() => _ThirdPageState();
}

class _SecondPageState extends State<SecondPage> {
  final TextEditingController _dateController = TextEditingController();
  String? _selectedType;
  final List<String> _typeOptions = ['Professionnel', 'Particulier'];
  double _calculatePasswordStrength(String password) {
    if (password.isEmpty) {
      return 0;
    }
    double strength = 0;

    // Add strength for length
    if (password.length >= 8) strength += 0.25;

    // Add strength for lowercase and uppercase letters
    if (RegExp(r'[a-z]').hasMatch(password) && RegExp(r'[A-Z]').hasMatch(password)) strength += 0.25;

    // Add strength for numbers
    if (RegExp(r'[0-9]').hasMatch(password)) strength += 0.25;

    // Add strength for special characters
    if (RegExp(r'[^A-Za-z0-9]').hasMatch(password)) strength += 0.25;

    return strength;
  }
  bool _passwordVisible = false;  // Add this line
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _passwordVisible = false;  // Initialize _passwordVisible here
  }
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            Text(
              'Bienvenue !',
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Color(0xff7b3910)), // Red color
            ),
            Text(
              'Enregistre toi dès maintenant par ici ',
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 15, color: Colors.black),
            ),
            SizedBox(height: 15),
            TextField(
              decoration: InputDecoration(
                labelText: 'Nom',
                labelStyle: TextStyle(color: Colors.black), // Custom label style
                hintText: 'DUPONT',
                hintStyle: TextStyle(color: Colors.grey), // Custom hint text style
                enabledBorder: OutlineInputBorder( // Border when TextField is not in focus
                  borderSide: BorderSide(color: Color(0xff7b3910), width: 2.0),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                focusedBorder: OutlineInputBorder( // Border when TextField is in focus
                  borderSide: BorderSide(color: Colors.green, width: 2.0),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                fillColor: Colors.white, // Background color of the TextField
                filled: true, // Don't forget to set filled to true when using fillColor
              ),
              cursorColor: Colors.orange, // Custom cursor color
              style: TextStyle(color: Colors.black), // Style for the input text
            ),
            SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                labelText: 'Prénom',
                labelStyle: TextStyle(color: Colors.black), // Custom label style
                hintText: 'Jean',
                hintStyle: TextStyle(color: Colors.grey), // Custom hint text style
                enabledBorder: OutlineInputBorder( // Border when TextField is not in focus
                  borderSide: BorderSide(color: Color(0xff7b3910), width: 2.0),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                focusedBorder: OutlineInputBorder( // Border when TextField is in focus
                  borderSide: BorderSide(color: Colors.green, width: 2.0),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                fillColor: Colors.white, // Background color of the TextField
                filled: true, // Don't forget to set filled to true when using fillColor
              ),
              cursorColor: Colors.orange, // Custom cursor color
              style: TextStyle(color: Colors.black), // Style for the input text
            ),
            SizedBox(height: 10),
            TextField(
              keyboardType: TextInputType.number,
              inputFormatters: [DateInputFormatter()],
              decoration: InputDecoration(
                labelText: 'Date de naissance',
                labelStyle: TextStyle(color: Colors.black, fontSize: 16), // Custom label style
                hintText: 'YYYY/MM/DD',
                hintStyle: TextStyle(color: Colors.grey), // Custom hint text style
                filled: false,
                prefixIcon: Icon(Icons.calendar_today), // Custom icon color
                enabledBorder: OutlineInputBorder( // Border when TextField is not in focus
                  borderSide: BorderSide(color: Color(0xff7b3910), width: 2.0),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                focusedBorder: OutlineInputBorder( // Border when TextField is in focus
                  borderSide: BorderSide(color: Colors.green, width: 2.0),
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),

            SizedBox(height: 10),

            DropdownButtonFormField(
              value: _selectedType,
              hint: Text(
                'Type',
                style: TextStyle(color: Colors.grey), // Styling for hint text
              ),
              items: _typeOptions.map((String type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(type),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedType = newValue;
                });
              },
              decoration: InputDecoration(
                labelText: 'Statut',
                labelStyle: TextStyle(color: Colors.black, fontSize: 16), // Custom label style
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xff7b3910), width: 2.0), // Custom border style
                  borderRadius: BorderRadius.circular(8.0), // Border radius
                ),
                enabledBorder: OutlineInputBorder( // Border when Dropdown is not in focus
                  borderSide: BorderSide(color: Color(0xff7b3910), width: 2.0),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                focusedBorder: OutlineInputBorder( // Border when Dropdown is in focus
                  borderSide: BorderSide(color: Colors.green, width: 2.0),
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),

            SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                labelText: 'Email',
                labelStyle: TextStyle(color: Colors.black), // Custom label style
                hintText: 'email@example.com',
                hintStyle: TextStyle(color: Colors.grey), // Custom hint text style
                enabledBorder: OutlineInputBorder( // Border when TextField is not in focus
                  borderSide: BorderSide(color: Color(0xff7b3910), width: 2.0),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                focusedBorder: OutlineInputBorder( // Border when TextField is in focus
                  borderSide: BorderSide(color: Colors.green, width: 2.0),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                fillColor: Colors.white, // Background color of the TextField
                filled: true, // Don't forget to set filled to true when using fillColor
              ),
              cursorColor: Colors.orange, // Custom cursor color
              style: TextStyle(color: Colors.black), // Style for the input text
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 10),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                labelStyle: TextStyle(color: Colors.black, fontSize: 16), // Custom label style
                hintText: 'Mot de passe',
                hintStyle: TextStyle(color: Colors.grey), // Style for the hint text
                filled: true,
                fillColor: Colors.white10, // Background color of the TextField
                border: OutlineInputBorder( // Border of the TextField
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none, // No border
                ),
                enabledBorder: OutlineInputBorder( // Border when TextField is not in focus
                  borderSide: BorderSide(color: Color(0xff7b3910), width: 2.0),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                focusedBorder: OutlineInputBorder( // Border when TextField is in focus
                  borderSide: BorderSide(color: Colors.green, width: 2.0),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                prefixIcon: Icon(Icons.lock, color: Colors.grey), // Prefix icon
                suffixIcon: IconButton( // Suffix icon
                  icon: Icon(
                    // Toggles the password visibility icon
                    _passwordVisible ? Icons.visibility : Icons.visibility_off,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    // Toggle the password visibility state
                    setState(() {
                      _passwordVisible = !_passwordVisible;
                    });
                  },
                ),
              ),
              obscureText: !_passwordVisible, // Controls the visibility of the password
              onChanged: (password) => setState(() {}),
            ),
            SizedBox(height: 5),
            LinearProgressIndicator(
              value: _calculatePasswordStrength(_passwordController.text),
              backgroundColor: Color(0xff7b3910),
              valueColor: AlwaysStoppedAnimation<Color>(
                _calculatePasswordStrength(_passwordController.text) > 0.7 ? Colors.green : Colors.red,
              ),
            ),
            SizedBox(height: 10),
            InternationalPhoneNumberInput(
              onInputChanged: (PhoneNumber number) {
                print(number.phoneNumber);
              },
              selectorConfig: SelectorConfig(
                selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
              ),
              ignoreBlank: false,
              autoValidateMode: AutovalidateMode.disabled,
              selectorTextStyle: TextStyle(color: Colors.black),
              initialValue: PhoneNumber(isoCode: 'FR'),
              textFieldController: _phoneController, // Initialize this controller in your state class
              formatInput: false,
              keyboardType: TextInputType.numberWithOptions(signed: true, decimal: true),
              inputDecoration: InputDecoration(
                labelText: 'Numéro de télephone',
                hintText: 'Quel est ton numéro ?',
                enabledBorder: OutlineInputBorder( // Border when TextField is not in focus
                  borderSide: BorderSide(color: Color(0xff7b3910), width: 2.0),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                focusedBorder: OutlineInputBorder( // Border when TextField is in focus
                  borderSide: BorderSide(color: Colors.green, width: 2.0),
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              textStyle: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
              spaceBetweenSelectorAndTextField: 5,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Handle signup logic here
              },
              child: Text(
                'Sign up',
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                primary: Color(0xff7b3910), // Red background color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30), // Rounded corners
                ),
                padding: EdgeInsets.symmetric(horizontal: 100, vertical: 5), // Same padding as 'Commencer' button
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Or sign up with',
              textAlign: TextAlign.center,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  icon: Icon(FontAwesomeIcons.facebook),
                  color: Color(0xff7b3910),
                  onPressed: () {
                    // Implement Facebook Signup Logic
                  },
                ),
                IconButton(
                  icon: Icon(FontAwesomeIcons.apple),
                  color: Color(0xff7b3910),
                  onPressed: () {
                    // Implement Apple Signup Logic
                  },
                ),
                IconButton(
                  icon: Icon(FontAwesomeIcons.google),
                  color: Color(0xff7b3910),
                  onPressed: () {
                    // Implement Google Signup Logic
                  },
                ),
                IconButton(
                  icon: Icon(FontAwesomeIcons.phone),
                  color: Color(0xff7b3910),
                  onPressed: () {
                    // Implement Google Signup Logic
                  },

                ),

              ],

            ),
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("Already have an account? "),
                TextButton(
                  child: Text(
                    "Sign in",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xff7b3910),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => ThirdPage()),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ThirdPageState extends State<ThirdPage> {
  final TextEditingController _passwordController = TextEditingController();
  bool _passwordVisible = false;  // Add this line
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _passwordVisible = false;  // Initialize _passwordVisible here
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            SizedBox(height: 20),
            Text(
              'Sign In',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 30),
            TextField(
              decoration: InputDecoration(
                labelText: 'Email',
                labelStyle: TextStyle(color: Colors.black), // Custom label style
                hintText: 'email@example.com',
                hintStyle: TextStyle(color: Colors.grey), // Custom hint text style
                enabledBorder: OutlineInputBorder( // Border when TextField is not in focus
                  borderSide: BorderSide(color: Color(0xff7b3910), width: 2.0),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                focusedBorder: OutlineInputBorder( // Border when TextField is in focus
                  borderSide: BorderSide(color: Colors.green, width: 2.0),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                fillColor: Colors.white, // Background color of the TextField
                filled: true, // Don't forget to set filled to true when using fillColor
              ),
              cursorColor: Colors.orange, // Custom cursor color
              style: TextStyle(color: Colors.black), // Style for the input text
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 10),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                labelStyle: TextStyle(color: Colors.black, fontSize: 16), // Custom label style
                hintText: 'Mot de passe',
                hintStyle: TextStyle(color: Colors.grey), // Style for the hint text
                filled: true,
                fillColor: Colors.white10, // Background color of the TextField
                border: OutlineInputBorder( // Border of the TextField
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none, // No border
                ),
                enabledBorder: OutlineInputBorder( // Border when TextField is not in focus
                  borderSide: BorderSide(color: Color(0xff7b3910), width: 2.0),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                focusedBorder: OutlineInputBorder( // Border when TextField is in focus
                  borderSide: BorderSide(color: Colors.green, width: 2.0),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                prefixIcon: Icon(Icons.lock, color: Colors.grey), // Prefix icon
                suffixIcon: IconButton( // Suffix icon
                  icon: Icon(
                    // Toggles the password visibility icon
                    _passwordVisible ? Icons.visibility : Icons.visibility_off,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    // Toggle the password visibility state
                    setState(() {
                      _passwordVisible = !_passwordVisible;
                    });
                  },
                ),
              ),
              keyboardType: TextInputType.emailAddress,
              obscureText: !_passwordVisible, // Controls the visibility of the password
              onChanged: (password) => setState(() {}),
            ),

            SizedBox(height: 10),
            TextButton(
              onPressed: () {
                // Navigate to password recovery page or handle logic
              },
              child: Text(
                'Password Forgotten?',
                style: TextStyle(
                  color: Color(0xff7b3910),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                setState(() {
                  _isLoading = true; // Start the loading process
                });

                // Simulate a network request or long-running task
                await Future.delayed(Duration(seconds: 1));

                setState(() {
                  _isLoading = false; // Stop the loading process
                });

                // Navigate to the FourthPage after the "login" process
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FourthPage()),
                );
              },
              child: _isLoading
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text('Login', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                primary: Color(0xff7b3910),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: EdgeInsets.symmetric(horizontal: 100, vertical: 15),
              ),
            ),
            // You can add more widgets here as needed
            SizedBox(height: 30),
            Text(
              'Or sign up with',
              textAlign: TextAlign.center,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  icon: Icon(FontAwesomeIcons.facebook),
                  color: Color(0xff7b3910),
                  onPressed: () {
                    // Implement Facebook Signup Logic
                  },
                ),
                IconButton(
                  icon: Icon(FontAwesomeIcons.apple),
                  color: Color(0xff7b3910),
                  onPressed: () {
                    // Implement Apple Signup Logic
                  },
                ),
                IconButton(
                  icon: Icon(FontAwesomeIcons.google),
                  color: Color(0xff7b3910),
                  onPressed: () {
                    // Implement Google Signup Logic
                  },
                ),
                IconButton(
                  icon: Icon(FontAwesomeIcons.phone),
                  color: Color(0xff7b3910),
                  onPressed: () {
                    // Implement Google Signup Logic
                  },

                ),

              ],

            ),
          ],
        ),
      ),
    );
  }
}

class FourthPage extends StatefulWidget {
  @override
  _FourthPageState createState() => _FourthPageState();
}

class _FourthPageState extends State<FourthPage> {
  int _selectedIndex = 0; // To track the selected index

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          title: Text('Home'),
          // Only show the TabBar in the AppBar when Home (index 0) is selected
          bottom: _selectedIndex == 0 ? TabBar(
            tabs: [
              Tab(text: 'Professionnels'),
              Tab(text: 'Particuliers'),
            ],
            indicatorColor: Color(0xff7b3910), // Color of the indicator line
            indicatorWeight: 3.0, // Thickness of the indicator line
            labelColor: Color(0xff7b3910), // Color of the label when selected
            unselectedLabelColor: Colors.grey, // Color of the label when not selected
            labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold), // Style of the label
            unselectedLabelStyle: TextStyle(fontSize: 14), // Style of the label when not selected
          ) : null,
        ),
        body: _selectedIndex == 0
            ? TabBarView(
          children: [
            ProfessionnelsTab(), // Tab content for Professionnels
            ParticuliersTab(),   // Tab content for Particuliers
          ],
        )
            : _getTabContent(_selectedIndex),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
            BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Map'),
            BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),

          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Color(0xff7b3910), // Color of the selected item
          unselectedItemColor: Colors.grey, // Color of the unselected items
          backgroundColor: Colors.white, // Background color of the BottomNavigationBar
          type: BottomNavigationBarType.fixed, // Type of BottomNavigationBar
          showUnselectedLabels: true, // Whether to show labels of unselected items
          selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold), // Style of the selected label
          unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal), // Style of the unselected label
          onTap: _onItemTapped,
        ),
      ),
    );
  }

  Widget _getTabContent(int index) {
    // Placeholder widgets for each tab
    switch (index) {
      case 1:
        return Center(child: Text('History Content'));
      case 2:
        return Center(child: Text('Map Content'));  // This is your Map tab
      case 3:
        return Center(child: Text('Settings Content'));
      default:
        return Container();
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}


class ProfessionnelsTab extends StatefulWidget {
  @override
  _ProfessionnelsTabState createState() => _ProfessionnelsTabState();
}

class _ProfessionnelsTabState extends State<ProfessionnelsTab> with AutomaticKeepAliveClientMixin {
  List<Map<String, dynamic>> items = [
    {
      'companyName': 'Starbucks',
      'description': 'Enjoy your coffee at Starbucks Paris',
      'bannerImageUrl': 'assets/banner.jpg',
      'profileImageUrl': 'assets/profile.png',
      'averageRating': 4.5,
      'totalReviews': 120,
      'pricePerKg': 3.0,
      'departureDate': '2024-02-23',
      'distance': '5 km',
    },
    // Add more initial items here if needed
  ];

  void _addItem(Map<String, dynamic> newItem) {
    setState(() {
      items.add(newItem);
    });
  }

  void _showAddItemForm() {
    final _formKey = GlobalKey<FormState>();
    // Create controllers for text fields
    final companyNameController = TextEditingController();
    final descriptionController = TextEditingController();
    final bannerImageUrlController = TextEditingController();
    final profileImageUrlController = TextEditingController();
    final averageRatingController = TextEditingController();
    final totalReviewsController = TextEditingController();
    final pricePerKgController = TextEditingController();
    final departureDateController = TextEditingController();
    final distanceController = TextEditingController();

    // Show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Ajouter un nouveau livreur '),
          content: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  // Style TextFormFields
                  TextFormField(
                    controller: companyNameController,
                    decoration: InputDecoration(labelText: 'Company Name'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a company name';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: descriptionController,
                    decoration: InputDecoration(labelText: 'Description'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a description';
                      } else if (value.length > 30) {
                        return 'Description should be less than 30 characters';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: pricePerKgController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: 'Price per Kg'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a valid price';
                      } else if (double.tryParse(value) == null) {
                        return 'Please enter a valid number';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: departureDateController,
                    keyboardType: TextInputType.datetime,
                    decoration: InputDecoration(labelText: 'Date de départ (yyyy/mm/dd)'),
                    validator: (value) {
                      RegExp datePattern = RegExp(r"^\d{4}/\d{2}/\d{2}$");
                      if (value == null || value.isEmpty) {
                        return 'Please enter a valid date';
                      } else if (!datePattern.hasMatch(value)) {
                        return 'Invalid date format. Use yyyy/mm/dd';
                      }
                      return null;
                    },
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // Call _addItem to add the item to the list
                        _addItem({
                          'companyName': companyNameController.text,
                          'description': descriptionController.text,
                          'bannerImageUrl': "assets/banner.jpg",
                          'profileImageUrl': "assets/profile.png",
                          'averageRating': 5,
                          'totalReviews': 76,
                          'pricePerKg': double.parse(pricePerKgController.text),
                          'departureDate': departureDateController.text,
                          'distance': 5,
                        });

                        // Clear the text fields
                        companyNameController.clear();
                        descriptionController.clear();
                        bannerImageUrlController.clear();
                        profileImageUrlController.clear();
                        averageRatingController.clear();
                        totalReviewsController.clear();
                        pricePerKgController.clear();
                        departureDateController.clear();
                        distanceController.clear();

                        // Close the dialog
                        Navigator.of(context).pop();
                      }
                    },
                    child: Text('Ajouter'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog without adding anything
                    },
                    child: Text('Annuler'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
  @override
  bool get wantKeepAlive => true; // Add this line

  Widget build(BuildContext context) {
    super.build(context); // Add this line
    return Scaffold(
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          var item = items[index];
          return _buildListItem(
            context,
            item['companyName'],
            item['description'],
            item['bannerImageUrl'],
            item['profileImageUrl'],
           4.5,
            10,
            item['pricePerKg'],
            item['departureDate'],
            "10.0",
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddItemForm,
        child: Icon(Icons.add),
        backgroundColor: Color(0xff7b3910),  // Background color of the button
        foregroundColor: Colors.white,       // Color of the icon and text (if any)
        elevation: 5.0,                      // Shadow elevation
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16.0)), // Rounded shape
        ),
      ),

    );
  }

  Widget _buildListItem(
      BuildContext context,
      String companyName,
      String description,
      String bannerImageUrl,
      String profileImageUrl,
      double averageRating,
      int totalReviews,
      double pricePerKg,
      String departureDate,
      String distance) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.all(8),
      child: Column(
        children: [
          Image.asset(bannerImageUrl, fit: BoxFit.cover), // Banner Image
          ListTile(
            leading: CircleAvatar(
              backgroundImage: AssetImage(profileImageUrl), // Profile Image
            ),
            title: Text(companyName, style: TextStyle(fontWeight: FontWeight.bold)), // Business Name
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("$description"), // Description
                Text("Collect before: $departureDate"), // Description
                Row(
                  children: [
                    Icon(Icons.star, color: Color(0xff7b3910),), // Star Icon
                    SizedBox(width: 4),
                    Text("$averageRating (${totalReviews.toString()}) | $distance away"),
                    Text("\t\t\t \$${pricePerKg.toStringAsFixed(2)}/kg",
                        style: TextStyle(
                          color: Color(0xff7b3910),
                          fontWeight: FontWeight.bold,
                          fontSize: 16,)),
                  ],
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }
}

  void _makePhoneCall(Uri uri) async {
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $uri';
    }
  }
  void _openMap(double latitude, double longitude) async {
    var googleMapsUrl = "google.navigation:q=$latitude,$longitude&mode=d";
    var googleMapsFallbackUrl = "https://www.google.com/maps/dir/?api=1&destination=$latitude,$longitude";

    Uri googleMapsUri = Uri.parse(googleMapsUrl);
    Uri googleMapsFallbackUri = Uri.parse(googleMapsFallbackUrl);

    if (await canLaunchUrl(googleMapsUri)) {
      // Attempt to open Google Maps App
      await launchUrl(googleMapsUri);
    } else if (await canLaunchUrl(googleMapsFallbackUri)) {
      // If Google Maps App isn't installed, open in the browser
      await launchUrl(googleMapsFallbackUri);
    } else {
      throw 'Could not launch the map';
    }
  }

  Widget customListTilePro(BuildContext context, {
    required String companyName,
    required String shipperName,
    required String departureDay,
    required String departureLocation, // New parameter
    required String arrivalLocation,   // New parameter
    required String minWeight,
    required String maxWeight,
    required double priceKg,
    required String imageUrl,
    required double averageRating,
    required int totalReviews,
    required VoidCallback onCallPressed,
    required VoidCallback onMapPressed,

  }) {
    return ListTile(
      leading: Image.asset(imageUrl, width: 50, height: 50),
      title: Text(companyName),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Shipper: $shipperName'),
          Text('Departure: $departureDay'),
          Text('Direction: $departureLocation -> $arrivalLocation'), // Added route info
          Text('Weight Range: $minWeight - $maxWeight kg'),
          Text('Price per Kg: $priceKg euros'),
          Row(
            children: <Widget>[
              Icon(Icons.star, color: Colors.amber),
              Text('$averageRating ($totalReviews)'),
              IconButton(
                icon: Icon(Icons.phone),
                onPressed: onCallPressed,
              ),
              IconButton(
                icon: Icon(Icons.map),
                onPressed: onMapPressed,
              ),
            ],
          ),
        ],
      ),
      onTap: () {
        // Handle the tile tap if needed
      },
    );
  }


class ParticuliersTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        customListTilePar(
          context,
          title: 'Package A',
          description: 'Description of Package A.',
          imageUrl: 'assets/avion.png', // replace with your image asset
          name: 'John Doe',
          departureAirport: 'Airport A',
          arrivalAirport: 'Airport B',
          departureDate: '2023-12-01',
          maxWeight: '20 kg',
          dimensions: '10 x 5 x 8',
          price: 50,
          averageRating : 5,
          totalReviews : 10,
          rating: 4.5,
          onCallPressed: () {
            // Handle phone call logic
          },
          onMapPressed: () {
            // Handle location viewing logic
          },
        ),
        customListTilePar(
          context,
          title: 'Package B',
          description: 'Description of Package B.',
          imageUrl: 'assets/avion.png', // replace with your image asset
          name: 'Jane Doe',
          departureAirport: 'Airport C',
          arrivalAirport: 'Airport D',
          departureDate: '2023-12-15',
          maxWeight: '15 kg',
          dimensions: '8 x 4 x 6',
          price: 40,
          averageRating : 5,
          totalReviews : 10,
          rating: 4.0,
          onCallPressed: () {
            // Handle phone call logic
          },
          onMapPressed: () {
            // Handle location viewing logic
          },
        ),
        // Add more customListTilePar widgets as needed
      ],
    );
  }

  Widget customListTilePar(
      BuildContext context, {
        required String title,
        required String description,
        required String imageUrl,
        required String name,
        required String departureAirport,
        required String arrivalAirport,
        required String departureDate,
        required String maxWeight,
        required String dimensions,
        required double price,
        required VoidCallback onCallPressed,
        required VoidCallback onMapPressed,
        required double rating,
        required double averageRating,
        required int totalReviews,
      }) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.all(8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: AssetImage(imageUrl),
        ),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Description: $description'),
            Text('Name: $name'),
            Text('Departure Airport: $departureAirport'),
            Text('Arrival Airport: $arrivalAirport'),
            Text('Departure Date: $departureDate'),
            Text('Max Weight: $maxWeight'),
            Text('Dimensions: $dimensions'),
            Text('Price: $price euros'),
            Row(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Icon(Icons.star, color: Colors.amber),
                    Text('$averageRating ($totalReviews)'),
                  ],
                ),
                Row(
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.phone),
                      onPressed: onCallPressed,
                    ),
                    IconButton(
                      icon: Icon(Icons.map),
                      onPressed: onMapPressed,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}