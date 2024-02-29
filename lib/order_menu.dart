import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:restaurant_order_menu/components/flex_wrapper.dart';
import 'package:restaurant_order_menu/components/order%20information/auto_complete.dart';
import 'package:restaurant_order_menu/components/order%20information/order_type_radio_card.dart';
import 'package:restaurant_order_menu/components/order%20information/table_radio_card.dart';
import 'package:restaurant_order_menu/models/customer.dart';
import 'package:restaurant_order_menu/models/order%20types/local%20models/restaurant_table.dart';
import 'package:restaurant_order_menu/models/order_type.dart';

import 'components/category_card.dart';
import 'components/item_card.dart';
import 'components/line_item_order_sheet.dart';
import 'components/order_summary.dart';
import 'dummy_data.dart';
import 'models/category_model.dart';
import 'models/item_model.dart';
import 'models/line_item_model.dart';
import 'models/order_model.dart';

class OrderMenu extends StatefulWidget {
  final List<Category> categories;
  final Order order;

  const OrderMenu({
    super.key,
    required this.categories,
    required this.order,
  });

  @override
  State<OrderMenu> createState() => _OrderMenuState();
}

class _OrderMenuState extends State<OrderMenu> {
  late List<ItemCard> itemCards = [];

  String? selectedOrder;
  String? tableIndex;

  final TextEditingController customerNameController = TextEditingController();
  final FocusNode customerNameFocusNode = FocusNode();

  final TextEditingController customerPhoneController = TextEditingController();
  final FocusNode customerPhoneFocusNode = FocusNode();

  /*
  final List<Customer> customers = [
    Customer(name: 'Nazeer', phone: '+966576894659'),
    Customer(name: 'Omar', phone: '+966556921526'),
    Customer(name: 'Ali', phone: '+966580984308'),
    Customer(name: 'Hadi', phone: '+966583463476'),
    Customer(name: 'Mohammed', phone: '+966523262623'),
    Customer(name: 'Khaled', phone: '+966523623623'),
    Customer(name: 'Mustafa', phone: '+966543572396'),
    Customer(name: 'Sara', phone: '+966554684984'),
    Customer(name: 'Tamara', phone: '+966518449544'),
  ];*/

  List<OrderType> orderTypes = [
    OrderType(type: 'Local'),
    OrderType(type: 'Takeaway'),
    OrderType(type: 'Delivery'),
    OrderType(type: 'Scheduled'),
  ];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    // Check if will be popped, make sure that it is done with the appropriate method (Confirm Button), or ask :)
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        //title: const Text('Restaurant Menu'),
        title: Row(
          children: <Widget>[
            // Order number
            Flexible(
              flex: 10,
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.only(right: 4.0),
                child: Row(
                  children: <Widget>[
                    const Text('# '),
                    Expanded(
                      child: AutoSizeText(
                        widget.order.id,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Customer Name
            Flexible(
              flex: 30,
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Row(
                  children: <Widget>[
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.person),
                      tooltip: 'Customer Name',
                    ),
                    Expanded(
                      child: AutocompleteField(
                        textEditingController: customerNameController,
                        focusNode: customerNameFocusNode,
                        hintText: 'Customer Name...',
                        optionsList: customers,
                        onSelected: (selection) =>
                            _customerNameSelected(selection),
                        getTitle: (Object customer) =>
                            _getCustomerName(customer),
                        getSubTitle: (Object customer) =>
                            _getCustomerPhone(customer),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Customer Phone
            Flexible(
              flex: 30,
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Row(
                  children: <Widget>[
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.phone),
                      tooltip: 'Customer Phone',
                    ),
                    Expanded(
                      child: AutocompleteField(
                        textEditingController: customerPhoneController,
                        focusNode: customerPhoneFocusNode,
                        hintText: 'Customer Phone...',
                        optionsList: customers,
                        onSelected: (selection) =>
                            _customerPhoneSelected(selection),
                        getTitle: (Object customer) =>
                            _getCustomerPhone(customer),
                        getSubTitle: (Object customer) =>
                            _getCustomerName(customer),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Order Type + Relevant Info
            Flexible(
              flex: 30,
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.only(left: 8.0),
                child: Row(
                  children: <Widget>[
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.table_restaurant),
                      tooltip: 'Order Type',
                    ),
                    // TODO: Working here~
                    Expanded(
                      child: ListTile(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 4.0),
                        horizontalTitleGap: 4.0,
                        onTap: _showOrderTypeDialog,
                        title: AutoSizeText(
                          selectedOrder ?? 'Select Order Type',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: AutoSizeText(
                          'Type Data',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.edit),
            tooltip: 'Edit Order Information',
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () {
          //FocusManager.instance.primaryFocus?.unfocus();
          // Remove focus from all children
          FocusScope.of(context).requestFocus(FocusNode());
          // Hide keyboard
          SystemChannels.textInput.invokeMethod('TextInput.hide');
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Categories
            Flexible(
              flex: 10,
              child: Container(
                width: double.infinity,
                height: height,
                decoration: BoxDecoration(
                  color:
                      Theme.of(context).colorScheme.primary.withOpacity(0.15),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: List.generate(widget.categories.length, (index) {
                      return CategoryCard(
                        category: widget.categories[index],
                        onTab: (items) => _changeItemCards(items),
                      );
                    }),
                  ),
                ),
              ),
            ),

            // Divider
            VerticalDivider(
              width: 1,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
            ),

            // Items
            Flexible(
              flex: 60,
              child: Container(
                width: double.infinity,
                height: height,
                decoration: BoxDecoration(
                  color:
                      Theme.of(context).colorScheme.primary.withOpacity(0.15),
                ),
                child: itemCards.isNotEmpty
                    ? OrientationBuilder(
                        builder: (context, orientation) {
                          return GridView.count(
                            shrinkWrap: true,
                            crossAxisCount: _crossAxisCount(),
                            childAspectRatio: 3 / 4,
                            //childAspectRatio: 2 / 3,
                            //childAspectRatio: 5 / 7,
                            padding: const EdgeInsets.all(8),
                            mainAxisSpacing: 4,
                            crossAxisSpacing: 4,
                            children: itemCards,
                          );
                        },
                      )
                    : Center(
                        child: Text(
                          'Select a Category',
                          style: Theme.of(context).textTheme.displayMedium,
                        ),
                      ),
              ),
            ),

            // Divider
            VerticalDivider(
              width: 1,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
            ),

            // Price/selling area
            Flexible(
              flex: 30,
              child: Container(
                  width: double.infinity,
                  height: height,
                  decoration: BoxDecoration(
                    color:
                        Theme.of(context).colorScheme.primary.withOpacity(0.15),
                  ),
                  child: OrderSummary(order: widget.order)),
            ),
          ],
        ),
      ),
    );
  }

  // TODO: Decide if to put the name & phone regardless of what was present before, or only put it when the other field is empty
  /// On selection for customer name
  void _customerNameSelected(Object? customer) {
    debugPrint(customer.toString());
    if (customer != null) {
      customer as Customer;
      customerNameController.text = customer.name ?? '';
      customerPhoneController.text = customer.phone ?? '';
      /*if (customerPhoneController.text == '') {
        customerPhoneController.text = customer.phone ?? '';
      }*/
    } else {
      customerNameController.clear();
    }
  }

  /// On selection for customer phone
  void _customerPhoneSelected(Object? customer) {
    debugPrint(customer.toString());
    if (customer != null) {
      customer as Customer;
      /*if (customerNameController.text == '') {
        customerNameController.text = customer.name ?? '';
      }*/
      customerNameController.text = customer.name ?? '';
      customerPhoneController.text = customer.phone ?? '';
    } else {
      customerPhoneController.clear();
    }
  }

  /// Get customer name for Autocomplete Options
  String _getCustomerName(Object customer) {
    return (customer as Customer).name ?? '';
  }

  /// Get customer phone for Autocomplete Options
  String _getCustomerPhone(Object customer) {
    return (customer as Customer).phone ?? '';
  }

  /// Change the items displayed in the main area depending on which category is clicked
  void _changeItemCards(List<Item> items) {
    setState(() {
      itemCards = _createItemCards(items);
    });
  }

  /// Create Item Cards Widgets from a list of items
  List<ItemCard> _createItemCards(List<Item> items) {
    return List.generate(items.length, (index) {
      return ItemCard(
        item: items[index],
        onTab: (item) => _addLineItem(item),
      );
    });
  }

  /// Open up LineItemOrderSheet and pass new LineItem
  Future<void> _addLineItem(Item item) async {
    await showModalBottomSheet<void>(
      elevation: 0,
      backgroundColor: Colors.transparent,
      useSafeArea: true,
      clipBehavior: Clip.hardEdge,
      constraints: BoxConstraints(
        maxWidth: MediaQuery.sizeOf(context).width * 0.9,
        maxHeight: MediaQuery.sizeOf(context).height * 0.85,
      ),
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return LineItemOrderSheet(
          lineItem: LineItem(
            item: item,
            quantity: 1,
            pickedUnit: item.units.first,
            pickedOptions: {},
          ),
          onConfirm: (lineItem) => _confirmLineItem(lineItem),
        );
      },
    );
  }

  void _confirmLineItem(LineItem lineItem) {
    setState(() {
      widget.order.lineItems.add(lineItem);
    });
  }

  Future<void> _showOrderTypeDialog() async {
    await showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Choose Order Type'),
            content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setLocalState) {
                return Container(
                  constraints: BoxConstraints(
                    minWidth: MediaQuery.sizeOf(context).width * 0.75,
                    minHeight: MediaQuery.sizeOf(context).height * 0.75,
                    maxWidth: MediaQuery.sizeOf(context).width * 0.75,
                    maxHeight: MediaQuery.sizeOf(context).height * 0.75,
                  ),
                  child: Column(
                    children: <Widget>[
                      FlexWrapper(
                          perRow: orderTypes.length,
                          children: List.generate(orderTypes.length, (index) {
                            return OrderTypeRadioCard(
                              orderType: orderTypes[index],
                              groupValue: selectedOrder,
                              onChange: (value) {
                                // Stateful Builder SetState Only update the state locally
                                // Therefore, nothing happens to the value when you ONLY update it locally
                                // You must also update it globally (update outside)
                                setLocalState(() {
                                  selectedOrder = value;
                                });
                              },
                            );
                          })),
                      Expanded(
                        child: GridView.count(
                          clipBehavior: Clip.hardEdge,
                          shrinkWrap: true,
                          crossAxisCount: 6,
                          childAspectRatio: 1,
                          padding: const EdgeInsets.all(8),
                          mainAxisSpacing: 4,
                          crossAxisSpacing: 4,
                          children: List.generate(30, (index) {
                            return TableRadioCard(
                              table: RestaurantTable(
                                id: '${index + 1}',
                              ),
                              groupValue: tableIndex,
                              onChange: (value) {
                                setLocalState(() {
                                  tableIndex = '${index + 1}';
                                });
                              },
                            );
                          }),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text('Confirm'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });


    // Set state globally outside
    setState(() {
      selectedOrder;
      tableIndex;
    });
  }

  /*
  // TODO: Delete
  Future<void> _showTestOrderTypeDialog() async {
    await showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return Material(
            child: Container(
              constraints: BoxConstraints(
                minWidth: MediaQuery.sizeOf(context).width / 2.0,
                minHeight: MediaQuery.sizeOf(context).height / 2.0,
                maxWidth: MediaQuery.sizeOf(context).width / 2.0,
                maxHeight: MediaQuery.sizeOf(context).height / 2.0,
              ),
              child: Column(
                children: <Widget>[
                  FlexWrapper(
                      perRow: orderTypes.length,
                      children: List.generate(orderTypes.length, (index) {
                        return OrderTypeRadioCard(
                          orderType: orderTypes[index],
                          groupValue: selectedOrder,
                          onChange: (value) {
                            setState(() {
                              selectedOrder = value;
                            });
                          },
                        );
                      })),
                  Expanded(
                    child: GridView.count(
                      clipBehavior: Clip.hardEdge,
                      shrinkWrap: true,
                      crossAxisCount: 7,
                      childAspectRatio: 1,
                      padding: const EdgeInsets.all(8),
                      mainAxisSpacing: 4,
                      crossAxisSpacing: 4,
                      children: List.generate(30, (index) {
                        return ChoiceChip(
                          //color: Colors.blue,
                          backgroundColor: Colors.transparent,
                          labelPadding: EdgeInsets.zero,
                          selected: (index + 1) == tableIndex,
                          onSelected: (selected) {
                            if (selected) {
                              setState(() {
                                tableIndex = (index + 1);;
                              });
                            }
                          },
                          label: Column(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  const Tooltip(
                                    message: 'Table Number',
                                    child: Icon(Icons.table_restaurant),
                                  ),
                                  const SizedBox(width: 8.0),
                                  AutoSizeText(
                                    '${index + 1}',
                                    maxLines: 1,
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  const Tooltip(
                                    message: 'Number of Seats',
                                    child: Icon(Icons.chair_alt),
                                  ),
                                  const SizedBox(width: 8.0),
                                  AutoSizeText(
                                    '4',
                                    maxLines: 1,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
   */

  int _crossAxisCount() {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    if (width <= 640) {
      return 3;
    } else if (width <= 1007) {
      return 4;
    } else {
      return 5;
    }
  }
}
