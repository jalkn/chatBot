# Chatbot de Auditoría de Negocios

Este repositorio contiene un conjunto de scripts para configurar y ejecutar un chatbot de auditoría de negocios utilizando el framework [LangChain](https://www.langchain.com/) y el modelo [Gemini de Google](https://ai.google.dev/). El chatbot está diseñado para generar preguntas de auditoría estructuradas y detalladas en base a un tema proporcionado por el usuario.

## Características

* **Configuración automatizada:** Un script de PowerShell (`chat.ps1`) para automatizar la creación del entorno virtual, la instalación de dependencias y la creación de los archivos de Python.

* **Generación** de preguntas de **auditoría:** Utiliza la IA para generar listas de preguntas de auditoría relevantes para una variedad de temas comerciales.

* **Salida estructurada:** Emplea un `PydanticOutputParser` para garantizar que la respuesta del modelo sea un objeto JSON estructurado y fácil de procesar.

* **Múltiples modos de chat:** Incluye scripts para una conversación simple y un modo para obtener una salida estructurada.

* **Localización:** Todos los scripts están en español para facilitar su uso a clientes hispanohablantes.

## Requisitos Previos

Asegúrate de tener instalado lo siguiente en tu sistema:

* [**Python**](https://www.python.org/downloads/) (versión 3.9 o superior)

* **PowerShell** (el script ha sido probado en Windows PowerShell)

* Una **Clave API de Google Gemini**. Puedes obtenerla en [Google AI Studio](https://ai.google.dev/).

## Instalación y Configuración

Sigue estos pasos para configurar el proyecto:

1. **Clonar el repositorio** (si aún no lo has hecho):

```

git clone https://github.com/jalkn/chatBot.git

```

2. **Ejecutar el script de configuración de PowerShell**:
Abre PowerShell en el directorio raíz del proyecto y ejecuta el script:

```

.\chat.ps1

```

Este script creará un entorno virtual de Python (`.venv`), instalará las librerías necesarias (LangChain, python-dotenv, pydantic) y creará los archivos de Python en el directorio `chat`.

3. **Configurar** la **clave API**:
Descomenta las líneas en `chat.ps1` que crean el archivo `.env` o crea manualmente un archivo llamado `.env` en la raíz del proyecto con el siguiente contenido:

```

GOOGLE\_API\_KEY="TU\_CLAVE\_API\_AQUÍ"

```

**Asegúrate de reemplazar `"TU_CLAVE_API_AQUÍ"` con tu clave API real de Google Gemini.**

## Uso

El script de PowerShell crea dos aplicaciones de chat principales:

### 1. Chat básico (`chat/chat.py`)

Este script utiliza un analizador de salida simple y es ideal para una conversación directa con el auditor.

Para ejecutarlo:

```

.venv\\scripts\\activate
python chat/chat.py

```

### 2. Chat con salida estructurada (`chat/structureOutput.py`)

Este script utiliza `Pydantic` para garantizar que la respuesta del modelo sea una lista de preguntas en formato JSON, lo que es útil si planeas procesar la salida en otra aplicación.

Para ejecutarlo:

```

.venv\\scripts\\activate
python chat\\structureOutput.py

```

En ambos casos, el programa te pedirá que escribas un "Tema de Auditoría" y responderá con una lista de preguntas.

## Estructura de Archivos

```

/
├── .venv/                   \# Entorno virtual de Python
├── chat.ps1                 \# Script principal de configuración en PowerShell
├── .env                     \# Archivo para la clave API (debes crearlo o descomentar las líneas en chat.ps1)
└── chat/
      ├── **init**.py
      ├── chat.py              \# Aplicación de chat con salida de cadena
      ├── message.py           \# Ejemplo de uso simple del modelo
      ├── mulTessages.py       \# Ejemplo de chat básico
      ├── prompTemplate.py     \# Definición de la plantilla de prompt del auditor
      └── structureOutput.py   \# Aplicación de chat con salida estructurada (recomendado)

```