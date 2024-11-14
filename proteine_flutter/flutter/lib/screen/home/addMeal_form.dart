import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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

class QuickAddMealScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
