import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/src/models/country_model.dart';
import 'package:intl_phone_number_input/src/utils/util.dart';

class Item extends StatelessWidget {
  final Country country;
  final bool showFlag;
  final bool useEmoji;
  final TextStyle textStyle;
  final bool withCountryNames;
  final BoxDecoration decoration;

  const Item({
    Key key,
    this.country,
    this.showFlag,
    this.useEmoji,
    this.textStyle,
    this.decoration,
    this.withCountryNames = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: this.decoration ?? BoxDecoration(),
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      child: Row(
        textDirection: TextDirection.ltr,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          _Flag(
            country: country,
            showFlag: showFlag,
            useEmoji: useEmoji,
          ),
          SizedBox(width: 12.0),
          Text(
            '${(country?.dialCode ?? '')}',
            textDirection: TextDirection.ltr,
            style: textStyle,
          ),
        ],
      ),
    );
  }
}

class _Flag extends StatelessWidget {
  final Country country;
  final bool showFlag;
  final bool useEmoji;

  const _Flag({Key key, this.country, this.showFlag, this.useEmoji})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return country != null && showFlag
        ? Container(
            child: useEmoji
                ? Text(
                    Utils.generateFlagEmojiUnicode(country?.countryCode ?? ''),
                    style: Theme.of(context).textTheme.headline5,
                  )
                : country?.flagUri != null
                    ? Image.asset(
                        country?.flagUri,
                        width: 32.0,
                        package: 'intl_phone_number_input',
                      )
                    : SizedBox.shrink(),
          )
        : SizedBox.shrink();
  }
}
