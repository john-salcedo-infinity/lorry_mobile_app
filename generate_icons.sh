#!/bin/bash

echo "Generando iconos para DEV..."
flutter pub get
flutter packages pub run flutter_launcher_icons:main -f flutter_launcher_icons-dev.yaml

echo "Generando iconos para QA..."
flutter packages pub run flutter_launcher_icons:main -f flutter_launcher_icons-qa.yaml

echo "Generando iconos para PROD..."
flutter packages pub run flutter_launcher_icons:main -f flutter_launcher_icons-prod.yaml

echo "¡Iconos generados para todos los entornos!"