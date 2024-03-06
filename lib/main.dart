import 'package:flutter/material.dart';
import 'package:restaurant_order_menu/main_menu.dart';
import 'package:restaurant_order_menu/models/order%20types/order_information.dart';
import 'package:restaurant_order_menu/models/order_type.dart';

import 'dummy_data.dart';
import 'models/category_model.dart';
import 'models/item_model.dart';
import 'models/option_model.dart';
import 'models/order_model.dart';
import 'models/unit_model.dart';
import 'order_menu.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Restaurant Orders',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurpleAccent),
        useMaterial3: true,
      ),
      //home: OrderMenu(categories: categories(), orderTypes: orderTypes(), customers: customers, order: order()),
      home: MainMenu(),
    );
  }

  List<Category> categories() {
    Unit large = Unit(
      label: 'Large',
      price: 18,
      imagePath: 'assets/restaurant/units/l.png',
      filledImagePath: 'assets/restaurant/units/filled_l.png',
    );
    Unit medium = Unit(
      label: 'Medium',
      price: 15,
      imagePath: 'assets/restaurant/units/m.png',
      filledImagePath: 'assets/restaurant/units/filled_m.png',
    );
    Unit small = Unit(
      label: 'Small',
      price: 12,
      imagePath: 'assets/restaurant/units/s.png',
      filledImagePath: 'assets/restaurant/units/filled_s.png',
    );

    List<Unit> units = [large, medium, small];

    Option tomato = Option(
      label: 'Tomato',
      imagePath: 'assets/restaurant/options/tomato.png',
    );
    Option lettuce = Option(
      label: 'Lettuce',
      imagePath: 'assets/restaurant/options/lettuce.png',
      defaultLevel: 2,
    );
    Option cheese = Option(
      label: 'Cheese',
      imagePath: 'assets/restaurant/options/cheese.png',
      defaultLevel: 2,
      price: 3,
    );
    Option sauce = Option(
      label: 'Sauce',
      imagePath: 'assets/restaurant/options/souce.png',
      defaultLevel: 2,
    );

    List<Option> options = [tomato, lettuce, cheese, sauce];

    Item burger = Item(
      label: 'Double Mini Burger',
      imagePath: 'assets/restaurant/appetizer/burger.png',
      units: units,
      options: options,
    );
    Item canapes = Item(
      label: 'Canapes',
      imagePath: 'assets/restaurant/appetizer/canapes.png',
      units: units,
      options: options,
    );
    Item empanada = Item(
      label: 'Empanada',
      imagePath: 'assets/restaurant/appetizer/empanada.png',
      units: units,
      options: options,
    );
    Item nachos = Item(
      label: 'Nachos',
      imagePath: 'assets/restaurant/appetizer/nachos.png',
      units: units,
      options: options,
    );

    List<Item> items = [burger, canapes, empanada, nachos];

    Category appetizers = Category(
      label: 'Appetizers',
      imagePath: 'assets/restaurant/appetizer.png',
      items: items,
    );
    Category salads = Category(
      label: 'Salads',
      imagePath: 'assets/restaurant/salad.png',
      items: items,
    );
    Category falafel = Category(
      label: 'Falafel',
      imagePath: 'assets/restaurant/falafel.png',
      items: items,
    );
    Category pasta = Category(
      label: 'Pasta',
      imagePath: 'assets/restaurant/spaguetti.png',
      items: items,
    );
    Category pizza = Category(
      label: 'Pizza',
      imagePath: 'assets/restaurant/pizza.png',
      items: items,
    );
    Category desserts = Category(
      label: 'Desserts',
      imagePath: 'assets/restaurant/gelato.png',
      items: items,
    );
    Category beverages = Category(
      label: 'Beverages',
      imagePath: 'assets/restaurant/lemonade.png',
      items: items,
    );

    List<Category> categories = [
      appetizers,
      salads,
      falafel,
      pasta,
      pizza,
      desserts,
      beverages,
    ];

    return categories;
  }

  List<OrderType> orderTypes() {
    List<OrderType> orderTypes = [
      OrderType(type: 'Local'),
      OrderType(type: 'Takeaway'),
      OrderType(type: 'Delivery'),
      OrderType(type: 'Scheduled'),
    ];

    return orderTypes;
  }

  Order order() {
    return Order(id: '1', lineItems: [], orderInformation: OrderInformation());
  }
}