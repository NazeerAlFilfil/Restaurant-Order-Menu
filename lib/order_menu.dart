import 'package:flutter/material.dart';

import 'components/category_card.dart';
import 'components/item_card.dart';
import 'components/line_item_order_sheet.dart';
import 'components/order_summary.dart';
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

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Restaurant Menu'),
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Categories
          Flexible(
            flex: 12,
            child: Container(
              width: double.infinity,
              height: height,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.15),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: List.generate(widget.categories.length, (index) {
                    return CategoryCard(
                      category: widget.categories[index],
                      onTab: (items) => _changeItemCards(items),
                      //onTab: (items) {},
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
            flex: 58,
            child: Container(
              width: double.infinity,
              height: height,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.15),
              ),
              child: itemCards.isNotEmpty
                  ? OrientationBuilder(
                      builder: (context, orientation) {
                        return GridView.count(
                          shrinkWrap: true,
                          crossAxisCount: _crossAxisCount(),
                          childAspectRatio: 2 / 3,
                          //childAspectRatio: 5 / 7,
                          padding: const EdgeInsets.all(8),
                          mainAxisSpacing: 6,
                          crossAxisSpacing: 6,
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
    );
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
  void _addLineItem(Item item) {
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

  int _crossAxisCount() {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    if (width <= 640) {
      return 2;
    } else if (width <= 1007) {
      return 3;
    } else {
      return 4;
    }
  }
}
