import 'package:flutter/material.dart';

class HistoryItem extends StatelessWidget {
  const HistoryItem({
    super.key,
    required this.itemID,
    required this.itemType,
    required this.itemTitle,
    required this.itemRawData,
    required this.onDismissed,
  });

  final int itemID;
  final String itemType;
  final String itemTitle;
  final String itemRawData;
  final void Function(DismissDirection)? onDismissed;

  @override
  Widget build(BuildContext context) {
    IconData typeIcon() {
      if (itemType == 'Contact') {
        return Icons.account_circle_outlined;
      } else if (itemType == 'Email') {
        return Icons.alternate_email;
      } else if (itemType == 'Phone') {
        return Icons.phone_outlined;
      } else if (itemType == 'SMS') {
        return Icons.sms_outlined;
      } else if (itemType == 'Text') {
        return Icons.notes;
      } else if (itemType == 'Link') {
        return Icons.link;
      } else if (itemType == 'Wi-Fi') {
        return Icons.wifi;
      } else if (itemType == 'Location') {
        return Icons.place_outlined;
      } else if (itemType == 'Event') {
        return Icons.emoji_events_outlined;
      } else if (itemType == 'MeCard') {
        return Icons.qr_code_2;
      } else {
        return Icons.help_outline;
      }
    }

    return Dismissible(
      key: ValueKey(itemID),
      onDismissed: onDismissed,
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.red[100],
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Row(
                children: const [
                  Text(
                    'Delete',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Icon(
                    Icons.delete_outline,
                    size: 20,
                    color: Colors.red,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: () {
            Navigator.pushNamed(
              context,
              '/history-detail',
              arguments: {
                'typeName': itemType,
                'qrData': itemRawData,
              },
            );
          },
          overlayColor: MaterialStateProperty.all(Colors.transparent),
          child: Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: const Color.fromARGB(255, 235, 235, 235),
                      child: Icon(
                        typeIcon(),
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    const SizedBox(width: 15),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          itemType,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 1.5,
                          child: Text(
                            itemTitle,
                            maxLines: 1,
                            style: const TextStyle(
                              color: Color.fromARGB(255, 114, 114, 114),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const Icon(
                  Icons.navigate_next,
                  size: 30,
                ),
                const SizedBox(width: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
