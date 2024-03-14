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
import 'package:restaurant_order_menu/utility.dart';

import 'components/category_card.dart';
import 'components/item_card.dart';
import 'components/line_item_order_sheet.dart';
import 'components/order_summary.dart';
import 'dummy_data.dart';
import 'models/category_model.dart';
import 'models/item_model.dart';
import 'models/line_item_model.dart';
import 'models/order_model.dart';

// TODO: Make it impossible to edit orders that are too late to change
// TODO: (complete ones, out for delivery)
class OrderMenu extends StatefulWidget {
  final List<Category> categories;
  final List<OrderType> orderTypes;
  final List<Customer> customers;
  final Order order;

  const OrderMenu({
    super.key,
    required this.categories,
    required this.orderTypes,
    required this.customers,
    required this.order,
  });

  @override
  State<OrderMenu> createState() => _OrderMenuState();
}

class _OrderMenuState extends State<OrderMenu> {
  late List<ItemCard> itemCards = [];

  late Customer? temporaryCustomer;

  final TextEditingController customerNameController = TextEditingController();
  final FocusNode customerNameFocusNode = FocusNode();

  final TextEditingController customerPhoneController = TextEditingController();
  final FocusNode customerPhoneFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    // (Make sure to flip it before exiting)
    widget.order.orderInformation.localTable?.occupied = false;

    temporaryCustomer = widget.order.orderInformation.customer;
    customerNameController.text = temporaryCustomer?.name ?? '';
    customerPhoneController.text = temporaryCustomer?.phone ?? '';

    debugPrint(customerNameController.text);
    debugPrint(customerPhoneController.text);
  }

  @override
  Widget build(BuildContext context) {
    //final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    bool isOrderEditable = isOrderActive(widget.order.orderInformation.orderStatus);

    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) async {
        if (didPop) {
          return;
        }

        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Leave?'),
            actionsAlignment: MainAxisAlignment.spaceBetween,
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  widget.order.orderInformation.localTable?.occupied = true;
                  Navigator.pop(context);
                  Navigator.pop(context, false);
                },
                child: const Text('Leave'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Stay'),
              ),
            ],
          ),
        );
        //_orderSummaryKey.currentState?.confirmOrder();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
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
                          readOnly: !isOrderEditable,
                          hintText: 'Customer Name...',
                          optionsList: widget.customers,
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
                          readOnly: !isOrderEditable,
                          hintText: 'Customer Phone...',
                          keyboardType: TextInputType.phone,
                          optionsList: widget.customers,
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
                        icon: Icon(_getOrderTypeIcon()),
                        tooltip: 'Order Type',
                      ),
                      Expanded(
                        child: ListTile(
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 4.0),
                          horizontalTitleGap: 4.0,
                          onTap: isOrderEditable ? _showOrderTypeDialog : null,
                          title: AutoSizeText(
                            //selectedOrder ?? 'Select Order Type',
                            widget.order.orderInformation.orderType?.type ??
                                'Select Order Type',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: _getTrailingOrderTypeData(),
                          /*AutoSizeText(
                          //'Type Data',
                          widget.order.orderInformation.orderType?.type ?? '-',
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

          // TODO: Make create method that enables the user to input ALL the order information at once (one page)
          /*actions: <Widget>[
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.edit),
            tooltip: 'Edit Order Information',
          ),
        ],*/
        ),
        body: GestureDetector(
          onTap: () {
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
                      children:
                          List.generate(widget.categories.length, (index) {
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
                  child: OrderSummary(
                    order: widget.order,
                    handleCustomer: _handleCustomer,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Get the icon for each of the order types
  IconData _getOrderTypeIcon() {
    if (widget.order.orderInformation.orderType == null) {
      return Icons.question_mark;
    } else {
      String type = widget.order.orderInformation.orderType!.type.toLowerCase();
      if (type == 'local') {
        return Icons.table_bar;
      } else if (type == 'takeaway') {
        return Icons.takeout_dining;
      } else if (type == 'delivery') {
        return Icons.delivery_dining;
      } else if (type == 'scheduled') {
        return Icons.date_range;
      } else {
        return Icons.question_mark;
      }
    }
  }

  /// Get the trailing widget for each of the eligible order types
  Widget? _getTrailingOrderTypeData() {
    String trailingText;
    String? type = widget.order.orderInformation.orderType?.type.toLowerCase();

    if (type != null) {
      if (type == 'local') {
        if (widget.order.orderInformation.localTable != null) {
          RestaurantTable table = widget.order.orderInformation.localTable!;
          trailingText =
              'Table [${table.id}${table.tableName != null ? ' - ${table.tableName}' : ''}]';
        } else {
          trailingText = 'No Table Selected';
        }
      } else if (type == 'scheduled') {
        if (widget.order.orderInformation.scheduledDateTime != null) {
          DateTime date = widget.order.orderInformation.scheduledDateTime!;

          // Man, this is garbage, make it an if-else statement pls ;-; [LATER ON: DONE :D]
          //String formattedDateTime = 'Date ${date.month}/${date.day} At [${time.hour == 0 ? (time.hour + 12) : (time.hour == 12 ? time.hour : time.hour % 12) }:${time.minute < 10 ? '0${time.minute}' : time.minute} ${time.hour >= 12 ? 'PM' : 'AM'}]';
          //trailingText = formattedDateTime;

          trailingText = formatDate(date: date);
        } else {
          trailingText = 'No Date Selected';
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

  /// On selection for customer name
  void _customerNameSelected(Object? customer) {
    debugPrint(customer.toString());
    if (customer != null) {
      customer as Customer;
      temporaryCustomer = customer;

      customerNameController.text = customer.name ?? '';
      customerPhoneController.text = customer.phone ?? '';
    } else {
      temporaryCustomer = null;
      customerNameController.clear();
    }
  }

  /// On selection for customer phone
  void _customerPhoneSelected(Object? customer) {
    debugPrint(customer.toString());
    if (customer != null) {
      customer as Customer;
      temporaryCustomer = customer;

      customerNameController.text = customer.name ?? '';
      customerPhoneController.text = customer.phone ?? '';
    } else {
      temporaryCustomer = null;
      customerPhoneController.clear();
    }
  }

  // TODO: Handle how to check if the selected customer exist, and if not, create a new one, & save him to database
  void _handleCustomer() {
    if (customerNameController.text != '' ||
        customerPhoneController.text != '') {
      Customer currentCustomer = Customer(
        name: customerNameController.text,
        phone: customerPhoneController.text,
      );

      if (temporaryCustomer != currentCustomer) {
        temporaryCustomer = currentCustomer;
      }

      // TODO: save to database if BOTH name & phone are registered AND not in database
      //if (customerInDatabase?)
      // NO => Add to database
      // IS IT IN DATABASE? YES, GOOD, NO, REGISTER

      widget.order.orderInformation.customer = temporaryCustomer;
    } else {
      widget.order.orderInformation.customer = null;
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
        onTab: isOrderActive(widget.order.orderInformation.orderStatus)
            ? (item) => _addLineItem(item)
            : null,
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
        OrderType? oldOrderType = widget.order.orderInformation.orderType;
        RestaurantTable? oldLocalTable =
            widget.order.orderInformation.localTable;
        String? oldDeliveryLocation =
            widget.order.orderInformation.deliveryLocation;
        DateTime? oldScheduledDateTime =
            widget.order.orderInformation.scheduledDateTime;

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
              widget.order.orderInformation.localTable?.occupied = true;
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
                  widget.order.orderInformation.orderType = oldOrderType;
                  widget.order.orderInformation.localTable = oldLocalTable;
                  widget.order.orderInformation.deliveryLocation =
                      oldDeliveryLocation;
                  widget.order.orderInformation.scheduledDateTime =
                      oldScheduledDateTime;

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
      widget.order.orderInformation;
    });
  }

  /// Create the Select Order Type Radio
  Widget _orderTypeSelector(StateSetter setLocalState) {
    return FlexWrapper(
      perRow: widget.orderTypes.length,
      children: List.generate(widget.orderTypes.length, (index) {
        return OrderTypeRadioCard(
          orderType: widget.orderTypes[index],
          groupValue: widget.order.orderInformation.orderType?.type,
          onChange: (value) {
            // Stateful Builder SetState Only update the state locally
            // Therefore, nothing happens to the value when you ONLY update it locally
            // You must also update it globally (update outside)
            setLocalState(() {
              widget.order.orderInformation.orderType =
                  widget.orderTypes[index];
            });
          },
        );
      }),
    );
  }

  /// Create the content of the selected order type
  Widget _orderTypeContent(StateSetter setLocalState) {
    String? selectedOrder =
        widget.order.orderInformation.orderType?.type.toLowerCase();

    if (selectedOrder != null) {
      // Table picker
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
                groupValue: widget.order.orderInformation.localTable?.id,
                onChange: (value) {
                  setLocalState(() {
                    widget.order.orderInformation.localTable = tables[index];
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
          text: widget.order.orderInformation.deliveryLocation,
        );

        return Expanded(
          child: TextField(
            controller: controller,
            onChanged: (value) {
              widget.order.orderInformation.deliveryLocation = value;
              debugPrint(widget.order.orderInformation.deliveryLocation);
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
                        widget.order.orderInformation.scheduledDateTime ??
                            DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 30)),
                    onDateChanged: (date) async {
                      //setLocalState(() {});
                      //widget.order.orderInformation.scheduledDateTime = date;

                      debugPrint(widget.order.orderInformation.scheduledDateTime
                          .toString());

                      TimeOfDay? time = await showTimePicker(
                        context: context,
                        initialTime:
                            widget.order.orderInformation.scheduledDateTime !=
                                    null
                                ? TimeOfDay.fromDateTime(
                                    widget.order.orderInformation
                                        .scheduledDateTime!,
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

                      widget.order.orderInformation.scheduledDateTime =
                          newDateTime;
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

  int _crossAxisCount() {
    final width = MediaQuery.of(context).size.width;
    //final height = MediaQuery.of(context).size.height;

    if (width <= 640) {
      return 3;
    } else if (width <= 1007) {
      return 4;
    } else {
      return 5;
    }
  }
}
