import 'package:flutter/material.dart';

class MainScreenPage extends StatefulWidget {
  const MainScreenPage({Key? key}) : super(key: key);

  @override
  State<MainScreenPage> createState() => _MainScreenPageState();
}

class _MainScreenPageState extends State<MainScreenPage> {
  int _selectecitem = 0;

  final List _screen = const [
    Center(
      child: Text('Note'),
    ),
    Center(
      child: Text('Calendar'),
    ),
    Center(
      child: Text('Collection'),
    ),
    Center(
      child: Text('Profile'),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screen[_selectecitem],
      bottomNavigationBar: BottomNavigationBar(
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
        selectedItemColor: Colors.lightBlue,
        unselectedItemColor: Colors.black,
        currentIndex: _selectecitem,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.note_alt_outlined),
            label: 'Note',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month_outlined),
            label: 'Calendar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.collections),
            label: 'Collection',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        onTap: (index) {
          setState(() {
            _selectecitem = index;
          });
        },
      ),
    );
  }
}
