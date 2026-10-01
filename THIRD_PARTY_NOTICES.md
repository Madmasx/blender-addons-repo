# Third-party notices

Este repositorio **no contiene código original**: solo reempaqueta, sin
modificar, 20 extensiones publicadas en [extensions.blender.org](https://extensions.blender.org/).
Cada autor conserva la titularidad y la licencia de su obra.

Los paquetes de `packages/` son copias sin modificar de las extensiones
oficiales, salvo `render_gif_animation`, cuyo manifiesto se corrigió para poder
empaquetarlo (ver la sección de notas del README).

## Licencias

Las 20 extensiones son software libre copyleft:

| Licencia | Extensiones |
|---|---|
| `GPL-3.0-or-later` | ambientcg_material_importer, anim_reviewer, animall, batch_exporter, blender_speed_curve, bool_tool, ContextPie, copy_paste_nodes, easeit, extra_mesh_objects, glare_node_controller, node_arrange, node_to_python, power_sequencer, quicksnap, render_gif_animation |
| `GPL-2.0-or-later` | curve_tools, looptools, precision_drawing_tools_pdt |

Textos completos en [`licenses/`](./licenses):

- [`licenses/GPL-2.0-or-later.txt`](./licenses/GPL-2.0-or-later.txt)
- [`licenses/GPL-3.0-or-later.txt`](./licenses/GPL-3.0-or-later.txt)

**Sobre los paquetes sin archivo de licencia:** 15 de los 20 paquetes publicados
en extensions.blender.org no incluyen su fichero `LICENSE` dentro del zip,
aunque declaran GPL en el manifiesto. Para que esta redistribución cumpla los
apartados (a) y (b) de la GPL —acompañar el trabajo con la licencia y con el
código fuente— los textos completos están en `licenses/` y el código fuente
completo de cada extensión está dentro de su propio paquete `.zip`.

QuickSnap sí incluye su `LICENSE.md` dentro del paquete.

## Atribución

| Extensión | Versión | Licencia | Autor / mantenedor | Upstream |
|---|---|---|---|---|
| AmbientCG Material Importer | 1.5.0 | GPL-3.0-or-later | Nino Filiu | [github.com/ninofiliu/blender-ambientcg-addon](https://github.com/ninofiliu/blender-ambientcg-addon) |
| Anim Reviewer | 1.1.3 | GPL-3.0-or-later | FhyTan | [github.com/FhyTan/blender-anim-reviewer](https://github.com/FhyTan/blender-anim-reviewer) |
| AnimAll | 0.14.0 | GPL-3.0-or-later | Damien Picard | [projects.blender.org/extensions/animation_animall](https://projects.blender.org/extensions/animation_animall) |
| Monty Batch Exporter | 1.0.0 | GPL-3.0-or-later | Diego Montañar | [github.com/montyanim/ProjectC](https://github.com/montyanim/ProjectC) |
| Motion Style | 1.0.2 | GPL-3.0-or-later | Willy_work | extensions.blender.org |
| Bool Tool | 2.1.0 | GPL-3.0-or-later | Nika Kutsniashvili | [nickberckley.github.io/bool_tool](https://nickberckley.github.io/bool_tool/) |
| Context Pie | 0.9.51 | GPL-3.0-or-later | Bastian L Strube | [github.com/bastianlstrube/ContextPie](https://github.com/bastianlstrube/ContextPie) |
| Copy/Paste Nodes | 0.1.6 | GPL-3.0-or-later | David Murmann | [github.com/davidm494/blender_addons](https://github.com/davidm494/blender_addons) |
| Curve Tools | 0.4.6 | GPL-2.0-or-later | Comunidad (Blender Studio) | [projects.blender.org/extensions/curve_tools](https://projects.blender.org/extensions/curve_tools) |
| Easeit | 2.0.3 | GPL-3.0-or-later | Andy Cuccaro | [github.com/andycuccaro/easeit-addon](https://github.com/andycuccaro/easeit-addon) |
| Extra Mesh Objects | 0.4.1 | GPL-3.0-or-later | Comunidad (Blender Studio) | [projects.blender.org/extensions/add_mesh_extra_objects](https://projects.blender.org/extensions/add_mesh_extra_objects) |
| Glare Node Controller | 2.3.3 | GPL-3.0-or-later | darkstarrd | extensions.blender.org |
| LoopTools | 4.7.7 | GPL-2.0-or-later | Comunidad (Blender Studio) | [projects.blender.org/extensions/mesh_looptools](https://projects.blender.org/extensions/mesh_looptools) |
| NDOF Viewport Switcher | 1.3.4 | GPL-3.0-or-later | ChrisP | [github.com/ChrisPZone/blender-ndof-viewport-switcher](https://github.com/ChrisPZone/blender-ndof-viewport-switcher) |
| Node Arrange | 1.12.1 | GPL-3.0-or-later | Leonardo Pike-Excell | [github.com/Leonardo-Pike-Excell/node-arrange](https://github.com/Leonardo-Pike-Excell/node-arrange) |
| Node To Python | 4.2.0 | GPL-3.0-or-later | Brendan Parmer | [github.com/BrendanParmer/NodeToPython](https://github.com/BrendanParmer/NodeToPython) |
| Power Sequencer | 2.0.4 | GPL-3.0-or-later | Comunidad (Blender Studio) | [projects.blender.org/extensions/power_sequencer](https://projects.blender.org/extensions/power_sequencer) |
| Precision Drawing Tools (PDT) | 1.5.3 | GPL-2.0-or-later | Comunidad (Blender Studio) | [projects.blender.org/extensions/precision_drawing_tools](https://projects.blender.org/extensions/precision_drawing_tools) |
| QuickSnap | 1.5.1 | GPL-3.0-or-later | Julien Heijmans | [github.com/JulienHeijmans/quicksnap](https://github.com/JulienHeijmans/quicksnap) |
| Render Animated .GIF | 1.7.0 | GPL-3.0-or-later | byebyeLAN | [extensions.blender.org/add-ons/render-gif-animation](https://extensions.blender.org/add-ons/render-gif-animation/) |

## Dependencia de terceros incluida

`render_gif_animation` empaqueta el wheel de Python
`imageio_ffmpeg-0.6.0-py3-none-win_amd64.whl`, que a su vez incluye binarios de
FFmpeg con licencia GPL/LGPL. Licencia declarada en el manifiesto de
`imageio_ffmpeg`: BSD-2-Clause para el wrapper, y FFmpeg bajo GPL-2.0-or-later
o LGPL-2.1-or-later según el build.

## Addons de Blender NO incluidos

`rigify` y `node_wrangler` se distribuyen dentro del propio Blender
(`scripts/addons_core/`) y no son extensiones descargables, por lo que no se
reempaquetan aquí.
