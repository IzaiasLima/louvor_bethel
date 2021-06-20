import 'package:flutter/material.dart';

class SearchDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          height: 50,
          top: 4,
          left: 4,
          right: 4,
          child: Card(
            child: TextFormField(
              autofocus: true,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(vertical: 15.0),
                prefixIcon: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                suffixIcon: Icon(Icons.close),
                border: InputBorder.none,
              ),
              onFieldSubmitted: (text) => Navigator.of(context).pop(text),
            ),
          ),
        )
      ],
    );
  }
}
