import requests
import os
from dotenv import load_dotenv

load_dotenv()

host = os.getenv("RAPIDAPI_HOST")

def get_taxi_locations(location: str):
  url = f"https://{host}/api/v1/taxi/searchLocation"

  querystring = {"query":location}

  headers = {
    "x-rapidapi-key": os.getenv("RAPIDAPI_KEY"),
    "x-rapidapi-host": host
  }

  response = requests.get(url, headers=headers, params=querystring)
  return response.json()