import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MainMenu extends StatefulWidget {
  const MainMenu({super.key});

  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  final GlobalKey _activeOrdersKey = GlobalKey();
  final GlobalKey _completedOrdersKey = GlobalKey();

  int index = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: <Widget>[
        Scaffold(
          appBar: AppBar(
            title: const Text('Home'),
          ),
          body: const Center(
            child: Text('Home'),
          ),
        ),
        DefaultTabController(
          key: _activeOrdersKey,
          length: 6,
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Active Orders'),
              bottom: const TabBar(
                tabs: [
                  Tab(text: 'Preparing'),
                  Tab(text: 'Ready for Pickup'),
                  Tab(text: 'Ready for Delivery'),
                  Tab(text: 'Out for Delivery'),
                  Tab(text: 'Scheduled'),
                  Tab(text: 'Pending'),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                Center(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Flexible(
                        flex: 75,
                        child: SingleChildScrollView(
                          child: Column(
                            children: List.generate(3 * 2 - 1, (index) {
                              if (index % 2 == 0) {
                                return InkWell(
                                  onTap: () {
                                    debugPrint('clicked');
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 8,
                                      horizontal: 16,
                                    ),
                                    width: double.infinity,
                                    child: Row(
                                      children: <Widget>[
                                         const Flexible(
                                          flex: 65,
                                          child: Column(
                                            children: <Widget>[
                                              Row(
                                                mainAxisSize: MainAxisSize.max,
                                                children: <Widget>[
                                                  Flexible(
                                                    child: SizedBox(
                                                      width: double.infinity,
                                                      child: AutoSizeText(
                                                        '# ${'Order ID Here'}',
                                                        maxLines: 1,
                                                        overflow:
                                                        TextOverflow.ellipsis,
                                                      ),
                                                    ),
                                                  ),
                                                  Flexible(
                                                    child: SizedBox(
                                                      width: double.infinity,
                                                      child: AutoSizeText(
                                                        'Total: ${'Total Here'}',
                                                        maxLines: 1,
                                                        overflow:
                                                        TextOverflow.ellipsis,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: <Widget>[
                                                  Flexible(
                                                    child: SizedBox(
                                                      width: double.infinity,
                                                      child: AutoSizeText(
                                                        'Customer: ${'Name'}',
                                                        maxLines: 1,
                                                        overflow:
                                                        TextOverflow.ellipsis,
                                                      ),
                                                    ),
                                                  ),
                                                  Flexible(
                                                    child: SizedBox(
                                                      width: double.infinity,
                                                      child: AutoSizeText(
                                                        '${'Phone'}',
                                                        maxLines: 1,
                                                        overflow:
                                                        TextOverflow.ellipsis,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: <Widget>[
                                                  Flexible(
                                                    child: SizedBox(
                                                      width: double.infinity,
                                                      child: AutoSizeText(
                                                        'Order Type: ${'Order Type'}',
                                                        maxLines: 1,
                                                        overflow:
                                                        TextOverflow.ellipsis,
                                                      ),
                                                    ),
                                                  ),
                                                  Flexible(
                                                    child: SizedBox(
                                                      width: double.infinity,
                                                      child: AutoSizeText(
                                                        'Type Data: ${'Type Data Here'}',
                                                        maxLines: 1,
                                                        overflow:
                                                        TextOverflow.ellipsis,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        Flexible(
                                          flex: 35,
                                          child: Row(
                                            children: <Widget>[
                                              Expanded(
                                                flex: 20,
                                                child: ElevatedButton(
                                                  onPressed: () {},
                                                  style: ButtonStyle(
                                                    padding:
                                                        MaterialStateProperty
                                                            .all(
                                                      const EdgeInsets
                                                          .symmetric(
                                                        vertical: 12,
                                                        horizontal: 8,
                                                      ),
                                                    ),
                                                    shape: MaterialStateProperty
                                                        .all<
                                                            RoundedRectangleBorder>(
                                                      RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(4),
                                                      ),
                                                    ),
                                                  ),
                                                  child: AutoSizeText(
                                                    'Pay',
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ),
                                              const Spacer(flex: 3),
                                              Expanded(
                                                flex: 30,
                                                child: ElevatedButton(
                                                  onPressed: () {},
                                                  style: ButtonStyle(
                                                    padding:
                                                        MaterialStateProperty
                                                            .all(
                                                      const EdgeInsets
                                                          .symmetric(
                                                        vertical: 12,
                                                        horizontal: 8,
                                                      ),
                                                    ),
                                                    shape: MaterialStateProperty
                                                        .all<
                                                            RoundedRectangleBorder>(
                                                      RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(4),
                                                      ),
                                                    ),
                                                  ),
                                                  child: AutoSizeText(
                                                    'Next Step',
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ),
                                              const Spacer(flex: 1),
                                              IconButton(
                                                onPressed: () {},
                                                icon: Icon(Icons.more_vert),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              } else {
                                return const Divider(
                                  height: 0,
                                  indent: 20,
                                  endIndent: 20,
                                );
                              }
                            }),
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 25,
                        child: Container(
                          color: Colors.red,
                          child: Center(
                            child: Text('Filters'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Center(
                  child: Text('Ready for Pickup'),
                ),
                Center(
                  child: Text('Ready for Delivery'),
                ),
                Center(
                  child: Text('Out for Delivery'),
                ),
                Center(
                  child: Text('Scheduled'),
                ),
                Center(
                  child: Text('Pending'),
                ),
              ],
            ),
          ),
        ),
        DefaultTabController(
          key: _completedOrdersKey,
          length: 4,
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Orders History'),
              bottom: const TabBar(
                tabs: [
                  Tab(
                    text: 'Received',
                  ),
                  Tab(
                    text: 'Delivered',
                  ),
                  Tab(
                    text: 'Cancelled',
                  ),
                  Tab(
                    text: 'All',
                  ),
                ],
              ),
            ),
            body: const TabBarView(
              children: [
                Center(
                  child: Text(
                    'Received',
                  ),
                ),
                Center(
                  child: Text(
                    'Delivered',
                  ),
                ),
                Center(
                  child: Text(
                    'Cancelled',
                  ),
                ),
                Center(
                  child: Text(
                    'All',
                  ),
                ),
              ],
            ),
          ),
        ),
        Scaffold(
          appBar: AppBar(
            title: const Text('Settings'),
          ),
          body: const Center(
            child: Text('Settings'),
          ),
        ),
      ][index],
      bottomNavigationBar: BottomNavigationBar(
        useLegacyColorScheme: false,
        type: BottomNavigationBarType.shifting,
        //showUnselectedLabels: true,
        currentIndex: index,
        onTap: (i) {
          setState(() {
            index = i;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.alarm),
            label: 'Active Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
