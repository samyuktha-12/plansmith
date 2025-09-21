
from fastapi import FastAPI
from services.flights_service import get_flights, get_flight_info
from services.hotels_service import get_destination
from services.attraction_service import get_tourist_attractions
from services.hotels_service import get_hotels_for_city
from dotenv import load_dotenv

app = FastAPI()
load_dotenv()

@app.get("/")
def read_root():
    return {"message": "Welcome to PlanSmith API"}

@app.get("/health")
def health_check():
    return {"status": "healthy"}

@app.get("/flights")
def get_flights_endpoint(
    from_id: str = "BOM.AIRPORT",
    to_id: str = "BLR.AIRPORT",
    depart_date: str = "2025-09-21",  # Use today's date as default
    adults: str = "1",
    children: str = "0,17"
):
    return get_flights(from_id, to_id, depart_date, adults, children)

@app.get("/flights/{flight_id}")
def get_flight_info_endpoint(flight_id: str):
    return get_flight_info(flight_id)
  
@app.get("/destination")
def get_destination_endpoint(location: str = "bangalore"):
    return get_destination(location)

@app.get("/destination/{destination_id}/hotels")
def get_hotels_endpoint(destination_id: str = "-2090174",
    arrival_date: str = "2025-09-22",
    departure_date: str = "2025-09-24",
    adults: str = "2",
    room_qty: str = "1"):
    return get_hotels_for_city(destination_id, arrival_date, departure_date, adults, room_qty)

@app.get("/destination/{destination_id}/attractions")
def get_attractions_endpoint(destination_id: str = "-2090174",
    start_date: str = "2025-09-22",
    end_date: str = "2025-09-24"):
    return get_tourist_attractions(destination_id, start_date, end_date)

@app.get("/destination/{destination_id}/taxi")
def get_taxi_endpoint(destination_id: str = "-2090174"):
    return get_taxi_locations(destination_id)
=======
from fastapi import FastAPI, HTTPException, Depends
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from typing import Optional, List
from contextlib import asynccontextmanager
from datetime import datetime
import os
from dotenv import load_dotenv
import logging

# Import our services
from services.gemini_service import GeminiService
from services.google_maps_service import GoogleMapsService
from services.firebase_service import FirebaseService
from services.mock_data_service import MockDataService
from models.trip_models import (
    TripRequest, Itinerary, BookingRequest, BookingResponse,
    ItineraryUpdate, WeatherAlert
)

# Load environment variables
load_dotenv()

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# Initialize services
gemini_service = None
maps_service = None
firebase_service = None
mock_data_service = None

@asynccontextmanager
async def lifespan(app: FastAPI):
    # Startup
    global gemini_service, maps_service, firebase_service, mock_data_service
    try:
        # Initialize services with error handling for each
        try:
            gemini_service = GeminiService()
            logger.info("Gemini service initialized successfully")
        except Exception as e:
            logger.warning(f"Failed to initialize Gemini service: {e}")
            gemini_service = None
        
        try:
            maps_service = GoogleMapsService()
            logger.info("Google Maps service initialized successfully")
        except Exception as e:
            logger.warning(f"Failed to initialize Google Maps service: {e}")
            maps_service = None
        
        try:
            firebase_service = FirebaseService()
            logger.info("Firebase service initialized successfully")
        except Exception as e:
            logger.warning(f"Failed to initialize Firebase service: {e}")
            firebase_service = None
        
        try:
            mock_data_service = MockDataService()
            logger.info("Mock data service initialized successfully")
        except Exception as e:
            logger.warning(f"Failed to initialize Mock data service: {e}")
            mock_data_service = None
        
        logger.info("Service initialization completed")
        
    except Exception as e:
        logger.error(f"Critical error during service initialization: {e}")
        # Don't raise here, let the app start with available services
    
    yield
    
    # Shutdown
    logger.info("Shutting down services")

# Initialize FastAPI app with lifespan
app = FastAPI(
    title="PlanSmith AI Trip Planner API",
    description="AI-powered personalized trip planner with real-time itinerary generation and booking capabilities",
    version="2.0.0",
    lifespan=lifespan
)

# Add CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # In production, specify your Flutter app's origins
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Dependency to get services
def get_services():
    return {
        "gemini": gemini_service,
        "maps": maps_service,
        "firebase": firebase_service,
        "mock_data": mock_data_service
    }

# ================================
# TRIP PLANNING ENDPOINTS
# ================================

@app.post("/api/trips/generate")
async def generate_itinerary(trip_request: TripRequest, services: dict = Depends(get_services)):
    """Generate a personalized AI-powered itinerary"""
    try:
        logger.info(f"Generating itinerary for {trip_request.destination.name}")
        
        # Get weather data and local events
        weather_data = await services["maps"].get_weather_data(
            trip_request.destination.city, 
            trip_request.destination.state
        )
        
        local_events = await services["maps"].get_local_events(
            trip_request.destination.city,
            trip_request.destination.state,
            trip_request.start_date.isoformat(),
            trip_request.end_date.isoformat()
        )
        
        # Generate itinerary using Gemini AI
        itinerary_data = await services["gemini"].generate_itinerary(
            trip_request, weather_data, local_events
        )
        
        # Save to Firebase
        itinerary_id = await services["firebase"].save_itinerary(
            itinerary_data, user_id="anonymous"  # In production, get from auth
        )
        
        return {
            "success": True,
            "itinerary_id": itinerary_id,
            "itinerary": itinerary_data,
            "message": "Itinerary generated successfully"
        }
        
    except Exception as e:
        logger.error(f"Error generating itinerary: {str(e)}")
        raise HTTPException(status_code=500, detail=str(e))

@app.get("/api/trips/{itinerary_id}")
async def get_itinerary(itinerary_id: str, services: dict = Depends(get_services)):
    """Get a specific itinerary by ID"""
    try:
        itinerary = await services["firebase"].get_itinerary(itinerary_id)
        
        if not itinerary:
            raise HTTPException(status_code=404, detail="Itinerary not found")
        
        return {
            "success": True,
            "itinerary": itinerary
        }
        
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error getting itinerary: {str(e)}")
        raise HTTPException(status_code=500, detail=str(e))

@app.get("/api/trips/user/{user_id}")
async def get_user_itineraries(user_id: str, services: dict = Depends(get_services)):
    """Get all itineraries for a user"""
    try:
        itineraries = await services["firebase"].get_user_itineraries(user_id)
        
        return {
            "success": True,
            "itineraries": itineraries,
            "count": len(itineraries)
        }
        
    except Exception as e:
        logger.error(f"Error getting user itineraries: {str(e)}")
        raise HTTPException(status_code=500, detail=str(e))

@app.post("/api/trips/{itinerary_id}/alternatives")
async def get_alternative_suggestions(
    itinerary_id: str, 
    feedback: dict,
    services: dict = Depends(get_services)
):
    """Get alternative suggestions based on user feedback"""
    try:
        itinerary = await services["firebase"].get_itinerary(itinerary_id)
        
        if not itinerary:
            raise HTTPException(status_code=404, detail="Itinerary not found")
        
        alternatives = await services["gemini"].generate_alternative_suggestions(
            itinerary_id, itinerary, feedback.get("feedback", "")
        )
        
        return {
            "success": True,
            "alternatives": alternatives
        }
        
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error generating alternatives: {str(e)}")
        raise HTTPException(status_code=500, detail=str(e))

@app.post("/api/trips/{itinerary_id}/updates")
async def get_real_time_updates(
    itinerary_id: str,
    update_request: ItineraryUpdate,
    services: dict = Depends(get_services)
):
    """Get real-time updates for an itinerary"""
    try:
        itinerary = await services["firebase"].get_itinerary(itinerary_id)
        
        if not itinerary:
            raise HTTPException(status_code=404, detail="Itinerary not found")
        
        updates = await services["gemini"].generate_real_time_updates(
            itinerary_id, itinerary, update_request.dict()
        )
        
        return {
            "success": True,
            "updates": updates
        }
        
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error generating updates: {str(e)}")
        raise HTTPException(status_code=500, detail=str(e))

# ================================
# BOOKING ENDPOINTS
# ================================

@app.post("/api/bookings")
async def create_booking(booking_request: BookingRequest, services: dict = Depends(get_services)):
    """Create a mock booking for an itinerary"""
    try:
        # Get itinerary details
        itinerary = await services["firebase"].get_itinerary(booking_request.itinerary_id)
        
        if not itinerary:
            raise HTTPException(status_code=404, detail="Itinerary not found")
        
        # Create mock booking record
        booking_id = f"booking_{hash(booking_request.itinerary_id) % 10000}"
        booking_data = {
            "id": booking_id,
            "itinerary_id": booking_request.itinerary_id,
            "payment_method": booking_request.payment_method,
            "contact_info": booking_request.contact_info,
            "total_amount": itinerary.get("total_cost", 0),
            "status": "confirmed",  # Mock confirmed status
            "created_at": datetime.now().isoformat()
        }
        
        # Save to Firebase
        await services["firebase"].save_booking(booking_data)
        
        # Update itinerary as booked
        await services["firebase"].update_itinerary(
            booking_request.itinerary_id, 
            {"is_booked": True, "booking_id": booking_id}
        )
        
        return {
            "success": True,
            "booking_id": booking_id,
            "status": "confirmed",
            "total_amount": booking_data["total_amount"]
        }
        
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error creating booking: {str(e)}")
        raise HTTPException(status_code=500, detail=str(e))

@app.get("/api/bookings/{booking_id}")
async def get_booking(booking_id: str, services: dict = Depends(get_services)):
    """Get booking details"""
    try:
        # Return mock booking data
        return {
            "success": True,
            "booking": {
                "id": booking_id,
                "status": "confirmed",
                "total_amount": 15000,
                "created_at": "2024-01-15T10:00:00Z"
            }
        }
        
    except Exception as e:
        logger.error(f"Error getting booking: {str(e)}")
        raise HTTPException(status_code=500, detail=str(e))

# ================================
# LOCATION & SEARCH ENDPOINTS
# ================================

@app.get("/api/locations/search")
async def search_locations(query: str, services: dict = Depends(get_services)):
    """Search for locations"""
    try:
        # Use Google Maps to search for places
        places = await services["maps"].get_place_details(query)
        
        return {
            "success": True,
            "locations": [places] if places else []
        }
        
    except Exception as e:
        logger.error(f"Error searching locations: {str(e)}")
        raise HTTPException(status_code=500, detail=str(e))

@app.get("/api/locations/{city}/attractions")
async def get_attractions(city: str, state: str, services: dict = Depends(get_services)):
    """Get attractions for a city"""
    try:
        attractions = await services["maps"].search_attractions(city, state)
        
        return {
            "success": True,
            "attractions": attractions
        }
        
    except Exception as e:
        logger.error(f"Error getting attractions: {str(e)}")
        raise HTTPException(status_code=500, detail=str(e))

@app.get("/api/locations/{city}/restaurants")
async def get_restaurants(
    city: str, 
    state: str, 
    cuisine_types: Optional[str] = None,
    services: dict = Depends(get_services)
):
    """Get restaurants for a city"""
    try:
        cuisines = cuisine_types.split(",") if cuisine_types else None
        restaurants = await services["maps"].search_restaurants(city, state, cuisines)
        
        return {
            "success": True,
            "restaurants": restaurants
        }
        
    except Exception as e:
        logger.error(f"Error getting restaurants: {str(e)}")
        raise HTTPException(status_code=500, detail=str(e))

# ================================
# MOCK DATA ENDPOINTS (Frontend Compatible)
# ================================

@app.post("/api/activities")
async def get_activities(preferences: dict, services: dict = Depends(get_services)):
    """Get activities based on preferences (frontend compatible)"""
    try:
        activities = services["mock_data"].get_activities(preferences)
        
        return {
            "success": True,
            "activities": activities
        }
        
    except Exception as e:
        logger.error(f"Error getting activities: {str(e)}")
        raise HTTPException(status_code=500, detail=str(e))

@app.post("/api/accommodations")
async def get_accommodations(preferences: dict, services: dict = Depends(get_services)):
    """Get accommodations based on preferences (frontend compatible)"""
    try:
        accommodations = services["mock_data"].get_accommodations(preferences)
        
        return {
            "success": True,
            "accommodations": accommodations
        }
        
    except Exception as e:
        logger.error(f"Error getting accommodations: {str(e)}")
        raise HTTPException(status_code=500, detail=str(e))

@app.post("/api/flights")
async def get_flights(preferences: dict, services: dict = Depends(get_services)):
    """Get flights based on preferences (frontend compatible)"""
    try:
        flights = services["mock_data"].get_flights(preferences)
        
        return {
            "success": True,
            "flights": flights
        }
        
    except Exception as e:
        logger.error(f"Error getting flights: {str(e)}")
        raise HTTPException(status_code=500, detail=str(e))

@app.post("/api/restaurants")
async def get_restaurants(preferences: dict, services: dict = Depends(get_services)):
    """Get restaurants based on preferences (frontend compatible)"""
    try:
        restaurants = services["mock_data"].get_restaurants(preferences)
        
        return {
            "success": True,
            "restaurants": restaurants
        }
        
    except Exception as e:
        logger.error(f"Error getting restaurants: {str(e)}")
        raise HTTPException(status_code=500, detail=str(e))

# ================================
# ANALYTICS & INSIGHTS ENDPOINTS
# ================================

@app.get("/api/analytics/popular-destinations")
async def get_popular_destinations(services: dict = Depends(get_services)):
    """Get popular destinations based on booking data"""
    try:
        destinations = await services["firebase"].get_popular_destinations()
        
        return {
            "success": True,
            "destinations": destinations
        }
        
    except Exception as e:
        logger.error(f"Error getting popular destinations: {str(e)}")
        raise HTTPException(status_code=500, detail=str(e))

@app.get("/api/health")
async def health_check():
    """Health check endpoint"""
    return {
        "status": "healthy",
        "service": "PlanSmith AI Trip Planner API",
        "version": "2.0.0"
    }

if __name__ == "__main__":
    import uvicorn
    
    # Run the server
    # Use 0.0.0.0 to bind to all interfaces (needed for emulator access)
    uvicorn.run(
        "main:app",
        host="0.0.0.0",  # Bind to all interfaces
        port=8000,
        reload=True,  # Enable auto-reload in development
        log_level="info"
    )
