import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/src/models/country_model.dart';
import 'package:intl_phone_number_input/src/utils/selector_config.dart';
import 'package:intl_phone_number_input/src/utils/test/test_helper.dart';
import 'package:intl_phone_number_input/src/widgets/countries_search_list_widget.dart';
import 'package:intl_phone_number_input/src/widgets/input_widget.dart';
import 'package:intl_phone_number_input/src/widgets/item.dart';

class SelectorButton extends StatelessWidget {
  final List<Country> countries;
  final Country country;
  final SelectorConfig selectorConfig;
  final TextStyle selectorTextStyle;
  final InputDecoration searchBoxDecoration;
  final bool autoFocusSearchField;
  final String locale;
  final bool isEnabled;
  final bool isScrollControlled;
  final BoxDecoration selectorDecoration;
  final bool darkMode;

  final ValueChanged<Country> onCountryChanged;

  const SelectorButton({
    Key key,
    @required this.darkMode,
    @required this.countries,
    @required this.country,
    @required this.selectorConfig,
    @required this.selectorTextStyle,
    @required this.searchBoxDecoration,
    @required this.autoFocusSearchField,
    @required this.locale,
    @required this.onCountryChanged,
    @required this.isEnabled,
    @required this.isScrollControlled,
    @required this.selectorDecoration,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return selectorConfig.selectorType == PhoneInputSelectorType.DROPDOWN
        ? countries.isNotEmpty && countries.length > 1
            ? DropdownButtonHideUnderline(
                child: DropdownButton<Country>(
                  key: Key(TestHelper.DropdownButtonKeyValue),
                  hint: Item(
                    country: country,
                    showFlag: selectorConfig.showFlags,
                    useEmoji: selectorConfig.useEmoji,
                    textStyle: selectorTextStyle,
                  ),
                  value: country,
                  items: mapCountryToDropdownItem(countries),
                  onChanged: isEnabled ? onCountryChanged : null,
                ),
              )
            : Item(
                country: country,
                showFlag: selectorConfig.showFlags,
                useEmoji: selectorConfig.useEmoji,
                textStyle: selectorTextStyle,
              )
        : MaterialButton(
            key: Key(TestHelper.DropdownButtonKeyValue),
            padding: EdgeInsets.zero,
            minWidth: 0,
            onPressed: countries.isNotEmpty && countries.length > 1
                ? () async {
                    Country selected;
                    if (selectorConfig.selectorType ==
                        PhoneInputSelectorType.BOTTOM_SHEET) {
                      selected = await showCountrySelectorBottomSheet(
                          context, countries, darkMode);
                    } else {
                      selected =
                          await showCountrySelectorDialog(context, countries, darkMode);
                    }

                    if (selected != null) {
                      onCountryChanged(selected);
                    }
                  }
                : null,
            child: Item(
              country: country,
              showFlag: selectorConfig.showFlags,
              useEmoji: selectorConfig.useEmoji,
              textStyle: selectorTextStyle,
              decoration: selectorDecoration
            ),
          );
  }

  List<DropdownMenuItem<Country>> mapCountryToDropdownItem(
      List<Country> countries) {
    return countries.map((country) {
      return DropdownMenuItem<Country>(
        value: country,
        child: Item(
          key: Key(TestHelper.countryItemKeyValue(country.countryCode)),
          country: country,
          showFlag: selectorConfig.showFlags,
          useEmoji: selectorConfig.useEmoji,
          textStyle: selectorTextStyle,
          withCountryNames: false,
        ),
      );
    }).toList();
  }

  Future<Country> showCountrySelectorDialog(
      BuildContext context, List<Country> countries, bool darkMode) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) => AlertDialog(
        backgroundColor: Colors.black,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(6.0))),
        contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 0),
        content: Container(
          width: double.maxFinite,
          child: CountrySearchListWidget(
            countries,
            locale,
            searchBoxDecoration: searchBoxDecoration,
            showFlags: selectorConfig.showFlags,
            useEmoji: selectorConfig.useEmoji,
            autoFocus: autoFocusSearchField,
              darkMode: darkMode ?? false
          ),
        ),
      ),
    );
  }

  Future<Country> showCountrySelectorBottomSheet(
      BuildContext context, List<Country> countries, bool darkMode) {
    return showModalBottomSheet(
      context: context,
      clipBehavior: Clip.hardEdge,
      isScrollControlled: isScrollControlled ?? true,
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12), topRight: Radius.circular(12))),
      builder: (BuildContext context) {
        return AnimatedPadding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          duration: const Duration(milliseconds: 100),
          child: DraggableScrollableSheet(
            builder: (BuildContext context, ScrollController controller) {
              return Container(
                decoration: ShapeDecoration(
                  color: darkMode ? Colors.black : Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                  ),
                ),
                child: CountrySearchListWidget(
                  countries,
                  locale,
                  searchBoxDecoration: searchBoxDecoration,
                  scrollController: controller,
                  showFlags: selectorConfig.showFlags,
                  useEmoji: selectorConfig.useEmoji,
                  autoFocus: autoFocusSearchField,
                ),
              );
            },
          ),
        );
      },
    );
  }
}
