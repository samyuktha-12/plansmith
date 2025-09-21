import os
import requests
from dotenv import load_dotenv

load_dotenv()

host = os.getenv("RAPIDAPI_HOST")

def get_tourist_attractions(attraction_id, start_date, end_date):
  url = f"https://{host}/api/v1/attraction/searchAttractions"

  querystring = {
    "id":attraction_id,
    "startDate":start_date,
    "endDate": end_date,
    "sortBy": "trending",
    "page": "1",
    "currency_code": "INR",
    "languagecode": "en-us"
  }

  headers = {
    "x-rapidapi-key": os.getenv("RAPIDAPI_KEY"),
    "x-rapidapi-host": os.getenv("RAPIDAPI_HOST")
  }

  response = requests.get(url, headers=headers, params=querystring)

  return response.json()