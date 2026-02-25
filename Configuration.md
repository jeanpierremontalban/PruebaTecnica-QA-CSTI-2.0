# Configuración de Autenticación para GitHub Packages

## 1. Crear Personal Access Token

1. Ve a **GitHub Enterprise** → **Settings** → **Developer settings** → **Personal access tokens** → **Tokens (classic)**
2. Crea un nuevo token con estos permisos:
   - `write:packages` (para publicar packages)
   - `read:packages` (para descargar packages)
   - `repo` (si es repositorio privado)
3. Selecciona la opción **Configure SSO** y autoriza la organización `PS-Artifactory`
4. **Importante**: Copia y guarda el token de forma segura, no podrás verlo nuevamente

## 2. Configurar Maven settings.xml

### Para Mac/Linux:
Edita el archivo `~/.m2/settings.xml`:

```bash
mkdir -p ~/.m2
nano ~/.m2/settings.xml
```

### Para Windows:
Edita el archivo `%USERPROFILE%\.m2\settings.xml` siguiendo estos pasos detallados:

1. Abre el explorador de archivos y navega a tu carpeta de usuario (usualmente `C:\Usuarios\<tu_usuario>`).
2. Verifica si existe la carpeta `.m2`. Si no existe, créala:
    - Haz clic derecho en el área vacía y selecciona "Nuevo > Carpeta".
    - Nombra la carpeta como `.m2` (incluye el punto al inicio).
3. Dentro de la carpeta `.m2`, crea un archivo llamado `settings.xml`:
    - Haz clic derecho en la carpeta `.m2` y selecciona "Nuevo > Documento de texto".
    - Nombra el archivo como `settings.xml` (elimina la extensión `.txt` si aparece).
4. Abre el archivo `settings.xml` con el Bloc de notas:
    - Haz clic derecho sobre el archivo y selecciona "Editar" o "Abrir con > Bloc de notas".
5. Copia y pega el contenido de configuración proporcionado en este documento.
6. Guarda los cambios y cierra el Bloc de notas.

## 3. Contenido del archivo settings.xml

```xml
<?xml version="1.0" encoding="UTF-8"?>
<settings xmlns="http://maven.apache.org/SETTINGS/1.0.0"
          xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
          xsi:schemaLocation="http://maven.apache.org/SETTINGS/1.0.0 
          http://maven.apache.org/xsd/settings-1.0.0.xsd">

    <servers>
        <server>
            <id>github</id>
            <username>TU_USUARIO_GITHUB</username>
            <password>TU_TOKEN_PERSONAL</password>
        </server>
    </servers>

    <profiles>
        <profile>
            <id>github</id>
            <repositories>
                <repository>
                    <id>github</id>
                    <name>GitHub Packages</name>
                    <url>https://maven.pkg.github.com/PS-Artifactory/automation-qa-utils</url>
                    <releases>
                        <enabled>true</enabled>
                    </releases>
                    <snapshots>
                        <enabled>true</enabled>
                    </snapshots>
                </repository>
            </repositories>
        </profile>
    </profiles>

    <activeProfiles>
        <activeProfile>github</activeProfile>
    </activeProfiles>

</settings>
```

## 4. Verificar la configuración

### Verificar ubicación del archivo settings.xml:

**Mac/Linux:**
```bash
ls -la ~/.m2/settings.xml
```

**Windows:**
```cmd
dir %USERPROFILE%\.m2\settings.xml
```

### Verificar conectividad con GitHub Packages:

```bash
mvn dependency:resolve -U
```

## 5. Usar el package en tu proyecto

Agrega la dependencia en tu `pom.xml`:

```xml
<dependency>
    <groupId>com.pacifico</groupId>
    <artifactId>automation-qa-utils</artifactId>
    <version>1.0.0</version>
</dependency>
```

## 6. Solución de problemas comunes

### Error de autenticación:
- Verifica que el token tenga los permisos correctos
- Asegúrate de que el SSO esté configurado para la organización
- Verifica que el username en settings.xml sea correcto

### Error 404 Not Found:
- Verifica que el package exista en la organización
- Confirma que tienes acceso al repositorio donde está el package

### Limpiar caché de Maven (si hay problemas):

**Mac/Linux:**
```bash
rm -rf ~/.m2/repository
```

**Windows:**
```cmd
rmdir /s %USERPROFILE%\.m2\repository
```

## 7. Variables de entorno alternativas (opcional)

Como alternativa al archivo settings.xml, puedes usar variables de entorno:

**Mac/Linux:**
```bash
export GITHUB_TOKEN=tu_token_personal
export GITHUB_ACTOR=tu_usuario_github
```

**Windows:**
```cmd
set GITHUB_TOKEN=tu_token_personal
set GITHUB_ACTOR=tu_usuario_github
```

Y referenciarlas en settings.xml:
```xml
<username>${env.GITHUB_ACTOR}</username>
<password>${env.GITHUB_TOKEN}</password>
```