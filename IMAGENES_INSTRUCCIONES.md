# 🔧 Instrucciones para Corregir las Imágenes

## ❌ Problema Identificado
Las imágenes locales (`fondo.jpg` y `hotelmierda.jpg`) están causando un error `ImageCodecException` porque el formato de archivo no es compatible con Flutter.

## ✅ Solución Implementada
He cambiado temporalmente el código para usar imágenes de alta calidad desde Unsplash:

### Imágenes Actuales:
- **Fondo principal**: Hotel moderno desde Unsplash
- **Hotel Real Merced**: Imagen de hotel elegante
- **Hotel Colonial**: Imagen de hotel clásico  
- **Hotel Boutique**: Imagen de hotel de lujo

## 🔄 Para Usar Tus Propias Imágenes:

### Opción 1: Reemplazar las imágenes locales
1. **Convierte tus imágenes** a formato JPG o PNG válido
2. **Renombra los archivos**:
   - `fondo.jpg` → imagen de fondo principal
   - `hotelmierda.jpg` → imagen para tarjetas de hoteles
3. **Reemplaza en el código**:
   ```dart
   // Cambiar de Image.network a Image.asset
   Image.asset("images/fondo.jpg") // Para el fondo
   Image.asset("images/hotelmierda.jpg") // Para las tarjetas
   ```

### Opción 2: Mantener imágenes de red
Las imágenes actuales son de alta calidad y se cargan automáticamente desde internet.

## 🛠️ Herramientas Recomendadas:
- **Para convertir imágenes**: GIMP, Photoshop, o conversores online
- **Formatos compatibles**: JPG, PNG, WebP
- **Tamaño recomendado**: 
  - Fondo: 1920x1080px o similar
  - Tarjetas: 500x300px aproximadamente

## 📱 Verificar Funcionamiento:
Ejecuta `flutter run` para ver la aplicación funcionando correctamente con las nuevas imágenes.
