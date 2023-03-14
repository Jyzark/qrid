import 'package:flutter/material.dart';
import 'package:qrid/controllers/generated_history_controller.dart';
import 'package:qrid/controllers/scanned_history_controller.dart';
import 'package:qrid/databases/scanned_history_database.dart';
import 'package:qrid/widgets/history_item_listtile.dart';
import 'package:sqflite/sqflite.dart';
import 'package:wakelock/wakelock.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  Widget build(BuildContext context) {
    Wakelock.disable();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'History',
          style: TextStyle(
              fontWeight: FontWeight.w700,
              color: Theme.of(context).primaryColor),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: DefaultTabController(
        length: 2,
        initialIndex: 0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(
              child: TabBar(
                labelColor: Theme.of(context).primaryColor,
                labelStyle: const TextStyle(fontWeight: FontWeight.w600),
                unselectedLabelColor: const Color.fromARGB(255, 114, 114, 114),
                unselectedLabelStyle:
                    const TextStyle(fontWeight: FontWeight.w500),
                padding: const EdgeInsets.symmetric(horizontal: 60),
                tabs: const [
                  Tab(text: 'Scanned'),
                  Tab(text: 'Generated'),
                ],
              ),
            ),
            const Expanded(
              child: TabBarView(
                children: [
                  ScannedTab(),
                  GeneratedTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ScannedTab extends StatefulWidget {
  const ScannedTab({super.key});

  @override
  State<ScannedTab> createState() => _ScannedTabState();
}

class _ScannedTabState extends State<ScannedTab> {
  @override
  Widget build(BuildContext context) {
    var scannedHistoryController = ScannedHistoryController();

    return FutureBuilder<List<Map<String, dynamic>>>(
      future: scannedHistoryController.getHistory(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              color: Color.fromARGB(255, 114, 114, 114),
            ),
          );
        }
        if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          return ListView.separated(
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(vertical: 20),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              Map<String, dynamic> data = snapshot.data![index];
              return HistoryItem(
                itemID: data["id"],
                itemType: data["type"],
                itemTitle: data["title"],
                itemRawData: data["rawData"],
                onDismissed: (_) async {
                  DatabaseManager database = DatabaseManager.instance;
                  Database db = await database.db;
                  await db.delete("scanned_history",
                      where: "id = ${data["id"]}");
                  setState(() {});
                },
              );
            },
            separatorBuilder: (context, index) => const SizedBox(height: 24),
          );
        } else {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                Text(
                  'NO',
                  style: TextStyle(
                    color: Color.fromARGB(255, 114, 114, 114),
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    height: 1,
                  ),
                ),
                Text(
                  'HISTORY',
                  style: TextStyle(
                    color: Color.fromARGB(255, 114, 114, 114),
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    height: 1,
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}

class GeneratedTab extends StatefulWidget {
  const GeneratedTab({super.key});

  @override
  State<GeneratedTab> createState() => _GeneratedTabState();
}

class _GeneratedTabState extends State<GeneratedTab> {
  @override
  Widget build(BuildContext context) {
    var generatedHistoryController = GeneratedHistoryController();

    return FutureBuilder<List<Map<String, dynamic>>>(
      future: generatedHistoryController.getHistory(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              color: Color.fromARGB(255, 114, 114, 114),
            ),
          );
        }
        if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          return ListView.separated(
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(vertical: 20),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              Map<String, dynamic> data = snapshot.data![index];
              return HistoryItem(
                itemID: data["id"],
                itemType: data["type"],
                itemTitle: data["title"],
                itemRawData: data["rawData"],
                onDismissed: (_) async {
                  DatabaseManager database = DatabaseManager.instance;
                  Database db = await database.db;
                  await db.delete("generated_history",
                      where: "id = ${data["id"]}");
                  setState(() {});
                },
              );
            },
            separatorBuilder: (context, index) => const SizedBox(height: 24),
          );
        } else {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                Text(
                  'NO',
                  style: TextStyle(
                    color: Color.fromARGB(255, 114, 114, 114),
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    height: 1,
                  ),
                ),
                Text(
                  'HISTORY',
                  style: TextStyle(
                    color: Color.fromARGB(255, 114, 114, 114),
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    height: 1,
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
