import os
import firebase_admin
from firebase_admin import credentials, firestore, storage
from typing import Dict, List, Any, Optional
import logging
from datetime import datetime
import uuid

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

class FirebaseService:
    def __init__(self):
        """Initialize Firebase service"""
        if not firebase_admin._apps:
            # Initialize Firebase Admin SDK
            cred_path = os.getenv("FIREBASE_SERVICE_ACCOUNT_PATH", "serviceAccountKey.json")
            cred = credentials.Certificate(cred_path)
            firebase_admin.initialize_app(cred, {
                'storageBucket': os.getenv("FIREBASE_STORAGE_BUCKET")
            })
        
        self.db = firestore.client()
        self.bucket = storage.bucket() if os.getenv("FIREBASE_STORAGE_BUCKET") else None
        
    async def save_itinerary(self, itinerary_data: Dict[str, Any], user_id: str) -> str:
        """Save itinerary to Firestore"""
        try:
            itinerary_id = str(uuid.uuid4())
            itinerary_data["id"] = itinerary_id
            itinerary_data["user_id"] = user_id
            itinerary_data["created_at"] = datetime.now()
            itinerary_data["updated_at"] = datetime.now()
            
            doc_ref = self.db.collection("itineraries").document(itinerary_id)
            doc_ref.set(itinerary_data)
            
            logger.info(f"Itinerary saved with ID: {itinerary_id}")
            return itinerary_id
            
        except Exception as e:
            logger.error(f"Error saving itinerary: {str(e)}")
            raise Exception(f"Failed to save itinerary: {str(e)}")
    
    async def get_itinerary(self, itinerary_id: str) -> Optional[Dict[str, Any]]:
        """Get itinerary by ID"""
        try:
            doc_ref = self.db.collection("itineraries").document(itinerary_id)
            doc = doc_ref.get()
            
            if doc.exists:
                return doc.to_dict()
            else:
                return None
                
        except Exception as e:
            logger.error(f"Error getting itinerary: {str(e)}")
            raise Exception(f"Failed to get itinerary: {str(e)}")
    
    async def update_itinerary(self, itinerary_id: str, update_data: Dict[str, Any]) -> bool:
        """Update itinerary"""
        try:
            update_data["updated_at"] = datetime.now()
            
            doc_ref = self.db.collection("itineraries").document(itinerary_id)
            doc_ref.update(update_data)
            
            logger.info(f"Itinerary updated: {itinerary_id}")
            return True
            
        except Exception as e:
            logger.error(f"Error updating itinerary: {str(e)}")
            raise Exception(f"Failed to update itinerary: {str(e)}")
    
    async def get_user_itineraries(self, user_id: str) -> List[Dict[str, Any]]:
        """Get all itineraries for a user"""
        try:
            itineraries_ref = self.db.collection("itineraries")
            query = itineraries_ref.where("user_id", "==", user_id).order_by("created_at", direction=firestore.Query.DESCENDING)
            
            docs = query.stream()
            itineraries = []
            
            for doc in docs:
                itinerary = doc.to_dict()
                itineraries.append(itinerary)
            
            return itineraries
            
        except Exception as e:
            logger.error(f"Error getting user itineraries: {str(e)}")
            raise Exception(f"Failed to get user itineraries: {str(e)}")
    
    async def save_booking(self, booking_data: Dict[str, Any]) -> str:
        """Save booking information"""
        try:
            booking_id = str(uuid.uuid4())
            booking_data["id"] = booking_id
            booking_data["created_at"] = datetime.now()
            booking_data["status"] = "pending"
            
            doc_ref = self.db.collection("bookings").document(booking_id)
            doc_ref.set(booking_data)
            
            logger.info(f"Booking saved with ID: {booking_id}")
            return booking_id
            
        except Exception as e:
            logger.error(f"Error saving booking: {str(e)}")
            raise Exception(f"Failed to save booking: {str(e)}")
    
    async def update_booking_status(self, booking_id: str, status: str, 
                                  additional_data: Dict[str, Any] = None) -> bool:
        """Update booking status"""
        try:
            update_data = {
                "status": status,
                "updated_at": datetime.now()
            }
            
            if additional_data:
                update_data.update(additional_data)
            
            doc_ref = self.db.collection("bookings").document(booking_id)
            doc_ref.update(update_data)
            
            logger.info(f"Booking status updated: {booking_id} -> {status}")
            return True
            
        except Exception as e:
            logger.error(f"Error updating booking status: {str(e)}")
            raise Exception(f"Failed to update booking status: {str(e)}")
    
    async def save_user_preferences(self, user_id: str, preferences: Dict[str, Any]) -> bool:
        """Save user preferences"""
        try:
            preferences["updated_at"] = datetime.now()
            
            doc_ref = self.db.collection("user_preferences").document(user_id)
            doc_ref.set(preferences, merge=True)
            
            logger.info(f"User preferences saved for: {user_id}")
            return True
            
        except Exception as e:
            logger.error(f"Error saving user preferences: {str(e)}")
            raise Exception(f"Failed to save user preferences: {str(e)}")
    
    async def get_user_preferences(self, user_id: str) -> Optional[Dict[str, Any]]:
        """Get user preferences"""
        try:
            doc_ref = self.db.collection("user_preferences").document(user_id)
            doc = doc_ref.get()
            
            if doc.exists:
                return doc.to_dict()
            else:
                return None
                
        except Exception as e:
            logger.error(f"Error getting user preferences: {str(e)}")
            raise Exception(f"Failed to get user preferences: {str(e)}")
    
    async def save_feedback(self, itinerary_id: str, feedback_data: Dict[str, Any]) -> str:
        """Save user feedback for an itinerary"""
        try:
            feedback_id = str(uuid.uuid4())
            feedback_data["id"] = feedback_id
            feedback_data["itinerary_id"] = itinerary_id
            feedback_data["created_at"] = datetime.now()
            
            doc_ref = self.db.collection("feedback").document(feedback_id)
            doc_ref.set(feedback_data)
            
            logger.info(f"Feedback saved with ID: {feedback_id}")
            return feedback_id
            
        except Exception as e:
            logger.error(f"Error saving feedback: {str(e)}")
            raise Exception(f"Failed to save feedback: {str(e)}")
    
    async def get_popular_destinations(self, limit: int = 10) -> List[Dict[str, Any]]:
        """Get popular destinations based on booking data"""
        try:
            # Mock popular destinations data that matches frontend expectations
            return [
                {
                    "id": "dest_1",
                    "name": "Jaipur",
                    "state": "Rajasthan",
                    "country": "India",
                    "image_url": "https://images.unsplash.com/photo-1564507592333-c60657eea523?w=400&h=300&fit=crop",
                    "visitor_count": 1250,
                    "average_rating": 4.5,
                    "popular_months": ["October", "November", "March"],
                    "description": "The Pink City of India, known for its magnificent palaces and rich cultural heritage",
                    "top_attractions": ["Amber Fort", "City Palace", "Hawa Mahal", "Jantar Mantar"],
                    "best_time_to_visit": "October to March",
                    "budget_range": "₹2000-₹8000 per day",
                    "themes": ["Heritage", "Cultural", "Shopping", "Food"]
                },
                {
                    "id": "dest_2",
                    "name": "Udaipur",
                    "state": "Rajasthan", 
                    "country": "India",
                    "image_url": "https://images.unsplash.com/photo-1571896349842-33c89424de2d?w=400&h=300&fit=crop",
                    "visitor_count": 980,
                    "average_rating": 4.3,
                    "popular_months": ["October", "November", "March"],
                    "description": "The City of Lakes, famous for its romantic palaces and beautiful water bodies",
                    "top_attractions": ["City Palace", "Lake Pichola", "Jag Mandir", "Fateh Sagar Lake"],
                    "best_time_to_visit": "September to March",
                    "budget_range": "₹2500-₹10000 per day",
                    "themes": ["Romantic", "Heritage", "Nature", "Luxury"]
                },
                {
                    "id": "dest_3",
                    "name": "Jodhpur",
                    "state": "Rajasthan",
                    "country": "India",
                    "image_url": "https://images.unsplash.com/photo-1587474260584-136574528ed5?w=400&h=300&fit=crop",
                    "visitor_count": 750,
                    "average_rating": 4.2,
                    "popular_months": ["October", "November", "February"],
                    "description": "The Blue City, known for its blue-painted houses and majestic Mehrangarh Fort",
                    "top_attractions": ["Mehrangarh Fort", "Jaswant Thada", "Umaid Bhawan Palace", "Clock Tower"],
                    "best_time_to_visit": "October to March",
                    "budget_range": "₹1800-₹6000 per day",
                    "themes": ["Heritage", "Adventure", "Cultural", "Photography"]
                },
                {
                    "id": "dest_4",
                    "name": "Pushkar",
                    "state": "Rajasthan",
                    "country": "India",
                    "image_url": "https://images.unsplash.com/photo-1594736797933-d0c1b6b7b5e5?w=400&h=300&fit=crop",
                    "visitor_count": 650,
                    "average_rating": 4.1,
                    "popular_months": ["October", "November", "March"],
                    "description": "A sacred town with the only Brahma temple in the world and a holy lake",
                    "top_attractions": ["Brahma Temple", "Pushkar Lake", "Camel Fair", "Savitri Temple"],
                    "best_time_to_visit": "October to March",
                    "budget_range": "₹1500-₹4000 per day",
                    "themes": ["Spiritual", "Cultural", "Adventure", "Photography"]
                }
            ]
            
        except Exception as e:
            logger.error(f"Error getting popular destinations: {str(e)}")
            return []
    
    async def upload_file(self, file_data: bytes, file_name: str, 
                         content_type: str = "image/jpeg") -> str:
        """Upload file to Firebase Storage"""
        try:
            if not self.bucket:
                raise Exception("Firebase Storage not configured")
            
            blob = self.bucket.blob(f"itineraries/{file_name}")
            blob.upload_from_string(file_data, content_type=content_type)
            
            # Make the file publicly accessible
            blob.make_public()
            
            return blob.public_url
            
        except Exception as e:
            logger.error(f"Error uploading file: {str(e)}")
            raise Exception(f"Failed to upload file: {str(e)}")
    
    async def delete_itinerary(self, itinerary_id: str) -> bool:
        """Delete an itinerary"""
        try:
            doc_ref = self.db.collection("itineraries").document(itinerary_id)
            doc_ref.delete()
            
            logger.info(f"Itinerary deleted: {itinerary_id}")
            return True
            
        except Exception as e:
            logger.error(f"Error deleting itinerary: {str(e)}")
            raise Exception(f"Failed to delete itinerary: {str(e)}")
    
    async def search_itineraries(self, query: str, filters: Dict[str, Any] = None) -> List[Dict[str, Any]]:
        """Search itineraries based on query and filters"""
        try:
            itineraries_ref = self.db.collection("itineraries")
            query_obj = itineraries_ref
            
            # Apply filters
            if filters:
                if "destination" in filters:
                    query_obj = query_obj.where("trip_request.destination.name", ">=", filters["destination"]).where("trip_request.destination.name", "<=", filters["destination"] + "\uf8ff")
                
                if "budget_level" in filters:
                    query_obj = query_obj.where("trip_request.preferences.budget_level", "==", filters["budget_level"])
                
                if "themes" in filters:
                    query_obj = query_obj.where("trip_request.preferences.themes", "array_contains_any", filters["themes"])
            
            docs = query_obj.limit(20).stream()
            itineraries = []
            
            for doc in docs:
                itinerary = doc.to_dict()
                # Simple text search in summary
                if query.lower() in itinerary.get("summary", "").lower():
                    itineraries.append(itinerary)
            
            return itineraries
            
        except Exception as e:
            logger.error(f"Error searching itineraries: {str(e)}")
            return []
