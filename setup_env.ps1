# Путь к папке .venv
# Check if Python is existing
if (-not (Get-Command python -ErrorAction SilentlyContinue)) {
    Write-Output "Error. Python not found. Install Python and add it to PATH."
    exit
}


# Create virtual environment
python -m venv .venv


# Check if virtual environment was created
if (-not (Test-Path ".venv\Scripts\Activate.ps1")) {
    Write-Output "Error: Failed to create virtual environment."
    exit
}


# Activate virtual environment
if (-not ($env:VIRTUAL_ENV)) {
    . .\.venv\Scripts\Activate.ps1
}


# Create requirements.txt with dependencies
$requirementsPath = "requirements.txt"
if (-Not (Test-Path $requirementsPath)) {
    @"
django==5.1
psycopg2==2.9.10
environs==11.0.0
"@ | Out-File -FilePath $requirementsPath -Encoding utf8
}


# Install dependencies
if (Test-Path "requirements.txt") {
    pip install -r requirements.txt
} else {
    Write-Output "File 'requirements.txt' not found."
}


# Create Django project
if (-not (Test-Path "manage.py")) {
    django-admin startproject config .
}


# Declare variables
$appName = "core"
$appPath = ".\$appName"

# Check if Django project was created
if (-not (Test-Path $appPath)) {
    # Create Django project
    python manage.py startapp $appName
}


# Create .gitignore
$gitignorePath = ".gitignore"
if (-not (Test-Path $gitignorePath)) {
    @"
# Python
*.py[cod]
__pycache__/
.venv/
env/
venv/
*.env

# Django
*.log
*.pot
*.pyc
db.sqlite3
media/

# IDE
.vscode/
.idea/
"@ | Set-Content -Path $gitignorePath
}

# Определяем путь к файлу и содержимое
$envFilePath = ".env"
$MyRawString = @("SECRET_KEY=''")  # Массив строк, которые нужно записать

# Определяем кодировку UTF8 без BOM
$Utf8NoBomEncoding = New-Object System.Text.UTF8Encoding($false)

# Проверяем, существует ли файл
if (-Not (Test-Path $envFilePath)) {
    # Записываем строки в файл без BOM
    [System.IO.File]::WriteAllLines($envFilePath, $MyRawString, $Utf8NoBomEncoding)
}


# Создание папки templates и пустого файла index.html
$templatesPath = "templates"
if (-Not (Test-Path $templatesPath)) {
    New-Item -ItemType Directory -Path $templatesPath
}

$indexFilePath = "$templatesPath\index.html"
if (-Not (Test-Path $indexFilePath)) {
    # Создание пустого файла index.html
    New-Item -ItemType File -Path $indexFilePath
}


# Создание директории для статических файлов
$staticPath = "static"
if (-Not (Test-Path $staticPath)) {
    New-Item -ItemType Directory -Path $staticPath
}


# Создание подпапок для статики
$staticCssPath = "$staticPath\css"
$staticJsPath = "$staticPath\js"
$staticImagesPath = "$staticPath\images"

if (-Not (Test-Path $staticCssPath)) {
    New-Item -ItemType Directory -Path $staticCssPath
}
if (-Not (Test-Path $staticJsPath)) {
    New-Item -ItemType Directory -Path $staticJsPath
}
if (-Not (Test-Path $staticImagesPath)) {
    New-Item -ItemType Directory -Path $staticImagesPath
}


# Clear console
Clear-Host


Write-Output "Виртуальное окружение установлено и активировано."
Write-Output "Django проект и приложение созданы."
Write-Output "Happy Coding!"