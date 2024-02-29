import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../models/line_item_model.dart';
import '../models/order_model.dart';
import '../utility.dart';
import 'line_item_card.dart';
import 'line_item_order_sheet.dart';

class OrderSummary extends StatefulWidget {
  final Order order;

  const OrderSummary({
    super.key,
    required this.order,
  });

  @override
  State<OrderSummary> createState() => _OrderSummaryState();
}

class _OrderSummaryState extends State<OrderSummary> {
  @override
  Widget build(BuildContext context) {
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
                    onTab: (lineItem) => _editLineItem(lineItem),
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
          // TODO: Make Single tab show alert box that asks you to (cancel, confirm, confirm & checkout)
          onDoubleTap: () {
            if (kDebugMode) print('double tabbed');
          },
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
            onPressed: _confirmOrder,
            child: Container(
              width: double.infinity,
              alignment: Alignment.center,
              child: const Text('Confirm Order'),
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
    showModalBottomSheet(
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
      widget.order; //.lineItems;
    });
  }

  Future<void> _confirmOrder() async {}
}
