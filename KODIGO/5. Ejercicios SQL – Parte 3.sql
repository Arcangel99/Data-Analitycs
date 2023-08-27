/*Ejercicios SQL – Parte 3
Utilice la base de datos de ejemplo dvdrental y sus habilidades en SQL para encontrar respuestas a las
siguientes preguntas. En cada ejercicio escriba el query que de mejor manera le permita obtener sus
respuestas.*/

/*Examen preliminar de los datos – Información Descriptiva*/
/*17. ¿Cuáles son las diferentes clasificaciones (rating) de películas que están en la base de datos?*/
select rating clasificaciones from film
group by rating
order by rating asc

/*18. ¿Cuántas películas en la base de datos corresponden a cada tarifa de renta?*/
select rental_rate "Tarifa de Renta", count(rental_rate) Cantidad from film
group by rental_rate

/*19. ¿Cuántas películas están asociadas con cada género (category)?*/
select ct.name, count(f.film_id)
from film f
inner join film_category fl on fl.film_id = f.film_id
inner join category ct on ct.category_id = fl.category_id
group by ct.name

/*20. ¿En cuántas películas participa cada uno de los actores y actrices?*/
select ac.actor_id, concat(ac.first_name,' ',ac.last_name) actor, count(f.film_id)cantidad
from film f
inner join film_actor fl on fl.film_id = f.film_id
inner join actor ac on ac.actor_id = fl.actor_id
group by(ac.actor_id)
order by actor, cantidad

/*21. ¿Quiénes son los actores que tienen al menos un homónimo exacto (nombre y apellido iguales)?*/
select distinct a1.first_name, a1.last_name, count(*)
from actor a1, actor a2
where a1.actor_id <> a2.actor_id
and a1.first_name = a2.first_name
and a1.last_name = a2.last_name
group by a1.first_name, a1.last_name
order by a1.last_name, a1.first_name;

/*22. ¿Cuántos ejemplares de películas (DVDs) hay en total en la base de datos?*/
select count(inventory_id) total_ejemplares from inventory

/*23. ¿Cuántos ejemplares hay de cada película? ¿Cuáles son las películas de las que hay más
ejemplares?*/
select f.title, count(i.film_id) cantidad_ejemplar
from film f
inner join inventory i on i.film_id = f.film_id
group by i.film_id,f.film_id
order by cantidad_ejemplar desc

/*24. ¿Hay películas que tengan un solo ejemplar en existencia? Si es así, ¿cuáles son?*/
select f.title, count(i.film_id) cantidad_ejemplar
from film f
inner join inventory i on i.film_id = f.film_id
group by i.film_id,f.title
having count(i.film_id) =1
order by cantidad_ejemplar desc

/*select * from film where title ='Hawk Chill'
select * from inventory where film_id = 407
select * from inventory where inventory_id = 1866
1866*/

/*25. ¿Hay películas que no tengan ningún ejemplar en existencia? Si es así, ¿cuáles son?*/
select f.film_id, f.title
from film f
left join inventory i on f.film_id = i.film_id
where i.film_id is null ;

/*26. ¿Cuáles son los 10 países que tienen más clientes registrados en base de datos, y cuántos
clientes tiene cada uno?*/
select co.country,count(*) cantidad_clientes
from customer c
inner join address ad on ad.address_id = c.address_id
inner join city ci on ci.city_id = ad.city_id 
inner join country co on co.country_id = ci.country_id
group by co.country_id
order by cantidad_clientes desc
limit 10

/*27. ¿Hay clientes que hicieron más de una renta en un solo día? Si es así, ¿quiénes son y cuántas
rentas registraron en qué días?*/
select rental_date::date, concat(c.first_name,' ',c.last_name), count(c.customer_id) rentas
from customer c
inner join rental r on r.customer_id = c.customer_id
group by c.customer_id, r.rental_date::date
having count(*)>1
order by rentas desc

                                              /* Análisis de los datos transaccionales – Reportes Analíticos */
											  
/*28. ¿Cuánto es el monto total pagado por fecha (fecha de pago)? Prepare el query de forma que se
pueda filtrar los resultados para ver un mes específico.*/
select payment_date::date fecha, sum(amount) Total_Pagado from payment
where extract(month from payment_date) = 2
group by payment_date::date
order by payment_date::date, Total_Pagado desc

/*29. Visualizar los montos pagados por fecha de pago es importante (para saber cuándo ingresaron
los fondos), pero también es importante ver en qué fechas ocurrieron las transacciones de renta
que generaron esos pagos (para saber cuándo se generó cada negocio del que provienen esos
fondos). Entonces cree un reporte que muestre los totales pagados por fecha de renta. Agregue
también el filtro de mes.*/
select date(r.rental_date), sum(p.amount) total from rental r
inner join payment p on p.rental_id = r.rental_id
where extract(month from r.rental_date)=6
group by date(r.rental_date)
order by date(r.rental_date)

/*30. Modifique los dos reportes de pagos de los ejercicios anteriores para que muestren los montos
por mes en lugar de hacerlo por fecha. Retire el filtro de mes en ambos reportes.*/
--Reporte 1
select to_char(payment_date,'YYYY/MON') mes, sum(amount) Total_Pagado from payment
group by to_char(payment_date,'YYYY/MON')
order by Total_Pagado

--Reporte 2
select to_char(r.rental_date,'YYYY/MON'), sum(p.amount) total from rental r
inner join payment p on p.rental_id = r.rental_id
group by to_char(r.rental_date,'YYYY/MON')
order by total

/*31. El gerente de contenido está interesado en evaluar cuáles títulos se renta más y cuáles se rentan
menos. Cree el reporte de número de rentas por título de película, con la posibilidad de filtrar
los resultados por mes.*/
select to_char(r.rental_date,'YYYY-MON'), f.title, count(r.rental_id) total_renta
from film f
inner join inventory i on i.film_id = f.film_id
inner join rental r on r.inventory_id = i.inventory_id
where extract(month from r.rental_date)=2
group by to_char(r.rental_date,'YYYY-MON'),f.title
order by total_renta DESC

/*32. El gerente de contenido también está interesado tener un reporte que resuma o agrupe los
resultados del reporte de rentas por título. Quiere visualizar las rentas agrupadas por
clasificación de la película (rating). Cree el query para visualizar esos datos.*/

--Filtra por mes
select to_char(r.rental_date,'YYYY-MON'), f.rating, count(r.rental_id) total_renta
from film f
inner join inventory i on i.film_id = f.film_id
inner join rental r on r.inventory_id = i.inventory_id
where extract(month from r.rental_date)=8
group by to_char(r.rental_date,'YYYY-MON'),f.rating
order by total_renta desc

--En general, sin filtro por mes
select f.rating, count(r.rental_id) total_renta
from film f
inner join inventory i on i.film_id = f.film_id
inner join rental r on r.inventory_id = i.inventory_id
group by f.rating
order by total_renta desc

/*33. El gerente financiero necesita saber qué monto total de pagos es recibido por cada empleado en
cadas mes. Cree un reporte (query) que le muestre esa información.*/
select to_char(p.payment_date, 'YYYY/MON'), concat(st.first_name,' ',last_name) nombre_empleado, sum(p.amount)
from staff st
inner join payment p on p.staff_id =st.staff_id 
group by to_char(p.payment_date, 'YYYY/MON'), concat(st.first_name,' ',last_name)
order by to_char(p.payment_date, 'YYYY/MON'), concat(st.first_name,' ',last_name)

/*34. Se está evaluando el desempeño de las sucursales del negocio y el punto de partida es saber
cuántas rentas genera cada sucursal por mes. Cree el reporte que muestre esa información.
Utilice la ciudad de la sucursal para identificar a cada una en este reporte.*/
select to_char(r.rental_date,'YYYY/MON'),ci.city , count(*) Total_Rentas
from rental r 
inner join inventory i on i.inventory_id =r.inventory_id 
inner join store s on s.store_id = i.store_id 
inner join address ad on ad.address_id = s.address_id 
inner join city ci on ci.city_id = ad.city_id  
inner join customer c on c.customer_id = r.customer_id 
group by ci.city,to_char(r.rental_date,'YYYY/MON')
order by to_char(r.rental_date,'YYYY/MON'),ci.city

/*35. Al reporte de rentas por sucursal, agregue también el monto total pagado que corresponde a las
rentas realizadas en cada sucursal cada mes.*/
select to_char(r.rental_date,'YYYY/MON'),ci.city , count(*) Total_Rentas, sum(amount) Total_Pagado
from rental r 
inner join inventory i on i.inventory_id =r.inventory_id 
inner join store s on s.store_id = i.store_id 
inner join address ad on ad.address_id = s.address_id 
inner join city ci on ci.city_id = ad.city_id  
inner join customer c on c.customer_id = r.customer_id 
left join payment p on p.rental_id =r.rental_id 
group by ci.city,to_char(r.rental_date,'YYYY/MON')
order by to_char(r.rental_date,'YYYY/MON'),ci.city

/*Para los siguientes ejercicios es necesario ejecutar en su base de datos el script de creación y llenado de
las tablas adicionales de ejemplo. Busque el archivo “Script Tablas Ejemplo.sql” en el Aula Virtual,
descargue el archivo, ábralo en pgAdmin y ejecute el contenido completo del script.
Una vez completado el script, podrá ver las tablas xmpl_rental y xmpl_us_postal_codes junto con las
tablas de la base de datos original. (Después de hacer un refresh en el Object Explorer: click derecho en
el agrupador “Tables” o en el nombre de la base de datos y luego click en Refresh).
Para estos ejercicios, suponga que los datos de rentas están en la tabla xmpl_rental y no en la tabla
rental.*/


/*36. Cree un reporte que muestre todas las rentas, en order cronológico: fecha de renta, nombre y
apellido del cliente y título de la película. Asegúrese de que este reporte incluye todas las rentas
de la tabla, incluso aquellas que no tengan referencia a cliente o a película (llaves foráneas
nulas).*/ 
select xr.rental_date::date,  concat(c.first_name,' ',c.last_name) as nombre_cliente, f.title  from xmpl_rental xr 
left join customer c on c.customer_id = xr.customer_id 
left join inventory i on i.inventory_id = xr.inventory_id 
left join film f on f.film_id = i.film_id 
order by xr.rental_date::date

/*37. Modifique el query del ejercicio anterior para que muestre solamente las rentas que no tienen
referencia a un cliente o a una película.*/
select xr.rental_date::date,  concat(c.first_name,' ',c.last_name) as nombre_cliente, f.title  from xmpl_rental xr 
left join customer c on c.customer_id = xr.customer_id 
left join inventory i on i.inventory_id = xr.inventory_id 
left join film f on f.film_id = i.film_id 
where c.customer_id is null or f.film_id is null
order by xr.rental_date::date

/*38. Modifique el query original para que muestre ‘N/A’ en lugar de NULL en la columna del título de
la película para las filas de renta que no tengan referencia a película. Sugerencia: investigue la
utilización de la función COALESCE() para usarla en la cláusula SELECT.*/
select xr.rental_date::date,  concat(c.first_name,' ',c.last_name) as nombre_cliente, COALESCE(f.title,'N/A')Titulo_Pelicula
from xmpl_rental xr 
left join customer c on c.customer_id = xr.customer_id 
left join inventory i on i.inventory_id = xr.inventory_id 
left join film f on f.film_id = i.film_id 
order by xr.rental_date::date

/*39. Cree un reporte que muestre todos los pagos realizados, en orden cronológico, incluyendo fecha
de pago, y nombre y apellido del cliente. El gerente de mercadeo ha pedido que al reporte se
agregue el estado de Estados Unidos vinculado a la dirección de cada cliente. Esta información se
encuentra en una tabla auxiliar llamada xmpl_us_postal_codes: por cada código postal en esa
tabla se especifica el estado al cual pertenece. Puede hacer el vínculo de esta tabla auxiliar
utilizando la columna postal_code de la tabla address, pero tenga en cuenta que la tabla auxiliar
solamente incluye unos pocos códigos postales, y por lo tanto la columna Estado en el resultado
deberá aparecer en blanco (nulo) para todos los clientes que no tengan su código postal en la
tabla auxiliar.*/
select date(p.payment_date) Fecha_Pago, c.first_name "Nombre Cliente" , 
c.last_name "Apellido Cliente", xupc.us_state Estado
from payment p 
inner join customer c on c.customer_id = p.customer_id 
inner join address a on a.address_id = c.address_id 
left join xmpl_us_postal_codes xupc on xupc.postal_code = a.postal_code 
order by date(p.payment_date)