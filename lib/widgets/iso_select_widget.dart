
import 'package:flutter/widgets.dart';
import 'package:lightmeter/widgets/display_value_widget.dart';

class IsoSelectWidget extends StatelessWidget {
  const IsoSelectWidget({
    super.key,
    required this.iso,
     this.onIsoChanged,
  });
  final int iso;
  final ValueChanged<int>? onIsoChanged;
  @override
  Widget build(BuildContext context) {
    return  DisplayValueWidget(
            label: 'ISO',
            value: iso.toDouble(),
            fractionDigits: 0,
          );
  }
}