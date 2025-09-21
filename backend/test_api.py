import requests
import json
from datetime import datetime, date

# Test data for the API
test_trip_request = {
    "origin": {
        "name": "Mumbai",
        "city": "Mumbai",
        "state": "Maharashtra",
        "country": "India"
    },
    "destination": {
        "name": "Goa",
        "city": "Panaji",
        "state": "Goa",
        "country": "India"
    },
    "start_date": "2024-02-15",
    "end_date": "2024-02-20",
    "travelers_count": 2,
    "preferences": {
        "themes": ["heritage", "adventure", "relaxation"],
        "budget_level": "mid_range",
        "max_budget": 50000,
        "dietary_restrictions": ["vegetarian"],
        "accessibility_needs": [],
        "languages_spoken": ["English", "Hindi"],
        "travel_style": "balanced"
    },
    "special_requirements": "Interested in water sports and historical sites"
}

def test_api_endpoints():
    """Test the main API endpoints"""
    base_url = "http://localhost:8000"
    
    print("🧪 Testing PlanSmith AI Trip Planner API")
    print("=" * 50)
    
    # Test 1: Health Check
    print("\n1. Testing Health Check...")
    try:
        response = requests.get(f"{base_url}/api/health")
        if response.status_code == 200:
            print("✅ Health check passed")
            print(f"   Response: {response.json()}")
        else:
            print(f"❌ Health check failed: {response.status_code}")
    except Exception as e:
        print(f"❌ Health check error: {e}")
    
    # Test 2: Generate Itinerary
    print("\n2. Testing Itinerary Generation...")
    try:
        response = requests.post(
            f"{base_url}/api/trips/generate",
            json=test_trip_request,
            headers={"Content-Type": "application/json"}
        )
        if response.status_code == 200:
            print("✅ Itinerary generation successful")
            data = response.json()
            print(f"   Itinerary ID: {data.get('itinerary_id')}")
            print(f"   Summary: {data.get('itinerary', {}).get('summary', 'N/A')}")
            print(f"   Total Cost: ₹{data.get('itinerary', {}).get('total_cost', 'N/A')}")
            
            # Store itinerary ID for further tests
            itinerary_id = data.get('itinerary_id')
        else:
            print(f"❌ Itinerary generation failed: {response.status_code}")
            print(f"   Error: {response.text}")
            itinerary_id = None
    except Exception as e:
        print(f"❌ Itinerary generation error: {e}")
        itinerary_id = None
    
    # Test 3: Get Itinerary
    if itinerary_id:
        print(f"\n3. Testing Get Itinerary (ID: {itinerary_id})...")
        try:
            response = requests.get(f"{base_url}/api/trips/{itinerary_id}")
            if response.status_code == 200:
                print("✅ Get itinerary successful")
                data = response.json()
                days_count = len(data.get('itinerary', {}).get('days', []))
                print(f"   Days planned: {days_count}")
            else:
                print(f"❌ Get itinerary failed: {response.status_code}")
        except Exception as e:
            print(f"❌ Get itinerary error: {e}")
    
    # Test 4: Search Locations
    print("\n4. Testing Location Search...")
    try:
        response = requests.get(f"{base_url}/api/locations/search?query=Jaipur")
        if response.status_code == 200:
            print("✅ Location search successful")
            data = response.json()
            locations = data.get('locations', [])
            print(f"   Found {len(locations)} locations")
        else:
            print(f"❌ Location search failed: {response.status_code}")
    except Exception as e:
        print(f"❌ Location search error: {e}")
    
    # Test 5: Get Attractions
    print("\n5. Testing Get Attractions...")
    try:
        response = requests.get(f"{base_url}/api/locations/Goa/attractions?state=Goa")
        if response.status_code == 200:
            print("✅ Get attractions successful")
            data = response.json()
            attractions = data.get('attractions', [])
            print(f"   Found {len(attractions)} attractions")
        else:
            print(f"❌ Get attractions failed: {response.status_code}")
    except Exception as e:
        print(f"❌ Get attractions error: {e}")
    
    # Test 6: Popular Destinations
    print("\n6. Testing Popular Destinations...")
    try:
        response = requests.get(f"{base_url}/api/analytics/popular-destinations")
        if response.status_code == 200:
            print("✅ Popular destinations successful")
            data = response.json()
            destinations = data.get('destinations', [])
            print(f"   Found {len(destinations)} popular destinations")
        else:
            print(f"❌ Popular destinations failed: {response.status_code}")
    except Exception as e:
        print(f"❌ Popular destinations error: {e}")
    
    print("\n" + "=" * 50)
    print("🏁 API Testing Complete")

def test_booking_flow():
    """Test the booking flow (requires a valid itinerary)"""
    print("\n💳 Testing Booking Flow...")
    
    # This would require a valid itinerary ID from the previous test
    # For demonstration purposes, we'll show the structure
    booking_request = {
        "itinerary_id": "test-itinerary-id",
        "payment_method": "stripe",
        "contact_info": {
            "name": "John Doe",
            "email": "john@example.com",
            "phone": "+91-9876543210"
        }
    }
    
    print("📋 Booking Request Structure:")
    print(json.dumps(booking_request, indent=2))

if __name__ == "__main__":
    print("🚀 Starting PlanSmith API Tests")
    print("Make sure the server is running on http://localhost:8000")
    
    # Test main endpoints
    test_api_endpoints()
    
    # Show booking flow structure
    test_booking_flow()
    
    print("\n📝 Test Summary:")
    print("- Health check: Basic API connectivity")
    print("- Itinerary generation: AI-powered trip planning")
    print("- Location services: Google Maps integration")
    print("- Analytics: Popular destinations")
    print("- Booking: Payment and confirmation flow")
    
    print("\n🔧 Next Steps:")
    print("1. Set up your API keys in .env file")
    print("2. Run 'python main.py' to start the server")
    print("3. Run 'python test_api.py' to test the endpoints")
    print("4. Visit http://localhost:8000/docs for API documentation")
