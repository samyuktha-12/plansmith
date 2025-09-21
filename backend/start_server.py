#!/usr/bin/env python3
"""
PlanSmith AI Trip Planner - Server Startup Script
"""

import os
import sys
import subprocess
from pathlib import Path

def check_requirements():
    """Check if all required files and dependencies are present"""
    print("🔍 Checking requirements...")
    
    # Check if .env file exists
    env_file = Path(".env")
    if not env_file.exists():
        print("❌ .env file not found!")
        print("   Please copy env_example.txt to .env and configure your API keys")
        return False
    
    # Check if serviceAccountKey.json exists
    service_key = Path("credentials/serviceAccountKey.json")
    if not service_key.exists():
        print("⚠️  serviceAccountKey.json not found!")
        print("   Please add your Firebase service account key")
        return False
    
    # Check Python version
    if sys.version_info < (3, 9):
        print("❌ Python 3.9 or higher is required!")
        return False
    
    print("✅ Requirements check passed")
    return True

def install_dependencies():
    """Install required dependencies"""
    print("📦 Installing dependencies...")
    try:
        subprocess.run([sys.executable, "-m", "pip", "install", "-r", "requirements.txt"], 
                      check=True, capture_output=True, text=True)
        print("✅ Dependencies installed successfully")
        return True
    except subprocess.CalledProcessError as e:
        print(f"❌ Failed to install dependencies: {e}")
        print(f"   Error output: {e.stderr}")
        return False

def start_server():
    """Start the FastAPI server"""
    print("🚀 Starting PlanSmith AI Trip Planner API Server...")
    print("=" * 60)
    
    try:
        # Start the server
        subprocess.run([
            sys.executable, "main.py"
        ], check=True)
    except KeyboardInterrupt:
        print("\n👋 Server stopped by user")
    except subprocess.CalledProcessError as e:
        print(f"❌ Server failed to start: {e}")
        return False
    except Exception as e:
        print(f"❌ Unexpected error: {e}")
        return False
    
    return True

def main():
    """Main startup function"""
    print("🌟 PlanSmith AI Trip Planner Backend")
    print("=" * 60)
    
    # Check requirements
    if not check_requirements():
        print("\n❌ Requirements check failed. Please fix the issues above.")
        sys.exit(1)
    
    # Install dependencies
    if not install_dependencies():
        print("\n❌ Dependency installation failed.")
        sys.exit(1)
    
    print("\n🎯 Starting server...")
    print("📖 API Documentation will be available at:")
    print("   • Swagger UI: http://localhost:8000/docs")
    print("   • ReDoc: http://localhost:8000/redoc")
    print("   • Health Check: http://localhost:8000/api/health")
    print("\n🛑 Press Ctrl+C to stop the server")
    print("=" * 60)
    
    # Start the server
    start_server()

if __name__ == "__main__":
    main()
