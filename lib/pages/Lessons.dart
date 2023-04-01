import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class Assignment {
  final String subject;
  final int completed;
  final int total;
  final DateTime deadline;

  Assignment({
    required this.subject,
    required this.completed,
    required this.total,
    required this.deadline,
  });
}

class AssignmentScreen extends StatefulWidget {
  @override
  _AssignmentScreenState createState() => _AssignmentScreenState();
}

class _AssignmentScreenState extends State<AssignmentScreen> {
  final List<Assignment> _assignments = [
    Assignment(
      subject: 'Mathematics',
      completed: 5,
      total: 10,
      deadline: DateTime(2023, 4, 5),
    ),
    Assignment(
      subject: 'Mathematics',
      completed: 10,
      total: 10,
      deadline: DateTime(2023, 2, 2),
    ),
    Assignment(
      subject: 'Science',
      completed: 2,
      total: 8,
      deadline: DateTime(2023, 4, 10),
    ),
    Assignment(
      subject: 'English',
      completed: 8,
      total: 10,
      deadline: DateTime(2023, 4, 1),
    ),
    Assignment(
      subject: 'History',
      completed: 3,
      total: 6,
      deadline: DateTime(2023, 4, 3),
    )
  ];

  List<Assignment> _completedAssignments = [];
  List<Assignment> _urgentAssignments = [];
  List<Assignment> _pendingAssignments = [];

  @override
  void initState() {
    super.initState();
    _completedAssignments = _assignments
        .where((assignment) => assignment.completed == assignment.total)
        .toList();
    _urgentAssignments = _assignments
        .where((assignment) =>
            assignment.deadline.isBefore(DateTime.now().add(Duration(days: 3))))
        .toList();
    _pendingAssignments = _assignments
        .where((assignment) =>
            assignment.completed < assignment.total &&
            assignment.deadline.isAfter(DateTime.now().add(Duration(days: 2))))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              Text(
                'Urgent Assignments',
                style: GoogleFonts.openSans(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: _urgentAssignments.length,
                itemBuilder: (context, index) {
                  return _buildAssignmentTile(_urgentAssignments[index]);
                },
              ),
              SizedBox(height: 20),
              Text(
                'Pending Assignments',
                style: GoogleFonts.openSans(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: _pendingAssignments.length,
                itemBuilder: (context, index) {
                  return _buildAssignmentTile(_pendingAssignments[index]);
                },
              ),
              Text(
                'Completed Assignments',
                style: GoogleFonts.openSans(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: _completedAssignments.length,
                itemBuilder: (context, index) {
                  return _buildAssignmentTile(_completedAssignments[index]);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAssignmentTile(Assignment assignment) {
    int percentage = ((assignment.completed / assignment.total) * 100).toInt();

    Color progressColor = Colors.blue;
    if (assignment.completed == assignment.total) {
      progressColor = Colors.green;
    } else if (assignment.deadline.difference(DateTime.now()).inDays < 3) {
      progressColor = Colors.red;
    }

    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset(
            'assets/icons/book.svg',
            width: 40,
            height: 40,
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  assignment.subject,
                  style: GoogleFonts.openSans(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5),
                Row(
                  children: [
                    Expanded(
                      child: LinearProgressIndicator(
                        value: percentage / 100,
                        backgroundColor: Colors.grey.withOpacity(0.5),
                        valueColor:
                            AlwaysStoppedAnimation<Color>(progressColor),
                      ),
                    ),
                    SizedBox(width: 10),
                    Text(
                      '$percentage%',
                      style: GoogleFonts.openSans(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5),
                Row(
                  children: [
                    Icon(Icons.calendar_today, color: Colors.grey, size: 20),
                    SizedBox(width: 5),
                    Text(
                      DateFormat('MMM dd, yyyy').format(assignment.deadline),
                      style: GoogleFonts.openSans(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
