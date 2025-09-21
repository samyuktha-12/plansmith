#!/usr/bin/env python3
"""
Test script to verify backend connection and API endpoints
"""

import requests
import json
import time

BASE_URL = "http://localhost:8000"

def test_health():
    """Test health endpoint"""
    print("🔍 Testing health endpoint...")
    try:
        response = requests.get(f"{BASE_URL}/api/health")
        if response.status_code == 200:
            print("✅ Health check passed")
            print(f"   Response: {response.json()}")
            return True
        else:
            print(f"❌ Health check failed: {response.status_code}")
            return False
    except Exception as e:
        print(f"❌ Health check error: {e}")
        return False

def test_activities():
    """Test activities endpoint"""
    print("\n🔍 Testing activities endpoint...")
    try:
        preferences = {
            "destination": {
                "city": "Paris",
                "country": "France"
            },
            "themes": ["heritage", "cultural"],
            "budget_level": "mid_range",
            "budget_amount": 50000,
            "travelers_count": 2,
            "trip_duration": "5",
            "travel_style": "balanced",
            "interests": ["museums", "art"],
            "age_group": "25-35"
        }
        
        response = requests.post(
            f"{BASE_URL}/api/activities",
            headers={"Content-Type": "application/json"},
            json=preferences
        )
        
        if response.status_code == 200:
            data = response.json()
            print("✅ Activities endpoint working")
            print(f"   Found {len(data.get('activities', []))} activities")
            return True
        else:
            print(f"❌ Activities endpoint failed: {response.status_code}")
            print(f"   Response: {response.text}")
            return False
    except Exception as e:
        print(f"❌ Activities endpoint error: {e}")
        return False

def test_itinerary_generation():
    """Test full itinerary generation"""
    print("\n🔍 Testing itinerary generation...")
    try:
        trip_request = {
            "origin": {
                "name": "Current Location",
                "city": "Current City",
                "state": "Current State",
                "country": "Current Country"
            },
            "destination": {
                "name": "Paris, France",
                "city": "Paris",
                "state": "",
                "country": "France"
            },
            "start_date": "2024-02-01",
            "end_date": "2024-02-05",
            "travelers_count": 2,
            "preferences": {
                "themes": ["heritage", "cultural"],
                "budget_level": "mid_range",
                "max_budget": 50000.0,
                "dietary_restrictions": [],
                "accessibility_needs": [],
                "languages_spoken": ["English"],
                "travel_style": "balanced",
                "interests": ["museums", "art"],
                "travelers_count": 2
            },
            "special_requirements": "First time visiting Paris"
        }
        
        response = requests.post(
            f"{BASE_URL}/api/trips/generate",
            headers={"Content-Type": "application/json"},
            json=trip_request
        )
        
        if response.status_code == 200:
            data = response.json()
            print("✅ Itinerary generation working")
            print(f"   Generated itinerary ID: {data.get('itinerary_id')}")
            return True
        else:
            print(f"❌ Itinerary generation failed: {response.status_code}")
            print(f"   Response: {response.text}")
            return False
    except Exception as e:
        print(f"❌ Itinerary generation error: {e}")
        return False

def main():
    """Run all tests"""
    print("🚀 Testing PlanSmith Backend API")
    print("=" * 50)
    
    # Wait a moment for server to start
    print("⏳ Waiting for server to start...")
    time.sleep(3)
    
    # Run tests
    health_ok = test_health()
    activities_ok = test_activities()
    itinerary_ok = test_itinerary_generation()
    
    print("\n" + "=" * 50)
    print("📊 Test Results:")
    print(f"   Health Check: {'✅ PASS' if health_ok else '❌ FAIL'}")
    print(f"   Activities API: {'✅ PASS' if activities_ok else '❌ FAIL'}")
    print(f"   Itinerary Gen: {'✅ PASS' if itinerary_ok else '❌ FAIL'}")
    
    if all([health_ok, activities_ok, itinerary_ok]):
        print("\n🎉 All tests passed! Backend is ready for Flutter integration.")
    else:
        print("\n⚠️  Some tests failed. Check the backend logs for details.")

if __name__ == "__main__":
    main()
