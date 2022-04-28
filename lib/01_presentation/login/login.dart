import 'package:blueapp/01_presentation/home/home.dart';
import 'package:blueapp/03_database/user_database.dart';
import 'package:flutter/material.dart';
import '../../constants.dart';

class LoginWithName extends StatefulWidget {
  static String routeName = '/login';

  @override
  _LoginWithNameState createState() => _LoginWithNameState();
}

class _LoginWithNameState extends State<LoginWithName> {
  final myController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                SizedBox(
                  height: size.height * 0.4,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: size.width * 0.2),
                    child: Image.asset(
                      'assets/images/exo.png',
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ),
                Text(
                  "Entwickelt von M.Sc. Nikolas Wilhelm",
                  style: TextStyle(
                      color: kPrimaryColor, fontWeight: FontWeight.w300),
                ),
                SizedBox(
                  height: size.height * 0.05,
                ),
                TextFieldContainer(
                  size: size,
                  color: kPrimaryColor.withOpacity(0.15),
                  radius: 10,
                  child: TextFormField(
                    controller: myController,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(
                        Icons.account_box,
                        color: kPrimaryColor,
                      ),
                      labelText: 'Bitte gib deinen Namen an',
                      border: InputBorder.none,
                    ),
                    onChanged: (value) {},
                    onFieldSubmitted: (_) {
                      goToHomePage();
                    },
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                /*
                ElevatedButton(
                  onPressed: goToHomePage,
                  child: Text(
                    'LOGIN',
                    style: TextStyle(color: kBackgroundColor),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: kPrimaryColor,
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: EdgeInsets.symmetric(
                        horizontal: size.width * 0.33, vertical: 20),
                  ),
                ),
                SizedBox(
                  height: 50,
                ),*/
              ],
            ),
          ),
        ),
      ),
    );
  }

  void goToHomePage() async {
    final String name = myController.text;

    if (name.length > 0) {
      await UserDatabase.instance.readOrCreateUserByNickName(name);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(
            name: myController.text,
          ),
        ),
      );
    } else {
      final snackBar = showNoNameFlushbar();
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}

class TextFieldContainer extends StatelessWidget {
  const TextFieldContainer({
    Key? key,
    required this.size,
    required this.child,
    required this.color,
    required this.radius,
  }) : super(key: key);

  final Size size;
  final Widget child;
  final Color color;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      width: size.width * 0.7,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(radius),
      ),
      child: child,
    );
  }
}

SnackBar showNoNameFlushbar() {
  return SnackBar(
    content: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.account_box_rounded,
          color: Colors.redAccent,
        ),
        SizedBox(
          width: 20,
        ),
        Text(
          'Biee Namen angeben!',
          style: TextStyle(color: kBackgroundColor),
        )
      ],
    ),
    duration: const Duration(seconds: 1),
    backgroundColor: kPrimaryColor,
  );
}
