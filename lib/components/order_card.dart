import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_order_menu/order_menu.dart';
import 'package:restaurant_order_menu/utility.dart';

import '../dummy_data.dart';
import '../models/order types/local models/restaurant_table.dart';
import '../models/order_model.dart';

class OrderCard extends StatefulWidget {
  final Order order;
  final void Function(OrderCard instance) onNextStep;
  final void Function(OrderCard instnace) onPreviousStep;
  final void Function(OrderCard instance) onReplacement;
  final void Function(OrderCard instance) onCancelOrder;

  const OrderCard({
    super.key,
    required this.order,
    required this.onNextStep,
    required this.onPreviousStep,
    required this.onReplacement,
    required this.onCancelOrder,
  });

  @override
  State<OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  @override
  Widget build(BuildContext context) {
    String? status = widget.order.orderInformation.orderStatus;
    status = status?.toLowerCase();

    return InkWell(
      onTap: () => _onCardTapped(),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        width: double.infinity,
        child: Row(
          children: <Widget>[
            // Order Information
            Flexible(
              flex: 65,
              child: Column(
                children: <Widget>[
                  // order number, order identifier, total price
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      // order number
                      AutoSizeText(
                        '# ${widget.order.id}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),

                      // padding
                      const SizedBox(width: 8.0),

                      // customer name, or phone, or Anonymous customer
                      Expanded(
                        child: Container(
                          alignment: Alignment.center,
                          child: AutoSizeText(
                            widget.order.orderInformation.customer?.name ??
                                widget.order.orderInformation.customer?.phone ??
                                'Anonymous',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),

                      // padding
                      const SizedBox(width: 8.0),

                      // total price
                      AutoSizeText(
                        '${formatNumber(widget.order.calculateTotalPrice())} SR',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),

                  // padding
                  const SizedBox(height: 6),

                  Row(
                    children: <Widget>[
                      // Order type & icon
                      Flexible(
                        flex: 35,
                        child: Row(
                          children: <Widget>[
                            // Order type icon
                            Icon(_getOrderTypeIcon()),

                            // padding
                            const SizedBox(width: 4),

                            // Order type
                            AutoSizeText(widget
                                        .order.orderInformation.orderType !=
                                    null
                                ? '${widget.order.orderInformation.orderType!.type} Order'
                                : 'Error: Unknown Order Type'),
                          ],
                        ),
                      ),

                      // order type data
                      Flexible(
                        flex: 65,
                        child: Container(
                          width: double.infinity,
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          child: _getOrderTypeData(),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Padding
            const Spacer(flex: 2),

            // Actions
            Flexible(
              flex: 35,
              child: Row(
                children: <Widget>[
                  // Payment button
                  Expanded(
                    flex: 40,
                    child: ElevatedButton(
                      onPressed: isOrderActive(status)
                          ? (_isOrderPaid() ? null : () => _onCheckOutClicked())
                          : null,
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all(
                          const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 8,
                          ),
                        ),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                      child: AutoSizeText(
                        _isOrderPaid() ? 'Paid' : 'Check Out',
                        //'Check Out | Paid (Cash | Card)',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),

                  // padding
                  const Spacer(flex: 6),

                  // Next Step
                  Expanded(
                    flex: 60,
                    child: ElevatedButton(
                      onPressed: isOrderActive(status)
                          ? () => widget.onNextStep(widget)
                          : null,
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all(
                          const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 8,
                          ),
                        ),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                      child: const AutoSizeText(
                        'Next Step',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),

                  // padding
                  const Spacer(flex: 2),

                  // More drop down
                  Visibility(
                    visible: isOrderActive(status),
                    child: Expanded(
                      flex: 10,
                      child: PopupMenuButton(
                        icon: const Icon(Icons.more_vert),
                        onSelected: (value) {
                          if (value == 'previous') {
                            widget.onPreviousStep(widget);
                          } else if (value == 'cancel') {
                            widget.onCancelOrder(widget);
                          } else if (value == 'delete') {
                            widget.onCancelOrder(widget);
                          } else if (value == 'complete') {
                            // TODO: Complete Order Immediately
                          } else {
                            debugPrint('Error: Incorrect Selected Value');
                          }
                        },
                        itemBuilder: (context) {
                          List<PopupMenuItem> items = [];

                          if (isOrderActive(status) &&
                              status != 'preparing' &&
                              status != 'scheduled') {
                            items.add(
                              const PopupMenuItem(
                                value: 'previous',
                                child: Text('Previous Step'),
                              ),
                            );
                          }

                          if (_isOrderPaid() && isOrderActive(status)) {
                            items.add(
                              const PopupMenuItem(
                                value: 'cancel',
                                child: Text('Cancel Order'),
                              ),
                            );
                          }

                          if (!_isOrderPaid() && isOrderActive(status)) {
                            items.add(
                              const PopupMenuItem(
                                value: 'delete',
                                child: Text('Delete Order'),
                              ),
                            );
                          }

                          if (isOrderActive(status)) {
                            items.add(
                              const PopupMenuItem(
                                value: 'complete',
                                child: Text('Complete Order'),
                              ),
                            );
                          }

                          return items;
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Navigate to OrderMenu with the saved order
  // TODO: Read categories & order types once and get them to everywhere
  // TODO: Make editing order conditional, based on the order status
  Future<void> _onCardTapped() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OrderMenu(
          categories: categories(),
          orderTypes: orderTypes(),
          customers: customers,
          order: widget.order,
        ),
      ),
    );
    setState(() {
      widget.order;
    });
    widget.onReplacement(widget);
  }

  // TODO: Handles check outs
  Future<void> _onCheckOutClicked() async {}

  bool _isOrderPaid() {
    String? paymentStatus = widget.order.orderInformation.paymentStatus;
    paymentStatus = paymentStatus?.toLowerCase();

    if (paymentStatus == 'not paid') {
      return false;
    } else if (paymentStatus == 'paid') {
      return true;
    }

    return false;
  }

  /// Get the icon for each of the order types
  IconData _getOrderTypeIcon() {
    if (widget.order.orderInformation.orderType == null) {
      return Icons.question_mark;
    } else {
      String? type = widget.order.orderInformation.orderType?.type;
      type = type?.toLowerCase();

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

  Widget _getOrderTypeData() {
    String? orderType = widget.order.orderInformation.orderType?.type;
    orderType = orderType?.toLowerCase();

    if (orderType == null) {
      return const Text('Error: Order type is null');
    } else {
      if (orderType == 'local') {
        RestaurantTable? table = widget.order.orderInformation.localTable;

        String tableId = table?.id ?? 'No Table Selected';
        String tableName = table?.tableName ?? '';

        return AutoSizeText(
          'Table [$tableId${tableName != '' ? ' - $tableName' : ''}]',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        );
      } else if (orderType == 'takeaway') {
        return const AutoSizeText('');
      } else if (orderType == 'delivery') {
        String location = widget.order.orderInformation.deliveryLocation ??
            'No Location Registered';

        return AutoSizeText(
          location,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        );
      } else if (orderType == 'scheduled') {
        DateTime? date = widget.order.orderInformation.scheduledDateTime;
        String? dateString = 'No Date Selected';

        if (date != null) {
          dateString = formatDate(date: date);
        }

        return AutoSizeText(
          dateString,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        );
      } else {
        return const AutoSizeText(
          'Error: Incorrect order type',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        );
      }
    }
  }
}
