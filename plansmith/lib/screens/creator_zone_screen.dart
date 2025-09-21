import 'package:flutter/material.dart';

class CreatorZoneScreen extends StatefulWidget {
  const CreatorZoneScreen({super.key});

  @override
  State<CreatorZoneScreen> createState() => _CreatorZoneScreenState();
}

class _CreatorZoneScreenState extends State<CreatorZoneScreen> {
  List<Map<String, dynamic>> posts = [];
  String selectedFilter = 'All';

  @override
  void initState() {
    super.initState();
    _loadMockData();
  }

  void _loadMockData() {
    // TODO: Replace with actual data from API
    posts = [
      {
        'id': '1',
        'title': 'Hidden Gems of Tokyo',
        'author': 'Sarah Chen',
        'authorAvatar': 'https://images.unsplash.com/photo-1494790108755-2616b612b786?w=150&h=150&fit=crop&crop=face',
        'snippet': 'Discover the most beautiful and lesser-known spots in Tokyo that most tourists miss. From secret gardens to local cafes...',
        'imageUrl': 'https://images.unsplash.com/photo-1540959733332-eab4deabeeaf?w=400&h=300&fit=crop',
        'likes': 124,
        'comments': 23,
        'shares': 8,
        'category': 'Travel Tips',
        'readTime': '5 min read',
        'date': DateTime.now().subtract(const Duration(days: 2)),
        'isLiked': false,
      },
      {
        'id': '2',
        'title': 'Budget Travel in Europe',
        'author': 'Mike Rodriguez',
        'authorAvatar': 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face',
        'snippet': 'How to explore Europe on a budget without compromising on experiences. My complete guide to affordable European travel...',
        'imageUrl': 'https://images.unsplash.com/photo-1469474968028-56623f02e42e?w=400&h=300&fit=crop',
        'likes': 89,
        'comments': 15,
        'shares': 12,
        'category': 'Budget Travel',
        'readTime': '7 min read',
        'date': DateTime.now().subtract(const Duration(days: 4)),
        'isLiked': true,
      },
      {
        'id': '3',
        'title': 'Solo Female Travel Safety',
        'author': 'Emma Wilson',
        'authorAvatar': 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=150&h=150&fit=crop&crop=face',
        'snippet': 'Essential safety tips and advice for women traveling alone. Stay safe while exploring the world independently...',
        'imageUrl': 'https://images.unsplash.com/photo-1488646950254-3c0e7d4e0282?w=400&h=300&fit=crop',
        'likes': 156,
        'comments': 31,
        'shares': 19,
        'category': 'Safety',
        'readTime': '6 min read',
        'date': DateTime.now().subtract(const Duration(days: 6)),
        'isLiked': false,
      },
      {
        'id': '4',
        'title': 'Photography Tips for Travelers',
        'author': 'Alex Thompson',
        'authorAvatar': 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150&h=150&fit=crop&crop=face',
        'snippet': 'Capture stunning travel photos with these professional photography techniques. From composition to lighting...',
        'imageUrl': 'https://images.unsplash.com/photo-1502920917128-1aa500764cbd?w=400&h=300&fit=crop',
        'likes': 203,
        'comments': 28,
        'shares': 15,
        'category': 'Photography',
        'readTime': '8 min read',
        'date': DateTime.now().subtract(const Duration(days: 8)),
        'isLiked': true,
      },
      {
        'id': '5',
        'title': 'Local Food Adventures',
        'author': 'Maria Garcia',
        'authorAvatar': 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=150&h=150&fit=crop&crop=face',
        'snippet': 'Exploring authentic local cuisines around the world. From street food to fine dining, discover amazing flavors...',
        'imageUrl': 'https://images.unsplash.com/photo-1555939594-58d7cb561ad1?w=400&h=300&fit=crop',
        'likes': 97,
        'comments': 18,
        'shares': 9,
        'category': 'Food',
        'readTime': '4 min read',
        'date': DateTime.now().subtract(const Duration(days: 10)),
        'isLiked': false,
      },
    ];
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
        title: const Text(
          'Creator Zone',
          style: TextStyle(
            fontFamily: 'Quicksand',
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF0E4F55),
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.search_rounded,
              color: Color(0xFF0E4F55),
              size: 20,
            ),
            onPressed: () {
              // TODO: Implement search functionality
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Search functionality coming soon!'),
                  backgroundColor: Color(0xFF0E4F55),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter Chips
          Container(
            height: 60,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildFilterChip('All'),
                const SizedBox(width: 8),
                _buildFilterChip('Travel Tips'),
                const SizedBox(width: 8),
                _buildFilterChip('Budget Travel'),
                const SizedBox(width: 8),
                _buildFilterChip('Safety'),
                const SizedBox(width: 8),
                _buildFilterChip('Photography'),
                const SizedBox(width: 8),
                _buildFilterChip('Food'),
              ],
            ),
          ),
          
          // Posts List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: posts.length,
              itemBuilder: (context, index) {
                return _buildPostCard(posts[index]);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCreatePostModal(),
        backgroundColor: const Color(0xFF0E4F55),
        foregroundColor: Colors.white,
        elevation: 0,
        icon: const Icon(Icons.add_rounded),
        label: const Text(
          'Create Post',
          style: TextStyle(
            fontFamily: 'Quicksand',
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    final isSelected = selectedFilter == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedFilter = label;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF0E4F55) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? const Color(0xFF0E4F55) : Colors.grey.shade300,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'Quicksand',
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : Colors.grey.shade700,
          ),
        ),
      ),
    );
  }

  Widget _buildPostCard(Map<String, dynamic> post) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Post Image
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Image.network(
                post['imageUrl'],
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          const Color(0xFF0E4F55).withOpacity(0.1),
                          const Color(0xFF0E4F55).withOpacity(0.05),
                        ],
                      ),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.image_rounded,
                        color: Color(0xFF0E4F55),
                        size: 48,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          
          // Post Content
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Author Info
                Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage(post['authorAvatar']),
                      onBackgroundImageError: (exception, stackTrace) {
                        // Handle image error
                      },
                      child: const Icon(
                        Icons.person_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            post['author'],
                            style: const TextStyle(
                              fontFamily: 'Quicksand',
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF0E4F55),
                            ),
                          ),
                          Text(
                            _formatDate(post['date']),
                            style: TextStyle(
                              fontFamily: 'Quicksand',
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0E4F55).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        post['category'],
                        style: const TextStyle(
                          fontFamily: 'Quicksand',
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF0E4F55),
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                // Post Title
                Text(
                  post['title'],
                  style: const TextStyle(
                    fontFamily: 'Quicksand',
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF0E4F55),
                    height: 1.2,
                  ),
                ),
                
                const SizedBox(height: 8),
                
                // Post Snippet
                Text(
                  post['snippet'],
                  style: TextStyle(
                    fontFamily: 'Quicksand',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey.shade700,
                    height: 1.4,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                
                const SizedBox(height: 12),
                
                // Post Meta
                Row(
                  children: [
                    Text(
                      post['readTime'],
                      style: TextStyle(
                        fontFamily: 'Quicksand',
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Icon(
                      Icons.visibility_rounded,
                      size: 16,
                      color: Colors.grey.shade600,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '1.2k views',
                      style: TextStyle(
                        fontFamily: 'Quicksand',
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                // Action Buttons
                Row(
                  children: [
                    _buildActionButton(
                      Icons.favorite_rounded,
                      post['likes'].toString(),
                      post['isLiked'],
                      () => _toggleLike(post['id']),
                    ),
                    const SizedBox(width: 24),
                    _buildActionButton(
                      Icons.comment_rounded,
                      post['comments'].toString(),
                      false,
                      () => _showComments(post['id']),
                    ),
                    const SizedBox(width: 24),
                    _buildActionButton(
                      Icons.share_rounded,
                      post['shares'].toString(),
                      false,
                      () => _sharePost(post['id']),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () => _readFullPost(post['id']),
                      child: const Text(
                        'Read More',
                        style: TextStyle(
                          fontFamily: 'Quicksand',
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF0E4F55),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String count, bool isActive, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: isActive ? Colors.red : Colors.grey.shade600,
          ),
          const SizedBox(width: 6),
          Text(
            count,
            style: TextStyle(
              fontFamily: 'Quicksand',
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: isActive ? Colors.red : Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  void _toggleLike(String postId) {
    setState(() {
      final postIndex = posts.indexWhere((post) => post['id'] == postId);
      if (postIndex != -1) {
        posts[postIndex]['isLiked'] = !posts[postIndex]['isLiked'];
        posts[postIndex]['likes'] += posts[postIndex]['isLiked'] ? 1 : -1;
      }
    });
  }

  void _showComments(String postId) {
    // TODO: Implement comments functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Comments functionality coming soon!'),
        backgroundColor: Color(0xFF0E4F55),
      ),
    );
  }

  void _sharePost(String postId) {
    // TODO: Implement share functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Share functionality coming soon!'),
        backgroundColor: Color(0xFF0E4F55),
      ),
    );
  }

  void _readFullPost(String postId) {
    // TODO: Navigate to full post view
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Full post view coming soon!'),
        backgroundColor: Color(0xFF0E4F55),
      ),
    );
  }

  void _showCreatePostModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.8,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Handle bar
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                
                const Text(
                  'Create New Post',
                  style: TextStyle(
                    fontFamily: 'Quicksand',
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF0E4F55),
                  ),
                ),
                const SizedBox(height: 24),
                
                // Form fields
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Post Title',
                    hintText: 'Enter an engaging title...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.title_rounded),
                  ),
                ),
                const SizedBox(height: 16),
                
                TextField(
                  maxLines: 4,
                  decoration: InputDecoration(
                    labelText: 'Post Content',
                    hintText: 'Share your travel experiences, tips, or stories...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignLabelWithHint: true,
                  ),
                ),
                const SizedBox(height: 16),
                
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Category',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.category_rounded),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'Travel Tips', child: Text('Travel Tips')),
                    DropdownMenuItem(value: 'Budget Travel', child: Text('Budget Travel')),
                    DropdownMenuItem(value: 'Safety', child: Text('Safety')),
                    DropdownMenuItem(value: 'Photography', child: Text('Photography')),
                    DropdownMenuItem(value: 'Food', child: Text('Food')),
                    DropdownMenuItem(value: 'Other', child: Text('Other')),
                  ],
                  onChanged: (value) {},
                ),
                const SizedBox(height: 16),
                
                // Image upload placeholder
                Container(
                  width: double.infinity,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.grey.shade300,
                      style: BorderStyle.solid,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add_photo_alternate_rounded,
                        color: Colors.grey.shade600,
                        size: 32,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Add Photo',
                        style: TextStyle(
                          fontFamily: 'Quicksand',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                
                // Publish button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Post created successfully!'),
                          backgroundColor: Color(0xFF0E4F55),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0E4F55),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      'Publish Post',
                      style: TextStyle(
                        fontFamily: 'Quicksand',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date).inDays;
    
    if (difference == 0) {
      return 'Today';
    } else if (difference == 1) {
      return 'Yesterday';
    } else if (difference < 7) {
      return '$difference days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
