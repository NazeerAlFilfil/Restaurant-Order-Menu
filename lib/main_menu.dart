import 'package:flutter/material.dart';
import 'package:restaurant_order_menu/components/divided_scroll_list.dart';
import 'package:restaurant_order_menu/components/order_card.dart';
import 'package:restaurant_order_menu/order_menu.dart';

import 'dummy_data.dart';
import 'models/order_model.dart';
import 'models/order_type.dart';

class MainMenu extends StatefulWidget {
  const MainMenu({super.key});

  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  // List of all orders
  List<Order> orders = [];

  // Active Orders
  List<OrderCard> preparingOrders = []; // For all orders
  List<OrderCard> readyForPickupOrders =
      []; // For takeaway orders (and app orders)
  List<OrderCard> scheduledOrders = []; // For scheduled orders
  List<OrderCard> pendingOrders = []; // For not accepted app orders

  // Local Orders
  List<OrderCard> readyToServeOrders = []; // For ready local orders
  List<OrderCard> servedOrders = []; // For already served local orders

  // Delivery Orders
  List<OrderCard> readyForDeliveryOrders = []; // For ready delivery orders (to be picked by the driver)
  List<OrderCard> outForDeliveryOrders = []; // Out for delivery orders

  // History Orders
  List<OrderCard> receivedOrders = []; // For takeaway received orders
  List<OrderCard> completeOrders = []; // For complete local orders
  List<OrderCard> deliveredOrders = []; // For delivered orders
  List<OrderCard> deletedOrders = []; // For deleted & not paid orders
  List<OrderCard> cancelledOrders = []; // For cancelled orders
  List<OrderCard> allOrders = []; // For all complete orders

  late Order dummyOrder;

  // Use these, otherwise it crashes
  final GlobalKey _activeOrdersKey = GlobalKey();
  final GlobalKey _completedOrdersKey = GlobalKey();

  int index = 1;

  @override
  void initState() {
    super.initState();

    dummyOrder = order();
    dummyOrder.orderInformation.orderType = OrderType(type: 'Local');
    dummyOrder.orderInformation.paymentStatus = 'paid';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => _newOrder(),
        tooltip: 'Add New Order',
        child: const Text('+'),
      ),
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
          length: 7,
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Active Orders'),
              bottom: const TabBar(
                tabs: [
                  Tab(text: 'Preparing'),
                  Tab(text: 'Ready for Pickup'),
                  Tab(text: 'Ready to Serve'),
                  Tab(text: 'Served'),
                  Tab(text: 'Ready for Delivery'),
                  Tab(text: 'Out for Delivery'),
                  Tab(text: 'Scheduled'),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                DividedScrollList(
                  children: preparingOrders,
                ),
                DividedScrollList(
                  children: readyForPickupOrders,
                ),
                DividedScrollList(
                  children: readyToServeOrders,
                ),
                DividedScrollList(
                  children: servedOrders,
                ),
                DividedScrollList(
                  children: readyForDeliveryOrders,
                ),
                DividedScrollList(
                  children: outForDeliveryOrders,
                ),
                DividedScrollList(
                  children: scheduledOrders,
                ),
              ],
            ),
          ),
        ),
        DefaultTabController(
          key: _completedOrdersKey,
          length: 6,
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Orders History'),
              bottom: const TabBar(
                tabs: [
                  Tab(text: 'Received'),
                  Tab(text: 'Complete'),
                  Tab(text: 'Delivered'),
                  Tab(text: 'Deleted'),
                  Tab(text: 'Cancelled'),
                  Tab(text: 'All'),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                DividedScrollList(
                  children: receivedOrders,
                ),
                DividedScrollList(
                  children: completeOrders,
                ),
                DividedScrollList(
                  children: deliveredOrders,
                ),
                DividedScrollList(
                  children: deletedOrders,
                ),
                DividedScrollList(
                  children: cancelledOrders,
                ),
                DividedScrollList(
                  children: allOrders,
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

  Future<void> _newOrder() async {
    Order newOrder = order();

    bool? addNewOrder = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OrderMenu(
          categories: categories(),
          orderTypes: orderTypes(),
          customers: customers,
          order: newOrder,
        ),
      ),
    );

    if (!mounted) return;

    if (addNewOrder ?? false) {
      OrderCard newOrderCard = OrderCard(
        order: newOrder,
        onNextStep: _onNextStep,
        onPreviousStep: _onPreviousStep,
        onReplacement: _onReplacement,
        onCancelOrder: _onCancelOrder,
      );

      setState(() {
        orders.add(newOrder);
        if (newOrder.orderInformation.orderStatus?.toLowerCase() != 'scheduled') {
          preparingOrders.add(newOrderCard);
        } else {
          scheduledOrders.add(newOrderCard);
        }
      });
    }
  }

  // TODO: Make orders unable to complete (other than cancel / delete) UNLESS they are paid
  void _onNextStep(OrderCard instance) {
    _addToLists(instance, true);
    _removeFromLists(instance, true);
    _updateStatus(instance, true);

    setState(() {});
  }

  void _onPreviousStep(OrderCard instance) {
    _addToLists(instance, false);
    _removeFromLists(instance, false);
    _updateStatus(instance, false);

    setState(() {});
  }

  void _onReplacement(OrderCard instance) {
    String? orderType = instance.order.orderInformation.orderType?.type;
    orderType = orderType?.toLowerCase();

    String? orderStatus = instance.order.orderInformation.orderStatus;
    orderStatus = orderStatus?.toLowerCase();

    // Preparing
    if (orderStatus == 'preparing') {
      if (orderType == 'local') {
        // Nothing
      } else if (orderType == 'takeaway') {
        // Nothing
      } else if (orderType == 'delivery') {
        // Nothing
      } else if (orderType == 'scheduled') {
        preparingOrders.remove(instance);
        scheduledOrders.add(instance);
        instance.order.orderInformation.orderStatus = 'Scheduled';
      }
    }

    // Ready for Pickup
    else if (orderStatus == 'ready for pickup') {
      if (orderType == 'local') {
        readyForPickupOrders.remove(instance);
        readyToServeOrders.add(instance);
        instance.order.orderInformation.orderStatus = 'Ready to Serve';
      } else if (orderType == 'takeaway') {
        // Nothing
      } else if (orderType == 'delivery') {
        readyForPickupOrders.remove(instance);
        readyForDeliveryOrders.add(instance);
        instance.order.orderInformation.orderStatus = 'Ready for Delivery';
      } else if (orderType == 'scheduled') {
        // Nothing
      }
    }

    // Ready to Serve
    else if (orderStatus == 'ready to serve') {
      if (orderType == 'local') {
        // Nothing
      } else if (orderType == 'takeaway') {
        readyToServeOrders.remove(instance);
        readyForPickupOrders.add(instance);
        instance.order.orderInformation.orderStatus = 'Ready for Pickup';
      } else if (orderType == 'delivery') {
        readyToServeOrders.remove(instance);
        readyForDeliveryOrders.add(instance);
        instance.order.orderInformation.orderStatus = 'Ready for Delivery';
      } else if (orderType == 'scheduled') {
        // Nothing
      }
    }

    // Served
    else if (orderStatus == 'ready to serve') {
      if (orderType == 'local') {
        // Nothing
      } else if (orderType == 'takeaway') {
        // Nothing
      } else if (orderType == 'delivery') {
        // Nothing
      } else if (orderType == 'scheduled') {
        // Nothing
      }
    }

    // Ready for Delivery
    else if (orderStatus == 'ready for delivery') {
      if (orderType == 'local') {
        readyForDeliveryOrders.remove(instance);
        readyToServeOrders.add(instance);
        instance.order.orderInformation.orderStatus = 'Ready to Serve';
      } else if (orderType == 'takeaway') {
        readyForDeliveryOrders.remove(instance);
        readyForPickupOrders.add(instance);
        instance.order.orderInformation.orderStatus = 'Ready for Pickup';
      } else if (orderType == 'delivery') {
        // Nothing
      } else if (orderType == 'scheduled') {
        // Nothing
      }
    }

    // Out for Delivery
    else if (orderStatus == 'out for delivery') {
      if (orderType == 'local') {
        // Nothing
      } else if (orderType == 'takeaway') {
        // Nothing
      } else if (orderType == 'delivery') {
        // Nothing
      } else if (orderType == 'scheduled') {
        // Nothing
      }
    }

    // Scheduled
    else if (orderStatus == 'scheduled') {
      if (orderType == 'local') {
        scheduledOrders.remove(instance);
        preparingOrders.add(instance);
        instance.order.orderInformation.orderStatus = 'Preparing';
      } else if (orderType == 'takeaway') {
        scheduledOrders.remove(instance);
        preparingOrders.add(instance);
        instance.order.orderInformation.orderStatus = 'Preparing';
      } else if (orderType == 'delivery') {
        scheduledOrders.remove(instance);
        preparingOrders.add(instance);
        instance.order.orderInformation.orderStatus = 'Preparing';
      } else if (orderType == 'scheduled') {
        // Nothing
      }
    }

    // else
    else {
      debugPrint('Error: Unknown Order Type');
    }

    setState(() {});
  }

  void _onCancelOrder(OrderCard instance) {
    bool paid = instance.order.orderInformation.paymentStatus?.toLowerCase() == 'paid';

    if (paid) {
      // TODO: Checkout
      // TODO: if successful, continue, otherwise, break

      _removeFromLists(instance, true);

      instance.order.orderInformation.localTable?.occupied = false;
      instance.order.orderInformation.orderStatus = 'Cancelled';

      cancelledOrders.add(instance);
      allOrders.add(instance);
    } else {
      _removeFromLists(instance, true);

      instance.order.orderInformation.localTable?.occupied = false;
      instance.order.orderInformation.orderStatus = 'Cancelled';

      deletedOrders.add(instance);
      allOrders.add(instance);
    }

    setState(() {});
  }

  void _addToLists(OrderCard instance, bool next) {
    String? orderType = instance.order.orderInformation.orderType?.type;
    orderType = orderType?.toLowerCase();

    String? orderStatus = instance.order.orderInformation.orderStatus;
    orderStatus = orderStatus?.toLowerCase();

    // Local
    if (orderType == 'local') {
      // Next
      if (next) {
        if (orderStatus == 'preparing') {
          readyToServeOrders.add(instance);
        } else if (orderStatus == 'ready to serve') {
          servedOrders.add(instance);
        } else if (orderStatus == 'served') {
          completeOrders.add(instance);
          allOrders.add(instance);
        } else if (orderStatus == 'complete') {
          // Nothing
        }
      }

      // Previous
      else {
        if (orderStatus == 'preparing') {
          // Nothing
        } else if (orderStatus == 'ready to serve') {
          preparingOrders.add(instance);
        } else if (orderStatus == 'served') {
          readyToServeOrders.add(instance);
        } else if (orderStatus == 'complete') {
          servedOrders.add(instance);
        }
      }
    }

    // Takeaway
    else if (orderType == 'takeaway') {
      // Next
      if (next) {
        if (orderStatus == 'preparing') {
          readyForPickupOrders.add(instance);
        } else if (orderStatus == 'ready for pickup') {
          receivedOrders.add(instance);
          allOrders.add(instance);
        } else if (orderStatus == 'received') {
          // Nothing
        }
      }

      // Previous
      else {
        if (orderStatus == 'preparing') {
         // Nothing
        } else if (orderStatus == 'ready for pickup') {
          preparingOrders.add(instance);
        } else if (orderStatus == 'received') {
          readyForPickupOrders.add(instance);
        }
      }
    }

    // Delivery
    else if (orderType == 'delivery') {
      // Next
      if (next) {
        if (orderStatus == 'preparing') {
          readyForDeliveryOrders.add(instance);
        } else if (orderStatus == 'ready for delivery') {
          outForDeliveryOrders.add(instance);
        } else if (orderStatus == 'out for delivery') {
          deliveredOrders.add(instance);
          allOrders.add(instance);
        } else if (orderStatus == 'delivered') {
          // Nothing
        }
      }

      // Previous
      else {
        if (orderStatus == 'preparing') {
          // Nothing
        } else if (orderStatus == 'ready for delivery') {
          preparingOrders.add(instance);
        } else if (orderStatus == 'out for delivery') {
          readyForDeliveryOrders.add(instance);
        } else if (orderStatus == 'delivered') {
          outForDeliveryOrders.add(instance);
        }
      }
    }

    // Scheduled
    else if (orderType == 'scheduled') {
      // Next
      if (next) {
        preparingOrders.add(instance);
      }

      // Previous
      else {
        // Nothing
      }
    }

    // Unknown Order Type
    else {
      debugPrint('Error: Unknown Order Type');
    }
  }

  void _removeFromLists(OrderCard instance, bool next) {
    String? orderType = instance.order.orderInformation.orderType?.type;
    orderType = orderType?.toLowerCase();

    String? orderStatus = instance.order.orderInformation.orderStatus;
    orderStatus = orderStatus?.toLowerCase();

    // Local
    if (orderType == 'local') {
      // Next
      if (next) {
        if (orderStatus == 'preparing') {
          preparingOrders.remove(instance);
        } else if (orderStatus == 'ready to serve') {
          readyToServeOrders.remove(instance);
        } else if (orderStatus == 'served') {
          servedOrders.remove(instance);
        } else if (orderStatus == 'complete') {
          // Nothing
        }
      }

      // Previous
      else {
        if (orderStatus == 'preparing') {
          // Nothing
        } else if (orderStatus == 'ready to serve') {
          readyToServeOrders.remove(instance);
        } else if (orderStatus == 'served') {
          servedOrders.remove(instance);
        } else if (orderStatus == 'complete') {
          completeOrders.remove(instance);
          allOrders.remove(instance);
        }
      }
    }

    // Takeaway
    else if (orderType == 'takeaway') {
      // Next
      if (next) {
        if (orderStatus == 'preparing') {
          preparingOrders.remove(instance);
        } else if (orderStatus == 'ready for pickup') {
          readyForPickupOrders.remove(instance);
        } else if (orderStatus == 'received') {
          // Nothing
        }
      }

      // Previous
      else {
        if (orderStatus == 'preparing') {
          // Nothing
        } else if (orderStatus == 'ready for pickup') {
          readyForPickupOrders.remove(instance);
        } else if (orderStatus == 'received') {
          receivedOrders.remove(instance);
          allOrders.remove(instance);
        }
      }
    }

    // Delivery
    else if (orderType == 'delivery') {
      // Next
      if (next) {
        if (orderStatus == 'preparing') {
          preparingOrders.remove(instance);
        } else if (orderStatus == 'ready for delivery') {
          readyForDeliveryOrders.remove(instance);
        } else if (orderStatus == 'out for delivery') {
          outForDeliveryOrders.remove(instance);
        } else if (orderStatus == 'delivered') {
          // Nothing
        }
      }

      // Previous
      else {
        if (orderStatus == 'preparing') {
          // Nothing
        } else if (orderStatus == 'ready for delivery') {
          readyForDeliveryOrders.remove(instance);
        } else if (orderStatus == 'out for delivery') {
          outForDeliveryOrders.remove(instance);
        } else if (orderStatus == 'delivered') {
          deliveredOrders.remove(instance);
          allOrders.remove(instance);
        }
      }
    }

    // Scheduled
    else if (orderType == 'scheduled') {
      // Next
      if (next) {
        scheduledOrders.remove(instance);
      }

      // Previous
      else {
        // Nothing
      }
    }

    // Unknown Order Type
    else {
      debugPrint('Error: Unknown Order Type');
    }
  }

  void _updateStatus(OrderCard instance, bool next) {
    String? orderType = instance.order.orderInformation.orderType?.type;
    orderType = orderType?.toLowerCase();

    String? orderStatus = instance.order.orderInformation.orderStatus;
    orderStatus = orderStatus?.toLowerCase();

    // Local
    if (orderType == 'local') {
      // Next
      if (next) {
        if (orderStatus == 'preparing') {
          instance.order.orderInformation.orderStatus = 'Ready to Serve';
        } else if (orderStatus == 'ready to serve') {
          instance.order.orderInformation.orderStatus = 'Served';
        } else if (orderStatus == 'served') {
          instance.order.orderInformation.orderStatus = 'Complete';
          instance.order.orderInformation.localTable?.occupied = false;
        } else if (orderStatus == 'complete') {
          // Nothing
        }
      }

      // Previous
      else {
        if (orderStatus == 'preparing') {
          // Nothing
        } else if (orderStatus == 'ready to serve') {
          instance.order.orderInformation.orderStatus = 'Preparing';
        } else if (orderStatus == 'served') {
          instance.order.orderInformation.orderStatus = 'Ready to Serve';
        } else if (orderStatus == 'complete') {
          instance.order.orderInformation.orderStatus = 'Served';
        }
      }
    }

    // Takeaway
    else if (orderType == 'takeaway') {
      // Next
      if (next) {
        if (orderStatus == 'preparing') {
          instance.order.orderInformation.orderStatus = 'Ready for Pickup';
        } else if (orderStatus == 'ready for pickup') {
          instance.order.orderInformation.orderStatus = 'Received';
        } else if (orderStatus == 'received') {
          // Nothing
        }
      }

      // Previous
      else {
        if (orderStatus == 'preparing') {
          // Nothing
        } else if (orderStatus == 'ready for pickup') {
          instance.order.orderInformation.orderStatus = 'Preparing';
        } else if (orderStatus == 'received') {
          instance.order.orderInformation.orderStatus = 'Ready for Pickup';
        }
      }
    }

    // Delivery
    else if (orderType == 'delivery') {
      // Next
      if (next) {
        if (orderStatus == 'preparing') {
          instance.order.orderInformation.orderStatus = 'Ready for Delivery';
        } else if (orderStatus == 'ready for delivery') {
          instance.order.orderInformation.orderStatus = 'Out for Delivery';
        } else if (orderStatus == 'out for delivery') {
          instance.order.orderInformation.orderStatus = 'Delivered';
        } else if (orderStatus == 'delivered') {
          // Nothing
        }
      }

      // Previous
      else {
        if (orderStatus == 'preparing') {
          // Nothing
        } else if (orderStatus == 'ready for delivery') {
          instance.order.orderInformation.orderStatus = 'preparing';
        } else if (orderStatus == 'out for delivery') {
          instance.order.orderInformation.orderStatus = 'Ready for Delivery';
        } else if (orderStatus == 'delivered') {
          instance.order.orderInformation.orderStatus = 'Out for Delivery';
        }
      }
    }

    // Scheduled
    else if (orderType == 'scheduled') {
      // Next
      if (next) {
        instance.order.orderInformation.orderStatus = 'Preparing';
        instance.order.orderInformation.orderType = OrderType(type: 'Takeaway');
        instance.order.orderInformation.scheduledDateTime = null;
      }

      // Previous
      else {
        // Nothing
      }
    }

    // Unknown Order Type
    else {
      debugPrint('Error: Unknown Order Type');
    }
  }
}
