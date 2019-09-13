CREATE TABLE Registros_Trabajo(
Codigo INT,
Fecha DATE,
Hora TIME,
Opcion VARCHAR(50)
);

CREATE TABLE Registros_Comida(
Codigo INT,
Fecha DATE,
Hora TIME,
Opcion VARCHAR(50)
);

CREATE TABLE Computos_Trabajo(
Codigo INT,
Fecha DATE,
Minutos FLOAT,
Horas FLOAT
);

CREATE TABLE Computos_Comida(
Codigo INT,
Fecha DATE,
Minutos FLOAT,
Horas FLOAT
);

CREATE TABLE Empleados(
Codigo INT,
Nombre VARCHAR(50),
Email VARCHAR(100),
PRIMARY KEY(Codigo)
);
INSERT INTO Empleados VALUES(30001, 'Cristian López', 'clopez@theforestnext.com');
INSERT INTO Empleados VALUES(30002, 'Gemma Sanjuan', 'gsanjuan@theforestnext.com');
INSERT INTO Empleados VALUES(30004, 'Vanesa Martínez', 'tecniclab@theforestnext.com');
INSERT INTO Empleados VALUES(30005, 'Jorge Fernández', 'jfernandez@theforestnext.com');
INSERT INTO Empleados VALUES(30010, 'Albert Lorenzo', 'alorenzo@theforestnext.com');
INSERT INTO Empleados VALUES(30011, 'Jorge Giménez', 'jgimenez@theforestnext.com');
INSERT INTO Empleados VALUES(30012, 'Raúl Hernández', 'rhernandez@theforestnext.com');
INSERT INTO Empleados VALUES(30013, 'Paula Cortés', 'pcortes@theforestnext.com');
INSERT INTO Empleados VALUES(11111, 'Prueba Prueba', 'jgimenez@theforestnext.com');


SELECT * FROM Registros_Trabajo;
SELECT * FROM Registros_Comida;
SELECT * FROM Computos_Trabajo;
SELECT * FROM Computos_Comida;
SELECT * FROM Empleados;