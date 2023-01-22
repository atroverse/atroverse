import 'package:atroverse/Controllers/CreateController.dart';
import 'package:atroverse/Models/WillModel.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

import '../../../../Models/AtroModel.dart';
import '../globals.dart';

class AudioBubble extends StatefulWidget {
  AudioBubble(
      {Key? key,
        this.isCreate,
        required this.player,
        this.list,
        this.model,
        this.filepath,
        this.isNetwork})
      : super(key: key);
  bool? isCreate;
  String? filepath;
  bool? isNetwork;
  var model;
  List<Comment>? list;
  AudioPlayer player;

  @override
  State<AudioBubble> createState() => _AudioBubbleState();
}

class _AudioBubbleState extends State<AudioBubble> {
  Duration? duration;

  @override
  void initState() {
    print("**************************************");
    print(widget.filepath);
    print("**************************************");
    super.initState();
    if (widget.isNetwork == true) {
      Future.delayed(2.5.seconds).then((value) {
        for (var i in widget.list!) {
          var a = LockCachingAudioSource(Uri.parse(i.sound.toString()));
          i.player.setAudioSource(a).then((value) {
            setState(() {
              i.duration = i.player.duration;
            });
          });
        }
      });
    } else if (widget.isNetwork == false) {
      Future.delayed(200.milliseconds).then((value) {
        widget.player.setFilePath(widget.filepath!).then((value) {
          setState(() {
            duration = value;
          });
        });
      });
    }
  }

  @override
  void dispose() {
    widget.player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Container(
        width: Get.width * .9,
        padding: const EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Globals.borderRadius - 10),
          color: Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: Get.width * .02,
            ),
            Flexible(
              child: StreamBuilder<PlayerState>(
                stream: widget.player.playerStateStream,
                builder: (context, snapshot) {
                  Future.delayed(2.seconds).then((value) {
                    if (mounted) {
                      setState(() {});
                    }
                  });
                  final playerState = snapshot.data;
                  final processingState = playerState?.processingState;
                  var playing = playerState?.playing;
                  if (processingState == ProcessingState.loading ||
                      processingState == ProcessingState.buffering) {
                    return GestureDetector(
                      onTap: () {
                        widget.player.play();
                      },
                      child: const Icon(Icons.play_arrow,
                          color: Colors.blue, size: 30),
                    );
                  } else if (playing != true) {
                    return GestureDetector(
                      onTap: () {
                        if (widget.list != null) {
                          if(widget.model is AtroModel){
                            widget.model.pause();
                          }else if(widget.model is WillModel){
                            widget.model.pause();
                          }else{
                            widget.model.pause();
                          }
                          widget.list?.forEach((element) {
                            element.player.pause();
                            for (var element in element.replies) {
                              element.player.pause();
                            }
                          });
                        }
                        widget.player.play();
                      },
                      child: const Icon(Icons.play_arrow,
                          color: Colors.blue, size: 30),
                    );
                  } else if (processingState != ProcessingState.completed) {
                    return GestureDetector(
                      onTap: widget.player.pause,
                      child:
                      const Icon(Icons.pause, color: Colors.blue, size: 30),
                    );
                  } else {
                    return GestureDetector(
                      child: const Icon(Icons.replay,
                          color: Colors.blue, size: 30),
                      onTap: () {
                        widget.player.seek(Duration.zero);
                      },
                    );
                  }
                },
              ),
            ),
            const SizedBox(width: 8),
            Flexible(
              flex: 5,
              child: StreamBuilder<Duration>(
                stream: widget.player.positionStream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Row(
                      children: [
                        const SizedBox(width: 5),
                        SizedBox(
                          child: ProgressBar(
                            baseBarColor: Colors.grey,
                            progressBarColor: Colors.blue,
                            thumbRadius: 7,
                            barHeight: 3,
                            bufferedBarColor: Colors.grey,
                            thumbColor: Colors.blue,
                            timeLabelLocation: TimeLabelLocation.sides,
                            onDragUpdate: (value) {
                              widget.player.seek(value.timeStamp);
                            },
                            timeLabelTextStyle:
                            const TextStyle(color: Colors.blue),
                            progress: widget.player.position == null
                                ? Duration.zero
                                : widget.player.position,
                            buffered: widget.player.duration,
                            total: widget.player.duration == null
                                ? Duration.zero
                                : widget.player.duration!,
                            onSeek: (duration) {
                              print('User selected a new time: $duration');
                            },
                          ),
                          height: Get.height * .05,
                          width: Get.width * .5,
                        ),
                        (widget.isCreate != true)
                            ? const SizedBox()
                            : IconButton(
                          onPressed: () {
                            Get.find<CreateController>().isEnd.value =
                            false;
                            Get.find<CreateController>().update();
                          },
                          icon: const Icon(
                            Icons.delete_forever_outlined,
                            color: Colors.red,
                          ),
                        ),
                        // SizedBox(
                        //   child: LinearProgressIndicator(
                        //     value: snapshot.data!.inMilliseconds /
                        //         (widget.player.duration?.inMilliseconds ??
                        //             1),
                        //     color: Colors.black,
                        //     backgroundColor: Colors.blue,
                        //   ),
                        //   width: Get.width * .4,
                        //   height: Get.height * .005,
                        // ),
                        // const SizedBox(width: 6),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //   children: [
                        //     Text(
                        //       (widget.player.playing)
                        //           ? prettyDuration(widget.player.position)
                        //           : prettyDuration(widget.player.duration ?? 0.seconds),
                        //       style: const TextStyle(
                        //         fontSize: 10,
                        //         color: Colors.grey,
                        //       ),
                        //     ),
                        //   ],
                        // ),
                      ],
                    );
                  } else {
                    return const LinearProgressIndicator();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String prettyDuration(Duration d) {
    var min = d.inMinutes < 10 ? "0${d.inMinutes}" : d.inMinutes.toString();
    var sec = d.inSeconds < 10 ? "0${d.inSeconds}" : d.inSeconds.toString();
    return min + ":" + sec;
  }
}
