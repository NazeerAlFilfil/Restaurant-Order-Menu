import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../models/line_item_model.dart';
import '../models/order_model.dart';
import '../models/order_type.dart';
import '../utility.dart';
import 'line_item_card.dart';
import 'line_item_order_sheet.dart';

class OrderSummary extends StatefulWidget {
  final Order order;
  final void Function() handleCustomer;

  const OrderSummary({
    super.key,
    required this.order,
    required this.handleCustomer,
  });

  @override
  State<OrderSummary> createState() => _OrderSummaryState();
}

class _OrderSummaryState extends State<OrderSummary> {
  @override
  Widget build(BuildContext context) {
    bool isOrderEditable = isOrderActive(widget.order.orderInformation.orderStatus);

    return Column(
      children: <Widget>[
        // Price Displaying Area
        Card(
          color: Theme.of(context).colorScheme.surface,
          margin: EdgeInsets.zero,
          elevation: 3,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 4.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                // Items Number
                Expanded(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    //mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      AutoSizeText(
                        '# Items',
                        maxLines: 1,
                        overflowReplacement: Text(
                          '#',
                          strutStyle: const StrutStyle(
                            forceStrutHeight: true,
                          ),
                          style: TextStyle(
                            fontSize: 10.5,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        strutStyle: const StrutStyle(
                          forceStrutHeight: true,
                        ),
                        style: TextStyle(
                          fontSize: 10.5,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      AutoSizeText(
                        maxLines: 1,
                        '${widget.order.lineItems.length}',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                ),

                // Divider
                const VerticalDivider(
                  width: 0,
                ),

                // Before VAT
                Expanded(
                  flex: 4,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        'Before VAT',
                        strutStyle: const StrutStyle(
                          forceStrutHeight: true,
                        ),
                        style: TextStyle(
                          fontSize: 10.5,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      AutoSizeText(
                        maxLines: 1,
                        formatNumber(
                          widget.order.calculateBeforeVATPrice(),
                        ),
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                ),

                // Divider
                const VerticalDivider(
                  width: 0,
                ),

                // VAT
                Expanded(
                  flex: 3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        'VAT',
                        strutStyle: const StrutStyle(
                          forceStrutHeight: true,
                        ),
                        style: TextStyle(
                          fontSize: 10.5,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      AutoSizeText(
                        maxLines: 1,
                        formatNumber(
                          widget.order.calculateVATPrice(),
                        ),
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                ),

                // Divider
                const VerticalDivider(
                  width: 0,
                ),

                // Total
                Expanded(
                  flex: 4,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        'Total',
                        strutStyle: const StrutStyle(
                          forceStrutHeight: false,
                        ),
                        style: TextStyle(
                          fontSize: 10.5,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      AutoSizeText(
                        maxLines: 1,
                        formatNumber(
                          widget.order.calculateTotalPrice(),
                        ),
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // Items Area
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: SingleChildScrollView(
              child: Column(
                children: List.generate(widget.order.lineItems.length, (index) {
                  return LineItemCard(
                    lineItem: widget.order.lineItems[index],
                    onTab: isOrderEditable ? (lineItem) => _editLineItem(lineItem) : null,
                    onRemovePressed: (lineItem) => _removeLineItem(lineItem),
                  );
                }),
              ),
            ),
          ),
        ),

        // Confirm Button
        GestureDetector(
          // TODO: Make double tabs immediately go to check out
          onDoubleTap: isOrderEditable ? () => _checkoutClicked(false) : null,
          child: ElevatedButton(
            style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0),
                ),
              ),
              padding: MaterialStateProperty.all(
                const EdgeInsets.symmetric(vertical: 12.0),
              ),
            ),
            onPressed: isOrderEditable ? _confirmOrder : _finishReview,
            onLongPress: isOrderEditable ? () => _saveClicked(false) : null,
            child: Container(
              width: double.infinity,
              alignment: Alignment.center,
              child: Text(isOrderEditable ? 'Confirm Order' : 'Finish Review'),
            ),
          ),
        ),
      ],
    );
  }

  void _removeLineItem(LineItem lineItem) {
    setState(() {
      widget.order.lineItems.remove(lineItem);
    });
  }

  Future<void> _editLineItem(LineItem lineItem) async {
    await showModalBottomSheet(
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
          lineItem: lineItem,
          onConfirm: (lineItem) => _confirmLineItem(lineItem),
        );
      },
    );
  }

  void _confirmLineItem(LineItem lineItem) {
    setState(() {
      widget.order;
    });
  }

  // Make Single tab show alert box that asks you to (cancel, confirm, confirm & checkout)
  // Remove all irrelevant order type information (from the ones not chosen)
  // Add timestamp to the order
  // Add customer name & phone (or their model) to the order
  // fill in missing order information like orderStatus, paymentStatus, etc...
  // Keep track of occupied tables
  void _confirmOrder() async {
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Save Order?'),
            content: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Text(
                  'Do you want to cancel and continue? or save & exit?',
                ),
                const Text('or do you want to go to checkout?'),
                const Text(''),
                Text(
                  'Note: A long press on "Confirm Order" will immediately take you to checkout',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
            actionsAlignment: MainAxisAlignment.spaceEvenly,
            actions: <Widget>[
              // Cancel
              TextButton(
                onPressed: _cancelClicked,
                child: const Text('Cancel'),
              ),

              // Save
              TextButton(
                onPressed: () => _saveClicked(true),
                child: const Text('Save'),
              ),

              // Save & Checkout
              TextButton(
                onPressed: () => _checkoutClicked(true),
                child: const Text('Checkout'),
              ),
            ],
          );
        });

    if (kDebugMode) print('tapped');
  }

  void _cancelClicked() {
    Navigator.of(context).pop();
  }

  void _saveClicked(bool inDialog) {
    _removeIrrelevantInformation();
    widget.order.orderInformation.localTable?.occupied = true;

    if (inDialog) Navigator.of(context).pop();

    Navigator.of(context).pop(true);
  }

  // TODO: Go to checkout (Make complete widget for checkout to be used elsewhere)
  void _checkoutClicked(bool inDialog) {
    _removeIrrelevantInformation();
    widget.order.orderInformation.localTable?.occupied = true;

    if (inDialog) Navigator.of(context).pop();

    Navigator.of(context).pop(true);
  }

  Future<void> _finishReview() async {
    Navigator.pop(context);
  }

  void _removeIrrelevantInformation() {
    // If no order type is selected, then assume its Takeaway
    widget.order.orderInformation.orderType ??= OrderType(type: 'Takeaway');

    String? orderType = widget.order.orderInformation.orderType?.type;
    orderType = orderType?.toLowerCase();

    debugPrint(widget.order.orderInformation.orderType?.type);

    if (orderType == 'local') {
      debugPrint('local');
      widget.order.orderInformation.orderStatus ??= 'Preparing';
      widget.order.orderInformation.paymentStatus ??= 'Not Paid';

      widget.order.orderInformation.localTable?.occupied = true;
      widget.order.orderInformation.localTable ??= null;
      widget.order.orderInformation.deliveryLocation = null;
      widget.order.orderInformation.scheduledDateTime = null;

      widget.handleCustomer();

      widget.order.orderInformation.timeStamp ??= DateTime.timestamp();
    } else if (orderType == 'takeaway') {
      debugPrint('takeaway');
      widget.order.orderInformation.orderStatus ??= 'Preparing';
      widget.order.orderInformation.paymentStatus ??= 'Not Paid';

      widget.order.orderInformation.localTable?.occupied = false;
      widget.order.orderInformation.localTable = null;
      widget.order.orderInformation.deliveryLocation = null;
      widget.order.orderInformation.scheduledDateTime = null;

      widget.handleCustomer();

      widget.order.orderInformation.timeStamp ??= DateTime.timestamp();


    } else if (orderType == 'delivery') {
      debugPrint('delivery');
      widget.order.orderInformation.orderStatus ??= 'Preparing';
      widget.order.orderInformation.paymentStatus ??= 'Not Paid';

      widget.order.orderInformation.localTable?.occupied = false;
      widget.order.orderInformation.localTable = null;
      widget.order.orderInformation.deliveryLocation ??= null;
      widget.order.orderInformation.scheduledDateTime = null;

      widget.handleCustomer();

      widget.order.orderInformation.timeStamp ??= DateTime.timestamp();
    } else if (orderType == 'scheduled') {
      debugPrint('scheduled');
      widget.order.orderInformation.orderStatus ??= 'Scheduled';
      widget.order.orderInformation.paymentStatus ??= 'Not Paid';

      widget.order.orderInformation.localTable?.occupied = false;
      widget.order.orderInformation.localTable = null;
      widget.order.orderInformation.deliveryLocation = null;
      widget.order.orderInformation.scheduledDateTime ??= null;

      widget.handleCustomer();

      widget.order.orderInformation.timeStamp ??= DateTime.timestamp();
    } else {
      debugPrint('else');
      widget.order.orderInformation.orderStatus ??= 'Cancelled';
      widget.order.orderInformation.paymentStatus ??= 'Not Paid';

      widget.order.orderInformation.localTable?.occupied = false;
      widget.order.orderInformation.localTable = null;
      widget.order.orderInformation.deliveryLocation = null;
      widget.order.orderInformation.scheduledDateTime = null;

      widget.order.orderInformation.customer = null;

      widget.order.orderInformation.timeStamp = null;
    }
  }

  void _addMissingInformation() {

  }
}
