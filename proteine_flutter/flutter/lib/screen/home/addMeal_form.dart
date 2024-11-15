import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:proteine_flutter/screen/home/home_viewmodel.dart';
import 'package:proteine_flutter/screen/screen.dart';
import 'package:proteine_flutter/widget/style/style.dart';

class QuickAddMealRoute extends GoRoute {
  QuickAddMealRoute()
      : super(
          path: "/quickAddMeal",
          pageBuilder: (context, state) => MaterialPage<void>(
            key: state.pageKey,
            child: QuickAddMealScreen(),
          ),
        );
}

class QuickAddMealScreen extends StatefulWidget {
  const QuickAddMealScreen({Key? key}) : super(key: key);

  void show(BuildContext context, AppStyle style) {
    showModalBottomSheet(
      backgroundColor: style.itemBlue, // Optional for styling
      context: context,
      useRootNavigator: true, // Using root navigator
      isScrollControlled: true, // Ensure the sheet can extend with the keyboard
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return QuickAddMealScreen();
      },
    );
  }

  @override
  _QuickAddMealScreenState createState() => _QuickAddMealScreenState();
}

class _QuickAddMealScreenState
    extends ScreenState<HomeViewModel, QuickAddMealScreen> {
  @override
  late final HomeViewModel viewModel;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget buildScreen(BuildContext context, AppStyle style) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quick Add Meal'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Meal Name'),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Calories'),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Notes (optional)'),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Add Meal'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
