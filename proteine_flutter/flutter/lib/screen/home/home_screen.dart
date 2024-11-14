import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:proteine_flutter/screen/home/home_viewmodel.dart';
import 'package:proteine_flutter/screen/screen.dart';
import 'package:proteine_flutter/widget/style/style.dart';

class HomeRoute extends GoRoute {
  HomeRoute()
      : super(
          path: "/home",
          pageBuilder: (context, state) =>
              NoTransitionPage<void>(key: state.pageKey, child: HomeScreen()),
        );
}

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomeState();
}

class _HomeViewModel extends HomeViewModel {}

class _HomeState extends ScreenState<_HomeViewModel, HomeScreen> {
  @override
  final _HomeViewModel viewModel = _HomeViewModel();

  @override
  Widget buildScreen(BuildContext context, AppStyle style) => Scaffold(
        appBar: AppBar(
          title: Text(
            'Proteine',
            style: TextStyle(color: style.appBlack),
          ),
          backgroundColor: style.appWhite,
          centerTitle: true,
          elevation: 0,
        ),
        body: Container(
          padding: style.contentInsets,
          alignment: Alignment.center,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Daily Calorie Summary
              Card(
                elevation: 4,
                margin:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Daily Summary',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: style.appBlack,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _calorieItem(
                              'Consumed', '1200 kcal', style.appGreenMid),
                          _calorieItem(
                              'Burned', '500 kcal', style.appOrangeLight),
                          _calorieItem(
                              'Remaining', '700 kcal', style.appBlueMid),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              // Quick Add Button
              ElevatedButton(
                onPressed: () {
                  GoRouter.of(context).push('/quickAddMeal');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: style.appGreenLight,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Quick Add Meal or Activity',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: style.appWhite,
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: style.appBlueMid,
          unselectedItemColor: style.appGrey400,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.insights),
              label: 'Progress',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.restaurant_menu),
              label: 'Recipes',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      );

  Widget _calorieItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: color,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}
