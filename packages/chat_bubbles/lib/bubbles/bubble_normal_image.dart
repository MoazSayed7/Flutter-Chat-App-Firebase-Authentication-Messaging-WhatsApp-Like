import 'package:flutter/material.dart';

const double BUBBLE_RADIUS_IMAGE = 16;

///basic image bubble type
///
///
/// image bubble should have [id] to work with Hero animations
/// [id] must be a unique value
///chat bubble [BorderRadius] can be customized using [bubbleRadius]
///chat bubble color can be customized using [color]
///chat bubble tail can be customized  using [tail]
///chat bubble display image can be changed using [image]
///[image] is a required parameter
///[id] must be an unique value for each other
///[id] is also a required parameter
///message sender can be changed using [isSender]
///[sent],[delivered] and [seen] can be used to display the message state

class BubbleNormalImage extends StatelessWidget {
  static const loadingWidget = Center(
    child: CircularProgressIndicator(),
  );

  final String id;
  final Widget image;

  final double bubbleRadius;
  final bool isSender;
  final bool isArabicApp;

  final Color color;
  final bool tail;
  final bool sent;
  final bool delivered;
  final bool seen;
  final void Function()? onTap;
  final void Function()? onPressDownload;

  const BubbleNormalImage({
    Key? key,
    required this.id,
    required this.image,
    this.bubbleRadius = BUBBLE_RADIUS_IMAGE,
    this.isSender = true,
    this.isArabicApp = false,
    this.color = Colors.white70,
    this.tail = true,
    this.sent = false,
    this.delivered = false,
    this.seen = false,
    this.onTap,
    this.onPressDownload,
  }) : super(key: key);

  /// image bubble builder method
  @override
  Widget build(BuildContext context) {
    bool stateTick = false;
    Icon? stateIcon;
    if (sent) {
      stateTick = true;
      stateIcon = const Icon(
        Icons.done,
        size: 18,
        color: Color(0xFF97AD8E),
      );
    }
    if (delivered) {
      stateTick = true;
      stateIcon = const Icon(
        Icons.done_all,
        size: 18,
        color: Color(0xFF97AD8E),
      );
    }
    if (seen) {
      stateTick = true;
      stateIcon = const Icon(
        Icons.done_all,
        size: 18,
        color: Color(0xFF92DEDA),
      );
    }

    return Row(
      children: <Widget>[
        isSender
            ? const Expanded(
                child: SizedBox(
                  width: 5,
                ),
              )
            : Container(),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: Container(
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * .5,
                maxHeight: MediaQuery.of(context).size.width * .5),
            child: GestureDetector(
                onTap: onTap ??
                    () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) {
                        return _DetailScreen(
                          tag: id,
                          image: image,
                          isAppArabic: isArabicApp,
                          isReciver: !isSender,
                          onPressed: onPressDownload,
                        );
                      }));
                    },
                child: Hero(
                  tag: id,
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(bubbleRadius),
                            topRight: Radius.circular(bubbleRadius),
                            bottomLeft: Radius.circular(
                              tail
                                  ? isSender
                                      ? isArabicApp
                                          ? 0
                                          : bubbleRadius
                                      : isArabicApp
                                          ? bubbleRadius
                                          : 0
                                  : BUBBLE_RADIUS_IMAGE,
                            ),
                            bottomRight: Radius.circular(
                              tail
                                  ? isSender
                                      ? isArabicApp
                                          ? bubbleRadius
                                          : 0
                                      : isArabicApp
                                          ? 0
                                          : bubbleRadius
                                  : BUBBLE_RADIUS_IMAGE,
                            ),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(bubbleRadius),
                            child: image,
                          ),
                        ),
                      ),
                      stateIcon != null && stateTick
                          ? Positioned(
                              bottom: 4,
                              right: 6,
                              child: stateIcon,
                            )
                          : const SizedBox(
                              width: 1,
                            ),
                    ],
                  ),
                )),
          ),
        )
      ],
    );
  }
}

/// detail screen of the image, display when tap on the image bubble
class _DetailScreen extends StatefulWidget {
  final String tag;
  final Widget image;
  final bool isAppArabic;
  final void Function()? onPressed;
  final bool isReciver;
  const _DetailScreen(
      {Key? key,
      required this.tag,
      required this.image,
      required this.isAppArabic,
      required this.isReciver,
      this.onPressed})
      : super(key: key);

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

/// created using the Hero Widget
class _DetailScreenState extends State<_DetailScreen> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Scaffold(
        appBar: AppBar(),
        floatingActionButtonLocation: widget.isAppArabic
            ? FloatingActionButtonLocation.startFloat
            : FloatingActionButtonLocation.endFloat,
        floatingActionButton: widget.isReciver
            ? Container(
                decoration: const BoxDecoration(
                  color: Color(0xff00a884),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  onPressed: widget.onPressed,
                  icon: const Icon(
                    Icons.download_rounded,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              )
            : const SizedBox.shrink(),
        body: Center(
          child: Hero(
            tag: widget.tag,
            child: widget.image,
          ),
        ),
      ),
      onTap: () {
        Navigator.pop(context);
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  initState() {
    super.initState();
  }
}
