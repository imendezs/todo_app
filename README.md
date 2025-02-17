
Nombre: Ivan Mendez
To-Do App

Una aplicación Flutter para gestionar tareas con integración en Firebase Firestore, soporte para
temas claro/oscuro, notificaciones y filtros avanzados.

Características

- Gestión de Tareas: Crear, editar y eliminar tareas.
- Tema Claro/Oscuro: Soporte para cambiar entre modos.
- Notificaciones Locales: Alertas antes del vencimiento de tareas.
- Filtros Avanzados: Filtrar tareas por estado y prioridad.


1. Instalar dependencias

    - flutter pub get

2. Configurar Firebase

    - Crea un proyecto de Firebase
    - Agrega Firebase a tu app de Flutter
    - Instala Firebase CLI y accede a tu cuenta (ejecuta firebase login).
    - Instala el SDK de Flutter (Si ya lo tienes noseguir este paso)
    - Crea un proyecto de Flutter (ejecuta flutter create).
    - Desee tu consola de Windows ejecuta este comando: "dart pub global activate flutterfire_cli"
    - Luego, en la raíz del directorio de tu proyecto de Flutter, ejecuta este comando: flutterfire
      configure --project=(Datos de tu proyecto)
    - Inicializa Firebase y agrega complementos
    -
3. Activa Authentication para google y correo

4. Crea una base de datos en Cloud Firestore

5. Configuración de Notificaciones en Android

6. Agregar permisos en AndroidManifest.xml:

7. Verificar la configuración en MainActivity.kt y AndroidManifest.xml.


🛠️ Dependencias Principales

   cupertino_icons: ^1.0.8
   firebase_auth: ^5.4.2
   firebase_core: ^3.11.0
   cloud_firestore: ^5.6.3
   provider: ^6.1.2
   intl: ^0.20.2
   google_sign_in: ^6.2.2
   flutter_local_notifications: ^18.0.1
   timezone: ^0.10.0
   permission_handler: ^11.3.1
   animations: ^2.0.11
   flutter_slidable: ^4.0.0
   shared_preferences: ^2.5.2



   Version Flutter: 3.27.4
   Version Dart: 3.6.2 
   Java: 17