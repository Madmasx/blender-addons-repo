# Mis Addons — repo de extensiones para Blender 5.2 LTS

Repo personal de extensiones de Blender, generado a partir de las ya instaladas
localmente. Formato de *Extension Repository* de Blender (4.2+), instalable
desde la UI con **Edit > Preferences > Get Extensions**.

## Contenido

19 extensiones, todas de `extensions.blender.org` y con licencia propia de cada
autor. Este repo solo reempaqueta: los créditos y licencias originales están en
el manifiesto de cada paquete y en los enlaces oficiales.

| Extensión | Versión | Categoría |
|---|---|---|
| Extra Mesh Objects | 0.4.1 | Modelado |
| Bool Tool | 2.1.0 | Modelado |
| Curve Tools | 0.4.6 | Modelado |
| Precision Drawing Tools (PDT) | 1.5.3 | Modelado |
| LoopTools | 4.7.7 | Modelado |
| Node To Python | 4.2.0 | Nodos |
| Node Arrange | 1.12.1 | Nodos |
| Copy/Paste Nodes | 0.1.6 | Nodos |
| Glare Node Controller | 2.3.3 | Nodos / Shading |
| AmbientCG Material Importer | 1.5.0 | Materiales |
| Anim Reviewer | 1.1.3 | Animación |
| AnimAll | 0.14.0 | Animación |
| Easeit | 2.0.3 | Animación |
| Motion Style (blender_speed_curve) | 1.0.2 | Animación |
| Power Sequencer | 2.0.4 | Flujo de trabajo |
| Monty Batch Exporter | 1.0.0 | Flujo de trabajo |
| NDOF Viewport Switcher | 1.3.4 | Flujo de trabajo |
| Context Pie | 0.9.51 | Interfaz |
| Render Animated .GIF | 1.7.0 | Render |

### No incluidos (ya vienen con Blender)

`rigify` y `node_wrangler` viven en `scripts/addons_core/` y se activan desde
Preferencias; no son extensiones descargables, por eso no se reempaquetan.

## Estructura

```
blender-addons-repo/
├── packages/            <- el repo de extensiones (esto es lo que se sube)
│   ├── *.zip            <- 19 paquetes
│   ├── index.json       <- índice, generado por Blender
│   └── index.html       <- página web para navegarlo
├── source/              <- copia editable (fuera de git, ver .gitignore)
├── blender_repo.toml    <- nombre/descripción del repo + blocklist
└── README.md
```

## Usar el repo

### En local (ya registrado)

```powershell
blender --command extension sync
blender --command extension install bool_tool -e
```

En la UI: **Edit > Preferences > Get Extensions > *Mis Addons***.

### Volver a registrar tras clonar

```powershell
blender --command extension repo-add mis_addons --name "Mis Addons" `
  --url "file:///<ruta-absoluta>/blender-addons-repo/packages"
```

### Servirlo por HTTP

`packages/` es estático, así que cualquier servidor vale:

```powershell
python -m http.server 8000
# luego: --url "http://localhost:8000/packages/"
```

## Regenerar un paquete

```powershell
blender --command extension build --source-dir source/<id> --output-dir packages
blender --command extension server-generate --repo-dir packages --repo-config blender_repo.toml --html
```

## Notas importantes

- **`render_gif_animation` ocupa 29.8 de los 33.6 MB** del repo: incluye el wheel
  de `imageio_ffmpeg` para generar los GIF. Es el 89% del peso.
- Su manifiesto quedó **acotado a `windows-x64`** y se le quitó un bloque
  `[build.generated]`. El archivo original declara 4 plataformas pero Blender
  solo descarga el wheel de la plataforma actual, así que el paquete no se podía
  construir. Para una versión multiplataforma hay que añadir los wheels de
  Linux/macOS y devolver la lista completa de `platforms`.
- `blender_repo.toml` **necesita un `blocklist` no vacío**: Blender lo valida con
  `if not blocklist:` y rechaza la lista vacía. Hay una entrada placeholder
  inofensiva; cámbiala por una real si la necesitas.
- Todos los paquetes son válidos para **Blender 5.x** (`blender_version_min`
  4.2.0 o 5.1.0 según el caso).
