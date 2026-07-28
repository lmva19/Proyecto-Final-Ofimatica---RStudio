# ==========================================================
# ANÁLISIS FINAL
# ENAHO 2025
# ==========================================================


library(dplyr)
library(ggplot2)
library(sf)
library(geodata)
library(scales)


# ==========================================================
# CREAR VARIABLE DEPARTAMENTO
# ==========================================================
base <- readRDS(
  "C:/Users/sirbo/Downloads/Proyecto_Final/data/base_limpia.rds"
)
# ==========================================================
# TASA DE OCUPACIÓN POR DEPARTAMENTO
# ==========================================================

ocupacion_dep <- base %>%
  group_by(departamento) %>%
  summarise(
    
    poblacion = n(),
    
    ocupados = sum(
      ocupado == "Ocupado"
    ),
    
    tasa_ocupacion = round(
      ocupados/poblacion*100,
      2
    )
    
  )


ocupacion_dep


# ==========================================================
# MAPA DEL PERÚ POR DEPARTAMENTOS
# ==========================================================


mapa_peru <- geodata::gadm(
  
  country = "PER",
  level = 1,
  path = tempdir()
  
) %>%
  
  sf::st_as_sf()


mapa_peru$NAME_1


departamentos <- data.frame(
  
  departamento = c(
    "01","02","03","04","05",
    "06","07","08","09","10",
    "11","12","13","14","15",
    "16","17","18","19","20",
    "21","22","23","24"
  ),
  
  NAME_1 = mapa_peru$NAME_1[1:24]
  
)

ocupacion_dep <- ocupacion_dep %>%
  
  left_join(
    departamentos,
    by="departamento"
  )



mapa_final <- mapa_peru %>%
  
  left_join(
    
    ocupacion_dep,
    
    by="NAME_1"
    
  )

# ==========================================================
# MAPA:
# TASA DE OCUPACIÓN POR DEPARTAMENTO
# GUARDAR COMO OBJETO
# ==========================================================


mapa_grafico <- mapa_final %>%
  
  ggplot()+
  
  geom_sf(
    aes(fill=tasa_ocupacion),
    color="white"
  )+
  
  
  scale_fill_viridis_c(
    
    option="C",
    
    labels=function(x)
      paste0(x,"%")
    
  )+
  
  
  labs(
    
    title="Perú: tasa de ocupación por departamento, 2025",
    
    subtitle="Población de 14 años a más según ENAHO 2025",
    
    fill="Ocupación",
    
    caption="Fuente: INEI - ENAHO 2025"
    
  )+
  
  
  theme_minimal()+
  
  
  theme(
    
    plot.title = element_text(
      size=15,
      face="bold",
      hjust=0.5
    ),
    
    plot.subtitle = element_text(
      hjust=0.5
    )
    
  )


# visualizar

mapa_grafico
# ==========================================================
# EDUCACIÓN PROMEDIO POR DEPARTAMENTO
# ==========================================================


educacion_dep <- base %>%
  
  group_by(departamento) %>%
  
  summarise(
    
    educacion_promedio = mean(
      estudios_aprobados,
      na.rm=TRUE
    )
    
  )

educacion_dep





analisis_final <- ocupacion_dep %>%
  
  left_join(
    educacion_dep,
    by="departamento"
  )


cor(
  analisis_final$tasa_ocupacion,
  analisis_final$educacion_promedio,
  use="complete.obs"
)


# ==========================================================
# GRÁFICO COMPLEMENTARIO:
# Relación entre educación promedio y tasa de ocupación
# por departamento
# ==========================================================


ggplot(
  analisis_final,
  aes(
    x = educacion_promedio,
    y = tasa_ocupacion
  )
) +
  
  # Puntos por departamento
  geom_point(
    size = 4,
    color = "#00BFC4"
  ) +
  
  # Línea de tendencia
  geom_smooth(
    method = "lm",
    se = TRUE,
    color = "#F8766D",
    linewidth = 1.2
  ) +
  
  # Etiquetas de departamentos
  geom_text(
    aes(
      label = departamento
    ),
    vjust = -1,
    size = 3,
    color = "white"
  ) +
  
  labs(
    title = "Educación y ocupación departamental en el Perú",
    subtitle = "Relación entre años promedio de estudio y tasa de ocupación - ENAHO 2025",
    x = "Años promedio de estudio",
    y = "Tasa de ocupación (%)",
    caption = "Fuente: INEI - ENAHO 2025"
  ) +
  
  theme_dark() +
  
  theme(
    plot.background = element_rect(
      fill = "black",
      color = "black"
    ),
    
    panel.background = element_rect(
      fill = "black",
      color = "black"
    ),
    
    plot.title = element_text(
      color = "white",
      size = 15,
      face = "bold",
      hjust = 0.5
    ),
    
    plot.subtitle = element_text(
      color = "white",
      hjust = 0.5
    ),
    
    axis.text = element_text(
      color = "white"
    ),
    
    axis.title = element_text(
      color = "white"
    ),
    
    plot.caption = element_text(
      color = "white"
    )
  )

# ==========================================================
# GUARDAR GRÁFICO DE DISPERSIÓN COMO OBJETO
# ==========================================================


dispersion_grafico <- ggplot(
  analisis_final,
  aes(
    x = educacion_promedio,
    y = tasa_ocupacion
  )
) +
  
  geom_point(
    size = 4,
    color = "#00BFC4"
  ) +
  
  geom_smooth(
    method = "lm",
    se = TRUE,
    color = "#F8766D",
    linewidth = 1.2
  ) +
  
  geom_text(
    aes(
      label = departamento
    ),
    vjust = -1,
    size = 3,
    color = "white"
  ) +
  
  labs(
    title = "Educación y ocupación departamental en el Perú",
    subtitle = "Relación entre años promedio de estudio y tasa de ocupación - ENAHO 2025",
    x = "Años promedio de estudio",
    y = "Tasa de ocupación (%)",
    caption = "Fuente: INEI - ENAHO 2025"
  ) +
  
  theme_dark() +
  
  theme(
    plot.background = element_rect(
      fill = "black",
      color = "black"
    ),
    
    panel.background = element_rect(
      fill = "black",
      color = "black"
    ),
    
    plot.title = element_text(
      color = "white",
      size = 15,
      face = "bold",
      hjust = 0.5
    ),
    
    plot.subtitle = element_text(
      color = "white",
      hjust = 0.5
    ),
    
    axis.text = element_text(
      color = "white"
    ),
    
    axis.title = element_text(
      color = "white"
    ),
    
    plot.caption = element_text(
      color = "white"
    )
  )


# Visualizar

dispersion_grafico



# ==========================================================
# GUARDAR MAPA Y GRÁFICO DE DISPERSIÓN EN FIGURES
# ==========================================================


# Ruta del proyecto

ruta_proyecto <- "C:/Users/sirbo/Downloads/Proyecto_Final"


# Carpeta de figuras

ruta_figuras <- file.path(
  ruta_proyecto,
  "figures"
)


# Crear carpeta si no existe

dir.create(
  ruta_figuras,
  showWarnings = FALSE
)



# ==========================================================
# GUARDAR MAPA DEL PERÚ
# ==========================================================

ggsave(
  filename = file.path(
    ruta_figuras,
    "mapa_peru_tasa_ocupacion.png"
  ),
  plot = mapa_grafico,
  width = 9,
  height = 8,
  dpi = 300
)



# ==========================================================
# GUARDAR GRÁFICO DE DISPERSIÓN
# ==========================================================

ggsave(
  filename = file.path(
    ruta_figuras,
    "educacion_vs_ocupacion_departamentos.png"
  ),
  plot = dispersion_grafico,
  width = 9,
  height = 7,
  dpi = 300
)



# ==========================================================
# VERIFICAR ARCHIVOS GUARDADOS
# ==========================================================

list.files(ruta_figuras)