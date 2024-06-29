import 'package:flutter/material.dart';

class HomeItem extends StatelessWidget {
  final String? title;
  final Icon? icon;
  final Color? color;
  final VoidCallback? press;

  const HomeItem({
    super.key,
    required this.title,
    required this.icon,
    required this.color,
    this.press,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextButton(
        style: ButtonStyle(
            padding: MaterialStateProperty.all(const EdgeInsets.only(top: 10)),
            backgroundColor: MaterialStateProperty.all(Colors.black12),
            elevation: MaterialStateProperty.all(5),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ))),
        onPressed: press,
        child: Container(
          width: double.maxFinite,
          height: 100,
          alignment: Alignment.center,
          margin: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                width: 50,
                height: 50,
                child: icon,
              ),
              Text(
                title ?? "",
                textAlign: TextAlign.end,
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
