import 'package:flutter/material.dart';

class MainMenu extends StatelessWidget {
  const MainMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            tabs: [
              Tab(text: 'tab1',),
              Tab(text: 'tab2',),
              Tab(text: 'tab3',),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Text('tab1',),
            Text('tab2',),
            Text('tab3',),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'home'),
            BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'settings'),
          ],
        ),
      ),
    );
  }
}
