import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'loading_provider.dart';

class GlobalLoadingWidget extends StatelessWidget {
  const GlobalLoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<LoadingProvider>(
      builder: (context, loader, child) {
        return loader.isLoading
            ? Container(
                color: Colors.black.withOpacity(0.5),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : SizedBox.shrink();
      },
    );
  }
}
