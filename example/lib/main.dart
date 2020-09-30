import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(title: Text('Demo')),
        body: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController controller = TextEditingController();
  String initialCountry = 'NG';
  PhoneNumber number = PhoneNumber(isoCode: 'NG');

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Container(
        padding: EdgeInsets.all(16),
        color: Colors.blueGrey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget> [
            InternationalPhoneNumberInput(
              onInputChanged: (PhoneNumber number) {
                print(number.phoneNumber);
              },
              onInputValidated: (bool value) {
                print(value);
              },
              selectorConfig : SelectorConfig(selectorType: PhoneInputSelectorType.DIALOG, showFlags: true, backgroundColor: Colors.black, textColor: Colors.white),
              ignoreBlank: false,
              autoValidate: false,
              selectorTextStyle: TextStyle(color: Colors.white),
              textStyle: TextStyle(color: Colors.white),
              initialValue: number,
              textFieldController: controller,
              selectorDecoration: BoxDecoration(
                color: Colors.grey,
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10),
              ),
              searchBoxDecoration: InputDecoration(
                  contentPadding:
                  EdgeInsets.symmetric(vertical:12, horizontal: 15),
                  filled: true,
                  fillColor: Colors.grey,
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  hintText: "Search country...",


                  prefixStyle: TextStyle(color: const Color(0xFFc8cbd1)),
                  // errorStyle: new TextStyle(color: Colors.rouge,
                  //     fontSize: widget.errorText
                  //         ? scale.scaledSize(12) : 0),
                  hintStyle:  new TextStyle(
                      color: Colors.white30,
                      fontSize: 14)),
              inputBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(40))),
              inputDecoration: InputDecoration(
                  contentPadding:
                  EdgeInsets.symmetric(vertical:12, horizontal: 15),
                  filled: true,
                  fillColor: Colors.grey,
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  hintText: "+123...",


                  prefixStyle: TextStyle(color: const Color(0xFFc8cbd1)),
                  // errorStyle: new TextStyle(color: Colors.rouge,
                  //     fontSize: widget.errorText
                  //         ? scale.scaledSize(12) : 0),
                  hintStyle:  new TextStyle(
                      color: Colors.white30,
                      fontSize: 14)),
            ),
            RaisedButton(
              onPressed: () {
                formKey.currentState.validate();
              },
              child: Text('Validate'),
            ),
            RaisedButton(
              onPressed: () {
                getPhoneNumber('+15417543010');
              },
              child: Text('Update'),
            ),
          ],
        ),
      ),
    );
  }

  void getPhoneNumber(String phoneNumber) async {
    PhoneNumber number =
        await PhoneNumber.getRegionInfoFromPhoneNumber(phoneNumber, 'US');

    setState(() {
      this.number = number;
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
