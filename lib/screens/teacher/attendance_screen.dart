import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../services/pdf_service.dart';
import '../../constants/app_colors.dart';
import '../../models/attendance_model.dart';
import '../../services/attendance_service.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  List<AttendanceModel> students = [];
  List<AttendanceModel> filteredStudents = [];

  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadAttendance();
  }

  Future<void> loadAttendance() async {
    await AttendanceService.instance.loadAttendance();

    if (!mounted) return;

    setState(() {
      students = List.from(
        AttendanceService.instance.attendanceList,
      );

      filteredStudents = List.from(students);
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void searchStudent(String value) {
    setState(() {
      filteredStudents = students.where((student) {
        return student.studentName
            .toLowerCase()
            .contains(value.toLowerCase());
      }).toList();
    });
  }

  // ============================================================
  // CLEAR ATTENDANCE
  // ============================================================

  Future<void> clearAttendance() async {
    if (students.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("There is no attendance data to clear."),
        ),
      );
      return;
    }

    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            "Clear Attendance?",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
            "This will remove all current attendance records. "
                "Are you sure you want to continue?",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text("Clear"),
            ),
          ],
        );
      },
    );

    if (confirm != true) return;

    await AttendanceService.instance.clearAttendance();

    if (!mounted) return;

    setState(() {
      students.clear();
      filteredStudents.clear();
      searchController.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Attendance cleared successfully."),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final int present =
        students.where((e) => e.isPresent).length;

    final int absent = students.length - present;

    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors.primaryBlue,
        foregroundColor: Colors.white,
        title: Text(
          "Attendance",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
          ),
        ),

        // ========================================================
        // CLEAR BUTTON IN APP BAR
        // ========================================================

        actions: [
          IconButton(
            tooltip: "Clear Attendance",
            icon: const Icon(
              Icons.delete_sweep_rounded,
            ),
            onPressed: clearAttendance,
          ),
        ],
      ),

      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: loadAttendance,

          child: SingleChildScrollView(
            keyboardDismissBehavior:
            ScrollViewKeyboardDismissBehavior.onDrag,

            physics: const AlwaysScrollableScrollPhysics(),

            padding: const EdgeInsets.all(18),

            child: Column(
              children: [
                // =================================================
                // SUMMARY
                // =================================================

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),

                  decoration: BoxDecoration(
                    color: AppColors.primaryBlue,
                    borderRadius: BorderRadius.circular(18),
                  ),

                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,

                    children: [
                      Text(
                        DateFormat(
                          "EEEE, dd MMMM yyyy",
                        ).format(DateTime.now()),

                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 10),

                      Text(
                        "Present : $present",
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                        ),
                      ),

                      Text(
                        "Absent : $absent",
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                        ),
                      ),

                      Text(
                        "Total : ${students.length}",
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // =================================================
                // SEARCH
                // =================================================

                TextField(
                  controller: searchController,

                  onChanged: searchStudent,

                  decoration: InputDecoration(
                    hintText: "Search Student...",

                    prefixIcon:
                    const Icon(Icons.search),

                    suffixIcon:
                    searchController.text.isNotEmpty
                        ? IconButton(
                      icon:
                      const Icon(Icons.clear),
                      onPressed: () {
                        searchController.clear();
                        searchStudent("");
                      },
                    )
                        : null,

                    filled: true,

                    fillColor: Colors.white,

                    border: OutlineInputBorder(
                      borderRadius:
                      BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // =================================================
                // ATTENDANCE LIST
                // =================================================

                filteredStudents.isEmpty
                    ? Padding(
                  padding:
                  const EdgeInsets.symmetric(
                    vertical: 40,
                  ),

                  child: Column(
                    mainAxisAlignment:
                    MainAxisAlignment.center,

                    children: [
                      Icon(
                        Icons.person_search,
                        size: 80,
                        color:
                        Colors.grey.shade400,
                      ),

                      const SizedBox(height: 20),

                      Text(
                        students.isEmpty
                            ? "No attendance records yet"
                            : "No student found",

                        textAlign:
                        TextAlign.center,

                        style:
                        GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight:
                          FontWeight.w600,
                        ),
                      ),

                      const SizedBox(height: 10),

                      Text(
                        students.isEmpty
                            ? "Start a new attendance session to see students here."
                            : "Try searching with another name.",

                        textAlign:
                        TextAlign.center,

                        style:
                        GoogleFonts.poppins(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                )
                    : ListView.builder(
                  shrinkWrap: true,

                  physics:
                  const NeverScrollableScrollPhysics(),

                  itemCount:
                  filteredStudents.length,

                  itemBuilder:
                      (context, index) {
                    final student =
                    filteredStudents[index];

                    return Card(
                      margin:
                      const EdgeInsets.only(
                        bottom: 12,
                      ),

                      elevation: 3,

                      shape:
                      RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(
                          15,
                        ),
                      ),

                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor:
                          Colors.blue.shade100,

                          child: Text(
                            student.studentName
                                .isNotEmpty
                                ? student.studentName[
                            0]
                                .toUpperCase()
                                : "?",

                            style:
                            const TextStyle(
                              fontWeight:
                              FontWeight.bold,
                            ),
                          ),
                        ),

                        title: Text(
                          student.studentName,

                          style:
                          GoogleFonts.poppins(
                            fontWeight:
                            FontWeight.w600,
                          ),
                        ),

                        subtitle: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,

                          children: [
                            Text(
                              "Enrollment: ${student.enrollment}",

                              style:
                              GoogleFonts.poppins(
                                fontWeight:
                                FontWeight.w500,
                              ),
                            ),

                            const SizedBox(height: 4),

                            Text(
                              "${student.date} • ${student.time}",

                              style:
                              GoogleFonts.poppins(),
                            ),

                            const SizedBox(height: 4),

                            Text(
                              student.isPresent
                                  ? "Present"
                                  : "Absent",

                              style:
                              GoogleFonts.poppins(
                                color:
                                student.isPresent
                                    ? Colors.green
                                    : Colors.red,

                                fontWeight:
                                FontWeight.w600,
                              ),
                            ),
                          ],
                        ),

                        trailing: Icon(
                          student.isPresent
                              ? Icons.check_circle
                              : Icons.cancel,

                          color:
                          student.isPresent
                              ? Colors.green
                              : Colors.red,
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 10),

                // =================================================
                // CLEAR ATTENDANCE BUTTON
                // =================================================

                if (students.isNotEmpty)
                  SizedBox(
                    width: double.infinity,
                    height: 55,

                    child: OutlinedButton.icon(
                      onPressed: clearAttendance,

                      icon: const Icon(
                        Icons.delete_sweep_rounded,
                        color: Colors.red,
                      ),

                      label: Text(
                        "Clear Attendance",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.red,
                        ),
                      ),

                      style:
                      OutlinedButton.styleFrom(
                        side: const BorderSide(
                          color: Colors.red,
                        ),

                        shape:
                        RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(15),
                        ),
                      ),
                    ),
                  ),

                const SizedBox(height: 12),

                // =================================================
                // EXPORT PDF
                // =================================================

                SizedBox(
                  width: double.infinity,
                  height: 55,

                  child: ElevatedButton.icon(
                    onPressed: () async {
                      if (students.isEmpty) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(
                          const SnackBar(
                            content: Text(
                              "No attendance available.",
                            ),
                          ),
                        );
                        return;
                      }

                      await PdfService
                          .generateAttendancePdf(
                        students,
                      );
                    },

                    icon: const Icon(Icons.save),

                    label: Text(
                      "Export PDF",

                      style: GoogleFonts.poppins(
                        fontSize: 17,
                        fontWeight:
                        FontWeight.w600,
                      ),
                    ),

                    style:
                    ElevatedButton.styleFrom(
                      backgroundColor:
                      AppColors.primaryBlue,

                      foregroundColor: Colors.white,

                      shape:
                      RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(15),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}