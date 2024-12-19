# Terminal Chatbot

This project provides a simple, native chatbot experience directly within your terminal.

## Features

* Basic conversational abilities.
* Customizable responses.
* Easy setup and installation.
* Lightweight and dependency-free

## Installation

1. **Clone the repository:**

   ```bash
   git clone https://github.com/jalknToth/chatBot.git
   ```

2. **Customize your chatbot's responses:**

   Open `chat.sh` and edit the `responses` dictionary around line 118.  Add or modify the json script.

   ```python
   responses = {
      "hello": "Hi there! How can I help you today?",
      "how are you": "I'm doing well, thank you for asking!","bye": "Goodbye! Have a great day!",
      "help": "I'm a simple chat agent. You can talk to me about basic topics.",
      }


3. **Run the setup script:**

   ```bash
   chmod +x chat.sh
   ./chat.sh
   ```

4. **Run the chatbot:**

   ```bash
   python3 chat.py #linux or mac
   or
   python chat.py #windows
   ```

## Usage

After running `python3 chat.py`, you can interact with the chatbot by typing messages and pressing Enter.  The chatbot will respond based on the pre-defined responses in the `chat.py` file.   Type 'quit' to exit

## Contributing

Contributions are welcome! Please fork the repository and submit a pull request. 
