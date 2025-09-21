import os
import json
import google.generativeai as genai
from typing import Dict, List, Any
from datetime import datetime, timedelta
from models.trip_models import TripRequest, Itinerary, DayPlan, Activity, Location
from services.mock_data_service import MockDataService
import logging

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

class GeminiService:
    def __init__(self):
        """Initialize Gemini AI service"""
        self.api_key = os.getenv("GEMINI_API_KEY")
        if not self.api_key:
            raise ValueError("GEMINI_API_KEY environment variable is required")
        
        genai.configure(api_key=self.api_key)
        self.model = genai.GenerativeModel('gemini-pro')
        self.mock_data_service = MockDataService()
        
    async def generate_itinerary(self, trip_request: TripRequest, weather_data: Dict = None, 
                               local_events: List[Dict] = None) -> Dict[str, Any]:
        """
        Generate a personalized itinerary using Gemini AI and mock data
        """
        try:
            # Get mock data based on preferences
            preferences = trip_request.preferences.dict()
            
            # Get activities, accommodations, flights, and restaurants
            activities = self.mock_data_service.get_activities(preferences)
            accommodations = self.mock_data_service.get_accommodations(preferences)
            flights = self.mock_data_service.get_flights(preferences)
            restaurants = self.mock_data_service.get_restaurants(preferences)
            
            # Use Gemini to create a structured itinerary
            context = self._build_context(trip_request, weather_data, local_events, activities, accommodations, flights, restaurants)
            prompt = self._create_itinerary_prompt(context)
            
            # Generate response from Gemini
            response = await self._generate_response(prompt)
            
            # Parse and structure the response
            itinerary_data = self._parse_itinerary_response(response, trip_request, activities, accommodations, flights, restaurants)
            
            return itinerary_data
            
        except Exception as e:
            logger.error(f"Error generating itinerary: {str(e)}")
            # Fallback to mock data only
            return self._generate_fallback_itinerary(trip_request)
    
    def _build_context(self, trip_request: TripRequest, weather_data: Dict = None, 
                      local_events: List[Dict] = None, activities: List[Dict] = None,
                      accommodations: List[Dict] = None, flights: List[Dict] = None,
                      restaurants: List[Dict] = None) -> Dict[str, Any]:
        """Build context for AI generation"""
        context = {
            "trip_details": {
                "origin": trip_request.origin.dict(),
                "destination": trip_request.destination.dict(),
                "duration_days": (trip_request.end_date - trip_request.start_date).days,
                "travelers_count": trip_request.travelers_count,
                "start_date": trip_request.start_date.isoformat(),
                "end_date": trip_request.end_date.isoformat()
            },
            "preferences": trip_request.preferences.dict(),
            "special_requirements": trip_request.special_requirements,
            "weather_data": weather_data or {},
            "local_events": local_events or [],
            "available_activities": activities or [],
            "available_accommodations": accommodations or [],
            "available_flights": flights or [],
            "available_restaurants": restaurants or []
        }
        return context
    
    def _generate_fallback_itinerary(self, trip_request: TripRequest) -> Dict[str, Any]:
        """Generate a fallback itinerary using only mock data"""
        preferences = trip_request.preferences.dict()
        duration_days = (trip_request.end_date - trip_request.start_date).days
        
        activities = self.mock_data_service.get_activities(preferences)
        accommodations = self.mock_data_service.get_accommodations(preferences)
        flights = self.mock_data_service.get_flights(preferences)
        restaurants = self.mock_data_service.get_restaurants(preferences)
        
        # Create a simple daily plan
        days = []
        for i in range(duration_days):
            day_activities = activities[i*2:(i+1)*2] if i*2 < len(activities) else activities[:2]
            day_restaurants = restaurants[i:i+2] if i < len(restaurants) else restaurants[:2]
            
            day_plan = {
                "date": (trip_request.start_date + timedelta(days=i)).isoformat(),
                "activities": day_activities,
                "meals": day_restaurants,
                "transportation": [],
                "total_daily_cost": sum(act.get('cost_per_person', 0) for act in day_activities) + 
                                 sum(rest.get('cost_per_person', 0) for rest in day_restaurants)
            }
            days.append(day_plan)
        
        total_cost = sum(day['total_daily_cost'] for day in days)
        if accommodations:
            total_cost += accommodations[0]['cost_per_night'] * duration_days
        if flights:
            total_cost += flights[0]['price']
        
        return {
            "summary": f"Personalized {duration_days}-day trip to {trip_request.destination.name}",
            "days": days,
            "accommodation": accommodations[:2],
            "transportation": flights[:2],
            "total_cost": total_cost,
            "budget_breakdown": {
                "accommodation": accommodations[0]['cost_per_night'] * duration_days if accommodations else 0,
                "transportation": flights[0]['price'] if flights else 0,
                "activities": sum(day['total_daily_cost'] for day in days),
                "meals": 0
            },
            "cultural_insights": [
                "Respect local customs and traditions",
                "Dress modestly when visiting religious sites",
                "Try local cuisine and street food"
            ],
            "safety_tips": [
                "Keep emergency contacts handy",
                "Stay hydrated and use sunscreen",
                "Be cautious with street food if you have a sensitive stomach"
            ],
            "local_recommendations": [
                "Visit during early morning or late evening for better weather",
                "Bargain at local markets",
                "Try authentic Rajasthani thali"
            ]
        }
    
    def _create_itinerary_prompt(self, context: Dict[str, Any]) -> str:
        """Create a simplified prompt for itinerary generation using available data"""
        trip_details = context["trip_details"]
        preferences = context["preferences"]
        available_activities = context.get("available_activities", [])
        available_accommodations = context.get("available_accommodations", [])
        available_flights = context.get("available_flights", [])
        available_restaurants = context.get("available_restaurants", [])
        
        prompt = f"""
        You are an expert AI travel planner. Create a personalized itinerary using the provided data.

        TRIP DETAILS:
        - Destination: {trip_details['destination']['name']}, {trip_details['destination']['state']}
        - Duration: {trip_details['duration_days']} days
        - Travelers: {trip_details['travelers_count']} people
        - Dates: {trip_details['start_date']} to {trip_details['end_date']}

        PREFERENCES:
        - Themes: {', '.join(preferences['themes'])}
        - Budget Level: {preferences['budget_level']}
        - Max Budget: ₹{preferences['max_budget']}

        AVAILABLE DATA:
        Activities: {json.dumps(available_activities[:5], indent=2)}
        Accommodations: {json.dumps(available_accommodations[:3], indent=2)}
        Flights: {json.dumps(available_flights[:3], indent=2)}
        Restaurants: {json.dumps(available_restaurants[:5], indent=2)}

        Create a {trip_details['duration_days']}-day itinerary by selecting and organizing the available activities, restaurants, and accommodations. 
        Distribute activities across days, suggest appropriate restaurants for meals, and include the best accommodation and flight options.

        Return ONLY a JSON response in this format:
        {{
            "summary": "Brief trip overview",
            "days": [
                {{
                    "date": "YYYY-MM-DD",
                    "activities": [selected activities with time slots],
                    "meals": [selected restaurants],
                    "transportation": [],
                    "total_daily_cost": calculated_cost
                }}
            ],
            "accommodation": [selected accommodations],
            "transportation": [selected flights],
            "total_cost": total_cost,
            "budget_breakdown": {{
                "accommodation": cost,
                "transportation": cost,
                "activities": cost,
                "meals": cost
            }},
            "cultural_insights": ["tip1", "tip2", "tip3"],
            "safety_tips": ["tip1", "tip2", "tip3"],
            "local_recommendations": ["tip1", "tip2", "tip3"]
        }}
        """
        
        return prompt
    
    async def _generate_response(self, prompt: str) -> str:
        """Generate response from Gemini"""
        try:
            response = self.model.generate_content(prompt)
            return response.text
        except Exception as e:
            logger.error(f"Error generating Gemini response: {str(e)}")
            raise Exception(f"Gemini API error: {str(e)}")
    
    def _parse_itinerary_response(self, response: str, trip_request: TripRequest, 
                                 activities: List[Dict] = None, accommodations: List[Dict] = None,
                                 flights: List[Dict] = None, restaurants: List[Dict] = None) -> Dict[str, Any]:
        """Parse and validate the Gemini response"""
        try:
            # Extract JSON from response (in case there's additional text)
            start_idx = response.find('{')
            end_idx = response.rfind('}') + 1
            
            if start_idx == -1 or end_idx == 0:
                raise ValueError("No valid JSON found in response")
            
            json_str = response[start_idx:end_idx]
            itinerary_data = json.loads(json_str)
            
            # Validate and enhance the data
            itinerary_data = self._validate_and_enhance_itinerary(itinerary_data, trip_request)
            
            return itinerary_data
            
        except json.JSONDecodeError as e:
            logger.error(f"JSON parsing error: {str(e)}")
            # Return fallback itinerary if parsing fails
            return self._generate_fallback_itinerary(trip_request)
        except Exception as e:
            logger.error(f"Error parsing itinerary: {str(e)}")
            # Return fallback itinerary if parsing fails
            return self._generate_fallback_itinerary(trip_request)
    
    def _validate_and_enhance_itinerary(self, data: Dict[str, Any], trip_request: TripRequest) -> Dict[str, Any]:
        """Validate and enhance the itinerary data"""
        # Add metadata
        data["trip_request"] = trip_request.dict()
        data["generated_by"] = "gemini_ai"
        data["created_at"] = datetime.now().isoformat()
        
        # Ensure all required fields are present
        required_fields = ["summary", "days", "accommodation", "transportation", "total_cost"]
        for field in required_fields:
            if field not in data:
                data[field] = [] if field in ["days", "accommodation", "transportation"] else ""
        
        return data
    
    async def generate_alternative_suggestions(self, itinerary_id: str, 
                                             original_itinerary: Dict[str, Any],
                                             user_feedback: str) -> Dict[str, Any]:
        """Generate alternative suggestions based on user feedback"""
        try:
            prompt = f"""
            The user has provided feedback on their itinerary: "{user_feedback}"
            
            Original itinerary: {json.dumps(original_itinerary, indent=2)}
            
            Please suggest 3 alternative modifications to the itinerary that address the user's feedback while maintaining the overall trip structure and budget.
            
            Return suggestions in JSON format:
            {{
                "suggestions": [
                    {{
                        "title": "Suggestion title",
                        "description": "Detailed description",
                        "changes": {{
                            "modified_days": [1, 3],
                            "new_activities": [...],
                            "removed_activities": [...],
                            "cost_impact": 500
                        }},
                        "reasoning": "Why this suggestion addresses the feedback"
                    }}
                ]
            }}
            """
            
            response = await self._generate_response(prompt)
            return json.loads(response)
            
        except Exception as e:
            logger.error(f"Error generating alternatives: {str(e)}")
            raise Exception(f"Failed to generate alternatives: {str(e)}")
    
    async def generate_real_time_updates(self, itinerary_id: str, 
                                       current_itinerary: Dict[str, Any],
                                       weather_alerts: List[Dict] = None,
                                       traffic_updates: List[Dict] = None) -> Dict[str, Any]:
        """Generate real-time updates for the itinerary"""
        try:
            context = {
                "current_itinerary": current_itinerary,
                "weather_alerts": weather_alerts or [],
                "traffic_updates": traffic_updates or []
            }
            
            prompt = f"""
            Based on real-time conditions, suggest updates to this itinerary:
            
            Current itinerary: {json.dumps(current_itinerary, indent=2)}
            Weather alerts: {json.dumps(weather_alerts or [], indent=2)}
            Traffic updates: {json.dumps(traffic_updates or [], indent=2)}
            
            Provide smart adjustments including:
            - Alternative indoor activities for bad weather
            - Route optimizations for traffic
            - Time adjustments for delays
            - Backup plans for cancellations
            
            Return in JSON format:
            {{
                "updates": [
                    {{
                        "type": "weather/traffic/cancellation",
                        "affected_date": "YYYY-MM-DD",
                        "original_activity": "Activity name",
                        "suggested_alternative": "Alternative activity",
                        "reason": "Reason for change",
                        "cost_impact": 0,
                        "booking_required": false
                    }}
                ],
                "general_recommendations": [
                    "General advice for the updated conditions"
                ]
            }}
            """
            
            response = await self._generate_response(prompt)
            return json.loads(response)
            
        except Exception as e:
            logger.error(f"Error generating real-time updates: {str(e)}")
            raise Exception(f"Failed to generate real-time updates: {str(e)}")
