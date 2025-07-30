import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:app_lorry/config/configs.dart';
import 'package:app_lorry/models/models.dart';
import 'package:app_lorry/widgets/widgets.dart';

class TireDragItem extends StatefulWidget {
  final TireTest tire;
  final bool ispaced;
  const TireDragItem({super.key, required this.tire, this.ispaced = false});

  @override
  State<TireDragItem> createState() => _TireDragItemState();
}

class _TireDragItemState extends State<TireDragItem> {
  @override
  Widget build(BuildContext contextf) {


    double screenwidth = MediaQuery.of(context).size.width ;

    return Column(
      children: [
        Text("P${widget.tire.id}",style:const TextStyle(color: Apptheme.secondary,fontWeight: FontWeight.bold,fontSize: 15)),
        if (widget.tire.newPosition == null)
          Draggable(
            data: widget.tire.id,
            feedback: ItemTire(tire: widget.tire,),
            childWhenDragging:_childWhenDragging(id:widget.tire.id),
            onDragEnd: (details) {
              print("onDragEnd");
              print(details.wasAccepted);
              setState(() {
                
              });
            },
            child: ItemTire(tire: widget.tire,),
          ),
        if (widget.tire.newPosition != null)
          _childWhenDragging(id:widget.tire.id),
        if (widget.ispaced)
         const SizedBox(width: 50)
      ],
    );
  }
}

class _childWhenDragging extends StatelessWidget {
  int id;
  
  _childWhenDragging({
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    double screenwidth = MediaQuery.of(context).size.width ;
 
    return Container(
      margin:const EdgeInsets.all(5),
      child: DottedBorder(
        radius: Radius.circular(12),
        dashPattern: [8, 4],
        color: Apptheme.secondary,
        borderType: BorderType.RRect,
        strokeWidth:4,
        padding: EdgeInsets.all(0),
        child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        child: Container(
          width: screenwidth*0.08,
          height: 64,
          color: Apptheme.lightGreen,
          child: Center(child: Text("P$id",style:const TextStyle(color: Apptheme.secondary,fontWeight: FontWeight.bold,fontSize: 15)),),
        ))),
    );
  }
}


