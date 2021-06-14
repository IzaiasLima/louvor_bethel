import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:louvor_bethel/src/commons/constants.dart';
import 'package:louvor_bethel/src/commons/validators.dart';
import 'package:louvor_bethel/src/models/worship.dart';
import 'package:louvor_bethel/src/ui/commons/app_bar.dart';
import 'package:louvor_bethel/src/ui/commons/drawer.dart';

class WorshipAddPage extends StatelessWidget {
  const WorshipAddPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    Worship worship = Worship();

    return Scaffold(
      appBar: CustomAppBar(),
      drawer: CustomDrawer(),
      body: Container(
        child: Column(
          children: [
            _descriptionFormField(),
            _dateTimeFormfield(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {},
                child: Text('CADASTRAR'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _dateTimeFormfield() {
    final format = DateFormat("dd-MM-yyyy HH:mm");
    return DateTimeField(
      decoration: InputDecoration(
        labelText: 'Data e hora do evento',
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
      format: format,
      onShowPicker: (context, currentValue) async {
        final date = await showDatePicker(
          context: context,
          firstDate: DateTime(1900),
          initialDate: currentValue ?? DateTime.now(),
          lastDate: DateTime(2100),
          // builder: (context, child) => Localizations.override(
          //   context: context,
          //   locale: Locale('pt'),
          //   child: child,
          // ),
        );
        if (date != null) {
          final time = await showTimePicker(
            context: context,
            initialTime: TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
          );
          return DateTimeField.combine(date, time);
        } else {
          return currentValue;
        }
      },
    );
  }

  _descriptionFormField() {
    return TextFormField(
      autocorrect: true,
      // autofocus: true,
      decoration: InputDecoration(
        labelText: 'Evento / momento',
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
      validator: (value) =>
          validWorshipField(value) ? null : Constants.validDescription,
      // onSaved: (newValue) => worship,
    );
  }
}
