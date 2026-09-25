# Aprobado — Marketplace de packs de estudio

Slogan: "De alumnos para alumnos". Proyecto en Perú (Lima). Idioma de la app y del código: español.

## Qué es
Marketplace donde alumnos universitarios que ya aprobaron un curso venden "packs" de estudio
(apuntes, ejercicios resueltos, videos, simulacros) a otros alumnos. Evolucionó de una idea previa
de tutorías (Tutor Express Universitario), que podría integrarse después como venta cruzada.

## Modelo de negocio
- El autor recibe el 70% de cada venta; la plataforma se queda con el 30%.
- Precio por pack entre S/ 5 y S/ 80 (referencia: S/ 18 a S/ 30).
- Competencia principal en Perú: uDocz (gratuito, con puntos "Ucoins"; el autor no cobra dinero).
  Diferenciales: autor cobra dinero real, vendedor verificado con récord de notas, packs curados
  por curso y evaluación, pago local con Yape, reglas legales estrictas.

## Reglas legales (no romperlas)
- Solo contenido propio del autor. Categorías permitidas: apuntes y resúmenes propios, ejercicios
  resueltos por el autor, videos propios, simulacros tipo examen con preguntas propias,
  formularios propios, guías o planes de estudio.
- Prohibido: material del profesor, la universidad o editoriales; evaluaciones del ciclo en curso
  y sus soluciones; enunciados copiados de exámenes pasados; datos personales de terceros.
- El vendedor acepta 6 declaraciones de autoría y adjunta su récord de notas (nota mínima 14).
- Todo pack pasa por revisión antes de publicarse ("En revisión" → "Publicado").
- Botón de denuncia en cada pack; si procede, se retira y se reembolsa.
- Licencia de uso personal para el comprador; marca de agua con su correo; reembolso en 48 horas.
- Libro de Reclamaciones virtual (obligatorio en Perú).
- Las reseñas evalúan el pack, no al profesor.

## Prototipo actual: `aprobado.html`
Un solo archivo HTML con CSS y JavaScript inline, sin backend. Datos en localStorage (clave `aprobado:v1`).
- Explorar: catálogo con búsqueda y filtro por universidad (libre, sin cuenta).
- Detalle del pack: contenido, vista previa gratuita, comprar, denunciar.
- Cuentas: crear cuenta (nombre, correo, universidad, carrera, contraseña) e iniciar sesión.
  Cuenta obligatoria para comprar, vender y ver "Mis packs". Datos separados por usuario.
- Pago: QR de Yape incrustado en base64 (`YAPE_QR`). El comprador ingresa el número de operación
  y opcionalmente la captura; la compra queda "Pago en verificación" hasta confirmación manual.
  Plin y Tarjeta aparecen como "Próximamente".
- Mis packs: compras, pagos en verificación, packs publicados. Visor con marca de agua.
- Vender: formulario en 4 pasos (datos del curso, contenido, verificación de nota, declaración).
- Reglas: políticas, datos personales y Libro de Reclamaciones.
- Diseño: estilo cuaderno cuadriculado, acento resaltador amarillo, tipografías Bricolage Grotesque
  y Atkinson Hyperlegible, modo claro y oscuro, pensado primero para celular.

## Próximo objetivo
Llevar el prototipo a WordPress en LocalWP (gratis, en local), gastando lo mínimo:
- WordPress + WooCommerce.
- Multivendedor gratuito: Dokan Lite, WCFM o MultiVendorX (productos nuevos como "pendientes").
- Yape: método de pago manual de WooCommerce (transferencia bancaria renombrada) con el QR
  y campo para número de operación.
- Tarjetas más adelante: pasarela peruana (Culqi, Izipay o Mercado Pago).
- Plugin peruano gratuito de Libro de Reclamaciones.
- Marca de agua en PDFs: manual al inicio; videos en YouTube no listado o Vimeo privado.
- Recrear el diseño del prototipo con un tema y CSS personalizado.
- Pagar hosting solo al lanzar.
