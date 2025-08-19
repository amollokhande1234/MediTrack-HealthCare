import 'package:flutter/material.dart';

class TimeSelector extends StatefulWidget {
  @override
  _TimeSelectorState createState() => _TimeSelectorState();
}

class _TimeSelectorState extends State<TimeSelector> {
  TimeOfDay? selectedTime;

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final hour =
        selectedTime == null
            ? "00"
            : (selectedTime!.hourOfPeriod == 0
                    ? 12
                    : selectedTime!.hourOfPeriod)
                .toString()
                .padLeft(2, '0');

    final minute =
        selectedTime == null
            ? "00"
            : selectedTime!.minute.toString().padLeft(2, '0');

    final period =
        selectedTime == null
            ? "--"
            : selectedTime!.period == DayPeriod.am
            ? "AM"
            : "PM";

    return GestureDetector(
      onTap: _pickTime,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _timeBox(hour, "Hour"),
          SizedBox(width: 5),
          Text(
            " : ",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40),
          ),
          SizedBox(width: 5),
          _timeBox(minute, "Min"),
          SizedBox(width: 10),
          _timeBox(period, "AM/PM"),
        ],
      ),
    );
  }

  Widget _timeBox(String value, String label) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.blue.shade300),
          ),
          child: Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.blue.shade900,
            ),
          ),
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
        ),
      ],
    );
  }
}
