import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/line_item_model.dart';
import '../models/option_model.dart';
import '../utility.dart';
import 'flex_wrapper.dart';
import 'option_with_level_card.dart';
import 'unit_radio_card.dart';

class LineItemOrderSheet extends StatefulWidget {
  final LineItem lineItem;
  final Function(LineItem lineItem) onConfirm;

  const LineItemOrderSheet({
    super.key,
    required this.lineItem,
    required this.onConfirm,
  });

  @override
  State<LineItemOrderSheet> createState() => _LineItemOrderSheetState();
}

class _LineItemOrderSheetState extends State<LineItemOrderSheet> {
  Timer? timer;
  late String? pickedUnit = widget.lineItem.pickedUnit.label;

  late TextEditingController quantityController =
      TextEditingController(text: widget.lineItem.quantity.toString());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: GestureDetector(
        onTap: () {
          // Remove focus when tabbing anything
          FocusManager.instance.primaryFocus?.unfocus();

          // Hide keyboard
          SystemChannels.textInput.invokeMethod('TextInput.hide');
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            // Transparent Area, Drag Shape
            Container(
              width: double.infinity,
              height: 24,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.surface.withOpacity(.3),
                    Theme.of(context).colorScheme.surface,
                    Theme.of(context).colorScheme.surface.withOpacity(.3),
                  ],
                  stops: const [0.30, 0.50, 0.70],
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    height: 6,
                    width: 40,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.inverseSurface,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: Card(
                elevation: 4,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(0),
                  ),
                ),
                margin: EdgeInsets.zero,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8.0,
                    horizontal: 12.0,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      // Image, Label, Description, Total Price, Unit Price
                      SizedBox(
                        height: MediaQuery.sizeOf(context).height * 0.16,
                        child: Row(
                          children: <Widget>[
                            // Image
                            Image(
                              image: AssetImage(widget.lineItem.item.imagePath),
                              fit: BoxFit.fitHeight,
                            ),

                            // Padding
                            const SizedBox(width: 8),

                            // Label, Description
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8.0,
                                ),
                                // Display Label & Description (if description is set)
                                // Otherwise, just display label (in the center)
                                child: widget.lineItem.item.description != null
                                    ? Column(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Expanded(
                                      child: Text(
                                        widget.lineItem.item.label,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        widget.lineItem.item.description!,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                )
                                    : Text(
                                  widget.lineItem.item.label,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),

                            // Padding
                            const SizedBox(width: 8),

                            // Total Price, Unit Price
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  // Total Price
                                  Text(
                                    'Total Price',
                                    strutStyle: const StrutStyle(
                                      forceStrutHeight: true,
                                    ),
                                    style: TextStyle(
                                      fontSize: 10.5,
                                      color:
                                      Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                  Text(
                                    '${formatNumber(widget.lineItem.totalPrice)} SR',
                                  ),

                                  // Filler Padding
                                  const Expanded(child: Text('')),

                                  // Unit Price
                                  Text(
                                    'Unit Price',
                                    strutStyle: const StrutStyle(
                                      forceStrutHeight: true,
                                    ),
                                    style: TextStyle(
                                      fontSize: 10.5,
                                      color:
                                      Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                  Text(
                                    '${formatNumber(widget.lineItem.unitPrice)} SR',
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Divider
                      const Divider(),

                      // Unit (Large, Medium, Small, etc..)
                      // Options
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: <Widget>[
                              // Units
                              FlexWrapper(
                                perRow: 4,
                                children: List.generate(
                                  widget.lineItem.item.units.length,
                                      (index) {
                                    return UnitRadioCard(
                                      unit: widget.lineItem.item.units[index],
                                      groupValue: pickedUnit,
                                      onChange: (value) =>
                                          _changePickedUnit(value),
                                    );
                                  },
                                ),
                              ),

                              // Padding
                              const SizedBox(height: 8.0),

                              // Options
                              FlexWrapper(
                                perRow: 4,
                                children: List.generate(
                                  widget.lineItem.item.options.length,
                                      (index) {
                                    Option option = widget.lineItem.item.options[index];
                                    return OptionWithLevelCard(
                                      option: option,
                                      level: widget.lineItem.pickedOptions[option],
                                      updatePickedOptions: (option, level) =>
                                          _updatePickedOptions(option, level),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Divider
                      const Divider(),

                      // Quantity, Cancel, Confirm
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          // Padding
                          const Flexible(flex: 5, child: Text('')),

                          // Subtract
                          Flexible(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: GestureDetector(
                                onLongPressStart: (details) {
                                  timer = Timer.periodic(
                                      const Duration(milliseconds: 250), (t) {
                                    setState(() {
                                      if (int.parse(quantityController.text) >
                                          10) {
                                        quantityController.text =
                                        '${int.parse(quantityController.text) - 10}';
                                      } else if (int.parse(
                                          quantityController.text) <
                                          10) {
                                        quantityController.text = '0';
                                      }

                                      // Update Prices
                                      widget.lineItem.quantity = int.parse(quantityController.text);
                                      widget.lineItem.updatePrices();
                                    });
                                  });
                                },
                                onLongPressEnd: (details) {
                                  if (timer != null) {
                                    timer!.cancel();
                                  }
                                },
                                child: ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      if (int.parse(quantityController.text) >
                                          0) {
                                        quantityController.text =
                                        '${int.parse(quantityController.text) - 1}';
                                      }

                                      // Update Prices
                                      widget.lineItem.quantity = int.parse(quantityController.text);
                                      widget.lineItem.updatePrices();
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.all(16.0),
                                    backgroundColor: Theme.of(context)
                                        .colorScheme
                                        .primary
                                        .withOpacity(0.33),
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(4),
                                      ),
                                    ),
                                    side: BorderSide(
                                      color:
                                      Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                  child: const Icon(Icons.remove, size: 32),
                                ),
                              ),
                            ),
                          ),

                          // Text Area
                          Flexible(
                            child: TextField(
                              controller: quantityController,
                              textAlign: TextAlign.center,
                              maxLength: 2,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                counterText: '',
                              ),
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                            ),
                          ),

                          // Add
                          Flexible(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: GestureDetector(
                                onLongPressStart: (details) {
                                  timer = Timer.periodic(
                                      const Duration(milliseconds: 250), (t) {
                                    setState(() {
                                      if (int.parse(quantityController.text) <=
                                          89) {
                                        quantityController.text =
                                        '${int.parse(quantityController.text) + 10}';
                                      } else if (int.parse(
                                          quantityController.text) >
                                          89) {
                                        quantityController.text = '99';
                                      }

                                      // Update Prices
                                      widget.lineItem.quantity = int.parse(quantityController.text);
                                      widget.lineItem.updatePrices();
                                    });
                                  });
                                },
                                onLongPressEnd: (details) {
                                  if (timer != null) {
                                    timer!.cancel();
                                  }
                                },
                                child: ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      if (int.parse(quantityController.text) <
                                          99) {
                                        quantityController.text =
                                        '${int.parse(quantityController.text) + 1}';
                                      }

                                      // Update Prices
                                      widget.lineItem.quantity = int.parse(quantityController.text);
                                      widget.lineItem.updatePrices();
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.all(16.0),
                                    backgroundColor: Theme.of(context)
                                        .colorScheme
                                        .primary
                                        .withOpacity(0.33),
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(4),
                                      ),
                                    ),
                                    side: BorderSide(
                                      color:
                                      Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                  child: const Icon(Icons.add, size: 32),
                                ),
                              ),
                            ),
                          ),

                          // Padding
                          const Flexible(flex: 5, child: Text('')),
                        ],
                      ),

                      // Padding
                      const SizedBox(height: 8.0),

                      // Cancel, Confirm
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          // Padding
                          const Flexible(child: Text('')),

                          // Cancel
                          Flexible(
                            child: Container(
                              width: double.infinity,
                              margin: const EdgeInsets.only(right: 32.0),
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.red[400],
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 20.0,
                                  ),
                                ),
                                child: const Text('Cancel'),
                              ),
                            ),
                          ),

                          // Confirm
                          Flexible(
                            child: Container(
                              width: double.infinity,
                              margin: const EdgeInsets.only(left: 32.0),
                              child: ElevatedButton(
                                onPressed: () {
                                  widget.onConfirm(widget.lineItem);
                                  Navigator.pop(context);
                                },
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 20.0,
                                  ),
                                ),
                                child: const Text('Confirm'),
                              ),
                            ),
                          ),

                          // Padding
                          const Flexible(child: Text('')),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _changePickedUnit(String? value) {
    setState(() {
      pickedUnit = value;
      widget.lineItem.pickedUnit = widget.lineItem.item.units.singleWhere((element) => element.label == value);
      widget.lineItem.updatePrices();
    });
  }

  void _updatePickedOptions(Option option, int level) {
    setState(() {
      if (level == option.defaultLevel) {
        widget.lineItem.pickedOptions.remove(option);
      } else {
        widget.lineItem.pickedOptions[option] = level;
      }
      widget.lineItem.updatePrices();
    });
  }
}
