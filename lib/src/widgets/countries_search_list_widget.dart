import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/src/models/country_model.dart';
import 'package:intl_phone_number_input/src/utils/test/test_helper.dart';
import 'package:intl_phone_number_input/src/utils/util.dart';

class CountrySearchListWidget extends StatefulWidget {
  final List<Country> countries;
  final InputDecoration searchBoxDecoration;
  final String locale;
  final ScrollController scrollController;
  final bool autoFocus;
  final bool showFlags;
  final bool useEmoji;
  final Color textColor;

  CountrySearchListWidget(this.countries, this.locale,
      {this.searchBoxDecoration,
      this.scrollController,
      this.showFlags,
      this.useEmoji,
        this.textColor,
      this.autoFocus = false});

  @override
  _CountrySearchListWidgetState createState() =>
      _CountrySearchListWidgetState();
}

class _CountrySearchListWidgetState extends State<CountrySearchListWidget> {
  TextEditingController _searchController = TextEditingController();
  List<Country> filteredCountries;

  @override
  void initState() {
    filteredCountries = filterCountries();
    super.initState();
  }

  @override
  void dispose() {
    _searchController?.dispose();
    super.dispose();
  }

  InputDecoration getSearchBoxDecoration() {
    return widget.searchBoxDecoration ??
        InputDecoration(labelText: 'Search by country name or dial code');
  }

  List<Country> filterCountries() {
    final value = _searchController.text.trim();

    if (value.isNotEmpty) {
      return widget.countries
          .where(
            (Country country) =>
                country.name.toLowerCase().contains(value.toLowerCase()) ||
                getCountryName(country)
                    .toLowerCase()
                    .contains(value.toLowerCase()) ||
                country.dialCode.contains(value.toLowerCase()),
          )
          .toList();
    }

    return widget.countries;
  }

  String getCountryName(Country country) {
    if (widget.locale != null && country.nameTranslations != null) {
      String translated = country.nameTranslations[widget.locale];
      if (translated != null && translated.isNotEmpty) {
        return translated;
      }
    }
    return country.name;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 10, right: 10, bottom: 20),
          child: TextFormField(
            key: Key(TestHelper.CountrySearchInputKeyValue),
            decoration: getSearchBoxDecoration(),
            controller: _searchController,
            autofocus: widget.autoFocus,
            onChanged: (value) =>
                setState(() => filteredCountries = filterCountries()),
          ),
        ),
        Expanded(
          child: ListView.builder(
            controller: widget.scrollController,
            shrinkWrap: true,
            itemCount: filteredCountries.length,
            itemBuilder: (BuildContext context, int index) {
              Country country = filteredCountries[index];
              if (country == null) return null;
              return Column(
                children: [
                  Material(
                    color: Colors.transparent,
                    child: ListTile(
                      dense: true,
                      contentPadding: EdgeInsets.only(left: 12, right: 12, bottom: 8, top: 8),
                      key: Key(TestHelper.countryItemKeyValue(country.countryCode)),
                      title: Row(
                        children: [
                          widget.showFlags
                              ? _Flag(country: country, useEmoji: widget.useEmoji)
                              : null,
                          SizedBox(width: 14,),
                          Text('${getCountryName(country)}',
                            textAlign: TextAlign.start, style: TextStyle(color: widget.textColor),)
                        ],
                      ),
                      // title: Text('${getCountryName(country)}',
                      //     textAlign: TextAlign.start, style: TextStyle(color: widget.textColor),),
                      // subtitle: Align(
                      //     alignment: AlignmentDirectional.centerStart,
                      //     child: Text('${country?.dialCode ?? ''}',
                      //         textDirection: TextDirection.ltr,
                      //         textAlign: TextAlign.start, style: TextStyle(color: widget.darkMode ? Colors.grey : Colors.black))),
                      // trailing: Align(
                      //     alignment: AlignmentDirectional.centerStart,
                      //     child: Text('${country?.dialCode ?? ''}',
                      //         textDirection: TextDirection.ltr,
                      //         textAlign: TextAlign.start, style: TextStyle(color: widget.darkMode ? Colors.grey : Colors.black))),
                      trailing: Text('${country?.dialCode ?? ''}',
                          textDirection: TextDirection.ltr,
                          textAlign: TextAlign.start, style: TextStyle(color: widget.textColor)),
                      onTap: () => Navigator.of(context).pop(country),
                    ),
                  ),
                  index < filteredCountries.length - 1 ? Divider(color: Colors.white70, height: 1,) : Divider(height: 1,),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}

class _Flag extends StatelessWidget {
  final Country country;
  final bool useEmoji;

  const _Flag({Key key, this.country, this.useEmoji}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return country != null
        ? Container(
      height: 20, width: 20,
            child: useEmoji
                ? Text(
                    Utils.generateFlagEmojiUnicode(country?.countryCode ?? ''),
                    style: Theme.of(context).textTheme.headline5,
                  )
                : country?.flagUri != null
                    ?
                      CircleAvatar(
                        backgroundImage: AssetImage(
                          country.flagUri,
                          package: 'intl_phone_number_input',
                        ),
                      )
            //Image.asset(country.flagUri, package: 'intl_phone_number_input', width: 32,)
                    : SizedBox.shrink(),
          )
        : SizedBox.shrink();
  }
}
