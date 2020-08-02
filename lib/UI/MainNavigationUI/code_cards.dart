import 'package:codecards/Services/notesServices/noteAPIService.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:codecards/routes/slideFromRight.dart';
import 'package:codecards/Services/notesServices/noteData.dart';
import 'package:codecards/Shared/Colors.dart';
import 'package:codecards/UI/Settings/settings2.dart';
import 'Bloc/navigation_bloc.dart';
import 'CardsLogic/cards.dart';
import 'Notes/noteTile.dart';
import 'Notes/noteView.dart';

class CodeCards extends StatefulWidget with NavigationStates {
  final Function onMenuTap;

  const CodeCards({Key key, this.onMenuTap}) : super(key: key);

  @override
  _CodeCardsState createState() => _CodeCardsState();
}

class _CodeCardsState extends State<CodeCards> {

  NoteAPIServerClass noteAPIServerClass = NoteAPIServerClass();
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double currentWidth = constraints.constrainWidth();
        double maxWidth = MediaQuery.of(context).size.width;
        bool border;
        if (maxWidth == currentWidth) {
          border = false;
        } else {
          border = true;
        }
        return Container(
          decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    color: PopBlue.withOpacity(0.4),
                    blurRadius: 8,
                    spreadRadius: 1)
              ],
              borderRadius:
                  border ? BorderRadius.circular(40) : BorderRadius.circular(0),
              color: Grey),
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: border == true
                  ? EdgeInsets.only(top: 30, left: 15)
                  : EdgeInsets.only(top: 30),
              child: Scaffold(
                body: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: border == true
                              ? EdgeInsets.only(left: 5)
                              : EdgeInsets.only(left: 16),
                          child: GestureDetector(
                            onTap: widget.onMenuTap,
                            child: Icon(
                              Icons.menu,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: IconButton(
                              splashColor: LightPopBlue.withOpacity(0.5),
                              hoverColor: LightPopBlue,
                              highlightColor: Colors.transparent,
                              icon: Icon(
                                Icons.settings,
                                color: Colors.white,
                                size: 25,
                              ),
                              onPressed: () {
                                Navigator.push(context,
                                    SlideFromRightPageRoute(page: Settings()));
                              }),
                        )
                      ],
                    ),
                    Expanded(
                      child: Container(
                        child: Stack(
                          children: [
                            IgnorePointer(
                              ignoring: border == true ? true : false,
                              child: Container(
                                padding: EdgeInsets.only(bottom: 75, top: 10),
                                child: CardsStack(),
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Padding(
                                padding: EdgeInsets.only(bottom: 0),
                                child: Padding(
                                  padding: border == true
                                      ? EdgeInsets.symmetric(horizontal: 25)
                                      : EdgeInsets.symmetric(horizontal: 0),
                                  child: Stack(
                                    children: [
                                      Align(
                                        alignment: Alignment.bottomCenter,
                                        child: Padding(
                                          padding: EdgeInsets.only(bottom: 5),
                                          child: GestureDetector(
                                            onTap: () {
                                              _bringUpNotesSheet(context);
                                            },
                                            child: Container(
                                              height: 60,
                                              width: 60,
                                              decoration: BoxDecoration(
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.white24,
                                                    offset: Offset(0, 0),
                                                    blurRadius: 7,
                                                  )
                                                ],
                                                borderRadius: BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(12),
                                                    bottomLeft:
                                                        Radius.circular(12),
                                                    topRight:
                                                        Radius.circular(12),
                                                    bottomRight:
                                                        Radius.circular(12)),
                                                gradient: LinearGradient(
                                                    colors: [
                                                      Theme.of(context)
                                                          .primaryColor,
                                                      Theme.of(context)
                                                          .primaryColorLight
                                                    ],
                                                    begin: FractionalOffset
                                                        .topLeft,
                                                    end: FractionalOffset
                                                        .bottomRight,
                                                    tileMode:
                                                        TileMode.repeated),
                                              ),
                                              child: Center(
                                                child: Icon(
                                                  Icons.add,
                                                  color: White,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _bringUpNotesSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext bc) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setStatee) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.8,
              decoration: BoxDecoration(
                  color: Grey,
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(15))),
              child: Scaffold(
                body: Stack(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 55,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white24,
                            offset: Offset(0, 0),
                            blurRadius: 10,
                          )
                        ],
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                        ),
                        gradient: LinearGradient(
                            colors: [
                              Theme.of(context).primaryColor,
                              Theme.of(context).primaryColorLight
                            ],
                            begin: FractionalOffset.topLeft,
                            end: FractionalOffset.topRight,
                            tileMode: TileMode.repeated),
                      ),
                      child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              'Notes',
                              style: TextStyle(
                                  color: Grey.withOpacity(0.9),
                                  fontSize: 30,
                                  fontFamily: 'Nunito Black'),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: IconButton(
                                onPressed: () {},
                                icon: Icon(
                                  Icons.star_border,
                                  color: Grey,
                                  size: 30,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(top: 70),
                            child: FutureBuilder(
                              future:
                                  Provider.of<NoteData>(context).getNoteList(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return ListView.builder(
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      return NoteTile(titleIndex: index);
                                    },
                                    itemCount: Provider.of<NoteData>(context)
                                        .noteCount,
                                  );
                                } else {
                                  return Center(
                                      child: CircularProgressIndicator(
                                    strokeWidth: 1,
                                  ));
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: EdgeInsets.only(right: 10, bottom: 10),
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => NoteView(
                                  noteMode: NoteModes.Adding,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            height: 60,
                            width: 60,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(60),
                              gradient: LinearGradient(
                                  colors: [
                                    Theme.of(context).primaryColor,
                                    Theme.of(context).primaryColorLight
                                  ],
                                  begin: FractionalOffset.topLeft,
                                  end: FractionalOffset.topRight,
                                  tileMode: TileMode.repeated),
                            ),
                            child: Icon(
                              Icons.add,
                              color: White,
                              size: 30,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class IconCardButton extends StatelessWidget {
  final IconData iconData;
  final String buttonTag;
  final Function buttonFunction;
  final Color color;

  const IconCardButton(
      {Key key, this.iconData, this.buttonTag, this.buttonFunction, this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: buttonFunction,
      child: Container(
        height: 40,
        width: 100,
        decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              bottomLeft: Radius.circular(20),
              topRight: Radius.circular(20),
              bottomRight: Radius.circular(20)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(
              iconData,
              color: color,
            ),
            Text(
              buttonTag,
              style: TextStyle(
                  color: color, fontSize: 16, fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }
}
