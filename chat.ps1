function TC {
    param (
        [string]$ExcelFilePath = $null
    )

    $YELLOW = [ConsoleColor]::Yellow

    Write-Host "🚀 Creating TC framework" -ForegroundColor $YELLOW

    # Create Python virtual environment
    python -m venv .venv
    .\.venv\scripts\activate

    # Install required Python packages
    python.exe -m pip install --upgrade pip
    python -m pip install langchain langchain-community langchain-pinecone langchain-openai datasets

    # Create templates directory structure
    $directories = @(
        "PDFS",
        "PDFS/MC",
        "PDFS/Visa",
        "Resultados",
        "Resultados/MC_Resultados",
        "Resultados/Visa_Resultados"
    )
    foreach ($dir in $directories) {
        New-Item -Path $dir -ItemType Directory -Force
    }

# Create models.py with cedula as primary key
Set-Content -Path "cards.py" -Value @" 
"@
}

TC