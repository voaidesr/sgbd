DROP TABLE finantare_restaurare CASCADE CONSTRAINTS;
DROP TABLE material_restaurare CASCADE CONSTRAINTS;
DROP TABLE expert_restaurare CASCADE CONSTRAINTS;
DROP TABLE inspectie CASCADE CONSTRAINTS;
DROP TABLE aviz CASCADE CONSTRAINTS;
DROP TABLE restaurare CASCADE CONSTRAINTS;
DROP TABLE autoritate CASCADE CONSTRAINTS;
DROP TABLE finantare CASCADE CONSTRAINTS;
DROP TABLE material CASCADE CONSTRAINTS;
DROP TABLE expert CASCADE CONSTRAINTS;
DROP TABLE monument CASCADE CONSTRAINTS;

-- 4. Implementați în Oracle diagrama conceptuală realizată: definiți toate tabelele, adăugând toate
-- constrângerile de integritate necesare (chei primare, cheile externe etc).

CREATE TABLE monument (
    id_monument NUMBER(5) CONSTRAINT pk_monument PRIMARY KEY,
    denumire    VARCHAR2(100) NOT NULL,
    locatie     VARCHAR2(100) NOT NULL
);


CREATE TABLE expert (
    id_expert    NUMBER(5) CONSTRAINT pk_expert PRIMARY KEY,
    nume         VARCHAR2(50) NOT NULL,
    specializare VARCHAR2(50) NOT NULL,
    email        VARCHAR2(100) CONSTRAINT uq_expert_email UNIQUE
);


CREATE TABLE material (
    id_material NUMBER(5) CONSTRAINT pk_material PRIMARY KEY,
    denumire    VARCHAR2(50) NOT NULL,
    clasa       VARCHAR2(20),
    risc        VARCHAR2(20)
);


CREATE TABLE finantare (
    id_finantare NUMBER(5) CONSTRAINT pk_finantare PRIMARY KEY,
    sursa        VARCHAR2(50) NOT NULL,
    buget        NUMBER(12, 2) CONSTRAINT ck_buget_pozitiv CHECK (buget > 0)
);


CREATE TABLE autoritate (
    id_autoritate NUMBER(5) CONSTRAINT pk_autoritate PRIMARY KEY,
    nume          VARCHAR2(100) NOT NULL,
    tip           VARCHAR2(50),
    atributie     VARCHAR2(100)
);

CREATE TABLE restaurare (
    id_restaurare NUMBER(5) CONSTRAINT pk_restaurare PRIMARY KEY,
    id_monument   NUMBER(5) NOT NULL,
    data_start    DATE DEFAULT SYSDATE,
    data_final    DATE,
    stadiu        VARCHAR2(20) CONSTRAINT ck_stadiu CHECK (stadiu IN ('Planificat', 'In executie', 'Finalizat', 'Suspendat')),
    CONSTRAINT fk_restaurare_monument FOREIGN KEY (id_monument) REFERENCES monument(id_monument),
    CONSTRAINT ck_date_valide CHECK (data_final >= data_start)
);


CREATE TABLE aviz (
    id_aviz       NUMBER(5) CONSTRAINT pk_aviz PRIMARY KEY,
    id_restaurare NUMBER(5) NOT NULL,
    id_autoritate NUMBER(5) NOT NULL,
    tip_aviz      VARCHAR2(50) NOT NULL,
    data_aviz     DATE DEFAULT SYSDATE,
    CONSTRAINT fk_aviz_restaurare FOREIGN KEY (id_restaurare) REFERENCES restaurare(id_restaurare),
    CONSTRAINT fk_aviz_autoritate FOREIGN KEY (id_autoritate) REFERENCES autoritate(id_autoritate)
);


CREATE TABLE inspectie (
    id_inspectie   NUMBER(5) CONSTRAINT pk_inspectie PRIMARY KEY,
    id_restaurare  NUMBER(5) NOT NULL,
    data_inspectie DATE DEFAULT SYSDATE,
    rezultat       VARCHAR2(200),
    CONSTRAINT fk_inspectie_restaurare FOREIGN KEY (id_restaurare) REFERENCES restaurare(id_restaurare)
);


CREATE TABLE expert_restaurare (
    id_expert     NUMBER(5),
    id_restaurare NUMBER(5),
    CONSTRAINT pk_expert_restaurare PRIMARY KEY (id_expert, id_restaurare),
    CONSTRAINT fk_er_expert FOREIGN KEY (id_expert) REFERENCES expert(id_expert),
    CONSTRAINT fk_er_restaurare FOREIGN KEY (id_restaurare) REFERENCES restaurare(id_restaurare)
);


CREATE TABLE material_restaurare (
    id_material   NUMBER(5),
    id_restaurare NUMBER(5),
    CONSTRAINT pk_material_restaurare PRIMARY KEY (id_material, id_restaurare),
    CONSTRAINT fk_mr_material FOREIGN KEY (id_material) REFERENCES material(id_material),
    CONSTRAINT fk_mr_restaurare FOREIGN KEY (id_restaurare) REFERENCES restaurare(id_restaurare)
);


CREATE TABLE finantare_restaurare (
    id_finantare  NUMBER(5),
    id_restaurare NUMBER(5),
    CONSTRAINT pk_finantare_restaurare PRIMARY KEY (id_finantare, id_restaurare),
    CONSTRAINT fk_fr_finantare FOREIGN KEY (id_finantare) REFERENCES finantare(id_finantare),
    CONSTRAINT fk_fr_restaurare FOREIGN KEY (id_restaurare) REFERENCES restaurare(id_restaurare)
);

-- 5. Adăugați informații coerente în tabelele create (minim 5 înregistrări pentru fiecare entitate
-- independentă; minim 10 înregistrări pentru fiecare tabelă asociativă).


INSERT INTO monument VALUES (1, 'Castelul Peles', 'Sinaia');
INSERT INTO monument VALUES (2, 'Biserica Neagra', 'Brasov');
INSERT INTO monument VALUES (3, 'Cetatea de Scaun', 'Suceava');
INSERT INTO monument VALUES (4, 'Manastirea Voronet', 'Gura Humorului');
INSERT INTO monument VALUES (5, 'Cazinoul', 'Constanta');

INSERT INTO expert VALUES (101, 'Popescu Ion', 'Arhitect', 'popescu.i@expert.ro');
INSERT INTO expert VALUES (102, 'Ionescu Maria', 'Inginer Structurist', 'maria.i@expert.ro');
INSERT INTO expert VALUES (103, 'Georgescu Vlad', 'Restaurator Pictura', 'vlad.g@expert.ro');
INSERT INTO expert VALUES (104, 'Dumitru Ana', 'Arheolog', 'ana.d@expert.ro');
INSERT INTO expert VALUES (105, 'Stanescu Dan', 'Manager Proiect', 'dan.s@expert.ro');

INSERT INTO material VALUES (201, 'Piatra de rau', 'Natural', 'Scazut');
INSERT INTO material VALUES (202, 'Mortar hidraulic', 'Sintetic', 'Mediu');
INSERT INTO material VALUES (203, 'Lemn de stejar tratat', 'Natural', 'Ridicat');
INSERT INTO material VALUES (204, 'Pigment mineral', 'Chimic', 'Mediu');
INSERT INTO material VALUES (205, 'Caramida arsa', 'Compozit', 'Scazut');

INSERT INTO finantare VALUES (301, 'Ministerul Culturii', 5000000);
INSERT INTO finantare VALUES (302, 'Fonduri Europene REGIO', 12000000);
INSERT INTO finantare VALUES (303, 'Buget Local Sinaia', 200000);
INSERT INTO finantare VALUES (304, 'Donatii Private ONG', 50000);
INSERT INTO finantare VALUES (305, 'Granturi Norvegiene', 3500000);

INSERT INTO autoritate VALUES (401, 'Ministerul Culturii', 'Guvernamental', 'Avizare patrimoniu');
INSERT INTO autoritate VALUES (402, 'Primaria Sinaia', 'Local', 'Certificat Urbanism');
INSERT INTO autoritate VALUES (403, 'ISC Brasov', 'Inspectie', 'Control Calitate');
INSERT INTO autoritate VALUES (404, 'Directia Judeteana Cultura', 'Judetean', 'Monitorizare');
INSERT INTO autoritate VALUES (405, 'Primaria Constanta', 'Local', 'Autorizatie Constructie');

INSERT INTO restaurare VALUES (1001, 1, TO_DATE('01-03-2024','DD-MM-YYYY'), TO_DATE('01-12-2025','DD-MM-YYYY'), 'In executie');
INSERT INTO restaurare VALUES (1002, 2, TO_DATE('15-05-2023','DD-MM-YYYY'), TO_DATE('15-05-2024','DD-MM-YYYY'), 'Finalizat');
INSERT INTO restaurare VALUES (1003, 5, TO_DATE('01-01-2020','DD-MM-YYYY'), TO_DATE('01-01-2026','DD-MM-YYYY'), 'In executie');
INSERT INTO restaurare VALUES (1004, 3, TO_DATE('10-10-2025','DD-MM-YYYY'), NULL, 'Planificat');
INSERT INTO restaurare VALUES (1005, 4, TO_DATE('01-06-2024','DD-MM-YYYY'), TO_DATE('01-09-2024','DD-MM-YYYY'), 'Suspendat');

INSERT INTO aviz VALUES (1, 1001, 401, 'Aviz Favorabil', TO_DATE('20-02-2024','DD-MM-YYYY'));
INSERT INTO aviz VALUES (2, 1001, 402, 'Autorizatie Constructie', TO_DATE('25-02-2024','DD-MM-YYYY'));
INSERT INTO aviz VALUES (3, 1003, 405, 'Prelungire Autorizatie', TO_DATE('10-01-2024','DD-MM-YYYY'));


INSERT INTO inspectie VALUES (1, 1001, TO_DATE('01-04-2024','DD-MM-YYYY'), 'Conform cu proiectul');
INSERT INTO inspectie VALUES (2, 1003, TO_DATE('15-04-2024','DD-MM-YYYY'), 'Degradari neprevazute la fatada');
INSERT INTO inspectie VALUES (3, 1002, TO_DATE('20-03-2024','DD-MM-YYYY'), 'Inspectie finala, lucrari conforme');
INSERT INTO inspectie VALUES (4, 1004, TO_DATE('12-11-2025','DD-MM-YYYY'), 'Verificare preliminara a santierului');
INSERT INTO inspectie VALUES (5, 1005, TO_DATE('25-07-2024','DD-MM-YYYY'), 'Necesita remedieri la acoperis');

INSERT INTO expert_restaurare VALUES (101, 1001);
INSERT INTO expert_restaurare VALUES (102, 1001);
INSERT INTO expert_restaurare VALUES (105, 1001);
INSERT INTO expert_restaurare VALUES (101, 1003);
INSERT INTO expert_restaurare VALUES (102, 1003);
INSERT INTO expert_restaurare VALUES (103, 1005);
INSERT INTO expert_restaurare VALUES (104, 1004);
INSERT INTO expert_restaurare VALUES (105, 1002);
INSERT INTO expert_restaurare VALUES (102, 1002);
INSERT INTO expert_restaurare VALUES (101, 1002);

INSERT INTO material_restaurare VALUES (203, 1001);
INSERT INTO material_restaurare VALUES (205, 1001);
INSERT INTO material_restaurare VALUES (201, 1002);
INSERT INTO material_restaurare VALUES (202, 1002);
INSERT INTO material_restaurare VALUES (201, 1003);
INSERT INTO material_restaurare VALUES (202, 1003);
INSERT INTO material_restaurare VALUES (204, 1003);
INSERT INTO material_restaurare VALUES (201, 1004);
INSERT INTO material_restaurare VALUES (204, 1005);
INSERT INTO material_restaurare VALUES (202, 1005);

INSERT INTO finantare_restaurare VALUES (301, 1001);
INSERT INTO finantare_restaurare VALUES (303, 1001);
INSERT INTO finantare_restaurare VALUES (304, 1002);
INSERT INTO finantare_restaurare VALUES (305, 1002);
INSERT INTO finantare_restaurare VALUES (302, 1003);
INSERT INTO finantare_restaurare VALUES (301, 1003);
INSERT INTO finantare_restaurare VALUES (305, 1003);
INSERT INTO finantare_restaurare VALUES (302, 1004);
INSERT INTO finantare_restaurare VALUES (301, 1005);
INSERT INTO finantare_restaurare VALUES (304, 1005);

COMMIT;

-- 6.

CREATE OR REPLACE PROCEDURE analiza_complexa_proiect (
    p_id_restaurare IN restaurare.id_restaurare%TYPE
) IS

    TYPE t_materiale_va IS VARRAY(5) OF VARCHAR2(50);
    v_lista_materiale t_materiale_va;

    TYPE t_experti_nt IS TABLE OF VARCHAR2(50);
    v_lista_experti t_experti_nt := t_experti_nt();

    TYPE t_bonusuri_aa IS TABLE OF NUMBER INDEX BY PLS_INTEGER;
    v_map_bonusuri t_bonusuri_aa;

    v_id_expert expert.id_expert%TYPE;

BEGIN
    DBMS_OUTPUT.PUT_LINE('Analiza Proiectului ID: ' || p_id_restaurare);

    SELECT m.denumire
    BULK COLLECT INTO v_lista_materiale
    FROM material m
    JOIN material_restaurare mr ON m.id_material = mr.id_material
    WHERE mr.id_restaurare = p_id_restaurare
    AND ROWNUM <= 5;

    DBMS_OUTPUT.PUT_LINE('> Materiale principale (Varray):');
    IF v_lista_materiale.COUNT > 0 THEN
        FOR i IN 1..v_lista_materiale.COUNT LOOP
            DBMS_OUTPUT.PUT_LINE('  ' || i || '. ' || v_lista_materiale(i));
        END LOOP;
    ELSE
        DBMS_OUTPUT.PUT_LINE('  Niciun material găsit.');
    END IF;

    FOR r IN (
        SELECT e.id_expert, e.nume
        FROM expert e
        JOIN expert_restaurare er ON e.id_expert = er.id_expert
        WHERE er.id_restaurare = p_id_restaurare
    ) LOOP

        v_lista_experti.EXTEND;
        v_lista_experti(v_lista_experti.LAST) := r.nume;

        v_map_bonusuri(r.id_expert) := 1500;
    END LOOP;

    DBMS_OUTPUT.PUT_LINE('> Lista Experti:');
    IF v_lista_experti.COUNT > 0 THEN
        FOR i IN 1..v_lista_experti.COUNT LOOP
            DBMS_OUTPUT.PUT_LINE('  - ' || v_lista_experti(i));
        END LOOP;
    ELSE
        DBMS_OUTPUT.PUT_LINE('  Niciun expert alocat.');
    END IF;

    DBMS_OUTPUT.PUT_LINE('> Calcul Bonusuri:');
    v_id_expert := v_map_bonusuri.FIRST;
    WHILE v_id_expert IS NOT NULL LOOP
        DBMS_OUTPUT.PUT_LINE('  Expert ID ' || v_id_expert || ' primeste bonus: ' || v_map_bonusuri(v_id_expert) || ' RON');
        v_id_expert := v_map_bonusuri.NEXT(v_id_expert);
    END LOOP;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Nu s-au găsit date pentru acest proiect.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Eroare: ' || SQLERRM);
END;
/



SET SERVEROUTPUT ON;
BEGIN
    analiza_complexa_proiect(1002);
END;
/


-- 7

CREATE OR REPLACE PROCEDURE raport_financiar_locatie (
    p_locatie IN monument.locatie%TYPE
) IS
    CURSOR c_monumente IS
        SELECT id_monument, denumire
        FROM monument
        WHERE UPPER(locatie) = UPPER(p_locatie);

    CURSOR c_finantari (p_id_mon NUMBER) IS
        SELECT f.sursa, f.buget, r.stadiu
        FROM finantare f
        JOIN finantare_restaurare fr ON f.id_finantare = fr.id_finantare
        JOIN restaurare r ON fr.id_restaurare = r.id_restaurare
        WHERE r.id_monument = p_id_mon;

    v_total_monument NUMBER;

BEGIN
    DBMS_OUTPUT.PUT_LINE('Raport Financiar pentru: ' || p_locatie);

    FOR r_mon IN c_monumente LOOP
        DBMS_OUTPUT.PUT_LINE('Monument: ' || r_mon.denumire || ' (ID: ' || r_mon.id_monument || ')');

        v_total_monument := 0;

        FOR r_fin IN c_finantari(r_mon.id_monument) LOOP
            DBMS_OUTPUT.PUT_LINE('   > Sursa: ' || r_fin.sursa ||
                                 ' | Buget: ' || r_fin.buget ||
                                 ' | Stadiu: ' || r_fin.stadiu);
            v_total_monument := v_total_monument + r_fin.buget;
        END LOOP;

        IF v_total_monument = 0 THEN
             DBMS_OUTPUT.PUT_LINE('   > Nu exista finantari inregistrate.');
        ELSE
             DBMS_OUTPUT.PUT_LINE('   > TOTAL MONUMENT: ' || v_total_monument || ' RON');
        END IF;

    END LOOP;
END;
/

SET SERVEROUTPUT ON;
BEGIN
    raport_financiar_locatie('Sinaia');
    DBMS_OUTPUT.PUT_LINE('');
    raport_financiar_locatie('Constanta');
END;
/

-- 8

CREATE OR REPLACE FUNCTION get_material_unic(p_id_restaurare NUMBER)
RETURN VARCHAR2 IS
    v_denumire_material VARCHAR2(50);
BEGIN
    SELECT m.denumire
    INTO v_denumire_material
    FROM material m
    JOIN material_restaurare mr ON m.id_material = mr.id_material
    JOIN restaurare r ON mr.id_restaurare = r.id_restaurare
    WHERE r.id_restaurare = p_id_restaurare;

    RETURN 'Material identificat: ' || v_denumire_material;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 'Eroare: Nu exista materiale sau ID invalid.';
    WHEN TOO_MANY_ROWS THEN
        RETURN 'Eroare: Proiectul utilizeaza mai multe materiale.';
    WHEN OTHERS THEN
        RETURN 'Alta eroare: ' || SQLERRM;
END;
/

SET SERVEROUTPUT ON;

BEGIN
    DBMS_OUTPUT.PUT_LINE('CAZ 1: O singura inregistrare (Succes)');
    DBMS_OUTPUT.PUT_LINE(get_material_unic(1004));

    DBMS_OUTPUT.PUT_LINE('CAZ 2: Mai multe inregistrari (TOO_MANY_ROWS)');
    DBMS_OUTPUT.PUT_LINE(get_material_unic(1001));

    DBMS_OUTPUT.PUT_LINE('CAZ 3: Nicio inregistrare (NO_DATA_FOUND)');
    DBMS_OUTPUT.PUT_LINE(get_material_unic(9999));
END;
/