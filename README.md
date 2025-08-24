# 🚛 Lorry Mobile App

Aplicación móvil de Lorry

## 📋 Requisitos Previos

- **Flutter SDK**: `>=3.6.1`
- **Dart SDK**: `>=3.6.1`
- **Android Studio** o **VS Code** con extensiones de Flutter
- **Git**
- **Dispositivo Android** o **Emulador Android**

## 🚀 Instalación

### 1. Clonar el repositorio
```bash
git clone <repository-url>
cd lorry_app_mobile
```

### 2. Instalar dependencias
```bash
flutter pub get
```

### 3. Configurar variables de entorno

Crea los archivos de configuración para cada entorno en `lib/config/env/`:

#### `lib/config/env/.env.dev` (Desarrollo local)
```env
URL_BASE=http://tu-ip-local:8000
API_KEY=dev_key_12345
APP_NAME=Lorry Dev
DEBUG_MODE=true
```

#### `lib/config/env/.env.qa` (Testing/QA)
```env
URL_BASE=http://servidor-qa:8000
API_KEY=qa_key_67890
APP_NAME=Lorry QA
DEBUG_MODE=false
```

#### `lib/config/env/.env.prod` (Producción)
```env
URL_BASE=https://api.lorry.com
API_KEY=prod_key_secret
APP_NAME=Lorry
DEBUG_MODE=false
```

> ⚠️ **Importante**: Estos archivos `.env.*` están en `lib/config/env/` y NO se suben al repositorio por seguridad.

### 4. Verificar instalación
```bash
flutter doctor
```

## 🏗️ Estructura del Proyecto

```
lorry_app_mobile/
├── android/                    # Configuración Android con Flavors
│   ├── app/
│   │   ├── build.gradle       # Configuración de flavors (dev/qa/prod)
│   │   └── src/
│   │       └── main/
│   │           └── AndroidManifest.xml
├── assets/                     # Recursos estáticos
│   ├── truckimage.jpeg
│   └── icons/                 # Iconos SVG y PNG
│       ├── Add_image.svg
│       ├── Alert_Icon.jpg
│       └── Icon_App.png
├── lib/                       # Código fuente principal
│   ├── main.dart             # Punto de entrada con detección de flavors
│   ├── config/               # Configuraciones
│   │   ├── app_config.dart   # Configuración de flavors y entornos
│   │   ├── constants.dart    # Constantes globales
│   │   ├── app_theme.dart    # Temas y configuraciones UI
│   │   ├── config.dart       # Archivo indexado de configucariones
│   │   └── env/              # Variables de entorno
│   │       ├── .env.dev      # Configuración desarrollo (NO subir)
│   │       ├── .env.qa       # Configuración QA (NO subir)
│   │       ├── .env.prod     # Configuración producción (NO subir)
│   │       └── .env.example  # Template de variables de entorno
│   ├── models/               # Modelos de datos
│   ├── providers/            # Estado global (Riverpod)
│   ├── screens/              # Pantallas de la aplicación
│   ├── services/             # Servicios API y lógica de negocio
│   │   └── MainService.dart  # Servicio HTTP principal
│   └── widgets/              # Componentes reutilizables
├── .vscode/
│   └── launch.json           # Configuraciones de debug para VS Code
└── pubspec.yaml              # Dependencias y assets
```

## 🎯 Entornos y Flavors

La aplicación soporta 3 entornos diferentes:

| Entorno | Flavor | Nombre App | Package ID | Descripción |
|---------|--------|------------|------------|-------------|
| **DEV** | `dev` | "Lorry Dev" | `com.example.app_lorry.dev` | Desarrollo local |
| **QA** | `qa` | "Lorry QA" | `com.example.app_lorry.qa` | Testing/QA |
| **PROD** | `prod` | "Lorry" | `com.example.app_lorry` | Producción |

## ⚡ Comandos de Ejecución

### Desarrollo (DEV)
```bash
# Ejecutar en modo desarrollo
flutter run --flavor dev --dart-define=FLAVOR=dev

# Build APK desarrollo
flutter build apk --flavor dev --dart-define=FLAVOR=dev
```

### QA/Testing
```bash
# Ejecutar en modo QA
flutter run --flavor qa --dart-define=FLAVOR=qa

# Build APK QA
flutter build apk --flavor qa --dart-define=FLAVOR=qa
```

### Producción
```bash
# Ejecutar en modo producción
flutter run --flavor prod --dart-define=FLAVOR=prod

# Build APK producción
flutter build apk --release --flavor prod --dart-define=FLAVOR=prod

# Build App Bundle para Play Store
flutter build appbundle --release --flavor prod --dart-define=FLAVOR=prod
```

## 🐛 Debug en VS Code

### Configuración automática
1. Abre el proyecto en **VS Code**
2. Ve al panel de **Debug** (`Ctrl+Shift+D`)
3. Selecciona una configuración:
   - 🔴 **Dev (Android Debug)**
   - 🟡 **QA (Android Debug)**
   - 🟢 **Prod (Android Debug)**
4. Presiona **F5** o click en ▶️

### Debug manual
```bash
# Conectar dispositivo Android y ejecutar:
flutter run --debug --flavor dev --dart-define=FLAVOR=dev
```

## 🛠️ Comandos Útiles

### Limpieza y rebuild
```bash
# Limpiar build cache
flutter clean

# Reinstalar dependencias
flutter pub get

# Rebuild completo
flutter clean && flutter pub get && flutter run --flavor dev --dart-define=FLAVOR=dev
```

### Generar íconos
```bash
# Generar íconos para la app
dart run flutter_launcher_icons:main
```

### Verificar configuración
```bash
# Verificar instalación Flutter
flutter doctor

# Verificar dispositivos conectados
flutter devices

# Ver información de build
flutter build apk --flavor dev --dart-define=FLAVOR=dev --verbose
```

## 📦 Dependencias Principales

| Paquete | Versión | Descripción |
|---------|---------|-------------|
| `flutter_riverpod` | ^2.5.1 | Gestión de estado |
| `go_router` | ^14.8.0 | Navegación |
| `flutter_dotenv` | ^5.1.0 | Variables de entorno |
| `http` | latest | Peticiones HTTP |
| `flutter_secure_storage` | ^9.0.0 | Almacenamiento seguro |
| `google_fonts` | ^6.1.0 | Fuentes personalizadas |
| `permission_handler` | ^11.3.0 | Manejo de permisos |

## 🔧 Configuración de Desarrollo

### Primer setup para nuevos desarrolladores:

1. **Clonar el repositorio**
2. **Crear carpeta para variables de entorno:**
   ```bash
   mkdir -p lib/config/env
   ```
3. **Copiar template de variables de entorno:**
   ```bash
   cp lib/config/env/.env.example lib/config/env/.env.dev
   ```
4. **Editar `lib/config/env/.env.dev`** con tu configuración local
5. **Instalar dependencias:**
   ```bash
   flutter pub get
   ```
6. **Ejecutar en modo desarrollo:**
   ```bash
   flutter run --flavor dev --dart-define=FLAVOR=dev
   ```

### Variables de entorno requeridas:
- `URL_BASE`: URL del backend API
- `APP_NAME`: Nombre de la aplicación
- `DEBUG_MODE`: Modo debug (true/false)

## 🔐 Seguridad

- ✅ Variables sensibles en archivos `lib/config/env/.env.*` (excluidos del repositorio)
- ✅ Diferentes configuraciones por entorno
- ✅ Keys de API no hardcodeadas en el código
- ✅ Flavors para separar builds de desarrollo y producción

## 🚨 Troubleshooting

### Error de Gradle
```bash
# Si hay problemas con Gradle flavors
flutter clean
cd android && ./gradlew clean && cd ..
flutter run --flavor dev --dart-define=FLAVOR=dev
```

### Error de dependencias
```bash
flutter pub cache clean
flutter clean
flutter pub get
```

### Error de permisos Android
- Verificar que el dispositivo tenga **Depuración USB** habilitada
- Verificar que el dispositivo esté autorizado: `flutter devices`

---

**Versión Flutter:** 3.6.1+  
**Última actualización:** Agosto 2025