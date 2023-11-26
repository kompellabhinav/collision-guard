import 'package:collision_detection/pages/home.dart';
import 'package:collision_detection/pages/settings.dart';
import 'package:flutter/material.dart';

class TabsController extends StatefulWidget {
  const TabsController({super.key});

  @override
  State<TabsController> createState() => _TabsControllerState();
}

class _TabsControllerState extends State<TabsController> {
  var _selectedIndex = 0;

  final List _pages = [
    Home(),
    Settings(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            title: Text(_pages[_selectedIndex].title),
            backgroundColor: Colors.black,
            centerTitle: true,
          ),
          body: _pages[_selectedIndex],
          backgroundColor: Colors.black,
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: Colors.black,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.paid),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.add),
                label: 'Settings',
              ),
            ],
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            type: BottomNavigationBarType.fixed,
          ),
        ));
  }
}
