# Guía de Uso del Framework Karate
## Requisitos y configuración previa

Antes de ejecutar el proyecto, asegúrate de cumplir con los siguientes requisitos y pasos de configuración:

### 1. Requisitos previos

- Tener instalado Java 17.
- Tener instalado Maven.
- Acceso a la red de la organización (si aplica restricciones de red).
- Acceso a GitHub con permisos para descargar paquetes privados.

### 2. Configuración de acceso a paquetes privados

El archivo `Configuration.md` contiene las instrucciones para configurar el acceso y autenticación a los paquetes privados alojados en el GitHub de la organización. Sigue estos pasos:

1. Abre el archivo `Configuration.md` y sigue las instrucciones para generar un token personal de GitHub.
2. Configura tu archivo `settings.xml` de Maven (usualmente en `~/.m2/settings.xml`) agregando el servidor y el token como se indica en `Configuration.md`.
3. Verifica que puedes descargar dependencias privadas ejecutando:
    ```bash
    mvn clean install
    ```

> [!IMPORTANT]
> Para más inforrmación visita el [Manual de configuración](/Configuration.md)

### 3. Configuración de propiedades y secretos

Revisa y ajusta los archivos en el directorio `config/` según el entorno que vayas a utilizar (`integracion`, `certificacion`, etc.). Estos archivos contienen los secretos y propiedades necesarias para la ejecución de pruebas.

### 4. Ejecución del proyecto

Para ejecutar las pruebas, utiliza los comandos indicados en la sección "Ejecución de Pruebas" de este README. Por ejemplo:
```bash
mvn test -Dkarate.options="--tags @TokenTest" -Dkarate.env="certificacion"
```

Si necesitas subir resultados a QMetry, revisa la sección correspondiente y configura los parámetros en `config.properties`.

---

Este proyecto utiliza el framework Karate para pruebas de API. El proyecto está estructurado en Java, JavaScript y Maven.

> [!IMPORTANT]
> Repositorio del Framework de Pruebas Automatizadas BE - Karate :link: [link](https://github.com/pacifico-seguros-org/frameworkpruebasautomatizadas-be-pilotokarate)

> [!NOTE]
> :movie_camera: Capacitación Framework Automatización BE - Karate :link: [link](https://pacificocia.sharepoint.com/:v:/r/sites/teamqa/Shared%20Documents/General/Gesti%C3%B3n%20de%20Conocimientos/Automatizaci%C3%B3n/Automatizaci%C3%B3n%20BE/Framework%20Karate/Introducci%C3%B3n%20Framework%20BE%20(Karate).mp4?csf=1&web=1&e=W9qIc4)

> [!TIP]
> Usa Copilot [aqui](https://github.com/Wiki-Pacifico/DevSecOps-PGA/wiki/GENAI-%E2%80%90-Copilot-QA-Backend) el manual.

## Estructura del Proyecto

La estructura actual del proyecto es la siguiente:

```txt
frameworkpruebasautomatizadas-be-pilotokarate/
├── Configuration.md.                       # Documentación adicional de configuración del framework.
├── pom.xml.                                # Archivo de configuración de Maven con dependencias del proyecto.
├── README.md                               # Documentación principal del proyecto con instrucciones de uso.
├── config/.                                # Archivos de configuración de secretos y ejemplos de propiedades.
│   ├── certification-secrets.properties
│   ├── example.properties
│   └── integracion-secrets.properties
├── src/
│   └── test/
│       └── java/
│           ├── config.properties           # Propiedades generales de configuración para ejecución de pruebas.
│           ├── karate-config.js            # Configuración de entornos (integración, certificación, producción)
│           ├── logback-test.xml            # Configuración de logs para pruebas. 
│           ├── karate/
│           │   ├── runner/
│           │   │   └── TestRunner.java     # Para ejecutar las pruebas. 
│           │   └── util/                   # Clases utilitarias para soporte en pruebas.
│           └── resources/
│               ├── features/               # Archivos .feature que definen los escenarios de prueba en formato Gherkin.
│               │   ├── Request.feature
│               │   └── Token.feature
│               └── request/                # Archivos JSON para datos de entrada o esquemas.
│                   └── Resource.json

```

## Configuración de entornos

  En el archivo `karate-config.js` se encuentran las configuraciones de los entornos de integración, certificación y producción.


```javascript
ENVIRONMENTS = {
  ambiente: {
    keyvault: "URL del Key Vault",
    secretFile: "archivo local de secretos", 
    secrets: {
      clientSecret: "nombre del secreto",
      subscriptionKey: "nombre de la clave"
    },
    api: {
      baseUrl: "URL base de la API",
      path: "ruta del servicio",
      version: "versión"
    },
    auth: {
      // configuración de autenticación
    }
  }
}
```

## 🔧 Agregar nuevo ambiente

Para agregar un nuevo ambiente (ej: `produccion`):

1. Copia la configuración de `certificacion`
2. Cambia los valores específicos del nuevo ambiente
3. Crea el archivo de secretos correspondiente en `/config/`

```javascript
produccion: {
  keyvault: 'https://nuevo-keyvault.vault.azure.net/',
  secretFile: 'config/produccion-secrets.properties',
  secrets: {
    clientSecret: 'nuevo-client-secret',
    subscriptionKey: 'nueva-subscription-key'
  },
  // ... resto de configuración
}
```

## Ejecución de Pruebas

Los escenarios de prueba se definen en los archivos `.feature` en el directorio `src/test/java/resources/features`. Cada escenario está etiquetado con una etiqueta única para su fácil identificación y ejecución.

Por ejemplo, para ejecutar el escenario de prueba etiquetado con `@TokenTest`, use el siguiente comando:

Para Windows/Linux/Mac:

```bash
# Ejecución por Tags
mvn test -Dkarate.options="--tags @TokenTest"

# Ejecución por Tags Windows
mvn test --% -Dkarate.options="--tags @TokenTest"

# Ejecución por entornos
mvn test -Dkarate.options="--tags @TokenTest" -Dkarate.env="certificacion"

# Ejecución y subida a qmetry 
mvn test -Dkarate.options="--tags @TokenTest" -Dkarate.task="TEST-2208"
```

> [!NOTE]
> Para usuarios de Windows que utilicen PowerShell como terminal, se recomienda el uso de `--%`.  
> En caso contrario, se sugiere utilizar el CMD para evitar problemas con el manejo de parámetros.

## Cucumber Uploader

```bash
mvn test -Dkarate.task="<IssueId>"
```

Para ejecutar el ciclo de pruebas en QMetry, es necesario configurar los parámetros en el archivo `config.properties` y establecer ciertas opciones en la consola.

| Campos                                                                   | Descricón                                                                | Por Defecto |
| ------------------------------------------------------------------------ | ------------------------------------------------------------------------ | ----------- |
| [APIKEY](https://id.atlassian.com/manage-profile/security/api-tokens)    | Token de acceso a Jira                                                   | -           |
| EMAIL                                                                    | Correo asociado a su cuenta de Jira                                      | -           |
| [ACCOUNT_ID](https://innovacionpacifico.atlassian.net/rest/api/3/myself) | ID del su perfil en Jira                                                 | -           |
| PROJECT_ID                                                               | Indicar el ID del project en JIRA                                        | -           |
| COMPONENT                                                                | Nombre del componente (API/Microservicio)                                | -           |
| QUARTER                                                                  | Indicar el quarter actual a trabajar                                     | Q1          |
| SPRINT                                                                   | Nombre exacto del sprint en Jira                                         | Sprint 1    |
| SQUAD                                                                    | Nombre del equipo asignado                                               | -           |
| AMBIENTE                                                                 | Ambiente de ejecución (opciones: Integration, Certification, Production) | Integration |
| PRIORITY                                                                 | Prioridad del ciclo                                                      | Medium      |

> [!NOTE]
> - Si un campo tiene un valor por defecto y no necesitas modificarlo, no es necesario incluirlo en config.properties.
> - Define un campo solo si deseas personalizar su valor (ejemplo: cambiar "Q1" por "Q2").
> - Incluir un campo con su valor por defecto no afecta la funcionalidad, pero es innecesario.
> - Si usas una versión inferior a **2.1.1**, se recomienda copiar todo el directorio Utils, actualizar TestRunner y copiar config.properties.

Si deseas solo ejecutar la subida de los resultados, agrega el siguiente codigo en TestRunner.
```java
@Test
void uploader() {
    File file = new File("./target/karate-reports/cucumber.json");
    try {
        String cucumberJson = new String(Files.readAllBytes(file.toPath()));
        new Uploader(cucumberJson);
    } catch (Exception e) {
        throw new Error("[ERROR] "+e.getMessage());
    }
}
```

> [!IMPORTANT]
> Asegúrate de ejecutar el comando correcto según tu necesidad, ya que puede variar:

```bash
# Ejecutar pruebas
mvn -Dtest=TestRunner#testParallel test <OTHER-OPTIONS>

# Ejecutar la subida unicamente
mvn -Dtest=TestRunner#uploader test -Dkarate.task="TEST-2208"
```

## Requerido en Github

Al subir tu automatización al repositorio correspondiente, asegúrate de:

1. Eliminar o dejar vacío los campos APIKEY y EMAIL en config.properties.

> [!WARNING]
> Si no cumples con estas reglas, tu Pull Request no será aprobado para master. 🚀