
Análisis de Despidos Masivos (Layoffs) - MySQL
Limpieza, Estandarización y Exploración de Datos

Descripción del Proyecto:

1. Este proyecto analiza datos históricos de despidos masivos en empresas (2020-2023) para identificar patrones, tendencias y métricas clave. El proceso incluyó:

2. Limpieza exhaustiva de datos para garantizar calidad.

3. Análisis exploratorio (EDA) para responder preguntas estratégicas.


Identificación de insights como empresas/países más afectados, tendencias temporales y sectores críticos.

🔧 LIMPIEZA DE DATOS 🔧
Se realizó una preparación rigurosa de los datos antes del análisis:

✅ Eliminación de duplicados:

    1. Uso de ROW_NUMBER() para identificar y eliminar registros repetidos.

✅ Estandarización:

    1. Unificación de categorías (ej: "Crypto", "Crypto Currency" → "Crypto").

    2. Corrección de formatos (países, fechas).

✅ Manejo de valores nulos/blancos:

     1. Relleno de datos faltantes mediante self-joins (ej: industria de una empresa basada en registros existentes).

✅ Eliminación de columnas irrelevantes:

     1. Optimización de la estructura de la tabla final.




📊 ANALISIS EXPLORATORIO (EDA) 📊 

Principales Hallazgos:

🔹 Top empresas con más despidos:

SELECT company, SUM(total_laid_off) AS total_despidos
FROM layoffs_staging2
GROUP BY company
ORDER BY total_despidos DESC
LIMIT 10;
(Ejemplo: Google, Amazon, Meta lideran el ranking).

🔹 Tendencias temporales:

     1. 2023 registró el mayor número de despidos (a pesar de solo incluir datos hasta marzo).

     2. Picos en octubre-noviembre 2022 y enero 2023.

🔹 Impacto por país/industria:

     1. Estados Unidos concentró el mayor volumen de despidos.

     2. Sectores Tech y Retail fueron los más afectados.

🔹 Análisis de cohortes implícito:

     1. Empresas de viajes/hospedaje lideraron despidos en 2020 (COVID-19).

     2. En 2022-2023, empresas con alta capitalización ajustaron plantillas (¿Asignacion de recursos a Inteligencia Artificial?).


🛠️ Tecnologías Utilizadas
     1. MySQL: Consultas, transformaciones y agregaciones.

     2. SQL Avanzado: Funciones de ventana (ROW_NUMBER(), DENSE_RANK()), CTEs, self-joins.



🔍 Conclusiones
     1. Los despidos masivos siguen una tendencia alcista, especialmente en Tech.

     2. Estrategias reactivas: Empresas reaccionaron a cambios macroeconómicos (pandemia, recesión).

     3. Oportunidad: Segmentar datos por etapa de empresa (startup vs. corporación) para profundizar el análisis.


