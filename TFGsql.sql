-- Crear la base de datos
DROP DATABASE IF EXISTS Optistock;
CREATE DATABASE Optistock;
USE Optistock;

-- Crear la tabla categorias
CREATE TABLE categorias (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    Nombre VARCHAR(100) NOT NULL UNIQUE
);

-- Crear la tabla productos con relación a categorias
CREATE TABLE productos (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    Nombre VARCHAR(255) NOT NULL,
    Precio FLOAT(10, 2) NOT NULL,
    Iva FLOAT(5, 2) DEFAULT 0.00,  -- IVA como porcentaje
    PrecioTotal FLOAT(10, 2) AS (Precio + (Precio * Iva / 100)) STORED, 
    Descripcion TEXT,
    CategoriaId INT,  
    Stock INT DEFAULT 0,
    StockInicial INT DEFAULT 0,
    Imagen VARCHAR(255),
    FechaCreacion DATETIME DEFAULT CURRENT_TIMESTAMP,
    Descuento FLOAT(5, 2) DEFAULT 0.00,
    EAN VARCHAR(13) UNIQUE,
    Marca VARCHAR(30),
    Modelo VARCHAR(30),
    CantidadMaxima INT NULL,
    CantidadMinima INT NULL,
    FOREIGN KEY (CategoriaId) REFERENCES categorias(Id) 
);

CREATE TABLE Ubicaciones (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    ProductoId INT NOT NULL,
    Nombre VARCHAR (20),
    FOREIGN KEY (ProductoId) REFERENCES productos(Id)
);

DELETE FROM Ubicaciones;
SET SQL_SAFE_UPDATES = 0;
DELETE FROM inventario WHERE UbicacionId IN (SELECT Id FROM Ubicaciones);


CREATE TABLE inventario (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    ProductoId INT NOT NULL,
    UbicacionId INT NOT NULL,
    Cantidad INT NOT NULL,
    UltimoInventario DATETIME DEFAULT CURRENT_TIMESTAMP,
    Recuento INT NOT NULL DEFAULT 0,
    UbicacionRecuento VARCHAR(50) NOT NULL,
    FOREIGN KEY (ProductoId) REFERENCES productos(Id),
    FOREIGN KEY (UbicacionId) REFERENCES Ubicaciones(Id)
);


CREATE TABLE Movimientos (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    ProductoId VARCHAR (20) NOT NULL,
    FechaMovimiento DATETIME DEFAULT CURRENT_TIMESTAMP,
    TipoMovimiento VARCHAR(50) NOT NULL,  -- Cambiado a VARCHAR
    Cantidad INT NOT NULL,
    FOREIGN KEY (ProductoId) REFERENCES productos(EAN)
);

CREATE TABLE MovimientosWeb (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    ProductoEAN VARCHAR (20) NOT NULL,
    FechaMovimiento DATETIME DEFAULT CURRENT_TIMESTAMP,
    TipoMovimiento VARCHAR(50) NOT NULL,  -- Cambiado a VARCHAR
    Cantidad INT NOT NULL,
    FOREIGN KEY (ProductoEAN) REFERENCES productos(EAN)
);

CREATE TABLE clienteweb (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    Nombre VARCHAR(255) NOT NULL,
    Apellido VARCHAR(255) NOT NULL,
    Direccion VARCHAR(255) NOT NULL,
    Ciudad VARCHAR(255) NOT NULL,
    Correo VARCHAR(255) NOT NULL,
    Contraseña VARCHAR(255) NOT NULL
);

CREATE TABLE pedidos_web (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    NumeroPedido VARCHAR(20) NOT NULL,
    ClienteWebId INT NOT NULL,
    PrecioTotal FLOAT(10, 2) NOT NULL,
    FechaPedido DATETIME DEFAULT CURRENT_TIMESTAMP,
    Estado VARCHAR(50) DEFAULT 'Pendiente',
    FOREIGN KEY (ClienteWebId) REFERENCES clienteweb(Id)
);

CREATE TABLE detalle_pedido (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    PedidoId INT NOT NULL,
    ProductoId INT NOT NULL,
    Cantidad INT NOT NULL,
    FOREIGN KEY (PedidoId) REFERENCES pedidos_web(Id),
    FOREIGN KEY (ProductoId) REFERENCES productos(Id)
);

CREATE TABLE Trabajadores (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    NombreCompleto VARCHAR(100) NOT NULL,
    FechaNacimiento DATE NOT NULL,
    DNI VARCHAR(20) NOT NULL UNIQUE,
    Telefono VARCHAR(15),
    Email VARCHAR(100),
    Direccion VARCHAR(255),
    FechaContratacion DATE NOT NULL,
    Salario DECIMAL(10, 2) NOT NULL,
    Usuario VARCHAR(50) NOT NULL UNIQUE,
    Contraseña VARCHAR(255) NOT NULL,
    NumeroSeguridadSocial VARCHAR(20) NOT NULL,
	CategoriaProfesional INT NOT NULL,
    Departamento VARCHAR(100) NOT NULL
);
select * from trabajadores;

CREATE TABLE Vacaciones (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    TrabajadorId INT NOT NULL,
    FechaInicio DATE NOT NULL,
    FechaFin DATE NOT NULL,
    DiasTotales INT NOT NULL,
    FOREIGN KEY (TrabajadorId) REFERENCES Trabajadores(Id)
);

-- Crear tabla Nomina
CREATE TABLE Nomina (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    TrabajadorId INT,
    Mes VARCHAR(20),
    Anio INT,
    SalarioBruto DECIMAL(10, 2) NOT NULL,
    Deducciones DECIMAL(10, 2) NOT NULL,
    SalarioNeto DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (TrabajadorId) REFERENCES Trabajadores(Id)
);

CREATE TABLE clientes (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    NombreCompleto VARCHAR(255) NOT NULL,
    FechaNacimiento DATE NOT NULL,
    DNI VARCHAR(20) NOT NULL UNIQUE,
    Telefono VARCHAR(15),
    Email VARCHAR(100),
    Direccion VARCHAR(255),
    Ciudad VARCHAR(100),
    FechaAlta DATETIME DEFAULT CURRENT_TIMESTAMP
);



CREATE TABLE Ventas (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    DniCliente VARCHAR(15) NOT NULL,
    NumeroDocumento VARCHAR(20) NOT NULL UNIQUE,  -- Número de documento (ticket/factura)
    Fecha DATETIME DEFAULT CURRENT_TIMESTAMP,
    Total DECIMAL(10, 2) NOT NULL
);

CREATE TABLE HistorialVentas (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    NumeroDocumento VARCHAR(20) NOT NULL,
    Producto VARCHAR(13) NOT NULL,
    Cantidad INT NOT NULL,
    FOREIGN KEY (NumeroDocumento) REFERENCES Ventas(NumeroDocumento) ON DELETE CASCADE,
    FOREIGN KEY (Producto) REFERENCES productos(EAN) ON DELETE CASCADE
);

CREATE TABLE Devoluciones (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    DniCliente VARCHAR(15) NOT NULL,
    NumeroDocumento VARCHAR(20) NOT NULL,
    Motivo VARCHAR(255),
    Fecha DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE DetalleDevolucion (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    DevolucionId INT NOT NULL,
    ProductoId VARCHAR(13) NOT NULL,
    Cantidad INT NOT NULL,
    FOREIGN KEY (DevolucionId) REFERENCES Devoluciones(Id) ON DELETE CASCADE,
    FOREIGN KEY (ProductoId) REFERENCES Productos(EAN) ON DELETE CASCADE
);

CREATE TABLE OrdenesDeCompra (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    NumeroOrden VARCHAR(20) NOT NULL,
    Proveedor VARCHAR(100) NOT NULL,
    Estado VARCHAR(20) NOT NULL,
    FechaApertura DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE DetallesOrdenDeCompra (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    OrdenDeCompraId INT NOT NULL,
    ProductoId INT NOT NULL,
    EAN VARCHAR(13) NOT NULL,
    Cantidad INT NOT NULL,
    PrecioUnitario DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (OrdenDeCompraId) REFERENCES OrdenesDeCompra(Id),
    FOREIGN KEY (ProductoId) REFERENCES productos(Id)
);

CREATE TABLE Proveedores (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    Nombre VARCHAR(255) NOT NULL,
    Contacto VARCHAR(255) NOT NULL,
    Telefono VARCHAR(20),
    Email VARCHAR(100),
    Direccion VARCHAR(255),
    Ciudad VARCHAR(100),
    Provincia VARCHAR(100),
    CodigoPostal VARCHAR(10),
    Pais VARCHAR(100),
    TipoProveedor VARCHAR(100),
    Notas TEXT,
    SitioWeb VARCHAR(255),
    FechaRegistro DATETIME DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY unique_nombre (Nombre)
);




describe pedidos_web;
select*from clienteweb;
select*from detalle_pedido;
select*from pedidos_web;
select*from productos;
select*from categorias;
select*from ventas;
select*from HistorialVentas;
select*from OrdenesDeCompra;
select*from DetallesOrdenDeCompra;

-- Insertar datos en la tabla categorias
INSERT INTO categorias (Nombre) VALUES
('Papelería'),
('Hogar y Baño'),
('Juguetes'),
('Navidad'),
('Decoración'),
('Hostelería'),
('Disfraces'),
('Bazar'),
('Alimentación');  -- Nueva categoría

INSERT INTO productos (Nombre, Precio, Iva, Descripcion, CategoriaId, Stock, StockInicial, Imagen, Descuento, EAN, Marca, Modelo) VALUES
-- Papelería
('Mochila 33x14x42cm Vaiana', 25.00, 21.00, 'Mochila de 33x14x42 cm con diseño de Vaiana, perfecta para el colegio.', 1, 150, 150, 'C:\Users\rafae\Desktop\TFGWeb\Imagenes\Papeleria\mochilavaina.jpeg', 0.00, '8412688579297', 'SAFTA', 'SAFT612442180'),
('Portatodo Triple 22x3x12cm Vaiana', 10.00, 21.00, 'Portatodo triple de 22x3x12 cm con diseño de Vaiana, ideal para lápices y útiles escolares.', 1, 200, 200, 'C:\Users\rafae\Desktop\TFGWeb\Imagenes\Papeleria\portatodotriple.jpeg', 0.00, '8412688579358', 'SAFTA', 'SAFT812442744'),
('Cuaderno 4 Lamela Forrado 3mm 80h Fucsia', 5.00, 21.00, 'Cuaderno forrado de 80 hojas, color fucsia, ideal para el colegio.', 1, 300, 300, 'C:\Users\rafae\Desktop\TFGWeb\Imagenes\Papeleria\lamelarosa.jpeg', 0.00, '8412688557325', 'LAMELA', 'LAME7CTE003F'),
('Bolígrafo Fibra 0,6mm 2U. Negro', 2.50, 21.00, 'Pack de 2 bolígrafos de fibra de 0,6 mm en color negro.', 1, 250, 250, 'C:\Users\rafae\Desktop\TFGWeb\Imagenes\Papeleria\boligrafo.jpeg', 0.00, '4007817189030', 'STAEDTLER', 'STAE3079BK210'),
('Agenda Escolar 24/25 A6 D/P Forr.CAST Yuku', 15.00, 21.00, 'Agenda escolar para el año 2024/2025, tamaño A6, con forro de cast.', 1, 100, 100, 'C:\Users\rafae\Desktop\TFGWeb\Imagenes\Papeleria\AGENDA.jpeg', 0.00, '8413623527342', 'GRAFOPLAS', 'GRAF75171354'),
('Mochila 33x14x42cm Vaiana', 25.00, 21.00, 'Mochila de 33x14x42 cm con diseño de Mario, perfecta para el colegio', 1, 180, 180, 'C:\Users\rafae\Desktop\TFGWeb\Imagenes\Papeleria\mochilamario.jpeg', 0.00, '8412688579457', 'SAFTA', 'SAFT612442177'),

-- Hogar y Baño
('Dispensador de Jabón Vidrio 570ml', 15.00, 21.00, 'Dispensador de jabón de vidrio de 570ml, elegante y funcional.', 2, 100, 100, 'dispensador_jabon_vidrio.jpg', 0.00, '8434504097983', 'NAHUEL', 'NAHU9798'),
('Portarrollos Bambú Metal 66,5cm', 12.00, 21.00, 'Portarrollos de bambú con soporte de metal, altura 66,5cm.', 2, 150, 150, 'portarrollos_bambu.jpg', 0.00, '8434504095736', 'NAHUEL', 'NAHU9573'),
('Cesto para Ropa Bambú Forrado c/Tela DRK', 20.00, 21.00, 'Cesto para ropa de bambú forrado con tela oscura, ideal para el hogar.', 2, 80, 80, 'cesto_ropa_bambu.jpg', 0.00, '8434504083566', 'NAHUEL', 'NAHU8356'),
('Papelería Acero 5L c/Pedal', 25.00, 21.00, 'Papelería de acero de 5 litros con pedal, práctica y moderna.', 2, 60, 60, 'papelera_acero.jpg', 0.00, '8434504082866', 'NAHUEL', 'NAHU8286'),
('Organizador Bambú 3 Cajones', 30.00, 21.00, 'Organizador de bambú con 3 cajones, perfecto para mantener el orden.', 2, 50, 50, 'organizador_bambu.jpg', 0.00, '8434504071884', 'NAHUEL', 'NAHU7188'),
('Espejo con LEDs 19.7cm USB', 35.00, 21.00, 'Espejo de 19.7 cm con iluminación LED y conexión USB.', 2, 40, 40, 'espejo_leds.jpg', 0.00, '8434504062530', 'NAHUEL', 'NAHU6253'),

-- Alimentacion
('Yogur natural de avena AlPro', 1.50, 21.00, 'Yogur natural de avena, bajo en grasas y sin azúcares añadidos.', 9, 200, 200, 'C:\Users\rafae\Desktop\TFGWeb\Imagenes\Alimentacion\alpro.png', 0.00, '1234567890123', 'ALPRO', 'AL051152'),
('Bebida natural de avena AlPro', 1.20, 21.00, 'Bebida de avena natural, ideal para desayunos y batidos.', 9, 150, 150, 'C:\Users\rafae\Desktop\TFGWeb\Imagenes\Alimentacion\bebidaalpro.png', 0.00, '1234567890124', 'ALPRO', 'AL052156'),
('Pack 12 coca colas', 12.00, 21.00, 'Pack de 12 latas de Coca-Cola, refrescante y deliciosa.', 9, 100, 100, 'C:\Users\rafae\Desktop\TFGWeb\Imagenes\Alimentacion\Pack 12 cocacolas.png', 0.00, '1234567890125', 'COCACOLA', 'COC055226'),
('Tónica Schweppes Lata', 0.90, 21.00, 'Lata de tónica Schweppes, perfecta para cocktails.', 9, 250, 250, 'C:\Users\rafae\Desktop\TFGWeb\Imagenes\Alimentacion\Tonica.png', 0.00, '1234567890126', 'SCHWEPPES', 'SCH115108'),
('Vino Tinto Crianza Rioja', 8.50, 21.00, 'Vino tinto crianza de Rioja, con un sabor intenso y afrutado.', 9, 75, 75, 'C:\Users\rafae\Desktop\TFGWeb\Imagenes\Alimentacion\Vinotinto.png', 0.00, '1234567890127', 'TRES REINOS', 'REI68189'),
('Agua Mineral 1.5L', 0.50, 21.00, 'Botella de agua mineral de 1.5 litros, refrescante y pura.', 9, 300, 300, 'C:\Users\rafae\Desktop\TFGWeb\Imagenes\Alimentacion\Lanjaron.png', 0.00, '1234567890128', 'LANJARON', 'LANJ058416'),

-- Hostelería
('Molde Tarta Redonda 28cm', 15.00, 21.00, 'Molde de tarta redonda de 28 cm, fabricado en material antiadherente.', 6, 100, 100, 'C:\Users\rafae\Desktop\TFGWeb\Imagenes\Molde tarta redonda 28cm.png', 0.00, '8721037085069', 'KOOPMAN', 'KOOP170489800'),
('Tabla Cortar 37x25cm', 10.00, 21.00, 'Tabla de cortar de 37x25 cm, ideal para preparar alimentos.', 6, 150, 150, 'C:\Users\rafae\Desktop\TFGWeb\Imagenes\Tabla Cortar 37x25cm.jpeg', 0.00, '8720573837545', 'KOOPMAN', 'KOOP529003330'),
('Molde Tarta Redonda 24cm', 12.00, 21.00, 'Molde de tarta redonda de 24 cm, fabricado en material antiadherente.', 6, 80, 80, 'C:\Users\rafae\Desktop\TFGWeb\Imagenes\Molde 24cm.png', 0.00, '8721037085120', 'KOOPMAN', 'KOOP170489830'),
('Bandeja Bambu 30x30cm', 20.00, 21.00, 'Bandeja de bambú de 30x30 cm, perfecta para servir.', 6, 60, 60, 'C:\Users\rafae\Desktop\TFGWeb\Imagenes\Bandeja Bambu 30x30cm.jpeg', 0.00, '8720573657556', 'KOOPMAN', 'KOOP101004340'),
('Portarollos Bambu 12.5x31.5cm', 8.00, 21.00, 'Portarollos de bambú de 12.5x31.5 cm, elegante y funcional.', 6, 90, 90, 'C:\Users\rafae\Desktop\TFGWeb\Imagenes\PORTARROLLOS BAMBU 12.5X31.5CM.jpeg', 0.00, '8721037100380', 'KOOPMAN', 'KOOP210001050'),
('Cacerola 22cm Elite C/Tapa Vidrio', 25.00, 21.00, 'Cacerola de 22 cm con tapa de vidrio, ideal para cocinar.', 6, 50, 50, 'C:\Users\rafae\Desktop\TFGWeb\Imagenes\CACEROLA 22CM ELITE TAPA VIDRIO.jpeg', 0.00, '8435092434433', 'ISOGONA', 'ISOGM240322'),

-- Bazar
('Cable Cargador USB Tipo iPhone Surtido', 1.15, 21.00, 'Cable cargador USB tipo iPhone surtido, compatible con varios modelos.', 8, 100, 100, 'C:\Users\rafae\Desktop\TFGWeb\Imagenes\Electronica\cable_iphone.jpeg', 0.00, '8720573208376', 'KOOPMAN', 'KOOPS48001096'),
('Pila Alcalina Energy AA 4U Pro Power Varta', 1.68, 21.00, 'Pack de 4 pilas Varta Energy AA, duraderas y de alta calidad.', 8, 150, 150, 'C:\Users\rafae\Desktop\TFGWeb\Imagenes\Electronica\pila_varta.jpeg', 0.00, '4008496626410', 'VARTA', 'PHIM62641'),
('Pila Alcalina 4U. AAA LR03 Pro Power Panasonic', 1.26, 21.00, 'Pack de 4 pilas alcalinas AAA LR03 Pro Power de Panasonic.', 8, 200, 200, 'C:\Users\rafae\Desktop\TFGWeb\Imagenes\Electronica\pila_panasonic.jpeg', 0.00, '5410853039006', 'PANASONIC', 'TEMPLR03PPG4BP'),
('Altavoz Bluetooth 21,5x6,9x11,7cm', 12.35, 21.00, 'Altavoz Bluetooth compacto, ideal para llevar a todas partes.', 8, 80, 80, 'C:\Users\rafae\Desktop\TFGWeb\Imagenes\Electronica\altavoz_bluetooth.jpeg', 0.00, '8435612226197', 'WEAY', 'WEAY2396030'),
('Auricular C/Cable Manos Libres HAVIT', 4.50, 21.00, 'Auriculares con cable y manos libres, sonido de alta calidad.', 8, 120, 120, 'C:\Users\rafae\Desktop\TFGWeb\Imagenes\Electronica\auriculares_havit.jpeg', 0.00, '6950676290974', 'WEAY', 'CASAH2218D'),
('Cable USB 2.0 A - Micro Negro 1m', 3.05, 21.00, 'Cable USB 2.0 tipo A a Micro USB, longitud de 1 metro.', 8, 250, 250, 'C:\Users\rafae\Desktop\TFGWeb\Imagenes\Electronica\cable_usb.jpeg', 0.00, '8412852954738', 'SIMON', 'BRICMU112201'),

-- Decoración
('Jarrón Vidrio Coloreado 12cm Surtido', 15.00, 21.00, 'Jarrón de vidrio coloreado de 12 cm, surtido en varios colores.', 5, 35, 35, 'C:\Users\rafae\Desktop\TFGWeb\Imagenes\Bazar\jarron_coloreado.jpeg', 0.00, '8721037145114', 'KOOPMAN', 'KOOPAC6310080'),
('Estantería 295X235X1065MM', 35.00, 21.00, 'Estantería de 295x235x1065 mm, ideal para organizar tu espacio.', 5, 25, 25, 'C:\Users\rafae\Desktop\TFGWeb\Imagenes\Bazar\estanteria.jpeg', 0.00, '8721037100595', 'KOOPMAN', 'KOOPDD1000680'),
('Vela LED 15CM Blanca', 12.00, 21.00, 'Vela LED blanca de 15 cm, perfecta para crear ambiente.', 5, 15, 15, 'C:\Users\rafae\Desktop\TFGWeb\Imagenes\Bazar\vela_led.jpeg', 0.00, '8721037242189', 'KOOPMAN', 'KOOPAX5383480'),
('Plato Madera de Mango 38CM', 10.00, 21.00, 'Plato de madera de mango de 38 cm, ideal para servir.', 5, 52, 52, 'C:\Users\rafae\Desktop\TFGWeb\Imagenes\Bazar\plato_madera.jpeg', 0.00, '8721037121453', 'KOOPMAN', 'KOOPA54413140'),
('Portavela Bambú 21X33CM', 8.00, 21.00, 'Portavela de bambú de 21x33 cm, elegante y natural.', 5, 50, 50, 'C:\Users\rafae\Desktop\TFGWeb\Imagenes\Bazar\portavela_bambu.jpeg', 0.00, '8720573951807', 'KOOPMAN', 'KOOP435105500'),
('Zapatilla Surtida', 5.00, 21.00, 'Zapatilla surtida, cómoda y versátil para el hogar.', 5, 12, 12, 'C:\Users\rafae\Desktop\TFGWeb\Imagenes\Bazar\zapatilla_surtida.jpeg', 0.00, '8721037047845', 'KOOPMAN', 'KOOPHZ1993140'),

-- Disfraces
('DISFRAZ PAJE MELCHOR XL', 30.00, 21.00, 'Disfraz de Paje Melchor, talla XL.', 7, 12, 12, 'C:\Users\rafae\Desktop\TFGWeb\Imagenes\Disfraces\disfraz_paje_melchor.jpeg', 0.00, '8435413480828', 'KIMOKAWAII', 'BANY8082'),
('DISFRAZ PAJE GASPAR XL', 30.00, 21.00, 'Disfraz de Paje Gaspar, talla XL.', 7, 6, 6, 'C:\Users\rafae\Desktop\TFGWeb\Imagenes\Disfraces\disfraz_paje_gaspar.jpeg', 0.00, '8435413480866', 'KIMOKAWAII', 'BANY8086'),
('DISFRAZ PAJE BALTASAR XL', 30.00, 21.00, 'Disfraz de Paje Baltasar, talla XL.', 7, 3, 3, 'C:\Users\rafae\Desktop\TFGWeb\Imagenes\Disfraces\disfraz_paje_baltasar.jpeg', 0.00, '8435413480903', 'KIMOKAWAII', 'BANY8090'),

-- Juguetes
('PELUCHE CERDITO VAIANA PUA 25CM', 15.00, 21.00, 'Peluche de cerdito de Vaiana, 25 cm.', 3, 10, 10, 'C:\Users\rafae\Desktop\TFGWeb\Imagenes\Juguetes\peluche_cerdito.jpeg', 0.00, '5400868031294', 'SIMBA', 'SIMB6315870476'),
('PELUCHE GALLO VAIANA HEI HEI 25CM', 15.00, 21.00, 'Peluche de gallo de Vaiana, Hei Hei, 25 cm.', 3, 20, 20, 'C:\Users\rafae\Desktop\TFGWeb\Imagenes\Juguetes\peluche_gallo.jpeg', 0.00, '5400868031300', 'SIMBA', 'SIMB6315870475'),
('PELUCHE STITCH CORAZONES 25CM', 15.00, 21.00, 'Peluche de Stitch con corazones, 25 cm.', 3, 16, 16, 'C:\Users\rafae\Desktop\TFGWeb\Imagenes\Juguetes\peluche_stitch.jpeg', 0.00, '5400868031690', 'SIMBA', 'SIMB6315870193'),
('HELICOPTERO POLICIA LUCES Y SONIDOS AZUL', 19.00, 21.00, 'Helicóptero de policía con luces y sonidos, color azul.', 3, 31, 31, 'C:\Users\rafae\Desktop\TFGWeb\Imagenes\Juguetes\helicoptero_policia.jpeg', 0.00, '8445276523709', 'PASTOR S.L', 'ETES369000090904'),
('HELICOPTERO RESCATE LUCES Y SONIDOS AMARILLO', 19.00, 21.00, 'Helicóptero de rescate con luces y sonidos, color amarillo.', 3, 22, 22, 'C:\Users\rafae\Desktop\TFGWeb\Imagenes\Juguetes\helicoptero_rescate.jpeg', 0.00, '8445276523716', 'PASTOR S.L', 'ETES369000090905'),
('HELICOPTERO DE BOMBEROS LUCES Y SONIDOS ROJO', 19.00, 21.00, 'Helicóptero de bomberos con luces y sonidos, color rojo.', 3, 7, 7, 'C:\Users\rafae\Desktop\TFGWeb\Imagenes\Juguetes\helicoptero_bomberos.jpeg', 0.00, '8445276523723', 'PASTOR S.L', 'ETES369000090906'),

-- Decoración de Navidad
('PELUCHE RENO NAVIDAD', 20.00, 21.00, 'Peluche de reno para Navidad, modelo KOOPAAD500040.', 4, 50, 50, 'C:\Users\rafae\Desktop\TFGWeb\Imagenes\Navidad\peluche_retro_navidad.jpeg', 0.00, '8721037157803', 'KOOPMAN', 'KOOPAAD500040'),
('PELUCHE NIÑA NAVIDAD 10X4,5X7CM SURTIDO', 15.00, 21.00, 'Peluche de niña navideña, surtido, 10x4,5x7 cm.', 4, 30, 30, 'C:\Users\rafae\Desktop\TFGWeb\Imagenes\Navidad\peluche_nina_navidad.jpeg', 0.00, '8435612249431', 'WE AND YOU', 'WEAY2680017'),
('DECORACION NAVIDAD MERRY CHRISTMAS 16X4X29CM SURTIDO', 25.00, 21.00, 'Decoración navideña "Merry Christmas", 16x4x29 cm, surtido.', 4, 40, 40, 'C:\Users\rafae\Desktop\TFGWeb\Imagenes\Navidad\decoracion_navidad_merry_christmas.jpeg', 0.00, '8435612249448', 'WE AND YOU', 'WEAY268005503'),
('CORONA PORTAVELAS 6,5X19CM', 18.00, 21.00, 'Corona portavelas para decoración navideña, 6,5x19 cm.', 4, 25, 25, 'C:\Users\rafae\Desktop\TFGWeb\Imagenes\Navidad\corona_portavelas.jpeg', 0.00, '8435612249516', 'WE AND YOU', 'WEAY2680470'),
('CONJUNTO CASTILLO 30X18X22CM', 30.00, 21.00, 'Conjunto de castillo para decoración navideña, 30x18x22 cm.', 4, 20, 20, 'C:\Users\rafae\Desktop\TFGWeb\Imagenes\Navidad\conjunto_castillo.jpeg', 0.00, '8436535067546', 'TOLEDANO PEREZ S.L', 'TOLE1754'),
('MUÑECO NAVIDAD2 60X12CM', 22.00, 21.00, 'Muñeco de Navidad, 60x12 cm.', 4, 15, 15, 'C:\\Users\\rafae\\Desktop\\TFGWeb\\Imagenes\\Navidad\\muneco_navidad.jpeg', 0.00, '8435612250086', 'WE AND YOU', 'WEAY2999021');




-- Insertar datos en la tabla Trabajadores
INSERT INTO Trabajadores (NombreCompleto, FechaNacimiento, DNI, Telefono, Email, Direccion, FechaContratacion, Salario, Usuario, Contraseña) VALUES
('Juan Pérez', '1985-06-15', '12345678A', '612345678', 'juan.perez@example.com', 'Calle Falsa 123', '2020-01-01', 2000.00, 'juan.perez', 'hashed_password_1'),
('María López', '1990-02-20', '87654321B', '623456789', 'maria.lopez@example.com', 'Avenida Siempre Viva 456', '2019-03-15', 2500.00, 'maria.lopez', 'hashed_password_2'),
('Carlos García', '1988-11-30', '23456789C', '634567890', 'carlos.garcia@example.com', 'Plaza Mayor 789', '2021-05-25', 1800.00, 'carlos.garcia', 'hashed_password_3');

INSERT INTO trabajadores (NombreCompleto, FechaNacimiento, DNI, Telefono, Email, Direccion, FechaContratacion, Salario, Usuario, Contraseña, NumeroSeguridadSocial, CategoriaProfesional)
VALUES 
('Juan García Perez', '1985-06-15', '16345678A', '612345678', 'juan.perez2@example.com', 'Calle Falsa 123', '2020-01-10', 3000.00, 'juan.perez2', 'admin1234', '1234567890', 5),
('María Fernández López', '1990-02-20', '87154321B', '623456789', 'maria.lope2z@example.com', 'Avenida Siempre Viva 742', '2019-03-15', 3200.00, 'maria.lopez2', 'admin1234', '0987654321', 8),
('Carlos Sánchez Ruiz', '1988-11-30', '23446789C', '634567890', 'carlos.sanchez@example.com', 'Calle Verdadera 456', '2021-05-20', 2800.00, 'carlos.sanchez', 'admin1234', '1122334455', 3),
('Ana Torres Martín', '1995-09-25', '34567890D', '645678901', 'ana.torres@example.com', 'Paseo del Río 789', '2022-07-30', 3100.00, 'ana.torres', 'admin1234', '2233445566', 2),
('Luis Gómez Pérez', '1982-01-12', '45678901E', '656789012', 'luis.gomez@example.com', 'Calle del Sol 101', '2018-12-05', 3500.00, 'luis.gomez', 'admin1234', '3344556677', 7);


INSERT INTO Trabajadores (NombreCompleto, FechaNacimiento, DNI, Telefono, Email, Direccion, FechaContratacion, Salario, Usuario, Contraseña, NumeroSeguridadSocial, CategoriaProfesional, Departamento)
VALUES
('Sofía Rodríguez Gómez', '1992-04-18', '56789012F', '678901234', 'sofia.rodriguez@example.com', 'Calle Mayor 567', '2021-09-01', 2900.00, 'sofia.rodriguez', 'admin1234', '4455667788', 4, 'Almacén'),
('Pedro Martínez Sánchez', '1985-11-22', '67890123G', '689012345', 'pedro.martinez@example.com', 'Avenida del Parque 321', '2020-02-15', 3300.00, 'pedro.martinez', 'admin1234', '5566778899', 6, 'Gerencia'),
('Laura Fernández Díaz', '1988-07-05', '78901234H', '690123456', 'laura.fernandez@example.com', 'Calle del Río 654', '2022-04-01', 2700.00, 'laura.fernandez', 'admin1234', '6677889900', 3, 'Almacén'),
('Miguel Gómez Torres', '1993-02-28', '89012345I', '601234567', 'miguel.gomez@example.com', 'Paseo de la Playa 789', '2019-06-10', 3100.00, 'miguel.gomez', 'admin1234', '7788990011', 5, 'Gerencia'),
('Natalia Sánchez Díez', '1991-09-14', '90123456J', '612345678', 'natalia.sanchez@example.com', 'Calle de la Fuente 321', '2023-01-01', 2800.00, 'natalia.sanchez', 'admin1234', '8899001122', 4, 'Almacén');



INSERT INTO Nomina (TrabajadorId, Mes, Anio, SalarioBruto, Deducciones, SalarioNeto) VALUES
(1, 'Enero', 2024, 2000.00, 300.00, 1700.00),
(2, 'Enero', 2024, 2500.00, 400.00, 2100.00),
(3, 'Enero', 2024, 1800.00, 250.00, 1550.00);

INSERT INTO Nomina (TrabajadorId, Mes, Anio, SalarioBruto, Deducciones, SalarioNeto)
VALUES 
(1, 'Enero', 2024, 3000.00, 300.00, 2700.00),
(2, 'Enero', 2024, 3200.00, 320.00, 2880.00),
(3, 'Enero', 2024, 2800.00, 280.00, 2520.00),
(4, 'Enero', 2024, 3100.00, 310.00, 2790.00),
(5, 'Enero', 2024, 3500.00, 350.00, 3150.00);

INSERT INTO Nomina (TrabajadorId, Mes, Anio, SalarioBruto, Deducciones, SalarioNeto)
VALUES 
(1, 'Febrero', 2024, 3000.00, 300.00, 2700.00),
(1, 'Marzo', 2024, 3000.00, 300.00, 2700.00),
(1, 'Abril', 2024, 3000.00, 300.00, 2700.00),
(2, 'Febrero', 2024, 3200.00, 320.00, 2880.00),
(2, 'Marzo', 2024, 3200.00, 320.00, 2880.00),
(2, 'Abril', 2024, 3200.00, 320.00, 2880.00),
(3, 'Febrero', 2024, 2800.00, 280.00, 2520.00),
(3, 'Marzo', 2024, 2800.00, 280.00, 2520.00),
(3, 'Abril', 2024, 2800.00, 280.00, 2520.00),
(4, 'Febrero', 2024, 3100.00, 310.00, 2790.00),
(4, 'Marzo', 2024, 3100.00, 310.00, 2790.00),
(4, 'Abril', 2024, 3100.00, 310.00, 2790.00),
(5, 'Febrero', 2024, 3500.00, 350.00, 3150.00),
(5, 'Marzo', 2024, 3500.00, 350.00, 3150.00),
(5, 'Abril', 2024, 3500.00, 350.00, 3150.00);

INSERT INTO clientes (NombreCompleto, FechaNacimiento, DNI, Telefono, Email, Direccion) VALUES
('Juan Pérez García', '1990-05-14', '12345678A', '612345678', 'juan.perez@example.com', 'Calle Falsa 123, Madrid'),
('María López Fernández', '1985-08-22', '87654321B', '698765432', 'maria.lopez@example.com', 'Avenida Siempre Viva 456, Barcelona'),
('Carlos Sánchez Martínez', '1992-03-30', '23456789C', '612345679', 'carlos.sanchez@example.com', 'Calle del Sol 789, Valencia'),
('Laura Gómez Ruiz', '1988-12-11', '34567890D', '612345670', 'laura.gomez@example.com', 'Paseo del Prado 101, Sevilla'),
('Pedro Jiménez Torres', '1995-07-19', '45678901E', '612345671', 'pedro.jimenez@example.com', 'Gran Vía 202, Zaragoza'),
('Ana María Díaz Ortega', '1993-11-05', '56789012F', '612345672', 'ana.diaz@example.com', 'Calle Mayor 303, Bilbao');

INSERT INTO Ubicaciones (Nombre) VALUES ('ALA01A01A'), ('ALA01B01A'), ('ALA02A01A'), ('ALA02B01A'), ('ALA03A01A'), ('ALA03B01A'), 
('ALA01A01B'), ('ALA01B01B'), ('ALA02A01B'), ('ALA02B01B'), ('ALA03A01B'), ('ALA03B01B'), ('ALA01A01C'), ('ALA01B01C'), 
('ALA02A01C'), ('ALA02B01C'), ('ALA03A01C'), ('ALA03B01C'), ('ALA01A02A'), ('ALA01B02A'), ('ALA02A02A'), ('ALA02B02A'), 
('ALA03A02A'), ('ALA03B02A'), ('ALA01A02B'), ('ALA01B02B'), ('ALA02A02B'), ('ALA02B02B'), ('ALA03A02B'), ('ALA03B02B'), 
('ALA01A02C'), ('ALA01B02C'), ('ALA02A02C'), ('ALA02B02C'), ('ALA03A02C'), ('ALA03B02C'), ('ALA01A03A'), ('ALA01B03A'), 
('ALA02A03A'), ('ALA02B03A'), ('ALA03A03A'), ('ALA03B03A'), ('ALA01A03B'), ('ALA01B03B'), ('ALA02A03B'), ('ALA02B03B'), 
('ALA03A03B'), ('ALA03B03B'), ('ALA01A03C'), ('ALA01B03C'), ('ALA02A03C'), ('ALA02B03C'), ('ALA03A03C'), ('ALA03B03C'), 
('ALA01A04A'), ('ALA01B04A'), ('ALA02A04A'), ('ALA02B04A'), ('ALA03A04A'), ('ALA03B04A'), ('ALA01A04B'), ('ALA01B04B'), 
('ALA02A04B'), ('ALA02B04B'), ('ALA03A04B'), ('ALA03B04B'), ('ALA01A04C'), ('ALA01B04C'), ('ALA02A04C'), ('ALA02B04C'), 
('ALA03A04C'), ('ALA03B04C'), ('ALA01A05A'), ('ALA01B05A'), ('ALA02A05A'), ('ALA02B05A'), ('ALA03A05A'), ('ALA03B05A'), 
('ALA01A05B'), ('ALA01B05B'), ('ALA02A05B'), ('ALA02B05B'), ('ALA03A05B'), ('ALA03B05B'), ('ALA01A05C'), ('ALA01B05C'), 
('ALA02A05C'), ('ALA02B05C'), ('ALA03A05C'), ('ALA03B05C'), ('ALA01A06A'), ('ALA01B06A'), ('ALA02A06A'), ('ALA02B06A'), 
('ALA03A06A'), ('ALA03B06A'), ('ALA01A06B'), ('ALA01B06B'), ('ALA02A06B'), ('ALA02B06B'), ('ALA03A06B'), ('ALA03B06B'), 
('ALA01A06C'), ('ALA01B06C'), ('ALA02A06C'), ('ALA02B06C'), ('ALA03A06C'), ('ALA03B06C'), ('ALA01A07A'), ('ALA01B07A'), 
('ALA02A07A'), ('ALA02B07A'), ('ALA03A07A'), ('ALA03B07A'), ('ALA01A07B'), ('ALA01B07B'), ('ALA02A07B'), ('ALA02B07B'), 
('ALA03A07B'), ('ALA03B07B'), ('ALA01A07C'), ('ALA01B07C'), ('ALA02A07C'), ('ALA02B07C'), ('ALA03A07C'), ('ALA03B07C'), 
('ALA01A08A'), ('ALA01B08A'), ('ALA02A08A'), ('ALA02B08A'), ('ALA03A08A'), ('ALA03B08A'), ('ALA01A08B'), ('ALA01B08B'), 
('ALA02A08B'), ('ALA02B08B'), ('ALA03A08B'), ('ALA03B08B'), ('ALA01A08C'), ('ALA01B08C'), ('ALA02A08C'), ('ALA02B08C'), 
('ALA03A08C'), ('ALA03B08C'), ('ALA01A09A'), ('ALA01B09A'), ('ALA02A09A'), ('ALA02B09A'), ('ALA03A09A'), ('ALA03B09A'), 
('ALA01A09B'), ('ALA01B09B'), ('ALA02A09B'), ('ALA02B09B'), ('ALA03A09B'), ('ALA03B09B'), ('ALA01A09C'), ('ALA01B09C'), 
('ALA02A09C'), ('ALA02B09C'), ('ALA03A09C'), ('ALA03B09C'), ('ALA04A01A');

INSERT INTO Proveedores (Nombre, Contacto, Telefono, Email, Direccion, Ciudad, Provincia, CodigoPostal, Pais, TipoProveedor, Notas, SitioWeb) VALUES
('SAFTA', 'Paco Encina', '+34 91 123 4567', 'info@safta.com', 'Calle Industria 45', 'Madrid', 'Madrid', '28001', 'España', 'Papelería', 'Proveedor de mochilas y material escolar', 'www.safta.com'),
('LAMELA', 'Ana Morales Ruiz', '+34 96 456 7890', 'contacto@lamela.es', 'Polígono Industrial El Pla', 'Valencia', 'Valencia', '46520', 'España', 'Papelería', 'Especialistas en cuadernos y material de oficina', 'www.lamela.es'),
('STAEDTLER', 'Carlos Fernández López', '+34 93 789 0123', 'ventas@staedtler.es', 'Avda. Diagonal 123', 'Barcelona', 'Barcelona', '08036', 'España', 'Material de Oficina', 'Fabricante líder de material de escritura', 'www.staedtler.es'),
('GRAFOPLAS', 'María Jiménez García', '+34 91 234 5678', 'comercial@grafoplas.com', 'Calle Tecnología 22', 'Madrid', 'Madrid', '28108', 'España', 'Papelería', 'Proveedor de agendas y material escolar', 'www.grafoplas.com'),
('NAHUEL', 'Javier Rodríguez Martín', '+34 95 567 8901', 'info@nahuel.com', 'Polígono Industrial Sur', 'Sevilla', 'Sevilla', '41020', 'España', 'Hogar y Decoración', 'Especialistas en productos para el hogar', 'www.nahuel.com'),
('ALPRO', 'Laura Sánchez Pérez', '+34 93 345 6789', 'contacto@alpro.es', 'Carrer de la Indústria 15', 'Barcelona', 'Barcelona', '08820', 'España', 'Alimentación', 'Proveedor de productos vegetales y lácteos', 'www.alpro.com'),
('COCACOLA', 'David Martínez Torres', '+34 91 678 9012', 'ventas@cocacola.es', 'Avda. de Europa 1', 'Alcobendas', 'Madrid', '28108', 'España', 'Bebidas', 'Embotelladora líder mundial', 'www.cocacola.es'),
('SCHWEPPES', 'Elena González Díaz', '+34 93 890 1234', 'comercial@schweppes.es', 'Passeig de Gràcia 55', 'Barcelona', 'Barcelona', '08007', 'España', 'Bebidas', 'Especialistas en bebidas carbonatadas', 'www.schweppes.es'),
('TRES REINOS', 'Miguel Álvarez Romero', '+34 95 901 2345', 'info@tresreinos.com', 'Calle Bodega 33', 'Jerez de la Frontera', 'Cádiz', '11402', 'España', 'Alimentación', 'Bodega tradicional de vinos', 'www.tresreinos.com'),
('LANJARON', 'Sofía Navarro Herrera', '+34 95 678 9012', 'contacto@lanjaron.com', 'Carretera de Sierra Nevada', 'Lanjarón', 'Granada', '18420', 'España', 'Bebidas', 'Embotelladora de agua mineral', 'www.lanjaron.com'),
('KOOPMAN', 'Alejandro Ruiz Gómez', '+34 91 234 5678', 'ventas@koopman.es', 'Calle Comercio 44', 'Madrid', 'Madrid', '28001', 'España', 'Decoración y Hogar', 'Proveedor de artículos para el hogar y decoración', 'www.koopman.es'),
('PASTOR S.L', 'Isabel Molina Campos', '+34 96 345 6789', 'comercial@pastor.com', 'Polígono Industrial Norte', 'Valencia', 'Valencia', '46520', 'España', 'Juguetes', 'Especialistas en juguetes infantiles', 'www.pastor.com'),
('WE AND YOU', 'Raúl Torres Navarro', '+34 93 456 7890', 'info@weyou.com', 'Carrer del Comerç 22', 'Barcelona', 'Barcelona', '08036', 'España', 'Decoración', 'Proveedor de artículos decorativos', 'www.weyou.com'),
('TOLEDANO PEREZ S.L', 'Carmen Herrero Sánchez', '+34 925 12 34 56', 'contacto@toledanopeez.com', 'Polígono Industrial La Bastida', 'Toledo', 'Toledo', '45007', 'España', 'Decoración', 'Fabricantes de decoración artesanal', 'www.toledanopeez.com'),
('SIMBA', 'Sergio Díaz Martínez', '+34 93 567 8901', 'ventas@simba.es', 'Avda. Diagonal 345', 'Barcelona', 'Barcelona', '08013', 'España', 'Juguetes', 'Fabricante de peluches y juguetes', 'www.simba.es');


select*from trabajadores;
select*from categorias;
select*from clientes;
select*from ventas;
select*from HistorialVentas;

delete from productos;
drop table productos;

SELECT * FROM movimientos WHERE ProductoId = 'EAN_DEL_PRODUCTO';

SELECT TABLE_NAME, COLUMN_NAME 
FROM information_schema.KEY_COLUMN_USAGE 
WHERE REFERENCED_TABLE_NAME = 'productos';
