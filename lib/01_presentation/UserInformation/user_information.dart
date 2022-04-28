import 'package:blueapp/03_database/user.dart';
import 'package:blueapp/03_database/user_database.dart';
import 'package:blueapp/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class UserInformation extends StatefulWidget {
  const UserInformation({Key? key, required this.name}) : super(key: key);
  final String name;

  @override
  _UserInformationState createState() => _UserInformationState(name);
}

class _UserInformationState extends State<UserInformation> {
  final String name;
  bool isLoading = true;

  _UserInformationState(this.name);
  late User _myUser;

  @override
  initState() {
    super.initState();
    refreshUser();
  }

  Future refreshUser() async {
    _myUser = await UserDatabase.instance.readOrCreateUserByNickName(name);
    setState(() {
      isLoading = false;
    });
  }

  void refresh() async {
    setState(() {
      isLoading = true;
    });
    await UserDatabase.instance.update(_myUser);
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Benutzerspezifische Daten')),
      ),
      body: Center(
        child: Container(
          width: size.width * 0.8,
          child: SingleChildScrollView(
            child: isLoading
                ? CircularProgressIndicator()
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        generalUserInput(),
                        SizedBox(height: 50),
                        fingerInput(),
                        SizedBox(height: 50),
                        fingerDetailedInput(),
                        SizedBox(height: 50),
                      ],
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  Column generalUserInput() {
    return Column(
      children: [
        SizedBox(
          height: 10,
        ),
        TextFormField(
          textAlign: TextAlign.center,
          decoration: const InputDecoration(
              border: UnderlineInputBorder(), labelText: 'Vorname'),
          keyboardType: TextInputType.name,
          onFieldSubmitted: (String value) {
            _myUser = _myUser.copyWith(firstName: value);
            refresh();
          },
          initialValue: _myUser.firstName,
        ),
        TextFormField(
          textAlign: TextAlign.center,
          decoration: const InputDecoration(
              border: UnderlineInputBorder(), labelText: 'Nachname'),
          keyboardType: TextInputType.name,
          onFieldSubmitted: (String value) {
            _myUser = _myUser.copyWith(lastName: value);
            refresh();
          },
          initialValue: _myUser.lastName,
        ),
        TextFormField(
          textAlign: TextAlign.center,
          decoration: const InputDecoration(
              border: UnderlineInputBorder(), labelText: 'Alter (Jahre)'),
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          onFieldSubmitted: (String value) {
            _myUser = _myUser.copyWith(age: int.parse(value));
            refresh();
          },
          initialValue: _myUser.age.toString(),
        ),
        TextFormField(
          textAlign: TextAlign.center,
          decoration: const InputDecoration(
            border: UnderlineInputBorder(),
            labelText: 'Gewicht (kg)',
          ),
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          onFieldSubmitted: (String value) {
            _myUser = _myUser.copyWith(weight: int.parse(value));
            refresh();
          },
          initialValue: _myUser.weight.toString(),
        ),
      ],
    );
  }

  Column fingerInput() {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        InteractiveViewer(
          child: Container(
            height: size.height * 0.4,
            child: Image.asset('assets/images/hand.png'),
          ),
        ),
        TextFormField(
          textAlign: TextAlign.center,
          decoration: const InputDecoration(
            labelStyle: TextStyle(color: Colors.green),
            border: UnderlineInputBorder(),
            labelText: 'Phalanx proximalis (mm)',
          ),
          keyboardType: TextInputType.number,
          onFieldSubmitted: (String value) {
            _myUser = _myUser.copyWith(lPp: double.parse(value));
            refresh();
          },
          initialValue: _myUser.lPp.toString(),
        ),
        TextFormField(
          textAlign: TextAlign.center,
          decoration: const InputDecoration(
              labelStyle: TextStyle(color: Colors.blue),
              border: UnderlineInputBorder(),
              labelText: 'Phalanx media (mm)'),
          keyboardType: TextInputType.number,
          onFieldSubmitted: (String value) {
            _myUser = _myUser.copyWith(lPm: double.parse(value));
            refresh();
          },
          initialValue: _myUser.lPm.toString(),
        ),
        TextFormField(
          textAlign: TextAlign.center,
          decoration: const InputDecoration(
              labelStyle: TextStyle(color: Colors.red),
              border: UnderlineInputBorder(),
              labelText: 'Phalanx distalis (mm)'),
          keyboardType: TextInputType.number,
          onFieldSubmitted: (String value) {
            _myUser = _myUser.copyWith(lPd: double.parse(value));
            refresh();
          },
          initialValue: _myUser.lPd.toString(),
        ),
      ],
    );
  }

  Column fingerDetailedInput() {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        InteractiveViewer(
          minScale: 1.0,
          maxScale: 5.0,
          child: Container(
            height: size.height * 0.4,
            child: Image.asset('assets/images/detailed_params.png'),
          ),
        ),
        TextFormField(
          textAlign: TextAlign.center,
          decoration: const InputDecoration(
            labelStyle: TextStyle(color: Colors.green),
            border: UnderlineInputBorder(),
            labelText: 'Höhe Phalanx proximalis (mm)',
          ),
          keyboardType: TextInputType.number,
          onFieldSubmitted: (String value) {
            _myUser = _myUser.copyWith(hPp: double.parse(value));
            refresh();
          },
          initialValue: _myUser.hPp.toString(),
        ),
        TextFormField(
          textAlign: TextAlign.center,
          decoration: const InputDecoration(
              labelStyle: TextStyle(color: Colors.blue),
              border: UnderlineInputBorder(),
              labelText: 'Höhe Phalanx media (mm)'),
          keyboardType: TextInputType.number,
          onFieldSubmitted: (String value) {
            _myUser = _myUser.copyWith(hPm: double.parse(value));
            refresh();
          },
          initialValue: _myUser.hPm.toString(),
        ),
        TextFormField(
          textAlign: TextAlign.center,
          decoration: const InputDecoration(
              labelStyle: TextStyle(color: Colors.red),
              border: UnderlineInputBorder(),
              labelText: 'Höhe Phalanx distalis (mm)'),
          keyboardType: TextInputType.number,
          onFieldSubmitted: (String value) {
            _myUser = _myUser.copyWith(hPd: double.parse(value));
            refresh();
          },
          initialValue: _myUser.hPd.toString(),
        ),
        //other stuff
        TextFormField(
          textAlign: TextAlign.center,
          decoration: const InputDecoration(
            labelStyle: TextStyle(color: kTextColor),
            border: UnderlineInputBorder(),
            labelText: 'dGen (mm)',
          ),
          keyboardType: TextInputType.number,
          onFieldSubmitted: (String value) {
            _myUser = _myUser.copyWith(dGen: double.parse(value));
            refresh();
          },
          initialValue: _myUser.dGen.toString(),
        ),
        TextFormField(
          textAlign: TextAlign.center,
          decoration: const InputDecoration(
              labelStyle: TextStyle(color: kTextColor),
              border: UnderlineInputBorder(),
              labelText: 'Offset Punkz A (x-Richtung) (mm)'),
          keyboardType: TextInputType.number,
          onFieldSubmitted: (String value) {
            _myUser = _myUser.copyWith(offAx: double.parse(value));
            refresh();
          },
          initialValue: _myUser.offAx.toString(),
        ),
        TextFormField(
          textAlign: TextAlign.center,
          decoration: const InputDecoration(
              labelStyle: TextStyle(color: kTextColor),
              border: UnderlineInputBorder(),
              labelText: 'Offset Punkz A (y-Richtung) (mm)'),
          keyboardType: TextInputType.number,
          onFieldSubmitted: (String value) {
            _myUser = _myUser.copyWith(offAy: double.parse(value));
            refresh();
          },
          initialValue: _myUser.offAy.toString(),
        ),
      ],
    );
  }
}
