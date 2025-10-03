import 'package:flutter/material.dart';

void main() {
  runApp(SportIQApp());
}

class SportIQApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SportIQ',
      theme: ThemeData(primarySwatch: Colors.green),
      home: SportIQHome(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class SportIQHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          title: Text('SportIQ'),
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.sports_soccer), text: "Live Scores"),
              Tab(icon: Icon(Icons.newspaper), text: "News"),
              Tab(icon: Icon(Icons.leaderboard), text: "Standings"),
            ],
          ),
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(color: Colors.green),
                child: Text(
                  'SportIQ Menu',
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
              ),
              ListTile(
                leading: Icon(Icons.group),
                title: Text('Teams'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TeamsScreen()),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.person),
                title: Text('Players'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PlayersScreen()),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.settings),
                title: Text('Settings'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SettingsScreen()),
                  );
                },
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [LiveScoresTab(), NewsTab(), StandingsTab()],
        ),
      ),
    );
  }
}

// Sample data for live scores
final List<Match> matches = [
  Match(teamA: 'Lions', teamB: 'Tigers', scoreA: 3, scoreB: 2),
  Match(teamA: 'Eagles', teamB: 'Sharks', scoreA: 1, scoreB: 1),
  Match(teamA: 'Wolves', teamB: 'Bears', scoreA: 0, scoreB: 4),
];

// Sample data for teams
final List<Team> teams = [
  Team(name: 'Lions', icon: Icons.sports_soccer),
  Team(name: 'Tigers', icon: Icons.pets),
  Team(name: 'Eagles', icon: Icons.flight),
  Team(name: 'Sharks', icon: Icons.pool),
  Team(name: 'Wolves', icon: Icons.nature),
  Team(name: 'Bears', icon: Icons.park),
];

class LiveScoresTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: matches.length,
      itemBuilder: (context, index) {
        final match = matches[index];
        return Card(
          margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: ListTile(
            leading: Icon(Icons.sports_soccer, color: Colors.green),
            title: Text('${match.teamA} vs ${match.teamB}'),
            trailing: Text(
              '${match.scoreA} - ${match.scoreB}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: match.scoreA > match.scoreB
                    ? Colors.green
                    : match.scoreA < match.scoreB
                    ? Colors.red
                    : Colors.orange,
              ),
            ),
          ),
        );
      },
    );
  }
}

class NewsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Latest sports news will be shown here.',
        style: TextStyle(fontSize: 18),
      ),
    );
  }
}

class StandingsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Current league standings will appear here.',
        style: TextStyle(fontSize: 18),
      ),
    );
  }
}

class TeamsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Teams')),
      body: ListView.builder(
        itemCount: teams.length,
        itemBuilder: (context, index) {
          final team = teams[index];
          return ListTile(
            leading: Icon(team.icon, color: Colors.green, size: 32),
            title: Text(team.name, style: TextStyle(fontSize: 18)),
          );
        },
      ),
    );
  }
}

class PlayersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Players')),
      body: Center(
        child: Text(
          'List of Players will be here.',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: Center(
        child: Text(
          'App settings can be configured here.',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}

// Models for match and team

class Match {
  final String teamA;
  final String teamB;
  final int scoreA;
  final int scoreB;

  Match({
    required this.teamA,
    required this.teamB,
    required this.scoreA,
    required this.scoreB,
  });
}

class Team {
  final String name;
  final IconData icon;

  Team({required this.name, required this.icon});
}
