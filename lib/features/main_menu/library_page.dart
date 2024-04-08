import 'package:flutter/material.dart';
import 'package:finalproject/data/repositories/achievement_repo.dart';
import 'package:finalproject/data/models/achievement.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({Key? key}) : super(key: key);

  @override
  _LibraryPageState createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  final AchievementRepository _achievementRepository = AchievementRepository();
  List<Achievement> _achievements = [];

  @override
  void initState() {
    super.initState();
    // Call the getAllAchievements function when the widget is initialized
    _loadAchievements();
  }

  Future<void> _loadAchievements() async {
    List<Achievement> achievements =
        await _achievementRepository.getAllAchievements();
    setState(() {
      // Update the state with the retrieved achievements
      _achievements = achievements;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Welcome to",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Lato',
                      ),
                    ),
                    Text(
                      "Triolingo",
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Lato',
                        color: Colors.blue, // Update color if needed
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      "This is your library",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Lato',
                        color: Colors.grey, // Update color if needed
                      ),
                      textAlign: TextAlign.center,
                    ),
                    // Display list of achievements
                    Expanded(
                      child: ListView.builder(
                        itemCount: _achievements.length,
                        itemBuilder: (BuildContext context, int index) {
                          // Access each achievement object from the list
                          Achievement achievement = _achievements[index];
                          return ListTile(
                            title: Text(achievement.title ?? ''),
                            subtitle: Text(achievement.description ?? ''),
                            // You can add more widgets or functionality here if needed
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
