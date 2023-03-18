import 'package:flutter/material.dart';

class DashboardButton extends StatelessWidget {
  final void Function() onPressed;
  final void Function()? onLongPress;
  final IconData icon;
  final String title;

  const DashboardButton({
    required this.title,
    required this.icon,
    required this.onPressed,
    this.onLongPress,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SizedBox(
        width: 150,
        height: 150,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            elevation: 4,
            foregroundColor: const Color(0xFF189304),
            backgroundColor: const Color(0xFF0B4901),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
            ),
          ),
          onPressed: onPressed,
          onLongPress: onLongPress,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 50,
                color: Colors.white,
              ),
              Padding(
                padding: EdgeInsets.only(top: 16.0),
                child: Text(
                  title,
                  style: const TextStyle(
                      fontFamily: 'Josefin Sans',
                      color: Colors.white,
                      fontSize: 18.0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
