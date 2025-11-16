import 'package:flutter/material.dart';

class SearchBarWidget extends StatefulWidget {
  const SearchBarWidget({
    super.key,
    required this.onChanged,
    this.initialValue = '',
  });

  final ValueChanged<String> onChanged;
  final String initialValue;

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
    _controller.addListener(_handleTextChanged);
  }

  @override
  void didUpdateWidget(covariant SearchBarWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialValue != widget.initialValue &&
        widget.initialValue != _controller.text) {
      _controller.text = widget.initialValue;
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_handleTextChanged);
    _controller.dispose();
    super.dispose();
  }

  void _handleTextChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final showClear = _controller.text.isNotEmpty;
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Semantics(
        label: 'Search users',
        textField: true,
        child: TextField(
          controller: _controller,
          onChanged: widget.onChanged,
          onSubmitted: widget.onChanged,
          textInputAction: TextInputAction.search,
          keyboardType: TextInputType.text,
          textCapitalization: TextCapitalization.none,
          autocorrect: false,
          style: theme.textTheme.bodyLarge,
          decoration: InputDecoration(
            hintText: 'Search users...',
            prefixIcon: Icon(
              Icons.search_rounded,
              color: theme.colorScheme.primary,
            ),
            suffixIcon: showClear
                ? IconButton(
                    onPressed: () {
                      _controller.clear();
                      widget.onChanged('');
                    },
                    tooltip: 'Clear search',
                    icon: Icon(
                      Icons.clear_rounded,
                      color: theme.colorScheme.outline,
                    ),
                  )
                : null,
          ),
        ),
      ),
    );
  }
}
