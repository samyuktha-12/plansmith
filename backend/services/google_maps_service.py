import os
import googlemaps
from typing import Dict, List, Any, Optional, Tuple
import logging
from datetime import datetime, timedelta
import requests
from .mock_data_service import MockDataService

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

class GoogleMapsService:
    def __init__(self):
        """Initialize Google Maps service with fallback to mock data"""
        self.api_key = os.getenv("GOOGLE_MAPS_API_KEY")
        self.use_mock_data = False
        self.mock_service = MockDataService()
        
        if not self.api_key or self.api_key == "your-google-maps-api-key":
            logger.warning("Google Maps API key not configured, using mock data")
            self.use_mock_data = True
        else:
            try:
                self.gmaps = googlemaps.Client(key=self.api_key)
                logger.info("Google Maps service initialized successfully")
            except Exception as e:
                logger.warning(f"Failed to initialize Google Maps service: {e}. Using mock data.")
                self.use_mock_data = True
        
    async def get_place_details(self, place_name: str, city: str = None, state: str = None) -> Dict[str, Any]:
        """Get detailed information about a place"""
        if self.use_mock_data:
            return self._get_mock_place_details(place_name, city, state)
        
        try:
            # Search for the place
            search_query = f"{place_name}"
            if city:
                search_query += f", {city}"
            if state:
                search_query += f", {state}"
            
            places_result = self.gmaps.places(query=search_query)
            
            if not places_result['results']:
                return {"error": "Place not found"}
            
            place = places_result['results'][0]
            place_id = place['place_id']
            
            # Get detailed information
            details = self.gmaps.place(
                place_id=place_id,
                fields=['name', 'formatted_address', 'geometry', 'rating', 'user_ratings_total',
                       'price_level', 'types', 'photos', 'opening_hours', 'website', 'formatted_phone_number']
            )
            
            return self._format_place_details(details['result'])
            
        except Exception as e:
            logger.error(f"Error getting place details: {str(e)}")
            return {"error": str(e)}
    
    def _format_place_details(self, place_data: Dict[str, Any]) -> Dict[str, Any]:
        """Format place details into a consistent structure"""
        return {
            "place_id": place_data.get('place_id'),
            "name": place_data.get('name'),
            "formatted_address": place_data.get('formatted_address'),
            "location": {
                "latitude": place_data.get('geometry', {}).get('location', {}).get('lat'),
                "longitude": place_data.get('geometry', {}).get('location', {}).get('lng')
            },
            "rating": place_data.get('rating'),
            "user_ratings_total": place_data.get('user_ratings_total'),
            "price_level": place_data.get('price_level'),
            "types": place_data.get('types', []),
            "photos": place_data.get('photos', []),
            "opening_hours": place_data.get('opening_hours', {}),
            "website": place_data.get('website'),
            "phone_number": place_data.get('formatted_phone_number')
        }
    
    async def search_attractions(self, city: str, state: str, 
                               attraction_types: List[str] = None) -> List[Dict[str, Any]]:
        """Search for attractions in a city"""
        if self.use_mock_data:
            return self._get_mock_attractions(city, state, attraction_types)
        
        try:
            query = f"tourist attractions in {city}, {state}"
            
            places_result = self.gmaps.places(
                query=query,
                type='tourist_attraction'
            )
            
            attractions = []
            for place in places_result['results'][:20]:  # Limit to 20 results
                attraction = {
                    "place_id": place.get('place_id'),
                    "name": place.get('name'),
                    "rating": place.get('rating'),
                    "user_ratings_total": place.get('user_ratings_total'),
                    "price_level": place.get('price_level'),
                    "location": {
                        "latitude": place.get('geometry', {}).get('location', {}).get('lat'),
                        "longitude": place.get('geometry', {}).get('location', {}).get('lng')
                    },
                    "formatted_address": place.get('formatted_address'),
                    "types": place.get('types', [])
                }
                attractions.append(attraction)
            
            return attractions
            
        except Exception as e:
            logger.error(f"Error searching attractions: {str(e)}")
            return []
    
    async def search_restaurants(self, city: str, state: str, 
                               cuisine_types: List[str] = None,
                               price_level: int = None) -> List[Dict[str, Any]]:
        """Search for restaurants in a city"""
        if self.use_mock_data:
            return self._get_mock_restaurants(city, state, cuisine_types, price_level)
        
        try:
            query = f"restaurants in {city}, {state}"
            if cuisine_types:
                query += f" {', '.join(cuisine_types)}"
            
            places_result = self.gmaps.places(
                query=query,
                type='restaurant'
            )
            
            restaurants = []
            for place in places_result['results'][:15]:  # Limit to 15 results
                restaurant = {
                    "place_id": place.get('place_id'),
                    "name": place.get('name'),
                    "rating": place.get('rating'),
                    "user_ratings_total": place.get('user_ratings_total'),
                    "price_level": place.get('price_level'),
                    "location": {
                        "latitude": place.get('geometry', {}).get('location', {}).get('lat'),
                        "longitude": place.get('geometry', {}).get('location', {}).get('lng')
                    },
                    "formatted_address": place.get('formatted_address'),
                    "types": place.get('types', [])
                }
                
                # Filter by price level if specified
                if price_level is None or restaurant["price_level"] == price_level:
                    restaurants.append(restaurant)
            
            return restaurants
            
        except Exception as e:
            logger.error(f"Error searching restaurants: {str(e)}")
            return []
    
    async def search_accommodations(self, city: str, state: str, 
                                  accommodation_type: str = "hotel",
                                  price_level: int = None) -> List[Dict[str, Any]]:
        """Search for accommodations in a city"""
        if self.use_mock_data:
            return self._get_mock_accommodations(city, state, accommodation_type, price_level)
        
        try:
            query = f"{accommodation_type} in {city}, {state}"
            
            places_result = self.gmaps.places(
                query=query,
                type='lodging'
            )
            
            accommodations = []
            for place in places_result['results'][:10]:  # Limit to 10 results
                accommodation = {
                    "place_id": place.get('place_id'),
                    "name": place.get('name'),
                    "rating": place.get('rating'),
                    "user_ratings_total": place.get('user_ratings_total'),
                    "price_level": place.get('price_level'),
                    "location": {
                        "latitude": place.get('geometry', {}).get('location', {}).get('lat'),
                        "longitude": place.get('geometry', {}).get('location', {}).get('lng')
                    },
                    "formatted_address": place.get('formatted_address'),
                    "types": place.get('types', [])
                }
                
                # Filter by price level if specified
                if price_level is None or accommodation["price_level"] == price_level:
                    accommodations.append(accommodation)
            
            return accommodations
            
        except Exception as e:
            logger.error(f"Error searching accommodations: {str(e)}")
            return []
    
    async def calculate_distance_duration(self, origin: Tuple[float, float], 
                                        destination: Tuple[float, float],
                                        mode: str = "driving") -> Dict[str, Any]:
        """Calculate distance and duration between two points"""
        try:
            result = self.gmaps.distance_matrix(
                origins=[origin],
                destinations=[destination],
                mode=mode,
                units="metric"
            )
            
            if result['rows'][0]['elements'][0]['status'] == 'OK':
                element = result['rows'][0]['elements'][0]
                return {
                    "distance_text": element['distance']['text'],
                    "distance_value": element['distance']['value'],  # in meters
                    "duration_text": element['duration']['text'],
                    "duration_value": element['duration']['value'],  # in seconds
                    "status": "OK"
                }
            else:
                return {"status": "NOT_FOUND"}
                
        except Exception as e:
            logger.error(f"Error calculating distance: {str(e)}")
            return {"status": "ERROR", "message": str(e)}
    
    async def get_directions(self, origin: str, destination: str, 
                           mode: str = "driving") -> Dict[str, Any]:
        """Get detailed directions between two locations"""
        try:
            directions = self.gmaps.directions(
                origin=origin,
                destination=destination,
                mode=mode,
                alternatives=True
            )
            
            if not directions:
                return {"error": "No routes found"}
            
            formatted_directions = []
            for route in directions:
                route_info = {
                    "summary": route['summary'],
                    "legs": []
                }
                
                for leg in route['legs']:
                    leg_info = {
                        "distance": leg['distance']['text'],
                        "duration": leg['duration']['text'],
                        "start_address": leg['start_address'],
                        "end_address": leg['end_address'],
                        "steps": []
                    }
                    
                    for step in leg['steps']:
                        step_info = {
                            "instruction": step['html_instructions'],
                            "distance": step['distance']['text'],
                            "duration": step['duration']['text']
                        }
                        leg_info["steps"].append(step_info)
                    
                    route_info["legs"].append(leg_info)
                
                formatted_directions.append(route_info)
            
            return {
                "routes": formatted_directions,
                "best_route": formatted_directions[0] if formatted_directions else None
            }
            
        except Exception as e:
            logger.error(f"Error getting directions: {str(e)}")
            return {"error": str(e)}
    
    async def get_nearby_places(self, location: Tuple[float, float], 
                              place_type: str = "tourist_attraction",
                              radius: int = 5000) -> List[Dict[str, Any]]:
        """Get nearby places of a specific type"""
        try:
            places_result = self.gmaps.places_nearby(
                location=location,
                radius=radius,
                type=place_type
            )
            
            places = []
            for place in places_result['results']:
                place_info = {
                    "place_id": place.get('place_id'),
                    "name": place.get('name'),
                    "rating": place.get('rating'),
                    "user_ratings_total": place.get('user_ratings_total'),
                    "price_level": place.get('price_level'),
                    "location": {
                        "latitude": place.get('geometry', {}).get('location', {}).get('lat'),
                        "longitude": place.get('geometry', {}).get('location', {}).get('lng')
                    },
                    "formatted_address": place.get('formatted_address'),
                    "types": place.get('types', [])
                }
                places.append(place_info)
            
            return places
            
        except Exception as e:
            logger.error(f"Error getting nearby places: {str(e)}")
            return []
    
    async def get_weather_data(self, city: str, state: str) -> Dict[str, Any]:
        """Get weather data for a city (mock implementation)"""
        try:
            # Mock weather data that matches frontend expectations
            return {
                "city": f"{city}, {state}",
                "current": {
                    "temperature": 28,
                    "condition": "Sunny",
                    "humidity": 65,
                    "wind_speed": 10,
                    "feels_like": 30,
                    "uv_index": 7
                },
                "forecast": [
                    {
                        "date": "2024-01-15",
                        "high": 32,
                        "low": 24,
                        "condition": "Partly Cloudy",
                        "precipitation_chance": 20,
                        "wind_speed": 8,
                        "humidity": 60
                    },
                    {
                        "date": "2024-01-16",
                        "high": 30,
                        "low": 22,
                        "condition": "Sunny",
                        "precipitation_chance": 10,
                        "wind_speed": 12,
                        "humidity": 55
                    },
                    {
                        "date": "2024-01-17",
                        "high": 29,
                        "low": 21,
                        "condition": "Cloudy",
                        "precipitation_chance": 40,
                        "wind_speed": 6,
                        "humidity": 70
                    }
                ],
                "alerts": []
            }
            
        except Exception as e:
            logger.error(f"Error getting weather data: {str(e)}")
            return {"error": str(e)}
    
    async def get_local_events(self, city: str, state: str, 
                             start_date: str, end_date: str) -> List[Dict[str, Any]]:
        """Get local events for a city (mock implementation)"""
        try:
            # Mock events data that matches frontend expectations
            return [
                {
                    "id": "event_1",
                    "name": "Jaipur Literature Festival",
                    "date": start_date,
                    "time": "10:00",
                    "location": f"{city}, {state}",
                    "address": "Diggi Palace, Jaipur",
                    "description": "Annual literature festival featuring renowned authors and speakers",
                    "category": "cultural",
                    "ticket_price": 200,
                    "image_url": "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400&h=300&fit=crop",
                    "organizer": "Jaipur Literature Festival",
                    "capacity": 500,
                    "booking_url": "https://example.com/book"
                },
                {
                    "id": "event_2",
                    "name": "Rajasthani Folk Music Evening",
                    "date": start_date,
                    "time": "19:00",
                    "location": f"{city}, {state}",
                    "address": "Jawahar Kala Kendra, Jaipur",
                    "description": "Traditional Rajasthani folk music and dance performance",
                    "category": "entertainment",
                    "ticket_price": 150,
                    "image_url": "https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?w=400&h=300&fit=crop",
                    "organizer": "Rajasthan Tourism",
                    "capacity": 200,
                    "booking_url": "https://example.com/book"
                },
                {
                    "id": "event_3",
                    "name": "Heritage Walk Tour",
                    "date": start_date,
                    "time": "08:00",
                    "location": f"{city}, {state}",
                    "address": "City Palace, Jaipur",
                    "description": "Guided walking tour of Jaipur's heritage sites",
                    "category": "tourism",
                    "ticket_price": 300,
                    "image_url": "https://images.unsplash.com/photo-1587474260584-136574528ed5?w=400&h=300&fit=crop",
                    "organizer": "Heritage Tours India",
                    "capacity": 25,
                    "booking_url": "https://example.com/book"
                }
            ]
            
        except Exception as e:
            logger.error(f"Error getting local events: {str(e)}")
            return []
    
    async def get_photo_url(self, photo_reference: str, max_width: int = 400) -> str:
        """Get photo URL from photo reference"""
        if self.use_mock_data:
            return "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400&h=300&fit=crop"
        
        try:
            photo_url = f"https://maps.googleapis.com/maps/api/place/photo?maxwidth={max_width}&photoreference={photo_reference}&key={self.api_key}"
            return photo_url
        except Exception as e:
            logger.error(f"Error getting photo URL: {str(e)}")
            return ""
    
    # Mock data methods
    def _get_mock_place_details(self, place_name: str, city: str = None, state: str = None) -> Dict[str, Any]:
        """Get mock place details"""
        return {
            "place_id": f"mock_place_{place_name.lower().replace(' ', '_')}",
            "name": place_name,
            "formatted_address": f"{place_name}, {city or 'Jaipur'}, {state or 'Rajasthan'}, India",
            "location": {
                "latitude": 26.9124 + (hash(place_name) % 100) / 10000,  # Add some variation
                "longitude": 75.7873 + (hash(place_name) % 100) / 10000
            },
            "rating": 4.2 + (hash(place_name) % 30) / 10,
            "user_ratings_total": 100 + (hash(place_name) % 500),
            "price_level": (hash(place_name) % 3) + 1,
            "types": ["tourist_attraction", "point_of_interest"],
            "photos": [{"photo_reference": f"mock_photo_{hash(place_name)}"}],
            "opening_hours": {"open_now": True},
            "website": f"https://example.com/{place_name.lower().replace(' ', '-')}",
            "phone_number": "+91-141-1234567"
        }
    
    def _get_mock_attractions(self, city: str, state: str, attraction_types: List[str] = None) -> List[Dict[str, Any]]:
        """Get mock attractions"""
        mock_attractions = [
            {
                "place_id": "mock_attraction_1",
                "name": "Amber Fort",
                "rating": 4.7,
                "user_ratings_total": 1250,
                "price_level": 2,
                "location": {"latitude": 26.9855, "longitude": 75.8513},
                "formatted_address": "Amber, Jaipur, Rajasthan, India",
                "types": ["tourist_attraction", "historical_site"]
            },
            {
                "place_id": "mock_attraction_2",
                "name": "City Palace",
                "rating": 4.5,
                "user_ratings_total": 980,
                "price_level": 2,
                "location": {"latitude": 26.9254, "longitude": 75.8236},
                "formatted_address": "City Palace, Jaipur, Rajasthan, India",
                "types": ["tourist_attraction", "museum"]
            },
            {
                "place_id": "mock_attraction_3",
                "name": "Hawa Mahal",
                "rating": 4.3,
                "user_ratings_total": 750,
                "price_level": 1,
                "location": {"latitude": 26.9239, "longitude": 75.8267},
                "formatted_address": "Hawa Mahal, Jaipur, Rajasthan, India",
                "types": ["tourist_attraction", "historical_site"]
            }
        ]
        return mock_attractions
    
    def _get_mock_restaurants(self, city: str, state: str, cuisine_types: List[str] = None, price_level: int = None) -> List[Dict[str, Any]]:
        """Get mock restaurants"""
        mock_restaurants = [
            {
                "place_id": "mock_restaurant_1",
                "name": "Suvarna Mahal",
                "rating": 4.8,
                "user_ratings_total": 320,
                "price_level": 3,
                "location": {"latitude": 26.9124, "longitude": 75.7873},
                "formatted_address": "Rambagh Palace, Jaipur, Rajasthan, India",
                "types": ["restaurant", "food"]
            },
            {
                "place_id": "mock_restaurant_2",
                "name": "Laxmi Misthan Bhandar",
                "rating": 4.5,
                "user_ratings_total": 450,
                "price_level": 1,
                "location": {"latitude": 26.9200, "longitude": 75.8200},
                "formatted_address": "Johari Bazaar, Jaipur, Rajasthan, India",
                "types": ["restaurant", "bakery"]
            },
            {
                "place_id": "mock_restaurant_3",
                "name": "Spice Court",
                "rating": 4.4,
                "user_ratings_total": 280,
                "price_level": 2,
                "location": {"latitude": 26.9000, "longitude": 75.8000},
                "formatted_address": "C-Scheme, Jaipur, Rajasthan, India",
                "types": ["restaurant", "food"]
            }
        ]
        return mock_restaurants
    
    def _get_mock_accommodations(self, city: str, state: str, accommodation_type: str = "hotel", price_level: int = None) -> List[Dict[str, Any]]:
        """Get mock accommodations"""
        mock_accommodations = [
            {
                "place_id": "mock_hotel_1",
                "name": "The Raj Palace",
                "rating": 4.8,
                "user_ratings_total": 150,
                "price_level": 4,
                "location": {"latitude": 26.9124, "longitude": 75.7873},
                "formatted_address": "Civil Lines, Jaipur, Rajasthan, India",
                "types": ["lodging", "hotel"]
            },
            {
                "place_id": "mock_hotel_2",
                "name": "Hotel Clarks Amer",
                "rating": 4.5,
                "user_ratings_total": 200,
                "price_level": 3,
                "location": {"latitude": 26.9000, "longitude": 75.8000},
                "formatted_address": "C-Scheme, Jaipur, Rajasthan, India",
                "types": ["lodging", "hotel"]
            },
            {
                "place_id": "mock_hotel_3",
                "name": "Jaipur Heritage Homestay",
                "rating": 4.6,
                "user_ratings_total": 120,
                "price_level": 2,
                "location": {"latitude": 26.9200, "longitude": 75.8200},
                "formatted_address": "Old City, Jaipur, Rajasthan, India",
                "types": ["lodging", "homestay"]
            }
        ]
        return mock_accommodations
