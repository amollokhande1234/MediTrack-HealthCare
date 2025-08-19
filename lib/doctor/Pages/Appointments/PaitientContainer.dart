import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meditrack/shared/constants/Colors.dart';

class ProfileCard extends StatefulWidget {
  final DateTime dateTime;
  final String pName;
  final String pNumber;
  final String imgUrl;
  final VoidCallback declineTap;
  final VoidCallback acceptTap;

  ProfileCard({
    super.key,
    required this.dateTime,
    required this.imgUrl,
    required this.pName,
    required this.pNumber,
    required this.declineTap,
    required this.acceptTap,
  });

  @override
  State<ProfileCard> createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    String dayName = DateFormat('EEEE').format(widget.dateTime); // Monday
    String monthDay = DateFormat('MMM d').format(widget.dateTime); // Aug 29
    String startTime = DateFormat('HH:mm').format(widget.dateTime); // 11:00
    String endTime = DateFormat(
      'HH:mm',
    ).format(widget.dateTime.add(Duration(hours: 1))); // 12:00

    return Card(
      margin: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Top Row: Image + Info + More Icon
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipOval(
                  child: Image.network(
                    widget.imgUrl,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.pName,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: CustomColors.textDark,
                        ),
                      ),
                      Text(
                        widget.pNumber,
                        style: TextStyle(
                          color: CustomColors.textSub,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(
                    isExpanded ? Icons.expand_less : Icons.expand_more,
                  ),
                  onPressed: () {
                    setState(() {
                      isExpanded = !isExpanded;
                    });
                  },
                ),
              ],
            ),

            // Date Time Container
            Container(
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color: Color(0xFFF5F6FA),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.calendar_today, size: 18, color: Colors.grey),
                  SizedBox(width: 8),
                  Text(
                    '$dayName, $monthDay',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: CustomColors.textDark,
                    ),
                  ),
                  Spacer(),
                  Icon(Icons.access_time, size: 18, color: Colors.grey),
                  SizedBox(width: 8),
                  Text(
                    '$startTime - $endTime WIB',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: CustomColors.textDark,
                    ),
                  ),
                ],
              ),
            ),

            // Row
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: widget.declineTap,
                    child: Text(
                      "Decline",
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: CustomColors.textDark,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      shape: StadiumBorder(),
                      backgroundColor: Colors.redAccent.shade100,
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: widget.acceptTap,
                    child: Text(
                      "Accept",
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: CustomColors.textDark,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      shape: StadiumBorder(),
                      backgroundColor: Colors.greenAccent.shade200,
                    ),
                  ),
                ),
              ],
            ),

            // Expandable Section
            AnimatedCrossFade(
              duration: const Duration(milliseconds: 300),
              crossFadeState:
                  isExpanded
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
              firstChild: const SizedBox.shrink(),
              secondChild: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Divider(),
                  SizedBox(height: 8),
                  Text("Email: lokhandeamol2208@gmail.com"),
                  Text("Phone: +91 7028900431"),
                  Text("Location: Pune, Maharashtra"),
                  Text("Experience: 6-month internship in Flutter"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
