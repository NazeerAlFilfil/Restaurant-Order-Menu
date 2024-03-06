import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';

/// Must Specify TextEditingController AND FocusNode, OR NEITHER
/// (Can't have any be null while the other isn't)
class AutocompleteField extends StatelessWidget {
  /// TextEditingController
  final TextEditingController? textEditingController;

  /// FocusNode
  final FocusNode? focusNode;

  /// Hint text for the TextField
  final String hintText;

  /// Function to handle when an option is selected
  final Function(Object? selection) onSelected;

  /// What get displayed in selection
  final String Function(Object option) getTitle;

  /// Function to get what to display at subtitle (if any)
  final String Function(Object option)? getSubTitle;

  /// Maximum options height, default to 250
  final double maxOptionsHeight;

  /// Maximum number of options, default to 10
  final int maxNumberOfOptions;

  /// Keyboard Type, determines what keyboard to show
  final TextInputType? keyboardType;

  /// Text Input Formatter, determines what format to use
  final List<TextInputFormatter>? textInputFormatter;

  /// List that contains all options
  final List<Object> optionsList;

  const AutocompleteField({
    super.key,
    this.textEditingController,
    this.focusNode,
    required this.hintText,
    required this.onSelected,
    required this.getTitle,
    this.getSubTitle,
    this.maxOptionsHeight = 250.0,
    this.maxNumberOfOptions = 10,
    this.keyboardType,
    this.textInputFormatter,
    required this.optionsList,
  });

  @override
  Widget build(BuildContext context) {
    // Layout builder passes the dynamic constraints of the parent to the child :D
    return LayoutBuilder(builder: (
      BuildContext context,
      BoxConstraints constraints,
    ) {
      return RawAutocomplete<Object>(
        textEditingController: textEditingController,
        focusNode: focusNode,

        // What get displayed (The title of whatever object we get)
        displayStringForOption: (Object option) => getTitle(option),

        // Option builder (retrieve valid options to display)
        optionsBuilder: (TextEditingValue textEditingValue) {
          if (textEditingValue.text == '') {
            return const Iterable<Object>.empty();
          }

          // TODO: For some reason, this shit is getting printed 2~3 times, which means it might cause delays with bigger lists? (At least I should know the cause)
          // TODO: The problem seems like its one of the quirks of Flutter, as even in the official documentation, the same problem can be observed :|
          //debugPrint('--------------${optionsList.length}--------------');
          /*return optionsList.where((Object option) {
            //debugPrint(option.toString());
              return option.toString().toLowerCase().contains(
            textEditingValue.text.toLowerCase(),
            );
          });*/

          // This should be much faster than the previous method + shouldn't have any weird interaction :D
          List<Object> validOptions = [];
          int optionsCount = 0;
          for (Object option in optionsList) {
            if (optionsCount < maxNumberOfOptions) {
              if (option
                  .toString()
                  .toLowerCase()
                  .contains(textEditingValue.text.toLowerCase())) {
                optionsCount++;
                validOptions.add(option);
              }
            } else {
              debugPrint(optionsCount.toString());
              break;
            }
          }

          return validOptions;
        },

        // Options view builder (the widget used for displaying the options)
        optionsViewBuilder: (
          BuildContext context,
          AutocompleteOnSelected<Object> onSelected,
          Iterable<Object> options,
        ) {
          // Mostly the same as The default Material-style Autocomplete options
          return Align(
            alignment: Alignment.topLeft,
            child: Material(
              elevation: 4.0,
              child: ConstrainedBox(
                // width constraints from parent (height can be specified)
                constraints: BoxConstraints(
                  maxHeight: maxOptionsHeight,
                  maxWidth: constraints.maxWidth,
                ),
                // Create a listView from the list of valid options
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  itemCount: options.length,
                  itemBuilder: (BuildContext context, int index) {
                    final Object option = options.elementAt(index);
                    return InkWell(
                      onTap: () => onSelected(option),
                      child: Builder(builder: (BuildContext context) {
                        final bool highlight =
                            AutocompleteHighlightedOption.of(context) == index;
                        if (highlight) {
                          SchedulerBinding.instance.addPostFrameCallback(
                              (Duration timeStamp) {
                            Scrollable.ensureVisible(context, alignment: 0.5);
                          }, debugLabel: 'AutocompleteOptions.ensureVisible');
                        }
                        return Container(
                          color:
                              highlight ? Theme.of(context).focusColor : null,
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                // Display the title
                                Text(
                                  getTitle(option),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                // Display subtitle if the function to get it was specified
                                if (getSubTitle != null)
                                  Text(
                                    getSubTitle!(option),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                    strutStyle: const StrutStyle(
                                      forceStrutHeight: true,
                                    ),
                                  ),
                              ]),
                        );
                      }),
                    );
                  },
                ),
              ),
            ),
          );
        },

        // Custom Text Field
        fieldViewBuilder: (
          BuildContext context,
          TextEditingController textEditingController,
          FocusNode focusNode,
          VoidCallback onFieldSubmitted,
        ) {
          return TextFormField(
            controller: this.textEditingController ?? textEditingController,
            focusNode: focusNode,
            onFieldSubmitted: (String value) => onFieldSubmitted(),
            keyboardType: keyboardType,
            inputFormatters: textInputFormatter,
            decoration: InputDecoration(
              suffixIcon: IconButton(
                onPressed: () {
                  // This is disgusting :$ (I love it tho XD)
                  (this.textEditingController ?? textEditingController).clear();
                  onSelected(null);
                },
                icon: const Icon(Icons.highlight_off),
              ),
              hintText: hintText,
              hintMaxLines: 1,
              border: InputBorder.none,
              fillColor: Colors.transparent,
              filled: true,
            ),
          );
        },

        // When selecting an option
        onSelected: (Object selection) {
          // Remove focus & hide keyboard :D
          FocusManager.instance.primaryFocus?.unfocus();

          onSelected(selection);
        },
      );
    });
  }
}
