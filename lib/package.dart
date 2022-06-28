import 'package:flutter/material.dart';
import 'package:sample/home.dart';

const Duration _kExpand = Duration(milliseconds: 200);

class MyExpansionTileReadMore extends StatefulWidget {
  const MyExpansionTileReadMore({
    Key? key,
    // this.leading,
    required this.title,
    // this.subtitle,
    this.onExpansionChanged,
    // this.children = const <Widget>[],
    // this.trailing,
    this.initiallyExpanded = false,
    this.maintainState = false,
    this.tilePadding,
    this.expandedCrossAxisAlignment,
    this.expandedAlignment,
    this.childrenPadding,
    this.backgroundColor,
    this.collapsedBackgroundColor,
    this.textColor,
    this.collapsedTextColor,
    this.iconColor,
    this.collapsedIconColor,
    this.controlAffinity,
  })  : assert(
          expandedCrossAxisAlignment != CrossAxisAlignment.baseline,
          'CrossAxisAlignment.baseline is not supported since the expanded children '
          'are aligned in a column, not a row. Try to use another constant.',
        ),
        super(key: key);

  // final Widget? leading;

  final Widget title;

  // final Widget? subtitle;

  final ValueChanged<bool>? onExpansionChanged;

  // final List<Widget> children;

  final Color? backgroundColor;

  final Color? collapsedBackgroundColor;

  // final Widget? trailing;

  final bool initiallyExpanded;

  final bool maintainState;

  final EdgeInsetsGeometry? tilePadding;

  final Alignment? expandedAlignment;

  final CrossAxisAlignment? expandedCrossAxisAlignment;

  final EdgeInsetsGeometry? childrenPadding;

  final Color? iconColor;

  final Color? collapsedIconColor;

  final Color? textColor;

  final Color? collapsedTextColor;

  final ListTileControlAffinity? controlAffinity;

  @override
  State<MyExpansionTileReadMore> createState() => _MyExpansionTileReadMoreState();
}

class _MyExpansionTileReadMoreState extends State<MyExpansionTileReadMore>
    with SingleTickerProviderStateMixin {
  static final Animatable<double> _easeOutTween = CurveTween(curve: Curves.easeOut);
  static final Animatable<double> _easeInTween = CurveTween(curve: Curves.easeIn);
  static final Animatable<double> _halfTween = Tween<double>(begin: 0.0, end: 0.5);

  final ColorTween _borderColorTween = ColorTween();
  final ColorTween _headerColorTween = ColorTween();
  final ColorTween _iconColorTween = ColorTween();
  final ColorTween _backgroundColorTween = ColorTween();

  late AnimationController _controller;
  late Animation<double> _iconTurns;
  // late Animation<double> _heightFactor;
  late Animation<Color?> _borderColor;
  // late Animation<Color?> _headerColor;
  // late Animation<Color?> _iconColor;
  late Animation<Color?> _backgroundColor;

  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: _kExpand, vsync: this);
    // _heightFactor = _controller.drive(_easeInTween);
    _iconTurns = _controller.drive(_halfTween.chain(_easeInTween));
    _borderColor = _controller.drive(_borderColorTween.chain(_easeOutTween));
    // _headerColor = _controller.drive(_headerColorTween.chain(_easeInTween));
    // _iconColor = _controller.drive(_iconColorTween.chain(_easeInTween));
    _backgroundColor = _controller.drive(_backgroundColorTween.chain(_easeOutTween));

    _isExpanded = PageStorage.of(context)?.readState(context) as bool? ?? widget.initiallyExpanded;
    if (_isExpanded) _controller.value = 1.0;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse().then<void>((void value) {
          if (!mounted) return;
          setState(() {
            // Rebuild without widget.children.
          });
        });
      }
      PageStorage.of(context)?.writeState(context, _isExpanded);
    });
    widget.onExpansionChanged?.call(_isExpanded);
  }

  // Widget? _buildIcon(BuildContext context) {
  //   return RotationTransition(
  //     turns: _iconTurns,
  //     child: const Icon(Icons.expand_more),
  //   );
  // }

  // Widget? _buildTrailingIcon(BuildContext context) {
  //   return _buildIcon(context);
  // }

  Widget _buildChildren(BuildContext context, Widget? child) {
    final ExpansionTileThemeData expansionTileTheme = ExpansionTileTheme.of(context);
    final Color borderSideColor = _borderColor.value ?? Colors.transparent;

    return Container(
      decoration: BoxDecoration(
        color: _backgroundColor.value ?? expansionTileTheme.backgroundColor ?? Colors.transparent,
        border: Border(
          top: BorderSide(color: borderSideColor),
          bottom: BorderSide(color: borderSideColor),
        ),
      ),
      child: ListTile(
        onTap: _handleTap,
        contentPadding: widget.tilePadding ?? expansionTileTheme.tilePadding,
        // trailing: _buildTrailingIcon(context),
        // title: SizedBox(),
        title: Text(
          sameText,
          maxLines: !_isExpanded ? 3 : 1000,
          overflow: TextOverflow.ellipsis,
        ),
        // title: Text(
        //   sameText,
        //   maxLines: !_isExpanded ? 3 : 1000,
        //   overflow: TextOverflow.ellipsis,
        // ),
      ),
    );
  }

  @override
  void didChangeDependencies() {
    final ThemeData theme = Theme.of(context);
    final ExpansionTileThemeData expansionTileTheme = ExpansionTileTheme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    _borderColorTween.end = theme.dividerColor;
    _headerColorTween
      ..begin = widget.collapsedTextColor ??
          expansionTileTheme.collapsedTextColor ??
          theme.textTheme.subtitle1!.color
      ..end = widget.textColor ?? expansionTileTheme.textColor ?? colorScheme.primary;
    _iconColorTween
      ..begin = widget.collapsedIconColor ??
          expansionTileTheme.collapsedIconColor ??
          theme.unselectedWidgetColor
      ..end = widget.iconColor ?? expansionTileTheme.iconColor ?? colorScheme.primary;
    _backgroundColorTween
      ..begin = widget.collapsedBackgroundColor ?? expansionTileTheme.collapsedBackgroundColor
      ..end = widget.backgroundColor ?? expansionTileTheme.backgroundColor;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final bool closed = !_isExpanded && _controller.isDismissed;
    final bool shouldRemoveChildren = closed && !widget.maintainState;

    return AnimatedBuilder(
      animation: _controller.view,
      builder: _buildChildren,
      child: shouldRemoveChildren ? null : null,
    );
  }
}
