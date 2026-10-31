# Seguridad

## Versiones que se mantienen

Solo la última versión publicada (y `main`) recibe correcciones. Mientras Tesela esté en 0.x no hay ramas de
mantenimiento de versiones anteriores.

| Versión | Con correcciones |
|---|---|
| La última 0.x | Sí |
| Anteriores | No |

## Avisar de un fallo

No abras un issue público. Usa el aviso privado de GitHub: en la pestaña **Security** del repositorio,
**Report a vulnerability**
([enlace directo](https://github.com/rododendro1/Tesela/security/advisories/new)).

Cuenta qué paquete o app está afectado, en qué versión y plataforma, y cómo reproducirlo. Lo más delicado es lo
que lee ficheros de fuera: la importación de MIDI y MusicXML, los teclados en formato UIL y el dibujo en SVG. Un
fichero que cuelgue la app o le haga gastar memoria sin límite también cuenta.

## Qué esperar

- Una primera respuesta en una semana.
- Si se confirma, una corrección en una versión nueva y un aviso de seguridad en GitHub que te nombre, si quieres.
- Si no se considera un fallo de seguridad, una explicación de por qué, y se pasa a un issue normal si hace falta.
