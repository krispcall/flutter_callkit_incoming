import "package:flutter/material.dart";
import "package:mvp/api/common/Status.dart";
import "package:mvp/config/CustomColors.dart";

class CustomLinearProgressIndicator extends StatelessWidget {
  const CustomLinearProgressIndicator(this.status);
  final Status status;

  @override
  Widget build(BuildContext context) {
    return Align(
      child: Opacity(
        opacity: status == Status.PROGRESS_LOADING ? 1 : 0,
        child: LinearProgressIndicator(
          backgroundColor: CustomColors.white,
          color: CustomColors.mainColor,
        ),
      ),
    );
  }
}
