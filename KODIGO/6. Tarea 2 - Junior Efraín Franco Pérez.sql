/*
1. ¿Hay clientes que hicieron más de una renta en un solo día? Si es así, ¿quiénes son y cuántas
rentas registraron en qué días? Asegúrese de que el query está construido a prueba de clientes
homónimos, es decir, si hay dos o más clientes con los mismos nombres y apellidos en la tabla
CUSTOMER, el resultado del query no debe “confundirse” y tratarlos como si fueran un solo
cliente.
*/

/* Se agrega el customer_id, dado que es un campo único y que no puede repetirse como llave primaria, al incluirlo, se listan los clientes sin importar
que hubiesen homónimos*/
--Con el having count, se filtran solamente aquellos que cumplen con la condición: "clientes que hicieron más de una renta en un solo día"
select c.customer_id, date(r.rental_date) fecha_renta,concat(c.first_name,' ',c.last_name) Nombre_Cliente, 
count(*) total
from rental r 
inner join customer c on r.customer_id  = c.customer_id 
group by fecha_renta,c.customer_id, Nombre_Cliente
having count(*) >1
order by Nombre_Cliente,fecha_renta,c.customer_id, Nombre_Cliente

/*
2. ¿Cuántas transacciones de renta se registraron en total por mes y país del cliente?
*/

--Se agrega el año para diferenciar y no agrupar los meses en general sin diferenciar por año.
select to_char(r.rental_date, 'YYYY/MON')fecha_renta, co.country pais_cliente
, count(*)total_renta_pais
from rental r 
inner join customer c on c.customer_id = r.customer_id 
inner join address a on a.address_id =c.address_id 
inner join city ci on ci.city_id = a.city_id 
inner join country co on co.country_id =ci.country_id 
group by to_char(r.rental_date, 'YYYY/MON'), pais_cliente
order by pais_cliente, total_renta_pais desc

--Si lo anterior no fuera requerido, podríamos dejar los meses en general, sin diferenciar por años.
select to_char(r.rental_date, 'MON')fecha_renta, co.country pais_cliente
, count(*)total_renta_pais
from rental r 
inner join customer c on c.customer_id = r.customer_id 
inner join address a on a.address_id =c.address_id 
inner join city ci on ci.city_id = a.city_id 
inner join country co on co.country_id =ci.country_id 
group by to_char(r.rental_date, 'MON'), pais_cliente
order by pais_cliente,total_renta_pais desc


/*
3. ¿Cuál es el monto total pagado, desagregado por año-mes (de pago), empleado que registró el
pago y sucursal a la que pertenece? Las columnas del resultado deberán ser “Año-Mes”, “Código
de Empleado” (que sería la llave primaria de la tabla Staff), “Nombre Completo del Empleado”,
“Ciudad de la Sucursal” y “Monto Total Pagado”.
*/
select to_char(p.payment_date, 'YYYY-MON') "Año_Mes", s.staff_id "Código del Empleado", 
concat(s.first_name, ' ', s.last_name)"Nombre Completo Del Empleado", c.city "Ciudad de la Sucursal", sum(amount) "Monto Total Pagado" 
from payment p 
inner join staff s on s.staff_id =p.staff_id 
inner join store st on st.store_id = s.store_id 
inner join address a on a.address_id = st.address_id 
inner join city c on c.city_id = a.city_id 
group by "Año_Mes", "Código del Empleado", "Nombre Completo Del Empleado", "Ciudad de la Sucursal"

--Problema desafiante

/*
Muestre el número total de rentas registradas por mes. Incluya también en el mismo resultado
el monto total pagado que corresponde a las rentas de cada línea del resultado.
Note que el monto total correspondiente a cada fila del resultado no necesariamente fue pagado
en el mismo mes, pero sí corresponde a las rentas efectuadas en ese mes.
*/
select to_char(r.rental_date, 'YYYY/MON')fecha_renta,  
count(r.rental_id), sum(p.amount) 
from rental r 
inner join payment p on p.rental_id = r.rental_id 
group by fecha_renta
order by fecha_renta