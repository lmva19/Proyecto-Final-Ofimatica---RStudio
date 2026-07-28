# Proyecto Final - Análisis Exploratorio y Análisis Final de ENAHO 2025

## Mercado laboral y educación en el Perú: ENAHO 2025

Este proyecto desarrolla un análisis exploratorio de datos (EDA) y un análisis complementario utilizando información de la Encuesta Nacional de Hogares (ENAHO) 2025 elaborada por el Instituto Nacional de Estadística e Informática (INEI) del Perú.

El objetivo principal es analizar las características educativas y laborales de la población peruana en edad de trabajar, identificando diferencias según características demográficas, territoriales y educativas.


---

# PARTE 1: Análisis Exploratorio de Datos (EDA)

## 1. Contexto del conjunto de datos

La fuente de información utilizada es la Encuesta Nacional de Hogares (ENAHO), elaborada por el Instituto Nacional de Estadística e Informática (INEI).

La ENAHO tiene como finalidad recopilar información sobre las condiciones socioeconómicas de los hogares peruanos, permitiendo estudiar aspectos relacionados con educación, empleo, características demográficas y ubicación geográfica.

Para este proyecto se utilizaron los siguientes módulos de ENAHO 2025:

- **Módulo 200:** características demográficas de las personas.
- **Módulo 300:** información educativa.
- **Módulo 500:** características del empleo.
- **SUMARIA:** información del hogar y ubicación geográfica.


Las principales variables analizadas fueron:

- Edad.
- Sexo.
- Nivel educativo.
- Años de estudios aprobados.
- Condición de ocupación.
- Área de residencia (urbano/rural).
- Departamento.


---

# 2. Importación y preparación de datos

Las bases fueron importadas utilizando el lenguaje R mediante el paquete `haven`, permitiendo trabajar con archivos en formato `.dta`.

Posteriormente se realizó la integración de los módulos mediante las variables identificadoras:

- Conglomerado.
- Vivienda.
- Hogar.
- Código de persona.


Las principales transformaciones realizadas fueron:

- Renombramiento de variables para facilitar el análisis.
- Construcción de la variable **años de estudio aprobados**.
- Recodificación de sexo.
- Creación de la variable urbano/rural.
- Construcción de la condición laboral ocupado/no ocupado.
- Filtrado de la población en edad de trabajar (14 años a más).


---

# 3. Estadísticas descriptivas

Se realizaron estadísticas descriptivas para conocer las principales características de la población analizada.

Se evaluaron:

- Distribución porcentual por sexo.
- Distribución de ocupados y no ocupados.
- Diferencias entre áreas urbanas y rurales.
- Estadísticos descriptivos de edad.
- Distribución de años de estudio aprobados.


Los resultados permiten observar la composición demográfica, educativa y laboral de la población peruana analizada.


---

# 4. Visualización de datos

Se construyeron gráficos utilizando la librería `ggplot2`, aplicando criterios de visualización como títulos, subtítulos, etiquetas de ejes y leyendas.


## Condición de ocupación según sexo

![Ocupación según sexo](figures/grafico_1_ocupacion_sexo.png)


## Años de estudio según condición laboral

![Educación y ocupación](figures/grafico_2_educacion_ocupacion.png)


## Distribución de años de estudio aprobados

![Distribución educativa](figures/grafico_3_distribucion_educacion.png)


## Condición de ocupación según área de residencia

![Ocupación por área](figures/grafico_4_ocupacion_area.png)


## Collage de gráficos exploratorios

![Collage](figures/collage_graficos.png)



---

# PARTE 2: Análisis Final

## Pregunta de análisis

**¿Existe una relación entre el nivel educativo promedio y la tasa de ocupación entre los departamentos del Perú durante 2025?**


---

# 1. Motivación del análisis

Durante el análisis exploratorio se identificaron diferencias en la condición laboral según características educativas y territoriales.

A partir de estos hallazgos, se realizó un análisis departamental para evaluar la relación entre el nivel educativo promedio y la tasa de ocupación en las regiones del Perú.


---

# 2. Análisis territorial del mercado laboral

Se construyó un indicador departamental de la tasa de ocupación utilizando la población de 14 años a más incluida en ENAHO 2025.

Asimismo, se elaboró un mapa del Perú para identificar diferencias territoriales en la participación laboral.


## Tasa de ocupación por departamento

![Mapa Perú](figures/mapa_peru_tasa_ocupacion.png)


El mapa evidencia diferencias importantes en la tasa de ocupación entre departamentos, mostrando que la dinámica laboral presenta características distintas según la estructura económica y productiva de cada región.


---

# 3. Relación entre educación y ocupación departamental

Para complementar el análisis se evaluó la relación entre los años promedio de estudio y la tasa de ocupación departamental.


## Educación promedio y tasa de ocupación

![Relación educación ocupación](figures/educacion_vs_ocupacion_departamentos.png)


El análisis encontró una correlación negativa entre ambas variables:

**Coeficiente de correlación: -0.74**


Este resultado no implica que una mayor educación reduzca las oportunidades laborales. Por el contrario, refleja diferencias en la estructura económica regional.

Los departamentos con mayores niveles educativos pueden presentar procesos de transición hacia empleos más especializados, mayor permanencia en formación educativa o características productivas distintas respecto a otras regiones.


---

# 4. Conclusiones finales

El análisis de ENAHO 2025 permitió identificar diferencias importantes en el mercado laboral peruano desde una perspectiva territorial y educativa.

Los resultados muestran que la tasa de ocupación varía considerablemente entre departamentos, evidenciando la influencia de factores económicos y regionales.

Asimismo, la relación entre educación y ocupación debe interpretarse considerando las características estructurales de cada región, debido a que un mayor nivel educativo no necesariamente se traduce inmediatamente en mayores tasas de ocupación.

En conjunto, los resultados resaltan la importancia de analizar el mercado laboral peruano considerando tanto factores educativos como diferencias territoriales.


---

# Estructura del proyecto
