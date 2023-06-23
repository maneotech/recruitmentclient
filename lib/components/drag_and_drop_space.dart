import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter/material.dart';


class PDFDragAndDropSpace extends StatefulWidget {
  final Function()? onTap;
  final Function(List<String>)? onResult;
  const PDFDragAndDropSpace({super.key, this.onTap, this.onResult});

  @override
  State<PDFDragAndDropSpace> createState() => _PDFDragAndDropSpaceState();
}

class _PDFDragAndDropSpaceState extends State<PDFDragAndDropSpace> {
  bool _dragging = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 200,
          width: 200,
          child: GestureDetector(onTap: () => onTap() ,child: getDragTargetElement()),
        ),
      ],
    );
  }

  onTap(){
    if (widget.onTap != null){
      widget.onTap!();
    }
  }

  DropTarget getDragTargetElement() {
    return DropTarget(
      onDragDone: (detail) {
        List<String> filepaths = [];
        for (var file in detail.files) {
          String lowercaseFilePath = file.path.toLowerCase();
          if (lowercaseFilePath.endsWith(".pdf")) {
            filepaths.add(file.path);
          }
        }

        sendResult(filepaths);
      },
      onDragEntered: (detail) {
        setState(() {
          _dragging = true;
        });
      },
      onDragExited: (detail) {
        setState(() {
          _dragging = false;
        });
      },
      child: Container(
        height: 200,
        width: 200,
        color: _dragging ? Colors.blue.withOpacity(0.4) : Colors.black26,
        child: const Center(
          child: Text("Drop here or click"),
        ),
      ),
    );
  }

  sendResult(List<String> filepaths) {
    if (widget.onResult != null){
      widget.onResult!(filepaths);
    }
  }
}
