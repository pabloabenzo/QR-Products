# QR_Products_App

## Instrucciones para ejecutar la aplicación.

Aplicación iOS híbrida con UIKit + SwiftUI que permite login manual o con Google. Navega a una vista SwiftUI después de la autenticación.

---

### Requisitos:

- Xcode 15 o superior.
- macOS compatible con Xcode.
- Cuenta de Firebase (para Google Sign-In).
- Simulador o dispositivo iOS (iPhone) real.

---

### Instrucciones de instalación

1. Cloná el repositorio:

   ```bash
   git clone https://github.com/tu_usuario/qr_products.git
   cd qr_products
   ```

2. Abrí el proyecto:

   Abrí `QR_Products.xcodeproj` en Xcode.

---

### Ejecución:

1. Seleccioná un simulador o dispositivo real.
2. Ejecutá con `Cmd + R`.

---

### Credenciales de prueba:

- Usuario: `pbenzo@apple.com`
- Contraseña: `claveSegura123`

---

### Datos de la tarjeta de prueba:

- Número de tarjeta: 4200-2244-2000-2244
- CVV: 182
- Fecha de vencimiento: 12/25
        
---

### Generador de codigos QR para pruebas en productos:

Instrucciones de prueba:

1. Ingresá a la URL:

   - https://www.qr-code-generator.com

2. Ingresá el ID del producto a testear (entre 1 y 10) y escanear el código en la pantalla del producto dentro de la app.

NOTA:
Probar con IDs mayores a 16 para ir por el flujo de error.

---

### Funcionalidades:

- Login manual validado.
- Autocompletado de usuario desde Keychain.
- Login con Google usando Firebase.
- Navegación hacia vista `ChallengeCountryView` al autenticar.

---

### Librerías:

- `KeychainSwift` para persistencia segura.
- `SwiftUI` para integración visual.
- `UIKit` para estructura del controlador.

--------------------------------------------------------------------------------------------------------------------------------------------------

## Conceptos de las ideas implementadas.

El proyecto representa una aplicación iOS híbrida construida con UIKit y SwiftUI, pensada para mostrar conocimientos técnicos sólidos, buenas prácticas de arquitectura y experiencia de usuario fluida.

⸻

1. Arquitectura híbrida UIKit + SwiftUI
    - Se utiliza UIKit como base de control de flujo (UIViewController, navegación, gestión de eventos).
    - Las vistas se modernizan mediante el uso de SwiftUI (CountryView, entre otras), embebidas mediante UIHostingController.
    - Esto permite escalar progresivamente hacia SwiftUI sin abandonar UIKit.

⸻

2. Autenticación segura

> Login manual:
    - El usuario puede ingresar un email y una contraseña predefinidos.
    - Se implementa validación mediante la función isLoginValid().

> Login con Google (OAuth 2.0):
    - Se implementa autenticación con Google utilizando Firebase.
    - Integración con el flujo de autorización de Google, manejo de errores y respuesta asincrónica.
    - Abstracción mediante un LoginInteractor o ChallengeLoginAuth, manteniendo la lógica desacoplada.

⸻

3. Almacenamiento seguro con Keychain
    - Se utiliza KeychainSwift para almacenar el usuario ingresado de forma segura.
    - Esto permite recordar las credenciales entre sesiones sin comprometer seguridad.
    - Implementación de carga automática (preloadUsername()).

⸻

4. Navegación estructurada
    - Navegación entre vistas mediante UINavigationController.
    - Uso de UIHostingController para hacer push de vistas SwiftUI desde UIKit.

⸻

5. Diseño UI y estilo coherente
    - Se centraliza la configuración visual a través de un objeto ChallengeUI, que gestiona colores, fuentes y estilos globales.
    - Componentes como botones (loginButton, googleButton) y campos (UITextField) tienen diseño personalizado con corner radius, padding y colores de tema.

⸻

6. Experiencia de usuario fluida
   - Uso de UIActivityIndicatorView para indicar procesos como login en curso.
   - Gestos para ocultar teclado (UITapGestureRecognizer).
   - Manejo de errores con UIAlertController, proporcionando mensajes claros y traducibles.

⸻

7. Modularidad y escalabilidad
   - Separación de responsabilidades: vistas, lógica de negocio y helpers (como UI o autenticación).
   - Facilita pruebas unitarias o reemplazo de partes (por ejemplo, cambiar Firebase por otro proveedor).

⸻

8. Preparación para testing
   - Lógica como la validación de login o carga de usuario está encapsulada, lo que permite escribir tests fácilmente.
   - La estructura modular permite extender el proyecto (por ejemplo, guardar tokens, manejar sesiones o persistir productos).
   - Test unitario con XCTest que se encarga del llamado al endpoint que recibe los datos de los productos.

⸻

9. Buenas prácticas de Xcode
    - Uso de constraints programáticas para layout flexible.
    - Integración de Swift Package Manager (GoogleSignIn, KeychainSwift).
    - Gestión de assets para íconos (Google, Apple, etc.).

⸻

10. Extensible para features reales

El proyecto está preparado para integrar:
  - Flujos de pago.
  - Decodificación de productos desde APIs (FakeStoreAPI).
  - Escaneo de QR o geolocalización si se requieren.

--------------------------------------------------------------------------------------------------------------------------------------------------

## Puntos de mejoras que se pueden implementar a futuro.

1. Autenticación y Seguridad
   - Si bien ya he implementado Firebase, integrar tokens JWT o Firebase ID tokens para manejar sesiones más seguras y escalables.
   - Cerrar sesión con Google y eliminar datos de Keychain al hacerlo.

3. Internacionalización y accesibilidad
   - Agregar soporte para múltiples idiomas usando Localizable.strings.
   - Agregar soporte para VoiceOver, contraste de colores, y navegación por teclado.

4. Sincronización con backend
   - Conectar con una API real para autenticar usuarios o cargar productos.
   - Implementar manejo de errores de red con mensajes adaptativos (retry, offline, sin conexión).
   - Soporte para paginación o cache de resultados.

5. Otras cosas
   - Agregar login con Apple (Sign in with Apple) u otras plataformas.
   - Incluir notificaciones push o deep linking para mejorar retención (un must).
