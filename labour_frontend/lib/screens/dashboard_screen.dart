// lib/screens/dashboard_screen.dart

import 'package:flutter/material.dart';
import '../utils/constants.dart';
// Variables used in this file
// AppColors.accentOrange - Color for the floating action button and some icons
// AppColors.primaryBlue - Primary color used for various UI elements
// AppSizes.borderRadius - Border radius used for cards and other elements
// title - Title of the stat card or recent activity item
// value - Value displayed on the stat card
// icon - Icon displayed on the stat card or recent activity item
// iconColor - Color of the icon
// time - Time of the recent activity
// screenWidth - Width of the screen, used to determine layout
// crossAxisCount - Number of columns in the grid layout
// context - Build context used in various widgets
// key - Key used for the DashboardScreen widget
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  /// Simulated data refresh method.
  Future<void> _onRefresh() async {
    // In a real app, you'd fetch fresh data here.
    // This is just a quick placeholder that waits for 1 second.
    return Future.delayed(const Duration(seconds: 1));
  }

  /// Builds a stat card with an icon, value, and title.
  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color iconColor,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.borderRadius),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 32, color: iconColor),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds a list item showing recent activity.
  Widget _buildRecentActivityItem({
    required String title,
    required String time,
    required IconData icon,
  }) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: AppColors.primaryBlue.withOpacity(0.1),
        child: Icon(icon, color: AppColors.primaryBlue),
      ),
      title: Text(title),
      subtitle: Text(time),
      trailing: IconButton(
        icon: const Icon(Icons.more_vert),
        onPressed: () {
          // Handle extra options, e.g. open a context menu
        },
      ),
    );
  }

  /// Drawer menu used for navigation.
  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: AppColors.primaryBlue,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, color: AppColors.primaryBlue),
                ),
                const SizedBox(height: 10),
                const Text(
                  'John Doe',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
                Text(
                  'john.doe@example.com',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.dashboard),
            title: const Text('Dashboard'),
            selected: true,
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Icon(Icons.work),
            title: const Text('Jobs'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.message),
            title: const Text('Messages'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {},
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Logout'),
            onTap: () => Navigator.pushReplacementNamed(context, '/login'),
          ),
        ],
      ),
    );
  }

  /// Builds the header portion of the dashboard.
  Widget _buildHeaderSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: AppColors.primaryBlue,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'Welcome back, John!',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            "Here's what's happening today",
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the grid of stats (Active Jobs, Applications, etc.).
  Widget _buildOverviewGrid(BuildContext context) {
    // Make it responsive: if the screen is wide, use 3 columns, otherwise 2.
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = screenWidth > 600 ? 3 : 2;

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: crossAxisCount,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      children: [
        _buildStatCard(
          title: 'Active Jobs',
          value: '12',
          icon: Icons.work,
          iconColor: AppColors.primaryBlue,
        ),
        _buildStatCard(
          title: 'Applications',
          value: '48',
          icon: Icons.person_search,
          iconColor: AppColors.accentOrange,
        ),
        _buildStatCard(
          title: 'Messages',
          value: '24',
          icon: Icons.message,
          iconColor: Colors.green,
        ),
        _buildStatCard(
          title: 'Reviews',
          value: '4.8',
          icon: Icons.star,
          iconColor: Colors.amber,
        ),
      ],
    );
  }

  /// Builds the Recent Activity list area.
  Widget _buildRecentActivitySection() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.borderRadius),
      ),
      child: Column(
        children: [
          _buildRecentActivityItem(
            title: 'New job application received',
            time: '2 minutes ago',
            icon: Icons.work,
          ),
          const Divider(),
          _buildRecentActivityItem(
            title: 'Message from Sarah',
            time: '1 hour ago',
            icon: Icons.message,
          ),
          const Divider(),
          _buildRecentActivityItem(
            title: 'New review: 5 stars',
            time: '3 hours ago',
            icon: Icons.star,
          ),
        ],
      ),
    );
  }

  /// Main build method.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Top bar
      appBar: AppBar(
        title: const Text('Dashboard'),
        backgroundColor: AppColors.primaryBlue,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // Handle notification action
            },
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              // Handle profile action
            },
          ),
        ],
      ),

      // Drawer menu
      drawer: _buildDrawer(context),

      // Content with refresh (pull to refresh on mobile!)
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _onRefresh,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                _buildHeaderSection(),

                // Overview
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Overview',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildOverviewGrid(context),
                      const SizedBox(height: 24),

                      // Recent Activity
                      const Text(
                        'Recent Activity',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildRecentActivitySection(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),

      // Floating Action Button
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.accentOrange,
        child: const Icon(Icons.add),
        onPressed: () {
          // Add new job or other quick action
        },
      ),
    );
  }
}