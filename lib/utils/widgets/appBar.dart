import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pawrapet/utils/constants.dart';
import 'package:pawrapet/utils/extensions/buildContext.dart';

enum AppBarType { backWithHeading, heading, home, search, profile, account }

Widget xAppBar(AppBarType type, BuildContext context, {String? text, String? username}) {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: xSize / 4),
    color: xSurface,
    width: xWidth,
    child: Row(
      children: [
        if (type == AppBarType.backWithHeading) ...[
          InkWell(
            onTap: () {
              context.pop();
            },
            child: const Icon(
              CupertinoIcons.back,
              size: xSize,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: xSize / 4),
              child: Text(
                text ?? "",
                style: xTheme.textTheme.titleLarge,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          )
        ],
        if (type == AppBarType.heading)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: xSize / 4),
              child: Text(
                text ?? "",
                style: xTheme.textTheme.titleLarge,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        // profile
        if (type == AppBarType.profile) ...[
          InkWell(
            onTap: () {
              context.pop();
            },
            child: const Icon(
              CupertinoIcons.back,
              size: xSize,
            ),
          ),
          Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.only(right: xSize / 4),
              child: Text(
                text??"",
                style: xTheme.textTheme.titleLarge,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.only(right: xSize / 4),
              child: Text(
                "@$username",
                style: xTheme.textTheme.bodySmall,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.right,
              ),
            ),
          )
        ],
        // home
        if (type == AppBarType.home) ...[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: xSize / 4),
              child: Text(
                text ?? "",
                style: xTheme.textTheme.titleLarge,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: xSize / 4),
            child: Icon(
              CupertinoIcons.slider_horizontal_3,
              size: xSize,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: xSize / 4, right: xSize / 4),
            child: SizedBox(height: xSize, width: xSize, child: SvgPicture.asset("assets/icons/love_pets.svg")),
          ),
        ],
      ],
    ),
  );
}
