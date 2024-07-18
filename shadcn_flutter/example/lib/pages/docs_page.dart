import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../main.dart';

const double breakpointWidth = 768;
const double breakpointWidth2 = 1024;

extension CustomWidgetExtension on Widget {
  Widget anchored(OnThisPage onThisPage) {
    return PageItemWidget(
      onThisPage: onThisPage,
      child: this,
    );
  }
}

void openInNewTab(String url) {
  launchUrlString(url);
}

class OnThisPage extends LabeledGlobalKey {
  final ValueNotifier<bool> isVisible = ValueNotifier(false);

  OnThisPage([super.debugLabel]);
}

class PageItemWidget extends StatelessWidget {
  final OnThisPage onThisPage;
  final Widget child;

  const PageItemWidget({
    Key? key,
    required this.onThisPage,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: onThisPage,
      child: child,
      onVisibilityChanged: (info) {
        onThisPage.isVisible.value = info.visibleFraction >= 1;
      },
    );
  }
}

class DocsPage extends StatefulWidget {
  final String name;
  final Widget child;
  final Map<String, OnThisPage> onThisPage;
  final List<Widget> navigationItems;
  final bool scrollable;
  const DocsPage({
    Key? key,
    required this.name,
    required this.child,
    this.onThisPage = const {},
    this.navigationItems = const [],
    this.scrollable = true,
  }) : super(key: key);

  @override
  DocsPageState createState() => DocsPageState();
}

enum ShadcnFeatureTag {
  newFeature,
  updated,
  workInProgress;

  Widget buildBadge(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ThemeData copy;
    String badgeText;
    switch (this) {
      case ShadcnFeatureTag.newFeature:
        copy = theme.copyWith(
          colorScheme: theme.colorScheme.copyWith(
            primary: Colors.green,
          ),
        );
        badgeText = 'New';
        break;
      case ShadcnFeatureTag.updated:
        copy = theme.copyWith(
          colorScheme: theme.colorScheme.copyWith(
            primary: Colors.blue,
          ),
        );
        badgeText = 'Updated';
        break;
      case ShadcnFeatureTag.workInProgress:
        copy = theme.copyWith(
          colorScheme: theme.colorScheme.copyWith(
            primary: Colors.orange,
          ),
        );
        badgeText = 'WIP';
        break;
    }
    return Theme(
      data: copy,
      child: PrimaryBadge(
        child: Text(badgeText),
      ),
    );
  }
}

class ShadcnDocsPage {
  final String title;
  final String name; // name for go_router
  final ShadcnFeatureTag? tag;

  const ShadcnDocsPage(this.title, this.name, [this.tag]);
}

class ShadcnDocsSection {
  final String title;
  final List<ShadcnDocsPage> pages;
  final IconData icon;

  const ShadcnDocsSection(this.title, this.pages, [this.icon = Icons.book]);

  List<ShadcnDocsPage> get sortedPages {
    return pages.toList()..sort((a, b) => a.title.compareTo(b.title));
  }
}

class DocsPageState extends State<DocsPage> {
  static const List<ShadcnDocsSection> sections = [
    ShadcnDocsSection(
        'Getting Started',
        [
          ShadcnDocsPage('Introduction', 'introduction'),
          ShadcnDocsPage('Installation', 'installation'),
          ShadcnDocsPage('Theme', 'theme'),
          ShadcnDocsPage('Typography', 'typography'),
          ShadcnDocsPage('Layout', 'layout'),
          ShadcnDocsPage('Web Preloader', 'web_preloader'),
          ShadcnDocsPage('Components', 'components'),
          ShadcnDocsPage('Icons', 'icons'),
        ],
        Icons.book),
    ShadcnDocsSection(
      'Animation',
      [
        ShadcnDocsPage('Animated Value', 'animated_value_builder'),
        ShadcnDocsPage('Repeated Animation', 'repeated_animation_builder'),
      ],
    ),
    ShadcnDocsSection(
      'Disclosure',
      [
        ShadcnDocsPage('Accordion', 'accordion'),
        ShadcnDocsPage('Collapsible', 'collapsible'),
      ],
    ),
    ShadcnDocsSection(
      'Feedback',
      [
        ShadcnDocsPage('Alert', 'alert'),
        ShadcnDocsPage('Alert Dialog', 'alert_dialog'),
        ShadcnDocsPage('Circular Progress', 'circular_progress'),
        ShadcnDocsPage('Progress', 'progress'),
        ShadcnDocsPage('Skeleton', 'skeleton'),
        ShadcnDocsPage('Toast', 'toast', ShadcnFeatureTag.workInProgress),
      ],
    ),
    ShadcnDocsSection(
      'Forms',
      [
        ShadcnDocsPage('Button', 'button'),
        ShadcnDocsPage('Checkbox', 'checkbox'),
        ShadcnDocsPage('Color Picker', 'color_picker'),
        ShadcnDocsPage('Date Picker', 'date_picker'),
        ShadcnDocsPage('Form', 'form'),
        ShadcnDocsPage('Input', 'input'),
        ShadcnDocsPage('Input OTP', 'input_otp'),
        ShadcnDocsPage('Radio Group', 'radio_group'),
        ShadcnDocsPage('Select', 'select'),
        ShadcnDocsPage('Slider', 'slider'),
        ShadcnDocsPage('Switch', 'switch'),
        ShadcnDocsPage('Text Area', 'text_area'),
        ShadcnDocsPage('Toggle', 'toggle'),
      ],
    ),
    ShadcnDocsSection(
      'Layout',
      [
        ShadcnDocsPage('Card', 'card'),
        ShadcnDocsPage('Carousel', 'carousel'),
        ShadcnDocsPage('Divider', 'divider'),
        ShadcnDocsPage('Resizable', 'resizable'),
        ShadcnDocsPage('Steps', 'steps'),
      ],
    ),
    ShadcnDocsSection(
      'Navigation',
      [
        ShadcnDocsPage('Breadcrumb', 'breadcrumb'),
        ShadcnDocsPage('Menubar', 'menubar'),
        ShadcnDocsPage('Navigation Menu', 'navigation_menu'),
        ShadcnDocsPage('Pagination', 'pagination'),
        ShadcnDocsPage('Tabs', 'tabs'),
        ShadcnDocsPage('Tab List', 'tab_list'),
      ],
    ),
    ShadcnDocsSection(
      'Surfaces',
      [
        ShadcnDocsPage('Dialog', 'dialog'),
        ShadcnDocsPage('Drawer', 'drawer'),
        ShadcnDocsPage('Popover', 'popover'),
        ShadcnDocsPage('Sheet', 'sheet'),
        ShadcnDocsPage('Tooltip', 'tooltip'),
      ],
    ),
    ShadcnDocsSection(
      'Data Display',
      [
        ShadcnDocsPage('Avatar', 'avatar'),
        ShadcnDocsPage(
            'Data Table', 'data_table', ShadcnFeatureTag.workInProgress),
        ShadcnDocsPage('Chart', 'chart', ShadcnFeatureTag.workInProgress),
        ShadcnDocsPage('Code Snippet', 'code_snippet'),
        ShadcnDocsPage('Table', 'table', ShadcnFeatureTag.workInProgress),
      ],
    ),
    ShadcnDocsSection(
      'Utilities',
      [
        ShadcnDocsPage('Badge', 'badge'),
        ShadcnDocsPage('Calendar', 'calendar'),
        ShadcnDocsPage('Command', 'command'),
        ShadcnDocsPage('Context Menu', 'context_menu'),
        ShadcnDocsPage('Dropdown Menu', 'dropdown_menu'),
      ],
    ),
  ];
  bool toggle = false;
  List<OnThisPage> currentlyVisible = [];

  @override
  void initState() {
    super.initState();
    for (final child in widget.onThisPage.values) {
      child.isVisible.addListener(_onVisibilityChanged);
    }
  }

  @override
  void didUpdateWidget(covariant DocsPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!mapEquals(oldWidget.onThisPage, widget.onThisPage)) {
      for (final child in widget.onThisPage.values) {
        child.isVisible.addListener(_onVisibilityChanged);
      }
    }
  }

  @override
  void dispose() {
    for (final child in widget.onThisPage.values) {
      child.isVisible.removeListener(_onVisibilityChanged);
    }
    super.dispose();
  }

  void _onVisibilityChanged() {
    setState(() {
      currentlyVisible = widget.onThisPage.values
          .where((element) => element.isVisible.value)
          .toList();
    });
  }

  bool isVisible(OnThisPage onThisPage) {
    return currentlyVisible.isNotEmpty && currentlyVisible[0] == onThisPage;
  }

  void showSearchBar() {
    showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: SizedBox(
              width: 510,
              height: 349,
              child: Command(
                debounceDuration: Duration.zero,
                builder: (context, query) async* {
                  for (final section in sections) {
                    final List<Widget> resultItems = [];
                    for (final page in section.pages) {
                      if (query == null ||
                          page.title
                              .toLowerCase()
                              .contains(query.toLowerCase())) {
                        resultItems.add(CommandItem(
                          title: Text(page.title),
                          trailing: Icon(section.icon),
                          onTap: () {
                            context.goNamed(page.name);
                          },
                        ));
                      }
                    }
                    if (resultItems.isNotEmpty) {
                      yield [
                        CommandCategory(
                          title: Text(section.title),
                          children: resultItems,
                        ),
                      ];
                    }
                  }
                },
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Map<String, OnThisPage> onThisPage = widget.onThisPage;
    ShadcnDocsPage? page = sections
        .expand((e) => e.pages)
        .where((e) => e.name == widget.name)
        .firstOrNull;

    final theme = Theme.of(context);

    return SafeArea(
      child: PageStorage(
        bucket: docsBucket,
        child: Scaffold(
          child: Builder(builder: (context) {
            return StageContainer(
              builder: (context, padding) {
                return Stack(
                  children: [
                    Positioned(
                      top: 0,
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(height: 72 + 1),
                          Expanded(
                            child: Builder(builder: (context) {
                              var hasOnThisPage = onThisPage.isNotEmpty;
                              return Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  MediaQueryVisibility(
                                    minWidth: breakpointWidth,
                                    child: FocusTraversalGroup(
                                      child: SingleChildScrollView(
                                        key: const PageStorageKey('sidebar'),
                                        padding: EdgeInsets.only(
                                            top: 32,
                                            left: 24 + padding.left,
                                            bottom: 32),
                                        child: SidebarNav(children: [
                                          for (var section in sections)
                                            SidebarSection(
                                              header: Text(section.title),
                                              children: [
                                                for (var page in section.pages)
                                                  NavigationButton(
                                                    onPressed: () {
                                                      if (page.tag ==
                                                          ShadcnFeatureTag
                                                              .workInProgress) {
                                                        showDialog(
                                                          context: context,
                                                          builder: (context) {
                                                            return Center(
                                                              child:
                                                                  AlertDialog(
                                                                title: Text(
                                                                    'Work in Progress'),
                                                                content: Text(
                                                                    'This page is still under development. Please come back later.'),
                                                                actions: [
                                                                  PrimaryButton(
                                                                      onPressed:
                                                                          () {
                                                                        Navigator.of(context)
                                                                            .pop();
                                                                      },
                                                                      child: Text(
                                                                          'Close')),
                                                                ],
                                                              ),
                                                            );
                                                          },
                                                        );
                                                        return;
                                                      }
                                                      context
                                                          .goNamed(page.name);
                                                    },
                                                    selected: page.name ==
                                                        widget.name,
                                                    child: Basic(
                                                      trailing: page.tag
                                                          ?.buildBadge(context),
                                                      trailingAlignment:
                                                          Alignment.centerLeft,
                                                      content: Text(page.title),
                                                    ),
                                                  ),
                                              ],
                                            ),
                                        ]),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: FocusTraversalGroup(
                                      child: widget.scrollable
                                          ? SingleChildScrollView(
                                              clipBehavior: Clip.none,
                                              padding: !hasOnThisPage
                                                  ? const EdgeInsets.symmetric(
                                                      horizontal: 40,
                                                      vertical: 32,
                                                    ).copyWith(
                                                      right: padding.right,
                                                    )
                                                  : const EdgeInsets.symmetric(
                                                      horizontal: 40,
                                                      vertical: 32,
                                                    ).copyWith(right: 24),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.stretch,
                                                children: [
                                                  Breadcrumb(
                                                    separator: Breadcrumb
                                                        .arrowSeparator,
                                                    children: [
                                                      TextButton(
                                                        onPressed: () {
                                                          context.goNamed(
                                                              'introduction');
                                                        },
                                                        density: ButtonDensity
                                                            .compact,
                                                        child: Text('Docs'),
                                                      ),
                                                      ...widget.navigationItems,
                                                      if (page != null)
                                                        Text(page.title),
                                                    ],
                                                  ),
                                                  gap(16),
                                                  widget.child,
                                                ],
                                              ),
                                            )
                                          : Container(
                                              clipBehavior: Clip.none,
                                              padding: !hasOnThisPage
                                                  ? const EdgeInsets.symmetric(
                                                      horizontal: 40,
                                                      vertical: 32,
                                                    ).copyWith(
                                                      right: padding.right,
                                                      bottom: 0,
                                                    )
                                                  : const EdgeInsets.symmetric(
                                                      horizontal: 40,
                                                      vertical: 32,
                                                    ).copyWith(
                                                      right: 24,
                                                      bottom: 0,
                                                    ),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.stretch,
                                                children: [
                                                  Breadcrumb(
                                                    separator: Breadcrumb
                                                        .arrowSeparator,
                                                    children: [
                                                      TextButton(
                                                        onPressed: () {
                                                          context.goNamed(
                                                              'introduction');
                                                        },
                                                        density: ButtonDensity
                                                            .compact,
                                                        child: Text('Docs'),
                                                      ),
                                                      ...widget.navigationItems,
                                                      if (page != null)
                                                        Text(page.title),
                                                    ],
                                                  ),
                                                  gap(16),
                                                  Expanded(child: widget.child),
                                                ],
                                              ),
                                            ),
                                    ),
                                  ),
                                  if (hasOnThisPage)
                                    MediaQueryVisibility(
                                      minWidth: breakpointWidth2,
                                      child: FocusTraversalGroup(
                                        child: SingleChildScrollView(
                                          padding: EdgeInsets.only(
                                            top: 32,
                                            right: 24 + padding.right,
                                            bottom: 32,
                                            left: 24,
                                          ),
                                          child: SidebarNav(children: [
                                            SidebarSection(
                                              header:
                                                  const Text('On This Page'),
                                              children: [
                                                for (var key in onThisPage.keys)
                                                  SidebarButton(
                                                    onPressed: () {
                                                      Scrollable.ensureVisible(
                                                          onThisPage[key]!
                                                              .currentContext!,
                                                          duration:
                                                              kDefaultDuration,
                                                          alignmentPolicy:
                                                              ScrollPositionAlignmentPolicy
                                                                  .explicit);
                                                    },
                                                    selected: isVisible(
                                                        onThisPage[key]!),
                                                    child: Text(key),
                                                  ),
                                              ],
                                            ),
                                          ]),
                                        ),
                                      ),
                                    )
                                  else
                                    const SizedBox(
                                      width: 32,
                                    ),
                                ],
                              );
                            }),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      top: 0,
                      height: 72 + 1,
                      child: Container(
                        color: theme.colorScheme.background.withOpacity(0.3),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            MediaQueryVisibility(
                              minWidth: breakpointWidth,
                              alternateChild: FocusTraversalGroup(
                                child: ClipRect(
                                  clipBehavior: Clip.hardEdge,
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(
                                        sigmaX: 10, sigmaY: 10),
                                    child: Container(
                                      height: 72,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 32,
                                      ),
                                      child: Row(
                                        children: [
                                          GhostButton(
                                            density: ButtonDensity.icon,
                                            onPressed: () {
                                              _openDrawer(context);
                                            },
                                            child: Icon(Icons.menu),
                                          ),
                                          gap(18),
                                          Expanded(
                                            child: OutlineButton(
                                              onPressed: () {
                                                showSearchBar();
                                              },
                                              child: Text(
                                                      'Search documentation...')
                                                  .muted()
                                                  .normal(),
                                              trailing: Icon(Icons.search)
                                                  .iconSmall()
                                                  .iconMuted(),
                                            ),
                                          ),
                                          gap(18),
                                          GhostButton(
                                            density: ButtonDensity.icon,
                                            onPressed: () {
                                              openInNewTab(
                                                  'https://github.com/sunarya-thito/shadcn_flutter');
                                            },
                                            child: FaIcon(
                                              FontAwesomeIcons.github,
                                              color: theme.colorScheme
                                                  .secondaryForeground,
                                            ),
                                          ),
                                          // pub.dev icon
                                          GhostButton(
                                              density: ButtonDensity.icon,
                                              onPressed: () {
                                                openInNewTab(
                                                    'https://pub.dev/packages/shadcn_flutter');
                                              },
                                              child: ColorFiltered(
                                                // turns into white
                                                colorFilter: ColorFilter.mode(
                                                  theme.colorScheme
                                                      .secondaryForeground,
                                                  BlendMode.srcIn,
                                                ),
                                                child: FlutterLogo(
                                                  size: 24,
                                                ),
                                              )),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              child: FocusTraversalGroup(
                                child: ClipRect(
                                  clipBehavior: Clip.hardEdge,
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(
                                        sigmaX: 10, sigmaY: 10),
                                    child: Container(
                                      height: 72,
                                      padding: padding,
                                      child: Row(
                                        children: [
                                          FlutterLogo(
                                            size: 32,
                                          ),
                                          gap(18),
                                          Text(
                                            'shadcn_flutter',
                                          ).textLarge().mono(),
                                          Spacer(),
                                          gap(18),
                                          SizedBox(
                                            width: 320 - 18,
                                            // height: 32,
                                            child: OutlineButton(
                                              onPressed: () {
                                                showSearchBar();
                                              },
                                              child: Text(
                                                      'Search documentation...')
                                                  .muted()
                                                  .normal(),
                                              trailing: Icon(Icons.search)
                                                  .iconSmall()
                                                  .iconMuted(),
                                            ),
                                          ),
                                          gap(18),
                                          GhostButton(
                                            density: ButtonDensity.icon,
                                            onPressed: () {
                                              openInNewTab(
                                                  'https://github.com/sunarya-thito/shadcn_flutter');
                                            },
                                            child: FaIcon(
                                                FontAwesomeIcons.github,
                                                color: theme.colorScheme
                                                    .secondaryForeground),
                                          ),
                                          // pub.dev icon
                                          GhostButton(
                                              density: ButtonDensity.icon,
                                              onPressed: () {
                                                openInNewTab(
                                                    'https://pub.dev/packages/shadcn_flutter');
                                              },
                                              child: ColorFiltered(
                                                // turns into white
                                                colorFilter: ColorFilter.mode(
                                                  theme.colorScheme
                                                      .secondaryForeground,
                                                  BlendMode.srcIn,
                                                ),
                                                child: FlutterLogo(
                                                  size: 24,
                                                ),
                                              )),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Divider(),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          }),
        ),
      ),
    );
  }

  void _openDrawer(BuildContext context) {
    openSheet(
      context: context,
      builder: (context) {
        return Container(
          constraints: BoxConstraints(maxWidth: 400),
          padding: EdgeInsets.only(top: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  FlutterLogo(
                    size: 24,
                  ),
                  gap(18),
                  Text(
                    'shadcn_flutter',
                  ).medium().mono().expanded(),
                  TextButton(
                    density: ButtonDensity.icon,
                    size: ButtonSize.small,
                    onPressed: () {
                      closeDrawer(context);
                    },
                    child: Icon(Icons.close),
                  ),
                ],
              ).withPadding(left: 32, right: 32),
              gap(32),
              Expanded(
                child: FocusTraversalGroup(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.only(left: 32, right: 32, bottom: 48),
                    key: const PageStorageKey('sidebar'),
                    child: SidebarNav(children: [
                      for (var section in sections)
                        SidebarSection(
                          header: Text(section.title),
                          children: [
                            for (var page in section.sortedPages)
                              NavigationButton(
                                onPressed: () {
                                  if (page.tag ==
                                      ShadcnFeatureTag.workInProgress) {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return Center(
                                          child: AlertDialog(
                                            title: Text('Work in Progress'),
                                            content: Text(
                                                'This page is still under development. Please come back later.'),
                                            actions: [
                                              PrimaryButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text('Close')),
                                            ],
                                          ),
                                        );
                                      },
                                    );
                                    return;
                                  }
                                  context.goNamed(page.name);
                                },
                                selected: page.name == widget.name,
                                child: Basic(
                                  trailing: page.tag?.buildBadge(context),
                                  trailingAlignment: Alignment.centerLeft,
                                  content: Text(page.title),
                                ),
                              ),
                          ],
                        ),
                    ]),
                  ),
                ),
              )
            ],
          ),
        );
      },
      position: OverlayPosition.left,
    );
  }
}
