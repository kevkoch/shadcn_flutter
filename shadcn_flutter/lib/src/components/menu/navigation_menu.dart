import 'package:shadcn_flutter/shadcn_flutter.dart';

class NavigationItem extends StatefulWidget {
  final VoidCallback? onPressed;
  final Widget? content;
  final Widget child;

  const NavigationItem({this.onPressed, this.content, required this.child});

  @override
  State<NavigationItem> createState() => NavigationItemState();
}

class NavigationItemState extends State<NavigationItem> {
  static const Duration kDebounceDuration = Duration(milliseconds: 500);
  NavigationMenuState? _menuState;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    var newMenuState = Data.maybeOf<NavigationMenuState>(context);
    assert(newMenuState != null,
        'NavigationItem must be a descendant of NavigationMenu');
    if (_menuState != newMenuState) {
      _menuState = newMenuState;
      if (widget.content != null) {
        _menuState!._attachContentBuilder(
          this,
          (context) {
            return widget.content!;
          },
        );
      }
    }
  }

  @override
  void didUpdateWidget(covariant NavigationItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.content != oldWidget.content) {
      if (widget.content != null) {
        _menuState!._attachContentBuilder(
          this,
          (context) {
            return widget.content!;
          },
        );
      } else {
        _menuState!._contentBuilders.remove(this);
      }
    }
  }

  @override
  void dispose() {
    if (widget.content != null) {
      _menuState!._contentBuilders.remove(this);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AnimatedBuilder(
        animation: Listenable.merge(
            [_menuState!._activeIndex, _menuState!._popoverController]),
        builder: (context, child) {
          return Button(
            style: const ButtonStyle.ghost().copyWith(
              decoration: (context, states, value) {
                if (_menuState!.isActive(this)) {
                  return (value as BoxDecoration).copyWith(
                    borderRadius: BorderRadius.circular(theme.radiusMd),
                    color: theme.colorScheme.muted.withOpacity(0.8),
                  );
                }
                return value;
              },
            ),
            child: widget.child,
            trailing: widget.content != null
                ? AnimatedRotation(
                    duration: kDefaultDuration,
                    turns: _menuState!.isActive(this) ? 0.5 : 0,
                    child: const Icon(
                      RadixIcons.chevronDown,
                      size: 12,
                    ),
                  )
                : null,
            onHover: (hovered) {
              if (hovered) {
                _menuState!._activate(this);
              }
            },
            onPressed: () {
              if (widget.onPressed != null) {
                widget.onPressed!();
              }
              if (widget.content != null) {
                _menuState!._activate(this);
              }
            },
          );
        });
  }
}

class NavigationContent extends StatelessWidget {
  final Widget child;

  const NavigationContent({required this.child});

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}

class NavigationContentList extends StatelessWidget {
  final Widget? primary;
  final List<Widget> children;

  const NavigationContentList({this.primary, required this.children});

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}

class NavigationContentItem extends StatelessWidget {
  final Widget? icon;
  final Widget title;
  final Widget content;

  const NavigationContentItem(
      {this.icon, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}

class NavigationMenu extends StatefulWidget {
  final List<Widget> children;

  const NavigationMenu({required this.children});

  @override
  State<NavigationMenu> createState() => NavigationMenuState();
}

class NavigationMenuState extends State<NavigationMenu> {
  final PopoverController _popoverController = PopoverController();
  final ValueNotifier<int> _activeIndex = ValueNotifier(0);
  final Map<NavigationItemState, WidgetBuilder> _contentBuilders = {};

  int _hoverCount = 0;

  bool _hovered = false;
  bool _popoverHovered = false;

  void _attachContentBuilder(NavigationItemState key, WidgetBuilder builder) {
    _contentBuilders[key] = builder;
  }

  bool isActive(NavigationItemState item) {
    return _popoverController.hasOpenPopovers &&
        widget.children[_activeIndex.value] == item.widget;
  }

  @override
  void dispose() {
    _popoverController.closeLater();
    _activeIndex.dispose();
    _popoverController.dispose();
    super.dispose();
  }

  void _show() {
    if (_popoverController.hasOpenPopovers) {
      return;
    }
    _popoverController.show(
      builder: buildPopover,
      alignment: Alignment.topLeft,
      anchorAlignment: Alignment.bottomLeft,
      regionGroupId: this,
      transitionAlignment: Alignment.center,
      offset: const Offset(0, 6),
    );
  }

  void _activate(NavigationItemState item) {
    if (item.widget.content == null) {
      _popoverController.closeLater();
      return;
    }
    final index = widget.children.indexOf(item.widget);
    _activeIndex.value = index;
    _show();
  }

  NavigationItemState? findByWidget(Widget widget) {
    return _contentBuilders.keys
        .where((key) => key.widget == widget)
        .firstOrNull;
  }

  Widget buildContent(int index) {
    NavigationItemState? item = findByWidget(widget.children[index]);
    if (item != null) {
      return _contentBuilders[item]!(context);
    }
    return Container();
  }

  Widget buildPopover(BuildContext context) {
    final theme = Theme.of(context);
    return MouseRegion(
      hitTestBehavior: HitTestBehavior.translucent,
      onEnter: (_) {
        _popoverHovered = true;
      },
      onExit: (event) {
        int currentHoverCount = ++_hoverCount;
        Future.delayed(NavigationItemState.kDebounceDuration, () {
          if (currentHoverCount == _hoverCount) {
            _popoverHovered = false;
            if (!_hovered) {
              _popoverController.closeLater();
              print('close');
            }
          }
        });
      },
      child: AnimatedBuilder(
          animation: _activeIndex,
          builder: (context, child) {
            return AnimatedValueBuilder<double>(
              value: _activeIndex.value.toDouble(),
              duration: kDefaultDuration,
              builder: (context, value, child) {
                List<Widget> children = [];
                int currentIndex = _activeIndex.value;
                if (currentIndex - 1 >= 0) {
                  children.add(
                    Positioned.fill(
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return FractionalTranslation(
                            translation: Offset(-value + currentIndex - 1, 0),
                            child: Stack(
                              children: [
                                Positioned(
                                    child: buildContent(currentIndex - 1)),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  );
                }
                if (currentIndex + 1 < widget.children.length) {
                  children.add(
                    Positioned.fill(
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return FractionalTranslation(
                            translation: Offset(-value + currentIndex + 1, 0),
                            child: Stack(
                              children: [
                                Positioned(
                                    child: buildContent(currentIndex + 1)),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  );
                }
                children.add(
                  FractionalTranslation(
                    translation: Offset(-value + currentIndex, 0),
                    child: buildContent(currentIndex),
                  ),
                );
                return OutlinedContainer(
                  clipBehavior: Clip.antiAlias,
                  borderRadius: theme.radiusMd,
                  child: Stack(
                    children: children,
                  ),
                );
              },
            );
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return TapRegion(
      groupId: this,
      child: MouseRegion(
        hitTestBehavior: HitTestBehavior.translucent,
        onEnter: (_) {
          _hovered = true;
        },
        onExit: (_) {
          int currentHoverCount = ++_hoverCount;
          Future.delayed(NavigationItemState.kDebounceDuration, () {
            if (currentHoverCount == _hoverCount) {
              _hovered = false;
              if (!_popoverHovered) {
                _popoverController.closeLater();
              }
            }
          });
        },
        child: IntrinsicHeight(
          child: PopoverPortal(
            controller: _popoverController,
            child: Data(
              data: this,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: widget.children,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
