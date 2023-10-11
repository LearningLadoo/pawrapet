import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pawrapet/utils/constants.dart';
import 'package:pawrapet/utils/extensions/sizedBox.dart';

class XBottomNavigatorr extends StatefulWidget {
  Function onChanged;
  int initialIndex;
  XBottomNavigatorr({Key? key, required this.onChanged, required this.initialIndex}) : super(key: key);

  @override
  State<XBottomNavigatorr> createState() => _XBottomNavigatorrState();
}

class _XBottomNavigatorrState extends State<XBottomNavigatorr> {
  int _selectedIndex = 1;
@override
  void initState() {
  _selectedIndex = widget.initialIndex;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: xSize1, left: xSize/4, right: 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // account
          Expanded(
            flex: _selectedIndex==0?5:3,
            child: InkWell(
              borderRadius: BorderRadius.circular(xSize),
              onTap: () {
                setState(() {
                  _selectedIndex = 0;
                });
                widget.onChanged(_selectedIndex);
              },
              child: Opacity(
                opacity: _selectedIndex == 0 ? 1 : 1.00,
                child: Column(
                  children: [
                    Container(
                      height: xSize,
                      decoration: BoxDecoration(
                        color: xPrimary,
                        borderRadius: BorderRadius.circular(xSize),
                      ),
                      child: Row(
                        children: [
                          Container(
                            height: xSize,
                            padding: const EdgeInsets.all(xSize1 * 0.2),
                            child: CircleAvatar(
                              backgroundImage: Image.asset("assets/images/pet1.jpeg").image,
                              radius: xSize / 2 - xSize1 * 0.2,
                            ),
                          ),
                          const SizedBox().horizontal(size: xSize1 * 0.2),
                          Expanded(
                              child: Text(
                            "Bruno",
                            style: xTheme.textTheme.labelLarge!.apply(color: xOnPrimary),
                            overflow: TextOverflow.ellipsis,
                            textAlign: _selectedIndex==0?TextAlign.center:TextAlign.left,
                          )),
                          if(_selectedIndex==0)InkWell(
                            onTap: () {
                              // todo open different accounts and change them
                            },
                            child: Icon(
                              Icons.expand_circle_down,
                              color: xOnPrimary.withOpacity((_selectedIndex == 0) ? 0.3 : 0.15),
                              size: xSize - xSize1 * 0.2,
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox().vertical(size: xSize1 / 2),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 100),
                      height: xSize1 * 0.5,
                      width: _selectedIndex == 0 ? xSize * 2 : 0,
                      decoration: BoxDecoration(
                        color: xPrimary,
                        borderRadius: BorderRadius.circular(xSize),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          // home
          Expanded(
            flex: 2,
            child: InkWell(
              borderRadius: BorderRadius.circular(xSize),
              onTap: () {
                setState(() {
                  _selectedIndex = 1;
                });
                widget.onChanged(_selectedIndex);
              },
              child: Opacity(
                opacity: _selectedIndex == 1 ? 1 : 1.00,
                child: Column(
                  children: [
                    const SizedBox(
                      height: xSize,
                      child: FittedBox(
                        child: Icon(
                          CupertinoIcons.house_alt_fill,
                          color: xPrimary,
                        ),
                      ),
                    ),
                    const SizedBox().vertical(size: xSize1 / 2),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 100),
                      height: xSize1 * 0.5,
                      width: _selectedIndex == 1 ? xSize * 0.8 : 0,
                      decoration: BoxDecoration(
                        color: xPrimary,
                        borderRadius: BorderRadius.circular(xSize),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          // pet shop
          Expanded(
            flex: 2,
            child: InkWell(
              borderRadius: BorderRadius.circular(xSize),
              onTap: () {
                setState(() {
                  _selectedIndex = 2;
                });
                widget.onChanged(_selectedIndex);
              },
              child: Opacity(
                opacity: _selectedIndex == 2 ? 1 : 1.00,
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.only(top: xSize1*0.3),
                      height: xSize*0.94,
                      child: SvgPicture.asset("assets/icons/essentialsIcon.svg"),
                    ),
                    const SizedBox().vertical(size: xSize1/2),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 100),
                      height: xSize1*0.5,
                      width: _selectedIndex==2?xSize*0.8:0,
                      decoration: BoxDecoration(
                        color: xPrimary,
                        borderRadius: BorderRadius.circular(xSize),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          // notification
          Expanded(
            flex: 2,
            child: InkWell(
              borderRadius: BorderRadius.circular(xSize),
              onTap: () {
                setState(() {
                  _selectedIndex = 3;
                });
                widget.onChanged(_selectedIndex);
              },
              child: Opacity(
                opacity: _selectedIndex == 3 ? 1 : 1.00,
                child: Column(
                  children: [
                    const SizedBox(
                      height: xSize,
                      child: FittedBox(
                        child: Icon(
                          Icons.notifications_rounded,
                          color: xPrimary,
                        ),
                      ),
                    ),
                    const SizedBox().vertical(size: xSize1 / 2),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 100),
                      height: xSize1 * 0.5,
                      width: _selectedIndex == 3 ? xSize * 0.8 : 0,
                      decoration: BoxDecoration(
                        color: xPrimary,
                        borderRadius: BorderRadius.circular(xSize),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          // search
          Expanded(
            flex: 2,
            child: InkWell(
              borderRadius: BorderRadius.circular(xSize),
              onTap: () {
                setState(() {
                  _selectedIndex = 4;
                });
                widget.onChanged(_selectedIndex);
              },
              child: Opacity(
                opacity: _selectedIndex == 4 ? 1 : 1.00,
                child: Column(
                  children: [
                    const SizedBox(
                      height: xSize,
                      child: FittedBox(
                        child: Icon(
                          Icons.person_search_rounded,
                          color: xPrimary,
                        ),
                      ),
                    ),
                    const SizedBox().vertical(size: xSize1 / 2),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 100),
                      height: xSize1 * 0.5,
                      width: _selectedIndex == 4 ? xSize * 0.8 : 0,
                      decoration: BoxDecoration(
                        color: xPrimary,
                        borderRadius: BorderRadius.circular(xSize),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class XBottomNavigator extends StatefulWidget {
  Function onChanged;
  int initialIndex;
  XBottomNavigator({Key? key, required this.onChanged, required this.initialIndex}) : super(key: key);

  @override
  State<XBottomNavigator> createState() => _XBottomNavigatorState();
}

class _XBottomNavigatorState extends State<XBottomNavigator> {
  int _selectedIndex = 1;
  @override
  void initState() {
    _selectedIndex = widget.initialIndex;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: xSize1, left: xSize/2, right: xSize/2),
      child: Opacity(
        opacity: 0.9,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // account
            InkWell(
              borderRadius: BorderRadius.circular(xSize),
              onTap: () {
                setState(() {
                  _selectedIndex = 0;
                });
                widget.onChanged(_selectedIndex);
              },
              child: Column(
                children: [
                  Container(
                    constraints: BoxConstraints(maxWidth: xWidth*0.2+xSize*(2.2)),
                    height: xSize,
                    decoration: BoxDecoration(
                      color: xPrimary,
                      borderRadius: BorderRadius.circular(xSize),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: xSize*0.1),
                          child: CircleAvatar(
                            backgroundImage: Image.asset("assets/images/pet1.jpeg").image,
                            radius: xSize*0.4,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: xSize*0.1),
                          constraints: BoxConstraints(maxWidth: xWidth*0.2),
                          child: Text(
                            "Bruno",
                            style: xTheme.textTheme.labelLarge!.apply(color: xOnPrimary.withOpacity(0.9)),
                            overflow: TextOverflow.ellipsis,
                            textAlign: _selectedIndex==0?TextAlign.center:TextAlign.left,
                          ),
                        ),
                        if(_selectedIndex!=0) SizedBox().horizontal(size: xSize/8),
                        if(_selectedIndex==0)InkWell(
                          onTap: () {
                            // todo open different accounts and change them
                          },
                          child: Container(
                            width: xSize*0.5*2,
                            padding: EdgeInsets.only(right:xSize*0.05),
                            child: FittedBox(
                              child: Icon(
                                Icons.expand_circle_down,
                                color: xOnPrimary.withOpacity((_selectedIndex == 0) ? 0.3 : 0.15),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox().vertical(size: xSize1 / 2),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 100),
                    height: xSize1 * 0.5,
                    width: _selectedIndex == 0 ? xSize * 2 : 0,
                    decoration: BoxDecoration(
                      color: xPrimary,
                      borderRadius: BorderRadius.circular(xSize),
                    ),
                  )
                ],
              ),
            ),
            // home
            InkWell(
              borderRadius: BorderRadius.circular(xSize),
              onTap: () {
                setState(() {
                  _selectedIndex = 1;
                });
                widget.onChanged(_selectedIndex);
              },
              child: Column(
                children: [
                  const SizedBox(
                    height: xSize,
                    child: FittedBox(
                      child: Icon(
                        CupertinoIcons.house_alt_fill,
                        color: xPrimary,
                      ),
                    ),
                  ),
                  const SizedBox().vertical(size: xSize1 / 2),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 100),
                    height: xSize1 * 0.5,
                    width: _selectedIndex == 1 ? xSize * 0.8 : 0,
                    decoration: BoxDecoration(
                      color: xPrimary,
                      borderRadius: BorderRadius.circular(xSize),
                    ),
                  )
                ],
              ),
            ),
            // pet shop
            InkWell(
              borderRadius: BorderRadius.circular(xSize),
              onTap: () {
                setState(() {
                  _selectedIndex = 2;
                });
                widget.onChanged(_selectedIndex);
              },
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.only(top: xSize1*0.3),
                    height: xSize*0.94,
                    width: xSize*0.94,
                    child: SvgPicture.asset("assets/icons/essentialsIcon.svg"),
                  ),
                  const SizedBox().vertical(size: xSize1/2),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 100),
                    height: xSize1*0.5,
                    width: _selectedIndex==2?xSize*0.8:0,
                    decoration: BoxDecoration(
                      color: xPrimary,
                      borderRadius: BorderRadius.circular(xSize),
                    ),
                  )
                ],
              ),
            ),
            // notification
            InkWell(
              borderRadius: BorderRadius.circular(xSize),
              onTap: () {
                setState(() {
                  _selectedIndex = 3;
                });
                widget.onChanged(_selectedIndex);
              },
              child: Opacity(
                opacity: _selectedIndex == 3 ? 1 : 1.00,
                child: Column(
                  children: [
                    const SizedBox(
                      height: xSize,
                      child: FittedBox(
                        child: Icon(
                          Icons.notifications_rounded,
                          color: xPrimary,
                        ),
                      ),
                    ),
                    const SizedBox().vertical(size: xSize1 / 2),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 100),
                      height: xSize1 * 0.5,
                      width: _selectedIndex == 3 ? xSize * 0.8 : 0,
                      decoration: BoxDecoration(
                        color: xPrimary,
                        borderRadius: BorderRadius.circular(xSize),
                      ),
                    )
                  ],
                ),
              ),
            ),
            // search
            InkWell(
              borderRadius: BorderRadius.circular(xSize),
              onTap: () {
                setState(() {
                  _selectedIndex = 4;
                });
                widget.onChanged(_selectedIndex);
              },
              child: Opacity(
                opacity: _selectedIndex == 4 ? 1 : 1.00,
                child: Column(
                  children: [
                    const SizedBox(
                      height: xSize,
                      child: FittedBox(
                        child: Icon(
                          Icons.person_search_rounded,
                          color: xPrimary,
                        ),
                      ),
                    ),
                    const SizedBox().vertical(size: xSize1 / 2),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 100),
                      height: xSize1 * 0.5,
                      width: _selectedIndex == 4 ? xSize * 0.8 : 0,
                      decoration: BoxDecoration(
                        color: xPrimary,
                        borderRadius: BorderRadius.circular(xSize),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}