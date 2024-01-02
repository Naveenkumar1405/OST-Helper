import 'package:flutter/material.dart';

class SearchField extends StatefulWidget {
  final ValueNotifier<String> query;
  final String? hintText;

  const SearchField({Key? key, required this.query, this.hintText})
      : super(key: key);

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  final TextEditingController _textEditingController = TextEditingController();

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.inversePrimary,
      padding: const EdgeInsets.all(15.0),
      child: TextFormField(
        controller: _textEditingController,
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          hintText: widget.hintText ?? 'Search',

          hintStyle: const TextStyle(
              color: Colors.grey, fontSize: 14.0),
          prefixIcon: const Icon(Icons.search_rounded),
          prefixIconColor: MaterialStateColor.resolveWith(
            (states) => states.contains(MaterialState.focused)
                ? Colors.blue
                : Colors.grey,
          ),
          suffixIcon: ValueListenableBuilder(
            valueListenable: widget.query,
            builder: (ctx, q, child) =>
                q.isEmpty ? const SizedBox.shrink() : child!,
            child: IconButton(
              icon: const Icon(Icons.highlight_remove_rounded),
              onPressed: () {
                widget.query.value = '';
                _textEditingController.clear();
              },
            ),
          ),
          contentPadding: const EdgeInsets.all(15.0),
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: BorderSide.none,
          ),
        ),
        onChanged: (value) => widget.query.value = value.toString().trim(),
      ),
    );
  }
}
