import 'package:blueapp/01_presentation/login/login.dart';
import 'package:flutter/material.dart';
import '../../../../constants.dart';

class HomeScreenTopBar extends StatelessWidget {
  const HomeScreenTopBar({
    Key? key,
    required this.topRadius,
    required this.name,
  }) : super(key: key);

  final double topRadius;
  final String name;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: kBackgroundColor,
      leading: Container(),
      expandedHeight: 100,
      stretch: true,
      flexibleSpace: FlexibleSpaceBar(
        background: ClipRRect(
          child: Container(
            decoration: BoxDecoration(
              color: kSecondaryColor.withOpacity(0.3),
              boxShadow: [
                BoxShadow(
                  blurRadius: 10,
                  color: kPrimaryColor.withOpacity(0.2),
                  offset: Offset(10, 5),
                )
              ],
            ),
            alignment: Alignment.center,
            child: Column(
              children: [
                Spacer(),
                Row(
                  children: [
                    Spacer(),
                    Text(
                      "Willkomen ",
                      style: TextStyle(
                        color: kPrimaryColor,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      name,
                      style: TextStyle(
                        color: kPrimaryColor,
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Text(
                      "!",
                      style: TextStyle(
                        color: kPrimaryColor,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Spacer(),
                    SizedBox(
                      height: 100,
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Image.asset("assets/images/exo.png"),
                      ),
                    ),
                    Spacer(),
                    InkWell(
                      child: Row(
                        children: [
                          Text(
                            'Logout ',
                            style: TextStyle(
                              color: kPrimaryColor,
                              fontSize: 20,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          Icon(
                            Icons.logout,
                            color: kPrimaryColor,
                          ),
                        ],
                      ),
                      onTap: () => Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (context) => LoginWithName(),
                          ),
                          (Route<dynamic> route) => false),
                    ),
                    Spacer(),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
