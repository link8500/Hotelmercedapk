# Comandos Git para Subir Cambios a GitHub

## Estado Actual
✅ **Commit realizado exitosamente**
- 42 archivos modificados/agregados
- 3860 líneas agregadas
- Cambios listos para push

## Comando para Hacer Push

```bash
git push origin main
```

## Si Necesitas Autenticarte

### Opción 1: Usar Personal Access Token (Recomendado)

1. Crear un token en GitHub:
   - Ve a: https://github.com/settings/tokens
   - Click en "Generate new token (classic)"
   - Selecciona el scope `repo` (acceso completo a repositorios)
   - Copia el token generado

2. Cuando ejecutes `git push origin main`:
   - Username: `link8500` (tu usuario de GitHub)
   - Password: **Pega tu Personal Access Token** (NO tu contraseña de GitHub)

### Opción 2: Cambiar a SSH (Alternativa)

```bash
# Cambiar remote a SSH
git remote set-url origin git@github.com:link8500/Hotelmercedapk.git

# Luego hacer push
git push origin main
```

## Comandos Completos (Si Necesitas Empezar de Nuevo)

```bash
# Ver estado
git status

# Agregar todos los cambios
git add .

# Hacer commit
git commit -m "feat: Integración de Supabase Auth y Dashboard de Administrador"

# Hacer push
git push origin main
```

## Verificar que .env NO se suba

El archivo `.env` está correctamente en `.gitignore` y NO se subirá a GitHub.

## Nota Importante

El commit ya está realizado localmente. Solo necesitas autenticarte correctamente para hacer el push.


