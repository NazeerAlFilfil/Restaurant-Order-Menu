import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_order_menu/models/unit_model.dart';
import 'package:sqflite/sqflite.dart';

import 'models/item_model.dart';
import 'models/option_model.dart';

class Testing extends StatefulWidget {
  const Testing({super.key});

  @override
  State<Testing> createState() => _TestingState();
}

class _TestingState extends State<Testing> {
  Future<Image>? imageWidget;

  @override
  void initState() {
    super.initState();

    WidgetsFlutterBinding.ensureInitialized();

    _saveUnit();

    //_saveDummyImage();

    //_readDummyImage();
    imageWidget = readImage('categories', 'salad.png');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Image>(
      future: imageWidget,
      builder: (BuildContext context, AsyncSnapshot<Image> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          // If the Future is complete and has an image, display it.
          return snapshot.data!;
        } else if (snapshot.error != null) {
          // If the Future returns an error, display an error message.
          return Text('Error loading image');
        } else {
          // Otherwise, display a loading indicator.
          return CircularProgressIndicator();
        }
      },
    );
  }

  void _saveUnit() async {
    /*final database = openDatabase(
      join(await getDatabasesPath(), 'test.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE units(id INTEGER PRIMARY KEY, label TEXT, price DOUBLE, imagePath TEXT, filledImagePath TEXT)',
        );
      },
      version: 1,
    );*/
    await deleteDatabase(
      join(await getDatabasesPath(), 'test.db'),
    );

    debugPrint('Database reset');

    final database = openDatabase(
      join(await getDatabasesPath(), 'test.db'),
      onCreate: (db, version) {
        db.execute(
          'CREATE TABLE Items('
          'id INTEGER PRIMARY KEY AUTOINCREMENT, '
          'label TEXT NOT NULL, '
          'description TEXT, '
          'imagePath TEXT NOT NULL'
          ')',
        );
        db.execute(
          'CREATE TABLE Units('
          'id INTEGER PRIMARY KEY AUTOINCREMENT, '
          'itemId INTEGER, '
          'label TEXT NOT NULL, '
          'price DOUBLE NOT NULL, '
          'imagePath TEXT, '
          'filledImagePath TEXT, '
          'FOREIGN KEY (itemId) REFERENCES Items(id)'
          ')',
        );
        db.execute(
          'CREATE TABLE Options('
          'id INTEGER PRIMARY KEY AUTOINCREMENT, '
          'itemId INTEGER, '
          'label TEXT NOT NULL, '
          'imagePath TEXT, '
          'price DOUBLE, '
          'defaultLevel INTEGER, '
          'FOREIGN KEY (itemId) REFERENCES Items(id)'
          ')',
        );
      },
      version: 1,
    );

    debugPrint('table created');

    Unit large = Unit(
      id: 1,
      itemId: 1,
      label: 'Large',
      price: 18,
      imagePath: 'units/l.png',
      filledImagePath: 'units/filled_l.png',
    );
    Unit medium = Unit(
      id: 2,
      itemId: 1,
      label: 'Medium',
      price: 15,
      imagePath: 'units/m.png',
      filledImagePath: 'units/filled_m.png',
    );
    Unit small = Unit(
      id: 3,
      itemId: 1,
      label: 'Small',
      price: 12,
      imagePath: 'units/s.png',
      filledImagePath: 'units/filled_s.png',
    );

    List<Unit> units = [large, medium, small];

    Option tomato = Option(
      id: 1,
      itemId: 1,
      label: 'Tomato',
      imagePath: 'options/tomato.png',
    );
    Option lettuce = Option(
      id: 2,
      itemId: 1,
      label: 'Lettuce',
      imagePath: 'options/lettuce.png',
      defaultLevel: 2,
    );
    Option cheese = Option(
      id: 3,
      itemId: 1,
      label: 'Cheese',
      imagePath: 'options/cheese.png',
      defaultLevel: 2,
      price: 3,
    );
    Option sauce = Option(
      id: 4,
      itemId: 1,
      label: 'Sauce',
      imagePath: 'options/souce.png',
      defaultLevel: 2,
    );

    List<Option> options = [tomato, lettuce, cheese, sauce];

    Item burger = Item(
      id: 1,
      label: 'Double Mini Burger',
      imagePath: 'appetizer/burger.png',
      units: units,
      options: options,
    );

    final db = await database;

    await db.insert(
      'Items',
      burger.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    debugPrint('item saved');

    for (final Unit unit in burger.units) {
      await db.insert(
        'Units',
        unit.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    debugPrint('units saved');

    for (final Option option in burger.options) {
      await db.insert(
        'Options',
        option.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    debugPrint('options saved');

    final List<Map<String, Object?>> itemMaps = await db.query('Items');
    final List<Map<String, Object?>> unitMaps = await db.query('Units');
    final List<Map<String, Object?>> optionMaps = await db.query('Options');

    List<Item> myItems = [
      for (final {
      'id': id as int,
      'label': label as String,
      'description': description as String?,
      'imagePath': imagePath as String,
      } in itemMaps)
        Item(
          id: id,
          label: label,
          description: description,
          imagePath: imagePath,
          units: _getUnits(id, unitMaps),
          options: _getOptions(id, optionMaps),
        ),
    ];

    /*final List<Map<String, Object?>> unitMaps = await db.query('units');

    List<Unit> myUnits = [
      for (final {
            'id': id as int,
            'itemId': itemId as int,
            'label': label as String,
            'price': price as double,
            'imagePath': imagePath as String?,
            'filledImagePath': filledImagePath as String?,
          } in unitMaps)
        Unit(
          id: id,
          itemId: itemId,
          label: label,
          price: price,
          imagePath: imagePath,
          filledImagePath: filledImagePath,
        ),
    ];*/

    debugPrint(myItems.toString());
  }

  List<Unit> _getUnits(int id, List<Map<String, Object?>> unitMaps) {
    List<Unit> units = [
      for (final {
      'id': id as int,
      'itemId': itemId as int,
      'label': label as String,
      'price': price as double,
      'imagePath': imagePath as String?,
      'filledImagePath': filledImagePath as String?,
      } in unitMaps)
        Unit(
          id: id,
          itemId: itemId,
          label: label,
          price: price,
          imagePath: imagePath,
          filledImagePath: filledImagePath,
        ),
    ];

    List<Unit> unitList = [];

    for (Unit unit in units) {
      if (unit.itemId == id) {
        unitList.add(unit);
      }
    }

    return unitList;
  }

  List<Option> _getOptions(int id, List<Map<String, Object?>> optionMaps) {
    List<Option> options = [
      for (final {
      'id': id as int,
      'itemId': itemId as int,
      'label': label as String,
      'imagePath': imagePath as String?,
      'price': price as double?,
      'defaultLevel': defaultLevel as int,
      } in optionMaps)
        Option(
          id: id,
          itemId: itemId,
          label: label,
          imagePath: imagePath,
          price: price,
          defaultLevel: defaultLevel,
        ),
    ];

    List<Option> optionList = [];

    for (Option option in options) {
      if (option.itemId == id) {
        optionList.add(option);
      }
    }

    return optionList;
  }

  void _saveDummyImage() async {
    final ByteData data = await rootBundle.load('assets/restaurant/salad.png');
    final Uint8List bytes = data.buffer.asUint8List();

    File file = await saveImage(bytes, 'categories', 'salad.png');

    debugPrint(file.path);
  }

  /*void _readDummyImage() async {
    File file = readImage('categories', 'salad.png');

    imageWidget = Image.file(file);
  }*/

  /// Save image given an imageData, folderName (optional), and imageName (with extension)
  Future<File> saveImage(
      Uint8List imageData, String folderPath, String imageName) async {
    final Directory appDirectory = await getApplicationDocumentsDirectory();

    String path = appDirectory.path;

    // if folder path is specified
    if (folderPath != '') {
      final Directory customFolder = Directory('$path/$folderPath');

      // Create folders recursively if any of them do not exists
      if (!await customFolder.exists()) {
        await customFolder.create(recursive: true);
      }

      path = customFolder.path;
    }

    final File file = File('$path/$imageName');

    debugPrint(file.path);

    return file.writeAsBytes(imageData);
  }

  Future<Image> readImage(String folderPath, String imageName) async {
    final Directory appDirectory = await getApplicationDocumentsDirectory();

    String path = appDirectory.path;

    if (folderPath != '') {
      path = '$path/$folderPath';
    }

    final File file = File('$path/$imageName');

    return Image.file(file);
  }
}
