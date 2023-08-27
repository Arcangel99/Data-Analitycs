-- Primera Tarea Evaluada del Bootcamp Data Analyst Jr. (DA2)
--Junior Efraín Franco Pérez.

/*1. Se está haciendo un análisis de los costos de reemplazo por pérdida en relación con la tarifa de
alquiler de cada película. Se desea listar las películas cuya proporción entre costo de reemplazo y
tarifa de alquiler sea menor que de 4 a 1.*/
select title, replacement_cost, rental_rate, (replacement_cost / rental_rate)  Proporcion  from film 
where replacement_cost / rental_rate <4

/*2. Se necesita filtrar las películas que fueron lanzadas en el año 2006, que se alquilan a $0.99 o
$2.99, que tienen un costo de reemplazo inferior a $19.99, que tienen una duración de entre 90
y 150 minutos, que tienen clasificación ‘G’, ‘PG’ o ‘PG-13’, que se rentan por 5 días o menos y
que sean de alguna de las categorías ‘Comedy’, ‘Family’ o ‘Children’. Cree un query que devuelva
la lista de títulos que cumplen con todos esos filtros.*/
select f.title from film f 
inner join film_category fc on fc.film_id = f.film_id 
inner join category c on c.category_id = fc.category_id 
where f.release_year =2006
and (f.rental_rate =0.99 or rental_rate =2.99)
and f.replacement_cost < 19.99
and f.length between 90 and 150
and (f.rating ='G' or f.rating ='PG' or f.rating ='PG-13')
and f.rental_duration <=5
and (upper(c.name) ='COMEDY' or upper(c.name) ='FAMILY' or upper(c.name) ='CHILDREN')


/*3. Se necesita crear el reporte de Rentas del Día, que consiste en la información de todas las rentas
registradas en una fecha en particular. Escriba un query que genere este reporte para una fecha
fija, por ejemplo el 31 de julio de 2005. El reporte debe mostrar las rentas de esa fecha en orden
cronológico. El reporte debe incluir las siguientes columnas:
a. “Fecha de Renta”, en este formato: 31-JUL-2005
b. “Hora de Renta”, en este formato: 15:30 (formato de 24 horas, sin am/pm)
c. “Título” (de la película)
d. “Nombre del Cliente” (nombre seguido de apellido)
e. “Email del Cliente”
f. “Teléfono del Cliente”
g. “Dirección Completa del Cliente”, en este formato: Dirección Base. Distrito, Código
Postal. Ciudad, País.
h. “Nombre del Empleado” (nombre seguido de apellido)*/
select to_char(r.rental_date,'DD/MON/YYYY') "Fecha de Renta" , to_char(r.rental_date,'hh24:mi') "Hora de Renta",
f.title "Título", concat(cu.first_name,' ',cu.last_name) "Nombre del Cliente", cu.email "Email del Cliente",
ad.phone "Teléfono del Cliente", concat(ad.address,'. ',ad.district,', ', ad.postal_code,'. ',ci.city,', ',co.country) "Dirección Completa del Cliente",
concat(st.first_name,' ',st.last_name) "Nombre del Empleado"
from rental r
inner join inventory i on i.inventory_id =r.inventory_id 
inner join film f on f.film_id = i.film_id 
inner join customer cu on cu.customer_id = r.customer_id 
inner join address ad on ad.address_id =cu.address_id 
inner join city ci on ci.city_id = ad.city_id 
inner join country co on co.country_id =ci.country_id 
inner join staff st on st.staff_id = r.staff_id 
where r.rental_date::date = '2005-07-31'
order by r.rental_date asc

/*4. Genere un reporte que muestre las rentas del día: Fecha y hora de renta, datos del cliente:
nombre completo, teléfono y país de residencia; y datos del empleado que registra la renta:
nombre completo, teléfono y país de residencia. Use en el query una fecha fija como ejemplo.*/
select to_char(r.rental_date,'DD/MON/YYYY') "Fecha de la renta", to_char(r.rental_date,'HH24:MI am') "Hora de la renta", 
concat(cu.first_name,' ',cu.last_name) "Nombre del Cliente", ad.phone "Telefono del Cliente",
co.country "Pais de Residencia del Cliente", concat(st.first_name, ' ', st.last_name) "Nombre del Empleado", ad2.phone "Telefono del empleado",
co2.country "Pais de Residencia del Empleado"
from rental r 
inner join customer cu on cu.customer_id = r.customer_id 
inner join address ad on ad.address_id = cu.address_id
inner join staff st on st.staff_id = r.staff_id
inner join city as ci on ci.city_id = ad.city_id
inner join country co on co.country_id = ci.country_id 
inner join address ad2 on ad2.address_id = st.address_id
inner join city ci2 on ci2.city_id = ad2.city_id
inner join country co2 on co2.country_id = ci2.country_id
where r.rental_date::date = '2005-05-25'
order by r.rental_date asc

/*5. Se piensa que hay un problema con la congruencia de los datos entre la tarifa de renta de cada
película y el monto pagado realmente por rentarla. Haga un query que muestre todas las rentas
efectuadas en agosto de 2005 en las que la tarifa de renta de la película (según la tabla film) NO
coincida con el monto pagado realmente (según la tabla payment). Suponga que cada renta de
ese periodo está asociada a un solo pago en la tabla payment.*/
select r.rental_date, r.rental_id, f.title Pelicula, f.rental_rate "Tarifa de Film", p.amount "Monto Pagado"
from film f 
inner join inventory i on i.film_id = f.film_id
inner join rental r on r.inventory_id = i.inventory_id
inner join payment p on p.rental_id = r.rental_id
where r.rental_date::date>='2005-08-01' and  r.rental_date::date<='2005-08-31'
and f.rental_rate <> p.amount
order by r.rental_date asc