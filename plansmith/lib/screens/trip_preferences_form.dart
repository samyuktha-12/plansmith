import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_styles.dart';

class TripPreferencesForm extends StatefulWidget {
  final Function(Map<String, dynamic>) onSubmit;

  const TripPreferencesForm({
    super.key,
    required this.onSubmit,
  });

  @override
  State<TripPreferencesForm> createState() => _TripPreferencesFormState();
}

class _TripPreferencesFormState extends State<TripPreferencesForm> {
  final _formKey = GlobalKey<FormState>();
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Form data
  String _destination = '';
  String _destinationCountry = '';
  String _selectedAge = '25-35';
  List<String> _selectedThemes = ['Heritage', 'Adventure']; // Default themes
  String _budgetLevel = 'mid_range';
  int _budgetAmount = 50000;
  int _travelersCount = 1;
  String _tripDuration = '5';
  List<String> _selectedInterests = ['Museums', 'Beaches']; // Default interests
  String _travelStyle = 'balanced';
  String _notes = '';

  final List<String> _ageGroups = ['18-25', '25-35', '35-45', '45-55', '55+'];
  final List<String> _themes = [
    'Heritage',
    'Adventure',
    'Relaxation',
    'Cultural',
    'Food',
    'Nightlife',
    'Shopping',
    'Nature',
    'Photography',
    'Wellness',
  ];
  final List<String> _interests = [
    'Museums',
    'Beaches',
    'Mountains',
    'Temples',
    'Markets',
    'Wildlife',
    'Water Sports',
    'Hiking',
    'Local Cuisine',
    'Art Galleries',
  ];
  final List<String> _travelStyles = [
    'Budget',
    'Balanced',
    'Luxury',
    'Adventure',
    'Cultural',
    'Relaxed',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: Text(
          'Trip Preferences',
          style: AppStyles.heading3.copyWith(color: AppColors.primary),
        ),
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (_currentPage > 0)
            TextButton(
              onPressed: () {
                _pageController.previousPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
              child: Text(
                'Back',
                style: AppStyles.labelLarge.copyWith(color: AppColors.primary),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          // Progress indicator
          Container(
            padding: const EdgeInsets.all(AppStyles.spacing16),
            child: Row(
              children: List.generate(3, (index) {
                return Expanded(
                  child: Container(
                    height: 4,
                    margin: EdgeInsets.only(
                      right: index < 2 ? AppStyles.spacing8 : 0,
                    ),
                    decoration: BoxDecoration(
                      color: index <= _currentPage
                          ? AppColors.primary
                          : AppColors.grey300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                );
              }),
            ),
          ),
          // Form pages
          Expanded(
            child: Form(
              key: _formKey,
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                children: [
                  _buildBasicInfoPage(),
                  _buildPreferencesPage(),
                  _buildAdditionalInfoPage(),
                ],
              ),
            ),
          ),
          // Bottom navigation
          Container(
            padding: const EdgeInsets.all(AppStyles.spacing24),
            child: Row(
              children: [
                if (_currentPage < 2) ...[
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                      style: AppStyles.outlineButton,
                      child: Text(
                        'Next',
                        style: AppStyles.labelLarge,
                      ),
                    ),
                  ),
                ] else ...[
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _submitForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.white,
                        padding: const EdgeInsets.symmetric(
                          vertical: AppStyles.spacing16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppStyles.radius12),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'Create Trip',
                        style: AppStyles.labelLarge.copyWith(
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBasicInfoPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppStyles.spacing24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Basic Information',
            style: AppStyles.heading2.copyWith(color: AppColors.primary),
          ),
          const SizedBox(height: AppStyles.spacing8),
          Text(
            'Tell us about your trip basics',
            style: AppStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: AppStyles.spacing32),
          
          // Destination
          Text(
            'Destination',
            style: AppStyles.labelLarge.copyWith(color: AppColors.textPrimary),
          ),
          const SizedBox(height: AppStyles.spacing12),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: 'City (e.g., Paris)',
                    hintStyle: AppStyles.bodyMedium.copyWith(color: AppColors.textTertiary),
                    filled: true,
                    fillColor: AppColors.grey100,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppStyles.radius12),
                      borderSide: const BorderSide(color: AppColors.border),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppStyles.radius12),
                      borderSide: const BorderSide(color: AppColors.border),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppStyles.radius12),
                      borderSide: const BorderSide(color: AppColors.primary, width: 2),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: AppStyles.spacing16,
                      vertical: AppStyles.spacing12,
                    ),
                  ),
                  style: AppStyles.bodyMedium,
                  onChanged: (value) {
                    setState(() {
                      _destination = value;
                    });
                  },
                ),
              ),
              const SizedBox(width: AppStyles.spacing12),
              Expanded(
                flex: 2,
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Country (e.g., France)',
                    hintStyle: AppStyles.bodyMedium.copyWith(color: AppColors.textTertiary),
                    filled: true,
                    fillColor: AppColors.grey100,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppStyles.radius12),
                      borderSide: const BorderSide(color: AppColors.border),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppStyles.radius12),
                      borderSide: const BorderSide(color: AppColors.border),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppStyles.radius12),
                      borderSide: const BorderSide(color: AppColors.primary, width: 2),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: AppStyles.spacing16,
                      vertical: AppStyles.spacing12,
                    ),
                  ),
                  style: AppStyles.bodyMedium,
                  onChanged: (value) {
                    setState(() {
                      _destinationCountry = value;
                    });
                  },
                ),
              ),
            ],
          ),
          
          const SizedBox(height: AppStyles.spacing24),
          
          // Age Group
          Text(
            'Age Group',
            style: AppStyles.labelLarge.copyWith(color: AppColors.textPrimary),
          ),
          const SizedBox(height: AppStyles.spacing12),
          Wrap(
            spacing: AppStyles.spacing12,
            runSpacing: AppStyles.spacing12,
            children: _ageGroups.map((age) {
              final isSelected = _selectedAge == age;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedAge = age;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppStyles.spacing16,
                    vertical: AppStyles.spacing12,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary : AppColors.grey100,
                    borderRadius: BorderRadius.circular(AppStyles.radius12),
                    border: Border.all(
                      color: isSelected ? AppColors.primary : AppColors.border,
                    ),
                  ),
                  child: Text(
                    age,
                    style: AppStyles.labelMedium.copyWith(
                      color: isSelected ? AppColors.white : AppColors.textPrimary,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          
          const SizedBox(height: AppStyles.spacing24),
          
          // Travelers Count
          Text(
            'Number of Travelers',
            style: AppStyles.labelLarge.copyWith(color: AppColors.textPrimary),
          ),
          const SizedBox(height: AppStyles.spacing12),
          Row(
            children: [
              IconButton(
                onPressed: _travelersCount > 1
                    ? () {
                        setState(() {
                          _travelersCount--;
                        });
                      }
                    : null,
                icon: const Icon(Icons.remove_circle_outline),
                color: AppColors.primary,
              ),
              Container(
                width: 60,
                padding: const EdgeInsets.symmetric(vertical: AppStyles.spacing12),
                decoration: BoxDecoration(
                  color: AppColors.grey100,
                  borderRadius: BorderRadius.circular(AppStyles.radius8),
                ),
                child: Text(
                  _travelersCount.toString(),
                  textAlign: TextAlign.center,
                  style: AppStyles.heading3.copyWith(color: AppColors.primary),
                ),
              ),
              IconButton(
                onPressed: _travelersCount < 10
                    ? () {
                        setState(() {
                          _travelersCount++;
                        });
                      }
                    : null,
                icon: const Icon(Icons.add_circle_outline),
                color: AppColors.primary,
              ),
            ],
          ),
          
          const SizedBox(height: AppStyles.spacing24),
          
          // Trip Duration
          Text(
            'Trip Duration (Days)',
            style: AppStyles.labelLarge.copyWith(color: AppColors.textPrimary),
          ),
          const SizedBox(height: AppStyles.spacing12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: AppStyles.spacing16),
            decoration: BoxDecoration(
              color: AppColors.grey100,
              borderRadius: BorderRadius.circular(AppStyles.radius12),
              border: Border.all(color: AppColors.border),
            ),
            child: DropdownButtonFormField<String>(
              value: _tripDuration,
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: AppStyles.spacing12),
              ),
              items: ['3', '5', '7', '10', '14', '21'].map((duration) {
                return DropdownMenuItem(
                  value: duration,
                  child: Text(duration),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _tripDuration = value!;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreferencesPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppStyles.spacing24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Travel Preferences',
            style: AppStyles.heading2.copyWith(color: AppColors.primary),
          ),
          const SizedBox(height: AppStyles.spacing8),
          Text(
            'What kind of experiences are you looking for?',
            style: AppStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: AppStyles.spacing32),
          
          // Themes
          Text(
            'Travel Themes',
            style: AppStyles.labelLarge.copyWith(color: AppColors.textPrimary),
          ),
          const SizedBox(height: AppStyles.spacing12),
          Wrap(
            spacing: AppStyles.spacing12,
            runSpacing: AppStyles.spacing12,
            children: _themes.map((theme) {
              final isSelected = _selectedThemes.contains(theme);
              return GestureDetector(
                onTap: () {
                  setState(() {
                    if (isSelected) {
                      _selectedThemes.remove(theme);
                    } else {
                      _selectedThemes.add(theme);
                    }
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppStyles.spacing16,
                    vertical: AppStyles.spacing12,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary : AppColors.grey100,
                    borderRadius: BorderRadius.circular(AppStyles.radius12),
                    border: Border.all(
                      color: isSelected ? AppColors.primary : AppColors.border,
                    ),
                  ),
                  child: Text(
                    theme,
                    style: AppStyles.labelMedium.copyWith(
                      color: isSelected ? AppColors.white : AppColors.textPrimary,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          
          const SizedBox(height: AppStyles.spacing24),
          
          // Interests
          Text(
            'Specific Interests',
            style: AppStyles.labelLarge.copyWith(color: AppColors.textPrimary),
          ),
          const SizedBox(height: AppStyles.spacing12),
          Wrap(
            spacing: AppStyles.spacing12,
            runSpacing: AppStyles.spacing12,
            children: _interests.map((interest) {
              final isSelected = _selectedInterests.contains(interest);
              return GestureDetector(
                onTap: () {
                  setState(() {
                    if (isSelected) {
                      _selectedInterests.remove(interest);
                    } else {
                      _selectedInterests.add(interest);
                    }
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppStyles.spacing16,
                    vertical: AppStyles.spacing12,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.secondary : AppColors.grey100,
                    borderRadius: BorderRadius.circular(AppStyles.radius12),
                    border: Border.all(
                      color: isSelected ? AppColors.secondary : AppColors.border,
                    ),
                  ),
                  child: Text(
                    interest,
                    style: AppStyles.labelMedium.copyWith(
                      color: isSelected ? AppColors.white : AppColors.textPrimary,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          
          const SizedBox(height: AppStyles.spacing24),
          
          // Travel Style
          Text(
            'Travel Style',
            style: AppStyles.labelLarge.copyWith(color: AppColors.textPrimary),
          ),
          const SizedBox(height: AppStyles.spacing12),
          Wrap(
            spacing: AppStyles.spacing12,
            runSpacing: AppStyles.spacing12,
            children: _travelStyles.map((style) {
              final isSelected = _travelStyle == style;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _travelStyle = style;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppStyles.spacing16,
                    vertical: AppStyles.spacing12,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.success : AppColors.grey100,
                    borderRadius: BorderRadius.circular(AppStyles.radius12),
                    border: Border.all(
                      color: isSelected ? AppColors.success : AppColors.border,
                    ),
                  ),
                  child: Text(
                    style,
                    style: AppStyles.labelMedium.copyWith(
                      color: isSelected ? AppColors.white : AppColors.textPrimary,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildAdditionalInfoPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppStyles.spacing24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Budget & Notes',
            style: AppStyles.heading2.copyWith(color: AppColors.primary),
          ),
          const SizedBox(height: AppStyles.spacing8),
          Text(
            'Set your budget and add any special notes',
            style: AppStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: AppStyles.spacing32),
          
          // Budget Level
          Text(
            'Budget Level',
            style: AppStyles.labelLarge.copyWith(color: AppColors.textPrimary),
          ),
          const SizedBox(height: AppStyles.spacing12),
          Row(
            children: [
              _buildBudgetOption('Budget', 'budget', Icons.account_balance_wallet),
              const SizedBox(width: AppStyles.spacing12),
              _buildBudgetOption('Mid-range', 'mid_range', Icons.star_half),
              const SizedBox(width: AppStyles.spacing12),
              _buildBudgetOption('Luxury', 'luxury', Icons.diamond),
            ],
          ),
          
          const SizedBox(height: AppStyles.spacing24),
          
          // Budget Amount
          Text(
            'Budget Amount (₹)',
            style: AppStyles.labelLarge.copyWith(color: AppColors.textPrimary),
          ),
          const SizedBox(height: AppStyles.spacing12),
          Container(
            padding: const EdgeInsets.all(AppStyles.spacing16),
            decoration: BoxDecoration(
              color: AppColors.grey100,
              borderRadius: BorderRadius.circular(AppStyles.radius12),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              children: [
                Text(
                  '₹${_budgetAmount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                  style: AppStyles.heading2.copyWith(color: AppColors.primary),
                ),
                Slider(
                  value: _budgetAmount.toDouble(),
                  min: 10000,
                  max: 500000,
                  divisions: 49,
                  activeColor: AppColors.primary,
                  inactiveColor: AppColors.grey300,
                  onChanged: (value) {
                    setState(() {
                      _budgetAmount = value.round();
                    });
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('₹10K', style: AppStyles.bodySmall),
                    Text('₹5L', style: AppStyles.bodySmall),
                  ],
                ),
              ],
            ),
          ),
          
          const SizedBox(height: AppStyles.spacing24),
          
          // Notes
          Text(
            'Special Notes',
            style: AppStyles.labelLarge.copyWith(color: AppColors.textPrimary),
          ),
          const SizedBox(height: AppStyles.spacing12),
          Container(
            padding: const EdgeInsets.all(AppStyles.spacing16),
            decoration: BoxDecoration(
              color: AppColors.grey100,
              borderRadius: BorderRadius.circular(AppStyles.radius12),
              border: Border.all(color: AppColors.border),
            ),
            child: TextFormField(
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Any special requirements, dietary restrictions, accessibility needs...',
                hintStyle: AppStyles.bodyMedium.copyWith(color: AppColors.textTertiary),
                border: InputBorder.none,
              ),
              style: AppStyles.bodyMedium,
              onChanged: (value) {
                _notes = value;
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBudgetOption(String label, String value, IconData icon) {
    final isSelected = _budgetLevel == value;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _budgetLevel = value;
          });
        },
        child: Container(
          padding: const EdgeInsets.all(AppStyles.spacing16),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : AppColors.grey100,
            borderRadius: BorderRadius.circular(AppStyles.radius12),
            border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.border,
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: isSelected ? AppColors.white : AppColors.primary,
                size: 24,
              ),
              const SizedBox(height: AppStyles.spacing8),
              Text(
                label,
                style: AppStyles.labelMedium.copyWith(
                  color: isSelected ? AppColors.white : AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitForm() {
    // Debug: Print current form state
    print('Submitting form with data:');
    print('Destination: $_destination, $_destinationCountry');
    print('Age: $_selectedAge');
    print('Themes: $_selectedThemes');
    print('Budget Level: $_budgetLevel');
    print('Budget Amount: $_budgetAmount');
    print('Travelers: $_travelersCount');
    
    // Validate destination
    if (_destination.isEmpty || _destinationCountry.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter both city and country for your destination'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }
    
    // Always submit for now (since we don't have complex validation)
    final preferences = {
      'destination': {
        'city': _destination,
        'country': _destinationCountry,
      },
      'age_group': _selectedAge,
      'themes': _selectedThemes,
      'interests': _selectedInterests,
      'budget_level': _budgetLevel,
      'budget_amount': _budgetAmount,
      'travelers_count': _travelersCount,
      'trip_duration': _tripDuration,
      'travel_style': _travelStyle,
      'notes': _notes,
      'created_at': DateTime.now().toIso8601String(),
    };
    
    print('Calling onSubmit with preferences: $preferences');
    widget.onSubmit(preferences);
    // Don't pop here - let the parent handle navigation
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
