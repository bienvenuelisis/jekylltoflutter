import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import '../../constants/styles.dart';
import '../../services/local_storage.dart';

class ProfileListItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool hasNavigation;
  final void Function() onPressed;

  const ProfileListItem({
    Key? key,
    required this.icon,
    required this.text,
    this.hasNavigation = true,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onPressed();
      },
      child: Container(
        height: 55,
        margin: const EdgeInsets.symmetric(
          horizontal: 10,
        ).copyWith(
          bottom: 20,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 5,
        ),
        decoration: BoxDecoration(
          color: LocalStorage.nightMode
              ? Colors.grey.withAlpha(100)
              : Colors.grey.shade300,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: <Widget>[
            Icon(
              icon,
              size: 25,
              color: LocalStorage.nightMode ? Colors.white : Colors.teal,
            ),
            const SizedBox(width: 15),
            Text(
              text,
              style: kTitleTextStyle.copyWith(
                fontWeight: FontWeight.w500,
                fontSize: 15,
                fontFamily: "Poppins",
                color: Theme.of(context).textTheme.headline6!.color,
              ),
            ),
            const Spacer(),
            if (hasNavigation)
              Icon(
                LineAwesomeIcons.angle_right,
                size: 25,
                color: Theme.of(context).textTheme.headline6!.color,
              )
          ],
        ),
      ),
    );
  }
}
