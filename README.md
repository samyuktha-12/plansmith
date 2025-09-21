# 🧳 PlanSmith - AI-Powered Trip Planner

<div align="center">
  <img src="plansmith/assets/images/logo.png" alt="PlanSmith Logo" width="200" height="200">
  
  **Your Personal AI Travel Companion**
  
  [![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev/)
  [![Python](https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white)](https://python.org/)
  [![Firebase](https://img.shields.io/badge/Firebase-FFCA28?style=for-the-badge&logo=firebase&logoColor=black)](https://firebase.google.com/)
  [![Google AI](https://img.shields.io/badge/Google_AI-4285F4?style=for-the-badge&logo=google&logoColor=white)](https://ai.google/)
</div>

## 🌟 Overview

PlanSmith is an intelligent travel planning application that leverages AI to create personalized, comprehensive travel itineraries. Whether you're planning a solo adventure, family vacation, or group trip, PlanSmith adapts to your preferences, budget, and real-time conditions to deliver the perfect travel experience.

## ✨ Key Features

### 🤖 AI-Powered Planning
- **Smart Itinerary Generation**: Uses Google Gemini AI to create personalized travel plans
- **Real-time Adaptations**: Automatically adjusts plans based on weather, events, and local conditions
- **Multi-destination Support**: Plan complex multi-city trips with seamless connections
- **Budget Optimization**: AI suggests cost-effective alternatives while maintaining quality

### 🎯 Personalization
- **Interest-based Recommendations**: Tailored suggestions based on your hobbies and preferences
- **Budget Flexibility**: Support for budget, mid-range, and luxury travel styles
- **Group Trip Management**: Collaborative planning with friends and family
- **Learning Algorithm**: Gets smarter with each trip you plan

### 🌍 Comprehensive Coverage
- **Global Destinations**: Support for major cities worldwide with detailed local information
- **Indian Focus**: Specialized coverage for Indian cities and destinations
- **Real-time Data**: Live weather, events, and local condition updates
- **Multilingual Support**: Designed for diverse travel destinations

### 📱 Modern Mobile Experience
- **Cross-platform**: Native iOS and Android apps built with Flutter
- **Intuitive UI**: Clean, modern interface with smooth animations
- **Offline Support**: Access your itineraries even without internet
- **Social Sharing**: Share your travel plans and memories with friends

## 🏗️ Architecture

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Flutter App   │────│   FastAPI       │────│   Google Cloud  │
│   (Mobile)      │    │   Backend       │    │   Services      │
└─────────────────┘    └─────────────────┘    └─────────────────┘
         │                       │                       │
         │                       ▼                       │
         │              ┌─────────────────┐              │
         │              │   Firebase      │              │
         └──────────────│   Firestore     │──────────────┘
                        └─────────────────┘
```

## 🛠️ Tech Stack

### Frontend (Mobile App)
- **Flutter 3.8+**: Cross-platform mobile development
- **Dart**: Programming language
- **Custom Fonts**: Quicksand, Sacramento, StyleScript
- **State Management**: Provider pattern
- **UI Components**: Material Design 3

### Backend (API Server)
- **FastAPI**: Modern, fast web framework
- **Python 3.9+**: Backend programming language
- **Pydantic**: Data validation and serialization
- **Uvicorn**: ASGI server

### Cloud Services
- **Google Gemini AI**: Advanced AI for itinerary generation
- **Google Maps API**: Location data, directions, places
- **Firebase**: Authentication, database, storage
- **Firebase Auth**: User authentication
- **Cloud Firestore**: NoSQL database
- **Firebase Storage**: File and image storage

### External APIs
- **Amadeus API**: Flight and hotel booking
- **Google Places API**: Local business information
- **Weather APIs**: Real-time weather data
- **Event APIs**: Local events and activities

## 🚀 Getting Started

### Prerequisites

- **Flutter SDK** (3.8.1 or higher)
- **Dart SDK** (3.0.0 or higher)
- **Python** (3.9 or higher)
- **Node.js** (for development tools)
- **Git** (for version control)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/plansmith.git
   cd plansmith
   ```

2. **Set up the Flutter app**
   ```bash
   cd plansmith
   flutter pub get
   flutter doctor
   ```

3. **Set up the backend**
   ```bash
   cd backend
   python -m venv venv
   source venv/bin/activate  # On Windows: venv\Scripts\activate
   pip install -r requirements.txt
   ```

4. **Configure environment variables**
   ```bash
   cp backend/env_example.txt backend/.env
   # Edit backend/.env with your API keys
   ```

5. **Run the application**
   ```bash
   # Terminal 1: Start the backend
   cd backend
   python main.py
   
   # Terminal 2: Start the Flutter app
   cd plansmith
   flutter run
   ```

## 📱 Mobile App Features

### 🏠 Home Screen
- Personalized trip recommendations
- Quick access to recent trips
- Weather updates for planned destinations
- One-tap trip creation

### 🗺️ Trip Planning
- Interactive destination selection
- Budget and preference configuration
- AI-generated itinerary suggestions
- Real-time plan adjustments

### 👥 Group Trips
- Collaborative planning with friends
- Expense tracking and splitting
- Group chat and updates
- Shared photo galleries

### 📊 Trip Management
- Detailed itinerary views
- Booking confirmations
- Expense tracking
- Photo and memory sharing

## 🔧 Backend API

### Core Endpoints

- `POST /api/trips/create` - Create new trip
- `GET /api/trips/{trip_id}` - Get trip details
- `PUT /api/trips/{trip_id}` - Update trip
- `DELETE /api/trips/{trip_id}` - Delete trip
- `POST /api/itinerary/generate` - Generate AI itinerary
- `GET /api/places/search` - Search places
- `GET /api/weather/{location}` - Get weather data

### Authentication
- Firebase Auth integration
- JWT token validation
- User profile management

## 🎨 Design System

### Colors
- **Primary**: `#0E4F55` (Teal)
- **Secondary**: `#FF6B6B` (Coral)
- **Accent**: `#4ECDC4` (Mint)
- **Background**: `#F8F9FA` (Light Gray)

### Typography
- **Primary Font**: Quicksand (Regular, Medium, SemiBold, Bold)
- **Display Font**: Sacramento (Script)
- **Accent Font**: StyleScript (Handwriting)

### Components
- Material Design 3 components
- Custom card designs
- Animated transitions
- Responsive layouts

## 📊 Project Structure

```
plansmith/
├── plansmith/                 # Flutter mobile app
│   ├── lib/
│   │   ├── screens/          # UI screens
│   │   ├── widgets/          # Reusable components
│   │   ├── services/         # API services
│   │   ├── models/           # Data models
│   │   └── constants/        # App constants
│   ├── assets/               # Images, fonts, videos
│   └── pubspec.yaml         # Flutter dependencies
├── backend/                  # Python FastAPI backend
│   ├── api/                 # API routes
│   ├── services/            # Business logic
│   ├── models/              # Data models
│   └── requirements.txt     # Python dependencies
└── README.md               # This file
```

## 🤝 Contributing

We welcome contributions! Please see our [Contributing Guidelines](CONTRIBUTING.md) for details.

### Development Setup
1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- **Google Cloud Platform** for AI and mapping services
- **Flutter Team** for the amazing cross-platform framework
- **FastAPI** for the modern Python web framework
- **Firebase** for backend services
- **Unsplash** for beautiful travel images

## 📞 Support

- **Documentation**: [Wiki](https://github.com/yourusername/plansmith/wiki)
- **Issues**: [GitHub Issues](https://github.com/yourusername/plansmith/issues)
- **Discussions**: [GitHub Discussions](https://github.com/yourusername/plansmith/discussions)
- **Email**: support@plansmith.app

## 🗺️ Roadmap

### Phase 1 (Current)
- [x] Basic trip planning
- [x] AI itinerary generation
- [x] Group trip management
- [x] Mobile app (iOS/Android)

### Phase 2 (Q2 2024)
- [ ] Advanced AI features
- [ ] Real-time collaboration
- [ ] Payment integration
- [ ] Web dashboard

### Phase 3 (Q3 2024)
- [ ] Social features
- [ ] Travel marketplace
- [ ] Advanced analytics
- [ ] Multi-language support

---

<div align="center">
  <p>Made with ❤️ by the PlanSmith Team</p>
  <p>© 2024 PlanSmith. All rights reserved.</p>
</div>
