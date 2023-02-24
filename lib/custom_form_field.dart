import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
class CustomFormField extends StatelessWidget {
  CustomFormField({
    Key? key,
    this.hintText,
    this.inputFormatters,
    this.validator,
    this.textField,
  }) : super(key: key);
  final String? hintText;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final TextField? textField;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        // textField,
        inputFormatters: inputFormatters,
        validator: validator,
        decoration: InputDecoration(hintText: hintText),
      ),
    );
  }
}

extension extString on String {
  bool get isValidEmail {
    final emailRegExp = RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    return emailRegExp.hasMatch(this);
  }

  bool get isValidName{
    final nameRegExp = new RegExp(r"^\s*([A-Za-z]{1,}([\.,] |[-']| ))+[A-Za-z]+\.?\s*$");
    return nameRegExp.hasMatch(this);
  }

  bool get isValidPassword{
    final passwordRegExp =
    RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\><*~]).{8,}/pre>');
    return passwordRegExp.hasMatch(this);
  }

  bool get isNotNull{
    return this!=null;
  }

  bool get isValidPhone{
    final phoneRegExp = RegExp(r"^\+?0[0-9]{10}$");
    return phoneRegExp.hasMatch(this);
  }

}

// class MyHomePage extends StatefulWidget {
//   @override
//   MyHomePageState createState() {
//     return new MyHomePageState();
//   }
// }

// class MyHomePageState extends State<MyHomePage> {
//   final _text = TextEditingController();
//   bool _validate = false;
//
//   @override
//   void dispose() {
//     _text.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('TextField Demo'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Text('Error Showed if Field is Empty on Submit button Pressed'),
//             TextField(
//               controller: _text,
//               decoration: InputDecoration(
//                 labelText: 'Enter the Value',
//                 errorText: _validate ? 'Value Can\'t Be Empty' : null,
//               ),
//             ),
//             RaisedButton(
//               onPressed: () {
//                 setState(() {
//                   _text.text.isEmpty ? _validate = true : _validate = false;
//                 });
//               },
//               child: Text('Submit'),
//               textColor: Colors.white,
//               color: Colors.blueAccent,
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }