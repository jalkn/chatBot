function chatBot {
    param (
        [string]$ExcelFilePath = $null
    )

    $YELLOW = [ConsoleColor]::Yellow

    Write-Host "🚀 Creando el framework de LangChain" -ForegroundColor $YELLOW

    # Crear entorno virtual de Python
    python -m venv .venv
    .\.venv\scripts\activate

    # Instalar paquetes de Python requeridos
    python.exe -m pip install --upgrade pip
    python -m pip install langchain-google-genai python-dotenv pydantic

    # Crear la estructura del directorio de plantillas
    $directories = @(
        "chat",
        "chat/historial"
    )
    foreach ($dir in $directories) {
        New-Item -Path $dir -ItemType Directory -Force
    }

# Crear .env con la CLAVE API
#Set-Content -Path ".env" -Value @" 
#GOOGLE_API_KEY=""
#"@

# Crear message.py
Set-Content -Path "chat/message.py" -Value @"
from langchain_google_genai import ChatGoogleGenerativeAI
from dotenv import load_dotenv
import os

load_dotenv()

api_key = os.getenv("GOOGLE_API_KEY")

if not api_key:
    raise ValueError("No se ha establecido la variable de entorno GOOGLE_API_KEY.")

# Comprobar la documentación de Google AI para los últimos modelos disponibles.
chat_model = ChatGoogleGenerativeAI(model="gemini-2.0-flash", google_api_key=api_key)

result = chat_model.predict("¡hola!")
print(result)
"@

# Crear mulTessages.py
Set-Content -Path "chat/mulTessages.py" -Value @"
from langchain_google_genai import ChatGoogleGenerativeAI
from dotenv import load_dotenv
import os

load_dotenv()

api_key = os.getenv("GOOGLE_API_KEY")

if not api_key:
    raise ValueError("No se ha establecido la variable de entorno GOOGLE_API_KEY.")

chat_model = ChatGoogleGenerativeAI(model="gemini-1.5-flash", google_api_key=api_key)

print("¡Chatbot iniciado! Escribe 'exit' para salir.")

while True:
    user_message = input("Tú: ")
    if user_message.lower() == 'exit':
        print("Saliendo del chat.")
        break
    
    try:
        result = chat_model.predict(user_message)
        print(f"Bot: {result}")
    except Exception as e:
        print(f"Ocurrió un error: {e}")
"@

# Crear prompTemplate.py
Set-Content -Path "chat/prompTemplate.py" -Value @"
from langchain_core.prompts import ChatPromptTemplate
from langchain_core.messages import SystemMessage, HumanMessage

def get_auditor_prompt_template():
    """
    Crea y devuelve una ChatPromptTemplate de LangChain para un auditor de negocios.

    La plantilla define la persona de la IA, el contexto de la auditoría,
    y los marcadores de posición para las preguntas dinámicas del usuario.
    """
    # El mensaje del sistema establece el escenario y define la persona de la IA.
    # Instruye al modelo sobre su rol, responsabilidades y tono.
    system_message = """
    Eres un auditor de negocios experimentado y meticuloso. Tu función es hacer
    preguntas incisivas y detalladas para evaluar la salud financiera, la eficiencia
    operativa, el cumplimiento y las perspectivas estratégicas de una empresa.

    Tus preguntas deben ser estructuradas, claras y diseñadas para descubrir posibles
    riesgos, debilidades y oportunidades de mejora.
    
    Mantén un tono profesional, objetivo y analítico.
    
    Las áreas en las que te centrarás incluyen:
    1. Finanzas: Ingresos, gastos, rentabilidad, flujo de caja, deuda.
    2. Operaciones: Cadena de suministro, procesos de producción, eficiencia, control de calidad.
    3. Cumplimiento y Gobierno: Adherencia regulatoria, controles internos, gobierno corporativo.
    4. Mercado y Estrategia: Panorama competitivo, estrategia de crecimiento, posicionamiento en el mercado.
    
    Proporciona tus preguntas en un formato claro de viñetas.
    """
    
    # El mensaje humano contiene la parte dinámica del prompt.
    # Permite al usuario especificar un tema para las preguntas.
    human_message = """
    Genera una lista de preguntas de auditoría clave para el tema: {topic}.
    """

    # Combina los mensajes en una ChatPromptTemplate.
    # Este es un componente clave de LangChain para crear prompts conversacionales.
    chat_prompt_template = ChatPromptTemplate.from_messages([
        SystemMessage(content=system_message),
        HumanMessage(content=human_message)
    ])
    
    return chat_prompt_template
"@

# Crear chat.py
Set-Content -Path "chat/chat.py" -Value @"
from langchain_google_genai import ChatGoogleGenerativeAI
from dotenv import load_dotenv
import os
from prompTemplate import get_auditor_prompt_template  
from langchain_core.runnables import RunnablePassthrough
from langchain_core.output_parsers import StrOutputParser

# Cargar variables de entorno del archivo .env
load_dotenv()

# Obtener la clave API
api_key = os.getenv("GOOGLE_API_KEY")

# Comprobar si se ha establecido la clave API
if not api_key:
    raise ValueError("No se ha establecido la variable de entorno GOOGLE_API_KEY.")

# Inicializar el modelo de chat con el modelo Gemini 1.5 Flash
chat_model = ChatGoogleGenerativeAI(model="gemini-2.0-flash", google_api_key=api_key)

# Obtener la plantilla de prompt del auditor predefinida
auditor_prompt_template = get_auditor_prompt_template()

# Crear una cadena del Lenguaje de Expresión de LangChain (LCEL)
# Esto asegura que la entrada del usuario se procese correctamente
# y se pase al modelo.
chain = (
    {"topic": RunnablePassthrough()}
    | auditor_prompt_template
    | chat_model
    | StrOutputParser()
)

print("¡El chatbot de auditoría de negocios ha comenzado!")
print("Escribe un tema para las preguntas de auditoría (por ejemplo, 'Finanzas', 'Cumplimiento').")
print("Escribe 'exit' para salir del chat.")

# Iniciar el bucle de chat
while True:
    user_topic = input("Tema de Auditoría: ")
    
    # Comprobar el comando de salida
    if user_topic.lower() == 'exit':
        print("Saliendo del chat.")
        break
    
    try:
        # Invocar la cadena con el tema del usuario
        result = chain.invoke(user_topic)
        
        # Imprimir el contenido de la respuesta del LLM
        print(f"\nPreguntas de Auditoría:\n{result}\n")
        
    except Exception as e:
        print(f"Ocurrió un error: {e}")
"@

# Crear structureOutput.py
Set-Content -Path "chat/structureOutput.py" -Value @"
# chat_with_structured_output.py

from langchain_google_genai import ChatGoogleGenerativeAI
from dotenv import load_dotenv
import os
from langchain_core.prompts import ChatPromptTemplate
from langchain_core.messages import HumanMessage, SystemMessage
from langchain_core.runnables import RunnablePassthrough
from langchain_core.output_parsers import PydanticOutputParser
from pydantic import BaseModel, Field
from typing import List

# Cargar variables de entorno del archivo .env
load_dotenv()

# Obtener la clave API
api_key = os.getenv("GOOGLE_API_KEY")

# Comprobar si se ha establecido la clave API
if not api_key:
    raise ValueError("No se ha establecido la variable de entorno GOOGLE_API_KEY.")

# --- Definir la estructura de salida deseada usando Pydantic ---
class AuditQuestions(BaseModel):
    """Una lista de preguntas de auditoría."""
    questions: List[str] = Field(description="Una lista de preguntas de auditoría detalladas.")

# Inicializar el PydanticOutputParser con el modelo Pydantic
parser = PydanticOutputParser(pydantic_object=AuditQuestions)

# --- Crear la plantilla de prompt con instrucciones de formato en español ---
# El mensaje del sistema se actualiza para ser más explícito sobre la salida esperada,
# y ahora está en español.
system_message = f"""
Eres un auditor de negocios experimentado y meticuloso. Tu función es hacer
preguntas incisivas y detalladas para evaluar la salud financiera, la eficiencia
operativa, el cumplimiento y las perspectivas estratégicas de una empresa.

Tus preguntas deben ser estructuradas, claras y diseñadas para descubrir posibles
riesgos, debilidades y oportunidades de mejora.

Tu ÚNICA tarea es generar una respuesta en formato JSON. NO incluyas ningún texto conversacional.

{parser.get_format_instructions()}
"""

human_message = """
Genera una lista de preguntas de auditoría clave para el tema: {topic}.
"""

# Combinar los mensajes en una ChatPromptTemplate.
auditor_prompt_template = ChatPromptTemplate.from_messages([
    SystemMessage(content=system_message),
    HumanMessage(content=human_message)
])

# Inicializar el modelo de chat
chat_model = ChatGoogleGenerativeAI(model="gemini-1.5-flash", google_api_key=api_key)

# --- Crear la cadena del Lenguaje de Expresión de LangChain (LCEL) ---
# La cadena ahora incluye el analizador como el paso final, asegurando que la salida
# sea un objeto Pydantic.
chain = (
    {"topic": RunnablePassthrough()}
    | auditor_prompt_template
    | chat_model
    | parser
)

# Las cadenas orientadas al usuario también se traducen al español
print("¡El chatbot de auditoría de negocios ha comenzado!")
print("Escribe un tema para las preguntas de auditoría (por ejemplo, 'Finanzas', 'Cumplimiento').")
print("Escribe 'exit' para salir del chat.")

# Iniciar el bucle de chat
while True:
    user_topic = input("Tema de Auditoría: ")
    
    # Comprobar el comando de salida
    if user_topic.lower() == 'exit':
        print("Saliendo del chat.")
        break
    
    try:
        # Invocar la cadena con el tema del usuario
        result = chain.invoke(user_topic)
        
        # El resultado es ahora un objeto Pydantic, al que podemos acceder fácilmente.
        print("\nPreguntas de Auditoría:")
        for question in result.questions:
            print(f"- {question}")
        print("\n")
        
    except Exception as e:
        print(f"Ocurrió un error: {e}")
"@
}

chatBot