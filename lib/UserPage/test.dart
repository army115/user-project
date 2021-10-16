// // Copyright 2019 The Flutter team. All rights reserved.
// // Use of this source code is governed by a BSD-style license that can be
// // found in the LICENSE file.

// import 'package:flutter/gestures.dart' show DragStartBehavior;
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

// import 'package:flutter_gen/gen_l10n/gallery_localizations.dart';

// class TextFieldDemo extends StatelessWidget {
//   const TextFieldDemo({Key key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         title: Text(GalleryLocalizations.of(context).demoTextFieldTitle),
//       ),
//       body: const TextFormFieldDemo(),
//     );
//   }
// }

// class TextFormFieldDemo extends StatefulWidget {
//   const TextFormFieldDemo({Key key}) : super(key: key);

//   @override
//   TextFormFieldDemoState createState() => TextFormFieldDemoState();
// }

// class PersonData {
//   String name = '';
//   String phoneNumber = '';
//   String email = '';
//   String password = '';
// }

// class PasswordField extends StatefulWidget {
//   const PasswordField({
//     Key key,
//     this.restorationId,
//     this.fieldKey,
//     this.hintText,
//     this.labelText,
//     this.helperText,
//     this.onSaved,
//     this.validator,
//     this.onFieldSubmitted,
//     this.focusNode,
//     this.textInputAction,
//   }) : super(key: key);

//   final String restorationId;
//   final Key fieldKey;
//   final String hintText;
//   final String labelText;
//   final String helperText;
//   final FormFieldSetter<String> onSaved;
//   final FormFieldValidator<String> validator;
//   final ValueChanged<String> onFieldSubmitted;
//   final FocusNode focusNode;
//   final TextInputAction textInputAction;

//   @override
//   _PasswordFieldState createState() => _PasswordFieldState();
// }

// class _PasswordFieldState extends State<PasswordField> with RestorationMixin {
//   final RestorableBool _obscureText = RestorableBool(true);

//   @override
//   String get restorationId => widget.restorationId;

//   @override
//   void restoreState(RestorationBucket oldBucket, bool initialRestore) {
//     registerForRestoration(_obscureText, 'obscure_text');
//   }

//   @override
//   Widget build(BuildContext context) {
//     return TextFormField(
//       key: widget.fieldKey,
//       restorationId: 'password_text_field',
//       obscureText: _obscureText.value,
//       maxLength: 8,
//       onSaved: widget.onSaved,
//       validator: widget.validator,
//       onFieldSubmitted: widget.onFieldSubmitted,
//       decoration: InputDecoration(
//         filled: true,
//         hintText: widget.hintText,
//         labelText: widget.labelText,
//         helperText: widget.helperText,
//         suffixIcon: GestureDetector(
//           dragStartBehavior: DragStartBehavior.down,
//           onTap: () {
//             setState(() {
//               _obscureText.value = !_obscureText.value;
//             });
//           },
//           child: Icon(
//             _obscureText.value ? Icons.visibility : Icons.visibility_off,
//             semanticLabel: _obscureText.value
//                 ? GalleryLocalizations.of(context)
//                     .demoTextFieldShowPasswordLabel
//                 : GalleryLocalizations.of(context)
//                     .demoTextFieldHidePasswordLabel,
//           ),
//         ),
//       ),
//     );
//   }
// }

// class TextFormFieldDemoState extends State<TextFormFieldDemo>
//     with RestorationMixin {
//   PersonData person = PersonData();

//   FocusNode _phoneNumber, _email, _lifeStory, _password, _retypePassword;

//   @override
//   void initState() {
//     super.initState();
//     _phoneNumber = FocusNode();
//     _email = FocusNode();
//     _lifeStory = FocusNode();
//     _password = FocusNode();
//     _retypePassword = FocusNode();
//   }

//   @override
//   void dispose() {
//     _phoneNumber.dispose();
//     _email.dispose();
//     _lifeStory.dispose();
//     _password.dispose();
//     _retypePassword.dispose();
//     super.dispose();
//   }

//   void showInSnackBar(String value) {
//     ScaffoldMessenger.of(context).hideCurrentSnackBar();
//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//       content: Text(value),
//     ));
//   }

//   @override
//   String get restorationId => 'text_field_demo';

//   @override
//   void restoreState(RestorationBucket oldBucket, bool initialRestore) {
//     registerForRestoration(_autoValidateModeIndex, 'autovalidate_mode');
//   }

//   final RestorableInt _autoValidateModeIndex =
//       RestorableInt(AutovalidateMode.disabled.index);

//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   final GlobalKey<FormFieldState<String>> _passwordFieldKey =
//       GlobalKey<FormFieldState<String>>();
//   final _UsNumberTextInputFormatter _phoneNumberFormatter =
//       _UsNumberTextInputFormatter();

//   void _handleSubmitted() {
//     final form = _formKey.currentState;
//     if (!form.validate()) {
//       _autoValidateModeIndex.value =
//           AutovalidateMode.always.index; // Start validating on every change.
//       showInSnackBar(
//         GalleryLocalizations.of(context).demoTextFieldFormErrors,
//       );
//     } else {
//       form.save();
//       showInSnackBar(Galler