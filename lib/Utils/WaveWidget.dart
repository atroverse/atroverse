// import 'package:audio_waveforms/audio_waveforms.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'dart:ui' as ui;
// import '../Controllers/CreateController.dart';
//
// class WaveBubble extends StatelessWidget {
//   final PlayerController playerController;
//   final VoidCallback onTap;
//   final bool isSender;
//   final bool isPlaying;
//
//   const WaveBubble({
//     Key? key,
//     required this.playerController,
//     required this.onTap,
//     required this.isPlaying,
//     this.isSender = false,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder<CreateController>(builder: (controller) {
//       // controller.playerController.stopPlayer();
//       return Align(
//         alignment: isSender ? Alignment.center : Alignment.center,
//         child: Container(
//           padding: EdgeInsets.only(
//             bottom: 6,
//             right: isSender ? 0 : 0,
//             top: 6,
//           ),
//           margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(10),
//             color: isSender ? Colors.grey : const Color(0xFF343145),
//           ),
//           child: Row(
//             mainAxisSize: MainAxisSize.min,
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               IconButton(
//                 onPressed: onTap,
//                 icon: Icon(isPlaying ? Icons.stop : Icons.play_arrow),
//                 color: isSender ? Colors.black : Colors.white,
//                 splashColor: Colors.transparent,
//                 highlightColor: Colors.transparent,
//               ),
//               AudioFileWaveforms(
//                 size: Size(MediaQuery.of(context).size.width / 1.8, 20),
//                 playerController: playerController,
//                 density: 1.5,
//                 enableSeekGesture: true,
//                 playerWaveStyle: PlayerWaveStyle(
//                   seekLineColor: Colors.blue,
//                   liveWaveGradient: ui.Gradient.linear(
//                     const Offset(70, 50),
//                     Offset(MediaQuery.of(context).size.width / 2, 0),
//                     [Colors.blue, Colors.green],
//                   ),
//                   fixedWavegradient: ui.Gradient.linear(
//                     const Offset(70, 50),
//                     Offset(MediaQuery.of(context).size.width / 2.2, 0),
//                     [Colors.red, Colors.green],
//                   ),
//                   scaleFactor: 0.8,
//                   fixedWaveColor: Colors.white30,
//                   liveWaveColor: Colors.white,
//                   waveCap: StrokeCap.butt,
//                 ),
//               ),
//               if (isSender) const SizedBox(width: 10),
//               (isSender)
//                   ? Container()
//                   : IconButton(
//                       onPressed: () {
//                         Get.find<CreateController>().isEnd.value = false;
//                         Get.find<CreateController>()
//                             .playerController
//                             .stopPlayer();
//                         Get.find<CreateController>().update();
//                       },
//                       icon: const Icon(
//                         Icons.close,
//                         color: Colors.red,
//                       ),
//                       color: Colors.white,
//                       splashColor: Colors.transparent,
//                       highlightColor: Colors.transparent,
//                     ),
//             ],
//           ),
//         ),
//       );
//     });
//   }
// }
