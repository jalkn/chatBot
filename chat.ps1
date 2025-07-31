function chatBot {
    param (
        [string]$ExcelFilePath = $null
    )

    $YELLOW = [ConsoleColor]::Yellow

    Write-Host "🚀 Creating LangChain framework" -ForegroundColor $YELLOW

    # Create Python virtual environment
    python -m venv .venv
    .\.venv\scripts\activate

    # Install required Python packages
    python.exe -m pip install --upgrade pip
    python -m pip install langchain-google-genai python-dotenv


    # Create templates directory structure
    $directories = @(
        "chat",
        "chat/historial",
        "chat/results"
    )
    foreach ($dir in $directories) {
        New-Item -Path $dir -ItemType Directory -Force
    }

# Create .env with API KEY
#t-Content -Path ".env" -Value @" 
#GOOGLE_API_KEY=""
#"@

# Create example.py
Set-Content -Path "chat/message.py" -Value @"
from langchain_google_genai import ChatGoogleGenerativeAI
from dotenv import load_dotenv
import os

load_dotenv()

api_key = os.getenv("GOOGLE_API_KEY")

if not api_key:
    raise ValueError("GOOGLE_API_KEY environment variable not set.")

# Check the Google AI documentation for the latest available models.
chat_model = ChatGoogleGenerativeAI(model="gemini-2.0-flash", google_api_key=api_key)

result = chat_model.predict("hi!")
print(result)
"@

# Create mulTexample.py
Set-Content -Path "chat/mulTessages.py" -Value @"
from langchain_google_genai import ChatGoogleGenerativeAI
from dotenv import load_dotenv
import os

load_dotenv()

api_key = os.getenv("GOOGLE_API_KEY")

if not api_key:
    raise ValueError("GOOGLE_API_KEY environment variable not set.")

chat_model = ChatGoogleGenerativeAI(model="gemini-1.5-flash", google_api_key=api_key)

print("Chatbot started! Type 'exit' to quit.")

while True:
    user_message = input("You: ")
    if user_message.lower() == 'exit':
        print("Exiting chat.")
        break
    
    try:
        result = chat_model.predict(user_message)
        print(f"Bot: {result}")
    except Exception as e:
        print(f"An error occurred: {e}")
"@


# Create chain.py
Set-Content -Path "chat/chain.py" -Value @" 
"@
}

chatBot