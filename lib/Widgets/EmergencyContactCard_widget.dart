// class EmergencyContactCard extends StatelessWidget {
//   final String contactName;
//   final String phoneNumber;
//
//   EmergencyContactCard({
//     required this.contactName,
//     required this.phoneNumber,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 2,
//       child: Padding(
//         padding: EdgeInsets.all(16),
//         child: Column(
//           children: [
//             Text(
//               contactName,
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             SizedBox(height: 8),
//             Text(
//               phoneNumber,
//               style: TextStyle(fontSize: 16),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }