import requests
import os
from dotenv import load_dotenv

load_dotenv()

host = os.getenv("RAPIDAPI_HOST")

def get_flights(from_id="BOM.AIRPORT", to_id="DEL.AIRPORT", depart_date="2025-09-21", adults="1", children="0,17"):
    url = f"https://{host}/api/v1/flights/searchFlights"
    headers = {
        'x-rapidapi-key': os.getenv("RAPIDAPI_KEY"),
        'x-rapidapi-host': host
    }
    params = {
        "fromId": from_id,
        "toId": to_id,
        "departDate": depart_date,
        "stops": "none",
        "pageNo": "1",
        "adults": adults,
        "children": children,
        "sort": "BEST",
        "cabinClass": "ECONOMY",
        "currency_code": "INR"
    }
    response = requests.get(url, headers=headers, params=params)
    return response.json()
  
def get_flight_info(flight_id: str):
    url = "https://booking-com15.p.rapidapi.com/api/v1/flights/getFlightDetails"
    headers = {
        'x-rapidapi-key': os.getenv("RAPIDAPI_KEY"),
        'x-rapidapi-host': os.getenv("RAPIDAPI_HOST")
    }
    params = {
        "token": flight_id,
        "currency_code": "INR"
    }
    response = requests.get(url, headers=headers, params=params)
    return response.json()
