-- LIMPIEZA DE DATOS --

-- OBJETIVOS --

-- 1. eliminar duplicados --
-- 2. estandarizar los datos --
-- 3. quitar valores nulos o blancos --
-- 4. remover columnas irrelevantes -- -- es convenientes crear una copia de la tabla orginal sin procesar y trabajar con ella --


-- crear otra tablar que es una copia de la original--

create table layoffs_staging 
like layoffs;

-- le agregamos la informacion --

insert layoffs_staging
select*
from layoffs; 
select*
from layoffs_staging; -- es con la que se trabaja -- 


-- 1. identificar duplicados --

select*
from layoffs_staging;

-- row_number() over: La función row_number() es una función de ventana que asigna un número único a cada fila dentro de una partición de un conjunto de resultados. El over indica que se va a definir una ventana sobre la cual se calculará el row_number().

-- row_number--
-- Muestra si hay dos o mas filas con los mismos valores en todas las columnas especificadas en el PARTITION BY.
-- La función ROW_NUMBER() asigna 1 a la primera fila y 2 a la segunda fila dentro de esta partición.--
-- depues usamos with que permite crear una consulta temporal con un nombre especifico para usar en otra consulta --


with duplicados as (
		select
		*,
		row_number() over( 
						partition by 
						company,
						location,
						industry,
						total_laid_off,
						percentage_laid_off,
						date,
						stage,
						country,
						funds_raised_millions) as row_num
from layoffs_staging)

select*
from duplicados
where row_num > 1;

-- corroboro --

select*
from layoffs_staging
where company="casper";


-- borrar duplicado --     -- creo una nueva tabla con la columna row_num y despues elimnio los duplicados --

CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

insert into layoffs_staging2
	select
			*,
			row_number() over( 
						partition by 
						company,
						location,
						industry,
						total_laid_off,
						percentage_laid_off,
						date,
						stage,
						country,
						funds_raised_millions) as row_num
from layoffs_staging;

select*
from layoffs_staging2
where row_num>1;


-- borrar --

delete
from layoffs_staging2 
where row_num>1;

-- 2. Estandarizar datos --

-- unir cateogorias que deberian ir juntas --
--  por ejemplo, habia varias industria de cripto como, como crypto, crupto currency,etc y se lo unio en la categoria "Crypto" --

select *
from layoffs_staging2;

select*
from layoffs_staging2
where industry like "crypto%";

update layoffs_staging2
set industry = "Crypto"
where industry like "Crypto%";

-- se elimnan puntos, comas y demas simbolos que puedan afectar la informacio --

select distinct country
from layoffs_staging2 
where country like "United States%";

select distinct country, trim(trailing '.' from country)
from layoffs_staging2
order by 1;

update layoffs_staging2
set country = trim(trailing '.' from country)
where country like "United States%";

-- se acomodan las fechas a otro formato --

select date, str_to_date(date, "%m/%d/%Y") as convertida
from layoffs_staging2;

update layoffs_staging2
set date = str_to_date(date, "%m/%d/%Y");

select *
from layoffs_staging2;

-- cambiamos el formato de texto a fromato date --

alter table layoffs_staging2
modify column date date;




-- 3. valores nulos y blancos --

select *
from layoffs_staging2
where total_laid_off is null and percentage_laid_off is null;


-- '' para una cadena vacia null para valores nulos --
select *
from layoffs_staging2
where industry = '' or industry is null;

-- se puede completar datos incompletos con datos de la misma tabla --

-- puedo rellenar las cadenas vacias por null--

update layoffs_staging2
set industry = null 
where industry = '';

-- se hace un join para identificar la industria a la que pertenencen --

select t1. company, t1.industry, t2.company, t2.industry
from layoffs_staging2 t1
join layoffs_staging2 t2
	on t1.company = t2.company
where (t1.industry is null) and
	t2.industry is not null;

-- ahora se actualiza la tabla --
-- t1 es la tabla que se actualiza y t2 (misma tabla) es la que proporciona los datos --

update layoffs_staging2 t1
join layoffs_staging2 t2 
	on t1.company = t2.company
set t1.industry=t2.industry
where t1.industry is null and t2.industry is not null; 



-- corroboro que funciono --
select*
from layoffs_staging2
where company = "airbnb";

-- borro la columna row_num que ya no necesito --

alter table layoffs_staging2
drop column row_num;

select*
from layoffs_staging2;

-- CON ESTO SE CONCLUYE LA LIMPIEZA DE LOS DATOS, AHORA CONTINUO CON EL ANALISIS --



-- EDA (ANALISIS EXPLORATORIO DE DATOS) --

-- cual fue la mayor cantidad de personas despedidas en un dia--
select
	max(total_laid_off)
from layoffs_staging2;

-- averiguamos que empresa --
select*
from layoffs_staging2
where total_laid_off = 12000;

-- mayor porcentaje de despidos --
select 
	max(percentage_laid_off)
from layoffs_staging2;

-- empresas que despidieron al total de su plantilla ordenadas en base al total despidos --
select *
from layoffs_staging2
where percentage_laid_off = "1"
order by total_laid_off desc;

    
-- que tiempo abarca la tabla --
select 
	min(date), 
	max(date)
from layoffs_staging2;

-- En cuales empresas hubo mas despidos (top 10) entre marzo 2020 y marzo 2023 --
select
	company,
    sum(total_laid_off) as total_despidos
from layoffs_staging2
group by 1
order by 2 desc
limit 10; -- tiene santido al ser empresas grandes --


-- En cual pais hubo mas despidos --
select
	country,
    sum(total_laid_off) as total_despidos
from layoffs_staging2
group by 1
order by 2 desc; 


-- En cual industria se despidio mas --
select
	industry,
    sum(total_laid_off) as total_despidos
from layoffs_staging2
group by 1
order by 2 desc;


-- Despidos por año --
select
	sum(total_laid_off) as total_despidos,
    year(date) as año
from layoffs_staging2
group by 2
order by 1 desc;


-- Despidos por mes en el año 2022 --
select
	sum(total_laid_off) as total_despidos,
    month(date) as mes,
    year(date) año
from layoffs_staging2
where year(date)=2022
group by 2
order by 1 desc; -- cerca de la mitad de los despidos en 2022 ocurrierion en ocubre y noviembre se repetira en otros años?


select
	sum(total_laid_off) as total_despidos,
    month(date) as mes,
    year(date) año
from layoffs_staging2
where year(date)=2023
group by 2
order by 1 desc; 

-- en 2023 ocurre que en enero se producen la mayoria de despidos --
-- tambien destacar que solo hay datos de los primeros tres meses y aun asi 2023 consituye el 2do año con mas despidos --
-- se nota una tendencia alcista de despidos entre el año 2022 y principios 2023 -- 

with acumulado as
(
select
	substring(date, 1, 7) as mes,
    sum(total_laid_off) as total_despidos
from layoffs_staging2
where substring(date, 1, 7) is not null 
group by 1
order by 1 asc
)
select 
	mes, 
	total_despidos as despidos_mensuales, 
	sum(total_despidos) over(order by mes) as acumulado
from acumulado;  -- se puede apreciar mejor la tendencia alcista entre 2022 y 2023 --


-- Cuales fueron las empresas que mas despidieron por cada ano --

with company_year as
(
select company, year(date) as years , sum(total_laid_off) as total_laid
from layoffs_staging2
group by company,year(date)
), company_year_rank as 
(
select 
	*,
	dense_rank() over (partition by years order by total_laid desc) as ranking
from company_year
where years is not null
order by ranking asc
)
select *
from company_year_rank
where ranking <= 5
order by years; 

-- entonces, en 2020 se tienen las 5 empresas en las que mas despidos hubo, los mismo para los demas años--
-- se puede notar como en 2020 empresas de servicios de tranporte y hospedaje fueron perjudicadas por la pandemia --
-- tambien en 2022 y 2023 empresas de gran capitalizacion estan en el top, lo que nos lleva a la pregunta del porque --
-- puede ser por cambios de rumbo del negocio, explotar y asignar recursos a la intelgia artifical, recortes de costos, etc -- 


-- CON ESTO CONLCUYE EL EDA (ANALISIS EXPLORATORIO DE DATOS) --

                
                
