import 'package:firebase_storage/firebase_storage.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';

class Uploader extends StatefulWidget {
  final StorageUploadTask uploadTask;
  final Function onComplete;

  Uploader(this.uploadTask, this.onComplete);

  @override
  _UploaderState createState() => _UploaderState();
}

class _UploaderState extends State<Uploader> {
  int opacity = 1;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder<StorageTaskEvent>(
          stream: widget.uploadTask.events,
          builder: (context, snapshot) {
            var event = snapshot?.data?.snapshot;

            double progressPercent = event != null
                ? event.bytesTransferred / event.totalByteCount
                : 0;

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: widget.uploadTask.isComplete
                  ? uploadTaskCompleted()
                  : uploadTaskInProgress(progressPercent),
            );
          }),
    );
  }

  uploadTaskInProgress(double progressPercent) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text('${(progressPercent * 100).toStringAsFixed(2)}%'),
        SizedBox(
          height: 10,
        ),
        LinearProgressIndicator(
          value: progressPercent,
        )
      ],
    );
  }

  uploadTaskCompleted() {
    widget.onComplete();
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          height: 100,
          width: 100,
          child: FlareActor(
            "assets/success_check.flr",
            alignment: Alignment.center,
            fit: BoxFit.contain,
            animation: "play",
          ),
        ),
      ],
    );
  }
}
