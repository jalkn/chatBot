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
        "chat/history",
        "chat/results"
    )
    foreach ($dir in $directories) {
        New-Item -Path $dir -ItemType Directory -Force
    }

# Create .env with API KEY
Set-Content -Path ".env" -Value @" 
GOOGLE_API_KEY=""
"@

# Create example.py
Set-Content -Path "chat/example.py" -Value @"
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


# Create chain.py
Set-Content -Path "chat/chain.py" -Value @" 
"@
}

chatBot