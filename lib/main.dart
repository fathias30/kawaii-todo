import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'list_view.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: WelcomePage(),
    );
  }
}

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 199, 219, 230),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 180),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(
              'images/kawaii_logo.jpg',
              width: 300,
            ),
            const SizedBox(height: 20),
            Text(
              'Selamat datang!',
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.bold,
                fontSize: 32,
                color: const Color.fromARGB(255, 81, 48, 55),
              ),
            ),
            const SizedBox(height: 40),
            Text(
              'Siapa nama kamu?',
              style: GoogleFonts.montserrat(
                fontSize: 17,
                color: const Color.fromARGB(255, 81, 48, 55),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50.0),
              child: TextField(
                controller: _nameController,
                style: GoogleFonts.montserrat(
                  color: const Color.fromARGB(255, 81, 48, 55),
                  fontSize: 14,
                ),
                cursorColor: const Color.fromARGB(150, 81, 48, 55),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'Masukkan nama kamu',
                  hintStyle: GoogleFonts.montserrat(
                    fontSize: 14,
                    color: const Color.fromARGB(150, 81, 48, 55),
                    fontWeight: FontWeight.w400,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: const BorderSide(
                      color: Color.fromARGB(255, 81, 48, 55),
                      width: 2.0,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: const BorderSide(
                      color: Color.fromARGB(150, 81, 48, 55),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 50),
            ElevatedButton.icon(
              icon: const Icon(Icons.rocket_launch, color: Colors.white),
              onPressed: () {
                final name = _nameController.text.trim();
                if (name.isNotEmpty) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ListViewPage(name: name),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 30.0,
                  vertical: 10.0,
                ),
                backgroundColor: const Color.fromARGB(255, 226, 150, 169),
                foregroundColor: Colors.white,
              ),
              label: Text(
                'Mulai',
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
