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
        "chat/historial"
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


# Create prompTemplate.py
Set-Content -Path "chat/prompTemplate.py" -Value @"
from langchain_core.prompts import ChatPromptTemplate
from langchain_core.messages import SystemMessage, HumanMessage

def get_auditor_prompt_template():
    """
    Creates and returns a LangChain ChatPromptTemplate for a business auditor.

    The template defines the persona of the AI, the context of the audit,
    and placeholders for dynamic user questions.
    """
    # It instructs the model on its role, responsibilities, and tone.
    system_message = """
    You are an experienced and meticulous business auditor. Your role is to ask
    incisive, detailed questions to assess a company's financial health, operational
    efficiency, compliance, and strategic outlook.

    Your questions should be structured, clear, and designed to uncover potential
    risks, weaknesses, and opportunities for improvement.
    
    Maintain a professional, objective, and analytical tone.
    
    The areas you will focus on include:
    1. Financials: Revenue, expenses, profitability, cash flow, debt.
    2. Operations: Supply chain, production processes, efficiency, quality control.
    3. Compliance & Governance: Regulatory adherence, internal controls, corporate governance.
    4. Market & Strategy: Competitive landscape, growth strategy, market positioning.
    
    Provide your questions in a clear, bullet-point format.
    """
    
    # It allows the user to specify a topic for the questions.
    human_message = """
    Generate a list of key audit questions for the topic: {topic}.
    """

    # This is a key component of LangChain for creating conversational prompts.
    chat_prompt_template = ChatPromptTemplate.from_messages([
        SystemMessage(content=system_message),
        HumanMessage(content=human_message)
    ])
    
    return chat_prompt_template
"@

# Create chat.py
Set-Content -Path "chat/chat.py" -Value @"
# chat_app.py

from langchain_google_genai import ChatGoogleGenerativeAI
from dotenv import load_dotenv
import os
from prompTemplate import get_auditor_prompt_template  

# Load environment variables from the .env file
load_dotenv()

# Get the API key
api_key = os.getenv("GOOGLE_API_KEY")

# Check if the API key is set
if not api_key:
    raise ValueError("GOOGLE_API_KEY environment variable not set.")

# Initialize the chat model with the Gemini 1.5 Flash model
chat_model = ChatGoogleGenerativeAI(model="gemini-2.0-flash", google_api_key=api_key)

# Get the pre-defined auditor prompt template
auditor_prompt_template = get_auditor_prompt_template()

print("Business Auditor Chatbot started!")
print("Type a topic for audit questions (e.g., Financials, Compliance).")
print("Type 'exit' to quit the chat.")

# Start the chat loop
while True:
    user_topic = input("Auditor Topic: ")
    
    # Check for the exit command
    if user_topic.lower() == 'exit':
        print("Exiting chat.")
        break
    
    # This combines the system message and the human message with the topic
    formatted_prompt = auditor_prompt_template.format_prompt(topic=user_topic)
    
    try:
        # The .invoke() method sends the prompt to the LLM and gets the response
        result = chat_model.invoke(formatted_prompt)
        
        # Print the LLM's response content
        print(f"\nAudit Questions:\n{result.content}\n")
        
    except Exception as e:
        print(f"An error occurred: {e}")
"@
}

chatBot