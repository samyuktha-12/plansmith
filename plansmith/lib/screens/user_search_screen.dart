import 'package:flutter/material.dart';

class UserSearchScreen extends StatefulWidget {
  final String tripId;
  final String tripName;

  const UserSearchScreen({
    super.key,
    required this.tripId,
    required this.tripName,
  });

  @override
  State<UserSearchScreen> createState() => _UserSearchScreenState();
}

class _UserSearchScreenState extends State<UserSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> users = [];
  List<Map<String, dynamic>> selectedUsers = [];
  List<Map<String, dynamic>> groupMembers = [];

  @override
  void initState() {
    super.initState();
    _loadMockUsers();
    _loadGroupMembers();
  }

  void _loadMockUsers() {
    // TODO: Replace with actual API call
    users = [
      {
        'id': '1',
        'name': 'Sarah Chen',
        'email': 'sarah.chen@email.com',
        'avatar': 'https://images.unsplash.com/photo-1494790108755-2616b612b786?w=150&h=150&fit=crop&crop=face',
        'isOnline': true,
        'mutualFriends': 5,
        'isSelected': false,
      },
      {
        'id': '2',
        'name': 'Mike Rodriguez',
        'email': 'mike.rodriguez@email.com',
        'avatar': 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face',
        'isOnline': false,
        'mutualFriends': 12,
        'isSelected': false,
      },
      {
        'id': '3',
        'name': 'Emma Wilson',
        'email': 'emma.wilson@email.com',
        'avatar': 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=150&h=150&fit=crop&crop=face',
        'isOnline': true,
        'mutualFriends': 8,
        'isSelected': false,
      },
      {
        'id': '4',
        'name': 'Alex Thompson',
        'email': 'alex.thompson@email.com',
        'avatar': 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150&h=150&fit=crop&crop=face',
        'isOnline': true,
        'mutualFriends': 3,
        'isSelected': false,
      },
      {
        'id': '5',
        'name': 'Maria Garcia',
        'email': 'maria.garcia@email.com',
        'avatar': 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=150&h=150&fit=crop&crop=face',
        'isOnline': false,
        'mutualFriends': 15,
        'isSelected': false,
      },
    ];
  }

  void _loadGroupMembers() {
    // TODO: Replace with actual API call
    groupMembers = [
      {
        'id': 'current_user',
        'name': 'You',
        'email': 'you@email.com',
        'avatar': 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150&h=150&fit=crop&crop=face',
        'isAdmin': true,
        'isOnline': true,
      },
    ];
  }

  void _searchUsers(String query) {
    setState(() {
      if (query.isEmpty) {
        users = users.map((user) => {...user, 'isSelected': false}).toList();
      } else {
        // Filter users based on search query
        // In real app, this would be an API call
      }
    });
  }

  void _toggleUserSelection(String userId) {
    setState(() {
      final userIndex = users.indexWhere((user) => user['id'] == userId);
      if (userIndex != -1) {
        users[userIndex]['isSelected'] = !users[userIndex]['isSelected'];
        
        if (users[userIndex]['isSelected']) {
          selectedUsers.add(users[userIndex]);
        } else {
          selectedUsers.removeWhere((user) => user['id'] == userId);
        }
      }
    });
  }

  void _addSelectedUsersToGroup() {
    // TODO: Implement API call to add users to group
    setState(() {
      groupMembers.addAll(selectedUsers);
      selectedUsers.clear();
      users = users.map((user) => {...user, 'isSelected': false}).toList();
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${selectedUsers.length} users added to ${widget.tripName}'),
        backgroundColor: const Color(0xFF0E4F55),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_rounded,
            color: Color(0xFF0E4F55),
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Add to ${widget.tripName}',
          style: const TextStyle(
            fontFamily: 'Quicksand',
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF0E4F55),
          ),
        ),
        centerTitle: true,
        actions: [
          if (selectedUsers.isNotEmpty)
            TextButton(
              onPressed: _addSelectedUsersToGroup,
              child: Text(
                'Add (${selectedUsers.length})',
                style: const TextStyle(
                  fontFamily: 'Quicksand',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF0E4F55),
                ),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            padding: const EdgeInsets.all(20),
            color: Colors.white,
            child: TextField(
              controller: _searchController,
              onChanged: _searchUsers,
              decoration: InputDecoration(
                hintText: 'Search users by name or email...',
                prefixIcon: const Icon(Icons.search_rounded),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded),
                        onPressed: () {
                          _searchController.clear();
                          _searchUsers('');
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFF0E4F55), width: 2),
                ),
              ),
            ),
          ),

          // Group Members Section
          if (groupMembers.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(20),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Group Members',
                    style: TextStyle(
                      fontFamily: 'Quicksand',
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF0E4F55),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 60,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: groupMembers.length,
                      itemBuilder: (context, index) {
                        final member = groupMembers[index];
                        return Container(
                          margin: const EdgeInsets.only(right: 12),
                          child: Column(
                            children: [
                              Stack(
                                children: [
                                  CircleAvatar(
                                    radius: 24,
                                    backgroundImage: NetworkImage(member['avatar']),
                                    onBackgroundImageError: (exception, stackTrace) {
                                      // Handle image error
                                    },
                                    child: const Icon(
                                      Icons.person_rounded,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                  if (member['isAdmin'])
                                    Positioned(
                                      bottom: 0,
                                      right: 0,
                                      child: Container(
                                        width: 16,
                                        height: 16,
                                        decoration: const BoxDecoration(
                                          color: Color(0xFF0E4F55),
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.star_rounded,
                                          color: Colors.white,
                                          size: 10,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                member['name'],
                                style: const TextStyle(
                                  fontFamily: 'Quicksand',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF0E4F55),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

          // Search Results
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return _buildUserCard(user);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserCard(Map<String, dynamic> user) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: user['isSelected'] 
              ? const Color(0xFF0E4F55) 
              : Colors.grey.shade200,
          width: user['isSelected'] ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundImage: NetworkImage(user['avatar']),
                onBackgroundImageError: (exception, stackTrace) {
                  // Handle image error
                },
                child: const Icon(
                  Icons.person_rounded,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              if (user['isOnline'])
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user['name'],
                  style: const TextStyle(
                    fontFamily: 'Quicksand',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF0E4F55),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  user['email'],
                  style: TextStyle(
                    fontFamily: 'Quicksand',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${user['mutualFriends']} mutual friends',
                  style: TextStyle(
                    fontFamily: 'Quicksand',
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => _toggleUserSelection(user['id']),
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: user['isSelected'] 
                    ? const Color(0xFF0E4F55) 
                    : Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(
                  color: user['isSelected'] 
                      ? const Color(0xFF0E4F55) 
                      : Colors.grey.shade400,
                  width: 2,
                ),
              ),
              child: user['isSelected']
                  ? const Icon(
                      Icons.check_rounded,
                      color: Colors.white,
                      size: 16,
                    )
                  : null,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
