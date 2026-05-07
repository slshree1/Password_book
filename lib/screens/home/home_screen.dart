import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/app_category.dart';
import '../../providers/password_provider.dart';
import '../../widgets/entry_list_tile.dart';
import '../password_entry/add_edit_entry_screen.dart';
import '../settings/settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: AppCategory.values.length,
      vsync: this,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PasswordProvider>().loadAllCategories(
        AppCategory.values.map((c) => c.id).toList(),
      );
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Relative padding for main list view based on screen size
    final size = MediaQuery.of(context).size;
    final paddingH = size.width * 0.04;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Password Book'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              );
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true, // Scrollable tabs for small screens
          tabAlignment:
              TabAlignment.start, // Helps with scrolling tabs on narrow screens
          tabs: AppCategory.values
              .map((c) => Tab(text: c.displayName))
              .toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: AppCategory.values.map((category) {
          return Consumer<PasswordProvider>(
            builder: (context, provider, child) {
              final entries = provider.getEntries(category.id);
              if (entries.isEmpty) {
                return Center(
                  child: Text(
                    'No entries found.',
                    style: TextStyle(
                      fontSize: (size.width * 0.04).clamp(14.0, 18.0),
                    ),
                  ),
                );
              }

              return ListView.builder(
                padding: EdgeInsets.symmetric(
                  horizontal: paddingH,
                  vertical: 8.0,
                ),
                itemCount: entries.length,
                itemBuilder: (context, index) {
                  final entry = entries[index];
                  return EntryListTile(
                    entry: entry,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AddEditEntryScreen(
                            category: category,
                            entry: entry,
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            },
          );
        }).toList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final currentCategory = AppCategory.values[_tabController.index];
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AddEditEntryScreen(category: currentCategory),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
