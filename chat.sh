#!/bin/bash

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

set -e

createFiles() {
    echo -e "${YELLOW}🏗️ Creating chatBot Files${NC}"

    touch .env .gitignore chat.py

    echo "Project files created successfully."
}

gitignore() {
    echo -e "${YELLOW}♠︎ Generating .gitignore file${NC}"
    cat > .gitignore << EOL
.vscode
__pycache__
*.pyc
.venv
.env
EOL
}

creatEnv() {
    echo -e "${YELLOW}🔐 Generating .env file${NC}"
    cat > .env << EOL
SECRET=$(openssl rand -hex 32)
EOL
}

createChat() {
    echo -e "${YELLOW}🚀 Creating main application file${NC}"
    cat > chat.py << EOL
from typing import List, Dict, Any, Optional
import json
from abc import ABC, abstractmethod
from datetime import datetime

class Message:
    def __init__(self, content: str, role: str, timestamp: Optional[datetime] = None):
        self.content = content
        self.role = role
        self.timestamp = timestamp or datetime.now()

    def to_dict(self) -> Dict[str, Any]:
        return {
            "content": self.content,
            "role": self.role,
            "timestamp": self.timestamp.isoformat()
        }

class Memory:
    def __init__(self):
        self.messages: List[Message] = []
    
    def add_message(self, message: Message):
        self.messages.append(message)
    
    def get_conversation_history(self) -> List[Message]:
        return self.messages
    
    def clear(self):
        self.messages = []

class ResponseGenerator(ABC):
    @abstractmethod
    def generate_response(self, message: str, context: List[Message]) -> str:
        pass

class SimpleResponseGenerator(ResponseGenerator):
    def __init__(self, responses: Dict[str, str]):
        self.responses = responses

    def generate_response(self, message: str, context: List[Message]) -> str:
        # Simple pattern matching - you can replace this with more sophisticated logic
        for pattern, response in self.responses.items():
            if pattern.lower() in message.lower():
                return response
        return "I'm not sure how to respond to that."

class ChatAgent:
    def __init__(self, response_generator: ResponseGenerator, memory: Optional[Memory] = None):
        self.response_generator = response_generator
        self.memory = memory or Memory()

    def process_message(self, message: str) -> str:
        # Create and store user message
        user_message = Message(message, "user")
        self.memory.add_message(user_message)

        # Generate response
        response = self.response_generator.generate_response(
            message, 
            self.memory.get_conversation_history()
        )

        # Store bot response
        bot_message = Message(response, "bot")
        self.memory.add_message(bot_message)

        return response

    def save_conversation(self, filename: str):
        with open(filename, 'w') as f:
            json.dump(
                [msg.to_dict() for msg in self.memory.get_conversation_history()],
                f,
                indent=2
            )

# Example usage
def create_simple_chat_agent() -> ChatAgent:
    # Define some basic responses
    responses = {
        "hello": "Hi there! How can I help you today?",
        "how are you": "I'm doing well, thank you for asking!",
        "bye": "Goodbye! Have a great day!",
        "help": "I'm a simple chat agent. You can talk to me about basic topics.",
    }
    
    return ChatAgent(SimpleResponseGenerator(responses))

if __name__ == "__main__":
    # Create and use the chat agent
    agent = create_simple_chat_agent()
    
    print("Chat Agent initialized. Type 'quit' to exit.")
    while True:
        user_input = input("You: ")
        if user_input.lower() == 'quit':
            break
            
        response = agent.process_message(user_input)
        print(f"Bot: {response}")

    # Save conversation history
    agent.save_conversation("chat_history.json")
EOL
}

setProject(){
    createChat
    createFiles
    gitignore
    creatEnv

}

main() {
    echo -e "${YELLOW}🔧 chatBot Initialization${NC}"
    
    python3 -m venv .venv
    source .venv/bin/activate
    pip install --upgrade pip
    pip install --use-pep517 python-dotenv
    pip install --upgrade pip setuptools wheel
    pip install typing datetime
    setProject

    source .env || { echo "Error sourcing .env"; exit 1; }

    chmod 600 .env

    echo -e "${GREEN}🎉 Project is ready! Run 'python3 chat.py(linux, mac) or python chat.py(windows)' to start.${NC}"
}

main