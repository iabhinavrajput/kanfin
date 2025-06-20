// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:kifinserv/constants/app_colors.dart';
// import 'package:kifinserv/routes/app_routes.dart';
// import 'package:kifinserv/services/application_storage_service.dart';

// class ApplicationStatsWidget extends StatelessWidget {
//   const ApplicationStatsWidget({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final screenHeight = MediaQuery.of(context).size.height;

//     return FutureBuilder<Map<String, int>>(
//       future: ApplicationStorageService().getApplicationStats(),
//       builder: (context, snapshot) {
//         if (!snapshot.hasData) {
//           return const SizedBox.shrink();
//         }

//         final stats = snapshot.data!;
//         if (stats['total'] == 0) {
//           return const SizedBox.shrink();
//         }

//         return Container(
//           padding: EdgeInsets.all(screenWidth * 0.04),
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               colors: [
//                 AppColors.royalBlue.withOpacity(0.1),
//                 Colors.blue.withOpacity(0.05)
//               ],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//             borderRadius: BorderRadius.circular(screenWidth * 0.04),
//             border: Border.all(color: AppColors.royalBlue.withOpacity(0.2)),
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     'Your Applications',
//                     style: GoogleFonts.poppins(
//                       fontSize: screenWidth * 0.043,
//                       fontWeight: FontWeight.w600,
//                       color: AppColors.royalBlue,
//                     ),
//                   ),
//                   TextButton(
//                     onPressed: () => Get.toNamed(AppRoutes.TRACK_APPLICATIONS),
//                     child: Text(
//                       'View All',
//                       style: GoogleFonts.poppins(
//                         fontSize: screenWidth * 0.035,
//                         color: AppColors.royalBlue,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(height: screenHeight * 0.015),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: [
//                   _buildStatColumn('Total', stats['total']!, Icons.apps,
//                       AppColors.royalBlue, screenWidth),
//                   _buildStatColumn(
//                       'Pending',
//                       (stats['submitted']! + stats['under_review']!),
//                       Icons.pending,
//                       Colors.orange,
//                       screenWidth),
//                   _buildStatColumn(
//                       'Approved',
//                       (stats['approved']! + stats['disbursed']!),
//                       Icons.check_circle,
//                       Colors.green,
//                       screenWidth),
//                 ],
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildStatColumn(
//       String label, int count, IconData icon, Color color, double screenWidth) {
//     return Column(
//       children: [
//         Container(
//           padding: EdgeInsets.all(screenWidth * 0.025),
//           decoration: BoxDecoration(
//             color: color.withOpacity(0.1),
//             shape: BoxShape.circle,
//           ),
//           child: Icon(icon, color: color, size: screenWidth * 0.05),
//         ),
//         SizedBox(height: screenWidth * 0.015),
//         Text(
//           count.toString(),
//           style: GoogleFonts.poppins(
//             fontSize: screenWidth * 0.043,
//             fontWeight: FontWeight.bold,
//             color: color,
//           ),
//         ),
//         Text(
//           label,
//           style: GoogleFonts.poppins(
//             fontSize: screenWidth * 0.032,
//             color: Colors.grey[600],
//           ),
//         ),
//       ],
//     );
//   }
// }
