from fastapi import FastAPI, HTTPException
import requests
import os

app = FastAPI()

# Amadeus API credentials
AMADEUS_CLIENT_ID = os.getenv("AMADEUS_CLIENT_ID")
AMADEUS_CLIENT_SECRET = os.getenv("AMADEUS_CLIENT_SECRET")
AMADEUS_API_URL = "https://test.api.amadeus.com"  # Sandbox environment

# Helper function to get access token
def get_amadeus_token():
    url = f"{AMADEUS_API_URL}/v1/security/oauth2/token"
    payload = {
        "grant_type": "client_credentials",
        "client_id": AMADEUS_CLIENT_ID,
        "client_secret": AMADEUS_CLIENT_SECRET
    }
    headers = {"Content-Type": "application/x-www-form-urlencoded"}
    response = requests.post(url, data=payload, headers=headers)
    if response.status_code == 200:
        return response.json()["access_token"]
    else:
        raise HTTPException(status_code=response.status_code, detail="Failed to obtain access token")

# ------------------------------
# Flight APIs
# ------------------------------

@app.get("/flights/offer")
def get_flight_offer():
    token = get_amadeus_token()
    url = f"{AMADEUS_API_URL}/v2/shopping/flight-offers"
    headers = {"Authorization": f"Bearer {token}"}
    response = requests.get(url, headers=headers)
    if response.status_code == 200:
        return response.json()
    else:
        raise HTTPException(status_code=response.status_code, detail="Failed to fetch flight offers")

# ------------------------------
# Hotel APIs
# ------------------------------

@app.get("/hotels/search")
def search_hotels():
    token = get_amadeus_token()
    url = f"{AMADEUS_API_URL}/v2/shopping/hotel-offers"
    headers = {"Authorization": f"Bearer {token}"}
    response = requests.get(url, headers=headers)
    if response.status_code == 200:
        return response.json()
    else:
        raise HTTPException(status_code=response.status_code, detail="Failed to search hotels")

# ------------------------------
# Destination APIs
# ------------------------------

@app.get("/destinations/city")
def get_city_info():
    token = get_amadeus_token()
    url = f"{AMADEUS_API_URL}/v1/reference-data/locations/cities"
    headers = {"Authorization": f"Bearer {token}"}
    response = requests.get(url, headers=headers)
    if response.status_code == 200:
        return response.json()
    else:
        raise HTTPException(status_code=response.status_code, detail="Failed to fetch city information")

# ------------------------------
# Car APIs
# ------------------------------

@app.get("/cars/search")
def search_cars():
    token = get_amadeus_token()
    url = f"{AMADEUS_API_URL}/v2/shopping/car-offers"
    headers = {"Authorization": f"Bearer {token}"}
    response = requests.get(url, headers=headers)
    if response.status_code == 200:
        return response.json()
    else:
        raise HTTPException(status_code=response.status_code, detail="Failed to search car offers")

# ------------------------------
# Airport APIs
# ------------------------------

@app.get("/airports/nearby")
def get_nearby_airports():
    token = get_amadeus_token()
    url = f"{AMADEUS_API_URL}/v1/reference-data/locations/airports/nearby"
    headers = {"Authorization": f"Bearer {token}"}
    response = requests.get(url, headers=headers)
    if response.status_code == 200:
        return response.json()
    else:
        raise HTTPException(status_code=response.status_code, detail="Failed to fetch nearby airports")

# ------------------------------
# Travel Insights APIs
# ------------------------------

@app.get("/insights/most-traveled-destinations")
def get_most_traveled_destinations():
    token = get_amadeus_token()
    url = f"{AMADEUS_API_URL}/v1/analytics/most-traveled-destinations"
    headers = {"Authorization": f"Bearer {token}"}
    response = requests.get(url, headers=headers)
    if response.status_code == 200:
        return response.json()
    else:
        raise HTTPException(status_code=response.status_code, detail="Failed to fetch travel insights")

# ------------------------------
# Tours & Activities APIs
# ------------------------------

@app.get("/tours/activities")
def get_tours_activities():
    token = get_amadeus_token()
    url = f"{AMADEUS_API_URL}/v1/activities/tours"
    headers = {"Authorization": f"Bearer {token}"}
    response = requests.get(url, headers=headers)
    if response.status_code == 200:
        return response.json()
    else:
        raise HTTPException(status_code=response.status_code, detail="Failed to fetch tours and activities")

# ------------------------------
# Airport & City Search APIs
# ------------------------------

@app.get("/airports/city")
def get_airports_by_city():
    token = get_amadeus_token()
    url = f"{AMADEUS_API_URL}/v1/reference-data/locations/airports/by-city"
    headers = {"Authorization": f"Bearer {token}"}
    response = requests.get(url, headers=headers)
    if response.status_code == 200:
        return response.json()
    else:
        raise HTTPException(status_code=response.status_code, detail="Failed to fetch airports by city")

@app.get("/airports/route")
def get_airport_routes():
    token = get_amadeus_token()
    url = f"{AMADEUS_API_URL}/v1/reference-data/locations/airports/routes"
    headers = {"Authorization": f"Bearer {token}"}
    response = requests.get(url, headers=headers)
    if response.status_code == 200:
        return response.json()
    else:
        raise HTTPException(status_code=response.status_code, detail="Failed to fetch airport routes")

# ------------------------------
# Airline APIs
# ------------------------------

@app.get("/airlines")
def get_airlines():
    token = get_amadeus_token()
    url = f"{AMADEUS_API_URL}/v1/reference-data/locations/airlines"
    headers = {"Authorization": f"Bearer {token}"}
    response = requests.get(url, headers=headers)
    if response.status_code == 200:
        return response.json()
    else:
        raise HTTPException(status_code=response.status_code, detail="Failed to fetch airlines")

@app.get("/airlines/routes")
def get_airline_routes():
    token = get_amadeus_token()
    url = f"{AMADEUS_API_URL}/v1/reference-data/locations/airlines/routes"
    headers = {"Authorization": f"Bearer {token}"}
    response = requests.get(url, headers=headers)
    if response.status_code == 200:
        return response.json()
    else:
        raise HTTPException(status_code=response.status_code, detail="Failed to fetch airline routes")
