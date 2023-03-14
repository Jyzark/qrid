import 'package:flutter/material.dart';

class QRTypeListTile extends StatelessWidget {
  const QRTypeListTile(
      {super.key,
      required this.typeIcon,
      required this.typeTitle,
      required this.onTap});
  final String typeTitle;
  final IconData typeIcon;
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: const Color.fromARGB(255, 235, 235, 235),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Theme.of(context).primaryColor,
                      child: Icon(
                        typeIcon,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 15),
                    Text(
                      typeTitle,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const Icon(
                  Icons.navigate_next,
                  size: 30,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
