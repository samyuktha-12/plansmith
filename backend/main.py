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
