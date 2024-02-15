--
-- PostgreSQL database dump
--

-- Dumped from database version 15.1
-- Dumped by pg_dump version 15rc2

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: add_equipment(integer, text); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.add_equipment(IN p1 integer, IN p2 text)
    LANGUAGE plpgsql
    AS $$
BEGIN
insert into "equipment" ("equipmentno","equipmentname") VALUES (p1,p2);
end;
$$;


ALTER PROCEDURE public.add_equipment(IN p1 integer, IN p2 text) OWNER TO postgres;

--
-- Name: character_ekle(integer, text, integer, text, integer, integer, integer, integer); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.character_ekle(IN p1 integer, IN p2 text, IN p3 integer, IN p4 text, IN p5 integer, IN p6 integer, IN p7 integer, IN p8 integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
insert into "character" ("characterid","name",age,country,race,"class",equipment,ability) VALUES (p1,p2,p3,p4,p5,p6,p7,p8);
end;
$$;


ALTER PROCEDURE public.character_ekle(IN p1 integer, IN p2 text, IN p3 integer, IN p4 text, IN p5 integer, IN p6 integer, IN p7 integer, IN p8 integer) OWNER TO postgres;

--
-- Name: characterchanges(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.characterchanges() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
IF NEW."name" <> OLD."name" THEN
INSERT INTO update_time("characterNo","old_Name","new_Name","changed_on") VALUES (OLD."characterid",OLD."name",NEW."name",CURRENT_TIMESTAMP::TIMESTAMP);
END IF;
RETURN NEW;
END;
$$;


ALTER FUNCTION public.characterchanges() OWNER TO postgres;

--
-- Name: characterupdates(integer, text, integer, text, integer, integer, integer, integer); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.characterupdates(IN p1 integer, IN p2 text, IN p3 integer, IN p4 text, IN p5 integer, IN p6 integer, IN p7 integer, IN p8 integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
update "character" SET "name"=p2,"age"=p3,"country"=p4,"race"=p5,"class"=p6,"equipment"=p7,"ability"=p8
where "characterid"=p1;
END;
$$;


ALTER PROCEDURE public.characterupdates(IN p1 integer, IN p2 text, IN p3 integer, IN p4 text, IN p5 integer, IN p6 integer, IN p7 integer, IN p8 integer) OWNER TO postgres;

--
-- Name: powercontrols(bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.powercontrols(p1 bigint) RETURNS character varying
    LANGUAGE plpgsql
    AS $$
BEGIN
IF p1 > 10 then
raise notice 'Strong';
ELSE
raise notice 'Weak';
end if;  
END;
$$;


ALTER FUNCTION public.powercontrols(p1 bigint) OWNER TO postgres;

--
-- Name: removecharacter(integer); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.removecharacter(IN p1 integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
DELETE FROM "character" where "characterid"=p1;
END;
$$;


ALTER PROCEDURE public.removecharacter(IN p1 integer) OWNER TO postgres;

--
-- Name: silme(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.silme() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
update "TotalCharacter" set number=number-1;
return NEW;
end;
$$;


ALTER FUNCTION public.silme() OWNER TO postgres;

--
-- Name: test(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.test() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
update "TotalCharacter" set number=number+1;
return NEW;
end;
$$;


ALTER FUNCTION public.test() OWNER TO postgres;

--
-- Name: uppernaming(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.uppernaming() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
NEW."name" = UPPER(NEW."name");
RETURN NEW;
END;
$$;


ALTER FUNCTION public.uppernaming() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: TotalCharacter; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."TotalCharacter" (
    number integer NOT NULL
);


ALTER TABLE public."TotalCharacter" OWNER TO postgres;

--
-- Name: abilityScore; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."abilityScore" (
    "Id" bigint NOT NULL,
    strength bigint NOT NULL,
    dexterity bigint NOT NULL,
    constitution bigint NOT NULL,
    intelligence bigint NOT NULL,
    wisdom bigint NOT NULL,
    charisma bigint NOT NULL
);


ALTER TABLE public."abilityScore" OWNER TO postgres;

--
-- Name: character; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."character" (
    characterid bigint NOT NULL,
    name character varying(255) NOT NULL,
    age bigint NOT NULL,
    country character varying(255) NOT NULL,
    race bigint NOT NULL,
    class bigint NOT NULL,
    equipment bigint NOT NULL,
    ability bigint NOT NULL
);


ALTER TABLE public."character" OWNER TO postgres;

--
-- Name: class; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.class (
    classid integer NOT NULL,
    classname character varying(255) NOT NULL
);


ALTER TABLE public.class OWNER TO postgres;

--
-- Name: equipment; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.equipment (
    equipmentno bigint NOT NULL,
    equipmentname character varying(255) NOT NULL
);


ALTER TABLE public.equipment OWNER TO postgres;

--
-- Name: race; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.race (
    raceid integer NOT NULL,
    racename character varying(255) NOT NULL
);


ALTER TABLE public.race OWNER TO postgres;

--
-- Name: characterlist; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.characterlist AS
 SELECT "character".characterid,
    "character".name,
    "character".age,
    "character".country,
    class.classname,
    race.racename,
    equipment.equipmentname,
    "character".ability,
    "abilityScore".strength,
    "abilityScore".dexterity,
    "abilityScore".constitution,
    "abilityScore".intelligence,
    "abilityScore".wisdom,
    "abilityScore".charisma
   FROM ((((public."abilityScore"
     JOIN public."character" ON (("abilityScore"."Id" = "character".ability)))
     JOIN public.class ON ((class.classid = "character".class)))
     JOIN public.equipment ON ((equipment.equipmentno = "character".equipment)))
     JOIN public.race ON ((race.raceid = "character".race)));


ALTER TABLE public.characterlist OWNER TO postgres;

--
-- Name: charisma; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.charisma (
    abilityid bigint NOT NULL,
    "CharismaTotalScore" bigint NOT NULL
);


ALTER TABLE public.charisma OWNER TO postgres;

--
-- Name: constitution; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.constitution (
    abilityid bigint NOT NULL,
    "ConstitutionTotalScore" bigint NOT NULL
);


ALTER TABLE public.constitution OWNER TO postgres;

--
-- Name: dexterity; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.dexterity (
    abilityid bigint NOT NULL,
    "DexterityTotalScore" bigint NOT NULL
);


ALTER TABLE public.dexterity OWNER TO postgres;

--
-- Name: intelligence; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.intelligence (
    "IntelligenceTotalScore" bigint NOT NULL,
    abilityid bigint NOT NULL
);


ALTER TABLE public.intelligence OWNER TO postgres;

--
-- Name: strength; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.strength (
    abilityid bigint NOT NULL,
    "StrengthTotalScore" bigint NOT NULL
);


ALTER TABLE public.strength OWNER TO postgres;

--
-- Name: update_time; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.update_time (
    "characterNo" bigint NOT NULL,
    changed_on timestamp(6) without time zone NOT NULL,
    "old_Name" character varying NOT NULL,
    "new_Name" character varying NOT NULL
);


ALTER TABLE public.update_time OWNER TO postgres;

--
-- Name: wisdom; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.wisdom (
    abilityid bigint NOT NULL,
    "WisdomTotalScore" bigint NOT NULL
);


ALTER TABLE public.wisdom OWNER TO postgres;

--
-- Data for Name: TotalCharacter; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."TotalCharacter" VALUES
	(8);


--
-- Data for Name: abilityScore; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."abilityScore" VALUES
	(1, 10, 15, 14, 12, 13, 8),
	(2, 15, 8, 14, 10, 13, 12),
	(3, 12, 15, 14, 10, 13, 8),
	(4, 15, 13, 14, 8, 12, 10),
	(5, 8, 13, 14, 12, 10, 15),
	(6, 8, 13, 14, 15, 12, 10),
	(7, 8, 15, 13, 14, 12, 10),
	(8, 13, 8, 14, 12, 15, 10);


--
-- Data for Name: character; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."character" VALUES
	(1, 'Vanir', 25, 'Gondor', 5, 4, 2, 7),
	(2, 'Elrond', 115, 'Rivendell', 8, 2, 3, 6),
	(3, 'Galadriel', 800, 'Valinor', 7, 3, 4, 5),
	(4, 'Aragorn', 39, 'Numenor', 3, 10, 5, 4),
	(5, 'Bilbo', 90, 'Shire', 11, 1, 6, 3),
	(6, 'GilGalad', 23, 'Earendil', 2, 9, 7, 2),
	(7, 'Gimli', 89, 'Mordor', 6, 7, 8, 1),
	(8, 'Legolas', 46, 'Legendarium', 9, 5, 8, 8);


--
-- Data for Name: charisma; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.charisma VALUES
	(1, -5),
	(2, -4),
	(3, -4),
	(4, -3),
	(5, -3),
	(6, -2),
	(7, -2),
	(8, -1),
	(9, -1),
	(10, 0),
	(11, 0),
	(12, 1),
	(13, 1),
	(14, 2),
	(15, 2),
	(16, 3),
	(17, 3),
	(18, 4),
	(19, 4),
	(20, 5),
	(21, 5);


--
-- Data for Name: class; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.class VALUES
	(1, 'Barbarian'),
	(2, 'Bard'),
	(3, 'Cleric'),
	(4, 'Druid'),
	(5, 'Figther'),
	(6, 'Monk'),
	(7, 'Paladin'),
	(8, 'Ranger'),
	(9, 'Rogue'),
	(10, 'Sorcerer'),
	(11, 'Wizard'),
	(12, 'Magician');


--
-- Data for Name: constitution; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.constitution VALUES
	(1, -5),
	(2, -4),
	(3, -4),
	(4, -3),
	(5, -3),
	(6, -2),
	(7, -2),
	(8, -1),
	(9, -1),
	(10, 0),
	(11, 0),
	(12, 1),
	(13, 1),
	(14, 2),
	(15, 2),
	(16, 3),
	(17, 3),
	(18, 4),
	(19, 4),
	(20, 5),
	(21, 5);


--
-- Data for Name: dexterity; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.dexterity VALUES
	(1, -5),
	(2, -4),
	(3, -4),
	(4, -3),
	(5, -3),
	(6, -2),
	(7, -2),
	(8, -1),
	(9, -1),
	(10, 0),
	(11, 0),
	(12, 1),
	(13, 1),
	(14, 2),
	(15, 2),
	(16, 3),
	(17, 3),
	(18, 4),
	(19, 4),
	(20, 5),
	(21, 5);


--
-- Data for Name: equipment; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.equipment VALUES
	(1, 'Rapier'),
	(2, 'Scimitar'),
	(3, 'Battleaxe'),
	(4, 'Crossbow'),
	(5, 'Dagger'),
	(6, 'Handaxe'),
	(7, 'Longsword'),
	(8, 'Club'),
	(9, 'Shortsword'),
	(10, 'Staff');


--
-- Data for Name: intelligence; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.intelligence VALUES
	(-5, 1),
	(-4, 2),
	(-4, 3),
	(-3, 4),
	(-3, 5),
	(-2, 6),
	(-2, 7),
	(-1, 8),
	(-1, 9),
	(0, 10),
	(0, 11),
	(1, 12),
	(1, 13),
	(2, 14),
	(2, 15),
	(3, 16),
	(3, 17),
	(4, 18),
	(4, 19),
	(5, 20),
	(5, 21);


--
-- Data for Name: race; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.race VALUES
	(1, 'Aarakocra'),
	(2, 'Dragonborn'),
	(3, 'Dwarf'),
	(4, 'Elf'),
	(5, 'Genasi'),
	(6, 'Gnome'),
	(7, 'Goliath'),
	(8, 'Half-Elf'),
	(9, 'Half-Orc'),
	(10, 'Halfling'),
	(11, 'Tiefling'),
	(12, 'Aasimar');


--
-- Data for Name: strength; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.strength VALUES
	(1, -5),
	(2, -4),
	(3, -4),
	(4, -3),
	(5, -3),
	(6, -2),
	(7, -2),
	(8, -1),
	(9, -1),
	(10, 0),
	(11, 0),
	(12, 1),
	(13, 1),
	(14, 2),
	(15, 2),
	(16, 3),
	(17, 3),
	(18, 4),
	(19, 4),
	(20, 5),
	(21, 5);


--
-- Data for Name: update_time; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.update_time VALUES
	(9, '2022-12-24 21:21:41.414015', 'Omer', 'MERT'),
	(9, '2022-12-25 18:19:46.956397', 'OMER', 'Mert'),
	(152, '2022-12-25 20:56:46.960378', 'OMER', 'mert'),
	(9, '2022-12-25 22:19:16.545208', 'A', 'a'),
	(9, '2022-12-25 22:19:21.437745', 'a', 'b');


--
-- Data for Name: wisdom; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.wisdom VALUES
	(1, -5),
	(2, -4),
	(3, -4),
	(4, -3),
	(5, -3),
	(6, -2),
	(7, -2),
	(8, -1),
	(9, -1),
	(10, 0),
	(11, 0),
	(15, 2),
	(16, 3),
	(17, 3),
	(18, 4),
	(19, 4),
	(20, 5),
	(21, 5),
	(12, 1),
	(13, 1),
	(14, 2);


--
-- Name: abilityScore abilityScore_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."abilityScore"
    ADD CONSTRAINT "abilityScore_pkey" PRIMARY KEY ("Id");


--
-- Name: character character_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."character"
    ADD CONSTRAINT character_pkey PRIMARY KEY (characterid);


--
-- Name: charisma charisma_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.charisma
    ADD CONSTRAINT charisma_pkey PRIMARY KEY (abilityid);


--
-- Name: class class_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.class
    ADD CONSTRAINT class_pkey PRIMARY KEY (classid);


--
-- Name: constitution constitution_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.constitution
    ADD CONSTRAINT constitution_pkey PRIMARY KEY (abilityid);


--
-- Name: dexterity dexterity_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dexterity
    ADD CONSTRAINT dexterity_pkey PRIMARY KEY (abilityid);


--
-- Name: equipment equipment_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.equipment
    ADD CONSTRAINT equipment_pkey PRIMARY KEY (equipmentno);


--
-- Name: intelligence intelligence_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.intelligence
    ADD CONSTRAINT intelligence_pkey PRIMARY KEY (abilityid);


--
-- Name: race race_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.race
    ADD CONSTRAINT race_pkey PRIMARY KEY (raceid);


--
-- Name: strength strength_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.strength
    ADD CONSTRAINT strength_pkey PRIMARY KEY (abilityid);


--
-- Name: wisdom wisdom_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.wisdom
    ADD CONSTRAINT wisdom_pkey PRIMARY KEY (abilityid);


--
-- Name: character lastchanges; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER lastchanges BEFORE UPDATE ON public."character" FOR EACH ROW EXECUTE FUNCTION public.characterchanges();


--
-- Name: character testrig; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER testrig AFTER INSERT ON public."character" FOR EACH ROW EXECUTE FUNCTION public.test();


--
-- Name: character testrig2; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER testrig2 AFTER DELETE ON public."character" FOR EACH ROW EXECUTE FUNCTION public.silme();


--
-- Name: character uppercontrol; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER uppercontrol BEFORE INSERT ON public."character" FOR EACH ROW EXECUTE FUNCTION public.uppernaming();


--
-- Name: abilityScore abilityscore_charisma_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."abilityScore"
    ADD CONSTRAINT abilityscore_charisma_foreign FOREIGN KEY (charisma) REFERENCES public.charisma(abilityid);


--
-- Name: abilityScore abilityscore_constitution_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."abilityScore"
    ADD CONSTRAINT abilityscore_constitution_foreign FOREIGN KEY (constitution) REFERENCES public.constitution(abilityid);


--
-- Name: abilityScore abilityscore_dexterity_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."abilityScore"
    ADD CONSTRAINT abilityscore_dexterity_foreign FOREIGN KEY (dexterity) REFERENCES public.dexterity(abilityid);


--
-- Name: abilityScore abilityscore_intelligence_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."abilityScore"
    ADD CONSTRAINT abilityscore_intelligence_foreign FOREIGN KEY (intelligence) REFERENCES public.intelligence(abilityid);


--
-- Name: abilityScore abilityscore_strength_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."abilityScore"
    ADD CONSTRAINT abilityscore_strength_foreign FOREIGN KEY (strength) REFERENCES public.strength(abilityid);


--
-- Name: abilityScore abilityscore_wisdom_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."abilityScore"
    ADD CONSTRAINT abilityscore_wisdom_foreign FOREIGN KEY (wisdom) REFERENCES public.wisdom(abilityid);


--
-- Name: character character_ability_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."character"
    ADD CONSTRAINT character_ability_foreign FOREIGN KEY (ability) REFERENCES public."abilityScore"("Id");


--
-- Name: character character_class_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."character"
    ADD CONSTRAINT character_class_foreign FOREIGN KEY (class) REFERENCES public.class(classid);


--
-- Name: character character_equipment_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."character"
    ADD CONSTRAINT character_equipment_foreign FOREIGN KEY (equipment) REFERENCES public.equipment(equipmentno);


--
-- Name: character character_race_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."character"
    ADD CONSTRAINT character_race_foreign FOREIGN KEY (race) REFERENCES public.race(raceid);


--
-- PostgreSQL database dump complete
--

