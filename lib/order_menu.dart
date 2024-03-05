import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:restaurant_order_menu/components/flex_wrapper.dart';
import 'package:restaurant_order_menu/components/order%20information/auto_complete.dart';
import 'package:restaurant_order_menu/components/order%20information/order_type_radio_card.dart';
import 'package:restaurant_order_menu/components/order%20information/table_radio_card.dart';
import 'package:restaurant_order_menu/models/customer.dart';
import 'package:restaurant_order_menu/models/order%20types/local%20models/restaurant_table.dart';
import 'package:restaurant_order_menu/models/order%20types/selected_order_type.dart';
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

  late SelectedOrderType selectedOrderType = SelectedOrderType();

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
                    Expanded(
                      child: ListTile(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 4.0),
                        horizontalTitleGap: 4.0,
                        onTap: _showOrderTypeDialog,
                        title: AutoSizeText(
                          //selectedOrder ?? 'Select Order Type',
                          selectedOrderType.orderType?.type ??
                              'Select Order Type',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        // TODO: Working here~
                        trailing: _getTrailingOrderTypeData(),
                        /*AutoSizeText(
                          //'Type Data',
                          selectedOrderType.orderType?.type ?? '-',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),*/
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
                        child: AutoSizeText(
                          'Select a Category',
                          maxLines: 1,
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
                child: OrderSummary(order: widget.order),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget? _getTrailingOrderTypeData() {
    String trailingText;
    String? type = selectedOrderType.orderType?.type.toLowerCase();

    // TODO: Make it so if type is set, then that type data must be set
    if (type != null) {
      if (type == 'local') {
        if (selectedOrderType.localTable != null) {
          RestaurantTable table = selectedOrderType.localTable!;
          trailingText =
              '${table.id}${table.tableName != null ? ' - ${table.tableName}' : ''}';
        } else {
          trailingText = 'No Table Selected';
        }
      } else if (type == 'scheduled') {
        if (selectedOrderType.scheduledDateTime != null) {
          DateTime date = selectedOrderType.scheduledDateTime!;
          TimeOfDay time = TimeOfDay.fromDateTime(date);

          debugPrint(time.toString());
          // Man, this is garbage, make an if-else statement pls ;-;
          String formattedDateTime =
              '${date.month}/${date.day} [${time.hour == 0 ? (time.hour + 12) : (time.hour == 12 ? time.hour : time.hour % 12) }:${time.minute < 10 ? '0${time.minute}' : time.minute} ${time.hour >= 12 ? 'PM' : 'AM'}]';

          trailingText = formattedDateTime;
        } else {
          trailingText = 'No Time Selected';
        }
      } else {
        trailingText = '';
      }

      return AutoSizeText(
        trailingText,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      );
    }

    return null;
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
        // Save old values in case of cancel clicked
        OrderType? oldOrderType = selectedOrderType.orderType;
        RestaurantTable? oldLocalTable = selectedOrderType.localTable;
        String? oldDeliveryLocation = selectedOrderType.deliveryLocation;
        DateTime? oldScheduledDateTime = selectedOrderType.scheduledDateTime;

        // track whether to pop context or hide keyboard
        return PopScope(
          canPop: false,
          onPopInvoked: (bool didPop) {
            if (didPop) {
              return;
            }
            // if keyboard open
            if (MediaQuery.of(context).viewInsets.bottom > 0.0) {
              FocusScope.of(context).unfocus();
            } else {
              Navigator.of(context).pop();
            }
          },
          child: AlertDialog(
            contentPadding: const EdgeInsets.only(
              left: 24.0,
              top: 20.0,
              right: 24.0,
              bottom: 0.0,
            ),
            title: const Text('Choose Order Type'),
            content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setLocalState) {
                double widthPercent = 0.60;
                double heightPercent = 0.60;

                return SizedBox(
                  width: MediaQuery.sizeOf(context).width * widthPercent,
                  height: MediaQuery.sizeOf(context).height * heightPercent,
                  child: Column(
                    children: <Widget>[
                      // Order Types
                      _orderTypeSelector(setLocalState),

                      // Horizontal Divider
                      const Divider(),

                      // Content
                      _orderTypeContent(setLocalState),

                      // Horizontal Divider
                      const Divider(),
                    ],
                  ),
                );
              },
            ),
            actions: <Widget>[
              // Wipe/cancel everything done
              TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  // Reverse to old values
                  selectedOrderType.orderType = oldOrderType;
                  selectedOrderType.localTable = oldLocalTable;
                  selectedOrderType.deliveryLocation = oldDeliveryLocation;
                  selectedOrderType.scheduledDateTime = oldScheduledDateTime;

                  Navigator.of(context).pop();
                },
              ),

              // Confirm (just pop normally)
              TextButton(
                child: const Text('Confirm'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );

    // Set state globally outside
    setState(() {
      //selectedOrder;
      //tableIndex;
      selectedOrderType;
    });
  }

  /// Create the Select Order Type Radio
  Widget _orderTypeSelector(StateSetter setLocalState) {
    return FlexWrapper(
      perRow: orderTypes.length,
      children: List.generate(orderTypes.length, (index) {
        return OrderTypeRadioCard(
          orderType: orderTypes[index],
          groupValue: selectedOrderType.orderType?.type,
          onChange: (value) {
            // Stateful Builder SetState Only update the state locally
            // Therefore, nothing happens to the value when you ONLY update it locally
            // You must also update it globally (update outside)
            setLocalState(() {
              selectedOrderType.orderType = orderTypes[index];
            });
          },
        );
      }),
    );
  }

  /// Create the content of the selected order type
  Widget _orderTypeContent(StateSetter setLocalState) {
    String? selectedOrder = selectedOrderType.orderType?.type.toLowerCase();

    if (selectedOrder != null) {
      if (selectedOrder == 'local') {
        return Expanded(
          child: GridView.count(
            clipBehavior: Clip.hardEdge,
            shrinkWrap: true,
            crossAxisCount: 6,
            childAspectRatio: 3 / 4,
            mainAxisSpacing: 16,
            crossAxisSpacing: 8,
            children: List.generate(tables.length, (index) {
              return TableRadioCard(
                table: tables[index],
                groupValue: selectedOrderType.localTable?.id,
                onChange: (value) {
                  setLocalState(() {
                    selectedOrderType.localTable = tables[index];
                  });
                },
              );
            }),
          ),
        );
      } else if (selectedOrder == 'takeaway') {
        return const Expanded(child: Center(child: Text('')));
      } else if (selectedOrder == 'delivery') {
        TextEditingController controller = TextEditingController(
          text: selectedOrderType.deliveryLocation,
        );

        return Expanded(
          child: TextField(
            controller: controller,
            onChanged: (value) {
              selectedOrderType.deliveryLocation = value;
              debugPrint(selectedOrderType.deliveryLocation);
            },
            expands: true,
            minLines: null,
            maxLines: null,
            maxLength: 1000,
            decoration: const InputDecoration(
              counterText: '',
              labelText: 'Location',
              hintText: 'Example: Qatif - Behind Tanoor Restaurant',
              alignLabelWithHint: true,
              border: InputBorder.none,
              fillColor: Colors.transparent,
              filled: true,
            ),
          ),
        );
      } else if (selectedOrder == 'scheduled') {
        return Expanded(
          child: SingleChildScrollView(
            child: Row(
              children: <Widget>[
                const Spacer(flex: 15),
                Flexible(
                  flex: 70,
                  child: CalendarDatePicker(
                    initialDate:
                        selectedOrderType.scheduledDateTime ?? DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 30)),
                    onDateChanged: (date) async {
                      //setLocalState(() {});
                      //selectedOrderType.scheduledDateTime = date;

                      debugPrint(
                          selectedOrderType.scheduledDateTime.toString());

                      TimeOfDay? time = await showTimePicker(
                        context: context,
                        initialTime: selectedOrderType.scheduledDateTime != null
                            ? TimeOfDay.fromDateTime(
                                selectedOrderType.scheduledDateTime!,
                              )
                            : TimeOfDay.now(),
                      );

                      DateTime newDateTime;

                      if (time != null) {
                        newDateTime = DateTime(
                          date.year,
                          date.month,
                          date.day,
                          time.hour,
                          time.minute,
                        );
                      } else {
                        newDateTime = DateTime(
                          date.year,
                          date.month,
                          date.day,
                        );
                      }

                      selectedOrderType.scheduledDateTime = newDateTime;
                    },
                  ),
                ),
                const Spacer(flex: 15),
              ],
            ),
          ),
        );
      } else {
        return Expanded(
          child: Center(
            child: AutoSizeText(
              'Error: Wrong Type',
              maxLines: 1,
              style: Theme.of(context).textTheme.displayMedium,
            ),
          ),
        );
      }
    }

    return Expanded(
      child: Center(
        child: AutoSizeText(
          'Select Order Type',
          maxLines: 1,
          style: Theme.of(context).textTheme.displayMedium,
        ),
      ),
    );
  }

  int? _getContentIndexFromSelectedOrder() {
    String? selectedOrder = selectedOrderType.orderType?.type.toLowerCase();

    if (selectedOrder != null) {
      if (selectedOrder == 'local') {
        return 0;
      } else if (selectedOrder == 'takeaway') {
        return 1;
      } else if (selectedOrder == 'delivery') {
        return 2;
      } else if (selectedOrder == 'scheduled') {
        return 3;
      }
    }

    return null;
  }

  /*int? _getContentIndexFromSelectedOrder(String? selectedOrder) {
    if (selectedOrder != null) {
      if (selectedOrder == 'local') {
        return 0;
      } else if (selectedOrder == 'takeaway') {
        return 1;
      } else if (selectedOrder == 'delivery') {
        return 2;
      } else if (selectedOrder == 'scheduled') {
        return 3;
      }
    }

    return null;
  }*/

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
