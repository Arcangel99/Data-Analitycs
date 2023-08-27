--JUNIOR EFRAIN FRANCO PEREZ.

/*Ejercicios de Joins en SQL – Parte 1
Utilizando la base de datos dvdrental en PostgreSQL, escriba las consultas o queries que muestren lo que
se pide en cada ejercicio.*/

/* 1. Liste las películas que están en idioma inglés */

select f.*, lg.name from film f inner join  language lg  on f.language_id = lg.language_id where lg.name = 'English';

/* 2. Liste los actores que participan en la película Lonely Elephant*/
select a.first_name nombre_actor, a.last_name apellido_actor, f.title titulo_pelicula
from film f inner join film_actor fl on f.film_id = fl.film_id
inner join actor a on a.actor_id = fl.actor_id 
where f.title='Lonely Elephant'

/* 3. Liste en orden alfabético las películas en las que ha participado la actriz Charlize Dench, usando
el formato Nombre de Película (Año de lanzamiento), por ejemplo: El Padrino (1972)*/
select concat(a.first_name,' ',a.last_name) Actor_nombre, concat(f.title, ' (',f.release_year,')')
from film f 
inner join film_actor fl on f.film_id = fl.film_id
inner join actor a on a.actor_id = fl.actor_id 
where concat(a.first_name,' ',a.last_name) = 'Charlize Dench'
order by concat(f.title, ' (',f.release_year,')')

/* 4. Liste las películas que están categorizadas como ‘Horror’*/
select f.title peliculas, c.name
from film f inner join film_category fc on f.film_id = fc.film_id
inner join category c on c.category_id = fc.category_id
where c.name = 'Horror'

/* 5. Muestre en orden cronológico la fecha y hora de renta correspondiente a todas las veces que se
ha rentado la película ‘Half Outfield’*/
select r.rental_date, f.title
from rental r
inner join inventory i on r.inventory_id = i.inventory_id
inner join film f on f.film_id = i.film_id
where f.title = 'Half Outfield' 
order by r.rental_date asc

/* 6. Agregue al resultado del ejercicio #5 el nombre completo del cliente que ha rentado la película*/
select r.rental_date, f.title, concat(cu.first_name, ' ', cu.last_name) cliente_nombre_completo
from rental r
inner join inventory i on r.inventory_id = i.inventory_id
inner join film f on f.film_id = i.film_id
inner join customer cu on cu.customer_id = r.customer_id 
where f.title = 'Half Outfield' 
order by r.rental_date asc

/* 7. Agregue al resultado del ejercicio #6 el nombre completo del empleado que ha procesado cada renta*/
select r.rental_date, f.title, concat(cu.first_name, ' ', cu.last_name) cliente_completo,
concat (st.first_name, ' ', st.last_name) as nombre_empleado
from rental r
inner join inventory i on r.inventory_id = i.inventory_id
inner join film f on f.film_id = i.film_id
inner join customer cu on cu.customer_id = r.customer_id 
inner join staff st on st.staff_id = r.staff_id
where f.title = 'Half Outfield' 
order by r.rental_date asc

/* 8. Se necesita crear el reporte de Rentas del Día, que consiste en la información de todas las rentas
registradas en una fecha en particular. Escriba un query que genere este reporte para una fecha
fija, por ejemplo el 31 de julio de 2005. El reporte debe mostrar las rentas de esa fecha en orden
cronológico. Incluya fecha-hora de renta, el nombre completo del cliente (en una sola columna),
el título de la película y el nombre completo del empleado que registro la renta (en una sola
columna).*/
select concat(TO_CHAR(r.rental_date, 'YYYY/MM/DD'), ' - ' ,TO_CHAR(r.rental_date, 'HH24:MI:SS')) AS fecha_hora
,concat(cu.first_name, ' ', cu.last_name) nombre_cliente,
f.title titulo_pelicula, concat(st.first_name, st.last_name) as nombre_empleado
from rental r
inner join customer cu on cu.customer_id = r.customer_id
inner join inventory i on i.inventory_id = r.inventory_id
inner join film f on f.film_id = i.film_id
inner join staff st on st.staff_id = r.staff_id
where r.rental_date >='2005-07-31' and r.rental_date < '2005-08-01'
order by r.rental_date asc

/* 9. Se necesita hacer una mejora el reporte Rentas del Día. Se necesita agregar los datos de
contacto del cliente (email y teléfono), así como su dirección, distrito, código postal, ciudad y
país. También se requiere separar la fecha-hora de renta en dos columnas, una solamente con la
fecha, en formato como este: 31-JUL-2005, y la otra solamente con la hora, en formato como
este: 15:30 pm. Use alias en las columnas para que el reporte tenga encabezados adecuados.*/
select TO_CHAR(r.rental_date, 'DD-MON-YYYY') fecha ,TO_CHAR(r.rental_date, 'HH24:SS am') AS hora
,concat(cu.first_name, ' ', cu.last_name) nombre_cliente, cu.email email_cliente,ad.phone celular_cliente,
ad.address direccion_cliente, ad.district distrito_cliente, ad.postal_code codigo_postal_cliente,
ci.city as ciudad_cliente, co.country pais_cliente,
f.title titulo_pelicula, concat(st.first_name, st.last_name) as nombre_empleado
from rental r
inner join customer cu on cu.customer_id = r.customer_id
inner join inventory i on i.inventory_id = r.inventory_id
inner join film f on f.film_id = i.film_id
inner join staff st on st.staff_id = r.staff_id
inner join address ad on ad.address_id = cu.address_id 
inner join city ci on ci.city_id = ad.city_id
inner join country co on co.country_id = ci.country_id
where r.rental_date >='2005-07-31' and r.rental_date < '2005-08-01'
order by r.rental_date asc