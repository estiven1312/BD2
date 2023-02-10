CREATE USER EP_HURTADO IDENTIFIED AS oracle DEFAULT TABLESPACE USERS TEMPORARY TABLESPACE TEMP PROFILCE DEFAULT; 



--SCRIPT PARA CREAR UN TABLESPACE 
--Un Tablespace permanente llamado EXPARCIAL y otro Tablespace temporal llamado EXPAR_TEMP

CREATE TABLESPACE EXPARCIAL DATAFILE 'C:\app\Usuario\product\21c\oradata\XE\XEPDB1\EXAPARCIAL01A.dbf' size 4M, 
'C:\app\Usuario\product\21c\oradata\XE\XEPDB1\EXAPARCIAL02A.dbf' size 6M;

CREATE TEMPORARY TABLESPACE EXPAR_TEMP TEMPFILLE 'C:\app\Usuario\product\21c\oradata\XE\XEPDB1\EXAPARCIALTEMPFILE.dbf' size 10M;





INSERT INTO alumno VALUES(1,'72257354','20200135','ESTIVEN SALVADOR', 'HURTADO SANTOS', 'INGENIERIA DE SOFTWARE',20, '13/09/2002');
INSERT INTO alumno VALUES(2, '74721664', '22225100', 'JASMIN ROSARIO', 'SANEZ PONCE', 'ARQUITECTURA', 20, '09/12/2002');
--Cómo mínimo crear las tablas de MATRICULA, DOCENTE, ALUMNO, CURSOS y EMPLEADO
CREATE TABLE ALUMNO(
    id_alumno number NOT NULL,
    dni_alumno varchar2(8) NOT NULL,
    codigo_alumno varchar2(8) NOT NULL,
    nombre_alumno varchar2(30) NOT NULL,
    apellido_alumno varchar2(30) NOT NULL,
    carrera varchar2(30) NOT NULL,
    edad number NOT NULL,
    fec_nacimiento date NOT NULL,
    CONSTRAINT PK_ALUMNO PRIMARY KEY(id_alumno)
);
INSERT INTO DOCENTE VALUES(1, '12345678', '14141515', 'JUAN', 'SAMANEZ OCAMPO', 'ELECTRONICA', 59, '18/02/1982');
INSERT INTO DOCENTE VALUES(2, '78945612', '10233802', 'MAXIMO', 'SAN ROMAN', 'FISICOQUIMICA', 45, '11/09/1990');

CREATE TABLE DOCENTE(
    id_docente number NOT NULL,
    dni_docente varchar2(8) NOT NULL,
    codigo_docente varchar2(8) NOT NULL,
    nombre_docente varchar2(30) NOT NULL,
    apellido_docente varchar2(30) NOT NULL,
    especialidad varchar2(30) NOT NULL,
    edad number NOT NULL,
    fec_nacimiento date NOT NULL,
    CONSTRAINT PK_DOCENTE PRIMARY KEY(id_docente)
);
INSERT INTO EMPLEADO VALUES(1, '14725836', '14141425', 'ERNESTO', 'CABRERA OCAMPO', 'SECRETARIA', 69, '18/02/1970');

CREATE TABLE EMPLEADO(
    id_empleado number NOT NULL,
    dni_empleado varchar2(8) NOT NULL,
    codigo_empleado varchar2(8) NOT NULL,
    nombre_empleado varchar2(30) NOT NULL,
    apellido_empleado varchar2(30) NOT NULL,
    area varchar2(30) NOT NULL,
    edad number NOT NULL,
    fec_nacimiento date NOT NULL,
    CONSTRAINT PK_EMPLEADO PRIMARY KEY(id_empleado)
);
INSERT INTO CURSO VALUES(1, 'W123B456', 'PANADERIA NUCLEAR', 6, 1);
INSERT INTO CURSO VALUES(2, 'ABCD4567', 'FISICAQUIMICA', 7, 2);
INSERT INTO CURSO VALUES(3, 'PQRZ7891', 'CAMPOS ELECTROMAGNETICOS', 7, 1);

CREATE TABLE CURSO(
    id_curso number NOT NULL,
    codigo_curso varchar2(8) NOT NULL,
    nombre_curso varchar2(30) NOT NULL,
    ciclo_curso number NOT NULL,
    id_docente number NOT NULL,
    CONSTRAINT PK_CURSO PRIMARY KEY(id_curso),
    CONSTRAINT FK_DOCENTE FOREIGN KEY(id_docente) REFERENCES DOCENTE(id_docente)
);


CREATE TABLE MATRICULA(
    id_matricula number NOT NULL,
    codigo_matricula varchar2(10) NOT NULL,
    id_curso number NOT NULL,
    id_alumno number NOT NULL,
    id_empleado number NOT NULL,
    fecha_matricula date NOT NULL,
    CONSTRAINT PK_MATRICULA PRIMARY KEY(id_matricula),
    CONSTRAINT FK_CURSO FOREIGN KEY(id_curso) REFERENCES CURSO(id_curso),
    CONSTRAINT FK_ALUMNO FOREIGN KEY(id_alumno) REFERENCES ALUMNO(id_alumno),
    CONSTRAINT FK_EMPLEADO FOREIGN KEY(id_empleado) REFERENCES EMPLEADO(id_empleado)
);


--Crear un procedimiento almacenado para matricular a un alumno
CREATE OR REPLACE PROCEDURE SP_MATRICULAR_ALUMNO
(
P_id_curso IN MATRICULA.id_curso%type,
P_id_alumno IN MATRICULA.id_alumno%type,
P_id_empleado IN MATRICULA.id_empleado%type
)
AS
    max_id_matricula number;
    fec_matricula date := TO_DATE(SYSDATE,'dd/mm/yyyy');
    cod_matricula varchar2(100);
BEGIN
    SELECT NVL(MAX(id_matricula),0) INTO max_id_matricula FROM MATRICULA;
    cod_matricula:=TO_CHAR(fec_matricula,'ddmmyyyy')||TO_CHAR(max_id_matricula);
    INSERT INTO MATRICULA VALUES
    (
        max_id_matricula+1,
        cod_matricula,
        P_id_curso,
        P_id_alumno,
        P_id_empleado,
        fec_matricula
    );
    COMMIT;
END SP_MATRICULAR_ALUMNO;

BEGIN
    SP_MATRICULAR_ALUMNO(2,1,1);
END;


/*
Considerando que el campo ATE_IDNUMREG de la tabla I_ATENCION (atenciones), se relaciona con el
campo ADIA_NUMREGATE de la tabla I_ATENCIONDIA (diagnósticos), responda: (06 Puntos)
a) ¿Cuáles son los diagnósticos que se repiten más de 40 veces inclusive (>=40)?
b) ¿Cuántos los registros de atenciones que tienen los diagnósticos más frecuentes (>=40)?

*/
CREATE TABLE I_ATENCIONDIA(
    id_I_ATENCIONDIA number,
    nombre varchar(20),
    CONSTRAINT PK_I_ATENCIONDIA PRIMARY KEY(id_I_ATENCIONDIA)
);

CREATE TABLE I_ATENCION(
    id_atencion number,
    fec_atencion date,
    nombre_paciente varchar2(50),
    apellido_paciente varchar2(50),
    dni_paciente varchar2(8),
    telefono_paciente varchar2(9),
    ATE_IDNUMREG number,
    CONSTRAINT PK_I_ATENCION PRIMARY KEY(id_atencion),
    CONSTRAINT FK_I_ATENCION FOREIGN KEY(ATE_IDNUMREG) REFERENCES I_ATENCIONDIA(id_I_ATENCIONDIA)
);