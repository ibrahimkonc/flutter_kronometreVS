import 'dart:async';
import 'package:flutter/material.dart';

class IHome extends StatefulWidget {
  const IHome({super.key});

  @override
  State<IHome> createState() => _IHomeState();
}

class _IHomeState extends State<IHome> with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;

  Timer? timer;
  Duration duration = Duration.zero;
  List<Duration> laps = [];
  int total = 0;

  bool get isStop => timer == null;
  bool get isActive => (timer != null && timer!.isActive);

  add() {
    Duration dur = duration;
    laps.add(dur);
    setState(() {});
  }

  start() {
    if (isStop || !isActive) {
      controller.forward();
      if (isStop) laps.clear();
      timer = Timer.periodic(const Duration(milliseconds: 1), (_timer) {
        duration = Duration(milliseconds: total + _timer.tick);
        setState(() {});
      });
    } else {
      controller.reverse();
      pause();
    }
  }

  pause() {
    if (!isStop) {
      total += timer!.tick;
      timer!.cancel();
    }
  }

  stop() {
    if (!isStop) {
      laps.clear();
      timer!.cancel();
      timer = null;
      total = 0;
      controller.reverse();
      duration = Duration.zero;
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    animation = Tween<double>(begin: 0.0, end: 1.0).animate(controller);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // ignore: avoid_unnecessary_containers
            Container(
              child: Text(
                (duration).toString(),
                style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
                child: Container(
              // ignore: prefer_const_constructors
              margin: EdgeInsets.all(10),
              // ignore: prefer_const_constructors
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.blueGrey),
                  borderRadius: BorderRadius.circular(15)),
              child: ListView.builder(
                itemCount: laps.length,
                itemBuilder: (context, index) => Container(
                  decoration: BoxDecoration(
                      border:
                          Border.all(color: Color.fromARGB(255, 255, 0, 217)),
                      borderRadius: BorderRadius.circular(15)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("${index + 1}"),
                      // ignore: prefer_const_constructors
                      SizedBox(
                        width: 10,
                      ),
                      Text("${laps[index]}"),
                      SizedBox(width: 50),
                      Expanded(child: Text("${laps[index]}")),

                      // ignore: prefer_const_constructors
                      Icon(Icons.arrow_forward_ios)
                    ],
                  ),
                ),
              ),
            )

                // children: laps.map((e) => Text(e.toString())).toList(),
                ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if (!isStop)
                  IconButton(
                      onPressed: () {
                        stop();
                      },
                      icon: Icon(Icons.stop)),
                IconButton(
                    onPressed: () {
                      start();
                    },
                    icon: AnimatedIcon(
                      icon: AnimatedIcons.play_pause,
                      progress: animation,
                    )),
                if (!isStop)
                  IconButton(
                      onPressed: () {
                        add();
                      },
                      icon: Icon(Icons.flag)),
              ],
            )
          ],
        ),
      ),
    );
  }
}
