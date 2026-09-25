-- Aprobado: esquema de base de datos
-- Pegar en Supabase SQL Editor y ejecutar una sola vez.

create table if not exists profiles (
  id uuid primary key default gen_random_uuid(),
  auth_user_id uuid unique references auth.users(id) on delete cascade,
  nombre text not null,
  uni text not null,
  carrera text,
  creado_en timestamptz not null default now()
);

create table if not exists packs (
  id uuid primary key default gen_random_uuid(),
  autor_id uuid not null references profiles(id) on delete cascade,
  titulo text not null,
  curso text not null,
  uni text not null,
  seccion text not null,
  descripcion text not null,
  preview text not null,
  tipos text[] not null,
  precio numeric(6,2) not null check (precio >= 5 and precio <= 80),
  nota int not null check (nota >= 14 and nota <= 20),
  estado text not null default 'revision' check (estado in ('revision','publicado','retirado')),
  rating numeric(2,1) not null default 0,
  resenas int not null default 0,
  creado_en timestamptz not null default now()
);

create table if not exists purchases (
  id uuid primary key default gen_random_uuid(),
  pack_id uuid not null references packs(id) on delete cascade,
  comprador_id uuid not null references profiles(id) on delete cascade,
  operacion text not null,
  estado text not null default 'en_verificacion' check (estado in ('en_verificacion','confirmado','reembolsado')),
  creado_en timestamptz not null default now(),
  unique (pack_id, comprador_id)
);

create table if not exists reports (
  id uuid primary key default gen_random_uuid(),
  pack_id uuid not null references packs(id) on delete cascade,
  autor_id uuid references profiles(id) on delete set null,
  motivo text not null,
  detalle text,
  estado text not null default 'pendiente' check (estado in ('pendiente','revisado')),
  creado_en timestamptz not null default now()
);

alter table profiles enable row level security;
alter table packs enable row level security;
alter table purchases enable row level security;
alter table reports enable row level security;

create policy "perfil propio: leer" on profiles for select using (auth_user_id = auth.uid());
create policy "perfil propio: crear" on profiles for insert with check (auth_user_id = auth.uid());
create policy "perfil propio: editar" on profiles for update using (auth_user_id = auth.uid());

-- Los nombres de autor deben verse en el catálogo público, sin exponer el resto del perfil.
create view public.autores as
  select id, nombre from profiles;

create policy "packs publicados: todos" on packs for select using (
  estado = 'publicado' or autor_id in (select id from profiles where auth_user_id = auth.uid())
);
create policy "packs: crear propios" on packs for insert with check (
  autor_id in (select id from profiles where auth_user_id = auth.uid())
);
create policy "packs: editar propios" on packs for update using (
  autor_id in (select id from profiles where auth_user_id = auth.uid())
);

create policy "compras: ver propias" on purchases for select using (
  comprador_id in (select id from profiles where auth_user_id = auth.uid())
);
create policy "compras: crear propias" on purchases for insert with check (
  comprador_id in (select id from profiles where auth_user_id = auth.uid())
);
create policy "compras: editar propias" on purchases for update using (
  comprador_id in (select id from profiles where auth_user_id = auth.uid())
);

create policy "denuncias: crear" on reports for insert with check (true);
create policy "denuncias: ver propias" on reports for select using (
  autor_id in (select id from profiles where auth_user_id = auth.uid())
);

-- Perfiles de ejemplo (autores de los packs de catálogo, sin cuenta real de login)
insert into profiles (id, nombre, uni, carrera) values
  ('00000000-0000-0000-0000-000000000001','Diego R.','UNI','Ingeniería'),
  ('00000000-0000-0000-0000-000000000002','Lucía M.','UNMSM','Ingeniería'),
  ('00000000-0000-0000-0000-000000000003','Andrea V.','PUCP','Economía'),
  ('00000000-0000-0000-0000-000000000004','Renzo C.','Universidad de Lima','Contabilidad'),
  ('00000000-0000-0000-0000-000000000005','Valeria S.','UPC','Química'),
  ('00000000-0000-0000-0000-000000000006','Mateo L.','Universidad del Pacífico','Economía')
on conflict (id) do nothing;

insert into packs (autor_id, titulo, curso, uni, seccion, descripcion, preview, tipos, precio, nota, estado, rating, resenas) values
  ('00000000-0000-0000-0000-000000000001','Integrales sin miedo','Cálculo II','UNI','Parcial 1','Todo lo del primer parcial: integrales por partes, sustitución trigonométrica, fracciones parciales e impropias. 80 ejercicios resueltos paso a paso y 3 simulacros con preguntas propias.','Tema 3 · Fracciones parciales\nCaso 1: factores lineales distintos. Si el denominador se factoriza como (x−a)(x−b), escribimos A/(x−a) + B/(x−b) y resolvemos el sistema…',array['apuntes','ejercicios','videos','simulacros'],25,18,'publicado',4.8,62),
  ('00000000-0000-0000-0000-000000000002','Física I de cero a parcial','Física I','UNMSM','Parcial 1','Cinemática, dinámica y trabajo-energía explicados con 12 videos cortos y un formulario de una página para repasar la noche anterior.','Cinemática · Truco para caída libre\nToma siempre el eje positivo hacia arriba y g = −9,8 m/s². Así evitas errores de signo…',array['apuntes','videos','formulario'],22,17,'publicado',4.6,41),
  ('00000000-0000-0000-0000-000000000003','Estadística aplicada: pack completo','Estadística I','PUCP','Final','Distribuciones, intervalos de confianza y pruebas de hipótesis. Incluye plan de estudio de 10 días y 2 simulacros tipo final.','Día 1 del plan · Distribución normal\nObjetivo: estandarizar cualquier variable con Z = (X − μ)/σ y leer la tabla sin dudar…',array['apuntes','ejercicios','simulacros','guia'],30,19,'publicado',4.9,88),
  ('00000000-0000-0000-0000-000000000004','Contabilidad General resuelta','Contabilidad General','Universidad de Lima','Parcial 2','Asientos contables, libro diario y mayor, y estados financieros con 45 casos resueltos creados por el autor.','Caso 4 · Compra de mercadería al crédito\nSe registra en el debe la cuenta 60 Compras y en el haber la 42 Cuentas por pagar…',array['ejercicios','apuntes'],20,17,'publicado',4.5,29),
  ('00000000-0000-0000-0000-000000000005','Química General: estequiometría','Química General','UPC','Parcial 1','Mol, reactivo limitante y rendimiento, con videos de 5 minutos y ejercicios graduados de fácil a difícil.','Reactivo limitante en 3 pasos\n1. Pasa todo a moles. 2. Divide entre el coeficiente. 3. El menor resultado es el limitante…',array['videos','ejercicios','formulario'],18,16,'publicado',4.4,18),
  ('00000000-0000-0000-0000-000000000006','Micro para no economistas','Microeconomía','Universidad del Pacífico','Final','Oferta y demanda, elasticidades y estructuras de mercado con gráficos explicados y un simulacro final con preguntas propias.','Elasticidad precio · Regla rápida\nSi |E| > 1 la demanda es elástica: subir el precio reduce el ingreso total…',array['apuntes','simulacros','guia'],24,18,'publicado',4.7,35)
on conflict do nothing;
