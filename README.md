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

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.


## 🗺️ Roadmap

### Phase 1 (Current)
- [x] Basic trip planning
- [x] AI itinerary generation
- [x] Group trip management
- [x] Mobile app (iOS/Android)

### Phase 2 (Q2 2025)
- [ ] Advanced AI features
- [ ] Real-time collaboration
- [ ] Payment integration
- [ ] Web dashboard

### Phase 3 (Q3 2025)
- [ ] Social features
- [ ] Travel marketplace
- [ ] Advanced analytics
- [ ] Multi-language support

---

<div align="center">
  <p>Made with ❤️ by the PlanSmith Team</p>
  <p>© 2025 PlanSmith. All rights reserved.</p>
</div>
