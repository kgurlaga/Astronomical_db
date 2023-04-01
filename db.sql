--
-- PostgreSQL database dump
--

-- Dumped from database version 11.9
-- Dumped by pg_dump version 11.9

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
-- Name: asteroidy; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE asteroidy WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'Polish_Poland.1250' LC_CTYPE = 'Polish_Poland.1250';


ALTER DATABASE asteroidy OWNER TO postgres;

\connect asteroidy

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
-- Name: parametry; Type: DOMAIN; Schema: public; Owner: postgres
--

CREATE DOMAIN public.parametry AS character varying
	CONSTRAINT parametry_check CHECK (((VALUE)::text = ANY ((ARRAY['masa (Mo)'::character varying, 'średnica'::character varying, 'odleglosc_od_gwiazdy_macierzystej (au)'::character varying, 'temperatura (K)'::character varying])::text[])));


ALTER DOMAIN public.parametry OWNER TO postgres;

--
-- Name: rodzaj; Type: DOMAIN; Schema: public; Owner: postgres
--

CREATE DOMAIN public.rodzaj AS character varying NOT NULL DEFAULT 'asteroida'::character varying;


ALTER DOMAIN public.rodzaj OWNER TO postgres;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: naukowcy; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.naukowcy (
    orcid character(19) NOT NULL,
    imie character varying NOT NULL,
    nazwisko character varying NOT NULL,
    telefon character varying,
    email character varying,
    afiliacja character varying,
    specjalizacja character varying,
    data_urodzenia date,
    id_instytuty integer
);


ALTER TABLE public.naukowcy OWNER TO postgres;

--
-- Name: astronomia_stosowana; Type: MATERIALIZED VIEW; Schema: public; Owner: postgres
--

CREATE MATERIALIZED VIEW public.astronomia_stosowana AS
 SELECT naukowcy.imie,
    naukowcy.nazwisko,
    naukowcy.telefon,
    naukowcy.email
   FROM public.naukowcy
  WHERE ((naukowcy.specjalizacja)::text = 'Astronomia stosowania'::text)
  WITH NO DATA;


ALTER TABLE public.astronomia_stosowana OWNER TO postgres;

--
-- Name: ciala_niebieskie; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ciala_niebieskie (
    id integer NOT NULL,
    parametr public.parametry NOT NULL,
    wartosc numeric,
    nr_katalogowy_typy character varying NOT NULL
);


ALTER TABLE public.ciala_niebieskie OWNER TO postgres;

--
-- Name: ciala_niebieskie_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.ciala_niebieskie_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ciala_niebieskie_id_seq OWNER TO postgres;

--
-- Name: ciala_niebieskie_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.ciala_niebieskie_id_seq OWNED BY public.ciala_niebieskie.id;


--
-- Name: instytuty; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.instytuty (
    id integer NOT NULL,
    email character varying,
    nazwa character varying NOT NULL,
    kraj character varying NOT NULL,
    miasto character varying NOT NULL,
    ulica character varying,
    nr_budynku character varying NOT NULL,
    kod_pocztowy character varying NOT NULL,
    data_zalozenia date
);


ALTER TABLE public.instytuty OWNER TO postgres;

--
-- Name: czlonkowie_instytutow; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.czlonkowie_instytutow AS
 SELECT naukowcy.imie,
    naukowcy.nazwisko,
    naukowcy.telefon,
    naukowcy.email,
    naukowcy.specjalizacja,
    instytuty.nazwa AS nazwa_instytutu,
    instytuty.kraj,
    instytuty.miasto,
    instytuty.email AS email_instytutu
   FROM (public.naukowcy
     JOIN public.instytuty ON ((naukowcy.id_instytuty = instytuty.id)));


ALTER TABLE public.czlonkowie_instytutow OWNER TO postgres;

--
-- Name: instytuty_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.instytuty_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.instytuty_id_seq OWNER TO postgres;

--
-- Name: instytuty_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.instytuty_id_seq OWNED BY public.instytuty.id;


--
-- Name: naukowcy_publikacje; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.naukowcy_publikacje (
    id integer NOT NULL,
    orcid_naukowcy character(19) NOT NULL,
    issn_publikacje character(14) NOT NULL
);


ALTER TABLE public.naukowcy_publikacje OWNER TO postgres;

--
-- Name: naukowcy_publikacje_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.naukowcy_publikacje_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.naukowcy_publikacje_id_seq OWNER TO postgres;

--
-- Name: naukowcy_publikacje_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.naukowcy_publikacje_id_seq OWNED BY public.naukowcy_publikacje.id;


--
-- Name: obserwacje; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.obserwacje (
    nr_obserwacji integer NOT NULL,
    data timestamp with time zone,
    rektascensja character varying NOT NULL,
    deklinacja character varying NOT NULL,
    id_teleskopy integer NOT NULL,
    orcid_naukowcy character(19) NOT NULL,
    id_ciala_niebieskie integer NOT NULL
);


ALTER TABLE public.obserwacje OWNER TO postgres;

--
-- Name: typy; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.typy (
    nr_katalogowy character varying NOT NULL,
    rodzaj public.rodzaj NOT NULL
);


ALTER TABLE public.typy OWNER TO postgres;

--
-- Name: obserwacje_ciala_niebieskie; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.obserwacje_ciala_niebieskie AS
 SELECT obserwacje.data,
    typy.nr_katalogowy,
    typy.rodzaj,
    obserwacje.rektascensja,
    obserwacje.deklinacja,
    ciala_niebieskie.parametr,
    ciala_niebieskie.wartosc
   FROM ((public.obserwacje
     JOIN public.ciala_niebieskie ON ((obserwacje.id_ciala_niebieskie = ciala_niebieskie.id)))
     JOIN public.typy ON (((typy.nr_katalogowy)::text = (ciala_niebieskie.nr_katalogowy_typy)::text)));


ALTER TABLE public.obserwacje_ciala_niebieskie OWNER TO postgres;

--
-- Name: teleskopy; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.teleskopy (
    id integer NOT NULL,
    model character varying,
    srednica_obiektywu integer,
    ogniskowa integer,
    powiekszenie character varying,
    id_obserwatoria integer,
    CONSTRAINT ogniskowa_teleskopy CHECK ((ogniskowa > 0)),
    CONSTRAINT srednica_obiektywu_teleskopy CHECK ((srednica_obiektywu > 0))
);


ALTER TABLE public.teleskopy OWNER TO postgres;

--
-- Name: obserwacje_naukowcow; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.obserwacje_naukowcow AS
 SELECT naukowcy.imie,
    naukowcy.nazwisko,
    naukowcy.afiliacja,
    naukowcy.specjalizacja,
    obserwacje.nr_obserwacji,
    obserwacje.data,
    teleskopy.model AS model_teleskopu
   FROM ((public.naukowcy
     JOIN public.obserwacje ON ((naukowcy.orcid = obserwacje.orcid_naukowcy)))
     JOIN public.teleskopy ON ((obserwacje.id_teleskopy = teleskopy.id)));


ALTER TABLE public.obserwacje_naukowcow OWNER TO postgres;

--
-- Name: obserwacje_nr_obserwacji_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.obserwacje_nr_obserwacji_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.obserwacje_nr_obserwacji_seq OWNER TO postgres;

--
-- Name: obserwacje_nr_obserwacji_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.obserwacje_nr_obserwacji_seq OWNED BY public.obserwacje.nr_obserwacji;


--
-- Name: obserwatoria; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.obserwatoria (
    id integer NOT NULL,
    szerokosc_geo numeric NOT NULL,
    dlugosc_geo numeric NOT NULL,
    nazwa character varying NOT NULL,
    wysokosc_npm numeric NOT NULL,
    kraj character varying NOT NULL,
    CONSTRAINT dlugosc_geo_obserwatoria CHECK (((dlugosc_geo >= ('-180'::integer)::numeric) AND (dlugosc_geo <= (180)::numeric))),
    CONSTRAINT szerokosc_geo_obserwatoria CHECK (((szerokosc_geo >= ('-90'::integer)::numeric) AND (szerokosc_geo <= (90)::numeric)))
);


ALTER TABLE public.obserwatoria OWNER TO postgres;

--
-- Name: obserwatoria_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.obserwatoria_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.obserwatoria_id_seq OWNER TO postgres;

--
-- Name: obserwatoria_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.obserwatoria_id_seq OWNED BY public.obserwatoria.id;


--
-- Name: parametry_asteroid_o_masie_wiekszej_niz_srednia_masy_dla_wszyst; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.parametry_asteroid_o_masie_wiekszej_niz_srednia_masy_dla_wszyst AS
 SELECT a.nr_katalogowy,
    max(a.wartosc) FILTER (WHERE ((a.parametr)::text = 'masa (Mo)'::text)) AS masa,
    max(a.wartosc) FILTER (WHERE ((a.parametr)::text = 'średnica'::text)) AS srednica
   FROM ( SELECT typy.nr_katalogowy,
            typy.rodzaj,
            ciala_niebieskie.parametr,
            ciala_niebieskie.wartosc
           FROM (public.typy
             JOIN public.ciala_niebieskie ON (((ciala_niebieskie.nr_katalogowy_typy)::text = (typy.nr_katalogowy)::text)))
          WHERE (((typy.rodzaj)::text = 'asteroida'::text) AND (ciala_niebieskie.wartosc > ( SELECT avg(ciala_niebieskie_1.wartosc) AS avg
                   FROM (public.ciala_niebieskie ciala_niebieskie_1
                     JOIN public.typy typy_1 ON (((ciala_niebieskie_1.nr_katalogowy_typy)::text = (typy_1.nr_katalogowy)::text)))
                  WHERE (((typy_1.rodzaj)::text = 'asteroida'::text) AND ((ciala_niebieskie_1.parametr)::text = 'masa (Mo)'::text)))))) a
  GROUP BY a.nr_katalogowy;


ALTER TABLE public.parametry_asteroid_o_masie_wiekszej_niz_srednia_masy_dla_wszyst OWNER TO postgres;

--
-- Name: publikacje; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.publikacje (
    issn character(9) NOT NULL,
    tytul_arykulu character varying NOT NULL,
    wydawnictwo character varying NOT NULL,
    data date NOT NULL,
    czasopismo character varying
);


ALTER TABLE public.publikacje OWNER TO postgres;

--
-- Name: publikacje_naukowcow; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.publikacje_naukowcow AS
 SELECT naukowcy.orcid,
    naukowcy.imie,
    naukowcy.nazwisko,
    publikacje.tytul_arykulu,
    publikacje.issn
   FROM ((public.naukowcy_publikacje
     JOIN public.naukowcy ON ((naukowcy_publikacje.orcid_naukowcy = naukowcy.orcid)))
     JOIN public.publikacje ON ((naukowcy_publikacje.issn_publikacje = publikacje.issn)));


ALTER TABLE public.publikacje_naukowcow OWNER TO postgres;

--
-- Name: teleskopy_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.teleskopy_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.teleskopy_id_seq OWNER TO postgres;

--
-- Name: teleskopy_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.teleskopy_id_seq OWNED BY public.teleskopy.id;


--
-- Name: temperatury_gwiazd; Type: MATERIALIZED VIEW; Schema: public; Owner: postgres
--

CREATE MATERIALIZED VIEW public.temperatury_gwiazd AS
 SELECT ciala_niebieskie.wartosc
   FROM public.ciala_niebieskie
  WHERE ((ciala_niebieskie.parametr)::text = 'temperatura (K)'::text)
  ORDER BY ciala_niebieskie.wartosc DESC
  WITH NO DATA;


ALTER TABLE public.temperatury_gwiazd OWNER TO postgres;

--
-- Name: wyposazenie_obserwatoriow; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.wyposazenie_obserwatoriow AS
 SELECT teleskopy.model,
    teleskopy.srednica_obiektywu,
    teleskopy.ogniskowa,
    teleskopy.powiekszenie,
    obserwatoria.nazwa,
    obserwatoria.kraj,
    obserwatoria.wysokosc_npm,
    obserwatoria.dlugosc_geo,
    obserwatoria.szerokosc_geo
   FROM (public.teleskopy
     JOIN public.obserwatoria ON ((teleskopy.id_obserwatoria = obserwatoria.id)));


ALTER TABLE public.wyposazenie_obserwatoriow OWNER TO postgres;

--
-- Name: ciala_niebieskie id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ciala_niebieskie ALTER COLUMN id SET DEFAULT nextval('public.ciala_niebieskie_id_seq'::regclass);


--
-- Name: instytuty id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.instytuty ALTER COLUMN id SET DEFAULT nextval('public.instytuty_id_seq'::regclass);


--
-- Name: naukowcy_publikacje id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.naukowcy_publikacje ALTER COLUMN id SET DEFAULT nextval('public.naukowcy_publikacje_id_seq'::regclass);


--
-- Name: obserwacje nr_obserwacji; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.obserwacje ALTER COLUMN nr_obserwacji SET DEFAULT nextval('public.obserwacje_nr_obserwacji_seq'::regclass);


--
-- Name: obserwatoria id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.obserwatoria ALTER COLUMN id SET DEFAULT nextval('public.obserwatoria_id_seq'::regclass);


--
-- Name: teleskopy id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.teleskopy ALTER COLUMN id SET DEFAULT nextval('public.teleskopy_id_seq'::regclass);


--
-- Data for Name: ciala_niebieskie; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ciala_niebieskie (id, parametr, wartosc, nr_katalogowy_typy) FROM stdin;
1	masa (Mo)	20	20395921
2	temperatura (K)	7000	20395921
3	średnica	20	27481738195
4	masa (Mo)	0.0005	27481738195
6	masa (Mo)	0.00008	29049184911
10	masa (Mo)	0.0003	3928481734
11	masa (Mo)	0.02	748172614
12	odleglosc_od_gwiazdy_macierzystej (au)	3	748172614
13	temperatura (K)	30000	B2059278194
7	średnica	10	29049184911
9	średnica	200	3928481734
\.


--
-- Data for Name: instytuty; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.instytuty (id, email, nazwa, kraj, miasto, ulica, nr_budynku, kod_pocztowy, data_zalozenia) FROM stdin;
1	mail@gmail.com	instytut matki i dziecka	USA	Wisconsin	Benedict St.	23	62-600	1999-02-22
2	mail2@gmail.com	asteroids	USA	New York	Jofrey St.	102	28-249	1950-05-30
3	mail3@gmail.com	jubudubu	Kongo	Malila	Ugabuga St.	28	202-12	2000-11-01
4	mail4@gmail.com	toyota	Japonia	Tokio	Ziungziu	200	200-45	1989-05-20
5	mail5@gmail.com	chorus	Francja	Paryż	La-croux	24	28-199	1920-05-20
\.


--
-- Data for Name: naukowcy; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.naukowcy (orcid, imie, nazwisko, telefon, email, afiliacja, specjalizacja, data_urodzenia, id_instytuty) FROM stdin;
0000-0002-1825-0097	John	Wayne	629384211	wildwest@gmail.com	Sacramento University	Kosmologia	1978-02-25	1
0000-0122-1825-2233	Aaron	Martin	274832942	mail23@gmail.com	Philadelfia University	Kosmologia	1979-03-15	1
0020-1140-1283-4499	Xin	Zhu	273849583	mail25@gmail.com	Tokio University	Astronomia stosowania	1975-01-15	4
9920-2130-5223-4422	Thomas	SHelby	283949283	mail30@gmail.com	Minessota University	Astronomia stosowania	1988-05-30	1
9922-2158-1233-2948	Moise	Tshombe	689999283	mail31@gmail.com	Kolom University	Astronomia stosowania	1968-02-01	3
9982-2168-2333-2955	Patrick	Swayze	299948583	mail32@gmail.com	Austin University	Terraformacja	1968-02-01	2
9982-2168-2193-2955	Randy	Lahey	299948583	mail32@gmail.com	Austin University	Terraformacja	1968-02-01	2
\.


--
-- Data for Name: naukowcy_publikacje; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.naukowcy_publikacje (id, orcid_naukowcy, issn_publikacje) FROM stdin;
1	0000-0122-1825-2233	2323-0000     
2	0020-1140-1283-4499	2323-0000     
3	0020-1140-1283-4499	2323-2222     
4	9922-2158-1233-2948	1893-6192     
\.


--
-- Data for Name: obserwacje; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.obserwacje (nr_obserwacji, data, rektascensja, deklinacja, id_teleskopy, orcid_naukowcy, id_ciala_niebieskie) FROM stdin;
1	2011-01-01 01:00:00+01	20	70	1	0000-0122-1825-2233	1
2	2011-01-01 01:00:00+01	30	60	1	0000-0122-1825-2233	1
3	2011-02-01 02:00:00+01	30	60	3	0020-1140-1283-4499	4
\.


--
-- Data for Name: obserwatoria; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.obserwatoria (id, szerokosc_geo, dlugosc_geo, nazwa, wysokosc_npm, kraj) FROM stdin;
1	41.21	120.20	Obserwatorium Kopernika	600	USA
2	10.30	20.20	Magnum	2200	USA
3	50.10	160.56	Great Eye	4000	Japan
4	10.10	10.56	Małe Obserwatorium	1200	Kongo
\.


--
-- Data for Name: publikacje; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.publikacje (issn, tytul_arykulu, wydawnictwo, data, czasopismo) FROM stdin;
2323-0000	Aliens?	Egmonton	1999-12-20	I want to believe
2323-2222	Big asteroids	Egmonton	2005-10-10	Cosmos
2883-2192	Moon craters	Nowa Era	2010-08-16	Eureka
1893-6192	Africa on astronomy	PWN	2012-01-06	Eureka
\.


--
-- Data for Name: teleskopy; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.teleskopy (id, model, srednica_obiektywu, ogniskowa, powiekszenie, id_obserwatoria) FROM stdin;
1	MCX2021-298	2000	4800	40x	1
2	WZX2123-195	3000	5800	70x	1
3	WZX30123-Z95	4000	7800	90x	3
4	WZZ12123-Z25	1000	3800	30x	2
5	SS22123-Z45	1000	3800	30x	\N
\.


--
-- Data for Name: typy; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.typy (nr_katalogowy, rodzaj) FROM stdin;
B210000493	gwiazda
B2059278194	gwiazda
20395921	gwiazda
29049184911	asteroida
92848103481	asteroida
27481738195	asteroida
3928481734	asteroida
748172614	planeta
\.


--
-- Name: ciala_niebieskie_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.ciala_niebieskie_id_seq', 1, false);


--
-- Name: instytuty_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.instytuty_id_seq', 1, false);


--
-- Name: naukowcy_publikacje_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.naukowcy_publikacje_id_seq', 1, false);


--
-- Name: obserwacje_nr_obserwacji_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.obserwacje_nr_obserwacji_seq', 1, false);


--
-- Name: obserwatoria_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.obserwatoria_id_seq', 1, false);


--
-- Name: teleskopy_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.teleskopy_id_seq', 1, false);


--
-- Name: naukowcy ORCID; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.naukowcy
    ADD CONSTRAINT "ORCID" PRIMARY KEY (orcid);


--
-- Name: ciala_niebieskie id_ciala; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ciala_niebieskie
    ADD CONSTRAINT id_ciala PRIMARY KEY (id);


--
-- Name: instytuty id_instytuty; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.instytuty
    ADD CONSTRAINT id_instytuty PRIMARY KEY (id);


--
-- Name: naukowcy_publikacje id_naukowcy_publikacje; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.naukowcy_publikacje
    ADD CONSTRAINT id_naukowcy_publikacje PRIMARY KEY (id);


--
-- Name: obserwacje id_obserwacje; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.obserwacje
    ADD CONSTRAINT id_obserwacje PRIMARY KEY (nr_obserwacji);


--
-- Name: obserwatoria id_obserwatoria; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.obserwatoria
    ADD CONSTRAINT id_obserwatoria PRIMARY KEY (id);


--
-- Name: teleskopy id_teleskopy; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.teleskopy
    ADD CONSTRAINT id_teleskopy PRIMARY KEY (id);


--
-- Name: publikacje issn; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.publikacje
    ADD CONSTRAINT issn PRIMARY KEY (issn);


--
-- Name: instytuty nazwa_instytuty; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.instytuty
    ADD CONSTRAINT nazwa_instytuty UNIQUE (nazwa);


--
-- Name: obserwatoria nazwa_obserwatoria; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.obserwatoria
    ADD CONSTRAINT nazwa_obserwatoria UNIQUE (nazwa);


--
-- Name: typy nr_katalogowy_typy; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.typy
    ADD CONSTRAINT nr_katalogowy_typy PRIMARY KEY (nr_katalogowy);


--
-- Name: ciala_niebieskie_parametr_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ciala_niebieskie_parametr_idx ON public.ciala_niebieskie USING btree (parametr);


--
-- Name: ciala_niebieskie_wartosc_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ciala_niebieskie_wartosc_idx ON public.ciala_niebieskie USING hash (wartosc);


--
-- Name: obserwacje_id_ciala_niebieskie_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX obserwacje_id_ciala_niebieskie_idx ON public.obserwacje USING btree (id_ciala_niebieskie);


--
-- Name: obserwacje_id_teleskopy_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX obserwacje_id_teleskopy_idx ON public.obserwacje USING btree (id_teleskopy);


--
-- Name: obserwacje_orcid_naukowcy_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX obserwacje_orcid_naukowcy_idx ON public.obserwacje USING btree (orcid_naukowcy);


--
-- Name: teleskopy_ogniskowa_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX teleskopy_ogniskowa_idx ON public.teleskopy USING btree (ogniskowa);


--
-- Name: typy_rodzaj_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX typy_rodzaj_idx ON public.typy USING btree (rodzaj);


--
-- Name: obserwacje ciala_niebieskie_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.obserwacje
    ADD CONSTRAINT ciala_niebieskie_fk FOREIGN KEY (id_ciala_niebieskie) REFERENCES public.ciala_niebieskie(id) MATCH FULL ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: naukowcy instytuty_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.naukowcy
    ADD CONSTRAINT instytuty_fk FOREIGN KEY (id_instytuty) REFERENCES public.instytuty(id) MATCH FULL ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: obserwacje naukowcy_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.obserwacje
    ADD CONSTRAINT naukowcy_fk FOREIGN KEY (orcid_naukowcy) REFERENCES public.naukowcy(orcid) MATCH FULL ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: naukowcy_publikacje naukowcy_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.naukowcy_publikacje
    ADD CONSTRAINT naukowcy_fk FOREIGN KEY (orcid_naukowcy) REFERENCES public.naukowcy(orcid) MATCH FULL ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: teleskopy obserwatoria_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.teleskopy
    ADD CONSTRAINT obserwatoria_fk FOREIGN KEY (id_obserwatoria) REFERENCES public.obserwatoria(id) MATCH FULL ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: naukowcy_publikacje publikacje_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.naukowcy_publikacje
    ADD CONSTRAINT publikacje_fk FOREIGN KEY (issn_publikacje) REFERENCES public.publikacje(issn) MATCH FULL ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: obserwacje teleskopy_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.obserwacje
    ADD CONSTRAINT teleskopy_fk FOREIGN KEY (id_teleskopy) REFERENCES public.teleskopy(id) MATCH FULL ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: ciala_niebieskie typy_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ciala_niebieskie
    ADD CONSTRAINT typy_fk FOREIGN KEY (nr_katalogowy_typy) REFERENCES public.typy(nr_katalogowy) MATCH FULL ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: astronomia_stosowana; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: postgres
--

REFRESH MATERIALIZED VIEW public.astronomia_stosowana;


--
-- Name: temperatury_gwiazd; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: postgres
--

REFRESH MATERIALIZED VIEW public.temperatury_gwiazd;


--
-- PostgreSQL database dump complete
--

