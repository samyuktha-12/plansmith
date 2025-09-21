
import requests
import os
from dotenv import load_dotenv

load_dotenv()

host = os.getenv("RAPIDAPI_HOST")

def get_destination(location):
  url = f"https://{host}/api/v1/hotels/searchDestination"
  headers = {
      'x-rapidapi-key': os.getenv("RAPIDAPI_KEY"),
      'x-rapidapi-host': host
  }
  params = {
    "query": location
  }

  response = requests.get(url, headers=headers, params=params)
  return response.json()


def get_hotels_for_city(destination_id, arrival_date, departure_date, adults, room_qty):
  
  url = "https://booking-com15.p.rapidapi.com/api/v1/hotels/searchHotels"

  headers = {
      'x-rapidapi-key': os.getenv("RAPIDAPI_KEY"),
      'x-rapidapi-host': host
  }

  params = {
    'dest_id': destination_id,
    'search_type': 'city',
    'arrival_date': arrival_date,
    'departure_date': departure_date,
    'adults': adults,
    'room_qty': room_qty,
    'page_number': '1',
    'units': 'metric',
    'temperature_unit': 'c',
    'languagecode': 'en-us',
    'currency_code': 'INR'
  }

  response = requests.get(url, headers=headers, params=params)
  return response.json()