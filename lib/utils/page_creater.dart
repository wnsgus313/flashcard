import 'package:flutter/material.dart';

class PageCreator{
  // 둥근 Textfield Widget.
  static Widget makeCircularTextField({required BuildContext context, required TextEditingController? controller, required String placeholder, int minLines = 8}) {
    return TextField(
      controller: controller,
      style: Theme.of(context).textTheme.bodyText1,
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(
              width: 2.0, color: Theme.of(context).secondaryHeaderColor,
          ),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
        hintStyle: const TextStyle(color: Colors.grey),
        hintText: placeholder,
      ),
      maxLines: null,
      minLines: 8,
    );
  }

  // 답안용 둥근 Textfield Widget.
  static Widget makeCircularReadOnlyTextField({required BuildContext context, required TextEditingController? controller, required String placeholder, int minLines = 8}) {
    return TextField(
      controller: controller,
      style: Theme.of(context).textTheme.bodyText1,
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(
            width: 2.0, color: Theme.of(context).secondaryHeaderColor,
          ),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
        hintStyle: const TextStyle(color: Colors.grey),
        hintText: placeholder,
      ),
      maxLines: null,
      minLines: 8,
      readOnly: true,
    );
  }
  static Widget makeCircularReadOnlyBackTextField({required BuildContext context, required TextEditingController? controller, required String placeholder, int minLines = 8, required String text}) {
    bool visible = false;

    return TextField(
      controller: controller,
      style: Theme.of(context).textTheme.bodyText1,
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(
            width: 2.0, color: Theme.of(context).secondaryHeaderColor,
          ),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
        hintStyle: const TextStyle(color: Colors.grey),
        hintText: placeholder,
      ),
      maxLines: null,
      minLines: 8,
      readOnly: true,
      onTap: (){
        if(!visible){
          visible = !visible;
          controller?.text = text;
        }
        else {
          visible = !visible;
          controller?.text = "";
        }
      },
    );
  }
}