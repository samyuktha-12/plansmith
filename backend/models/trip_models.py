from pydantic import BaseModel, Field
from typing import List, Optional, Dict, Any
from datetime import datetime, date
from enum import Enum

class TravelTheme(str, Enum):
    HERITAGE = "heritage"
    NIGHTLIFE = "nightlife"
    ADVENTURE = "adventure"
    RELAXATION = "relaxation"
    CULTURAL = "cultural"
    FOOD = "food"
    SHOPPING = "shopping"
    NATURE = "nature"
    FAMILY = "family"
    ROMANTIC = "romantic"

class BudgetLevel(str, Enum):
    BUDGET = "budget"
    MID_RANGE = "mid_range"
    LUXURY = "luxury"

class TransportationMode(str, Enum):
    FLIGHT = "flight"
    TRAIN = "train"
    BUS = "bus"
    CAR_RENTAL = "car_rental"
    TAXI = "taxi"
    LOCAL_TRANSPORT = "local_transport"

class AccommodationType(str, Enum):
    HOTEL = "hotel"
    HOSTEL = "hostel"
    RESORT = "resort"
    HOMESTAY = "homestay"
    VACATION_RENTAL = "vacation_rental"

class Location(BaseModel):
    name: str
    city: str
    state: str
    country: str
    latitude: Optional[float] = None
    longitude: Optional[float] = None
    place_id: Optional[str] = None

class UserPreferences(BaseModel):
    themes: List[TravelTheme]
    budget_level: BudgetLevel
    max_budget: float = Field(..., gt=0, description="Maximum budget in INR")
    dietary_restrictions: List[str] = []
    accessibility_needs: List[str] = []
    languages_spoken: List[str] = ["English"]
    travel_style: str = "balanced"  # adventure, relaxed, cultural, etc.
    interests: List[str] = []  # Additional interests field for frontend compatibility
    travelers_count: int = Field(default=1, ge=1, le=10)  # Move from TripRequest for easier access

class TripRequest(BaseModel):
    origin: Location
    destination: Location
    start_date: date
    end_date: date
    travelers_count: int = Field(..., ge=1, le=10)
    preferences: UserPreferences
    special_requirements: Optional[str] = None

class Activity(BaseModel):
    id: str
    name: str
    description: str
    location: Location
    duration_hours: float
    cost_per_person: float
    category: str
    rating: Optional[float] = None
    booking_url: Optional[str] = None
    image_url: Optional[str] = None
    opening_hours: Optional[Dict[str, str]] = None

class Accommodation(BaseModel):
    id: str
    name: str
    type: AccommodationType
    location: Location
    cost_per_night: float
    rating: Optional[float] = None
    amenities: List[str] = []
    booking_url: Optional[str] = None
    image_url: Optional[str] = None

class Transportation(BaseModel):
    id: str
    mode: TransportationMode
    from_location: Location
    to_location: Location
    departure_time: datetime
    arrival_time: datetime
    cost_per_person: float
    provider: str
    booking_url: Optional[str] = None
    duration_minutes: int

class DayPlan(BaseModel):
    date: date
    activities: List[Activity]
    meals: List[Activity] = []
    transportation: List[Transportation] = []
    total_cost: float
    weather_forecast: Optional[Dict[str, Any]] = None

class Itinerary(BaseModel):
    id: str
    trip_request: TripRequest
    days: List[DayPlan]
    total_cost: float
    accommodation: List[Accommodation]
    transportation: List[Transportation]
    summary: str
    created_at: datetime
    updated_at: datetime
    is_booked: bool = False
    booking_id: Optional[str] = None

class BookingRequest(BaseModel):
    itinerary_id: str
    payment_method: str
    contact_info: Dict[str, str]

class BookingResponse(BaseModel):
    booking_id: str
    status: str
    payment_status: str
    confirmation_details: Dict[str, Any]
    total_amount: float

class WeatherAlert(BaseModel):
    type: str
    severity: str
    message: str
    affected_dates: List[date]
    recommendations: List[str]

class ItineraryUpdate(BaseModel):
    itinerary_id: str
    update_reason: str  # weather, delay, preference_change
    changes: Dict[str, Any]
    new_recommendations: List[str] = []

# Additional models for frontend compatibility
class ActivityItem(BaseModel):
    name: str
    description: str
    category: str
    duration_hours: float
    cost_per_person: int
    rating: float
    location: str
    image_url: str
    themes: List[str]
    interests: List[str]

class AccommodationItem(BaseModel):
    name: str
    type: str
    cost_per_night: int
    rating: float
    amenities: List[str]
    location: str
    image_url: str
    description: str
    budget_level: str

class FlightItem(BaseModel):
    airline: str
    from_location: str
    to_location: str
    departure_time: str
    arrival_time: str
    duration: str
    price: int
    type: str
    aircraft: str
    budget_level: str

class RestaurantItem(BaseModel):
    name: str
    cuisine: str
    price_range: str
    rating: float
    location: str
    specialties: List[str]
    image_url: str
    description: str
    budget_level: str
    themes: List[str]
    interests: List[str]

class DayPlanItem(BaseModel):
    date: str
    activities: List[ActivityItem]
    meals: List[RestaurantItem]
    transportation: List[Dict[str, Any]]
    total_daily_cost: int

class ItineraryResponse(BaseModel):
    summary: str
    days: List[DayPlanItem]
    accommodation: List[AccommodationItem]
    transportation: List[FlightItem]
    total_cost: int
    budget_breakdown: Dict[str, int]
    cultural_insights: List[str]
    safety_tips: List[str]
    local_recommendations: List[str]
