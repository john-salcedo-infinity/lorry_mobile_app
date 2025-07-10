
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_lorry/config/app_theme.dart';
import 'package:app_lorry/models/models.dart';
import 'package:app_lorry/providers/app/rotation/rotationProvider.dart';
import 'package:app_lorry/widgets/items/ItemTite.dart';

class TireDragTarget extends ConsumerStatefulWidget {
  TireTest tire;
  DragTargetAcceptWithDetails<int> onAcceptWithDetails;
   TireDragTarget({
    required this.tire,
    required this.onAcceptWithDetails,
    super.key
    });

  @override
  _TireDragTargetState createState() => _TireDragTargetState();
}

class _TireDragTargetState extends ConsumerState<TireDragTarget> {
  
  @override
  Widget build(BuildContext context ) {
    final TireMovedPositionss = ref.watch(tireMovedPositionsProvider);
    final tires = ref.watch(tireListProvider);
    double screenwidth = MediaQuery.of(context).size.width ;

    return DragTarget<int>(
      key: ValueKey(widget.tire.id),
          builder: (
            BuildContext context,
            List<dynamic> accepted,
            List<dynamic> rejected,
          ) {
            return Column(
              children: [
                if(!TireMovedPositionss.contains(widget.tire.id))
                Container(
                  margin:const EdgeInsets.symmetric(horizontal: 12,vertical: 6),
                  child: DottedBorder(
                    radius: const Radius.circular(12),
                    dashPattern:const [8, 4],
                    color: Apptheme.darkorange,
                    borderType: BorderType.RRect,
                    strokeWidth:4,
                    padding:const EdgeInsets.all(0),
                    child: ClipRRect(
                    borderRadius:const BorderRadius.all(Radius.circular(12)),
                    child: Container(
                      width: screenwidth*0.08,
                      height: 64,
                      color: Apptheme.lightOrange2,
                      child: Center(child: Text("P${widget.tire.id}",style:const TextStyle(color: Apptheme.darkorange,fontWeight: FontWeight.bold,fontSize: 15)),),
                    ))),
                ),
                if (TireMovedPositionss.contains(widget.tire.id))
                ItemTire(tire: widget.tire,),
              ],
            );
          },
          onAcceptWithDetails: (details) {
            widget.onAcceptWithDetails(details);
            print("erda");
            setState(() {
              
            });
          },
        );
  }
}