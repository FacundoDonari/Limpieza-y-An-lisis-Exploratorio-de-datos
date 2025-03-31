
Análisis de Despidos Masivos (Layoffs) - MySQL
Limpieza, Estandarización y Exploración de Datos

Descripción del Proyecto:

Este proyecto analiza datos históricos de despidos masivos en empresas (2020-2023) para identificar patrones, tendencias y métricas clave. El proceso incluyó:

Limpieza exhaustiva de datos para garantizar calidad.

Análisis exploratorio (EDA) para responder preguntas estratégicas.


Identificación de insights como empresas/países más afectados, tendencias temporales y sectores críticos.

🔧 LIMPIEZA DE DATOS 🔧
Se realizó una preparación rigurosa de los datos antes del análisis:

✅ Eliminación de duplicados: 

Uso de ROW_NUMBER() para identificar y eliminar registros repetidos.

 
✅ Estandarización: 

Unificación de categorías (ej: "Crypto", "Crypto Currency" → "Crypto").
Corrección de formatos (países, fechas).

✅ Manejo de valores nulos/blancos:

Relleno de datos faltantes mediante self-joins (ej: industria de una empresa basada en registros existentes).

✅ Eliminación de columnas irrelevantes:

Optimización de la estructura de la tabla final.




📊 ANALISIS EXPLORATORIO (EDA) 📊 

Principales Hallazgos:

🔹 Top empresas con más despidos:

🔹 Tendencias temporales:

2023 registró el mayor número de despidos (a pesar de solo incluir datos hasta marzo).

Picos en octubre-noviembre 2022 y enero 2023.

🔹 Impacto por país/industria:

Estados Unidos concentró el mayor volumen de despidos.

Sectores Tech y Retail fueron los más afectados.

🔹 Análisis de cohortes implícito:

Empresas de viajes/hospedaje lideraron despidos en 2020 (COVID-19).

En 2022-2023, empresas con alta capitalización ajustaron plantillas (¿Asignacion de recursos a Inteligencia Artificial?).


🛠️ Tecnologías Utilizadas
MySQL: Consultas, transformaciones y agregaciones.

SQL Avanzado: Funciones de ventana (ROW_NUMBER()), CTEs, self-joins.



🔍 Conclusiones

Los despidos masivos siguen una tendencia alcista, especialmente en Tech.

Estrategias reactivas: Empresas reaccionaron a cambios macroeconómicos (pandemia, recesión).

Oportunidad: Segmentar datos por etapa de empresa (startup vs. corporación) para profundizar el análisis.


