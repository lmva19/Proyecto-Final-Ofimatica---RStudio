# ==========================================================
# PROYECTO FINAL - IMPORTACIÓN Y MERGE DE BASES ENAHO 2025
# ==========================================================

# Librerías
library(haven)
library(dplyr)
library(ggplot2)
library(patchwork)
library(gridExtra)
# ==========================================================
# Ruta de trabajo
# ==========================================================

ruta <- "C:/Users/sirbo/Downloads/Proyecto_final/data"

# ==========================================================
# Importar bases
# ==========================================================


sumaria <- read_dta(file.path(ruta, "sumaria-2025.dta"))
mod200  <- read_dta(file.path(ruta, "enaho01-2025-200.dta"))
mod300  <- read_dta(file.path(ruta, "enaho01a-2025-300.dta"))
mod500  <- read_dta(file.path(ruta, "enaho01a-2025-500.dta"))

# ==========================================================
# Seleccionar variables de interés
# ==========================================================


# Módulo 200 (Edad)

mod200 <- mod200 %>%
  select(
    conglome,
    vivienda,
    hogar,
    codperso,
    p208a      # Edad
  )



# Módulo 300 (Educación)
mod300 <- mod300 %>%
  select(
    conglome,
    vivienda,
    hogar,
    codperso,
    p207,      # Sexo
    p301a,     # Nivel educativo
    p301b      # Grado aprobado
  )

# Módulo 500 (Empleo)

mod500 <- mod500 %>%
  select(
    conglome,
    vivienda,
    hogar,
    codperso,
    ocu500     # Condición de ocupado
  )

# SUMARIA

# ==========================================================
# SUMARIA
# Variables del hogar y ubicación geográfica
# ==========================================================

sumaria <- sumaria %>%
  select(
    conglome,
    vivienda,
    hogar,
    ubigeo,
    estrato
  )
# ==========================================================
# Merge 300 + 500
# ==========================================================

base <- mod300 %>%
  left_join(
    mod500,
    by = c(
      "conglome",
      "vivienda",
      "hogar",
      "codperso"
    )
  )

# ==========================================================
# Agregar 200
# ==========================================================
base <- base %>%
  left_join(
    mod200,
    by = c(
      "conglome",
      "vivienda",
      "hogar",
      "codperso"
    )
  )


# ==========================================================
# Agregar SUMARIA
# ==========================================================
base <- base %>%
  left_join(
    sumaria,
    by = c(
      "conglome",
      "vivienda",
      "hogar"
    )
  )
# ==========================================================
# Revisar resultado
# ==========================================================

glimpse(base)

summary(base)

head(base)



# ==========================================================
# PASO 1: RENOMBRAR VARIABLES
# ==========================================================
base <- base %>%
  rename(
    sexo = p207,
    nivel_educativo = p301a,
    grado_aprobado = p301b,
    ocupado = ocu500,
    edad = p208a
  )

# ==========================================================
# PASO 2: CONSTRUIR ESTUDIOS_APROBADOS
# Objetivo:
# Calcular los años de estudio aprobados
# ==========================================================
# ==========================================================
# CONSTRUIR ESTUDIOS_APROBADOS Y ELIMINAR NA
# ==========================================================

base <- base %>%
  mutate(
    estudios_aprobados = case_when(
      
      # Sin nivel e inicial
      nivel_educativo %in% c(1,2) ~ 0,
      
      # Primaria
      nivel_educativo %in% c(3,4) ~ grado_aprobado,
      
      # Secundaria
      nivel_educativo %in% c(5,6) ~ 6 + grado_aprobado,
      
      # Superior no universitaria
      nivel_educativo %in% c(7,8) ~ 11 + grado_aprobado,
      
      # Superior universitaria
      nivel_educativo %in% c(9,10) ~ 11 + grado_aprobado,
      
      # Maestría / Doctorado
      nivel_educativo == 11 ~ 16,
      
      # Básica especial
      nivel_educativo == 12 ~ 0,
      
      TRUE ~ NA_real_
    )
  ) %>%
  filter(!is.na(estudios_aprobados))
# ==========================================================
# PASO 3: RECODIFICAR SEXO
# ==========================================================

base <- base %>%
  mutate(
    sexo = factor(
      sexo,
      levels = c(1, 2),
      labels = c("Hombre", "Mujer")
    )
  )

# ==========================================================
# PASO 4: CREAR VARIABLE URBANO
# 1 = Urbano
# 0 = Rural
# ==========================================================

base <- base %>%
  mutate(
    urbano = if_else(estrato <= 5, 1, 0)
  )

# ==========================================================
# PASO 5: ETIQUETAR VARIABLE URBANO
# ==========================================================

base <- base %>%
  mutate(
    urbano = factor(
      urbano,
      levels = c(1,0),
      labels = c("Urbano","Rural")
    )
  )

# ==========================================================
# PASO 6: CREAR VARIABLE BINARIA OCUPADO
# 1 = Ocupado
# Cualquier otro valor = No ocupado
# ==========================================================

base <- base %>%
  mutate(
    ocupado = if_else(ocupado == 1, 1, 0),
    ocupado = factor(
      ocupado,
      levels = c(1, 0),
      labels = c("Ocupado", "No ocupado")
    )
  )
# ==========================================================
# PASO 7: FILTRAR POBLACIÓN EN EDAD DE TRABAJAR
# Personas de 14 años o más
# ==========================================================

base <- base %>%
  filter(edad >= 14)

head(base)


# ==========================================================
# ASEGURAR VARIABLES NUMÉRICAS
# ==========================================================

base <- base %>%
  mutate(
    edad = as.numeric(edad),
    estudios_aprobados = as.numeric(estudios_aprobados)
  )


base_graf <- base %>%
  filter(!is.na(estudios_aprobados))


# ==========================================================
# VERIFICAR VARIABLES
# ==========================================================

summary(base)

table(base$sexo)

table(base$urbano)

table(base$ocupado)

summary(base$estudios_aprobados)

head(base)


# ==========================================================
# ESTADÍSTICAS DESCRIPTIVAS
# PASO 1: DIMENSIÓN DE LA BASE
# ==========================================================

cat("Número de filas:", nrow(base), "\n")
cat("Número de columnas:", ncol(base), "\n")


# ==========================================================
#  SEXO
# ==========================================================

table(base$sexo)

round(prop.table(table(base$sexo))*100,2)

# ==========================================================
#  OCUPACIÓN
# ==========================================================

table(base$ocupado)

round(prop.table(table(base$ocupado))*100,2)

# ==========================================================
#  ÁREA DE RESIDENCIA
# ==========================================================

table(base$urbano)

round(prop.table(table(base$urbano))*100,2)

# ==========================================================
#  EDAD
# ==========================================================

summary(base$edad)

sd(base$edad)

quantile(base$edad)

# ==========================================================
#  ESTUDIOS APROBADOS
# ==========================================================

summary(base$estudios_aprobados)

sd(base$estudios_aprobados)

quantile(base$estudios_aprobados)



library(janitor)


tabyl(base, sexo)

tabyl(base, ocupado)

tabyl(base, urbano)


tabyl(base, sexo) %>%
  adorn_percentages("col") %>%
  adorn_pct_formatting()

# ==========================================================
# VISUALIZACIÓN DE DATOS
# ENAHO 2025
# ==========================================================


# ==========================================================
# GRÁFICO 1:
# Condición de ocupación según sexo
# Muestra la proporción de ocupados y no ocupados
# diferenciando entre hombres y mujeres
# ==========================================================

g1 <- ggplot(base,
             aes(
               x = sexo,
               fill = ocupado
             )) +
  
  geom_bar(position = "fill") +
  
  scale_y_continuous(
    labels = scales::percent
  ) +
  
  labs(
    title = "Condición de ocupación según sexo",
    subtitle = "Distribución porcentual de ocupados y no ocupados - ENAHO 2025",
    x = "Sexo",
    y = "Porcentaje",
    fill = "Condición laboral"
  ) +
  
  theme_dark() +
  
  theme(
    plot.title = element_text(size = 15, face = "bold"),
    plot.subtitle = element_text(size = 11),
    legend.position = "bottom"
  )


g1


# ==========================================================
# GRÁFICO 2:
# Años de estudio según condición de ocupación
# Compara la distribución educativa entre ocupados
# y no ocupados mediante un diagrama de caja
# ==========================================================
g2 <- ggplot(base,
             aes(
               x = ocupado,
               y = estudios_aprobados,
               fill = ocupado
             )) +
  
  geom_boxplot() +
  
  labs(
    title = "Años de estudio según condición de ocupación",
    subtitle = "Comparación del nivel educativo entre grupos laborales - ENAHO 2025",
    x = "Condición laboral",
    y = "Años de estudio aprobados",
    fill = "Condición laboral"
  ) +
  
  theme_dark() +
  
  theme(
    plot.title = element_text(size = 15, face = "bold"),
    plot.subtitle = element_text(size = 11),
    legend.position = "none"
  )


g2

# ==========================================================
# GRÁFICO 3:
# Distribución de los años de estudio aprobados
# Permite observar la concentración educativa
# de la población analizada
# ==========================================================
g3 <- ggplot(base,
             aes(
               x = estudios_aprobados
             )) +
  
  geom_histogram(
    bins = 25,
    fill = "#377EB8",
    color = "white"
  ) +
  
  labs(
    title = "Distribución de los años de estudio aprobados",
    subtitle = "Población en edad de trabajar - ENAHO 2025",
    x = "Años de estudio aprobados",
    y = "Frecuencia"
  ) +
  
  theme_dark() +
  
  theme(
    plot.title = element_text(size = 15, face = "bold"),
    plot.subtitle = element_text(size = 11)
  )


g3

# ==========================================================
# GRÁFICO 4:
# Condición de ocupación según área de residencia
# Compara la situación laboral entre zonas urbanas
# y rurales
# ==========================================================
g4 <- ggplot(base,
             aes(
               x = urbano,
               fill = ocupado
             )) +
  
  geom_bar(position = "fill") +
  
  scale_y_continuous(
    labels = scales::percent
  ) +
  
  labs(
    title = "Condición de ocupación según área de residencia",
    subtitle = "Diferencias laborales entre zonas urbanas y rurales - ENAHO 2025",
    x = "Área de residencia",
    y = "Porcentaje",
    fill = "Condición laboral"
  ) +
  
  theme_dark() +
  
  theme(
    plot.title = element_text(size = 15, face = "bold"),
    plot.subtitle = element_text(size = 11),
    legend.position = "bottom"
  )


g4


# ==========================================================
# GUARDAR GRÁFICOS DEL PROYECTO FINAL
# EN CARPETA FIGURES DE GITHUB
# ==========================================================


# Ruta principal del proyecto

ruta_proyecto <- "C:/Users/sirbo/Downloads/Proyecto_Final"


# Ruta donde se guardarán los gráficos

ruta_figuras <- file.path(
  ruta_proyecto,
  "figures"
)


# Crear carpeta figures si no existe

dir.create(
  ruta_figuras,
  showWarnings = FALSE
)



# ==========================================================
# GUARDAR GRÁFICOS INDIVIDUALES
# ==========================================================


ggsave(
  filename = file.path(
    ruta_figuras,
    "grafico_1_ocupacion_sexo.png"
  ),
  plot = g1,
  width = 8,
  height = 6,
  dpi = 300
)



ggsave(
  filename = file.path(
    ruta_figuras,
    "grafico_2_educacion_ocupacion.png"
  ),
  plot = g2,
  width = 8,
  height = 6,
  dpi = 300
)



ggsave(
  filename = file.path(
    ruta_figuras,
    "grafico_3_distribucion_educacion.png"
  ),
  plot = g3,
  width = 8,
  height = 6,
  dpi = 300
)



ggsave(
  filename = file.path(
    ruta_figuras,
    "grafico_4_ocupacion_area.png"
  ),
  plot = g4,
  width = 8,
  height = 6,
  dpi = 300
)



# ==========================================================
# CREAR Y GUARDAR COLLAGE
# ==========================================================


library(gridExtra)


png(
  filename = file.path(
    ruta_figuras,
    "collage_graficos.png"
  ),
  width = 3000,
  height = 2500,
  res = 300
)


grid.arrange(
  g1,
  g2,
  g3,
  g4,
  ncol = 2
)


dev.off()



# ==========================================================
# GUARDAR BASE
# ==========================================================

saveRDS(
  base,
  "C:/Users/sirbo/Downloads/Proyecto_Final/data/base_limpia.rds"
)