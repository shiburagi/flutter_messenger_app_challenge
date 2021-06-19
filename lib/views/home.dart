import 'package:flutter/material.dart';
import 'package:localization/localization.dart';
import 'package:uikit/uikit.dart';

class HomeBottomBar extends StatelessWidget {
  const HomeBottomBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: EdgeInsets.fromLTRB(8, 0, 8, 8),
      child: BottomAppBar(
        notchMargin: 12,
        elevation: 8,
        shape: HomeNotchedRectangle(),
        child: Container(
          height: kToolbarHeight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              buildButton(context, Icons.message, () {}, isActive: true),
              buildButton(context, Icons.call, () {}),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildButton(
    BuildContext context,
    IconData icon,
    VoidCallback onPressed, {
    bool isActive = false,
  }) {
    return Card(
      elevation: isActive ? 6 : 0,
      color: isActive ? Theme.of(context).primaryColor : null,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(16),
          topLeft: Radius.circular(4),
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(4),
        ),
      ),
      child: IconButton(
        icon: Icon(
          icon,
          color: isActive
              ? Theme.of(context).cardColor
              : Theme.of(context).disabledColor,
        ),
        onPressed: onPressed,
      ),
    );
  }
}

class HomeAppBar extends AppBar {
  HomeAppBar(BuildContext context)
      : super(
          centerTitle: true,
          elevation: 0,
          titleSpacing: 4,
          title: Row(
            children: [
              FloatingActionButton(
                heroTag: "appbar_action",
                elevation: 4,
                onPressed: () {},
                child: Icon(Icons.menu),
                backgroundColor: Theme.of(context).cardColor,
                foregroundColor: Theme.of(context).primaryColorDark,
                mini: true,
              ),
              Flexible(
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32)),
                  child: TextField(
                    autofocus: false,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "${S.of(context).search}...",
                      hintStyle: AppTextStyle.regular().copyWith(fontSize: 14),
                      isDense: true,
                      contentPadding: EdgeInsets.fromLTRB(24, 12, 24, 12),
                    ),
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: Theme.of(context).canvasColor,
          foregroundColor: Theme.of(context).primaryColor,
        );
}
