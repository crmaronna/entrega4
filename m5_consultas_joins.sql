-- CONSULTA 1 --
-- Unir cada venta con los datos del cliente, del producto y su categoría. --

SELECT
v.id_venta,
    v.fecha_venta,
    c.id_cliente,
    c.nombre                            AS cliente,
    c.ciudad                            AS region,
    p.nombre_producto                   AS producto,
    cat.nombre_categoria                AS categoria,
    v.cantidad,
    v.precio_unitario,
    v.cantidad * v.precio_unitario      AS total_venta
    FROM dbo. ventas v
    INNER JOIN  dbo. clientes c         ON v. id_cliente = c. id_cliente
    INNER JOIN  dbo. productos p        ON v. id_producto = p. id_producto
    INNER JOIN  dbo. categorias cat     ON p. id_categoria = cat. id_categoria
    ORDER BY v.fecha_venta; 

    -- En base al resultado podemos ver la evoluciòn de las ventas conforme se desarrolló el mes. Tambien aquellos clientes que compraron más, su zona, y en que cantidades asi como en que montos totales. --
    

-- CONSULTA 2 --
-- Detectar clientes registrados que nunca compraron, para que CRM los contacte. --

SELECT
    c.nombre,
    c.email,
    c.fecha_registro
FROM dbo.clientes c
LEFT JOIN dbo.ventas v ON c.id_cliente = v.id_cliente
WHERE v.id_venta IS NULL
ORDER BY c.fecha_registro;

-- Ninguno de los cinco clientes quedó sin realizar una compra en el período estudiado. --


-- CONSULTA 3 --
-- Identificar artículos del catálogo sin movimiento, para que el sector comercial decida si promocionarlos o discontinuarlos. --

SELECT
    p.nombre_producto,
    cat.nombre_categoria    AS categoria,
    p.precio
FROM dbo.productos p
LEFT JOIN  dbo.ventas v       ON p.id_producto  = v.id_producto
INNER JOIN dbo.categorias cat ON p.id_categoria = cat.id_categoria
WHERE v.id_venta IS NULL
ORDER BY p.precio DESC;

-- Todos los productos del catálogo registran al menos una venta. Comercial no debe discontinuar ninguno, debemos analizar posibles promociones. --


-- CONSULTA 4 --
-- Comparar la facturación de la primera y la segunda parte de marzo 2024. La columna "canal" no existe en las tablas: se crea como texto fijo en cada SELECT. --

SELECT
    canal,
    SUM(total) AS total_canal
FROM (
    SELECT fecha_venta, cantidad * precio_unitario AS total, 'Del 1 al 10' AS canal
    FROM dbo.ventas
    WHERE fecha_venta BETWEEN '2024-03-01' AND '2024-03-10'
    UNION ALL
    SELECT fecha_venta, cantidad * precio_unitario AS total, 'Del 11 al 31' AS canal
    FROM dbo.ventas
    WHERE fecha_venta BETWEEN '2024-03-11' AND '2024-03-31'
) AS consolidado
GROUP BY canal;

-- Del 1 al 10 de marzo se facturaron 3.620 (56%) contra 2.824 del 11 en adelante; la primera parte del mes concentra más ventas. --