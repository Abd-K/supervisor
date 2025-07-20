import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  // Hardcoded notifications for now
  final List<NotificationItem> notifications = const [
    NotificationItem(
      title: 'New orphan payment received',
      subtitle: 'Please upload proof of withdrawal from the bank.',
      icon: Icons.account_balance_wallet,
      iconColor: Colors.green,
      timestamp: 'Just now',
      isUnread: true,
    ),
    NotificationItem(
      title: 'Orphan status update needed',
      subtitle: 'Kindly review and update the status of your assigned orphans.',
      icon: Icons.update,
      iconColor: Colors.orange,
      timestamp: '2 hours ago',
      isUnread: true,
    ),
    NotificationItem(
      title: 'New orphan assigned to your care',
      subtitle: 'Mohamed Ali has been added to your dependant list.',
      icon: Icons.person_add,
      iconColor: Colors.blue,
      timestamp: '1 day ago',
      isUnread: false,
    ),
    NotificationItem(
      title: 'Health record verification needed',
      subtitle: 'Please confirm that all orphans have received their scheduled health checkups.',
      icon: Icons.health_and_safety,
      iconColor: Colors.purple,
      timestamp: '3 days ago',
      isUnread: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header section
            Row(
              children: [
                const Text(
                  'Updates',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${notifications.where((n) => n.isUnread).length}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Stay updated with the latest notifications',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 24),
            
            // Notifications list
            Expanded(
              child: ListView.builder(
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  final notification = notifications[index];
                  return _buildNotificationCard(notification);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationCard(NotificationItem notification) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Card(
        elevation: notification.isUnread ? 4 : 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: notification.isUnread 
              ? const BorderSide(color: Colors.green, width: 1)
              : BorderSide.none,
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            // TODO: Handle notification tap
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Notification icon
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: notification.iconColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Icon(
                    notification.icon,
                    color: notification.iconColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                
                // Notification content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        notification.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        notification.subtitle,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        notification.timestamp,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[400],
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Unread indicator
                if (notification.isUnread)
                  Container(
                    width: 12,
                    height: 12,
                    decoration: const BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Model class for notifications
class NotificationItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final String timestamp;
  final bool isUnread;

  const NotificationItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.timestamp,
    required this.isUnread,
  });
} 