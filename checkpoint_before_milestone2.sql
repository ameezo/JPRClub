--
-- PostgreSQL database dump
--

\restrict ozUFu80SG68dXZ9ftrxKbhN6cqj7DNKdBgISGg6lPfSGY1PkwTE1SQtF1E1Dn7f

-- Dumped from database version 16.15
-- Dumped by pg_dump version 16.15

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
-- Name: journalstatus; Type: TYPE; Schema: public; Owner: jprclub
--

CREATE TYPE public.journalstatus AS ENUM (
    'draft',
    'pending',
    'approved',
    'rejected'
);


ALTER TYPE public.journalstatus OWNER TO jprclub;

--
-- Name: sessionstatus; Type: TYPE; Schema: public; Owner: jprclub
--

CREATE TYPE public.sessionstatus AS ENUM (
    'draft',
    'published',
    'cancelled',
    'completed'
);


ALTER TYPE public.sessionstatus OWNER TO jprclub;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: alembic_version; Type: TABLE; Schema: public; Owner: jprclub
--

CREATE TABLE public.alembic_version (
    version_num character varying(32) NOT NULL
);


ALTER TABLE public.alembic_version OWNER TO jprclub;

--
-- Name: audit_logs; Type: TABLE; Schema: public; Owner: jprclub
--

CREATE TABLE public.audit_logs (
    id integer NOT NULL,
    "timestamp" timestamp with time zone DEFAULT now(),
    method character varying(10),
    path character varying(255),
    ip_address character varying(50),
    user_agent character varying(512),
    status_code integer,
    process_time double precision,
    user_id uuid
);


ALTER TABLE public.audit_logs OWNER TO jprclub;

--
-- Name: audit_logs_id_seq; Type: SEQUENCE; Schema: public; Owner: jprclub
--

CREATE SEQUENCE public.audit_logs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.audit_logs_id_seq OWNER TO jprclub;

--
-- Name: audit_logs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jprclub
--

ALTER SEQUENCE public.audit_logs_id_seq OWNED BY public.audit_logs.id;


--
-- Name: journal_submissions; Type: TABLE; Schema: public; Owner: jprclub
--

CREATE TABLE public.journal_submissions (
    id uuid NOT NULL,
    title character varying NOT NULL,
    title_ar character varying,
    content text NOT NULL,
    content_ar text,
    status public.journalstatus NOT NULL,
    author_id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    published_at timestamp with time zone,
    version integer NOT NULL,
    cover_image_url character varying,
    content_format character varying DEFAULT 'markdown'::character varying NOT NULL,
    content_language character varying DEFAULT 'en'::character varying NOT NULL
);


ALTER TABLE public.journal_submissions OWNER TO jprclub;

--
-- Name: session_interests; Type: TABLE; Schema: public; Owner: jprclub
--

CREATE TABLE public.session_interests (
    id uuid NOT NULL,
    type character varying(50) NOT NULL,
    full_name character varying(255) NOT NULL,
    email character varying(255) NOT NULL,
    phone character varying(100) NOT NULL,
    message text,
    session_id uuid,
    status character varying(50) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.session_interests OWNER TO jprclub;

--
-- Name: sessions; Type: TABLE; Schema: public; Owner: jprclub
--

CREATE TABLE public.sessions (
    id uuid NOT NULL,
    title character varying NOT NULL,
    title_ar character varying,
    description text NOT NULL,
    description_ar text,
    material_type character varying NOT NULL,
    chapters character varying,
    level character varying,
    scheduled_at timestamp with time zone NOT NULL,
    duration_minutes integer,
    status public.sessionstatus NOT NULL,
    cover_image_url character varying,
    idempotency_key character varying,
    created_by uuid NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    published_at timestamp with time zone,
    version integer NOT NULL,
    studio_content text,
    gallery_images json,
    studio_content_format character varying DEFAULT 'markdown'::character varying NOT NULL,
    documentation_status character varying DEFAULT 'none'::character varying NOT NULL
);


ALTER TABLE public.sessions OWNER TO jprclub;

--
-- Name: users; Type: TABLE; Schema: public; Owner: jprclub
--

CREATE TABLE public.users (
    id uuid NOT NULL,
    email character varying NOT NULL,
    name character varying NOT NULL,
    hashed_password character varying NOT NULL,
    role character varying NOT NULL
);


ALTER TABLE public.users OWNER TO jprclub;

--
-- Name: audit_logs id; Type: DEFAULT; Schema: public; Owner: jprclub
--

ALTER TABLE ONLY public.audit_logs ALTER COLUMN id SET DEFAULT nextval('public.audit_logs_id_seq'::regclass);


--
-- Data for Name: alembic_version; Type: TABLE DATA; Schema: public; Owner: jprclub
--

COPY public.alembic_version (version_num) FROM stdin;
e66c99bf4982
\.


--
-- Data for Name: audit_logs; Type: TABLE DATA; Schema: public; Owner: jprclub
--

COPY public.audit_logs (id, "timestamp", method, path, ip_address, user_agent, status_code, process_time, user_id) FROM stdin;
1	2026-10-07 22:10:26.865824+00	GET	/api/v1/sessions/next	172.24.0.1	curl/8.7.1	404	0.004829883575439453	\N
2	2026-10-07 22:10:27.557007+00	GET	/api/users	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.0058667659759521484	\N
3	2026-10-07 22:10:27.567716+00	GET	/api/users	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.002045154571533203	\N
4	2026-10-07 22:10:28.144163+00	GET	/api/journal	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.005793571472167969	\N
5	2026-10-07 22:10:28.142407+00	GET	/api/journal	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.0045320987701416016	\N
6	2026-10-07 22:10:29.758069+00	GET	/api/sessions	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.04849863052368164	\N
7	2026-10-07 22:10:29.784816+00	GET	/api/sessions	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.017525911331176758	\N
9	2026-10-07 22:10:31.277719+00	GET	/api/journal	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.0013606548309326172	\N
8	2026-10-07 22:10:31.277318+00	GET	/api/journal	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.0035686492919921875	\N
10	2026-10-07 22:10:32.877898+00	GET	/api/journal	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.005171298980712891	\N
11	2026-10-07 22:10:33.303789+00	GET	/api/journal	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.0020933151245117188	\N
12	2026-10-07 22:10:33.856097+00	GET	/api/journal	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.001711130142211914	\N
13	2026-10-07 22:10:36.562402+00	GET	/api/sessions/next	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.10741615295410156	\N
14	2026-10-07 22:10:36.564344+00	GET	/api/sessions	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.06473159790039062	\N
15	2026-10-07 22:10:36.593533+00	GET	/api/sessions	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.10987091064453125	\N
16	2026-10-07 22:10:36.607637+00	GET	/api/sessions	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.004596233367919922	\N
17	2026-10-07 22:10:36.612113+00	GET	/api/sessions/next	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.03261542320251465	\N
18	2026-10-07 22:10:36.611551+00	GET	/api/sessions	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.03359723091125488	\N
19	2026-10-07 22:10:38.964992+00	GET	/api/sessions/next	172.24.0.1	curl/8.7.1	200	0.018445730209350586	\N
20	2026-10-07 22:10:39.40645+00	GET	/api/journal/public	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.035446882247924805	\N
21	2026-10-07 22:10:39.428384+00	GET	/api/journal/public	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.016172409057617188	\N
22	2026-10-07 22:10:41.86855+00	GET	/api/sessions	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.02461528778076172	\N
23	2026-10-07 22:10:41.899129+00	GET	/api/sessions	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0035316944122314453	\N
24	2026-10-07 22:10:42.178757+00	GET	/api/sessions	172.24.0.1	curl/8.7.1	200	0.013668060302734375	\N
25	2026-10-07 22:10:42.762613+00	GET	/api/users	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.007054805755615234	\N
26	2026-10-07 22:10:42.762231+00	GET	/api/users	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.006482839584350586	\N
28	2026-10-07 22:10:43.271467+00	GET	/api/audit	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.012193441390991211	\N
27	2026-10-07 22:10:43.269251+00	GET	/api/audit	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.00803375244140625	\N
29	2026-10-07 22:10:48.762651+00	GET	/api/audit	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.0072174072265625	\N
30	2026-10-07 22:10:48.761456+00	GET	/api/audit	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.006886482238769531	\N
31	2026-10-07 22:10:50.716317+00	GET	/api/journal/dda23ea8-273a-4cdb-8960-59331db60cfa	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.031760454177856445	\N
32	2026-10-07 22:10:50.718131+00	GET	/api/journal/dda23ea8-273a-4cdb-8960-59331db60cfa	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.05751466751098633	\N
33	2026-10-07 22:10:53.176012+00	GET	/api/audit	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.013348102569580078	\N
34	2026-10-07 22:10:53.178082+00	GET	/api/audit	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.009225845336914062	\N
36	2026-10-07 22:10:56.348219+00	GET	/api/audit	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.008982419967651367	\N
35	2026-10-07 22:10:56.349346+00	GET	/api/audit	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.0158994197845459	\N
37	2026-10-07 22:10:58.011387+00	GET	/api/sessions/next	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.041547298431396484	\N
38	2026-10-07 22:10:58.013362+00	GET	/api/sessions	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.04567265510559082	\N
40	2026-10-07 22:10:58.047387+00	GET	/api/sessions	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.007219791412353516	\N
39	2026-10-07 22:10:58.046953+00	GET	/api/sessions/next	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.006562232971191406	\N
41	2026-10-07 22:10:58.057134+00	GET	/api/sessions	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.04678511619567871	\N
42	2026-10-07 22:10:58.07992+00	GET	/api/sessions	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.004014730453491211	\N
43	2026-10-07 22:10:58.47315+00	GET	/api/journal/dda23ea8-273a-4cdb-8960-59331db60cfa	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.007041454315185547	\N
44	2026-10-07 22:10:58.506888+00	GET	/api/journal/dda23ea8-273a-4cdb-8960-59331db60cfa	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.02662372589111328	\N
45	2026-10-07 22:10:59.41347+00	GET	/api/sessions	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.020420312881469727	\N
47	2026-10-07 22:11:03.730287+00	GET	/api/audit	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.00955820083618164	\N
52	2026-10-07 22:11:14.720781+00	GET	/api/sessions/next	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0036745071411132812	2b3f77bc-0f82-4c55-aa05-41d12db6b770
54	2026-10-07 22:11:14.756828+00	GET	/api/sessions	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.07864570617675781	2b3f77bc-0f82-4c55-aa05-41d12db6b770
57	2026-10-07 22:11:20.251267+00	GET	/api/audit	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.013195514678955078	\N
65	2026-10-07 22:11:54.373137+00	GET	/api/auth/me	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.03465604782104492	2b3f77bc-0f82-4c55-aa05-41d12db6b770
69	2026-10-07 22:12:09.483184+00	GET	/api/audit	172.24.0.1	curl/8.7.1	401	0.005659580230712891	\N
1256	2026-10-08 17:37:28.262597+00	PATCH	/api/journal/e1b9db18-3f6f-41c4-8498-f18a574ebc7e	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.06697344779968262	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1259	2026-10-08 17:38:37.141544+00	PATCH	/api/journal/e1b9db18-3f6f-41c4-8498-f18a574ebc7e	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.06717586517333984	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1264	2026-10-08 17:39:59.844745+00	PATCH	/api/journal/e1b9db18-3f6f-41c4-8498-f18a574ebc7e	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.04847121238708496	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1267	2026-10-08 17:40:18.455116+00	PATCH	/api/journal/e1b9db18-3f6f-41c4-8498-f18a574ebc7e	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.05433940887451172	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1270	2026-10-08 17:40:29.365859+00	PATCH	/api/journal/e1b9db18-3f6f-41c4-8498-f18a574ebc7e	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.043237924575805664	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1273	2026-10-08 17:41:09.145292+00	PATCH	/api/journal/e1b9db18-3f6f-41c4-8498-f18a574ebc7e	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.05604815483093262	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1276	2026-10-08 17:41:12.290074+00	GET	/api/journal/e1b9db18-3f6f-41c4-8498-f18a574ebc7e	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.011502265930175781	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1483	2026-10-08 18:22:45.549071+00	GET	/api/auth/me	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	401	0.0004792213439941406	\N
1485	2026-10-08 18:24:46.761116+00	POST	/api/upload	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	201	0.11529779434204102	2b3f77bc-0f82-4c55-aa05-41d12db6b770
1491	2026-10-08 18:24:54.553433+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0059659481048583984	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1495	2026-10-08 18:24:59.819184+00	POST	/api/journal/de99b413-6a92-48c8-823d-17d0e2ed6b07/approve	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0402066707611084	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1699	2026-10-08 20:19:07.370322+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.06148338317871094	2b3f77bc-0f82-4c55-aa05-41d12db6b770
1700	2026-10-08 20:19:48.773058+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.01865673065185547	2b3f77bc-0f82-4c55-aa05-41d12db6b770
1703	2026-10-08 20:19:48.811512+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.09131264686584473	2b3f77bc-0f82-4c55-aa05-41d12db6b770
1958	2026-10-08 20:48:03.98606+00	GET	/api/sessions/77722f17-88b9-4ae3-8438-91cd12eced8f	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.10128045082092285	\N
1961	2026-10-08 20:49:04.266257+00	PATCH	/api/sessions/77722f17-88b9-4ae3-8438-91cd12eced8f/documentation	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	401	0.01987743377685547	\N
1964	2026-10-08 20:49:42.184184+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.010206937789916992	\N
1966	2026-10-08 20:49:54.595446+00	GET	/api/sessions/f29b7e3c-59c5-4380-9af4-96cec59b69bd	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.006600856781005859	\N
1967	2026-10-08 20:50:03.419162+00	PATCH	/api/sessions/f29b7e3c-59c5-4380-9af4-96cec59b69bd/documentation	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	401	0.013166666030883789	\N
1968	2026-10-08 20:50:09.487555+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.032889366149902344	\N
1970	2026-10-08 20:52:39.243484+00	POST	/api/auth/login	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.37540721893310547	\N
1972	2026-10-08 20:52:39.31405+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.002994537353515625	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1974	2026-10-08 20:52:47.018383+00	GET	/api/sessions/77722f17-88b9-4ae3-8438-91cd12eced8f	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.00464177131652832	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1975	2026-10-08 20:53:35.415883+00	PATCH	/api/sessions/77722f17-88b9-4ae3-8438-91cd12eced8f/documentation	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.057891845703125	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1976	2026-10-08 20:53:54.514873+00	PATCH	/api/sessions/77722f17-88b9-4ae3-8438-91cd12eced8f/documentation	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0654592514038086	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1977	2026-10-08 20:54:15.323787+00	PATCH	/api/sessions/77722f17-88b9-4ae3-8438-91cd12eced8f/documentation	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.19319844245910645	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1979	2026-10-08 20:54:15.456881+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.009677410125732422	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1981	2026-10-08 20:54:44.537221+00	GET	/api/sessions/77722f17-88b9-4ae3-8438-91cd12eced8f	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.006659507751464844	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1982	2026-10-08 20:54:49.698803+00	PATCH	/api/sessions/77722f17-88b9-4ae3-8438-91cd12eced8f/documentation	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.04371833801269531	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2288	2026-10-08 21:28:54.335954+00	POST	/api/auth/login	127.0.0.1	python-httpx/0.28.1	200	0.24230718612670898	\N
46	2026-10-07 22:10:59.438446+00	GET	/api/sessions	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0029931068420410156	\N
51	2026-10-07 22:11:14.715046+00	GET	/api/sessions	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.007116556167602539	2b3f77bc-0f82-4c55-aa05-41d12db6b770
56	2026-10-07 22:11:20.098995+00	GET	/api/audit	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.017449140548706055	\N
61	2026-10-07 22:11:32.425883+00	GET	/api/sessions	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.05114006996154785	\N
63	2026-10-07 22:11:48.711895+00	GET	/api/journal/public	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.042584896087646484	\N
1257	2026-10-08 17:37:31.174778+00	PATCH	/api/journal/e1b9db18-3f6f-41c4-8498-f18a574ebc7e	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.020751237869262695	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1260	2026-10-08 17:38:42.623672+00	PATCH	/api/journal/e1b9db18-3f6f-41c4-8498-f18a574ebc7e	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.019452810287475586	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1489	2026-10-08 18:24:50.981959+00	GET	/api/auth/me	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0077016353607177734	2b3f77bc-0f82-4c55-aa05-41d12db6b770
1500	2026-10-08 18:25:05.448135+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.007348299026489258	2b3f77bc-0f82-4c55-aa05-41d12db6b770
1698	2026-10-08 20:19:07.367016+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.05749154090881348	2b3f77bc-0f82-4c55-aa05-41d12db6b770
1960	2026-10-08 20:48:56.880455+00	PATCH	/api/sessions/77722f17-88b9-4ae3-8438-91cd12eced8f/documentation	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	401	0.026951074600219727	\N
1962	2026-10-08 20:49:16.901031+00	PATCH	/api/sessions/77722f17-88b9-4ae3-8438-91cd12eced8f/documentation	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	401	0.009052753448486328	\N
1963	2026-10-08 20:49:42.155809+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.047763824462890625	\N
1965	2026-10-08 20:49:54.574524+00	GET	/api/sessions/f29b7e3c-59c5-4380-9af4-96cec59b69bd	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.03025078773498535	\N
1969	2026-10-08 20:50:09.504146+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.003042459487915039	\N
1971	2026-10-08 20:52:39.298427+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.011925697326660156	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1973	2026-10-08 20:52:46.997832+00	GET	/api/sessions/77722f17-88b9-4ae3-8438-91cd12eced8f	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.03641080856323242	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1978	2026-10-08 20:54:15.439365+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.031899452209472656	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1980	2026-10-08 20:54:44.507007+00	GET	/api/sessions/77722f17-88b9-4ae3-8438-91cd12eced8f	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.04512524604797363	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1984	2026-10-08 20:54:49.913279+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.00908041000366211	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1986	2026-10-08 20:55:04.061064+00	GET	/api/sessions/77722f17-88b9-4ae3-8438-91cd12eced8f	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.022234201431274414	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1988	2026-10-08 20:55:15.21718+00	GET	/api/sessions/77722f17-88b9-4ae3-8438-91cd12eced8f	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.02293086051940918	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1993	2026-10-08 20:57:54.125306+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.1743030548095703	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2005	2026-10-08 20:58:09.812742+00	GET	/api/users	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.006894111633300781	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2010	2026-10-08 20:58:13.025436+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.04172825813293457	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2012	2026-10-08 20:58:16.508308+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.008650541305541992	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2016	2026-10-08 20:58:18.766918+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0071904659271240234	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2024	2026-10-08 20:58:25.288316+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.004544496536254883	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2038	2026-10-08 20:58:37.610949+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.011585235595703125	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2048	2026-10-08 20:58:42.609583+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.005888462066650391	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2057	2026-10-08 20:58:46.304939+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.017246484756469727	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2059	2026-10-08 20:58:46.324524+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.005004405975341797	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2060	2026-10-08 20:58:49.103018+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.007334470748901367	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2062	2026-10-08 20:58:50.976073+00	GET	/api/users	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.023672103881835938	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2064	2026-10-08 20:58:51.892338+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.022974491119384766	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2066	2026-10-08 20:58:53.056675+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.02922368049621582	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2068	2026-10-08 20:58:57.44899+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.010309696197509766	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2070	2026-10-08 20:59:01.1388+00	GET	/api/users	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0029401779174804688	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2289	2026-10-08 21:28:54.366668+00	POST	/api/sessions	127.0.0.1	python-httpx/0.28.1	201	0.023277759552001953	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
48	2026-10-07 22:11:03.729051+00	GET	/api/audit	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.022411108016967773	\N
58	2026-10-07 22:11:27.86953+00	GET	/api/openapi.json	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.15681791305541992	\N
1258	2026-10-08 17:37:38.92354+00	PATCH	/api/journal/e1b9db18-3f6f-41c4-8498-f18a574ebc7e	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.08505964279174805	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1261	2026-10-08 17:38:51.205421+00	PATCH	/api/journal/e1b9db18-3f6f-41c4-8498-f18a574ebc7e	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.04717659950256348	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1501	2026-10-08 18:25:09.67769+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.02498149871826172	2b3f77bc-0f82-4c55-aa05-41d12db6b770
1510	2026-10-08 18:25:14.783224+00	GET	/api/journal/de99b413-6a92-48c8-823d-17d0e2ed6b07	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.03763389587402344	2b3f77bc-0f82-4c55-aa05-41d12db6b770
1512	2026-10-08 18:25:15.747853+00	GET	/api/journal/public	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.025644302368164062	2b3f77bc-0f82-4c55-aa05-41d12db6b770
1701	2026-10-08 20:19:48.803317+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.029810667037963867	2b3f77bc-0f82-4c55-aa05-41d12db6b770
1983	2026-10-08 20:54:49.733757+00	POST	/api/sessions/77722f17-88b9-4ae3-8438-91cd12eced8f/publish-studio	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.01726245880126953	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1985	2026-10-08 20:54:49.945658+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0072629451751708984	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1987	2026-10-08 20:55:04.090311+00	GET	/api/sessions/77722f17-88b9-4ae3-8438-91cd12eced8f	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0026597976684570312	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1989	2026-10-08 20:55:15.234726+00	GET	/api/sessions/77722f17-88b9-4ae3-8438-91cd12eced8f	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.001834869384765625	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1994	2026-10-08 20:57:54.127486+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.1784069538116455	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1996	2026-10-08 20:57:55.585748+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.004895687103271484	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1998	2026-10-08 20:58:05.854256+00	POST	/api/auth/login	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.2813255786895752	\N
1999	2026-10-08 20:58:05.942421+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0039215087890625	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2001	2026-10-08 20:58:08.651324+00	GET	/api/users	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.03069901466369629	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2003	2026-10-08 20:58:09.344169+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.07989621162414551	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2153	2026-10-08 21:11:39.130242+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.05239391326904297	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2156	2026-10-08 21:12:48.136763+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.03033733367919922	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2158	2026-10-08 21:12:49.795823+00	GET	/api/journal/public	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.07435917854309082	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2170	2026-10-08 21:13:10.188524+00	GET	/api/journal/public	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.028238296508789062	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2179	2026-10-08 21:13:20.925014+00	GET	/api/journal/public	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.004012107849121094	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2181	2026-10-08 21:13:21.471977+00	GET	/api/journal/de99b413-6a92-48c8-823d-17d0e2ed6b07	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.010627269744873047	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2183	2026-10-08 21:13:23.597015+00	GET	/api/journal/public	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.010173797607421875	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2185	2026-10-08 21:13:24.39437+00	GET	/api/journal/e1b9db18-3f6f-41c4-8498-f18a574ebc7e	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0024423599243164062	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2187	2026-10-08 21:13:25.991548+00	GET	/api/journal/public	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.041440486907958984	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2188	2026-10-08 21:13:27.091457+00	GET	/api/journal/bb701e5a-271b-40b8-8298-1b903317aee1	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.004420757293701172	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2190	2026-10-08 21:13:29.86764+00	GET	/api/journal/public	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.03338027000427246	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2192	2026-10-08 21:13:31.109711+00	GET	/api/journal/dda23ea8-273a-4cdb-8960-59331db60cfa	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.013562440872192383	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2194	2026-10-08 21:15:44.467862+00	GET	/api/journal/public	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.04072380065917969	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2196	2026-10-08 21:16:43.45813+00	GET	/api/journal/public	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.01966547966003418	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2290	2026-10-08 21:28:54.378065+00	POST	/api/sessions/dcc69d2a-0366-4f91-a8a8-d41cc0724919/publish	127.0.0.1	python-httpx/0.28.1	200	0.007604122161865234	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2291	2026-10-08 21:28:54.386952+00	POST	/api/sessions/dcc69d2a-0366-4f91-a8a8-d41cc0724919/complete	127.0.0.1	python-httpx/0.28.1	200	0.0054090023040771484	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2293	2026-10-08 21:28:54.399553+00	GET	/api/sessions/dcc69d2a-0366-4f91-a8a8-d41cc0724919	127.0.0.1	python-httpx/0.28.1	200	0.0016257762908935547	\N
2294	2026-10-08 21:28:54.411098+00	PATCH	/api/sessions/dcc69d2a-0366-4f91-a8a8-d41cc0724919	127.0.0.1	python-httpx/0.28.1	200	0.007735252380371094	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2295	2026-10-08 21:28:54.422354+00	POST	/api/sessions/dcc69d2a-0366-4f91-a8a8-d41cc0724919/publish-studio	127.0.0.1	python-httpx/0.28.1	200	0.0064470767974853516	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2296	2026-10-08 21:28:54.432768+00	POST	/api/sessions/dcc69d2a-0366-4f91-a8a8-d41cc0724919/unpublish-studio	127.0.0.1	python-httpx/0.28.1	200	0.006272077560424805	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2305	2026-10-08 21:28:54.76618+00	GET	/api/sessions	127.0.0.1	python-httpx/0.28.1	200	0.003650188446044922	\N
2306	2026-10-08 21:28:55.015974+00	POST	/api/auth/login	127.0.0.1	python-httpx/0.28.1	200	0.2416989803314209	\N
2308	2026-10-08 21:28:55.036479+00	POST	/api/upload/multiple	127.0.0.1	python-httpx/0.28.1	201	0.00422978401184082	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2537	2026-10-09 10:56:46.665039+00	POST	/api/journal	127.0.0.1	python-httpx/0.28.1	201	0.07312822341918945	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
49	2026-10-07 22:11:14.482586+00	POST	/api/auth/register	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	201	0.3219332695007324	\N
53	2026-10-07 22:11:14.741258+00	GET	/api/sessions	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0056383609771728516	2b3f77bc-0f82-4c55-aa05-41d12db6b770
55	2026-10-07 22:11:14.817675+00	GET	/api/sessions	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.01601552963256836	2b3f77bc-0f82-4c55-aa05-41d12db6b770
60	2026-10-07 22:11:31.316095+00	GET	/api/audit	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.02027440071105957	\N
62	2026-10-07 22:11:32.610521+00	GET	/api/sessions	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.11195039749145508	\N
64	2026-10-07 22:11:48.722351+00	GET	/api/journal/public	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0035088062286376953	\N
1262	2026-10-08 17:39:22.441278+00	POST	/api/upload	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	201	0.19278669357299805	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1265	2026-10-08 17:40:02.880538+00	PATCH	/api/journal/e1b9db18-3f6f-41c4-8498-f18a574ebc7e	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.024526357650756836	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1268	2026-10-08 17:40:22.332821+00	PATCH	/api/journal/e1b9db18-3f6f-41c4-8498-f18a574ebc7e	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.02384161949157715	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1271	2026-10-08 17:40:32.856365+00	PATCH	/api/journal/e1b9db18-3f6f-41c4-8498-f18a574ebc7e	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.019496917724609375	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1274	2026-10-08 17:41:10.499184+00	PATCH	/api/journal/e1b9db18-3f6f-41c4-8498-f18a574ebc7e	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.01749706268310547	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1279	2026-10-08 17:41:17.354403+00	GET	/api/journal/public	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.029066085815429688	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1503	2026-10-08 18:25:09.678368+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.024156570434570312	2b3f77bc-0f82-4c55-aa05-41d12db6b770
1506	2026-10-08 18:25:09.729428+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.09459424018859863	2b3f77bc-0f82-4c55-aa05-41d12db6b770
1511	2026-10-08 18:25:15.743548+00	GET	/api/journal/public	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.02092766761779785	2b3f77bc-0f82-4c55-aa05-41d12db6b770
1702	2026-10-08 20:19:48.803718+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.025188207626342773	2b3f77bc-0f82-4c55-aa05-41d12db6b770
1704	2026-10-08 20:19:48.824856+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0054149627685546875	2b3f77bc-0f82-4c55-aa05-41d12db6b770
1714	2026-10-08 20:20:17.572588+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.010514020919799805	2b3f77bc-0f82-4c55-aa05-41d12db6b770
1724	2026-10-08 20:22:02.781051+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.01688838005065918	2b3f77bc-0f82-4c55-aa05-41d12db6b770
1733	2026-10-08 20:22:08.602999+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.06178164482116699	2b3f77bc-0f82-4c55-aa05-41d12db6b770
1990	2026-10-08 20:57:54.078395+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.10266327857971191	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2154	2026-10-08 21:11:39.134802+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.07665586471557617	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2157	2026-10-08 21:12:48.137444+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.051410675048828125	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2164	2026-10-08 21:13:00.649943+00	GET	/api/sessions/f29b7e3c-59c5-4380-9af4-96cec59b69bd	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.024186372756958008	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2166	2026-10-08 21:13:04.380156+00	GET	/api/journal/public	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.024750232696533203	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2168	2026-10-08 21:13:04.812525+00	GET	/api/journal/e1b9db18-3f6f-41c4-8498-f18a574ebc7e	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.008930444717407227	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2176	2026-10-08 21:13:16.134342+00	GET	/api/journal/bb701e5a-271b-40b8-8298-1b903317aee1	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.009087324142456055	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2178	2026-10-08 21:13:20.908552+00	GET	/api/journal/public	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.027167081832885742	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2186	2026-10-08 21:13:25.990383+00	GET	/api/journal/public	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.03590273857116699	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2203	2026-10-08 21:16:44.210239+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.007282733917236328	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2205	2026-10-08 21:17:35.098334+00	GET	/api/sessions/77722f17-88b9-4ae3-8438-91cd12eced8f	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.05422401428222656	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2206	2026-10-08 21:17:37.962561+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.02564406394958496	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2211	2026-10-08 21:17:38.004505+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.003290414810180664	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2213	2026-10-08 21:17:56.96848+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0035581588745117188	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2215	2026-10-08 21:17:58.258793+00	GET	/api/sessions/8431bdef-789a-4a8e-a151-76ca4ff740db	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.006443023681640625	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2217	2026-10-08 21:18:02.074471+00	GET	/api/sessions/8431bdef-789a-4a8e-a151-76ca4ff740db	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.02282094955444336	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2218	2026-10-08 21:18:09.598008+00	PATCH	/api/sessions/8431bdef-789a-4a8e-a151-76ca4ff740db/documentation	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0390322208404541	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2222	2026-10-08 21:18:20.762782+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.025846481323242188	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2224	2026-10-08 21:18:21.276702+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.004951953887939453	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2226	2026-10-08 21:18:23.753196+00	GET	/api/sessions/f29b7e3c-59c5-4380-9af4-96cec59b69bd	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.005866050720214844	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
50	2026-10-07 22:11:14.699137+00	GET	/api/sessions/next	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.04053449630737305	2b3f77bc-0f82-4c55-aa05-41d12db6b770
59	2026-10-07 22:11:31.320622+00	GET	/api/audit	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.011477470397949219	\N
66	2026-10-07 22:11:54.427956+00	GET	/api/auth/me	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.05588102340698242	2b3f77bc-0f82-4c55-aa05-41d12db6b770
67	2026-10-07 22:11:54.423335+00	GET	/api/auth/me	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.03861880302429199	2b3f77bc-0f82-4c55-aa05-41d12db6b770
68	2026-10-07 22:11:54.423962+00	GET	/api/auth/me	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.05138564109802246	2b3f77bc-0f82-4c55-aa05-41d12db6b770
70	2026-10-07 22:12:12.825884+00	GET	/api/sessions	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.04902458190917969	2b3f77bc-0f82-4c55-aa05-41d12db6b770
71	2026-10-07 22:12:12.83179+00	GET	/api/sessions	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.025051355361938477	2b3f77bc-0f82-4c55-aa05-41d12db6b770
72	2026-10-07 22:12:12.838182+00	GET	/api/sessions/next	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.05949997901916504	2b3f77bc-0f82-4c55-aa05-41d12db6b770
73	2026-10-07 22:12:12.846469+00	GET	/api/sessions/next	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.05796670913696289	2b3f77bc-0f82-4c55-aa05-41d12db6b770
74	2026-10-07 22:12:12.852597+00	GET	/api/sessions	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.05045175552368164	2b3f77bc-0f82-4c55-aa05-41d12db6b770
75	2026-10-07 22:12:12.860592+00	GET	/api/sessions	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.05585360527038574	2b3f77bc-0f82-4c55-aa05-41d12db6b770
76	2026-10-07 22:12:15.866426+00	POST	/api/auth/login	172.24.0.1	Python-urllib/3.14	200	0.2656567096710205	\N
77	2026-10-07 22:12:15.884687+00	GET	/api/audit	172.24.0.1	Python-urllib/3.14	200	0.009860992431640625	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
78	2026-10-07 22:12:18.978378+00	GET	/api/audit	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.010787010192871094	\N
79	2026-10-07 22:12:18.979616+00	GET	/api/audit	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.01356816291809082	\N
80	2026-10-07 22:12:20.479863+00	GET	/api/users	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.005415201187133789	\N
81	2026-10-07 22:12:20.478518+00	GET	/api/users	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.0035126209259033203	\N
82	2026-10-07 22:12:21.164942+00	GET	/api/journal	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.005217075347900391	\N
83	2026-10-07 22:12:21.163103+00	GET	/api/journal	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.003797769546508789	\N
84	2026-10-07 22:12:22.666423+00	GET	/api/journal	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.0032460689544677734	\N
85	2026-10-07 22:12:23.146737+00	GET	/api/journal	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.002172231674194336	\N
86	2026-10-07 22:12:24.76488+00	GET	/api/journal	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.0017197132110595703	\N
87	2026-10-07 22:12:26.694438+00	GET	/api/journal	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.0016574859619140625	\N
89	2026-10-07 22:12:27.584442+00	GET	/api/users	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.005040168762207031	\N
88	2026-10-07 22:12:27.583337+00	GET	/api/users	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.003957271575927734	\N
91	2026-10-07 22:12:28.295743+00	GET	/api/journal	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.0034575462341308594	\N
90	2026-10-07 22:12:28.294133+00	GET	/api/journal	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.0023431777954101562	\N
92	2026-10-07 22:12:31.887379+00	GET	/api/auth/me	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0165557861328125	2b3f77bc-0f82-4c55-aa05-41d12db6b770
93	2026-10-07 22:12:31.904849+00	GET	/api/auth/me	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.009937286376953125	2b3f77bc-0f82-4c55-aa05-41d12db6b770
94	2026-10-07 22:12:31.905334+00	GET	/api/auth/me	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.003216981887817383	2b3f77bc-0f82-4c55-aa05-41d12db6b770
95	2026-10-07 22:12:31.927434+00	GET	/api/auth/me	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.008597612380981445	2b3f77bc-0f82-4c55-aa05-41d12db6b770
97	2026-10-07 22:12:36.949135+00	GET	/api/journal	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.009183883666992188	\N
96	2026-10-07 22:12:36.950616+00	GET	/api/journal	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.009918212890625	\N
98	2026-10-07 22:12:37.753492+00	GET	/api/users	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.0020325183868408203	\N
99	2026-10-07 22:12:37.756957+00	GET	/api/users	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.003099203109741211	\N
100	2026-10-07 22:12:39.123625+00	GET	/api/users	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.0011322498321533203	\N
101	2026-10-07 22:12:39.145329+00	GET	/api/users	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.0011959075927734375	\N
102	2026-10-07 22:12:40.152069+00	GET	/api/users	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.009020090103149414	\N
103	2026-10-07 22:12:40.153051+00	GET	/api/users	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.014879465103149414	\N
104	2026-10-07 22:12:41.13608+00	GET	/api/users	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.0034110546112060547	\N
105	2026-10-07 22:12:41.133734+00	GET	/api/users	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.0019893646240234375	\N
106	2026-10-07 22:14:11.539133+00	GET	/api/users	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.014254331588745117	\N
107	2026-10-07 22:14:11.54262+00	GET	/api/users	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.0179288387298584	\N
108	2026-10-07 22:14:13.031847+00	GET	/api/journal	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.003054380416870117	\N
109	2026-10-07 22:14:13.033337+00	GET	/api/journal	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.002912282943725586	\N
110	2026-10-07 22:14:13.586064+00	GET	/api/audit	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.004455089569091797	\N
115	2026-10-07 22:14:18.251422+00	GET	/api/users	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.0037806034088134766	\N
1263	2026-10-08 17:39:38.150324+00	PATCH	/api/journal/e1b9db18-3f6f-41c4-8498-f18a574ebc7e	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.04975605010986328	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1266	2026-10-08 17:40:08.478481+00	PATCH	/api/journal/e1b9db18-3f6f-41c4-8498-f18a574ebc7e	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.024252891540527344	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1269	2026-10-08 17:40:24.956257+00	PATCH	/api/journal/e1b9db18-3f6f-41c4-8498-f18a574ebc7e	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.013594627380371094	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1272	2026-10-08 17:40:36.444257+00	PATCH	/api/journal/e1b9db18-3f6f-41c4-8498-f18a574ebc7e	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.032865285873413086	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1275	2026-10-08 17:41:10.520544+00	POST	/api/journal/e1b9db18-3f6f-41c4-8498-f18a574ebc7e/approve	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.012131452560424805	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1277	2026-10-08 17:41:12.292279+00	GET	/api/journal/e1b9db18-3f6f-41c4-8498-f18a574ebc7e	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.010069131851196289	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1278	2026-10-08 17:41:17.350483+00	GET	/api/journal/public	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.008828163146972656	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1502	2026-10-08 18:25:09.680915+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.020568370819091797	2b3f77bc-0f82-4c55-aa05-41d12db6b770
1717	2026-10-08 20:20:17.594375+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.014585256576538086	2b3f77bc-0f82-4c55-aa05-41d12db6b770
1991	2026-10-08 20:57:54.080414+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.11400580406188965	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1992	2026-10-08 20:57:54.114875+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.16397929191589355	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1995	2026-10-08 20:57:54.136552+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.03554892539978027	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2171	2026-10-08 21:13:10.189314+00	GET	/api/journal/public	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.01642632484436035	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2172	2026-10-08 21:13:11.970924+00	GET	/api/journal/dda23ea8-273a-4cdb-8960-59331db60cfa	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.01190185546875	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2174	2026-10-08 21:13:14.988959+00	GET	/api/journal/public	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.015772342681884766	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2189	2026-10-08 21:13:27.096986+00	GET	/api/journal/bb701e5a-271b-40b8-8298-1b903317aee1	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.00260162353515625	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2191	2026-10-08 21:13:29.883974+00	GET	/api/journal/public	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0046558380126953125	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2193	2026-10-08 21:13:31.125173+00	GET	/api/journal/dda23ea8-273a-4cdb-8960-59331db60cfa	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.007955074310302734	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2195	2026-10-08 21:15:44.487737+00	GET	/api/journal/public	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.006200075149536133	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2197	2026-10-08 21:16:43.469525+00	GET	/api/journal/public	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.00409698486328125	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2198	2026-10-08 21:16:44.132994+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.022019386291503906	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2300	2026-10-08 21:28:54.719835+00	POST	/api/sessions	127.0.0.1	python-httpx/0.28.1	201	0.008324861526489258	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2301	2026-10-08 21:28:54.73019+00	POST	/api/sessions/8465d5a4-42eb-4182-a2c8-e11f391afdf6/publish	127.0.0.1	python-httpx/0.28.1	200	0.006023883819580078	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2302	2026-10-08 21:28:54.73833+00	POST	/api/sessions/8465d5a4-42eb-4182-a2c8-e11f391afdf6/complete-and-document	127.0.0.1	python-httpx/0.28.1	200	0.005244016647338867	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2303	2026-10-08 21:28:54.748408+00	PATCH	/api/sessions/8465d5a4-42eb-4182-a2c8-e11f391afdf6/documentation	127.0.0.1	python-httpx/0.28.1	200	0.0067138671875	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2304	2026-10-08 21:28:54.759078+00	POST	/api/sessions/8465d5a4-42eb-4182-a2c8-e11f391afdf6/publish-studio	127.0.0.1	python-httpx/0.28.1	200	0.005870819091796875	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2307	2026-10-08 21:28:55.026208+00	POST	/api/upload	127.0.0.1	python-httpx/0.28.1	201	0.0040781497955322266	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2309	2026-10-08 21:28:55.044956+00	POST	/api/upload	127.0.0.1	python-httpx/0.28.1	400	0.003111124038696289	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2334	2026-10-08 21:29:16.930048+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.03989529609680176	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2344	2026-10-08 21:33:20.60399+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.008380651473999023	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2346	2026-10-08 21:33:20.694357+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.754436731338501	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2348	2026-10-08 21:33:39.13754+00	GET	/api/sessions/f29b7e3c-59c5-4380-9af4-96cec59b69bd	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.07561349868774414	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2350	2026-10-08 21:33:47.968423+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.05326032638549805	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2352	2026-10-08 21:34:01.8648+00	GET	/api/sessions/1bc6dfe0-cc1d-4446-995b-64c17d34623f	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.023852109909057617	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2354	2026-10-08 21:34:10.838522+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.027601242065429688	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2357	2026-10-08 21:36:39.376875+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0087738037109375	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2384	2026-10-08 21:39:25.522133+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.03481173515319824	\N
2386	2026-10-08 21:39:34.255446+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.02383112907409668	\N
2538	2026-10-09 10:56:46.674302+00	PATCH	/api/journal/2a2e231e-4a5b-4386-913a-4603ddb2d7dc	127.0.0.1	python-httpx/0.28.1	200	0.0061914920806884766	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
111	2026-10-07 22:14:13.584212+00	GET	/api/audit	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.002929210662841797	\N
122	2026-10-07 22:14:42.036442+00	GET	/api/journal	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.029863357543945312	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
123	2026-10-07 22:14:43.329937+00	GET	/api/audit	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.01629948616027832	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
125	2026-10-07 22:14:59.525854+00	GET	/api/users	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.024222373962402344	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
127	2026-10-07 22:15:04.158453+00	GET	/api/journal	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.028456687927246094	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
129	2026-10-07 22:15:05.363618+00	GET	/api/journal	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.006752967834472656	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
131	2026-10-07 22:15:06.204361+00	GET	/api/journal	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.012160778045654297	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
133	2026-10-07 22:15:06.914987+00	GET	/api/users	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.002437591552734375	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
135	2026-10-07 22:15:09.425379+00	GET	/api/sessions	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0022287368774414062	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
137	2026-10-07 22:15:11.606772+00	GET	/api/users	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.002399444580078125	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1280	2026-10-08 17:41:25.515698+00	GET	/api/journal/dda23ea8-273a-4cdb-8960-59331db60cfa	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.024118661880493164	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1290	2026-10-08 17:44:38.554093+00	GET	/api/auth/me	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.005463838577270508	\N
1300	2026-10-08 17:44:46.163216+00	GET	/api/auth/me	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.014322280883789062	\N
1307	2026-10-08 17:44:48.777324+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.03212380409240723	\N
1311	2026-10-08 17:44:50.553873+00	GET	/api/auth/me	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.009839057922363281	\N
1316	2026-10-08 17:44:52.739205+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.004975795745849609	\N
1504	2026-10-08 18:25:09.683402+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.03114604949951172	2b3f77bc-0f82-4c55-aa05-41d12db6b770
1507	2026-10-08 18:25:12.456118+00	GET	/api/journal/public	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.03775191307067871	2b3f77bc-0f82-4c55-aa05-41d12db6b770
1720	2026-10-08 20:22:02.717152+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.019100666046142578	2b3f77bc-0f82-4c55-aa05-41d12db6b770
1723	2026-10-08 20:22:02.767062+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.005036830902099609	2b3f77bc-0f82-4c55-aa05-41d12db6b770
1997	2026-10-08 20:57:55.586164+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.008220672607421875	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2008	2026-10-08 20:58:10.366237+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.010663747787475586	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2014	2026-10-08 20:58:18.733974+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.013678550720214844	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2020	2026-10-08 20:58:21.48696+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.016718149185180664	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2025	2026-10-08 20:58:25.296889+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.009355306625366211	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2201	2026-10-08 21:16:44.181316+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.01989006996154785	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2207	2026-10-08 21:17:37.96456+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.030840158462524414	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2245	2026-10-08 21:19:58.82267+00	POST	/api/upload	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	201	0.13503646850585938	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2249	2026-10-08 21:20:06.808384+00	PATCH	/api/sessions/1bc6dfe0-cc1d-4446-995b-64c17d34623f/documentation	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.03931117057800293	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2251	2026-10-08 21:20:29.324158+00	POST	/api/upload	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	201	0.024590730667114258	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2254	2026-10-08 21:20:34.247781+00	POST	/api/sessions/1bc6dfe0-cc1d-4446-995b-64c17d34623f/publish-studio	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.007467985153198242	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2256	2026-10-08 21:20:36.269244+00	GET	/api/sessions/1bc6dfe0-cc1d-4446-995b-64c17d34623f	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0018134117126464844	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2258	2026-10-08 21:20:56.675376+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.00535273551940918	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2260	2026-10-08 21:20:57.977523+00	GET	/api/sessions/8431bdef-789a-4a8e-a151-76ca4ff740db	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.008530855178833008	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2262	2026-10-08 21:21:59.684751+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.005389213562011719	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2264	2026-10-08 21:22:03.167861+00	GET	/api/sessions/1bc6dfe0-cc1d-4446-995b-64c17d34623f	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.003971576690673828	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2266	2026-10-08 21:22:06.385909+00	GET	/api/sessions/1bc6dfe0-cc1d-4446-995b-64c17d34623f	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.012756824493408203	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2271	2026-10-08 21:22:17.41003+00	GET	/api/sessions/1bc6dfe0-cc1d-4446-995b-64c17d34623f	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.00861501693725586	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2273	2026-10-08 21:22:21.450494+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.029161930084228516	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2275	2026-10-08 21:22:22.701382+00	GET	/api/sessions/8431bdef-789a-4a8e-a151-76ca4ff740db	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0066335201263427734	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2310	2026-10-08 21:29:08.624011+00	GET	/api/sessions/77722f17-88b9-4ae3-8438-91cd12eced8f	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.16805744171142578	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
112	2026-10-07 22:14:15.640263+00	GET	/api/audit	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.004972219467163086	\N
113	2026-10-07 22:14:15.639192+00	GET	/api/audit	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.005736589431762695	\N
114	2026-10-07 22:14:18.249041+00	GET	/api/users	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.002271413803100586	\N
116	2026-10-07 22:14:37.271119+00	POST	/api/auth/login	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.28206491470336914	\N
117	2026-10-07 22:14:37.354105+00	GET	/api/sessions	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.007740020751953125	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
118	2026-10-07 22:14:37.391253+00	GET	/api/sessions	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.03195476531982422	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
119	2026-10-07 22:14:40.741585+00	GET	/api/users	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.03285861015319824	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
120	2026-10-07 22:14:40.744175+00	GET	/api/users	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.019739866256713867	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
121	2026-10-07 22:14:42.03593+00	GET	/api/journal	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.028983116149902344	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
124	2026-10-07 22:14:43.33064+00	GET	/api/audit	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.017651796340942383	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
126	2026-10-07 22:14:59.539209+00	GET	/api/users	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.004433631896972656	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
128	2026-10-07 22:15:04.167772+00	GET	/api/journal	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.003917694091796875	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
130	2026-10-07 22:15:05.718132+00	GET	/api/journal	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.010156869888305664	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
132	2026-10-07 22:15:06.906496+00	GET	/api/users	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.01554560661315918	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
134	2026-10-07 22:15:09.417861+00	GET	/api/sessions	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.007391929626464844	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
136	2026-10-07 22:15:11.600519+00	GET	/api/users	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.00949716567993164	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
138	2026-10-07 22:15:12.113575+00	GET	/api/audit	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.010184288024902344	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
139	2026-10-07 22:15:12.126246+00	GET	/api/audit	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.00671696662902832	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
140	2026-10-07 22:16:43.578563+00	GET	/api/audit	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.011072874069213867	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
141	2026-10-07 22:16:43.580645+00	GET	/api/audit	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.025726795196533203	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
142	2026-10-07 22:16:46.238295+00	GET	/api/audit	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.008649587631225586	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
143	2026-10-07 22:16:46.245837+00	GET	/api/audit	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.004192352294921875	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
144	2026-10-07 22:16:51.566483+00	GET	/api/audit	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.01412820816040039	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
145	2026-10-07 22:16:51.568281+00	GET	/api/audit	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.009269475936889648	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
146	2026-10-07 22:16:52.803308+00	GET	/api/journal	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.004773855209350586	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
147	2026-10-07 22:16:52.826262+00	GET	/api/journal	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.018954753875732422	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
148	2026-10-07 22:16:53.603162+00	GET	/api/audit	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.007930517196655273	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
149	2026-10-07 22:16:53.610656+00	GET	/api/audit	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0036439895629882812	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
150	2026-10-07 22:18:20.934979+00	GET	/api/audit	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.03036189079284668	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
151	2026-10-07 22:18:20.94587+00	GET	/api/audit	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.004019498825073242	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
152	2026-10-07 22:19:03.334174+00	GET	/api/audit	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.028990983963012695	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
153	2026-10-07 22:19:03.346474+00	GET	/api/audit	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.00488734245300293	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
154	2026-10-07 22:24:46.34603+00	GET	/api/audit	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.02309870719909668	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
155	2026-10-07 22:24:46.363992+00	GET	/api/audit	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.006144523620605469	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
156	2026-10-07 22:49:42.183574+00	GET	/api/auth/me	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.027721643447875977	2b3f77bc-0f82-4c55-aa05-41d12db6b770
157	2026-10-07 22:49:42.199601+00	GET	/api/auth/me	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.006450176239013672	2b3f77bc-0f82-4c55-aa05-41d12db6b770
158	2026-10-07 22:49:42.200537+00	GET	/api/auth/me	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.003767728805541992	2b3f77bc-0f82-4c55-aa05-41d12db6b770
159	2026-10-07 22:49:42.242071+00	GET	/api/auth/me	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.00630950927734375	2b3f77bc-0f82-4c55-aa05-41d12db6b770
160	2026-10-07 22:49:47.642611+00	GET	/api/audit	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.027080535888671875	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
161	2026-10-07 22:49:47.65542+00	GET	/api/audit	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0034737586975097656	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
162	2026-10-08 00:03:29.650681+00	GET	/api/journal/public	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.4499518871307373	\N
163	2026-10-08 00:03:29.738366+00	GET	/api/journal/public	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.03931593894958496	\N
165	2026-10-08 00:10:02.915631+00	GET	/api/auth/me	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.01706719398498535	\N
164	2026-10-08 00:10:02.914282+00	GET	/api/auth/me	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.03579235076904297	\N
168	2026-10-08 00:15:20.488184+00	GET	/api/journal/public	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.14131999015808105	\N
170	2026-10-08 04:50:44.977316+00	GET	/api/journal/public	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.09991574287414551	\N
172	2026-10-08 05:04:35.983111+00	GET	/api/journal/public	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.03209352493286133	\N
174	2026-10-08 05:06:41.977234+00	GET	/api/journal/public	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.03860592842102051	\N
176	2026-10-08 05:15:57.163635+00	GET	/api/journal/public	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.044205665588378906	\N
178	2026-10-08 08:28:42.671153+00	GET	/api/journal/public	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.1104278564453125	\N
180	2026-10-08 09:21:17.400803+00	GET	/api/journal/public	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.1350114345550537	\N
182	2026-10-08 09:21:33.167452+00	GET	/api/journal/public	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.128800630569458	\N
184	2026-10-08 09:21:33.436115+00	GET	/api/journal/public	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.006395578384399414	\N
186	2026-10-08 09:47:11.675104+00	GET	/api/journal/public	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.12596893310546875	\N
188	2026-10-08 09:47:13.904225+00	GET	/api/journal/public	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0388333797454834	\N
190	2026-10-08 09:47:28.910827+00	GET	/api/journal/public	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.030046463012695312	\N
192	2026-10-08 09:50:17.050197+00	GET	/api/journal/public	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.03614449501037598	\N
194	2026-10-08 09:50:20.51962+00	GET	/api/journal/public	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.03737664222717285	\N
196	2026-10-08 09:50:33.199849+00	GET	/api/journal/public	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.04645800590515137	\N
198	2026-10-08 09:59:19.986739+00	GET	/api/journal/public	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.15738320350646973	\N
200	2026-10-08 10:02:19.449531+00	GET	/api/journal/public	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.03734707832336426	\N
1281	2026-10-08 17:41:25.516283+00	GET	/api/journal/dda23ea8-273a-4cdb-8960-59331db60cfa	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.025448083877563477	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1282	2026-10-08 17:41:32.119223+00	GET	/api/journal/public	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.019982576370239258	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1284	2026-10-08 17:41:33.152979+00	GET	/api/journal/e1b9db18-3f6f-41c4-8498-f18a574ebc7e	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.00862574577331543	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1286	2026-10-08 17:41:36.113798+00	GET	/api/journal/public	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.007079362869262695	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1288	2026-10-08 17:44:37.473865+00	GET	/api/auth/me	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.01957869529724121	\N
1292	2026-10-08 17:44:40.59803+00	GET	/api/auth/me	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.008600711822509766	\N
1505	2026-10-08 18:25:09.690564+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.028096437454223633	2b3f77bc-0f82-4c55-aa05-41d12db6b770
1721	2026-10-08 20:22:02.717469+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.036150217056274414	2b3f77bc-0f82-4c55-aa05-41d12db6b770
2000	2026-10-08 20:58:05.942048+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.009699344635009766	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2002	2026-10-08 20:58:08.660207+00	GET	/api/users	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.004547119140625	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2004	2026-10-08 20:58:09.362314+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.014586925506591797	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2006	2026-10-08 20:58:09.813814+00	GET	/api/users	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.008051872253417969	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2007	2026-10-08 20:58:10.365807+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.009829521179199219	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2009	2026-10-08 20:58:11.546325+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.036341190338134766	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2011	2026-10-08 20:58:16.06042+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.010174989700317383	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2013	2026-10-08 20:58:17.461068+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.013158321380615234	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2015	2026-10-08 20:58:18.733601+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.012316465377807617	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2019	2026-10-08 20:58:18.795796+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.008404254913330078	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2021	2026-10-08 20:58:21.520477+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.027001142501831055	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2022	2026-10-08 20:58:25.270132+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.2574286460876465	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2027	2026-10-08 20:58:25.313511+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.004032611846923828	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2029	2026-10-08 20:58:28.686387+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.015468597412109375	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
166	2026-10-08 00:10:02.915239+00	GET	/api/auth/me	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.01955866813659668	\N
169	2026-10-08 00:15:20.517041+00	GET	/api/journal/public	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.009413957595825195	\N
171	2026-10-08 04:50:44.99269+00	GET	/api/journal/public	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.004509925842285156	\N
173	2026-10-08 05:04:35.996921+00	GET	/api/journal/public	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0037393569946289062	\N
175	2026-10-08 05:06:41.994606+00	GET	/api/journal/public	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.007016658782958984	\N
177	2026-10-08 05:15:57.181182+00	GET	/api/journal/public	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.005686044692993164	\N
179	2026-10-08 08:28:42.702769+00	GET	/api/journal/public	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.009158134460449219	\N
181	2026-10-08 09:21:17.426229+00	GET	/api/journal/public	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.009170055389404297	\N
183	2026-10-08 09:21:33.210868+00	GET	/api/journal/public	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.014296531677246094	\N
185	2026-10-08 09:21:33.450835+00	GET	/api/journal/public	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.009672164916992188	\N
187	2026-10-08 09:47:11.701115+00	GET	/api/journal/public	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0059087276458740234	\N
189	2026-10-08 09:47:13.92801+00	GET	/api/journal/public	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0048406124114990234	\N
191	2026-10-08 09:47:28.92257+00	GET	/api/journal/public	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.004029273986816406	\N
193	2026-10-08 09:50:17.064561+00	GET	/api/journal/public	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.004235029220581055	\N
195	2026-10-08 09:50:20.529348+00	GET	/api/journal/public	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0026903152465820312	\N
197	2026-10-08 09:50:33.217534+00	GET	/api/journal/public	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0053060054779052734	\N
199	2026-10-08 09:59:20.013638+00	GET	/api/journal/public	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.00774693489074707	\N
201	2026-10-08 10:02:19.466368+00	GET	/api/journal/public	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.003992319107055664	\N
1283	2026-10-08 17:41:32.128629+00	GET	/api/journal/public	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.003982067108154297	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1285	2026-10-08 17:41:33.159694+00	GET	/api/journal/e1b9db18-3f6f-41c4-8498-f18a574ebc7e	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0030722618103027344	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1287	2026-10-08 17:41:36.121881+00	GET	/api/journal/public	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.003783702850341797	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1291	2026-10-08 17:44:38.557135+00	GET	/api/auth/me	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.005887269973754883	\N
1513	2026-10-08 18:28:09.939714+00	GET	/api/auth/me	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.036325693130493164	2b3f77bc-0f82-4c55-aa05-41d12db6b770
1514	2026-10-08 18:28:09.941489+00	GET	/api/auth/me	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.01725029945373535	2b3f77bc-0f82-4c55-aa05-41d12db6b770
1519	2026-10-08 18:28:13.280838+00	POST	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	201	0.05506610870361328	2b3f77bc-0f82-4c55-aa05-41d12db6b770
1520	2026-10-08 18:28:14.655675+00	GET	/api/auth/me	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.00703883171081543	2b3f77bc-0f82-4c55-aa05-41d12db6b770
1522	2026-10-08 18:28:14.66359+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0158689022064209	2b3f77bc-0f82-4c55-aa05-41d12db6b770
1725	2026-10-08 20:22:05.210073+00	GET	/api/auth/me	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.03908061981201172	2b3f77bc-0f82-4c55-aa05-41d12db6b770
1729	2026-10-08 20:22:05.231545+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.06217026710510254	2b3f77bc-0f82-4c55-aa05-41d12db6b770
1731	2026-10-08 20:22:08.566357+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.007891416549682617	2b3f77bc-0f82-4c55-aa05-41d12db6b770
1732	2026-10-08 20:22:08.599378+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.041767120361328125	2b3f77bc-0f82-4c55-aa05-41d12db6b770
1744	2026-10-08 20:22:18.318511+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.022852659225463867	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1746	2026-10-08 20:22:37.847261+00	GET	/api/sessions/7d99751a-91fa-4bae-a8e7-cba5ab18a544	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.04761195182800293	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1749	2026-10-08 20:22:49.06279+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.028287887573242188	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1754	2026-10-08 20:22:50.849822+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.00420689582824707	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1756	2026-10-08 20:22:57.096104+00	GET	/api/sessions/7d99751a-91fa-4bae-a8e7-cba5ab18a544	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.01678180694580078	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1758	2026-10-08 20:22:59.5118+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.013783693313598633	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1760	2026-10-08 20:23:07.700036+00	GET	/api/sessions/7d99751a-91fa-4bae-a8e7-cba5ab18a544	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.021236419677734375	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1762	2026-10-08 20:23:09.584913+00	GET	/api/sessions/7d99751a-91fa-4bae-a8e7-cba5ab18a544	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.004338741302490234	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
167	2026-10-08 00:10:02.913767+00	GET	/api/auth/me	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.02459406852722168	\N
1289	2026-10-08 17:44:37.471977+00	GET	/api/auth/me	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.00999140739440918	\N
1301	2026-10-08 17:44:46.162527+00	GET	/api/auth/me	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.013864755630493164	\N
1306	2026-10-08 17:44:48.771888+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.05389404296875	\N
1308	2026-10-08 17:44:48.778198+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.035616397857666016	\N
1310	2026-10-08 17:44:50.55586+00	GET	/api/auth/me	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.016570568084716797	\N
1314	2026-10-08 17:44:52.725806+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.14583826065063477	\N
1319	2026-10-08 17:44:52.757245+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0027642250061035156	\N
1323	2026-10-08 17:44:53.901079+00	GET	/api/auth/me	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.017531156539916992	\N
1515	2026-10-08 18:28:09.944387+00	GET	/api/auth/me	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.020598173141479492	2b3f77bc-0f82-4c55-aa05-41d12db6b770
1521	2026-10-08 18:28:14.661662+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.013635396957397461	2b3f77bc-0f82-4c55-aa05-41d12db6b770
1523	2026-10-08 18:28:14.665082+00	GET	/api/auth/me	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0023348331451416016	2b3f77bc-0f82-4c55-aa05-41d12db6b770
1564	2026-10-08 18:43:38.331082+00	POST	/api/auth/login	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	401	0.06092405319213867	\N
1566	2026-10-08 18:50:32.434707+00	POST	/api/auth/register	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	201	0.3508472442626953	\N
1567	2026-10-08 18:50:32.838237+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.11321258544921875	826ac151-a131-48ee-aadc-c6db6f963c9c
1571	2026-10-08 18:50:32.957128+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.07084465026855469	826ac151-a131-48ee-aadc-c6db6f963c9c
1574	2026-10-08 18:51:02.924124+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.029026031494140625	826ac151-a131-48ee-aadc-c6db6f963c9c
1576	2026-10-08 18:53:46.699332+00	POST	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	403	0.04078340530395508	826ac151-a131-48ee-aadc-c6db6f963c9c
1581	2026-10-08 18:58:30.485534+00	POST	/api/auth/login	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	401	0.3469541072845459	\N
1588	2026-10-08 19:01:19.973209+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.026107311248779297	96a48a1b-0906-45c2-923a-18836cecc423
1590	2026-10-08 19:01:19.991571+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.007218599319458008	96a48a1b-0906-45c2-923a-18836cecc423
1592	2026-10-08 19:01:50.109753+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.005425930023193359	96a48a1b-0906-45c2-923a-18836cecc423
1594	2026-10-08 19:02:15.721841+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.008323431015014648	96a48a1b-0906-45c2-923a-18836cecc423
1596	2026-10-08 19:04:23.548399+00	GET	/api/journal/public	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.009395837783813477	96a48a1b-0906-45c2-923a-18836cecc423
1598	2026-10-08 19:04:40.095104+00	GET	/api/journal/e1b9db18-3f6f-41c4-8498-f18a574ebc7e	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.00609588623046875	96a48a1b-0906-45c2-923a-18836cecc423
1600	2026-10-08 19:05:42.544328+00	GET	/api/journal/public	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.010705709457397461	96a48a1b-0906-45c2-923a-18836cecc423
1602	2026-10-08 19:11:03.059294+00	GET	/api/journal/public	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.004711151123046875	96a48a1b-0906-45c2-923a-18836cecc423
1604	2026-10-08 19:26:59.363563+00	GET	/api/journal/public	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0038309097290039062	96a48a1b-0906-45c2-923a-18836cecc423
1606	2026-10-08 20:15:12.662337+00	GET	/api/journal/public	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.12812423706054688	\N
1607	2026-10-08 20:15:14.367542+00	GET	/api/journal/public	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.034978389739990234	\N
1612	2026-10-08 20:15:20.530738+00	GET	/api/journal/public	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.007153034210205078	\N
1613	2026-10-08 20:15:22.566132+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.011574745178222656	\N
1619	2026-10-08 20:15:31.187904+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.019688129425048828	\N
1630	2026-10-08 20:15:39.47767+00	GET	/api/audit	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.003106832504272461	\N
1636	2026-10-08 20:16:06.631701+00	GET	/api/users	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.013906717300415039	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1638	2026-10-08 20:16:24.416859+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.02330303192138672	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1640	2026-10-08 20:16:25.656269+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.014179468154907227	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1642	2026-10-08 20:16:30.885936+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.012441158294677734	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1647	2026-10-08 20:16:38.184549+00	GET	/api/users	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.003531932830810547	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1649	2026-10-08 20:16:38.705473+00	GET	/api/audit	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.018273353576660156	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
202	2026-10-08 10:04:21.235217+00	GET	/api/journal/public	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0348966121673584	\N
204	2026-10-08 10:04:42.175954+00	GET	/api/journal/public	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.02298569679260254	\N
206	2026-10-08 10:16:24.626733+00	GET	/api/journal/public	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.018366098403930664	\N
208	2026-10-08 10:18:45.603365+00	GET	/api/journal/public	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.024537324905395508	\N
210	2026-10-08 10:18:52.710889+00	GET	/api/journal/public	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.016611576080322266	\N
212	2026-10-08 10:38:03.026053+00	GET	/api/journal/public	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.023985862731933594	\N
214	2026-10-08 10:38:05.756047+00	GET	/api/journal/public	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.054701805114746094	\N
216	2026-10-08 10:39:03.822878+00	GET	/api/journal/public	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.17821407318115234	\N
218	2026-10-08 10:39:05.557685+00	GET	/api/journal/public	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.08641433715820312	\N
220	2026-10-08 10:43:11.444853+00	GET	/api/journal/public	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.03378915786743164	\N
222	2026-10-08 10:43:47.667343+00	GET	/api/journal/public	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.04710745811462402	\N
224	2026-10-08 10:44:03.675865+00	GET	/api/journal/public	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.024472475051879883	\N
226	2026-10-08 10:55:27.335343+00	GET	/api/journal/public	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.04238295555114746	\N
228	2026-10-08 10:56:11.477777+00	GET	/api/journal/public	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.04961872100830078	\N
230	2026-10-08 11:09:44.391992+00	GET	/api/journal/public	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.029397964477539062	\N
232	2026-10-08 11:09:51.838396+00	GET	/api/journal/public	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.04140281677246094	\N
234	2026-10-08 11:09:54.377831+00	GET	/api/journal/public	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.02121448516845703	\N
236	2026-10-08 11:29:55.223831+00	GET	/api/audit	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.18583202362060547	\N
237	2026-10-08 11:29:55.219619+00	GET	/api/audit	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.07352113723754883	\N
240	2026-10-08 11:37:22.491543+00	GET	/api/journal	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.002810239791870117	\N
241	2026-10-08 11:37:22.48911+00	GET	/api/journal	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.0040740966796875	\N
243	2026-10-08 11:37:23.931494+00	GET	/api/sessions	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.1110527515411377	\N
246	2026-10-08 11:40:51.115116+00	GET	/api/sessions	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.13558006286621094	\N
248	2026-10-08 11:40:51.140991+00	GET	/api/sessions/next	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.2078568935394287	\N
250	2026-10-08 11:41:00.20663+00	GET	/api/sessions	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.060652971267700195	\N
252	2026-10-08 11:41:00.265718+00	GET	/api/sessions	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.2275404930114746	\N
254	2026-10-08 11:41:00.291574+00	GET	/api/sessions/next	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.22991108894348145	\N
260	2026-10-08 11:41:11.311894+00	GET	/api/sessions	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.14658594131469727	2b3f77bc-0f82-4c55-aa05-41d12db6b770
261	2026-10-08 11:41:11.39855+00	GET	/api/sessions	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0144195556640625	2b3f77bc-0f82-4c55-aa05-41d12db6b770
262	2026-10-08 11:41:11.400285+00	GET	/api/sessions/next	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.016411304473876953	2b3f77bc-0f82-4c55-aa05-41d12db6b770
263	2026-10-08 11:41:15.026338+00	GET	/api/auth/me	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.011242389678955078	2b3f77bc-0f82-4c55-aa05-41d12db6b770
266	2026-10-08 11:41:15.051025+00	GET	/api/auth/me	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.02963089942932129	2b3f77bc-0f82-4c55-aa05-41d12db6b770
268	2026-10-08 11:41:20.47222+00	GET	/api/users	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.008987665176391602	\N
267	2026-10-08 11:41:20.474402+00	GET	/api/users	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.009389877319335938	\N
272	2026-10-08 11:41:22.656216+00	GET	/api/users	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.0047435760498046875	\N
274	2026-10-08 11:41:23.245225+00	GET	/api/journal	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.018242597579956055	\N
275	2026-10-08 11:41:25.532622+00	GET	/api/auth/me	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.00652623176574707	2b3f77bc-0f82-4c55-aa05-41d12db6b770
276	2026-10-08 11:41:25.533907+00	GET	/api/auth/me	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.03365516662597656	2b3f77bc-0f82-4c55-aa05-41d12db6b770
277	2026-10-08 11:41:25.54173+00	GET	/api/auth/me	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0018541812896728516	2b3f77bc-0f82-4c55-aa05-41d12db6b770
279	2026-10-08 11:41:28.907992+00	GET	/api/journal	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.016852855682373047	\N
281	2026-10-08 11:41:29.415744+00	GET	/api/journal	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.0019004344940185547	\N
203	2026-10-08 10:04:21.265343+00	GET	/api/journal/public	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.008547544479370117	\N
205	2026-10-08 10:04:42.186813+00	GET	/api/journal/public	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0028715133666992188	\N
207	2026-10-08 10:16:24.63524+00	GET	/api/journal/public	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0029506683349609375	\N
209	2026-10-08 10:18:45.61396+00	GET	/api/journal/public	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0030040740966796875	\N
211	2026-10-08 10:18:52.723101+00	GET	/api/journal/public	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.00316619873046875	\N
213	2026-10-08 10:38:03.038127+00	GET	/api/journal/public	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0033359527587890625	\N
215	2026-10-08 10:38:05.775001+00	GET	/api/journal/public	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.008575439453125	\N
217	2026-10-08 10:39:03.836858+00	GET	/api/journal/public	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.003583669662475586	\N
219	2026-10-08 10:39:05.585562+00	GET	/api/journal/public	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.005877017974853516	\N
221	2026-10-08 10:43:11.465785+00	GET	/api/journal/public	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.00506281852722168	\N
223	2026-10-08 10:43:47.681657+00	GET	/api/journal/public	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.00556635856628418	\N
225	2026-10-08 10:44:03.692213+00	GET	/api/journal/public	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.004256486892700195	\N
227	2026-10-08 10:55:27.353577+00	GET	/api/journal/public	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0037839412689208984	\N
229	2026-10-08 10:56:11.494031+00	GET	/api/journal/public	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.00379180908203125	\N
231	2026-10-08 11:09:44.408301+00	GET	/api/journal/public	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.003572225570678711	\N
233	2026-10-08 11:09:51.853634+00	GET	/api/journal/public	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.003805875778198242	\N
235	2026-10-08 11:09:54.399194+00	GET	/api/journal/public	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.004422187805175781	\N
238	2026-10-08 11:37:21.035257+00	GET	/api/users	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.09566402435302734	\N
239	2026-10-08 11:37:21.028774+00	GET	/api/users	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.05614733695983887	\N
242	2026-10-08 11:37:23.931017+00	GET	/api/sessions	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.07011151313781738	\N
244	2026-10-08 11:40:51.115415+00	GET	/api/sessions	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.24633502960205078	\N
245	2026-10-08 11:40:51.11668+00	GET	/api/sessions	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.14272069931030273	\N
247	2026-10-08 11:40:51.126267+00	GET	/api/sessions/next	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.18718266487121582	\N
249	2026-10-08 11:40:51.171566+00	GET	/api/sessions	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.21872186660766602	\N
251	2026-10-08 11:41:00.212428+00	GET	/api/sessions/next	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.08247613906860352	\N
253	2026-10-08 11:41:00.282378+00	GET	/api/sessions	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.15886330604553223	\N
255	2026-10-08 11:41:00.297866+00	GET	/api/sessions	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.21463418006896973	\N
256	2026-10-08 11:41:10.981966+00	POST	/api/auth/login	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.28624486923217773	\N
257	2026-10-08 11:41:11.163695+00	GET	/api/sessions	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.01802825927734375	2b3f77bc-0f82-4c55-aa05-41d12db6b770
258	2026-10-08 11:41:11.199314+00	GET	/api/sessions	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.011176586151123047	2b3f77bc-0f82-4c55-aa05-41d12db6b770
259	2026-10-08 11:41:11.318219+00	GET	/api/sessions/next	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.1749124526977539	2b3f77bc-0f82-4c55-aa05-41d12db6b770
265	2026-10-08 11:41:15.048633+00	GET	/api/auth/me	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.03479647636413574	2b3f77bc-0f82-4c55-aa05-41d12db6b770
264	2026-10-08 11:41:15.048913+00	GET	/api/auth/me	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.03647279739379883	2b3f77bc-0f82-4c55-aa05-41d12db6b770
270	2026-10-08 11:41:22.380341+00	GET	/api/audit	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.022559165954589844	\N
269	2026-10-08 11:41:22.382108+00	GET	/api/audit	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.014166116714477539	\N
271	2026-10-08 11:41:22.651406+00	GET	/api/users	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.002994537353515625	\N
273	2026-10-08 11:41:23.246451+00	GET	/api/journal	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.027963638305664062	\N
278	2026-10-08 11:41:25.542545+00	GET	/api/auth/me	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0028557777404785156	2b3f77bc-0f82-4c55-aa05-41d12db6b770
280	2026-10-08 11:41:28.906014+00	GET	/api/journal	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.015032768249511719	\N
282	2026-10-08 11:41:29.959718+00	GET	/api/journal	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.0023450851440429688	\N
283	2026-10-08 11:41:30.414277+00	GET	/api/journal	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.0028214454650878906	\N
284	2026-10-08 11:41:30.85634+00	GET	/api/journal	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.0015442371368408203	\N
289	2026-10-08 11:41:32.839642+00	GET	/api/journal	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.009512901306152344	\N
294	2026-10-08 11:41:36.309611+00	GET	/api/journal	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.0021691322326660156	\N
297	2026-10-08 11:41:38.743279+00	GET	/api/sessions	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0269014835357666	\N
1293	2026-10-08 17:44:40.596991+00	GET	/api/auth/me	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.0051953792572021484	\N
1516	2026-10-08 18:28:09.957255+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.035820960998535156	2b3f77bc-0f82-4c55-aa05-41d12db6b770
1727	2026-10-08 20:22:05.210301+00	GET	/api/auth/me	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.04180741310119629	2b3f77bc-0f82-4c55-aa05-41d12db6b770
1730	2026-10-08 20:22:05.252106+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.07892465591430664	2b3f77bc-0f82-4c55-aa05-41d12db6b770
2017	2026-10-08 20:58:18.760075+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.006600618362426758	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2018	2026-10-08 20:58:18.759073+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0057833194732666016	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2023	2026-10-08 20:58:25.271469+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.25703907012939453	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2028	2026-10-08 20:58:28.666035+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.00983738899230957	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2030	2026-10-08 20:58:32.06726+00	GET	/api/users	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.010320901870727539	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2032	2026-10-08 20:58:32.910885+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.021164417266845703	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2034	2026-10-08 20:58:35.505521+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.006470441818237305	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2039	2026-10-08 20:58:37.614769+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.00857234001159668	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2047	2026-10-08 20:58:42.579517+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.048442840576171875	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2052	2026-10-08 20:58:43.91256+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.004753828048706055	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2209	2026-10-08 21:17:37.988762+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.012440204620361328	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2214	2026-10-08 21:17:58.256705+00	GET	/api/sessions/8431bdef-789a-4a8e-a151-76ca4ff740db	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.004140615463256836	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2225	2026-10-08 21:18:21.283213+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.002277374267578125	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2227	2026-10-08 21:18:23.764775+00	GET	/api/sessions/f29b7e3c-59c5-4380-9af4-96cec59b69bd	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.004715442657470703	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2229	2026-10-08 21:18:28.650361+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.026728391647338867	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2230	2026-10-08 21:18:29.756773+00	GET	/api/sessions/ccb9c8cd-e6a4-4efa-8d34-69095c43e387	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.004618406295776367	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2232	2026-10-08 21:18:46.549339+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.021634817123413086	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2237	2026-10-08 21:18:53.135446+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.03238415718078613	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2238	2026-10-08 21:19:11.2793+00	POST	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	201	0.0711674690246582	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2240	2026-10-08 21:19:11.35911+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.001926422119140625	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2247	2026-10-08 21:20:00.934944+00	PATCH	/api/sessions/1bc6dfe0-cc1d-4446-995b-64c17d34623f/documentation	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0437922477722168	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2253	2026-10-08 21:20:34.218147+00	PATCH	/api/sessions/1bc6dfe0-cc1d-4446-995b-64c17d34623f/documentation	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.03925800323486328	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2268	2026-10-08 21:22:15.553293+00	PATCH	/api/sessions/1bc6dfe0-cc1d-4446-995b-64c17d34623f/documentation	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.046523094177246094	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2311	2026-10-08 21:29:08.641802+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.41419076919555664	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2312	2026-10-08 21:29:08.694156+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0280916690826416	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2324	2026-10-08 21:29:11.145688+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.034958600997924805	\N
2328	2026-10-08 21:29:15.154281+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.004277706146240234	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2331	2026-10-08 21:29:16.918166+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.023462533950805664	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2358	2026-10-08 21:36:39.385522+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.22000479698181152	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2359	2026-10-08 21:36:39.386212+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.14308619499206543	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2360	2026-10-08 21:36:39.386063+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.23331379890441895	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2362	2026-10-08 21:36:46.74488+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.048805952072143555	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2364	2026-10-08 21:36:52.546346+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.034755706787109375	\N
286	2026-10-08 11:41:31.520189+00	GET	/api/users	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.004464626312255859	\N
290	2026-10-08 11:41:33.308499+00	GET	/api/journal	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.0019261837005615234	\N
295	2026-10-08 11:41:36.312202+00	GET	/api/journal	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.0034744739532470703	\N
1295	2026-10-08 17:44:42.259442+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.04732871055603027	\N
1299	2026-10-08 17:44:42.310888+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.12727880477905273	\N
1309	2026-10-08 17:44:48.812069+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.03316855430603027	\N
1317	2026-10-08 17:44:52.744481+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.008565664291381836	\N
1320	2026-10-08 17:44:53.898651+00	GET	/api/auth/me	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.015233278274536133	\N
1517	2026-10-08 18:28:09.957005+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.03893136978149414	2b3f77bc-0f82-4c55-aa05-41d12db6b770
1726	2026-10-08 20:22:05.21133+00	GET	/api/auth/me	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.04400753974914551	2b3f77bc-0f82-4c55-aa05-41d12db6b770
1734	2026-10-08 20:22:08.608235+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.029406309127807617	2b3f77bc-0f82-4c55-aa05-41d12db6b770
1736	2026-10-08 20:22:08.624188+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.020032405853271484	2b3f77bc-0f82-4c55-aa05-41d12db6b770
2026	2026-10-08 20:58:25.297667+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.005767107009887695	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2036	2026-10-08 20:58:37.583604+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.02637004852294922	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2042	2026-10-08 20:58:39.723356+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.004172086715698242	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2044	2026-10-08 20:58:40.520344+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.013329029083251953	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2049	2026-10-08 20:58:42.610255+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.006340742111206055	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2051	2026-10-08 20:58:42.628754+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.002471446990966797	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2053	2026-10-08 20:58:43.930329+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.01432943344116211	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2054	2026-10-08 20:58:46.269573+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0439906120300293	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2063	2026-10-08 20:58:50.990318+00	GET	/api/users	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.004924297332763672	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2065	2026-10-08 20:58:51.914443+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.018383502960205078	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2067	2026-10-08 20:58:56.709984+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.012630701065063477	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2069	2026-10-08 20:59:01.132412+00	GET	/api/users	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.009080648422241211	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2071	2026-10-08 20:59:04.140581+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.009667396545410156	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2073	2026-10-08 20:59:06.574109+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.010119915008544922	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2078	2026-10-08 20:59:11.757852+00	GET	/api/sessions/f29b7e3c-59c5-4380-9af4-96cec59b69bd	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.00595545768737793	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2084	2026-10-08 20:59:32.613544+00	PATCH	/api/sessions/f29b7e3c-59c5-4380-9af4-96cec59b69bd/documentation	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.008008241653442383	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2088	2026-10-08 20:59:39.645195+00	POST	/api/sessions/f29b7e3c-59c5-4380-9af4-96cec59b69bd/unpublish-studio	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.04121732711791992	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2090	2026-10-08 20:59:42.568721+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.002418994903564453	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2092	2026-10-08 20:59:44.892087+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.011762142181396484	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2096	2026-10-08 20:59:44.965201+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0075931549072265625	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2098	2026-10-08 20:59:45.808442+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0019369125366210938	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2100	2026-10-08 20:59:48.396626+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0031969547271728516	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2102	2026-10-08 20:59:54.582456+00	GET	/api/sessions/f29b7e3c-59c5-4380-9af4-96cec59b69bd	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.004529714584350586	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2106	2026-10-08 21:00:10.912089+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.009125709533691406	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2108	2026-10-08 21:00:18.363567+00	GET	/api/sessions/f29b7e3c-59c5-4380-9af4-96cec59b69bd	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.037187814712524414	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2110	2026-10-08 21:00:34.370865+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.028936147689819336	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2112	2026-10-08 21:00:34.949601+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.009576559066772461	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2114	2026-10-08 21:06:22.893018+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.026321887969970703	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2116	2026-10-08 21:06:25.07016+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.034576416015625	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2118	2026-10-08 21:07:00.100606+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.021773099899291992	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
285	2026-10-08 11:41:31.516599+00	GET	/api/users	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.003057241439819336	\N
291	2026-10-08 11:41:34.571782+00	GET	/api/journal	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.00809025764465332	\N
1296	2026-10-08 17:44:42.262939+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.049858808517456055	\N
1303	2026-10-08 17:44:46.16077+00	GET	/api/auth/me	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.014362096786499023	\N
1305	2026-10-08 17:44:48.734947+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.010083198547363281	\N
1312	2026-10-08 17:44:50.560661+00	GET	/api/auth/me	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.012601137161254883	\N
1315	2026-10-08 17:44:52.726187+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.14714384078979492	\N
1322	2026-10-08 17:44:53.899699+00	GET	/api/auth/me	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.015974760055541992	\N
1330	2026-10-08 17:45:00.593807+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.02002263069152832	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1332	2026-10-08 17:45:01.917971+00	GET	/api/users	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.02085089683532715	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1336	2026-10-08 17:45:10.470052+00	GET	/api/auth/me	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.011320829391479492	\N
1359	2026-10-08 17:47:27.780439+00	PATCH	/api/journal/2244bf82-1f9a-4004-aecf-9357def21b44	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.06661248207092285	2b3f77bc-0f82-4c55-aa05-41d12db6b770
1362	2026-10-08 17:47:30.19451+00	PATCH	/api/journal/2244bf82-1f9a-4004-aecf-9357def21b44	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.012235879898071289	2b3f77bc-0f82-4c55-aa05-41d12db6b770
1363	2026-10-08 17:47:31.402808+00	GET	/api/auth/me	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.003236055374145508	2b3f77bc-0f82-4c55-aa05-41d12db6b770
1365	2026-10-08 17:47:31.407199+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.013136148452758789	2b3f77bc-0f82-4c55-aa05-41d12db6b770
1518	2026-10-08 18:28:09.961686+00	GET	/api/auth/me	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.028885364532470703	2b3f77bc-0f82-4c55-aa05-41d12db6b770
1728	2026-10-08 20:22:05.210774+00	GET	/api/auth/me	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.04389214515686035	2b3f77bc-0f82-4c55-aa05-41d12db6b770
1735	2026-10-08 20:22:08.614787+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.004970550537109375	2b3f77bc-0f82-4c55-aa05-41d12db6b770
2031	2026-10-08 20:58:32.076201+00	GET	/api/users	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0033998489379882812	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2033	2026-10-08 20:58:32.918112+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.003385782241821289	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2035	2026-10-08 20:58:35.513796+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0036842823028564453	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2037	2026-10-08 20:58:37.582398+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0557560920715332	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2041	2026-10-08 20:58:37.637749+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0053730010986328125	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2043	2026-10-08 20:58:39.743117+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.013357400894165039	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2045	2026-10-08 20:58:40.537276+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.013511896133422852	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2046	2026-10-08 20:58:42.578472+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.04157304763793945	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2056	2026-10-08 20:58:46.304478+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.014364242553710938	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2083	2026-10-08 20:59:32.484728+00	PATCH	/api/sessions/f29b7e3c-59c5-4380-9af4-96cec59b69bd/documentation	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.06235861778259277	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2089	2026-10-08 20:59:42.558706+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.007132768630981445	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2095	2026-10-08 20:59:44.94435+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.00889134407043457	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2210	2026-10-08 21:17:37.993295+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.006260871887207031	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2212	2026-10-08 21:17:56.957945+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.03581738471984863	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2219	2026-10-08 21:18:09.617789+00	POST	/api/sessions/8431bdef-789a-4a8e-a151-76ca4ff740db/publish-studio	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.00928187370300293	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2221	2026-10-08 21:18:10.887924+00	GET	/api/sessions/8431bdef-789a-4a8e-a151-76ca4ff740db	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0013818740844726562	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2223	2026-10-08 21:18:20.763401+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.012749910354614258	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2235	2026-10-08 21:18:48.818728+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.025992870330810547	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2236	2026-10-08 21:18:53.132377+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.029636144638061523	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2242	2026-10-08 21:19:15.526031+00	GET	/api/sessions/1bc6dfe0-cc1d-4446-995b-64c17d34623f	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.002000093460083008	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2244	2026-10-08 21:19:30.126709+00	PATCH	/api/sessions/1bc6dfe0-cc1d-4446-995b-64c17d34623f/documentation	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.04447650909423828	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2246	2026-10-08 21:19:58.847831+00	POST	/api/upload	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	201	0.010718822479248047	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2250	2026-10-08 21:20:29.287728+00	POST	/api/upload	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	201	0.11192917823791504	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2540	2026-10-09 10:56:46.68868+00	GET	/api/journal/public	127.0.0.1	python-httpx/0.28.1	200	0.007437467575073242	\N
287	2026-10-08 11:41:32.075177+00	GET	/api/journal	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.009447336196899414	\N
288	2026-10-08 11:41:32.076529+00	GET	/api/journal	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.018804311752319336	\N
292	2026-10-08 11:41:35.48848+00	GET	/api/users	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.005027055740356445	\N
293	2026-10-08 11:41:35.490015+00	GET	/api/users	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.006213665008544922	\N
296	2026-10-08 11:41:38.70549+00	GET	/api/sessions	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.06177997589111328	\N
298	2026-10-08 12:19:52.673028+00	POST	/api/auth/login	127.0.0.1	python-httpx/0.28.1	200	0.2735133171081543	\N
299	2026-10-08 12:19:52.779371+00	POST	/api/sessions	127.0.0.1	python-httpx/0.28.1	201	0.07724285125732422	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
300	2026-10-08 12:19:52.794628+00	POST	/api/sessions/22bd0c13-4c2f-49ae-8841-3cae187aff12/publish	127.0.0.1	python-httpx/0.28.1	200	0.010843992233276367	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
301	2026-10-08 12:19:52.805452+00	POST	/api/sessions/22bd0c13-4c2f-49ae-8841-3cae187aff12/complete	127.0.0.1	python-httpx/0.28.1	200	0.0072438716888427734	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
302	2026-10-08 12:19:52.814174+00	GET	/api/sessions	127.0.0.1	python-httpx/0.28.1	200	0.005265712738037109	\N
303	2026-10-08 12:19:52.822905+00	GET	/api/sessions/22bd0c13-4c2f-49ae-8841-3cae187aff12	127.0.0.1	python-httpx/0.28.1	200	0.0027227401733398438	\N
304	2026-10-08 12:19:52.831697+00	PATCH	/api/sessions/22bd0c13-4c2f-49ae-8841-3cae187aff12	127.0.0.1	python-httpx/0.28.1	200	0.005496978759765625	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
305	2026-10-08 12:19:53.087166+00	POST	/api/auth/login	127.0.0.1	python-httpx/0.28.1	200	0.24690008163452148	\N
306	2026-10-08 12:19:53.107151+00	POST	/api/upload	127.0.0.1	python-httpx/0.28.1	201	0.01359701156616211	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
307	2026-10-08 12:19:53.116452+00	POST	/api/upload/multiple	127.0.0.1	python-httpx/0.28.1	201	0.004615068435668945	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
308	2026-10-08 12:19:53.123635+00	POST	/api/upload	127.0.0.1	python-httpx/0.28.1	400	0.003271818161010742	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
309	2026-10-08 12:29:21.365181+00	GET	/api/journal	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.017637968063354492	\N
310	2026-10-08 12:29:21.371407+00	GET	/api/journal	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.020399808883666992	\N
311	2026-10-08 12:29:22.665722+00	GET	/api/journal	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.01282644271850586	\N
312	2026-10-08 12:29:23.060636+00	GET	/api/journal	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.0020940303802490234	\N
313	2026-10-08 12:29:25.343881+00	GET	/api/audit	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.038457632064819336	\N
314	2026-10-08 12:29:25.343406+00	GET	/api/audit	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.02444624900817871	\N
315	2026-10-08 12:29:25.721929+00	GET	/api/users	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.0019202232360839844	\N
316	2026-10-08 12:29:25.722688+00	GET	/api/users	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.0025582313537597656	\N
317	2026-10-08 12:29:27.968823+00	GET	/api/journal	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.033193349838256836	\N
320	2026-10-08 12:29:27.969412+00	GET	/api/journal	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.022091150283813477	\N
319	2026-10-08 12:29:27.969871+00	GET	/api/users	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.0292966365814209	\N
318	2026-10-08 12:29:27.970124+00	GET	/api/users	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.037860870361328125	\N
321	2026-10-08 12:31:43.478709+00	POST	/api/auth/login	127.0.0.1	python-httpx/0.28.1	200	0.305419921875	\N
322	2026-10-08 12:31:43.574292+00	POST	/api/sessions	127.0.0.1	python-httpx/0.28.1	201	0.0718989372253418	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
323	2026-10-08 12:31:43.588731+00	POST	/api/sessions/6d527307-d0ff-4afa-b8e8-c851a204813f/publish	127.0.0.1	python-httpx/0.28.1	200	0.010228872299194336	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
324	2026-10-08 12:31:43.599664+00	POST	/api/sessions/6d527307-d0ff-4afa-b8e8-c851a204813f/complete	127.0.0.1	python-httpx/0.28.1	200	0.007494926452636719	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
325	2026-10-08 12:31:43.610679+00	GET	/api/sessions	127.0.0.1	python-httpx/0.28.1	200	0.006061077117919922	\N
326	2026-10-08 12:31:43.617512+00	GET	/api/sessions/6d527307-d0ff-4afa-b8e8-c851a204813f	127.0.0.1	python-httpx/0.28.1	200	0.0022568702697753906	\N
327	2026-10-08 12:31:43.628147+00	PATCH	/api/sessions/6d527307-d0ff-4afa-b8e8-c851a204813f	127.0.0.1	python-httpx/0.28.1	200	0.007107734680175781	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
328	2026-10-08 12:31:43.883921+00	POST	/api/auth/login	127.0.0.1	python-httpx/0.28.1	200	0.24663209915161133	\N
329	2026-10-08 12:31:43.896687+00	POST	/api/upload	127.0.0.1	python-httpx/0.28.1	201	0.006173133850097656	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
330	2026-10-08 12:31:43.90449+00	POST	/api/upload/multiple	127.0.0.1	python-httpx/0.28.1	201	0.0038421154022216797	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
331	2026-10-08 12:31:43.910962+00	POST	/api/upload	127.0.0.1	python-httpx/0.28.1	400	0.0034377574920654297	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
332	2026-10-08 12:32:03.276384+00	POST	/api/auth/login	127.0.0.1	python-httpx/0.28.1	200	0.3040452003479004	\N
333	2026-10-08 12:32:03.353103+00	POST	/api/sessions	127.0.0.1	python-httpx/0.28.1	201	0.06252789497375488	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
334	2026-10-08 12:32:03.369915+00	POST	/api/sessions/c45ad193-f48f-443b-8217-814b1ec5f4de/publish	127.0.0.1	python-httpx/0.28.1	200	0.011609792709350586	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
335	2026-10-08 12:32:03.379996+00	POST	/api/sessions/c45ad193-f48f-443b-8217-814b1ec5f4de/complete-and-document	127.0.0.1	python-httpx/0.28.1	200	0.0064961910247802734	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
336	2026-10-08 12:32:03.390725+00	PATCH	/api/sessions/c45ad193-f48f-443b-8217-814b1ec5f4de/documentation	127.0.0.1	python-httpx/0.28.1	200	0.00722503662109375	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
337	2026-10-08 12:32:03.402574+00	POST	/api/sessions/c45ad193-f48f-443b-8217-814b1ec5f4de/publish-studio	127.0.0.1	python-httpx/0.28.1	200	0.008404016494750977	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
338	2026-10-08 12:32:03.411008+00	GET	/api/sessions	127.0.0.1	python-httpx/0.28.1	200	0.00479888916015625	\N
339	2026-10-08 12:32:09.625342+00	POST	/api/auth/login	127.0.0.1	python-httpx/0.28.1	200	0.2770249843597412	\N
340	2026-10-08 12:32:09.698223+00	POST	/api/sessions	127.0.0.1	python-httpx/0.28.1	201	0.0642538070678711	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
341	2026-10-08 12:32:09.709525+00	POST	/api/sessions/fcd5a522-5260-4ed7-9060-ad66dd277d3a/publish	127.0.0.1	python-httpx/0.28.1	200	0.007501125335693359	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
342	2026-10-08 12:32:09.71877+00	POST	/api/sessions/fcd5a522-5260-4ed7-9060-ad66dd277d3a/complete	127.0.0.1	python-httpx/0.28.1	200	0.0061130523681640625	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
343	2026-10-08 12:32:09.727027+00	GET	/api/sessions	127.0.0.1	python-httpx/0.28.1	200	0.005277872085571289	\N
344	2026-10-08 12:32:09.734543+00	GET	/api/sessions/fcd5a522-5260-4ed7-9060-ad66dd277d3a	127.0.0.1	python-httpx/0.28.1	200	0.0019271373748779297	\N
352	2026-10-08 12:32:10.079613+00	GET	/api/sessions	127.0.0.1	python-httpx/0.28.1	200	0.0036821365356445312	\N
345	2026-10-08 12:32:09.754551+00	PATCH	/api/sessions/fcd5a522-5260-4ed7-9060-ad66dd277d3a	127.0.0.1	python-httpx/0.28.1	200	0.01586318016052246	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
346	2026-10-08 12:32:10.020589+00	POST	/api/auth/login	127.0.0.1	python-httpx/0.28.1	200	0.24774503707885742	\N
347	2026-10-08 12:32:10.032646+00	POST	/api/sessions	127.0.0.1	python-httpx/0.28.1	201	0.007902860641479492	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
348	2026-10-08 12:32:10.041828+00	POST	/api/sessions/9f23fda8-b503-4f6c-b502-31add8641225/publish	127.0.0.1	python-httpx/0.28.1	200	0.006166934967041016	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
349	2026-10-08 12:32:10.05235+00	POST	/api/sessions/9f23fda8-b503-4f6c-b502-31add8641225/complete-and-document	127.0.0.1	python-httpx/0.28.1	200	0.006844043731689453	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
350	2026-10-08 12:32:10.06133+00	PATCH	/api/sessions/9f23fda8-b503-4f6c-b502-31add8641225/documentation	127.0.0.1	python-httpx/0.28.1	200	0.006138801574707031	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
351	2026-10-08 12:32:10.073314+00	POST	/api/sessions/9f23fda8-b503-4f6c-b502-31add8641225/publish-studio	127.0.0.1	python-httpx/0.28.1	200	0.0061550140380859375	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
354	2026-10-08 12:32:10.348086+00	POST	/api/upload	127.0.0.1	python-httpx/0.28.1	201	0.011271953582763672	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
356	2026-10-08 12:32:10.36663+00	POST	/api/upload	127.0.0.1	python-httpx/0.28.1	400	0.003057718276977539	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1294	2026-10-08 17:44:42.264436+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.03250765800476074	\N
1302	2026-10-08 17:44:46.161804+00	GET	/api/auth/me	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.024102210998535156	\N
1304	2026-10-08 17:44:48.735491+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.011137962341308594	\N
1313	2026-10-08 17:44:50.561336+00	GET	/api/auth/me	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.018068790435791016	\N
1524	2026-10-08 18:29:10.712873+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.07657861709594727	2b3f77bc-0f82-4c55-aa05-41d12db6b770
1563	2026-10-08 18:41:47.933427+00	POST	/api/auth/login	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	401	0.05597972869873047	\N
1569	2026-10-08 18:50:32.903288+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.016123533248901367	826ac151-a131-48ee-aadc-c6db6f963c9c
1572	2026-10-08 18:50:32.956084+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.01037287712097168	826ac151-a131-48ee-aadc-c6db6f963c9c
1579	2026-10-08 18:56:14.531879+00	POST	/api/auth/login	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	401	0.03152346611022949	\N
1586	2026-10-08 19:01:19.917154+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.01575183868408203	96a48a1b-0906-45c2-923a-18836cecc423
1587	2026-10-08 19:01:19.957606+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.029062271118164062	96a48a1b-0906-45c2-923a-18836cecc423
1589	2026-10-08 19:01:19.974786+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.08349132537841797	96a48a1b-0906-45c2-923a-18836cecc423
1605	2026-10-08 20:15:12.641226+00	GET	/api/journal/public	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.10492992401123047	\N
1614	2026-10-08 20:15:22.56555+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.006590604782104492	\N
1615	2026-10-08 20:15:23.470938+00	GET	/api/sessions/77722f17-88b9-4ae3-8438-91cd12eced8f	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0077173709869384766	\N
1624	2026-10-08 20:15:34.050316+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.0062885284423828125	\N
1639	2026-10-08 20:16:24.417399+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0182039737701416	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1654	2026-10-08 20:17:29.001646+00	POST	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	201	0.07770872116088867	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1656	2026-10-08 20:17:29.091491+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0025725364685058594	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1658	2026-10-08 20:17:33.893316+00	GET	/api/sessions/f29b7e3c-59c5-4380-9af4-96cec59b69bd	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0051763057708740234	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1661	2026-10-08 20:17:37.868027+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.002605915069580078	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1737	2026-10-08 20:22:14.834185+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.02390885353088379	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1738	2026-10-08 20:22:14.835605+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.07826924324035645	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1739	2026-10-08 20:22:14.833998+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.03527212142944336	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1743	2026-10-08 20:22:18.284904+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.060964107513427734	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1745	2026-10-08 20:22:37.846564+00	GET	/api/sessions/7d99751a-91fa-4bae-a8e7-cba5ab18a544	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.04516005516052246	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1747	2026-10-08 20:22:40.241581+00	PATCH	/api/sessions/7d99751a-91fa-4bae-a8e7-cba5ab18a544/documentation	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.020946025848388672	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1748	2026-10-08 20:22:49.061007+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0323178768157959	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1786	2026-10-08 20:23:54.150878+00	PATCH	/api/sessions/7d99751a-91fa-4bae-a8e7-cba5ab18a544/documentation	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.02314925193786621	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1799	2026-10-08 20:24:48.629029+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.011801719665527344	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1801	2026-10-08 20:24:49.577402+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0018727779388427734	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1803	2026-10-08 20:24:50.722885+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.03229808807373047	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1804	2026-10-08 20:24:51.648405+00	GET	/api/sessions/77722f17-88b9-4ae3-8438-91cd12eced8f	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.005078315734863281	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
353	2026-10-08 12:32:10.329314+00	POST	/api/auth/login	127.0.0.1	python-httpx/0.28.1	200	0.2413492202758789	\N
355	2026-10-08 12:32:10.358475+00	POST	/api/upload/multiple	127.0.0.1	python-httpx/0.28.1	201	0.00512385368347168	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
357	2026-10-08 12:40:40.440064+00	POST	/api/auth/login	127.0.0.1	python-httpx/0.28.1	200	0.3644430637359619	\N
358	2026-10-08 12:40:40.543324+00	POST	/api/journal	127.0.0.1	python-httpx/0.28.1	201	0.08556079864501953	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
359	2026-10-08 12:40:40.555903+00	PATCH	/api/journal/fa1cc6f9-ab1f-4356-a922-91e91b743ee8	127.0.0.1	python-httpx/0.28.1	200	0.009299993515014648	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
360	2026-10-08 12:40:40.566033+00	POST	/api/journal/fa1cc6f9-ab1f-4356-a922-91e91b743ee8/approve	127.0.0.1	python-httpx/0.28.1	200	0.0070111751556396484	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
361	2026-10-08 12:40:40.577032+00	GET	/api/journal/public	127.0.0.1	python-httpx/0.28.1	200	0.00818490982055664	\N
362	2026-10-08 12:40:46.75163+00	POST	/api/auth/login	127.0.0.1	python-httpx/0.28.1	200	0.3438537120819092	\N
363	2026-10-08 12:40:46.833717+00	POST	/api/journal	127.0.0.1	python-httpx/0.28.1	201	0.07062602043151855	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
364	2026-10-08 12:40:46.855319+00	PATCH	/api/journal/2544739a-7ea2-42bf-aeca-0f80a92e51df	127.0.0.1	python-httpx/0.28.1	200	0.01455378532409668	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
365	2026-10-08 12:40:46.871368+00	POST	/api/journal/2544739a-7ea2-42bf-aeca-0f80a92e51df/approve	127.0.0.1	python-httpx/0.28.1	200	0.00846409797668457	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
366	2026-10-08 12:40:46.88963+00	GET	/api/journal/public	127.0.0.1	python-httpx/0.28.1	200	0.012368917465209961	\N
367	2026-10-08 12:40:47.190378+00	POST	/api/auth/login	127.0.0.1	python-httpx/0.28.1	200	0.2741968631744385	\N
368	2026-10-08 12:40:47.312897+00	POST	/api/sessions	127.0.0.1	python-httpx/0.28.1	201	0.10607171058654785	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
369	2026-10-08 12:40:47.334669+00	POST	/api/sessions/484ee9d5-6542-40db-8799-b462a7da04a8/publish	127.0.0.1	python-httpx/0.28.1	200	0.015213966369628906	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
370	2026-10-08 12:40:47.344685+00	POST	/api/sessions/484ee9d5-6542-40db-8799-b462a7da04a8/complete	127.0.0.1	python-httpx/0.28.1	200	0.005369901657104492	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
371	2026-10-08 12:40:47.352618+00	GET	/api/sessions	127.0.0.1	python-httpx/0.28.1	200	0.004724264144897461	\N
372	2026-10-08 12:40:47.358688+00	GET	/api/sessions/484ee9d5-6542-40db-8799-b462a7da04a8	127.0.0.1	python-httpx/0.28.1	200	0.0020608901977539062	\N
373	2026-10-08 12:40:47.369139+00	PATCH	/api/sessions/484ee9d5-6542-40db-8799-b462a7da04a8	127.0.0.1	python-httpx/0.28.1	200	0.006994962692260742	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
374	2026-10-08 12:40:47.660258+00	POST	/api/auth/login	127.0.0.1	python-httpx/0.28.1	200	0.2787439823150635	\N
375	2026-10-08 12:40:47.678076+00	POST	/api/sessions	127.0.0.1	python-httpx/0.28.1	201	0.010256052017211914	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
376	2026-10-08 12:40:47.687403+00	POST	/api/sessions/87f119f2-d02f-45b9-b39e-78d1b1475394/publish	127.0.0.1	python-httpx/0.28.1	200	0.0043981075286865234	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
377	2026-10-08 12:40:47.696194+00	POST	/api/sessions/87f119f2-d02f-45b9-b39e-78d1b1475394/complete-and-document	127.0.0.1	python-httpx/0.28.1	200	0.005809307098388672	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
378	2026-10-08 12:40:47.705296+00	PATCH	/api/sessions/87f119f2-d02f-45b9-b39e-78d1b1475394/documentation	127.0.0.1	python-httpx/0.28.1	200	0.006159782409667969	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
379	2026-10-08 12:40:47.714226+00	POST	/api/sessions/87f119f2-d02f-45b9-b39e-78d1b1475394/publish-studio	127.0.0.1	python-httpx/0.28.1	200	0.0060269832611083984	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
380	2026-10-08 12:40:47.720453+00	GET	/api/sessions	127.0.0.1	python-httpx/0.28.1	200	0.0033578872680664062	\N
381	2026-10-08 12:40:47.977307+00	POST	/api/auth/login	127.0.0.1	python-httpx/0.28.1	200	0.2461230754852295	\N
382	2026-10-08 12:40:47.987689+00	POST	/api/upload	127.0.0.1	python-httpx/0.28.1	201	0.004467010498046875	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
383	2026-10-08 12:40:48.001181+00	POST	/api/upload/multiple	127.0.0.1	python-httpx/0.28.1	201	0.00577092170715332	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
384	2026-10-08 12:40:48.015789+00	POST	/api/upload	127.0.0.1	python-httpx/0.28.1	400	0.006711006164550781	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
385	2026-10-08 12:46:54.393387+00	POST	/api/auth/login	127.0.0.1	python-httpx/0.28.1	200	0.3024272918701172	\N
386	2026-10-08 12:46:54.483592+00	POST	/api/journal	127.0.0.1	python-httpx/0.28.1	201	0.07747101783752441	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
387	2026-10-08 12:46:54.502275+00	PATCH	/api/journal/296cc53e-16a6-45eb-9530-d2b955a708f8	127.0.0.1	python-httpx/0.28.1	200	0.014297246932983398	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
388	2026-10-08 12:46:54.517168+00	POST	/api/journal/296cc53e-16a6-45eb-9530-d2b955a708f8/approve	127.0.0.1	python-httpx/0.28.1	200	0.010700225830078125	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
389	2026-10-08 12:46:54.542864+00	GET	/api/journal/public	127.0.0.1	python-httpx/0.28.1	200	0.018226146697998047	\N
390	2026-10-08 12:46:54.802281+00	POST	/api/auth/login	127.0.0.1	python-httpx/0.28.1	200	0.24703502655029297	\N
391	2026-10-08 12:46:54.848131+00	POST	/api/sessions	127.0.0.1	python-httpx/0.28.1	201	0.038437843322753906	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
392	2026-10-08 12:46:54.860849+00	POST	/api/sessions/4f8920e9-8c80-41e3-9d10-16ba1fd555e2/publish	127.0.0.1	python-httpx/0.28.1	200	0.008884906768798828	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
393	2026-10-08 12:46:54.872358+00	POST	/api/sessions/4f8920e9-8c80-41e3-9d10-16ba1fd555e2/complete	127.0.0.1	python-httpx/0.28.1	200	0.0076541900634765625	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
394	2026-10-08 12:46:54.880768+00	GET	/api/sessions	127.0.0.1	python-httpx/0.28.1	200	0.004961967468261719	\N
395	2026-10-08 12:46:54.886001+00	GET	/api/sessions/4f8920e9-8c80-41e3-9d10-16ba1fd555e2	127.0.0.1	python-httpx/0.28.1	200	0.0018727779388427734	\N
396	2026-10-08 12:46:54.897739+00	PATCH	/api/sessions/4f8920e9-8c80-41e3-9d10-16ba1fd555e2	127.0.0.1	python-httpx/0.28.1	200	0.0078029632568359375	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
397	2026-10-08 12:46:55.154097+00	POST	/api/auth/login	127.0.0.1	python-httpx/0.28.1	200	0.24547600746154785	\N
398	2026-10-08 12:46:55.16883+00	POST	/api/sessions	127.0.0.1	python-httpx/0.28.1	201	0.008388280868530273	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
399	2026-10-08 12:46:55.179139+00	POST	/api/sessions/3d5684c4-e8bc-4679-b8b5-ce98acb1e6ce/publish	127.0.0.1	python-httpx/0.28.1	200	0.00520014762878418	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
400	2026-10-08 12:46:55.188996+00	POST	/api/sessions/3d5684c4-e8bc-4679-b8b5-ce98acb1e6ce/complete-and-document	127.0.0.1	python-httpx/0.28.1	200	0.006774187088012695	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
401	2026-10-08 12:46:55.19827+00	PATCH	/api/sessions/3d5684c4-e8bc-4679-b8b5-ce98acb1e6ce/documentation	127.0.0.1	python-httpx/0.28.1	200	0.0060176849365234375	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
402	2026-10-08 12:46:55.206948+00	POST	/api/sessions/3d5684c4-e8bc-4679-b8b5-ce98acb1e6ce/publish-studio	127.0.0.1	python-httpx/0.28.1	200	0.005468845367431641	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
403	2026-10-08 12:46:55.212748+00	GET	/api/sessions	127.0.0.1	python-httpx/0.28.1	200	0.0028219223022460938	\N
404	2026-10-08 12:46:55.458217+00	POST	/api/auth/login	127.0.0.1	python-httpx/0.28.1	200	0.23788905143737793	\N
405	2026-10-08 12:46:55.467163+00	POST	/api/upload	127.0.0.1	python-httpx/0.28.1	201	0.0037660598754882812	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
406	2026-10-08 12:46:55.475576+00	POST	/api/upload/multiple	127.0.0.1	python-httpx/0.28.1	201	0.004012107849121094	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
407	2026-10-08 12:46:55.483774+00	POST	/api/upload	127.0.0.1	python-httpx/0.28.1	400	0.0029039382934570312	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
408	2026-10-08 12:50:44.882592+00	POST	/api/auth/login	127.0.0.1	python-httpx/0.28.1	200	0.2860889434814453	\N
409	2026-10-08 12:50:44.952037+00	POST	/api/journal	127.0.0.1	python-httpx/0.28.1	201	0.05560612678527832	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
410	2026-10-08 12:50:44.965921+00	PATCH	/api/journal/99955f81-c14e-415d-8733-ad873b42fbe8	127.0.0.1	python-httpx/0.28.1	200	0.010360002517700195	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
411	2026-10-08 12:50:44.97632+00	POST	/api/journal/99955f81-c14e-415d-8733-ad873b42fbe8/approve	127.0.0.1	python-httpx/0.28.1	200	0.0071430206298828125	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
412	2026-10-08 12:50:44.989537+00	GET	/api/journal/public	127.0.0.1	python-httpx/0.28.1	200	0.010172843933105469	\N
413	2026-10-08 12:50:45.246236+00	POST	/api/auth/login	127.0.0.1	python-httpx/0.28.1	200	0.24341702461242676	\N
414	2026-10-08 12:50:45.282695+00	POST	/api/sessions	127.0.0.1	python-httpx/0.28.1	201	0.028132200241088867	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
415	2026-10-08 12:50:45.294016+00	POST	/api/sessions/3ed4ffe8-b5b8-4e48-82c4-7ae4d8c7e059/publish	127.0.0.1	python-httpx/0.28.1	200	0.007697105407714844	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
416	2026-10-08 12:50:45.303573+00	POST	/api/sessions/3ed4ffe8-b5b8-4e48-82c4-7ae4d8c7e059/complete	127.0.0.1	python-httpx/0.28.1	200	0.005995035171508789	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
418	2026-10-08 12:50:45.315968+00	GET	/api/sessions/3ed4ffe8-b5b8-4e48-82c4-7ae4d8c7e059	127.0.0.1	python-httpx/0.28.1	200	0.0017240047454833984	\N
419	2026-10-08 12:50:45.326016+00	PATCH	/api/sessions/3ed4ffe8-b5b8-4e48-82c4-7ae4d8c7e059	127.0.0.1	python-httpx/0.28.1	200	0.006646156311035156	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
420	2026-10-08 12:50:45.577338+00	POST	/api/auth/login	127.0.0.1	python-httpx/0.28.1	200	0.2418661117553711	\N
421	2026-10-08 12:50:45.595917+00	POST	/api/sessions	127.0.0.1	python-httpx/0.28.1	201	0.011041879653930664	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
422	2026-10-08 12:50:45.603852+00	POST	/api/sessions/dc6db833-ea77-49d2-b9e7-09bfa2f58f1d/publish	127.0.0.1	python-httpx/0.28.1	200	0.005109071731567383	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
423	2026-10-08 12:50:45.612274+00	POST	/api/sessions/dc6db833-ea77-49d2-b9e7-09bfa2f58f1d/complete-and-document	127.0.0.1	python-httpx/0.28.1	200	0.0050051212310791016	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
424	2026-10-08 12:50:45.620796+00	PATCH	/api/sessions/dc6db833-ea77-49d2-b9e7-09bfa2f58f1d/documentation	127.0.0.1	python-httpx/0.28.1	200	0.005712032318115234	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
425	2026-10-08 12:50:45.629486+00	POST	/api/sessions/dc6db833-ea77-49d2-b9e7-09bfa2f58f1d/publish-studio	127.0.0.1	python-httpx/0.28.1	200	0.005295753479003906	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
428	2026-10-08 12:50:45.901019+00	POST	/api/upload	127.0.0.1	python-httpx/0.28.1	201	0.0048558712005615234	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
430	2026-10-08 12:50:45.919316+00	POST	/api/upload	127.0.0.1	python-httpx/0.28.1	400	0.003371000289916992	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1297	2026-10-08 17:44:42.276926+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0649876594543457	\N
1525	2026-10-08 18:29:10.713041+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.04120683670043945	2b3f77bc-0f82-4c55-aa05-41d12db6b770
1530	2026-10-08 18:29:18.556908+00	GET	/api/users	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.06130242347717285	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1535	2026-10-08 18:29:34.856535+00	GET	/api/audit	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.03110480308532715	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1536	2026-10-08 18:35:10.78858+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.14705848693847656	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1561	2026-10-08 18:38:42.137711+00	POST	/api/auth/login	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	401	0.0733191967010498	\N
1568	2026-10-08 18:50:32.841792+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.15762972831726074	826ac151-a131-48ee-aadc-c6db6f963c9c
1740	2026-10-08 20:22:14.835906+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.028413772583007812	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1742	2026-10-08 20:22:14.871177+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.020731687545776367	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1751	2026-10-08 20:22:49.093863+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.010214090347290039	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1753	2026-10-08 20:22:49.118146+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0062406063079833984	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1755	2026-10-08 20:22:50.888489+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.030349016189575195	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1757	2026-10-08 20:22:57.110601+00	GET	/api/sessions/7d99751a-91fa-4bae-a8e7-cba5ab18a544	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0073184967041015625	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1759	2026-10-08 20:22:59.52374+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0067026615142822266	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1761	2026-10-08 20:23:07.712611+00	GET	/api/sessions/7d99751a-91fa-4bae-a8e7-cba5ab18a544	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.005038261413574219	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1763	2026-10-08 20:23:09.591779+00	GET	/api/sessions/7d99751a-91fa-4bae-a8e7-cba5ab18a544	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0018012523651123047	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1785	2026-10-08 20:23:52.089146+00	GET	/api/sessions/7d99751a-91fa-4bae-a8e7-cba5ab18a544	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.003507852554321289	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1788	2026-10-08 20:23:54.856121+00	POST	/api/sessions/7d99751a-91fa-4bae-a8e7-cba5ab18a544/publish-studio	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.005478382110595703	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1790	2026-10-08 20:23:56.025724+00	GET	/api/sessions/7d99751a-91fa-4bae-a8e7-cba5ab18a544	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.003933429718017578	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1792	2026-10-08 20:23:57.90121+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0038225650787353516	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1794	2026-10-08 20:24:01.146701+00	GET	/api/audit	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.005405902862548828	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1796	2026-10-08 20:24:47.914633+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.14837384223937988	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1808	2026-10-08 20:24:57.170719+00	GET	/api/sessions/8431bdef-789a-4a8e-a151-76ca4ff740db	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0068759918212890625	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1824	2026-10-08 20:25:50.455831+00	GET	/api/sessions/77722f17-88b9-4ae3-8438-91cd12eced8f	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0024306774139404297	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1826	2026-10-08 20:25:53.381476+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.002496480941772461	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1828	2026-10-08 20:26:26.460861+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.013594388961791992	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1829	2026-10-08 20:26:31.313175+00	GET	/api/sessions/f29b7e3c-59c5-4380-9af4-96cec59b69bd	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0045511722564697266	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1831	2026-10-08 20:26:33.557829+00	GET	/api/sessions/f29b7e3c-59c5-4380-9af4-96cec59b69bd	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.01051020622253418	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2541	2026-10-09 10:56:46.943296+00	POST	/api/auth/login	127.0.0.1	python-httpx/0.28.1	200	0.2476978302001953	\N
417	2026-10-08 12:50:45.311072+00	GET	/api/sessions	127.0.0.1	python-httpx/0.28.1	200	0.00432586669921875	\N
426	2026-10-08 12:50:45.636171+00	GET	/api/sessions	127.0.0.1	python-httpx/0.28.1	200	0.00379180908203125	\N
427	2026-10-08 12:50:45.888526+00	POST	/api/auth/login	127.0.0.1	python-httpx/0.28.1	200	0.2435450553894043	\N
429	2026-10-08 12:50:45.910609+00	POST	/api/upload/multiple	127.0.0.1	python-httpx/0.28.1	201	0.004537105560302734	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
431	2026-10-08 12:56:28.292618+00	GET	/api/sessions	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.21889710426330566	\N
432	2026-10-08 12:56:28.310455+00	GET	/api/sessions	172.24.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.009988784790039062	\N
433	2026-10-08 12:57:17.081351+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.11014199256896973	\N
434	2026-10-08 12:57:17.109813+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.021546602249145508	\N
435	2026-10-08 12:58:15.827267+00	GET	/api/sessions/7d99751a-91fa-4bae-a8e7-cba5ab18a544	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.06619000434875488	\N
436	2026-10-08 12:58:15.841729+00	GET	/api/sessions/7d99751a-91fa-4bae-a8e7-cba5ab18a544	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.002460002899169922	\N
437	2026-10-08 12:58:55.345328+00	PATCH	/api/sessions/7d99751a-91fa-4bae-a8e7-cba5ab18a544/documentation	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	401	0.02006673812866211	\N
438	2026-10-08 12:59:05.246501+00	PATCH	/api/sessions/7d99751a-91fa-4bae-a8e7-cba5ab18a544/documentation	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	401	0.018536090850830078	\N
439	2026-10-08 12:59:23.999519+00	PATCH	/api/sessions/7d99751a-91fa-4bae-a8e7-cba5ab18a544/documentation	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	401	0.011344194412231445	\N
440	2026-10-08 13:01:04.821957+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	401	0.038535356521606445	\N
441	2026-10-08 13:01:04.83127+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	401	0.0017085075378417969	\N
442	2026-10-08 13:02:02.124905+00	GET	/api/journal/public	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.10998225212097168	\N
443	2026-10-08 13:02:02.152795+00	GET	/api/journal/public	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.019951343536376953	\N
444	2026-10-08 13:02:29.358649+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.025707006454467773	\N
445	2026-10-08 13:02:29.369334+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.004700183868408203	\N
446	2026-10-08 13:17:39.584975+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.023586034774780273	\N
447	2026-10-08 13:17:39.598737+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0021381378173828125	\N
448	2026-10-08 13:17:48.91338+00	GET	/api/auth/me	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	401	0.01725149154663086	\N
449	2026-10-08 13:17:48.925798+00	GET	/api/auth/me	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	401	0.0006999969482421875	\N
450	2026-10-08 13:17:48.930108+00	GET	/api/auth/me	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	401	0.0005507469177246094	\N
451	2026-10-08 13:17:48.934214+00	GET	/api/auth/me	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	401	0.0006299018859863281	\N
453	2026-10-08 13:17:51.332719+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.24637961387634277	\N
452	2026-10-08 13:17:51.32819+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.10168910026550293	\N
454	2026-10-08 13:17:51.387978+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.329221248626709	\N
455	2026-10-08 13:17:51.419038+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.008968353271484375	\N
456	2026-10-08 13:17:51.44335+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.08166313171386719	\N
457	2026-10-08 13:17:51.463356+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.09855961799621582	\N
458	2026-10-08 13:17:58.192805+00	GET	/api/users	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.012796878814697266	\N
459	2026-10-08 13:17:58.194509+00	GET	/api/users	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.014639616012573242	\N
460	2026-10-08 13:19:27.624226+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.01023101806640625	\N
461	2026-10-08 13:19:27.626399+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.017635822296142578	\N
462	2026-10-08 13:19:29.0659+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.022799968719482422	\N
463	2026-10-08 13:19:29.064454+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.00984954833984375	\N
464	2026-10-08 13:19:41.080003+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.010983943939208984	\N
465	2026-10-08 13:19:41.081143+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.010442018508911133	\N
2542	2026-10-09 10:56:46.980965+00	POST	/api/sessions	127.0.0.1	python-httpx/0.28.1	201	0.03452420234680176	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
467	2026-10-08 13:19:42.605162+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.01629495620727539	\N
475	2026-10-08 13:20:01.839277+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.002207517623901367	\N
477	2026-10-08 13:20:03.273855+00	GET	/api/sessions/e630385a-5974-4a0f-862e-2e09c01440a6	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.025240182876586914	\N
494	2026-10-08 13:20:34.393168+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.020740747451782227	\N
1298	2026-10-08 17:44:42.281122+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.07797527313232422	\N
1526	2026-10-08 18:29:10.712371+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.052110910415649414	2b3f77bc-0f82-4c55-aa05-41d12db6b770
1531	2026-10-08 18:29:18.558681+00	GET	/api/users	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.06319403648376465	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1532	2026-10-08 18:29:18.911909+00	GET	/api/audit	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.04615521430969238	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1537	2026-10-08 18:35:10.810699+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.11659121513366699	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1562	2026-10-08 18:39:55.382925+00	POST	/api/auth/login	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	401	0.04459810256958008	\N
1573	2026-10-08 18:51:02.888032+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.04848480224609375	826ac151-a131-48ee-aadc-c6db6f963c9c
1575	2026-10-08 18:53:39.742398+00	POST	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	403	0.024233579635620117	826ac151-a131-48ee-aadc-c6db6f963c9c
1580	2026-10-08 18:57:47.921367+00	POST	/api/auth/login	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	401	0.31288933753967285	\N
1591	2026-10-08 19:01:50.090838+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.026407480239868164	96a48a1b-0906-45c2-923a-18836cecc423
1593	2026-10-08 19:02:15.705841+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.04494786262512207	96a48a1b-0906-45c2-923a-18836cecc423
1595	2026-10-08 19:04:23.531564+00	GET	/api/journal/public	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.05891132354736328	96a48a1b-0906-45c2-923a-18836cecc423
1597	2026-10-08 19:04:40.083429+00	GET	/api/journal/e1b9db18-3f6f-41c4-8498-f18a574ebc7e	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.028238534927368164	96a48a1b-0906-45c2-923a-18836cecc423
1599	2026-10-08 19:05:42.525378+00	GET	/api/journal/public	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.027457237243652344	96a48a1b-0906-45c2-923a-18836cecc423
1601	2026-10-08 19:11:03.0428+00	GET	/api/journal/public	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.10347795486450195	96a48a1b-0906-45c2-923a-18836cecc423
1603	2026-10-08 19:26:59.348055+00	GET	/api/journal/public	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.08581662178039551	96a48a1b-0906-45c2-923a-18836cecc423
1616	2026-10-08 20:15:23.471773+00	GET	/api/sessions/77722f17-88b9-4ae3-8438-91cd12eced8f	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.01668572425842285	\N
1617	2026-10-08 20:15:27.419335+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.009409904479980469	\N
1620	2026-10-08 20:15:31.188802+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.030417680740356445	\N
1623	2026-10-08 20:15:34.051532+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.008651494979858398	\N
1626	2026-10-08 20:15:35.986202+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.007622718811035156	\N
1632	2026-10-08 20:15:39.871346+00	GET	/api/users	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.0038459300994873047	\N
1641	2026-10-08 20:16:29.952305+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.008499860763549805	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1643	2026-10-08 20:16:31.507775+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.020020723342895508	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1645	2026-10-08 20:16:35.222836+00	GET	/api/journal/de99b413-6a92-48c8-823d-17d0e2ed6b07	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.016676664352416992	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1655	2026-10-08 20:17:29.08122+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.007715463638305664	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1741	2026-10-08 20:22:14.837277+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.03062295913696289	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1750	2026-10-08 20:22:49.091779+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.006369590759277344	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1764	2026-10-08 20:23:13.778999+00	PATCH	/api/sessions/7d99751a-91fa-4bae-a8e7-cba5ab18a544/documentation	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.04160046577453613	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1774	2026-10-08 20:23:32.89207+00	GET	/api/sessions/7d99751a-91fa-4bae-a8e7-cba5ab18a544	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.022767066955566406	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1776	2026-10-08 20:23:36.05783+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.006899833679199219	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1778	2026-10-08 20:23:40.486197+00	GET	/api/sessions/7d99751a-91fa-4bae-a8e7-cba5ab18a544	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0026865005493164062	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1780	2026-10-08 20:23:42.352244+00	GET	/api/sessions/7d99751a-91fa-4bae-a8e7-cba5ab18a544	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.021477222442626953	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1787	2026-10-08 20:23:54.844026+00	PATCH	/api/sessions/7d99751a-91fa-4bae-a8e7-cba5ab18a544/documentation	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.008236885070800781	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1795	2026-10-08 20:24:14.535065+00	GET	/api/openapi.json	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.2717716693878174	\N
2683	2026-10-09 11:51:59.4185+00	POST	/api/auth/login	127.0.0.1	python-httpx/0.28.1	200	0.2813267707824707	\N
466	2026-10-08 13:19:42.605576+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.01733088493347168	\N
469	2026-10-08 13:19:43.604089+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.01906752586364746	\N
473	2026-10-08 13:19:58.891493+00	GET	/api/sessions/6181c511-10b9-4bff-b8f4-164d7db901ba	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.026918411254882812	\N
474	2026-10-08 13:20:01.833256+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.007978439331054688	\N
479	2026-10-08 13:20:04.537476+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0026655197143554688	\N
481	2026-10-08 13:20:09.521967+00	GET	/api/sessions/451afbe0-be04-4d5f-a8c4-3e523e3695e8	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.013920307159423828	\N
497	2026-10-08 13:20:35.486522+00	GET	/api/sessions/8431bdef-789a-4a8e-a151-76ca4ff740db	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0074427127838134766	\N
1318	2026-10-08 17:44:52.746858+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.14725613594055176	\N
1321	2026-10-08 17:44:53.900355+00	GET	/api/auth/me	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.016794919967651367	\N
1527	2026-10-08 18:29:10.716439+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.047865867614746094	2b3f77bc-0f82-4c55-aa05-41d12db6b770
1533	2026-10-08 18:29:18.91231+00	GET	/api/audit	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.057444095611572266	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1534	2026-10-08 18:29:34.857162+00	GET	/api/audit	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.05711174011230469	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1565	2026-10-08 18:48:16.032435+00	POST	/api/auth/login	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	401	0.06706666946411133	\N
1577	2026-10-08 18:53:56.01524+00	POST	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	403	0.029093265533447266	826ac151-a131-48ee-aadc-c6db6f963c9c
1582	2026-10-08 18:59:32.33206+00	POST	/api/auth/register	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	400	0.04799818992614746	\N
1584	2026-10-08 19:01:19.708682+00	POST	/api/auth/register	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	201	0.3827097415924072	\N
1585	2026-10-08 19:01:19.911453+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.05187392234802246	96a48a1b-0906-45c2-923a-18836cecc423
1608	2026-10-08 20:15:14.366195+00	GET	/api/journal/public	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.02989482879638672	\N
1609	2026-10-08 20:15:16.481378+00	GET	/api/journal/de99b413-6a92-48c8-823d-17d0e2ed6b07	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.014393329620361328	\N
1611	2026-10-08 20:15:20.517524+00	GET	/api/journal/public	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.014159440994262695	\N
1621	2026-10-08 20:15:32.925107+00	GET	/api/users	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.0019822120666503906	\N
1628	2026-10-08 20:15:38.603501+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0244443416595459	\N
1631	2026-10-08 20:15:39.870361+00	GET	/api/users	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.006269216537475586	\N
1634	2026-10-08 20:16:03.484816+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.009223461151123047	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1648	2026-10-08 20:16:38.702108+00	GET	/api/audit	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.02218151092529297	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1650	2026-10-08 20:16:42.825168+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.017229795455932617	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1652	2026-10-08 20:16:57.463645+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.02153468132019043	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1752	2026-10-08 20:22:49.100096+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0646047592163086	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1765	2026-10-08 20:23:13.802452+00	POST	/api/sessions/7d99751a-91fa-4bae-a8e7-cba5ab18a544/publish-studio	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.010270118713378906	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1767	2026-10-08 20:23:14.957772+00	GET	/api/sessions/7d99751a-91fa-4bae-a8e7-cba5ab18a544	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0017921924591064453	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1769	2026-10-08 20:23:17.059956+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.003866434097290039	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1771	2026-10-08 20:23:22.971071+00	GET	/api/sessions/7d99751a-91fa-4bae-a8e7-cba5ab18a544	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0021076202392578125	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1773	2026-10-08 20:23:25.248031+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.003943443298339844	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1775	2026-10-08 20:23:32.892873+00	GET	/api/sessions/7d99751a-91fa-4bae-a8e7-cba5ab18a544	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.007554292678833008	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1782	2026-10-08 20:23:49.156098+00	GET	/api/sessions/7d99751a-91fa-4bae-a8e7-cba5ab18a544	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.012711763381958008	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1789	2026-10-08 20:23:56.014113+00	GET	/api/sessions/7d99751a-91fa-4bae-a8e7-cba5ab18a544	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.011637687683105469	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1791	2026-10-08 20:23:57.89209+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.006359577178955078	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1793	2026-10-08 20:24:01.134407+00	GET	/api/audit	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.02565479278564453	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1802	2026-10-08 20:24:50.721998+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.02745223045349121	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1811	2026-10-08 20:25:00.434504+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.007643699645996094	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2684	2026-10-09 11:51:59.515465+00	POST	/api/journal	127.0.0.1	python-httpx/0.28.1	201	0.07751274108886719	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
468	2026-10-08 13:19:43.60486+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.011940479278564453	\N
470	2026-10-08 13:19:46.730084+00	GET	/api/sessions/77722f17-88b9-4ae3-8438-91cd12eced8f	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.00988459587097168	\N
483	2026-10-08 13:20:10.958788+00	GET	/api/sessions/451afbe0-be04-4d5f-a8c4-3e523e3695e8	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0019202232360839844	\N
486	2026-10-08 13:20:26.02377+00	GET	/api/sessions/451afbe0-be04-4d5f-a8c4-3e523e3695e8	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.027773618698120117	\N
488	2026-10-08 13:20:27.653366+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.006821155548095703	\N
493	2026-10-08 13:20:31.728054+00	GET	/api/sessions/6181c511-10b9-4bff-b8f4-164d7db901ba	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0015246868133544922	\N
495	2026-10-08 13:20:34.394439+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.023503541946411133	\N
496	2026-10-08 13:20:35.485862+00	GET	/api/sessions/8431bdef-789a-4a8e-a151-76ca4ff740db	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.00687861442565918	\N
1324	2026-10-08 17:44:59.251953+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.03243851661682129	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1337	2026-10-08 17:45:10.467179+00	GET	/api/auth/me	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.012969493865966797	\N
1528	2026-10-08 18:29:10.724195+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.05727410316467285	2b3f77bc-0f82-4c55-aa05-41d12db6b770
1766	2026-10-08 20:23:14.950964+00	GET	/api/sessions/7d99751a-91fa-4bae-a8e7-cba5ab18a544	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.00537562370300293	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1768	2026-10-08 20:23:17.051577+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.016843795776367188	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1770	2026-10-08 20:23:22.96409+00	GET	/api/sessions/7d99751a-91fa-4bae-a8e7-cba5ab18a544	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.008887767791748047	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1772	2026-10-08 20:23:25.237981+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.006804227828979492	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1777	2026-10-08 20:23:36.064902+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.00257110595703125	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1779	2026-10-08 20:23:40.494524+00	GET	/api/sessions/7d99751a-91fa-4bae-a8e7-cba5ab18a544	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0016205310821533203	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1781	2026-10-08 20:23:42.362049+00	GET	/api/sessions/7d99751a-91fa-4bae-a8e7-cba5ab18a544	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0021142959594726562	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1783	2026-10-08 20:23:49.156598+00	GET	/api/sessions/7d99751a-91fa-4bae-a8e7-cba5ab18a544	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.026613950729370117	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1784	2026-10-08 20:23:52.075938+00	GET	/api/sessions/7d99751a-91fa-4bae-a8e7-cba5ab18a544	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0192716121673584	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1797	2026-10-08 20:24:47.915327+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.15015864372253418	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1798	2026-10-08 20:24:48.628204+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.010794401168823242	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1800	2026-10-08 20:24:49.571134+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.005075693130493164	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1805	2026-10-08 20:24:51.653785+00	GET	/api/sessions/77722f17-88b9-4ae3-8438-91cd12eced8f	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.005626678466796875	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1807	2026-10-08 20:24:55.080411+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.013911724090576172	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1814	2026-10-08 20:25:11.087429+00	GET	/api/sessions/f29b7e3c-59c5-4380-9af4-96cec59b69bd	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.007144927978515625	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1815	2026-10-08 20:25:27.779593+00	PATCH	/api/sessions/f29b7e3c-59c5-4380-9af4-96cec59b69bd/documentation	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.035125017166137695	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1840	2026-10-08 20:27:43.923418+00	GET	/api/sessions/f29b7e3c-59c5-4380-9af4-96cec59b69bd	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0174252986907959	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1845	2026-10-08 20:27:46.787057+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.004940986633300781	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1847	2026-10-08 20:27:51.970218+00	GET	/api/sessions/f29b7e3c-59c5-4380-9af4-96cec59b69bd	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.005856752395629883	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1851	2026-10-08 20:27:59.597145+00	PATCH	/api/sessions/f29b7e3c-59c5-4380-9af4-96cec59b69bd/documentation	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.024892091751098633	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1853	2026-10-08 20:28:02.223206+00	GET	/api/sessions/f29b7e3c-59c5-4380-9af4-96cec59b69bd	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0018887519836425781	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1855	2026-10-08 20:28:03.316985+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.002283334732055664	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1857	2026-10-08 20:28:07.321317+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.020806550979614258	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1861	2026-10-08 20:28:25.864631+00	GET	/api/sessions/e630385a-5974-4a0f-862e-2e09c01440a6	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.006938457489013672	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1862	2026-10-08 20:28:27.143006+00	PATCH	/api/sessions/e630385a-5974-4a0f-862e-2e09c01440a6/documentation	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.025059938430786133	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1864	2026-10-08 20:28:30.515909+00	GET	/api/sessions/e630385a-5974-4a0f-862e-2e09c01440a6	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.001539468765258789	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1865	2026-10-08 20:28:30.796152+00	GET	/api/sessions/e630385a-5974-4a0f-862e-2e09c01440a6	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.007354021072387695	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2687	2026-10-09 11:51:59.543282+00	GET	/api/journal/public	127.0.0.1	python-httpx/0.28.1	200	0.007288217544555664	\N
471	2026-10-08 13:19:46.730973+00	GET	/api/sessions/77722f17-88b9-4ae3-8438-91cd12eced8f	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.028868436813354492	\N
472	2026-10-08 13:19:58.890836+00	GET	/api/sessions/6181c511-10b9-4bff-b8f4-164d7db901ba	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.008944034576416016	\N
480	2026-10-08 13:20:09.521146+00	GET	/api/sessions/451afbe0-be04-4d5f-a8c4-3e523e3695e8	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.01615619659423828	\N
482	2026-10-08 13:20:10.952217+00	GET	/api/sessions/451afbe0-be04-4d5f-a8c4-3e523e3695e8	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0055179595947265625	\N
485	2026-10-08 13:20:24.599227+00	PATCH	/api/sessions/451afbe0-be04-4d5f-a8c4-3e523e3695e8/documentation	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.0060427188873291016	\N
490	2026-10-08 13:20:30.259388+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.1590731143951416	\N
492	2026-10-08 13:20:31.722776+00	GET	/api/sessions/6181c511-10b9-4bff-b8f4-164d7db901ba	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.004365205764770508	\N
1325	2026-10-08 17:44:59.253087+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.03805351257324219	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1328	2026-10-08 17:44:59.271978+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.08278799057006836	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1331	2026-10-08 17:45:00.594253+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.021388530731201172	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1335	2026-10-08 17:45:06.295308+00	GET	/api/users	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.003864288330078125	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1338	2026-10-08 17:45:10.470794+00	GET	/api/auth/me	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.012039661407470703	\N
1529	2026-10-08 18:29:10.734409+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0662531852722168	2b3f77bc-0f82-4c55-aa05-41d12db6b770
1806	2026-10-08 20:24:55.079557+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.01193547248840332	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1809	2026-10-08 20:24:57.169964+00	GET	/api/sessions/8431bdef-789a-4a8e-a151-76ca4ff740db	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.005375862121582031	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1810	2026-10-08 20:25:00.418921+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.021398305892944336	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1816	2026-10-08 20:25:27.801359+00	POST	/api/sessions/f29b7e3c-59c5-4380-9af4-96cec59b69bd/publish-studio	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.006262779235839844	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1818	2026-10-08 20:25:29.01689+00	GET	/api/sessions/f29b7e3c-59c5-4380-9af4-96cec59b69bd	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0023407936096191406	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1820	2026-10-08 20:25:33.238029+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.009111166000366211	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1822	2026-10-08 20:25:35.809634+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.004101276397705078	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1833	2026-10-08 20:26:42.569556+00	PATCH	/api/sessions/f29b7e3c-59c5-4380-9af4-96cec59b69bd/documentation	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.12953925132751465	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1836	2026-10-08 20:27:38.420908+00	PATCH	/api/sessions/f29b7e3c-59c5-4380-9af4-96cec59b69bd/documentation	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.013707637786865234	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1839	2026-10-08 20:27:39.328101+00	PATCH	/api/sessions/f29b7e3c-59c5-4380-9af4-96cec59b69bd/documentation	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.006905078887939453	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1841	2026-10-08 20:27:43.933252+00	GET	/api/sessions/f29b7e3c-59c5-4380-9af4-96cec59b69bd	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.002331972122192383	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1843	2026-10-08 20:27:44.248843+00	GET	/api/sessions/f29b7e3c-59c5-4380-9af4-96cec59b69bd	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.004060029983520508	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1852	2026-10-08 20:28:02.214804+00	GET	/api/sessions/f29b7e3c-59c5-4380-9af4-96cec59b69bd	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0036737918853759766	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1854	2026-10-08 20:28:03.311217+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.008846759796142578	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1859	2026-10-08 20:28:23.8477+00	GET	/api/sessions/e630385a-5974-4a0f-862e-2e09c01440a6	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.008213281631469727	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1866	2026-10-08 20:28:30.795635+00	GET	/api/sessions/e630385a-5974-4a0f-862e-2e09c01440a6	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0069866180419921875	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1869	2026-10-08 20:28:32.229989+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.009749174118041992	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1886	2026-10-08 20:28:52.850308+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.011471033096313477	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2040	2026-10-08 20:58:37.61369+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.015152692794799805	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2231	2026-10-08 21:18:29.757309+00	GET	/api/sessions/ccb9c8cd-e6a4-4efa-8d34-69095c43e387	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.005706310272216797	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2233	2026-10-08 21:18:46.562677+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.003334522247314453	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2234	2026-10-08 21:18:48.819463+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.015716075897216797	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2241	2026-10-08 21:19:15.456591+00	POST	/api/sessions/1bc6dfe0-cc1d-4446-995b-64c17d34623f/complete-and-document	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.03878283500671387	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2243	2026-10-08 21:19:15.526359+00	GET	/api/sessions/1bc6dfe0-cc1d-4446-995b-64c17d34623f	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0033638477325439453	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2255	2026-10-08 21:20:36.260429+00	GET	/api/sessions/1bc6dfe0-cc1d-4446-995b-64c17d34623f	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0045931339263916016	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2688	2026-10-09 11:51:59.790772+00	POST	/api/auth/login	127.0.0.1	python-httpx/0.28.1	200	0.23810315132141113	\N
476	2026-10-08 13:20:03.273337+00	GET	/api/sessions/e630385a-5974-4a0f-862e-2e09c01440a6	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.008899211883544922	\N
478	2026-10-08 13:20:04.529071+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.00799250602722168	\N
484	2026-10-08 13:20:20.668375+00	PATCH	/api/sessions/451afbe0-be04-4d5f-a8c4-3e523e3695e8/documentation	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.02060866355895996	\N
487	2026-10-08 13:20:26.037502+00	GET	/api/sessions/451afbe0-be04-4d5f-a8c4-3e523e3695e8	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.002813577651977539	\N
489	2026-10-08 13:20:27.662467+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.004335641860961914	\N
491	2026-10-08 13:20:30.259834+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.19210076332092285	\N
498	2026-10-08 13:20:40.253986+00	GET	/api/sessions/8431bdef-789a-4a8e-a151-76ca4ff740db	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.01628398895263672	\N
499	2026-10-08 13:20:40.254805+00	GET	/api/sessions/8431bdef-789a-4a8e-a151-76ca4ff740db	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0192413330078125	\N
500	2026-10-08 13:20:49.73939+00	PATCH	/api/sessions/8431bdef-789a-4a8e-a151-76ca4ff740db/documentation	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.018377065658569336	\N
501	2026-10-08 13:21:00.964965+00	PATCH	/api/sessions/8431bdef-789a-4a8e-a151-76ca4ff740db/documentation	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.009690523147583008	\N
502	2026-10-08 13:21:05.516571+00	PATCH	/api/sessions/8431bdef-789a-4a8e-a151-76ca4ff740db/documentation	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.0031223297119140625	\N
503	2026-10-08 13:21:06.751376+00	PATCH	/api/sessions/8431bdef-789a-4a8e-a151-76ca4ff740db/documentation	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.002412080764770508	\N
504	2026-10-08 13:21:07.04581+00	PATCH	/api/sessions/8431bdef-789a-4a8e-a151-76ca4ff740db/documentation	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.0040624141693115234	\N
505	2026-10-08 13:21:51.747272+00	POST	/api/auth/login	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.28630590438842773	\N
506	2026-10-08 13:21:51.832154+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.006108760833740234	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
507	2026-10-08 13:21:51.843157+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.003557443618774414	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
508	2026-10-08 13:22:01.453583+00	GET	/api/sessions/6181c511-10b9-4bff-b8f4-164d7db901ba	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.016257762908935547	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
509	2026-10-08 13:22:01.469384+00	GET	/api/sessions/6181c511-10b9-4bff-b8f4-164d7db901ba	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.007845640182495117	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
510	2026-10-08 13:22:03.32601+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.005007743835449219	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
511	2026-10-08 13:22:03.333664+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0024089813232421875	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
512	2026-10-08 13:22:07.680331+00	GET	/api/sessions/8431bdef-789a-4a8e-a151-76ca4ff740db	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.01683521270751953	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
513	2026-10-08 13:22:07.694473+00	GET	/api/sessions/8431bdef-789a-4a8e-a151-76ca4ff740db	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.005702018737792969	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
514	2026-10-08 13:22:10.757798+00	GET	/api/auth/me	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.016251325607299805	\N
515	2026-10-08 13:22:10.756725+00	GET	/api/auth/me	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.012137174606323242	\N
516	2026-10-08 13:22:15.630861+00	GET	/api/sessions/6181c511-10b9-4bff-b8f4-164d7db901ba	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.011687755584716797	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
517	2026-10-08 13:22:15.629867+00	GET	/api/sessions/6181c511-10b9-4bff-b8f4-164d7db901ba	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.027446746826171875	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
518	2026-10-08 13:22:17.576571+00	GET	/api/sessions/6181c511-10b9-4bff-b8f4-164d7db901ba	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.003712892532348633	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
519	2026-10-08 13:22:17.583953+00	GET	/api/sessions/6181c511-10b9-4bff-b8f4-164d7db901ba	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0018162727355957031	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
520	2026-10-08 13:22:20.08949+00	GET	/api/sessions/6181c511-10b9-4bff-b8f4-164d7db901ba	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0299072265625	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
521	2026-10-08 13:22:20.091644+00	GET	/api/sessions/6181c511-10b9-4bff-b8f4-164d7db901ba	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.036148786544799805	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
522	2026-10-08 13:22:22.160464+00	GET	/api/sessions/6181c511-10b9-4bff-b8f4-164d7db901ba	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0043087005615234375	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
523	2026-10-08 13:22:22.161967+00	GET	/api/sessions/6181c511-10b9-4bff-b8f4-164d7db901ba	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.005868434906005859	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
524	2026-10-08 13:22:22.837049+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.007491111755371094	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
525	2026-10-08 13:22:22.837504+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.008364677429199219	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
526	2026-10-08 13:24:01.971861+00	GET	/api/sessions/8431bdef-789a-4a8e-a151-76ca4ff740db	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.007623434066772461	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
527	2026-10-08 13:24:01.975214+00	GET	/api/sessions/8431bdef-789a-4a8e-a151-76ca4ff740db	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.03223228454589844	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
528	2026-10-08 13:24:06.387888+00	GET	/api/sessions/8431bdef-789a-4a8e-a151-76ca4ff740db	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.022189855575561523	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
529	2026-10-08 13:24:06.389561+00	GET	/api/sessions/8431bdef-789a-4a8e-a151-76ca4ff740db	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.025356292724609375	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
530	2026-10-08 13:25:20.403957+00	PATCH	/api/sessions/8431bdef-789a-4a8e-a151-76ca4ff740db/documentation	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0875701904296875	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
533	2026-10-08 13:25:46.782019+00	PATCH	/api/sessions/8431bdef-789a-4a8e-a151-76ca4ff740db/documentation	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.053961992263793945	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
536	2026-10-08 13:26:19.443742+00	PATCH	/api/sessions/8431bdef-789a-4a8e-a151-76ca4ff740db/documentation	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.07925105094909668	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
539	2026-10-08 13:26:41.036962+00	PATCH	/api/sessions/8431bdef-789a-4a8e-a151-76ca4ff740db/documentation	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.05104184150695801	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
542	2026-10-08 13:27:05.806473+00	POST	/api/sessions/8431bdef-789a-4a8e-a151-76ca4ff740db/publish-studio	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.013167858123779297	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
544	2026-10-08 13:27:09.721213+00	GET	/api/sessions/8431bdef-789a-4a8e-a151-76ca4ff740db	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.002000093460083008	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
545	2026-10-08 13:28:04.832579+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.01830577850341797	\N
553	2026-10-08 13:28:09.056881+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.010596513748168945	\N
555	2026-10-08 13:28:09.089586+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.09006881713867188	\N
559	2026-10-08 13:28:21.30097+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.006962299346923828	\N
1326	2026-10-08 17:44:59.252783+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.07162308692932129	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1333	2026-10-08 17:45:01.920514+00	GET	/api/users	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.024004459381103516	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1334	2026-10-08 17:45:06.280061+00	POST	/api/users/2b3f77bc-0f82-4c55-aa05-41d12db6b770/verify	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.022435665130615234	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1339	2026-10-08 17:45:10.468211+00	GET	/api/auth/me	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.011428594589233398	\N
1340	2026-10-08 17:45:22.746482+00	POST	/api/auth/login	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.2835068702697754	\N
1538	2026-10-08 18:37:20.573216+00	POST	/api/auth/login	127.0.0.1	python-httpx/0.28.1	200	0.28127098083496094	\N
1539	2026-10-08 18:37:20.653371+00	POST	/api/journal	127.0.0.1	python-httpx/0.28.1	201	0.06934118270874023	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1540	2026-10-08 18:37:20.669193+00	PATCH	/api/journal/a31ed9fe-3132-48f7-9b8e-46481c4cd0a0	127.0.0.1	python-httpx/0.28.1	200	0.012063026428222656	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1541	2026-10-08 18:37:20.682282+00	POST	/api/journal/a31ed9fe-3132-48f7-9b8e-46481c4cd0a0/approve	127.0.0.1	python-httpx/0.28.1	200	0.008651971817016602	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1547	2026-10-08 18:37:21.034918+00	GET	/api/sessions	127.0.0.1	python-httpx/0.28.1	200	0.004033088684082031	\N
1556	2026-10-08 18:37:21.370246+00	GET	/api/sessions	127.0.0.1	python-httpx/0.28.1	200	0.0033059120178222656	\N
1557	2026-10-08 18:37:21.622554+00	POST	/api/auth/login	127.0.0.1	python-httpx/0.28.1	200	0.24321889877319336	\N
1559	2026-10-08 18:37:21.647345+00	POST	/api/upload/multiple	127.0.0.1	python-httpx/0.28.1	201	0.00473785400390625	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1812	2026-10-08 20:25:11.017114+00	POST	/api/sessions/f29b7e3c-59c5-4380-9af4-96cec59b69bd/complete-and-document	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.045369625091552734	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1813	2026-10-08 20:25:11.087844+00	GET	/api/sessions/f29b7e3c-59c5-4380-9af4-96cec59b69bd	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.004679203033447266	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1817	2026-10-08 20:25:29.008739+00	GET	/api/sessions/f29b7e3c-59c5-4380-9af4-96cec59b69bd	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.006976127624511719	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1819	2026-10-08 20:25:33.216729+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.018357276916503906	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1827	2026-10-08 20:26:26.460236+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.02195143699645996	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1834	2026-10-08 20:26:55.362385+00	PATCH	/api/sessions/f29b7e3c-59c5-4380-9af4-96cec59b69bd/documentation	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.029053211212158203	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1837	2026-10-08 20:27:38.93175+00	PATCH	/api/sessions/f29b7e3c-59c5-4380-9af4-96cec59b69bd/documentation	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.008034229278564453	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1849	2026-10-08 20:27:56.305236+00	GET	/api/sessions/f29b7e3c-59c5-4380-9af4-96cec59b69bd	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.006701946258544922	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1856	2026-10-08 20:28:07.320712+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.01062154769897461	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1858	2026-10-08 20:28:23.846727+00	GET	/api/sessions/e630385a-5974-4a0f-862e-2e09c01440a6	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.014662504196166992	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1860	2026-10-08 20:28:25.863472+00	GET	/api/sessions/e630385a-5974-4a0f-862e-2e09c01440a6	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.005489826202392578	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1868	2026-10-08 20:28:32.201139+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.029045820236206055	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1873	2026-10-08 20:28:33.621839+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.002743244171142578	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1875	2026-10-08 20:28:40.912809+00	GET	/api/sessions/f29b7e3c-59c5-4380-9af4-96cec59b69bd	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.018331289291381836	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1877	2026-10-08 20:28:43.455671+00	GET	/api/sessions/f29b7e3c-59c5-4380-9af4-96cec59b69bd	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.006810188293457031	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1881	2026-10-08 20:28:50.801033+00	GET	/api/sessions/f29b7e3c-59c5-4380-9af4-96cec59b69bd	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.021183252334594727	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2050	2026-10-08 20:58:42.61093+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.05357241630554199	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
531	2026-10-08 13:25:30.131753+00	PATCH	/api/sessions/8431bdef-789a-4a8e-a151-76ca4ff740db/documentation	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.08000493049621582	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
534	2026-10-08 13:25:54.781017+00	PATCH	/api/sessions/8431bdef-789a-4a8e-a151-76ca4ff740db/documentation	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.06074976921081543	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
537	2026-10-08 13:26:22.512812+00	PATCH	/api/sessions/8431bdef-789a-4a8e-a151-76ca4ff740db/documentation	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.016847610473632812	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
540	2026-10-08 13:26:47.480151+00	PATCH	/api/sessions/8431bdef-789a-4a8e-a151-76ca4ff740db/documentation	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.016622543334960938	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
546	2026-10-08 13:28:04.833199+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.09443235397338867	\N
554	2026-10-08 13:28:09.057518+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.017078161239624023	\N
557	2026-10-08 13:28:21.279817+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.02614903450012207	\N
563	2026-10-08 14:11:26.055268+00	GET	/api/sessions/8431bdef-789a-4a8e-a151-76ca4ff740db	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.08725523948669434	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1327	2026-10-08 17:44:59.253461+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.04175257682800293	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1329	2026-10-08 17:44:59.290285+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.10017633438110352	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1542	2026-10-08 18:37:20.696328+00	GET	/api/journal/public	127.0.0.1	python-httpx/0.28.1	200	0.010530948638916016	\N
1543	2026-10-08 18:37:20.969566+00	POST	/api/auth/login	127.0.0.1	python-httpx/0.28.1	200	0.25861096382141113	\N
1544	2026-10-08 18:37:21.008486+00	POST	/api/sessions	127.0.0.1	python-httpx/0.28.1	201	0.0307619571685791	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1545	2026-10-08 18:37:21.018724+00	POST	/api/sessions/1d41586b-044b-4676-a21c-e506978c27bb/publish	127.0.0.1	python-httpx/0.28.1	200	0.007080078125	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1546	2026-10-08 18:37:21.027094+00	POST	/api/sessions/1d41586b-044b-4676-a21c-e506978c27bb/complete	127.0.0.1	python-httpx/0.28.1	200	0.0048732757568359375	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1548	2026-10-08 18:37:21.040071+00	GET	/api/sessions/1d41586b-044b-4676-a21c-e506978c27bb	127.0.0.1	python-httpx/0.28.1	200	0.0016868114471435547	\N
1549	2026-10-08 18:37:21.050263+00	PATCH	/api/sessions/1d41586b-044b-4676-a21c-e506978c27bb	127.0.0.1	python-httpx/0.28.1	200	0.006860971450805664	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1550	2026-10-08 18:37:21.3084+00	POST	/api/auth/login	127.0.0.1	python-httpx/0.28.1	200	0.24872899055480957	\N
1551	2026-10-08 18:37:21.325033+00	POST	/api/sessions	127.0.0.1	python-httpx/0.28.1	201	0.009610891342163086	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1552	2026-10-08 18:37:21.335733+00	POST	/api/sessions/08f94f0a-7b8e-40cf-9dd1-c59e8a247d63/publish	127.0.0.1	python-httpx/0.28.1	200	0.006337165832519531	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1553	2026-10-08 18:37:21.346213+00	POST	/api/sessions/08f94f0a-7b8e-40cf-9dd1-c59e8a247d63/complete-and-document	127.0.0.1	python-httpx/0.28.1	200	0.006160736083984375	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1554	2026-10-08 18:37:21.355412+00	PATCH	/api/sessions/08f94f0a-7b8e-40cf-9dd1-c59e8a247d63/documentation	127.0.0.1	python-httpx/0.28.1	200	0.005976676940917969	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1555	2026-10-08 18:37:21.363991+00	POST	/api/sessions/08f94f0a-7b8e-40cf-9dd1-c59e8a247d63/publish-studio	127.0.0.1	python-httpx/0.28.1	200	0.005541324615478516	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1558	2026-10-08 18:37:21.635093+00	POST	/api/upload	127.0.0.1	python-httpx/0.28.1	201	0.004893064498901367	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1560	2026-10-08 18:37:21.658443+00	POST	/api/upload	127.0.0.1	python-httpx/0.28.1	400	0.00684809684753418	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1821	2026-10-08 20:25:35.808413+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.012735605239868164	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1823	2026-10-08 20:25:50.446185+00	GET	/api/sessions/77722f17-88b9-4ae3-8438-91cd12eced8f	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.016031265258789062	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1825	2026-10-08 20:25:53.375416+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.008271455764770508	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1830	2026-10-08 20:26:31.319244+00	GET	/api/sessions/f29b7e3c-59c5-4380-9af4-96cec59b69bd	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0016655921936035156	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1832	2026-10-08 20:26:33.565366+00	GET	/api/sessions/f29b7e3c-59c5-4380-9af4-96cec59b69bd	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0014789104461669922	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1835	2026-10-08 20:27:37.388283+00	PATCH	/api/sessions/f29b7e3c-59c5-4380-9af4-96cec59b69bd/documentation	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0250091552734375	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1838	2026-10-08 20:27:39.106638+00	PATCH	/api/sessions/f29b7e3c-59c5-4380-9af4-96cec59b69bd/documentation	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.007439374923706055	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1842	2026-10-08 20:27:44.245869+00	GET	/api/sessions/f29b7e3c-59c5-4380-9af4-96cec59b69bd	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.008148670196533203	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1844	2026-10-08 20:27:46.772039+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.02738332748413086	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1846	2026-10-08 20:27:51.955359+00	GET	/api/sessions/f29b7e3c-59c5-4380-9af4-96cec59b69bd	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.015172958374023438	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1863	2026-10-08 20:28:30.508886+00	GET	/api/sessions/e630385a-5974-4a0f-862e-2e09c01440a6	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0048749446868896484	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1867	2026-10-08 20:28:32.200461+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.024297475814819336	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1880	2026-10-08 20:28:47.249013+00	PATCH	/api/sessions/f29b7e3c-59c5-4380-9af4-96cec59b69bd/documentation	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.011383533477783203	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1882	2026-10-08 20:28:50.814999+00	GET	/api/sessions/f29b7e3c-59c5-4380-9af4-96cec59b69bd	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0025348663330078125	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1884	2026-10-08 20:28:51.0195+00	GET	/api/sessions/f29b7e3c-59c5-4380-9af4-96cec59b69bd	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.004372835159301758	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1885	2026-10-08 20:28:52.850795+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.012465953826904297	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2055	2026-10-08 20:58:46.27081+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.051215410232543945	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
532	2026-10-08 13:25:34.570553+00	PATCH	/api/sessions/8431bdef-789a-4a8e-a151-76ca4ff740db/documentation	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.014982461929321289	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
535	2026-10-08 13:26:12.587048+00	PATCH	/api/sessions/8431bdef-789a-4a8e-a151-76ca4ff740db/documentation	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.07016897201538086	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
538	2026-10-08 13:26:27.572593+00	PATCH	/api/sessions/8431bdef-789a-4a8e-a151-76ca4ff740db/documentation	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.05477333068847656	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
541	2026-10-08 13:27:05.780621+00	PATCH	/api/sessions/8431bdef-789a-4a8e-a151-76ca4ff740db/documentation	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.04002857208251953	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1342	2026-10-08 17:45:23.008654+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.04894828796386719	2b3f77bc-0f82-4c55-aa05-41d12db6b770
1345	2026-10-08 17:45:23.108852+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.20532679557800293	2b3f77bc-0f82-4c55-aa05-41d12db6b770
1570	2026-10-08 18:50:32.907405+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.17680096626281738	826ac151-a131-48ee-aadc-c6db6f963c9c
1578	2026-10-08 18:55:19.277637+00	POST	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	403	0.034934043884277344	826ac151-a131-48ee-aadc-c6db6f963c9c
1583	2026-10-08 19:00:18.64718+00	POST	/api/auth/login	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	401	0.3235325813293457	\N
1610	2026-10-08 20:15:16.480826+00	GET	/api/journal/de99b413-6a92-48c8-823d-17d0e2ed6b07	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.013844966888427734	\N
1618	2026-10-08 20:15:27.429632+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0054094791412353516	\N
1622	2026-10-08 20:15:32.926528+00	GET	/api/users	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.003220081329345703	\N
1625	2026-10-08 20:15:35.985583+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.013924360275268555	\N
1627	2026-10-08 20:15:38.596326+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.015865087509155273	\N
1629	2026-10-08 20:15:39.478705+00	GET	/api/audit	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.0024063587188720703	\N
1633	2026-10-08 20:16:03.386471+00	POST	/api/auth/login	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.2919001579284668	\N
1635	2026-10-08 20:16:03.49847+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0039441585540771484	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1637	2026-10-08 20:16:06.632439+00	GET	/api/users	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.015560388565063477	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1644	2026-10-08 20:16:35.222276+00	GET	/api/journal/de99b413-6a92-48c8-823d-17d0e2ed6b07	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.01572418212890625	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1646	2026-10-08 20:16:38.176534+00	GET	/api/users	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.00862884521484375	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1651	2026-10-08 20:16:42.845216+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.006928920745849609	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1653	2026-10-08 20:16:57.480468+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.006787300109863281	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1657	2026-10-08 20:17:33.892759+00	GET	/api/sessions/f29b7e3c-59c5-4380-9af4-96cec59b69bd	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.008275985717773438	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1659	2026-10-08 20:17:37.760647+00	PATCH	/api/sessions/f29b7e3c-59c5-4380-9af4-96cec59b69bd	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.04623055458068848	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1848	2026-10-08 20:27:53.69928+00	PATCH	/api/sessions/f29b7e3c-59c5-4380-9af4-96cec59b69bd/documentation	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.017325401306152344	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1850	2026-10-08 20:27:56.312135+00	GET	/api/sessions/f29b7e3c-59c5-4380-9af4-96cec59b69bd	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0018973350524902344	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2058	2026-10-08 20:58:46.306092+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.04944181442260742	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2061	2026-10-08 20:58:49.102657+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.006963491439819336	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2086	2026-10-08 20:59:34.030344+00	GET	/api/sessions/f29b7e3c-59c5-4380-9af4-96cec59b69bd	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0033392906188964844	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2257	2026-10-08 21:20:56.658403+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.02617502212524414	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2259	2026-10-08 21:20:57.957383+00	GET	/api/sessions/8431bdef-789a-4a8e-a151-76ca4ff740db	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0046579837799072266	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2261	2026-10-08 21:21:59.517843+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.03413891792297363	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2263	2026-10-08 21:22:03.1492+00	GET	/api/sessions/1bc6dfe0-cc1d-4446-995b-64c17d34623f	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.028011560440063477	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2313	2026-10-08 21:29:08.702191+00	GET	/api/sessions/77722f17-88b9-4ae3-8438-91cd12eced8f	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.04300951957702637	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2326	2026-10-08 21:29:15.119934+00	GET	/api/sessions/77722f17-88b9-4ae3-8438-91cd12eced8f	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.01745319366455078	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2365	2026-10-08 21:36:52.56596+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.004362344741821289	\N
2367	2026-10-08 21:36:53.776056+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.026593685150146484	\N
2369	2026-10-08 21:37:03.229062+00	GET	/api/sessions/ccb9c8cd-e6a4-4efa-8d34-69095c43e387	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.013348817825317383	\N
2382	2026-10-08 21:38:39.251817+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.007631063461303711	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
543	2026-10-08 13:27:09.693561+00	GET	/api/sessions/8431bdef-789a-4a8e-a151-76ca4ff740db	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0105133056640625	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
548	2026-10-08 13:28:04.876559+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.005297660827636719	\N
550	2026-10-08 13:28:04.906052+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.002926349639892578	\N
551	2026-10-08 13:28:09.02172+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.020128250122070312	\N
560	2026-10-08 13:28:21.30133+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.006583690643310547	\N
562	2026-10-08 13:28:21.329367+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.009809017181396484	\N
564	2026-10-08 14:11:26.133043+00	GET	/api/sessions/8431bdef-789a-4a8e-a151-76ca4ff740db	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.04941129684448242	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
572	2026-10-08 14:11:36.221883+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.040706634521484375	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
573	2026-10-08 14:30:52.538297+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.012750387191772461	\N
574	2026-10-08 14:30:52.559382+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.04963994026184082	\N
587	2026-10-08 14:37:07.817646+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0070343017578125	\N
589	2026-10-08 14:37:07.824865+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0650777816772461	\N
595	2026-10-08 14:37:13.253154+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0030202865600585938	\N
599	2026-10-08 14:40:16.065789+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.004923105239868164	\N
601	2026-10-08 14:40:16.082797+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.13803958892822266	\N
606	2026-10-08 14:40:22.548415+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0039370059967041016	\N
612	2026-10-08 14:40:24.222587+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.017484188079833984	\N
614	2026-10-08 14:40:24.272069+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.002398967742919922	\N
1341	2026-10-08 17:45:23.006917+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.01885056495666504	2b3f77bc-0f82-4c55-aa05-41d12db6b770
1660	2026-10-08 20:17:37.78769+00	POST	/api/sessions/f29b7e3c-59c5-4380-9af4-96cec59b69bd/publish	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.01363515853881836	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1662	2026-10-08 20:17:37.878443+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.004368782043457031	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1870	2026-10-08 20:28:32.230415+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.010654211044311523	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1872	2026-10-08 20:28:32.275184+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.002361774444580078	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1874	2026-10-08 20:28:33.652313+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.02374434471130371	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1876	2026-10-08 20:28:40.921522+00	GET	/api/sessions/f29b7e3c-59c5-4380-9af4-96cec59b69bd	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0016477108001708984	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1878	2026-10-08 20:28:43.461148+00	GET	/api/sessions/f29b7e3c-59c5-4380-9af4-96cec59b69bd	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0015461444854736328	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2072	2026-10-08 20:59:04.158933+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.011778593063354492	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2074	2026-10-08 20:59:06.583483+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.004024505615234375	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2075	2026-10-08 20:59:07.496988+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.008291959762573242	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2080	2026-10-08 20:59:13.900251+00	GET	/api/sessions/f29b7e3c-59c5-4380-9af4-96cec59b69bd	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.001932382583618164	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2082	2026-10-08 20:59:21.33047+00	POST	/api/upload	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	201	0.03468775749206543	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2085	2026-10-08 20:59:32.631964+00	POST	/api/sessions/f29b7e3c-59c5-4380-9af4-96cec59b69bd/publish-studio	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0076444149017333984	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2087	2026-10-08 20:59:34.039595+00	GET	/api/sessions/f29b7e3c-59c5-4380-9af4-96cec59b69bd	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.003354787826538086	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2093	2026-10-08 20:59:44.941557+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.006728649139404297	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2104	2026-10-08 21:00:06.499351+00	PATCH	/api/sessions/f29b7e3c-59c5-4380-9af4-96cec59b69bd/documentation	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.022638320922851562	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2265	2026-10-08 21:22:06.385115+00	GET	/api/sessions/1bc6dfe0-cc1d-4446-995b-64c17d34623f	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.024323463439941406	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2267	2026-10-08 21:22:11.181966+00	PATCH	/api/sessions/1bc6dfe0-cc1d-4446-995b-64c17d34623f/documentation	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.03833198547363281	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2314	2026-10-08 21:29:09.551225+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.033371925354003906	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
547	2026-10-08 13:28:04.874852+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.006377458572387695	\N
549	2026-10-08 13:28:04.890518+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.021631479263305664	\N
552	2026-10-08 13:28:09.022945+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.04125571250915527	\N
556	2026-10-08 13:28:09.095776+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.002788543701171875	\N
558	2026-10-08 13:28:21.27925+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.01088714599609375	\N
561	2026-10-08 13:28:21.309527+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.01330876350402832	\N
565	2026-10-08 14:11:35.280309+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.06418967247009277	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
568	2026-10-08 14:11:35.279968+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.060680389404296875	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
566	2026-10-08 14:11:35.279655+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.06281590461730957	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
569	2026-10-08 14:11:35.354455+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.06887555122375488	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
567	2026-10-08 14:11:35.282847+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.10706710815429688	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
570	2026-10-08 14:11:35.396966+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.18938279151916504	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
571	2026-10-08 14:11:36.206183+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.02466106414794922	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
575	2026-10-08 14:30:52.559752+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.10388779640197754	\N
576	2026-10-08 14:30:52.58006+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.007867813110351562	\N
577	2026-10-08 14:30:52.587411+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.009380578994750977	\N
578	2026-10-08 14:30:52.586487+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.013976573944091797	\N
579	2026-10-08 14:37:00.808441+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.01617264747619629	\N
580	2026-10-08 14:37:00.812123+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.04225778579711914	\N
581	2026-10-08 14:37:00.843054+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.010017633438110352	\N
582	2026-10-08 14:37:00.852492+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.017472028732299805	\N
583	2026-10-08 14:37:00.857111+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.019821643829345703	\N
584	2026-10-08 14:37:00.892042+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0284116268157959	\N
585	2026-10-08 14:37:07.773629+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.014202356338500977	\N
586	2026-10-08 14:37:07.774195+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.03188967704772949	\N
588	2026-10-08 14:37:07.821599+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.019960403442382812	\N
590	2026-10-08 14:37:07.833747+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0038504600524902344	\N
591	2026-10-08 14:37:13.226398+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.022321462631225586	\N
592	2026-10-08 14:37:13.226801+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.016373395919799805	\N
593	2026-10-08 14:37:13.243184+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.004069805145263672	\N
594	2026-10-08 14:37:13.247452+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0155029296875	\N
596	2026-10-08 14:37:13.275595+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.014328956604003906	\N
597	2026-10-08 14:40:15.998872+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.01663374900817871	\N
598	2026-10-08 14:40:15.999385+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.02072286605834961	\N
600	2026-10-08 14:40:16.067447+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.012483835220336914	\N
602	2026-10-08 14:40:16.086913+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0014848709106445312	\N
603	2026-10-08 14:40:22.521569+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.025321006774902344	\N
604	2026-10-08 14:40:22.522861+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.017978191375732422	\N
605	2026-10-08 14:40:22.547392+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.00867319107055664	\N
607	2026-10-08 14:40:22.559502+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.01685166358947754	\N
610	2026-10-08 14:40:24.170115+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.022118806838989258	\N
1343	2026-10-08 17:45:23.008883+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.03398633003234863	2b3f77bc-0f82-4c55-aa05-41d12db6b770
1344	2026-10-08 17:45:23.067893+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.16601014137268066	2b3f77bc-0f82-4c55-aa05-41d12db6b770
1666	2026-10-08 20:17:51.70467+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.060506582260131836	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1664	2026-10-08 20:17:51.70417+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.05406308174133301	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1667	2026-10-08 20:17:51.709226+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.06443929672241211	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1871	2026-10-08 20:28:32.23882+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.03835725784301758	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1879	2026-10-08 20:28:46.274487+00	PATCH	/api/sessions/f29b7e3c-59c5-4380-9af4-96cec59b69bd/documentation	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.048163652420043945	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1883	2026-10-08 20:28:51.018019+00	GET	/api/sessions/f29b7e3c-59c5-4380-9af4-96cec59b69bd	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.005681276321411133	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2076	2026-10-08 20:59:07.496202+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.00703883171081543	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2077	2026-10-08 20:59:11.756855+00	GET	/api/sessions/f29b7e3c-59c5-4380-9af4-96cec59b69bd	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.00468754768371582	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2079	2026-10-08 20:59:13.894534+00	GET	/api/sessions/f29b7e3c-59c5-4380-9af4-96cec59b69bd	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.004916191101074219	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2081	2026-10-08 20:59:21.284869+00	POST	/api/upload	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	201	0.08508920669555664	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2091	2026-10-08 20:59:44.892873+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.022364377975463867	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2105	2026-10-08 21:00:06.549698+00	POST	/api/sessions/f29b7e3c-59c5-4380-9af4-96cec59b69bd/publish-studio	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0420374870300293	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2107	2026-10-08 21:00:10.920621+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.003173351287841797	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2109	2026-10-08 21:00:18.376871+00	GET	/api/sessions/f29b7e3c-59c5-4380-9af4-96cec59b69bd	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0025360584259033203	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2111	2026-10-08 21:00:34.381269+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0038056373596191406	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2113	2026-10-08 21:00:34.956165+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0021975040435791016	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2115	2026-10-08 21:06:22.91242+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.003063678741455078	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2117	2026-10-08 21:06:25.078323+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0040166378021240234	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2119	2026-10-08 21:07:00.118+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.005471706390380859	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2121	2026-10-08 21:07:35.790635+00	GET	/api/users	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0036013126373291016	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2123	2026-10-08 21:07:36.077666+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.004005908966064453	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2125	2026-10-08 21:08:47.958947+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.010210990905761719	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2127	2026-10-08 21:08:49.965321+00	GET	/api/users	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.003033876419067383	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2129	2026-10-08 21:08:54.423379+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0036499500274658203	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2270	2026-10-08 21:22:16.071151+00	POST	/api/sessions/1bc6dfe0-cc1d-4446-995b-64c17d34623f/publish-studio	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0063970088958740234	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2272	2026-10-08 21:22:17.419926+00	GET	/api/sessions/1bc6dfe0-cc1d-4446-995b-64c17d34623f	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.003939151763916016	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2274	2026-10-08 21:22:21.466043+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0037109851837158203	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2276	2026-10-08 21:22:22.706592+00	GET	/api/sessions/8431bdef-789a-4a8e-a151-76ca4ff740db	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0014917850494384766	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2315	2026-10-08 21:29:09.551904+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.044747352600097656	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2319	2026-10-08 21:29:09.611375+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.09887480735778809	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2368	2026-10-08 21:37:03.227787+00	GET	/api/sessions/ccb9c8cd-e6a4-4efa-8d34-69095c43e387	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.024339675903320312	\N
2370	2026-10-08 21:37:06.625054+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.015060186386108398	\N
2372	2026-10-08 21:38:18.612129+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0279996395111084	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2374	2026-10-08 21:38:19.521759+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.007096290588378906	\N
2376	2026-10-08 21:38:20.283773+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0335536003112793	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
608	2026-10-08 14:40:22.588875+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.019669771194458008	\N
609	2026-10-08 14:40:24.168562+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.027556419372558594	\N
1346	2026-10-08 17:45:23.107129+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.12953948974609375	2b3f77bc-0f82-4c55-aa05-41d12db6b770
1663	2026-10-08 20:17:51.702037+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.055756330490112305	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1665	2026-10-08 20:17:51.704375+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.06948304176330566	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1668	2026-10-08 20:17:51.769398+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.14070701599121094	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1887	2026-10-08 20:30:12.726334+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.022790193557739258	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1888	2026-10-08 20:30:12.727313+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.013463973999023438	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1889	2026-10-08 20:30:16.43678+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.005293607711791992	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1891	2026-10-08 20:30:21.882479+00	GET	/api/sessions/f29b7e3c-59c5-4380-9af4-96cec59b69bd	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0076084136962890625	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1894	2026-10-08 20:30:23.34892+00	POST	/api/sessions/f29b7e3c-59c5-4380-9af4-96cec59b69bd/publish-studio	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.010715246200561523	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1895	2026-10-08 20:30:24.465623+00	GET	/api/sessions/f29b7e3c-59c5-4380-9af4-96cec59b69bd	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.00501561164855957	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1897	2026-10-08 20:30:26.375902+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.005914926528930664	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1898	2026-10-08 20:30:26.384287+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.002282857894897461	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1899	2026-10-08 20:30:30.72746+00	GET	/api/sessions/8431bdef-789a-4a8e-a151-76ca4ff740db	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.016918420791625977	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1900	2026-10-08 20:30:30.740755+00	GET	/api/sessions/8431bdef-789a-4a8e-a151-76ca4ff740db	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.002229928970336914	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1901	2026-10-08 20:30:35.285969+00	GET	/api/sessions/8431bdef-789a-4a8e-a151-76ca4ff740db	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.027907609939575195	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1905	2026-10-08 20:30:44.033813+00	GET	/api/sessions/f29b7e3c-59c5-4380-9af4-96cec59b69bd	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.014806509017944336	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1906	2026-10-08 20:30:44.046177+00	GET	/api/sessions/f29b7e3c-59c5-4380-9af4-96cec59b69bd	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.005457162857055664	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1907	2026-10-08 20:30:45.945371+00	GET	/api/sessions/f29b7e3c-59c5-4380-9af4-96cec59b69bd	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.025226593017578125	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1908	2026-10-08 20:30:45.952031+00	GET	/api/sessions/f29b7e3c-59c5-4380-9af4-96cec59b69bd	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0016934871673583984	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1911	2026-10-08 20:33:47.325214+00	PATCH	/api/sessions/f29b7e3c-59c5-4380-9af4-96cec59b69bd/documentation	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.05317831039428711	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1915	2026-10-08 20:37:04.365294+00	GET	/api/auth/me	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	401	0.0005593299865722656	\N
1916	2026-10-08 20:37:06.273273+00	GET	/api/auth/me	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	401	0.0018799304962158203	\N
2094	2026-10-08 20:59:44.938054+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.04102182388305664	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2097	2026-10-08 20:59:45.801821+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0040493011474609375	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2099	2026-10-08 20:59:48.38219+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.017982006072998047	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2101	2026-10-08 20:59:54.572329+00	GET	/api/sessions/f29b7e3c-59c5-4380-9af4-96cec59b69bd	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.003345012664794922	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2103	2026-10-08 21:00:05.116168+00	POST	/api/upload	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	201	0.14781522750854492	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2280	2026-10-08 21:25:03.306279+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0618133544921875	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2316	2026-10-08 21:29:09.560204+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.05395197868347168	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2318	2026-10-08 21:29:09.606332+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.1086130142211914	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2322	2026-10-08 21:29:09.680965+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0020165443420410156	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2327	2026-10-08 21:29:15.144257+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.08147835731506348	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2329	2026-10-08 21:29:15.163114+00	GET	/api/sessions/77722f17-88b9-4ae3-8438-91cd12eced8f	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.031681060791015625	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2337	2026-10-08 21:29:17.324731+00	GET	/api/audit	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.008666515350341797	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2339	2026-10-08 21:29:17.451042+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.031187772750854492	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2341	2026-10-08 21:29:18.433342+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0067441463470458984	\N
2342	2026-10-08 21:33:20.563074+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.8525841236114502	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
611	2026-10-08 14:40:24.208569+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.009524345397949219	\N
613	2026-10-08 14:40:24.265196+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.1152186393737793	\N
615	2026-10-08 15:47:31.677379+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.017674684524536133	\N
616	2026-10-08 15:47:31.67677+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.04508566856384277	\N
617	2026-10-08 15:47:31.697314+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.003804922103881836	\N
618	2026-10-08 15:47:31.697716+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0043792724609375	\N
619	2026-10-08 15:47:31.695776+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.018343448638916016	\N
620	2026-10-08 15:47:31.724092+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.012900829315185547	\N
621	2026-10-08 15:47:43.903847+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.021762371063232422	\N
622	2026-10-08 15:47:43.905518+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.010801553726196289	\N
623	2026-10-08 15:47:43.91406+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.00287628173828125	\N
624	2026-10-08 15:47:43.914938+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0019774436950683594	\N
625	2026-10-08 15:47:43.930295+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.03881406784057617	\N
626	2026-10-08 15:47:43.940932+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0042896270751953125	\N
627	2026-10-08 15:47:45.791302+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.03351259231567383	\N
628	2026-10-08 15:47:45.790681+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.018035173416137695	\N
629	2026-10-08 15:47:45.815066+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.004736423492431641	\N
630	2026-10-08 15:47:45.815601+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.010787010192871094	\N
631	2026-10-08 15:47:45.828092+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.012111186981201172	\N
632	2026-10-08 15:47:45.849335+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0023698806762695312	\N
633	2026-10-08 15:47:47.61845+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.022053956985473633	\N
634	2026-10-08 15:47:47.619289+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.011248588562011719	\N
635	2026-10-08 15:47:47.636233+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0036089420318603516	\N
636	2026-10-08 15:47:47.635867+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.005351543426513672	\N
637	2026-10-08 15:47:47.649053+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.03872227668762207	\N
638	2026-10-08 15:47:47.653698+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0020380020141601562	\N
639	2026-10-08 16:11:07.624852+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.03523397445678711	\N
640	2026-10-08 16:11:07.625402+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.00927591323852539	\N
641	2026-10-08 16:11:07.647286+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.004818916320800781	\N
642	2026-10-08 16:11:07.650184+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.006661891937255859	\N
643	2026-10-08 16:11:07.65653+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.013464212417602539	\N
644	2026-10-08 16:11:07.666313+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0024802684783935547	\N
645	2026-10-08 16:11:14.752708+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.01794123649597168	\N
646	2026-10-08 16:11:14.753292+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.01067972183227539	\N
647	2026-10-08 16:11:14.777363+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.015773534774780273	\N
648	2026-10-08 16:11:14.781717+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.018240928649902344	\N
649	2026-10-08 16:11:14.800285+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.05543708801269531	\N
650	2026-10-08 16:11:14.803803+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0012977123260498047	\N
651	2026-10-08 16:11:22.401796+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.012621164321899414	\N
660	2026-10-08 16:18:04.499789+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0037186145782470703	\N
662	2026-10-08 16:18:04.514354+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0014460086822509766	\N
664	2026-10-08 16:19:01.414226+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.01012563705444336	\N
672	2026-10-08 16:19:01.871865+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.002691507339477539	\N
676	2026-10-08 16:19:04.071076+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.01740574836730957	\N
683	2026-10-08 16:19:05.207889+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.007641315460205078	\N
685	2026-10-08 16:19:05.222712+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.03205585479736328	\N
689	2026-10-08 16:19:06.136161+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.006299734115600586	\N
694	2026-10-08 16:19:07.098974+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.04994082450866699	\N
698	2026-10-08 16:19:07.164157+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.002022981643676758	\N
699	2026-10-08 16:19:07.585873+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0035881996154785156	\N
708	2026-10-08 16:19:09.340915+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.007969379425048828	\N
710	2026-10-08 16:19:09.355388+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0013756752014160156	\N
711	2026-10-08 16:19:09.561023+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0027866363525390625	\N
713	2026-10-08 16:19:09.563634+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.004693746566772461	\N
718	2026-10-08 16:19:12.205117+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.006805419921875	\N
726	2026-10-08 16:19:16.835946+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.013213634490966797	\N
729	2026-10-08 16:19:17.763255+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.02250075340270996	\N
737	2026-10-08 16:19:24.740903+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0039827823638916016	\N
739	2026-10-08 16:19:24.764764+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.04830050468444824	\N
744	2026-10-08 16:19:59.668835+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0034952163696289062	\N
746	2026-10-08 16:19:59.69233+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0020952224731445312	\N
1347	2026-10-08 17:45:26.068063+00	GET	/api/auth/me	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.023752450942993164	2b3f77bc-0f82-4c55-aa05-41d12db6b770
1356	2026-10-08 17:45:27.799588+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.03154587745666504	2b3f77bc-0f82-4c55-aa05-41d12db6b770
1364	2026-10-08 17:47:31.4053+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.01532125473022461	2b3f77bc-0f82-4c55-aa05-41d12db6b770
1366	2026-10-08 17:47:31.417994+00	GET	/api/auth/me	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0015406608581542969	2b3f77bc-0f82-4c55-aa05-41d12db6b770
1374	2026-10-08 17:47:58.497063+00	GET	/api/auth/me	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0056874752044677734	2b3f77bc-0f82-4c55-aa05-41d12db6b770
1381	2026-10-08 17:48:05.529509+00	PATCH	/api/journal/2244bf82-1f9a-4004-aecf-9357def21b44	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.012884855270385742	2b3f77bc-0f82-4c55-aa05-41d12db6b770
1390	2026-10-08 17:48:16.510474+00	GET	/api/auth/me	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0021636486053466797	2b3f77bc-0f82-4c55-aa05-41d12db6b770
1392	2026-10-08 17:48:36.357733+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.029828310012817383	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1394	2026-10-08 17:48:39.976206+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.048395633697509766	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1396	2026-10-08 17:48:40.960206+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.013245105743408203	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1411	2026-10-08 18:00:24.510858+00	PATCH	/api/journal/59f30e0a-25aa-4d37-82cb-e79b3f53a0e8	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.02964615821838379	2b3f77bc-0f82-4c55-aa05-41d12db6b770
1414	2026-10-08 18:00:26.646109+00	PATCH	/api/journal/59f30e0a-25aa-4d37-82cb-e79b3f53a0e8	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.00933694839477539	2b3f77bc-0f82-4c55-aa05-41d12db6b770
1669	2026-10-08 20:17:59.999536+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.07815146446228027	\N
1671	2026-10-08 20:18:01.231968+00	GET	/api/auth/me	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.004826068878173828	\N
2689	2026-10-09 11:51:59.811926+00	POST	/api/sessions	127.0.0.1	python-httpx/0.28.1	201	0.017594337463378906	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
652	2026-10-08 16:11:22.402849+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.013649702072143555	\N
659	2026-10-08 16:18:04.497145+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0027365684509277344	\N
661	2026-10-08 16:18:04.510567+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.03658151626586914	\N
665	2026-10-08 16:19:01.431817+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0060253143310546875	\N
669	2026-10-08 16:19:01.855508+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.020241737365722656	\N
674	2026-10-08 16:19:01.891336+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0021941661834716797	\N
675	2026-10-08 16:19:04.070412+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0416719913482666	\N
684	2026-10-08 16:19:05.210619+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.013118267059326172	\N
686	2026-10-08 16:19:05.226559+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0013430118560791016	\N
687	2026-10-08 16:19:06.087423+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0443880558013916	\N
696	2026-10-08 16:19:07.141429+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.01969122886657715	\N
700	2026-10-08 16:19:07.586236+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0055387020111083984	\N
707	2026-10-08 16:19:09.336999+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.005853891372680664	\N
709	2026-10-08 16:19:09.351853+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.04599142074584961	\N
715	2026-10-08 16:19:09.576806+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0031499862670898438	\N
720	2026-10-08 16:19:12.22954+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.004138469696044922	\N
722	2026-10-08 16:19:12.244292+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.003444671630859375	\N
723	2026-10-08 16:19:16.807761+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.010654449462890625	\N
731	2026-10-08 16:19:17.791344+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.003797292709350586	\N
736	2026-10-08 16:19:24.726928+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.03154110908508301	\N
743	2026-10-08 16:19:59.666683+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.019588232040405273	\N
1349	2026-10-08 17:45:26.070001+00	GET	/api/auth/me	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.028119564056396484	2b3f77bc-0f82-4c55-aa05-41d12db6b770
1351	2026-10-08 17:45:26.094487+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.062253713607788086	2b3f77bc-0f82-4c55-aa05-41d12db6b770
1670	2026-10-08 20:18:00.003303+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.05060172080993652	\N
1673	2026-10-08 20:18:01.232803+00	GET	/api/auth/me	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.003159761428833008	\N
1680	2026-10-08 20:18:04.499705+00	GET	/api/auth/me	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.01084589958190918	\N
1890	2026-10-08 20:30:16.443459+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0024843215942382812	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1892	2026-10-08 20:30:21.888631+00	GET	/api/sessions/f29b7e3c-59c5-4380-9af4-96cec59b69bd	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0015540122985839844	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1896	2026-10-08 20:30:24.464693+00	GET	/api/sessions/f29b7e3c-59c5-4380-9af4-96cec59b69bd	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.007077693939208984	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1903	2026-10-08 20:30:35.307853+00	GET	/api/sessions/8431bdef-789a-4a8e-a151-76ca4ff740db	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0037555694580078125	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1910	2026-10-08 20:31:59.375339+00	PATCH	/api/sessions/f29b7e3c-59c5-4380-9af4-96cec59b69bd/documentation	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.05246782302856445	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1912	2026-10-08 20:37:04.341517+00	GET	/api/auth/me	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	401	0.007352352142333984	\N
1917	2026-10-08 20:37:06.284594+00	GET	/api/auth/me	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	401	0.0006158351898193359	\N
2120	2026-10-08 21:07:35.776788+00	GET	/api/users	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.036287784576416016	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2122	2026-10-08 21:07:36.070359+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.012833356857299805	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2124	2026-10-08 21:08:47.079843+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.03219175338745117	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2126	2026-10-08 21:08:49.953349+00	GET	/api/users	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.010028600692749023	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2128	2026-10-08 21:08:54.411705+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.01495361328125	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2710	2026-10-09 11:54:10.628721+00	POST	/api/auth/login	127.0.0.1	python-httpx/0.28.1	200	0.25646233558654785	\N
653	2026-10-08 16:11:22.421992+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0036249160766601562	\N
658	2026-10-08 16:18:04.484471+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.013175249099731445	\N
666	2026-10-08 16:19:01.431262+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.004360198974609375	\N
668	2026-10-08 16:19:01.448803+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.002173900604248047	\N
670	2026-10-08 16:19:01.853787+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.010202407836914062	\N
671	2026-10-08 16:19:01.87127+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0041120052337646484	\N
673	2026-10-08 16:19:01.886285+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.04326653480529785	\N
1348	2026-10-08 17:45:26.069818+00	GET	/api/auth/me	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.048061370849609375	2b3f77bc-0f82-4c55-aa05-41d12db6b770
1371	2026-10-08 17:47:53.776413+00	GET	/api/journal/2244bf82-1f9a-4004-aecf-9357def21b44	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.010970830917358398	2b3f77bc-0f82-4c55-aa05-41d12db6b770
1373	2026-10-08 17:47:56.064353+00	PATCH	/api/journal/2244bf82-1f9a-4004-aecf-9357def21b44	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.031210660934448242	2b3f77bc-0f82-4c55-aa05-41d12db6b770
1375	2026-10-08 17:47:58.499249+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.008107185363769531	2b3f77bc-0f82-4c55-aa05-41d12db6b770
1377	2026-10-08 17:47:58.508822+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.005192995071411133	2b3f77bc-0f82-4c55-aa05-41d12db6b770
1379	2026-10-08 17:47:59.42206+00	GET	/api/journal/2244bf82-1f9a-4004-aecf-9357def21b44	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.009358882904052734	2b3f77bc-0f82-4c55-aa05-41d12db6b770
1387	2026-10-08 17:48:15.533339+00	POST	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	201	0.025300979614257812	2b3f77bc-0f82-4c55-aa05-41d12db6b770
1388	2026-10-08 17:48:16.499514+00	GET	/api/auth/me	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.003839254379272461	2b3f77bc-0f82-4c55-aa05-41d12db6b770
1393	2026-10-08 17:48:36.358992+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0327153205871582	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1417	2026-10-08 18:00:37.41066+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.03398704528808594	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1672	2026-10-08 20:18:01.231645+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.004293918609619141	\N
1678	2026-10-08 20:18:04.498666+00	GET	/api/auth/me	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.02152085304260254	\N
1708	2026-10-08 20:20:04.095793+00	GET	/api/sessions/f29b7e3c-59c5-4380-9af4-96cec59b69bd	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.00408482551574707	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1710	2026-10-08 20:20:11.98134+00	PATCH	/api/sessions/f29b7e3c-59c5-4380-9af4-96cec59b69bd	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.023859024047851562	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1712	2026-10-08 20:20:12.060497+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0024271011352539062	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1713	2026-10-08 20:20:17.572409+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.03702092170715332	2b3f77bc-0f82-4c55-aa05-41d12db6b770
1893	2026-10-08 20:30:23.324883+00	PATCH	/api/sessions/f29b7e3c-59c5-4380-9af4-96cec59b69bd/documentation	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.012009143829345703	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2130	2026-10-08 21:09:08.844858+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.018518924713134766	2b3f77bc-0f82-4c55-aa05-41d12db6b770
2279	2026-10-08 21:25:03.30651+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.05510997772216797	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2317	2026-10-08 21:29:09.569023+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.09802365303039551	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2321	2026-10-08 21:29:09.636326+00	GET	/api/audit	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0045049190521240234	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2323	2026-10-08 21:29:09.70034+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.015476226806640625	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2325	2026-10-08 21:29:11.162964+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.02803325653076172	\N
2330	2026-10-08 21:29:16.836608+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.03621029853820801	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2335	2026-10-08 21:29:16.952846+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.008157491683959961	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2343	2026-10-08 21:33:20.56607+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.02311563491821289	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2347	2026-10-08 21:33:20.76368+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.04497385025024414	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2349	2026-10-08 21:33:39.162858+00	GET	/api/sessions/f29b7e3c-59c5-4380-9af4-96cec59b69bd	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.012075662612915039	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2351	2026-10-08 21:33:47.979305+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0035092830657958984	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2353	2026-10-08 21:34:01.877575+00	GET	/api/sessions/1bc6dfe0-cc1d-4446-995b-64c17d34623f	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0041751861572265625	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2355	2026-10-08 21:34:10.858871+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.009748458862304688	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2371	2026-10-08 21:37:06.632956+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0025680065155029297	\N
654	2026-10-08 16:11:22.423136+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0024423599243164062	\N
655	2026-10-08 16:11:22.433132+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.03318214416503906	\N
656	2026-10-08 16:11:22.451128+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.003475189208984375	\N
657	2026-10-08 16:18:04.483957+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.029428720474243164	\N
663	2026-10-08 16:19:01.414934+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.035576820373535156	\N
667	2026-10-08 16:19:01.432371+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.011837244033813477	\N
677	2026-10-08 16:19:04.089991+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.003700733184814453	\N
678	2026-10-08 16:19:04.091145+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0028581619262695312	\N
679	2026-10-08 16:19:04.097326+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.022698640823364258	\N
680	2026-10-08 16:19:04.104485+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0016443729400634766	\N
681	2026-10-08 16:19:05.191802+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.006112098693847656	\N
682	2026-10-08 16:19:05.192941+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.003587007522583008	\N
688	2026-10-08 16:19:06.088635+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.06504416465759277	\N
690	2026-10-08 16:19:06.144458+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.007665157318115234	\N
691	2026-10-08 16:19:06.156164+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.04724526405334473	\N
692	2026-10-08 16:19:06.174193+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.002622842788696289	\N
693	2026-10-08 16:19:07.098047+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.020592927932739258	\N
695	2026-10-08 16:19:07.139993+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.017754077911376953	\N
697	2026-10-08 16:19:07.158496+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.07875370979309082	\N
701	2026-10-08 16:19:07.601728+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0029990673065185547	\N
702	2026-10-08 16:19:07.601075+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0057756900787353516	\N
703	2026-10-08 16:19:07.60969+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.003209352493286133	\N
704	2026-10-08 16:19:07.616938+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0019080638885498047	\N
705	2026-10-08 16:19:09.319818+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.020417451858520508	\N
706	2026-10-08 16:19:09.320414+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.040055274963378906	\N
712	2026-10-08 16:19:09.563352+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0034880638122558594	\N
714	2026-10-08 16:19:09.575116+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0034644603729248047	\N
716	2026-10-08 16:19:09.605488+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.03981494903564453	\N
717	2026-10-08 16:19:12.206108+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.023855209350585938	\N
719	2026-10-08 16:19:12.228351+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.004728078842163086	\N
721	2026-10-08 16:19:12.230883+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.03747296333312988	\N
724	2026-10-08 16:19:16.808861+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.03166818618774414	\N
725	2026-10-08 16:19:16.833296+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.011865377426147461	\N
727	2026-10-08 16:19:16.854575+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.059320926666259766	\N
728	2026-10-08 16:19:16.858591+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0013473033905029297	\N
730	2026-10-08 16:19:17.761722+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0471501350402832	\N
732	2026-10-08 16:19:17.792288+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.002708911895751953	\N
733	2026-10-08 16:19:17.803086+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.02193903923034668	\N
1350	2026-10-08 17:45:26.071464+00	GET	/api/auth/me	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.029683351516723633	2b3f77bc-0f82-4c55-aa05-41d12db6b770
1352	2026-10-08 17:45:26.100031+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.067901611328125	2b3f77bc-0f82-4c55-aa05-41d12db6b770
1353	2026-10-08 17:45:27.778732+00	GET	/api/auth/me	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.011083841323852539	2b3f77bc-0f82-4c55-aa05-41d12db6b770
1355	2026-10-08 17:45:27.792332+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.02426457405090332	2b3f77bc-0f82-4c55-aa05-41d12db6b770
1357	2026-10-08 17:45:55.866822+00	POST	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	201	0.08402490615844727	2b3f77bc-0f82-4c55-aa05-41d12db6b770
1360	2026-10-08 17:47:29.136649+00	PATCH	/api/journal/2244bf82-1f9a-4004-aecf-9357def21b44	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.01384115219116211	2b3f77bc-0f82-4c55-aa05-41d12db6b770
1367	2026-10-08 17:47:52.068769+00	GET	/api/auth/me	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.02472233772277832	2b3f77bc-0f82-4c55-aa05-41d12db6b770
1368	2026-10-08 17:47:52.081608+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.02733588218688965	2b3f77bc-0f82-4c55-aa05-41d12db6b770
1376	2026-10-08 17:47:58.50538+00	GET	/api/auth/me	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0032339096069335938	2b3f77bc-0f82-4c55-aa05-41d12db6b770
1382	2026-10-08 17:48:06.794732+00	PATCH	/api/journal/2244bf82-1f9a-4004-aecf-9357def21b44	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.010896444320678711	2b3f77bc-0f82-4c55-aa05-41d12db6b770
1384	2026-10-08 17:48:08.581023+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.04520726203918457	2b3f77bc-0f82-4c55-aa05-41d12db6b770
1385	2026-10-08 17:48:08.588701+00	GET	/api/auth/me	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0040435791015625	2b3f77bc-0f82-4c55-aa05-41d12db6b770
1389	2026-10-08 17:48:16.5009+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.011452198028564453	2b3f77bc-0f82-4c55-aa05-41d12db6b770
1398	2026-10-08 17:48:53.403397+00	POST	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	201	0.016731977462768555	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1400	2026-10-08 17:48:54.421948+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0033936500549316406	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1402	2026-10-08 17:48:57.5391+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0070590972900390625	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1404	2026-10-08 17:49:02.55214+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.008792638778686523	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1406	2026-10-08 18:00:10.175614+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.005042314529418945	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1408	2026-10-08 18:00:13.289958+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.036051273345947266	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1425	2026-10-08 18:00:52.755384+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.022490501403808594	2b3f77bc-0f82-4c55-aa05-41d12db6b770
1427	2026-10-08 18:00:52.772021+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.056864023208618164	2b3f77bc-0f82-4c55-aa05-41d12db6b770
1428	2026-10-08 18:01:47.281588+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.06223917007446289	\N
1434	2026-10-08 18:02:01.148038+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.022303342819213867	\N
1439	2026-10-08 18:02:01.212867+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0038433074951171875	\N
1440	2026-10-08 18:05:12.046529+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.01746058464050293	\N
1448	2026-10-08 18:05:38.377018+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.008372306823730469	\N
1450	2026-10-08 18:05:38.39396+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.07979083061218262	\N
1674	2026-10-08 20:18:01.23337+00	GET	/api/auth/me	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.0035469532012939453	\N
1677	2026-10-08 20:18:04.500337+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.011549711227416992	\N
1705	2026-10-08 20:19:48.839404+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.020145654678344727	2b3f77bc-0f82-4c55-aa05-41d12db6b770
1716	2026-10-08 20:20:17.592622+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.007620573043823242	2b3f77bc-0f82-4c55-aa05-41d12db6b770
1718	2026-10-08 20:20:17.63479+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0018305778503417969	2b3f77bc-0f82-4c55-aa05-41d12db6b770
1902	2026-10-08 20:30:35.287113+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.020479202270507812	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1913	2026-10-08 20:37:04.354932+00	GET	/api/auth/me	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	401	0.0008141994476318359	\N
1918	2026-10-08 20:37:06.288007+00	GET	/api/auth/me	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	401	0.0005695819854736328	\N
2131	2026-10-08 21:09:08.862583+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0042536258697509766	2b3f77bc-0f82-4c55-aa05-41d12db6b770
2133	2026-10-08 21:09:11.901661+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.032569169998168945	2b3f77bc-0f82-4c55-aa05-41d12db6b770
2134	2026-10-08 21:09:13.147843+00	GET	/api/sessions/6181c511-10b9-4bff-b8f4-164d7db901ba	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0025272369384765625	2b3f77bc-0f82-4c55-aa05-41d12db6b770
2136	2026-10-08 21:09:14.226046+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0016875267028808594	2b3f77bc-0f82-4c55-aa05-41d12db6b770
2138	2026-10-08 21:10:12.678263+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.11835646629333496	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
734	2026-10-08 16:19:17.822233+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.005558490753173828	\N
735	2026-10-08 16:19:24.726392+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.011499404907226562	\N
742	2026-10-08 16:19:59.629717+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.014909505844116211	\N
1354	2026-10-08 17:45:27.786928+00	GET	/api/auth/me	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.011665105819702148	2b3f77bc-0f82-4c55-aa05-41d12db6b770
1358	2026-10-08 17:46:43.370473+00	PATCH	/api/journal/2244bf82-1f9a-4004-aecf-9357def21b44	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.06933093070983887	2b3f77bc-0f82-4c55-aa05-41d12db6b770
1361	2026-10-08 17:47:29.800454+00	PATCH	/api/journal/2244bf82-1f9a-4004-aecf-9357def21b44	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.010356426239013672	2b3f77bc-0f82-4c55-aa05-41d12db6b770
1386	2026-10-08 17:48:08.59448+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.00847625732421875	2b3f77bc-0f82-4c55-aa05-41d12db6b770
1395	2026-10-08 17:48:40.309878+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.013701677322387695	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1397	2026-10-08 17:48:41.258641+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.007100820541381836	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1410	2026-10-08 18:00:23.880797+00	POST	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	201	0.04521512985229492	2b3f77bc-0f82-4c55-aa05-41d12db6b770
1413	2026-10-08 18:00:26.359417+00	PATCH	/api/journal/59f30e0a-25aa-4d37-82cb-e79b3f53a0e8	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.009911298751831055	2b3f77bc-0f82-4c55-aa05-41d12db6b770
1416	2026-10-08 18:00:27.996443+00	PATCH	/api/journal/59f30e0a-25aa-4d37-82cb-e79b3f53a0e8	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.009853363037109375	2b3f77bc-0f82-4c55-aa05-41d12db6b770
1418	2026-10-08 18:00:37.427088+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.006531953811645508	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1675	2026-10-08 20:18:01.233769+00	GET	/api/auth/me	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.0040743350982666016	\N
1686	2026-10-08 20:18:07.477821+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.08907818794250488	\N
1904	2026-10-08 20:30:35.314525+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.013498544692993164	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1909	2026-10-08 20:31:01.02405+00	PATCH	/api/sessions/f29b7e3c-59c5-4380-9af4-96cec59b69bd/documentation	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.05198836326599121	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1914	2026-10-08 20:37:04.360736+00	GET	/api/auth/me	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	401	0.00064849853515625	\N
1919	2026-10-08 20:37:06.298102+00	GET	/api/auth/me	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	401	0.0013430118560791016	\N
2132	2026-10-08 21:09:11.897626+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.02430558204650879	2b3f77bc-0f82-4c55-aa05-41d12db6b770
2147	2026-10-08 21:11:36.150821+00	GET	/api/users	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.011968612670898438	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2148	2026-10-08 21:11:37.717221+00	GET	/api/audit	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.022137880325317383	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2278	2026-10-08 21:25:03.307356+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.031340837478637695	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2320	2026-10-08 21:29:09.620199+00	GET	/api/audit	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.04395627975463867	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2373	2026-10-08 21:38:18.632609+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.006069660186767578	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2375	2026-10-08 21:38:19.532538+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0043604373931884766	\N
2377	2026-10-08 21:38:20.296201+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.002444744110107422	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2379	2026-10-08 21:38:38.125666+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.002505064010620117	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2381	2026-10-08 21:38:39.134366+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0029773712158203125	\N
2383	2026-10-08 21:38:39.253742+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.008202314376831055	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2385	2026-10-08 21:39:25.536641+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.003923654556274414	\N
2387	2026-10-08 21:39:34.272392+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.003368854522705078	\N
2388	2026-10-08 21:39:35.062884+00	GET	/api/journal/public	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.04668545722961426	\N
2397	2026-10-08 21:39:40.224617+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.01636648178100586	\N
2398	2026-10-08 21:39:41.24961+00	GET	/api/sessions/e630385a-5974-4a0f-862e-2e09c01440a6	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0041065216064453125	\N
2399	2026-10-08 21:39:41.250319+00	GET	/api/sessions/e630385a-5974-4a0f-862e-2e09c01440a6	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0069561004638671875	\N
2400	2026-10-08 21:41:31.862744+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.040107011795043945	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2402	2026-10-08 21:41:32.655343+00	GET	/api/journal/public	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.01793837547302246	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2407	2026-10-08 22:11:40.874282+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.09647774696350098	\N
2410	2026-10-08 22:28:59.703887+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	401	0.03084254264831543	\N
738	2026-10-08 16:19:24.745893+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.005231380462646484	\N
740	2026-10-08 16:19:24.772097+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0031316280364990234	\N
741	2026-10-08 16:19:59.628833+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.026038408279418945	\N
745	2026-10-08 16:19:59.681786+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.01540827751159668	\N
747	2026-10-08 16:22:33.64878+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.03748345375061035	\N
748	2026-10-08 16:22:33.650384+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.02385878562927246	\N
749	2026-10-08 16:22:33.674377+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.005857229232788086	\N
750	2026-10-08 16:22:33.677881+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.003740072250366211	\N
751	2026-10-08 16:22:33.698194+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.06998276710510254	\N
752	2026-10-08 16:22:33.704546+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0021276473999023438	\N
753	2026-10-08 16:22:37.768711+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.009694337844848633	\N
754	2026-10-08 16:22:37.769279+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.026391029357910156	\N
755	2026-10-08 16:22:37.803043+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.016496896743774414	\N
756	2026-10-08 16:22:37.800766+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.012754201889038086	\N
757	2026-10-08 16:22:37.809851+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.014936208724975586	\N
758	2026-10-08 16:22:37.818399+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.002105236053466797	\N
759	2026-10-08 16:22:40.252414+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.03988814353942871	\N
760	2026-10-08 16:22:40.251642+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.014328479766845703	\N
761	2026-10-08 16:22:40.28073+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.01297307014465332	\N
762	2026-10-08 16:22:40.286007+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.015088319778442383	\N
763	2026-10-08 16:22:40.301842+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0622553825378418	\N
764	2026-10-08 16:22:40.306284+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0017294883728027344	\N
766	2026-10-08 16:22:41.181507+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.019626617431640625	\N
765	2026-10-08 16:22:41.180666+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.023113250732421875	\N
767	2026-10-08 16:22:41.205189+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.004370689392089844	\N
768	2026-10-08 16:22:41.20721+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.002680063247680664	\N
769	2026-10-08 16:22:41.218133+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.014399528503417969	\N
770	2026-10-08 16:22:41.227213+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0024421215057373047	\N
771	2026-10-08 16:22:43.197678+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.025499582290649414	\N
772	2026-10-08 16:22:43.198369+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.015261173248291016	\N
773	2026-10-08 16:22:43.218607+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.008733272552490234	\N
774	2026-10-08 16:22:43.223265+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.012533187866210938	\N
775	2026-10-08 16:22:43.236299+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.05069780349731445	\N
776	2026-10-08 16:22:43.241346+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0014591217041015625	\N
777	2026-10-08 16:22:44.188712+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.007573127746582031	\N
778	2026-10-08 16:22:44.189328+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0205080509185791	\N
779	2026-10-08 16:22:44.207115+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.003197908401489258	\N
780	2026-10-08 16:22:44.207888+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0038895606994628906	\N
781	2026-10-08 16:22:44.220574+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.010045766830444336	\N
782	2026-10-08 16:22:44.2325+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0026090145111083984	\N
783	2026-10-08 16:25:02.026707+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.1707148551940918	\N
785	2026-10-08 16:25:02.072513+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.08405041694641113	\N
786	2026-10-08 16:25:02.080812+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.005767345428466797	\N
787	2026-10-08 16:25:02.097078+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.001992464065551758	\N
790	2026-10-08 16:25:02.128691+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0059740543365478516	\N
795	2026-10-08 16:25:03.258832+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.027833938598632812	\N
797	2026-10-08 16:25:03.270344+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0019948482513427734	\N
799	2026-10-08 16:25:04.187851+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.021126508712768555	\N
803	2026-10-08 16:25:04.22696+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.003667116165161133	\N
804	2026-10-08 16:25:05.251401+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.014355659484863281	\N
813	2026-10-08 16:25:06.281703+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0036084651947021484	\N
815	2026-10-08 16:25:06.297385+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0036535263061523438	\N
816	2026-10-08 16:25:07.408923+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.03908061981201172	\N
821	2026-10-08 16:25:07.434614+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0012774467468261719	\N
822	2026-10-08 16:25:14.291659+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.009223222732543945	\N
830	2026-10-08 16:25:15.237139+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.005977630615234375	\N
835	2026-10-08 16:25:18.387401+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.02868938446044922	\N
843	2026-10-08 16:25:25.626181+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.018801450729370117	\N
846	2026-10-08 16:29:24.470951+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.015305519104003906	\N
855	2026-10-08 16:29:32.702039+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.019469261169433594	\N
857	2026-10-08 16:29:32.725081+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0030319690704345703	\N
858	2026-10-08 16:39:26.692994+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.048032522201538086	\N
870	2026-10-08 16:39:28.234256+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.006131887435913086	\N
872	2026-10-08 16:39:28.261431+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.002663850784301758	\N
873	2026-10-08 16:39:29.42204+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.028470277786254883	\N
883	2026-10-08 16:39:30.471213+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0037527084350585938	\N
884	2026-10-08 16:39:30.501025+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.025238037109375	\N
885	2026-10-08 16:39:31.579292+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0277097225189209	\N
894	2026-10-08 16:39:39.310321+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.008602380752563477	\N
897	2026-10-08 16:39:47.460548+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.013576745986938477	\N
902	2026-10-08 16:39:47.51457+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.004061698913574219	\N
903	2026-10-08 16:39:47.713457+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.002586841583251953	\N
908	2026-10-08 16:39:47.733114+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0012288093566894531	\N
909	2026-10-08 16:46:05.75458+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.028280019760131836	\N
784	2026-10-08 16:25:02.036371+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.08044600486755371	\N
788	2026-10-08 16:25:02.115885+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.003362417221069336	\N
789	2026-10-08 16:25:02.116148+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.006735563278198242	\N
791	2026-10-08 16:25:02.130681+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.005587339401245117	\N
793	2026-10-08 16:25:03.223537+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.012245893478393555	\N
801	2026-10-08 16:25:04.206655+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.004816293716430664	\N
806	2026-10-08 16:25:05.26815+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.00456690788269043	\N
808	2026-10-08 16:25:05.294527+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.05536031723022461	\N
812	2026-10-08 16:25:06.281244+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.002939462661743164	\N
817	2026-10-08 16:25:07.409446+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.03031158447265625	\N
824	2026-10-08 16:25:14.318172+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.005429506301879883	\N
828	2026-10-08 16:25:15.221823+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.00978541374206543	\N
833	2026-10-08 16:25:15.261044+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.004480838775634766	\N
834	2026-10-08 16:25:18.386543+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.054945945739746094	\N
842	2026-10-08 16:25:25.623488+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.011443614959716797	\N
844	2026-10-08 16:25:25.639041+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.07803034782409668	\N
848	2026-10-08 16:29:24.487418+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.004445314407348633	\N
853	2026-10-08 16:29:32.666131+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.024506092071533203	\N
859	2026-10-08 16:39:26.693818+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.016190052032470703	\N
1369	2026-10-08 17:47:52.095216+00	GET	/api/auth/me	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.014902830123901367	2b3f77bc-0f82-4c55-aa05-41d12db6b770
1372	2026-10-08 17:47:53.776904+00	GET	/api/journal/2244bf82-1f9a-4004-aecf-9357def21b44	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.01143956184387207	2b3f77bc-0f82-4c55-aa05-41d12db6b770
1378	2026-10-08 17:47:59.421705+00	GET	/api/journal/2244bf82-1f9a-4004-aecf-9357def21b44	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.008877992630004883	2b3f77bc-0f82-4c55-aa05-41d12db6b770
1380	2026-10-08 17:48:00.076892+00	PATCH	/api/journal/2244bf82-1f9a-4004-aecf-9357def21b44	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.013761758804321289	2b3f77bc-0f82-4c55-aa05-41d12db6b770
1383	2026-10-08 17:48:08.577326+00	GET	/api/auth/me	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.010885238647460938	2b3f77bc-0f82-4c55-aa05-41d12db6b770
1676	2026-10-08 20:18:01.251546+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.0039484500885009766	\N
1920	2026-10-08 20:45:00.677341+00	GET	/api/sessions/f29b7e3c-59c5-4380-9af4-96cec59b69bd	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.1116633415222168	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2135	2026-10-08 21:09:13.148628+00	GET	/api/sessions/6181c511-10b9-4bff-b8f4-164d7db901ba	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.006827831268310547	2b3f77bc-0f82-4c55-aa05-41d12db6b770
2137	2026-10-08 21:09:14.232329+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.003438234329223633	2b3f77bc-0f82-4c55-aa05-41d12db6b770
2139	2026-10-08 21:10:12.712589+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.011994600296020508	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2140	2026-10-08 21:11:17.602725+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.031770944595336914	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2142	2026-10-08 21:11:19.66122+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.03670620918273926	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2144	2026-10-08 21:11:20.662071+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.01640605926513672	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2149	2026-10-08 21:11:37.717651+00	GET	/api/audit	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.07695317268371582	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2281	2026-10-08 21:25:03.306696+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.05670642852783203	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2282	2026-10-08 21:25:03.36066+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.03125715255737305	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2332	2026-10-08 21:29:16.92768+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.05799102783203125	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2345	2026-10-08 21:33:20.620304+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.03347468376159668	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2363	2026-10-08 21:36:46.745634+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0530695915222168	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2711	2026-10-09 11:54:10.675498+00	POST	/api/journal	127.0.0.1	python-httpx/0.28.1	201	0.04172325134277344	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
792	2026-10-08 16:25:03.222966+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.01408243179321289	\N
798	2026-10-08 16:25:04.188566+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.029631614685058594	\N
807	2026-10-08 16:25:05.269013+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.004315376281738281	\N
811	2026-10-08 16:25:06.26496+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.007582664489746094	\N
818	2026-10-08 16:25:07.421418+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.004481792449951172	\N
820	2026-10-08 16:25:07.431115+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.03285670280456543	\N
825	2026-10-08 16:25:14.318681+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.008862495422363281	\N
827	2026-10-08 16:25:14.340239+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.003105640411376953	\N
829	2026-10-08 16:25:15.221328+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.004434347152709961	\N
836	2026-10-08 16:25:18.420308+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.003757953643798828	\N
839	2026-10-08 16:25:18.433672+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.002645254135131836	\N
841	2026-10-08 16:25:25.588445+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0122833251953125	\N
845	2026-10-08 16:25:25.642976+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0014410018920898438	\N
847	2026-10-08 16:29:24.470256+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.018935680389404297	\N
854	2026-10-08 16:29:32.695677+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.009434938430786133	\N
856	2026-10-08 16:29:32.718512+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0714564323425293	\N
861	2026-10-08 16:39:26.71657+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.005501270294189453	\N
863	2026-10-08 16:39:26.738733+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0029325485229492188	\N
864	2026-10-08 16:39:28.021949+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.011228322982788086	\N
869	2026-10-08 16:39:28.233739+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.005620002746582031	\N
874	2026-10-08 16:39:29.423961+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.016492605209350586	\N
878	2026-10-08 16:39:29.455445+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0019268989562988281	\N
880	2026-10-08 16:39:30.442444+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.012136459350585938	\N
887	2026-10-08 16:39:31.611259+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0111846923828125	\N
892	2026-10-08 16:39:39.295135+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.04628491401672363	\N
896	2026-10-08 16:39:39.326903+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0019979476928710938	\N
898	2026-10-08 16:39:47.459943+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.013334989547729492	\N
906	2026-10-08 16:39:47.721011+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0040721893310546875	\N
910	2026-10-08 16:46:05.754841+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.017038822174072266	\N
918	2026-10-08 16:46:07.242223+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.00487208366394043	\N
919	2026-10-08 16:46:07.257069+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.05955910682678223	\N
923	2026-10-08 16:46:08.392659+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.003354310989379883	\N
928	2026-10-08 16:46:09.55625+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.026798248291015625	\N
932	2026-10-08 16:46:09.585004+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0017156600952148438	\N
934	2026-10-08 16:46:10.449217+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.025117874145507812	\N
941	2026-10-08 16:46:11.493961+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.004281759262084961	\N
944	2026-10-08 16:46:11.528084+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.006035566329956055	\N
794	2026-10-08 16:25:03.233876+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0015807151794433594	\N
796	2026-10-08 16:25:03.262539+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.06482863426208496	\N
800	2026-10-08 16:25:04.204888+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0044727325439453125	\N
802	2026-10-08 16:25:04.214023+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0464937686920166	\N
805	2026-10-08 16:25:05.251982+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.029323101043701172	\N
809	2026-10-08 16:25:05.298783+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.001451253890991211	\N
810	2026-10-08 16:25:06.264425+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.01390981674194336	\N
814	2026-10-08 16:25:06.288755+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.006456136703491211	\N
819	2026-10-08 16:25:07.422618+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.004420280456542969	\N
823	2026-10-08 16:25:14.292186+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.024490833282470703	\N
826	2026-10-08 16:25:14.329803+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.009337902069091797	\N
831	2026-10-08 16:25:15.237626+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.003308534622192383	\N
832	2026-10-08 16:25:15.25388+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.03644204139709473	\N
837	2026-10-08 16:25:18.421026+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.004432201385498047	\N
838	2026-10-08 16:25:18.418964+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.02264714241027832	\N
840	2026-10-08 16:25:25.58779+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.011970043182373047	\N
849	2026-10-08 16:29:24.490468+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.006963491439819336	\N
850	2026-10-08 16:29:24.492039+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.03803205490112305	\N
851	2026-10-08 16:29:24.500036+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0017249584197998047	\N
852	2026-10-08 16:29:32.665218+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.04475593566894531	\N
860	2026-10-08 16:39:26.714856+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.005267143249511719	\N
862	2026-10-08 16:39:26.726988+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.013720989227294922	\N
865	2026-10-08 16:39:28.023005+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.030648469924926758	\N
866	2026-10-08 16:39:28.124574+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.11288022994995117	\N
867	2026-10-08 16:39:28.217746+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.004332542419433594	\N
868	2026-10-08 16:39:28.218311+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0030760765075683594	\N
871	2026-10-08 16:39:28.25155+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0027005672454833984	\N
875	2026-10-08 16:39:29.44022+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.005035877227783203	\N
876	2026-10-08 16:39:29.441395+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0035190582275390625	\N
877	2026-10-08 16:39:29.451069+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.04142117500305176	\N
879	2026-10-08 16:39:30.443176+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.03612995147705078	\N
881	2026-10-08 16:39:30.468509+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.013393163681030273	\N
882	2026-10-08 16:39:30.471892+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.005565643310546875	\N
886	2026-10-08 16:39:31.578841+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.007260322570800781	\N
888	2026-10-08 16:39:31.614779+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0054302215576171875	\N
889	2026-10-08 16:39:31.623052+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.012357473373413086	\N
890	2026-10-08 16:39:31.633274+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0024137496948242188	\N
891	2026-10-08 16:39:39.293904+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.03649139404296875	\N
1370	2026-10-08 17:47:52.099514+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.030614614486694336	2b3f77bc-0f82-4c55-aa05-41d12db6b770
1679	2026-10-08 20:18:04.497461+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.01617431640625	\N
1707	2026-10-08 20:20:00.445059+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0422513484954834	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1709	2026-10-08 20:20:04.096269+00	GET	/api/sessions/f29b7e3c-59c5-4380-9af4-96cec59b69bd	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.012807130813598633	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1715	2026-10-08 20:20:17.592073+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0061206817626953125	2b3f77bc-0f82-4c55-aa05-41d12db6b770
1719	2026-10-08 20:22:02.679143+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.06472158432006836	2b3f77bc-0f82-4c55-aa05-41d12db6b770
1722	2026-10-08 20:22:02.730984+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.07823562622070312	2b3f77bc-0f82-4c55-aa05-41d12db6b770
1921	2026-10-08 20:45:00.704792+00	GET	/api/sessions/f29b7e3c-59c5-4380-9af4-96cec59b69bd	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.016343116760253906	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2141	2026-10-08 21:11:17.601412+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.050867319107055664	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2143	2026-10-08 21:11:20.239796+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.018402099609375	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2145	2026-10-08 21:11:21.789398+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.011371374130249023	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2146	2026-10-08 21:11:36.15148+00	GET	/api/users	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.028005361557006836	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2277	2026-10-08 21:25:03.307587+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.058101654052734375	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2333	2026-10-08 21:29:16.926596+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.11812734603881836	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2336	2026-10-08 21:29:17.307787+00	GET	/api/audit	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.022101402282714844	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2338	2026-10-08 21:29:17.415832+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0039014816284179688	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2340	2026-10-08 21:29:18.413521+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.04895305633544922	\N
2356	2026-10-08 21:36:39.260175+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.13086438179016113	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2361	2026-10-08 21:36:39.436142+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.013020038604736328	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2366	2026-10-08 21:36:53.754414+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.009343624114990234	\N
2378	2026-10-08 21:38:38.111743+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.037870168685913086	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2380	2026-10-08 21:38:39.123588+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.015129566192626953	\N
2389	2026-10-08 21:39:35.062555+00	GET	/api/journal/public	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.07238078117370605	\N
2390	2026-10-08 21:39:36.791033+00	GET	/api/journal/e1b9db18-3f6f-41c4-8498-f18a574ebc7e	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.027048110961914062	\N
2391	2026-10-08 21:39:36.791511+00	GET	/api/journal/e1b9db18-3f6f-41c4-8498-f18a574ebc7e	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.01716017723083496	\N
2392	2026-10-08 21:39:38.549207+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.004668474197387695	\N
2393	2026-10-08 21:39:38.550387+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.009323596954345703	\N
2394	2026-10-08 21:39:39.128842+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.005097866058349609	\N
2395	2026-10-08 21:39:39.129753+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0057947635650634766	\N
2396	2026-10-08 21:39:40.223337+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.019366025924682617	\N
2401	2026-10-08 21:41:31.897665+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.009946107864379883	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2403	2026-10-08 21:41:32.657832+00	GET	/api/journal/public	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0203702449798584	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2404	2026-10-08 21:41:34.003371+00	GET	/api/journal/e1b9db18-3f6f-41c4-8498-f18a574ebc7e	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.02602410316467285	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2405	2026-10-08 21:41:34.020115+00	GET	/api/journal/e1b9db18-3f6f-41c4-8498-f18a574ebc7e	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.032068490982055664	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2406	2026-10-08 22:11:40.855016+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	401	0.22321271896362305	\N
2408	2026-10-08 22:11:40.888854+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	401	0.0004973411560058594	\N
2409	2026-10-08 22:11:40.900361+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.008661270141601562	\N
2411	2026-10-08 22:28:59.710517+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.027627229690551758	\N
2412	2026-10-08 22:28:59.718966+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	401	0.0012831687927246094	\N
2413	2026-10-08 22:28:59.725433+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.004171848297119141	\N
893	2026-10-08 16:39:39.309505+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.007701873779296875	\N
895	2026-10-08 16:39:39.322684+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.04427671432495117	\N
900	2026-10-08 16:39:47.497665+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.00996708869934082	\N
905	2026-10-08 16:39:47.720355+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0033674240112304688	\N
907	2026-10-08 16:39:47.729576+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.01715230941772461	\N
911	2026-10-08 16:46:05.774503+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.003443002700805664	\N
916	2026-10-08 16:46:07.232158+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.04237866401672363	\N
924	2026-10-08 16:46:08.393613+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0036139488220214844	\N
926	2026-10-08 16:46:08.41208+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.003077268600463867	\N
927	2026-10-08 16:46:09.555703+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.038506269454956055	\N
935	2026-10-08 16:46:10.476194+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0065746307373046875	\N
940	2026-10-08 16:46:11.478881+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.015163660049438477	\N
1391	2026-10-08 17:48:16.5134+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.009467124938964844	2b3f77bc-0f82-4c55-aa05-41d12db6b770
1399	2026-10-08 17:48:54.411186+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0074002742767333984	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1401	2026-10-08 17:48:56.950368+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.014350414276123047	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1403	2026-10-08 17:48:58.191554+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.01138162612915039	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1405	2026-10-08 18:00:10.157771+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.030452251434326172	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1407	2026-10-08 18:00:12.272231+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.011246204376220703	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1409	2026-10-08 18:00:14.642255+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.011410713195800781	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1412	2026-10-08 18:00:26.09402+00	PATCH	/api/journal/59f30e0a-25aa-4d37-82cb-e79b3f53a0e8	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.010210275650024414	2b3f77bc-0f82-4c55-aa05-41d12db6b770
1415	2026-10-08 18:00:27.659739+00	PATCH	/api/journal/59f30e0a-25aa-4d37-82cb-e79b3f53a0e8	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.00856781005859375	2b3f77bc-0f82-4c55-aa05-41d12db6b770
1419	2026-10-08 18:00:48.694197+00	GET	/api/journal/59f30e0a-25aa-4d37-82cb-e79b3f53a0e8	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.036691904067993164	2b3f77bc-0f82-4c55-aa05-41d12db6b770
1433	2026-10-08 18:01:47.351483+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.016302108764648438	\N
1435	2026-10-08 18:02:01.149182+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.031072139739990234	\N
1681	2026-10-08 20:18:07.429063+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.049025774002075195	\N
1683	2026-10-08 20:18:07.450817+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0666954517364502	\N
1687	2026-10-08 20:18:19.67757+00	POST	/api/auth/login	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.2944152355194092	\N
1922	2026-10-08 20:47:07.174325+00	POST	/api/auth/login	127.0.0.1	python-httpx/0.28.1	200	0.2850039005279541	\N
1923	2026-10-08 20:47:07.256941+00	POST	/api/journal	127.0.0.1	python-httpx/0.28.1	201	0.07176017761230469	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1924	2026-10-08 20:47:07.273942+00	PATCH	/api/journal/bd0d0f09-9fbf-4fad-b563-9b39eb84eb0b	127.0.0.1	python-httpx/0.28.1	200	0.013204097747802734	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1925	2026-10-08 20:47:07.285547+00	POST	/api/journal/bd0d0f09-9fbf-4fad-b563-9b39eb84eb0b/approve	127.0.0.1	python-httpx/0.28.1	200	0.007539987564086914	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1931	2026-10-08 20:47:07.627226+00	GET	/api/sessions	127.0.0.1	python-httpx/0.28.1	200	0.0039861202239990234	\N
1940	2026-10-08 20:47:07.955439+00	GET	/api/sessions	127.0.0.1	python-httpx/0.28.1	200	0.003701925277709961	\N
1941	2026-10-08 20:47:08.204643+00	POST	/api/auth/login	127.0.0.1	python-httpx/0.28.1	200	0.24038195610046387	\N
1943	2026-10-08 20:47:08.226685+00	POST	/api/upload/multiple	127.0.0.1	python-httpx/0.28.1	201	0.004345893859863281	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2150	2026-10-08 21:11:39.126759+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.05252361297607422	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2155	2026-10-08 21:11:39.196768+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.16208434104919434	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2161	2026-10-08 21:12:51.306428+00	GET	/api/journal/e1b9db18-3f6f-41c4-8498-f18a574ebc7e	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.03180813789367676	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2163	2026-10-08 21:12:55.429975+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0027043819427490234	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2165	2026-10-08 21:13:00.660365+00	GET	/api/sessions/f29b7e3c-59c5-4380-9af4-96cec59b69bd	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.04023122787475586	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2167	2026-10-08 21:13:04.417642+00	GET	/api/journal/public	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.02842259407043457	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2169	2026-10-08 21:13:04.820177+00	GET	/api/journal/e1b9db18-3f6f-41c4-8498-f18a574ebc7e	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.003024578094482422	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
899	2026-10-08 16:39:47.494722+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.012108802795410156	\N
901	2026-10-08 16:39:47.504438+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.03474712371826172	\N
904	2026-10-08 16:39:47.713781+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.002155303955078125	\N
912	2026-10-08 16:46:05.775715+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0036482810974121094	\N
913	2026-10-08 16:46:05.802953+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.01717543601989746	\N
914	2026-10-08 16:46:05.816689+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0023119449615478516	\N
915	2026-10-08 16:46:07.226988+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.035216569900512695	\N
920	2026-10-08 16:46:07.260769+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0013020038604736328	\N
921	2026-10-08 16:46:08.377171+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.012194395065307617	\N
929	2026-10-08 16:46:09.568146+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0025415420532226562	\N
931	2026-10-08 16:46:09.580344+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.03498411178588867	\N
936	2026-10-08 16:46:10.476647+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0071103572845458984	\N
938	2026-10-08 16:46:10.492463+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0035467147827148438	\N
939	2026-10-08 16:46:11.478254+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.04339122772216797	\N
1422	2026-10-08 18:00:48.717518+00	GET	/api/auth/me	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.015474081039428711	2b3f77bc-0f82-4c55-aa05-41d12db6b770
1421	2026-10-08 18:00:48.714647+00	GET	/api/journal/59f30e0a-25aa-4d37-82cb-e79b3f53a0e8	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.020501375198364258	2b3f77bc-0f82-4c55-aa05-41d12db6b770
1420	2026-10-08 18:00:48.715547+00	GET	/api/auth/me	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.012146234512329102	2b3f77bc-0f82-4c55-aa05-41d12db6b770
1423	2026-10-08 18:00:51.284587+00	PATCH	/api/journal/59f30e0a-25aa-4d37-82cb-e79b3f53a0e8	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.01899862289428711	2b3f77bc-0f82-4c55-aa05-41d12db6b770
1424	2026-10-08 18:00:52.744968+00	GET	/api/auth/me	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.010893106460571289	2b3f77bc-0f82-4c55-aa05-41d12db6b770
1426	2026-10-08 18:00:52.764242+00	GET	/api/auth/me	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0034830570220947266	2b3f77bc-0f82-4c55-aa05-41d12db6b770
1429	2026-10-08 18:01:47.28639+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.04488396644592285	\N
1430	2026-10-08 18:01:47.319105+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.00934910774230957	\N
1432	2026-10-08 18:01:47.332841+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0291445255279541	\N
1436	2026-10-08 18:02:01.176496+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0092010498046875	\N
1437	2026-10-08 18:02:01.177077+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.007384061813354492	\N
1438	2026-10-08 18:02:01.204251+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.10934948921203613	\N
1441	2026-10-08 18:05:12.047762+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.016508102416992188	\N
1442	2026-10-08 18:05:12.077575+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.00691986083984375	\N
1447	2026-10-08 18:05:38.345359+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.03660225868225098	\N
1449	2026-10-08 18:05:38.382332+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.012102603912353516	\N
1451	2026-10-08 18:05:38.406086+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.004284858703613281	\N
1452	2026-10-08 18:05:53.375503+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.07266426086425781	\N
1453	2026-10-08 18:05:53.380029+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.02580738067626953	\N
1682	2026-10-08 20:18:07.431791+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.03148603439331055	\N
1684	2026-10-08 20:18:07.451726+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.09233593940734863	\N
1926	2026-10-08 20:47:07.301886+00	GET	/api/journal/public	127.0.0.1	python-httpx/0.28.1	200	0.012670040130615234	\N
1927	2026-10-08 20:47:07.568137+00	POST	/api/auth/login	127.0.0.1	python-httpx/0.28.1	200	0.2529120445251465	\N
1928	2026-10-08 20:47:07.601214+00	POST	/api/sessions	127.0.0.1	python-httpx/0.28.1	201	0.02708721160888672	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1929	2026-10-08 20:47:07.611337+00	POST	/api/sessions/90f38824-b40b-4730-8973-cf852ebb88bc/publish	127.0.0.1	python-httpx/0.28.1	200	0.006685018539428711	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
917	2026-10-08 16:46:07.242657+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.004258632659912109	\N
922	2026-10-08 16:46:08.377664+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.008562326431274414	\N
925	2026-10-08 16:46:08.394014+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.007602691650390625	\N
930	2026-10-08 16:46:09.568741+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0030677318572998047	\N
933	2026-10-08 16:46:10.44991+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0464632511138916	\N
937	2026-10-08 16:46:10.483988+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.02846837043762207	\N
942	2026-10-08 16:46:11.49595+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0033512115478515625	\N
943	2026-10-08 16:46:11.518142+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.04993438720703125	\N
945	2026-10-08 16:46:12.419273+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0175628662109375	\N
946	2026-10-08 16:46:12.420468+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.013201475143432617	\N
947	2026-10-08 16:46:12.439035+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.007205963134765625	\N
948	2026-10-08 16:46:12.441683+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.005244016647338867	\N
949	2026-10-08 16:46:12.44383+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.013653755187988281	\N
950	2026-10-08 16:46:12.454244+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0042111873626708984	\N
951	2026-10-08 16:46:13.577552+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.02444291114807129	\N
952	2026-10-08 16:46:13.579506+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.012424468994140625	\N
953	2026-10-08 16:46:13.592399+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.005764007568359375	\N
954	2026-10-08 16:46:13.593935+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.004419565200805664	\N
955	2026-10-08 16:46:13.601901+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.032491445541381836	\N
956	2026-10-08 16:46:13.606398+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0021049976348876953	\N
957	2026-10-08 16:46:14.55309+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.04498457908630371	\N
958	2026-10-08 16:46:14.553492+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.01904582977294922	\N
959	2026-10-08 16:46:14.592242+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.011705160140991211	\N
960	2026-10-08 16:46:14.596694+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.009076118469238281	\N
961	2026-10-08 16:46:14.608127+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0195009708404541	\N
962	2026-10-08 16:46:14.619501+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.002573728561401367	\N
963	2026-10-08 16:46:16.714702+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0403594970703125	\N
964	2026-10-08 16:46:16.715536+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.018622398376464844	\N
965	2026-10-08 16:46:16.736181+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.005345582962036133	\N
966	2026-10-08 16:46:16.737058+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.003505229949951172	\N
967	2026-10-08 16:46:16.759411+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.05746889114379883	\N
968	2026-10-08 16:46:16.765031+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.002560853958129883	\N
969	2026-10-08 16:46:17.713653+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.006567239761352539	\N
970	2026-10-08 16:46:17.714867+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.004999637603759766	\N
971	2026-10-08 16:46:17.742129+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.004966020584106445	\N
972	2026-10-08 16:46:17.743013+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.003491640090942383	\N
973	2026-10-08 16:46:17.757575+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0036766529083251953	\N
974	2026-10-08 16:46:17.764287+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.001974344253540039	\N
975	2026-10-08 16:46:18.990429+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.07162666320800781	\N
980	2026-10-08 16:46:19.063411+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0027129650115966797	\N
982	2026-10-08 16:46:20.12217+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.018678665161132812	\N
990	2026-10-08 16:46:21.114982+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0022902488708496094	\N
994	2026-10-08 16:46:22.180444+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.044830322265625	\N
1002	2026-10-08 16:46:23.201182+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.013470172882080078	\N
1006	2026-10-08 16:46:25.285439+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.04575324058532715	\N
1013	2026-10-08 16:46:29.576512+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.006294965744018555	\N
1018	2026-10-08 16:46:30.567456+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.044281005859375	\N
1025	2026-10-08 16:46:38.015938+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.008469343185424805	\N
1027	2026-10-08 16:46:38.024767+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.03873467445373535	\N
1032	2026-10-08 16:46:45.208434+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0036971569061279297	\N
1034	2026-10-08 16:46:45.231722+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.002340078353881836	\N
1036	2026-10-08 16:46:46.227369+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.005219459533691406	\N
1044	2026-10-08 16:46:47.93715+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.004031658172607422	\N
1049	2026-10-08 16:46:48.388751+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0034775733947753906	\N
1051	2026-10-08 16:46:48.403808+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.03507280349731445	\N
1056	2026-10-08 16:46:50.558072+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.003986358642578125	\N
1431	2026-10-08 18:01:47.327719+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.05426597595214844	\N
1443	2026-10-08 18:05:12.082202+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.008513212203979492	\N
1445	2026-10-08 18:05:12.109154+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.004805326461791992	\N
1446	2026-10-08 18:05:38.3435+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.10038328170776367	\N
1454	2026-10-08 18:05:53.433336+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.022480010986328125	\N
1685	2026-10-08 20:18:07.469645+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.06121325492858887	\N
1930	2026-10-08 20:47:07.619913+00	POST	/api/sessions/90f38824-b40b-4730-8973-cf852ebb88bc/complete	127.0.0.1	python-httpx/0.28.1	200	0.005261898040771484	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1932	2026-10-08 20:47:07.631936+00	GET	/api/sessions/90f38824-b40b-4730-8973-cf852ebb88bc	127.0.0.1	python-httpx/0.28.1	200	0.0015668869018554688	\N
1933	2026-10-08 20:47:07.64239+00	PATCH	/api/sessions/90f38824-b40b-4730-8973-cf852ebb88bc	127.0.0.1	python-httpx/0.28.1	200	0.0067141056060791016	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1934	2026-10-08 20:47:07.893106+00	POST	/api/auth/login	127.0.0.1	python-httpx/0.28.1	200	0.24216508865356445	\N
1935	2026-10-08 20:47:07.908018+00	POST	/api/sessions	127.0.0.1	python-httpx/0.28.1	201	0.009151935577392578	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1936	2026-10-08 20:47:07.918109+00	POST	/api/sessions/153cc794-852f-48fe-9d32-3f9020367ae3/publish	127.0.0.1	python-httpx/0.28.1	200	0.005647182464599609	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1937	2026-10-08 20:47:07.926833+00	POST	/api/sessions/153cc794-852f-48fe-9d32-3f9020367ae3/complete-and-document	127.0.0.1	python-httpx/0.28.1	200	0.005592823028564453	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1938	2026-10-08 20:47:07.938921+00	PATCH	/api/sessions/153cc794-852f-48fe-9d32-3f9020367ae3/documentation	127.0.0.1	python-httpx/0.28.1	200	0.00861811637878418	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1939	2026-10-08 20:47:07.948711+00	POST	/api/sessions/153cc794-852f-48fe-9d32-3f9020367ae3/publish-studio	127.0.0.1	python-httpx/0.28.1	200	0.006636857986450195	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1942	2026-10-08 20:47:08.215805+00	POST	/api/upload	127.0.0.1	python-httpx/0.28.1	201	0.004573822021484375	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1944	2026-10-08 20:47:08.236397+00	POST	/api/upload	127.0.0.1	python-httpx/0.28.1	400	0.0032510757446289062	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2152	2026-10-08 21:11:39.127171+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.061043739318847656	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2175	2026-10-08 21:13:14.99894+00	GET	/api/journal/public	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0038051605224609375	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2177	2026-10-08 21:13:16.137789+00	GET	/api/journal/bb701e5a-271b-40b8-8298-1b903317aee1	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.009092092514038086	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2199	2026-10-08 21:16:44.13593+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.01615595817565918	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2200	2026-10-08 21:16:44.177485+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.013997554779052734	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
976	2026-10-08 16:46:18.990989+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.048264503479003906	\N
983	2026-10-08 16:46:20.147766+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.00539398193359375	\N
988	2026-10-08 16:46:21.101414+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.017088890075683594	\N
995	2026-10-08 16:46:22.202072+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0063877105712890625	\N
1000	2026-10-08 16:46:23.178058+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.03482675552368164	\N
1007	2026-10-08 16:46:25.311648+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.006066322326660156	\N
1012	2026-10-08 16:46:29.558544+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.03952336311340332	\N
1019	2026-10-08 16:46:30.590596+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.008020639419555664	\N
1024	2026-10-08 16:46:37.994978+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.02739262580871582	\N
1031	2026-10-08 16:46:45.206358+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.005315303802490234	\N
1035	2026-10-08 16:46:46.228194+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0047037601470947266	\N
1040	2026-10-08 16:46:46.27064+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0034685134887695312	\N
1041	2026-10-08 16:46:47.914587+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.011938810348510742	\N
1046	2026-10-08 16:46:48.00217+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.004324674606323242	\N
1047	2026-10-08 16:46:48.370312+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.006723880767822266	\N
1052	2026-10-08 16:46:48.408641+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0012924671173095703	\N
1053	2026-10-08 16:46:50.542559+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.029162168502807617	\N
1062	2026-10-08 16:46:51.412149+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.006320476531982422	\N
1066	2026-10-08 16:46:58.323205+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.009926557540893555	\N
1074	2026-10-08 16:59:29.636917+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.013723373413085938	\N
1078	2026-10-08 16:59:30.433286+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.02964043617248535	\N
1085	2026-10-08 16:59:31.654134+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0027468204498291016	\N
1087	2026-10-08 16:59:31.682562+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.06578421592712402	\N
1092	2026-10-08 16:59:31.988943+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.015677928924560547	\N
1097	2026-10-08 16:59:36.520361+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0024797916412353516	\N
1099	2026-10-08 16:59:36.536077+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.03674435615539551	\N
1444	2026-10-08 18:05:12.092555+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.054132699966430664	\N
1455	2026-10-08 18:05:53.435267+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.016506195068359375	\N
1457	2026-10-08 18:05:53.474353+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0035734176635742188	\N
1688	2026-10-08 20:18:19.859775+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.03739118576049805	2b3f77bc-0f82-4c55-aa05-41d12db6b770
1693	2026-10-08 20:18:19.892014+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0818779468536377	2b3f77bc-0f82-4c55-aa05-41d12db6b770
1945	2026-10-08 20:47:27.425188+00	POST	/api/auth/login	127.0.0.1	python-httpx/0.28.1	200	0.27202510833740234	\N
1946	2026-10-08 20:47:27.490837+00	POST	/api/sessions	127.0.0.1	python-httpx/0.28.1	201	0.058071136474609375	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1947	2026-10-08 20:47:27.502919+00	POST	/api/sessions/26170c08-4b1e-4cab-a515-87cd06783919/publish	127.0.0.1	python-httpx/0.28.1	200	0.00830698013305664	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1948	2026-10-08 20:47:27.512464+00	POST	/api/sessions/26170c08-4b1e-4cab-a515-87cd06783919/complete	127.0.0.1	python-httpx/0.28.1	200	0.00613713264465332	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1950	2026-10-08 20:47:27.527594+00	GET	/api/sessions/26170c08-4b1e-4cab-a515-87cd06783919	127.0.0.1	python-httpx/0.28.1	200	0.0016241073608398438	\N
1951	2026-10-08 20:47:27.539641+00	PATCH	/api/sessions/26170c08-4b1e-4cab-a515-87cd06783919	127.0.0.1	python-httpx/0.28.1	200	0.008428096771240234	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1952	2026-10-08 20:47:27.55152+00	POST	/api/sessions/26170c08-4b1e-4cab-a515-87cd06783919/publish-studio	127.0.0.1	python-httpx/0.28.1	200	0.007642269134521484	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1953	2026-10-08 20:47:27.560565+00	POST	/api/sessions/26170c08-4b1e-4cab-a515-87cd06783919/unpublish-studio	127.0.0.1	python-httpx/0.28.1	200	0.005499839782714844	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2283	2026-10-08 21:28:53.969133+00	POST	/api/auth/login	127.0.0.1	python-httpx/0.28.1	200	0.27417707443237305	\N
977	2026-10-08 16:46:19.014042+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.010753393173217773	\N
979	2026-10-08 16:46:19.052093+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.10612225532531738	\N
984	2026-10-08 16:46:20.150877+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0065920352935791016	\N
989	2026-10-08 16:46:21.11402+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0027763843536376953	\N
991	2026-10-08 16:46:21.128683+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.04079318046569824	\N
996	2026-10-08 16:46:22.203148+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.00967264175415039	\N
998	2026-10-08 16:46:22.22323+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0020418167114257812	\N
999	2026-10-08 16:46:23.177438+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.015506267547607422	\N
1004	2026-10-08 16:46:23.219846+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0012903213500976562	\N
1005	2026-10-08 16:46:25.284902+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.018611907958984375	\N
1010	2026-10-08 16:46:25.32903+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0015032291412353516	\N
1011	2026-10-08 16:46:29.557805+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.04964876174926758	\N
1016	2026-10-08 16:46:29.591248+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0014600753784179688	\N
1017	2026-10-08 16:46:30.566799+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.024212360382080078	\N
1026	2026-10-08 16:46:38.017276+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.007371187210083008	\N
1028	2026-10-08 16:46:38.02804+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0011963844299316406	\N
1029	2026-10-08 16:46:45.188285+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.022367238998413086	\N
1038	2026-10-08 16:46:46.236317+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0028450489044189453	\N
1042	2026-10-08 16:46:47.91642+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.03388500213623047	\N
1050	2026-10-08 16:46:48.389174+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.003691434860229492	\N
1054	2026-10-08 16:46:50.543148+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.019453763961791992	\N
1061	2026-10-08 16:46:51.411865+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0024368762969970703	\N
1063	2026-10-08 16:46:51.426474+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.030438661575317383	\N
1067	2026-10-08 16:46:58.340631+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.004662275314331055	\N
1071	2026-10-08 16:59:29.604525+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.019463777542114258	\N
1076	2026-10-08 16:59:29.655628+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0017573833465576172	\N
1077	2026-10-08 16:59:30.431775+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.011693000793457031	\N
1086	2026-10-08 16:59:31.671289+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.01765584945678711	\N
1088	2026-10-08 16:59:31.687534+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.001861572265625	\N
1089	2026-10-08 16:59:31.962651+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0030562877655029297	\N
1094	2026-10-08 16:59:32.00813+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0019381046295166016	\N
1095	2026-10-08 16:59:36.511224+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.028035402297973633	\N
1100	2026-10-08 16:59:36.541215+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.002763986587524414	\N
1456	2026-10-08 18:05:53.45336+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.04054689407348633	\N
1689	2026-10-08 20:18:19.860317+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.03604292869567871	2b3f77bc-0f82-4c55-aa05-41d12db6b770
1691	2026-10-08 20:18:19.873395+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0654299259185791	2b3f77bc-0f82-4c55-aa05-41d12db6b770
1949	2026-10-08 20:47:27.521177+00	GET	/api/sessions	127.0.0.1	python-httpx/0.28.1	200	0.004931926727294922	\N
1954	2026-10-08 20:47:27.569267+00	DELETE	/api/sessions/26170c08-4b1e-4cab-a515-87cd06783919	127.0.0.1	python-httpx/0.28.1	204	0.0051190853118896484	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
978	2026-10-08 16:46:19.019415+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.01271677017211914	\N
981	2026-10-08 16:46:20.122824+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.04714536666870117	\N
985	2026-10-08 16:46:20.15935+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.01646113395690918	\N
986	2026-10-08 16:46:20.171381+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0045278072357177734	\N
987	2026-10-08 16:46:21.100622+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.03155970573425293	\N
992	2026-10-08 16:46:21.134065+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0021028518676757812	\N
993	2026-10-08 16:46:22.179579+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.01062154769897461	\N
997	2026-10-08 16:46:22.215208+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.01275324821472168	\N
1001	2026-10-08 16:46:23.201597+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.012886524200439453	\N
1003	2026-10-08 16:46:23.216134+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.05426812171936035	\N
1008	2026-10-08 16:46:25.312718+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.004205465316772461	\N
1009	2026-10-08 16:46:25.320823+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.01885676383972168	\N
1014	2026-10-08 16:46:29.576852+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.004669904708862305	\N
1015	2026-10-08 16:46:29.587361+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.06674337387084961	\N
1020	2026-10-08 16:46:30.591167+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.007182121276855469	\N
1021	2026-10-08 16:46:30.597929+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.019066810607910156	\N
1022	2026-10-08 16:46:30.605573+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0023009777069091797	\N
1023	2026-10-08 16:46:37.994535+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.010777473449707031	\N
1030	2026-10-08 16:46:45.188763+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.013051271438598633	\N
1033	2026-10-08 16:46:45.210795+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.011122703552246094	\N
1037	2026-10-08 16:46:46.236006+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.002455472946166992	\N
1039	2026-10-08 16:46:46.263971+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.037004709243774414	\N
1043	2026-10-08 16:46:47.936083+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.004410505294799805	\N
1045	2026-10-08 16:46:47.948732+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.019251585006713867	\N
1048	2026-10-08 16:46:48.370796+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.004763126373291016	\N
1055	2026-10-08 16:46:50.55883+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0037741661071777344	\N
1057	2026-10-08 16:46:50.569538+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.018802881240844727	\N
1058	2026-10-08 16:46:50.580106+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0025582313537597656	\N
1059	2026-10-08 16:46:51.399173+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.008185386657714844	\N
1060	2026-10-08 16:46:51.399382+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.005362749099731445	\N
1064	2026-10-08 16:46:51.431754+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0024421215057373047	\N
1065	2026-10-08 16:46:58.322804+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.00988006591796875	\N
1068	2026-10-08 16:46:58.341036+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0025682449340820312	\N
1069	2026-10-08 16:46:58.345547+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.02565455436706543	\N
1070	2026-10-08 16:46:58.352185+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0014719963073730469	\N
1072	2026-10-08 16:59:29.602852+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.04560589790344238	\N
1073	2026-10-08 16:59:29.634436+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.014738321304321289	\N
1075	2026-10-08 16:59:29.649714+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.062029123306274414	\N
1079	2026-10-08 16:59:30.474006+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.02174067497253418	\N
1084	2026-10-08 16:59:31.6403+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.025482654571533203	\N
1090	2026-10-08 16:59:31.963388+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0028955936431884766	\N
1091	2026-10-08 16:59:31.987326+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.011566877365112305	\N
1096	2026-10-08 16:59:36.511697+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.015052318572998047	\N
1458	2026-10-08 18:17:32.379865+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.03953385353088379	\N
1463	2026-10-08 18:17:32.421999+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0017468929290771484	\N
1465	2026-10-08 18:19:07.056198+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.03722023963928223	\N
1473	2026-10-08 18:22:31.320285+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.004332542419433594	\N
1475	2026-10-08 18:22:31.348297+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.003973245620727539	\N
1479	2026-10-08 18:22:43.335808+00	GET	/api/auth/me	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	401	0.0006229877471923828	\N
1492	2026-10-08 18:24:54.573687+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.02618861198425293	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1494	2026-10-08 18:24:57.755532+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.015110015869140625	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1690	2026-10-08 20:18:19.859195+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.04361677169799805	2b3f77bc-0f82-4c55-aa05-41d12db6b770
1955	2026-10-08 20:47:27.574335+00	GET	/api/sessions/26170c08-4b1e-4cab-a515-87cd06783919	127.0.0.1	python-httpx/0.28.1	404	0.0018458366394042969	\N
2151	2026-10-08 21:11:39.124198+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.050423383712768555	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2159	2026-10-08 21:12:49.797682+00	GET	/api/journal/public	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.08291077613830566	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2160	2026-10-08 21:12:51.303674+00	GET	/api/journal/e1b9db18-3f6f-41c4-8498-f18a574ebc7e	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.042659759521484375	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2162	2026-10-08 21:12:55.419803+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.042784929275512695	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2173	2026-10-08 21:13:11.971612+00	GET	/api/journal/dda23ea8-273a-4cdb-8960-59331db60cfa	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.012590646743774414	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2180	2026-10-08 21:13:21.47118+00	GET	/api/journal/de99b413-6a92-48c8-823d-17d0e2ed6b07	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.011630773544311523	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2182	2026-10-08 21:13:23.575053+00	GET	/api/journal/public	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.027991056442260742	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2184	2026-10-08 21:13:24.388737+00	GET	/api/journal/e1b9db18-3f6f-41c4-8498-f18a574ebc7e	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.008370399475097656	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2202	2026-10-08 21:16:44.19646+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0343174934387207	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2204	2026-10-08 21:17:35.074479+00	GET	/api/sessions/77722f17-88b9-4ae3-8438-91cd12eced8f	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.026588916778564453	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2208	2026-10-08 21:17:37.991137+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.00399017333984375	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2216	2026-10-08 21:18:02.073627+00	GET	/api/sessions/8431bdef-789a-4a8e-a151-76ca4ff740db	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.020932435989379883	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2220	2026-10-08 21:18:10.882775+00	GET	/api/sessions/8431bdef-789a-4a8e-a151-76ca4ff740db	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.007984399795532227	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2228	2026-10-08 21:18:28.649712+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0064084529876708984	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2239	2026-10-08 21:19:11.351508+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.005418300628662109	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2248	2026-10-08 21:20:04.718102+00	POST	/api/upload	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	201	0.12699365615844727	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2252	2026-10-08 21:20:31.36039+00	PATCH	/api/sessions/1bc6dfe0-cc1d-4446-995b-64c17d34623f/documentation	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.017092227935791016	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2269	2026-10-08 21:22:16.056947+00	PATCH	/api/sessions/1bc6dfe0-cc1d-4446-995b-64c17d34623f/documentation	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.010260820388793945	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2284	2026-10-08 21:28:54.039526+00	POST	/api/journal	127.0.0.1	python-httpx/0.28.1	201	0.05934500694274902	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2285	2026-10-08 21:28:54.053594+00	PATCH	/api/journal/35f27722-11a5-4e7d-a654-0f48cbc6696f	127.0.0.1	python-httpx/0.28.1	200	0.00943899154663086	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2286	2026-10-08 21:28:54.064223+00	POST	/api/journal/35f27722-11a5-4e7d-a654-0f48cbc6696f/approve	127.0.0.1	python-httpx/0.28.1	200	0.006894826889038086	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2292	2026-10-08 21:28:54.394664+00	GET	/api/sessions	127.0.0.1	python-httpx/0.28.1	200	0.004694938659667969	\N
2297	2026-10-08 21:28:54.441021+00	DELETE	/api/sessions/dcc69d2a-0366-4f91-a8a8-d41cc0724919	127.0.0.1	python-httpx/0.28.1	204	0.004995107650756836	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2298	2026-10-08 21:28:54.446633+00	GET	/api/sessions/dcc69d2a-0366-4f91-a8a8-d41cc0724919	127.0.0.1	python-httpx/0.28.1	404	0.0021970272064208984	\N
2299	2026-10-08 21:28:54.70364+00	POST	/api/auth/login	127.0.0.1	python-httpx/0.28.1	200	0.24494194984436035	\N
1080	2026-10-08 16:59:30.474606+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.027110576629638672	\N
1081	2026-10-08 16:59:30.48565+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.017241477966308594	\N
1082	2026-10-08 16:59:30.498133+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.002958536148071289	\N
1083	2026-10-08 16:59:31.638922+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.03623199462890625	\N
1093	2026-10-08 16:59:31.997453+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0027556419372558594	\N
1098	2026-10-08 16:59:36.521209+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0019652843475341797	\N
1101	2026-10-08 17:00:38.313845+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.012980937957763672	\N
1102	2026-10-08 17:00:38.317317+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.04058074951171875	\N
1103	2026-10-08 17:00:38.336131+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0042095184326171875	\N
1104	2026-10-08 17:00:38.338664+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.004586696624755859	\N
1105	2026-10-08 17:00:38.343335+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.015244245529174805	\N
1106	2026-10-08 17:00:38.350955+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0015871524810791016	\N
1107	2026-10-08 17:02:42.143101+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.046543121337890625	\N
1108	2026-10-08 17:02:42.143698+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.019118309020996094	\N
1109	2026-10-08 17:02:42.15999+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.005364418029785156	\N
1110	2026-10-08 17:02:42.16162+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0070650577545166016	\N
1111	2026-10-08 17:02:42.177833+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0486750602722168	\N
1112	2026-10-08 17:02:42.181362+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0013704299926757812	\N
1113	2026-10-08 17:02:49.702695+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.026666879653930664	\N
1114	2026-10-08 17:02:49.703425+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.01887202262878418	\N
1115	2026-10-08 17:02:49.749419+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.016562461853027344	\N
1116	2026-10-08 17:02:49.751689+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.017645597457885742	\N
1117	2026-10-08 17:02:49.762393+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.015274763107299805	\N
1118	2026-10-08 17:02:49.771839+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0019538402557373047	\N
1119	2026-10-08 17:04:25.623163+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.029600143432617188	\N
1120	2026-10-08 17:04:25.625896+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.016766786575317383	\N
1121	2026-10-08 17:04:25.640023+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.007341623306274414	\N
1122	2026-10-08 17:04:25.641333+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.008289098739624023	\N
1123	2026-10-08 17:04:25.652947+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.04183316230773926	\N
1124	2026-10-08 17:04:25.656243+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0012822151184082031	\N
1126	2026-10-08 17:04:29.400666+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.027544021606445312	\N
1125	2026-10-08 17:04:29.401284+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0146636962890625	\N
1127	2026-10-08 17:04:29.425844+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.006171226501464844	\N
1128	2026-10-08 17:04:29.426189+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.006735086441040039	\N
1129	2026-10-08 17:04:29.426722+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.013811588287353516	\N
1130	2026-10-08 17:04:29.434374+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0017313957214355469	\N
1131	2026-10-08 17:04:33.881574+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0625464916229248	\N
1132	2026-10-08 17:04:33.882368+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.06228518486022949	\N
1133	2026-10-08 17:04:33.939123+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.11604571342468262	\N
1134	2026-10-08 17:04:33.985714+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0025513172149658203	\N
1139	2026-10-08 17:04:34.00804+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.002169370651245117	\N
1140	2026-10-08 17:04:34.931879+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.03833508491516113	\N
1150	2026-10-08 17:27:00.064951+00	POST	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.042524099349975586	\N
1155	2026-10-08 17:29:59.532922+00	POST	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.001928567886352539	\N
1160	2026-10-08 17:31:04.094065+00	POST	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.0021903514862060547	\N
1165	2026-10-08 17:31:41.622629+00	POST	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.01195669174194336	\N
1170	2026-10-08 17:32:25.987634+00	POST	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.016632080078125	\N
1175	2026-10-08 17:33:32.770626+00	POST	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.01292729377746582	\N
1180	2026-10-08 17:34:25.400798+00	POST	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.013588905334472656	\N
1186	2026-10-08 17:34:57.773364+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.013994693756103516	\N
1191	2026-10-08 17:35:01.557823+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.0021631717681884766	\N
1196	2026-10-08 17:35:09.666109+00	GET	/api/users	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.003452777862548828	\N
1201	2026-10-08 17:35:15.969778+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.012151479721069336	\N
1206	2026-10-08 17:35:57.821446+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.044793128967285156	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1233	2026-10-08 17:36:49.399228+00	GET	/api/journal/public	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.03196096420288086	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1235	2026-10-08 17:36:50.824507+00	GET	/api/journal/e1b9db18-3f6f-41c4-8498-f18a574ebc7e	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.002590179443359375	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1237	2026-10-08 17:36:53.10728+00	GET	/api/journal/public	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0036613941192626953	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1238	2026-10-08 17:36:53.86805+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.014845848083496094	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1240	2026-10-08 17:36:55.629593+00	GET	/api/journal/public	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.00497126579284668	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1245	2026-10-08 17:36:59.738322+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0029458999633789062	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1247	2026-10-08 17:37:00.987952+00	GET	/api/users	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.003648042678833008	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1249	2026-10-08 17:37:01.67875+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0031175613403320312	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1251	2026-10-08 17:37:04.849481+00	GET	/api/journal/e1b9db18-3f6f-41c4-8498-f18a574ebc7e	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.00690913200378418	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1255	2026-10-08 17:37:20.690191+00	PATCH	/api/journal/e1b9db18-3f6f-41c4-8498-f18a574ebc7e	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.02979874610900879	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1459	2026-10-08 18:17:32.38019+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.01958489418029785	\N
1466	2026-10-08 18:19:07.097424+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.008270025253295898	\N
1471	2026-10-08 18:22:31.300309+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.029068708419799805	\N
1476	2026-10-08 18:22:43.314605+00	GET	/api/auth/me	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	401	0.010630130767822266	\N
1481	2026-10-08 18:22:45.541079+00	GET	/api/auth/me	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	401	0.0004966259002685547	\N
1484	2026-10-08 18:24:44.313685+00	POST	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	201	0.09116935729980469	2b3f77bc-0f82-4c55-aa05-41d12db6b770
1487	2026-10-08 18:24:50.966771+00	GET	/api/auth/me	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.006487607955932617	2b3f77bc-0f82-4c55-aa05-41d12db6b770
1488	2026-10-08 18:24:50.98334+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.03773784637451172	2b3f77bc-0f82-4c55-aa05-41d12db6b770
1493	2026-10-08 18:24:57.753819+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0074765682220458984	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1497	2026-10-08 18:25:05.422239+00	GET	/api/auth/me	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.02620244026184082	2b3f77bc-0f82-4c55-aa05-41d12db6b770
1508	2026-10-08 18:25:12.456754+00	GET	/api/journal/public	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.03082561492919922	2b3f77bc-0f82-4c55-aa05-41d12db6b770
1509	2026-10-08 18:25:14.772833+00	GET	/api/journal/de99b413-6a92-48c8-823d-17d0e2ed6b07	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.034440040588378906	2b3f77bc-0f82-4c55-aa05-41d12db6b770
1692	2026-10-08 20:18:19.87378+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.07300043106079102	2b3f77bc-0f82-4c55-aa05-41d12db6b770
1956	2026-10-08 20:47:46.555651+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.09342312812805176	\N
1135	2026-10-08 17:04:33.986522+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0025682449340820312	\N
1143	2026-10-08 17:04:34.980771+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.008987188339233398	\N
1145	2026-10-08 17:04:35.003301+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0022275447845458984	\N
1149	2026-10-08 17:25:49.738718+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.0035343170166015625	\N
1154	2026-10-08 17:29:52.993538+00	POST	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.02104806900024414	\N
1159	2026-10-08 17:30:55.727439+00	POST	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.013175725936889648	\N
1164	2026-10-08 17:31:36.601041+00	POST	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.011049032211303711	\N
1169	2026-10-08 17:32:16.481352+00	POST	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.0018401145935058594	\N
1174	2026-10-08 17:33:11.486913+00	POST	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.014461755752563477	\N
1179	2026-10-08 17:34:06.797507+00	POST	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.011611461639404297	\N
1184	2026-10-08 17:34:51.579977+00	POST	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.018085241317749023	\N
1189	2026-10-08 17:35:00.199354+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.018095970153808594	\N
1194	2026-10-08 17:35:09.089263+00	GET	/api/audit	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.05466175079345703	\N
1198	2026-10-08 17:35:10.616172+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.003946542739868164	\N
1209	2026-10-08 17:35:59.13211+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.03367328643798828	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1211	2026-10-08 17:36:12.688913+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.009475231170654297	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1218	2026-10-08 17:36:26.115318+00	GET	/api/users	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.016908884048461914	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1220	2026-10-08 17:36:28.033357+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.008369922637939453	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1222	2026-10-08 17:36:29.356205+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.011637449264526367	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1224	2026-10-08 17:36:30.506255+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.010773420333862305	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1226	2026-10-08 17:36:32.446999+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.006944894790649414	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1229	2026-10-08 17:36:44.391702+00	POST	/api/journal/e1b9db18-3f6f-41c4-8498-f18a574ebc7e/approve	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.014353036880493164	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1231	2026-10-08 17:36:46.015688+00	GET	/api/journal/e1b9db18-3f6f-41c4-8498-f18a574ebc7e	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.01953268051147461	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1239	2026-10-08 17:36:53.867544+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.007674455642700195	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1243	2026-10-08 17:36:56.538756+00	GET	/api/journal/e1b9db18-3f6f-41c4-8498-f18a574ebc7e	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.00878596305847168	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1253	2026-10-08 17:37:17.734033+00	PATCH	/api/journal/e1b9db18-3f6f-41c4-8498-f18a574ebc7e	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.05634307861328125	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1461	2026-10-08 18:17:32.395576+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.004458427429199219	\N
1462	2026-10-08 18:17:32.409014+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.04178261756896973	\N
1467	2026-10-08 18:19:07.106644+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.013553857803344727	\N
1472	2026-10-08 18:22:31.31902+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.007821083068847656	\N
1474	2026-10-08 18:22:31.340078+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.059343576431274414	\N
1477	2026-10-08 18:22:43.324951+00	GET	/api/auth/me	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	401	0.0006146430969238281	\N
1482	2026-10-08 18:22:45.545589+00	GET	/api/auth/me	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	401	0.0005624294281005859	\N
1694	2026-10-08 20:19:07.339799+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.025960206985473633	2b3f77bc-0f82-4c55-aa05-41d12db6b770
1695	2026-10-08 20:19:07.336436+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.04252982139587402	2b3f77bc-0f82-4c55-aa05-41d12db6b770
1697	2026-10-08 20:19:07.361646+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.05524802207946777	2b3f77bc-0f82-4c55-aa05-41d12db6b770
1706	2026-10-08 20:20:00.390431+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.028600454330444336	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1711	2026-10-08 20:20:12.05102+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.004404544830322266	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1957	2026-10-08 20:47:46.587515+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.018990755081176758	\N
1959	2026-10-08 20:48:04.006459+00	GET	/api/sessions/77722f17-88b9-4ae3-8438-91cd12eced8f	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.008466243743896484	\N
2287	2026-10-08 21:28:54.080319+00	GET	/api/journal/public	127.0.0.1	python-httpx/0.28.1	200	0.012952804565429688	\N
1136	2026-10-08 17:04:33.996825+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.004233360290527344	\N
1141	2026-10-08 17:04:34.932661+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0368649959564209	\N
1146	2026-10-08 17:25:47.472072+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.017800569534301758	\N
1151	2026-10-08 17:28:30.318765+00	POST	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.015685319900512695	\N
1156	2026-10-08 17:30:04.346543+00	POST	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.01709127426147461	\N
1161	2026-10-08 17:31:10.232551+00	POST	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.022940397262573242	\N
1166	2026-10-08 17:31:48.02141+00	POST	/api/upload	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.0980687141418457	\N
1171	2026-10-08 17:32:48.671522+00	POST	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.013103485107421875	\N
1176	2026-10-08 17:33:39.511275+00	POST	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.008903741836547852	\N
1181	2026-10-08 17:34:29.572181+00	POST	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.003206491470336914	\N
1185	2026-10-08 17:34:57.774563+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.009616374969482422	\N
1190	2026-10-08 17:35:00.627783+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.002050638198852539	\N
1195	2026-10-08 17:35:09.090285+00	GET	/api/audit	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.012001752853393555	\N
1200	2026-10-08 17:35:15.96863+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.01329493522644043	\N
1204	2026-10-08 17:35:54.957932+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.009144067764282227	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1212	2026-10-08 17:36:20.236521+00	POST	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	201	0.07642340660095215	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1214	2026-10-08 17:36:21.986898+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0027267932891845703	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1216	2026-10-08 17:36:24.447459+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0072062015533447266	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1227	2026-10-08 17:36:42.21473+00	POST	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	201	0.08330488204956055	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1230	2026-10-08 17:36:46.014131+00	GET	/api/journal/e1b9db18-3f6f-41c4-8498-f18a574ebc7e	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.006095409393310547	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1232	2026-10-08 17:36:49.397201+00	GET	/api/journal/public	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.027708053588867188	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1234	2026-10-08 17:36:50.818676+00	GET	/api/journal/e1b9db18-3f6f-41c4-8498-f18a574ebc7e	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.009394407272338867	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1236	2026-10-08 17:36:53.09993+00	GET	/api/journal/public	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.009686708450317383	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1241	2026-10-08 17:36:55.62999+00	GET	/api/journal/public	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.00577235221862793	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1242	2026-10-08 17:36:56.538088+00	GET	/api/journal/e1b9db18-3f6f-41c4-8498-f18a574ebc7e	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.007473945617675781	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1244	2026-10-08 17:36:59.731406+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.011828899383544922	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1246	2026-10-08 17:37:00.974907+00	GET	/api/users	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.009238243103027344	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1248	2026-10-08 17:37:01.672403+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.006920337677001953	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1250	2026-10-08 17:37:02.591576+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.008890390396118164	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1252	2026-10-08 17:37:04.856257+00	GET	/api/journal/e1b9db18-3f6f-41c4-8498-f18a574ebc7e	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0027234554290771484	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1460	2026-10-08 18:17:32.396+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.00514531135559082	\N
1464	2026-10-08 18:19:07.056893+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0662689208984375	\N
1469	2026-10-08 18:19:07.129025+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.007460117340087891	\N
1470	2026-10-08 18:22:31.299236+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.06229805946350098	\N
1480	2026-10-08 18:22:45.535496+00	GET	/api/auth/me	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	401	0.001811981201171875	\N
1486	2026-10-08 18:24:49.489576+00	PATCH	/api/journal/de99b413-6a92-48c8-823d-17d0e2ed6b07	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.04304027557373047	2b3f77bc-0f82-4c55-aa05-41d12db6b770
1490	2026-10-08 18:24:50.986697+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.032204389572143555	2b3f77bc-0f82-4c55-aa05-41d12db6b770
1496	2026-10-08 18:24:59.841142+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.010674476623535156	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1498	2026-10-08 18:25:05.425493+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.011461734771728516	2b3f77bc-0f82-4c55-aa05-41d12db6b770
1499	2026-10-08 18:25:05.443005+00	GET	/api/auth/me	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0036063194274902344	2b3f77bc-0f82-4c55-aa05-41d12db6b770
1696	2026-10-08 20:19:07.343583+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.02504134178161621	2b3f77bc-0f82-4c55-aa05-41d12db6b770
1137	2026-10-08 17:04:33.999883+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0045757293701171875	\N
1138	2026-10-08 17:04:34.000301+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.002078533172607422	\N
1142	2026-10-08 17:04:34.972583+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.02179241180419922	\N
1144	2026-10-08 17:04:34.996924+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.09406495094299316	\N
1147	2026-10-08 17:25:47.474257+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.026694297790527344	\N
1148	2026-10-08 17:25:48.822616+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.010124444961547852	\N
1152	2026-10-08 17:29:18.242737+00	POST	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.0272219181060791	\N
1153	2026-10-08 17:29:32.238164+00	POST	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.021826982498168945	\N
1157	2026-10-08 17:30:14.860801+00	POST	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.002112865447998047	\N
1158	2026-10-08 17:30:37.985884+00	POST	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.02619791030883789	\N
1162	2026-10-08 17:31:16.492665+00	POST	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.01934528350830078	\N
1163	2026-10-08 17:31:28.566983+00	POST	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.02036285400390625	\N
1167	2026-10-08 17:32:04.849147+00	POST	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.012071609497070312	\N
1168	2026-10-08 17:32:13.096443+00	POST	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.01094198226928711	\N
1172	2026-10-08 17:32:56.256592+00	POST	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.01414799690246582	\N
1173	2026-10-08 17:33:03.523524+00	POST	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.015023469924926758	\N
1177	2026-10-08 17:33:44.379639+00	POST	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.012403488159179688	\N
1178	2026-10-08 17:33:52.811405+00	POST	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.015052556991577148	\N
1182	2026-10-08 17:34:35.245633+00	POST	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.018430233001708984	\N
1183	2026-10-08 17:34:40.219581+00	POST	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.002779722213745117	\N
1187	2026-10-08 17:34:59.293425+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.002156972885131836	\N
1188	2026-10-08 17:34:59.328916+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.001535177230834961	\N
1192	2026-10-08 17:35:03.678537+00	GET	/api/users	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.010179281234741211	\N
1193	2026-10-08 17:35:03.680669+00	GET	/api/users	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.009105205535888672	\N
1197	2026-10-08 17:35:09.667848+00	GET	/api/users	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.0048236846923828125	\N
1199	2026-10-08 17:35:10.614724+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.002440214157104492	\N
1202	2026-10-08 17:35:32.074243+00	POST	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.03402376174926758	\N
1203	2026-10-08 17:35:54.85055+00	POST	/api/auth/login	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.2871837615966797	\N
1205	2026-10-08 17:35:54.972222+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0029001235961914062	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1207	2026-10-08 17:35:57.822026+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.06317281723022461	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1208	2026-10-08 17:35:58.731479+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.03518104553222656	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1210	2026-10-08 17:36:12.031269+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.027671337127685547	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1213	2026-10-08 17:36:21.978824+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.008978128433227539	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1215	2026-10-08 17:36:22.761369+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.014086246490478516	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1217	2026-10-08 17:36:25.334258+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.019789457321166992	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1219	2026-10-08 17:36:26.116839+00	GET	/api/users	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.007506370544433594	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1221	2026-10-08 17:36:28.041804+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0034537315368652344	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1223	2026-10-08 17:36:29.883615+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0031206607818603516	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1225	2026-10-08 17:36:31.81876+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.005986690521240234	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1228	2026-10-08 17:36:44.364261+00	PATCH	/api/journal/e1b9db18-3f6f-41c4-8498-f18a574ebc7e	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.027156352996826172	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1254	2026-10-08 17:37:18.633095+00	POST	/api/upload	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	201	0.08121919631958008	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
1468	2026-10-08 18:19:07.106075+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.028555870056152344	\N
1478	2026-10-08 18:22:43.330664+00	GET	/api/auth/me	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	401	0.000568389892578125	\N
2414	2026-10-08 22:31:55.917262+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	401	0.03360700607299805	\N
2417	2026-10-08 22:31:55.939522+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.003067493438720703	\N
2419	2026-10-09 04:13:25.582386+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.029082059860229492	\N
2430	2026-10-09 05:20:26.814476+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	401	0.028399944305419922	\N
2433	2026-10-09 05:20:26.838317+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.003445863723754883	\N
2435	2026-10-09 05:51:37.590851+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.005209684371948242	\N
2438	2026-10-09 09:02:31.857247+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	401	0.03293418884277344	\N
2446	2026-10-09 09:15:35.710504+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	401	0.017420291900634766	\N
2449	2026-10-09 09:15:35.73044+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0036613941192626953	\N
2451	2026-10-09 10:27:18.857348+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.006199359893798828	\N
2453	2026-10-09 10:27:26.365283+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.003241300582885742	\N
2455	2026-10-09 10:27:39.85226+00	GET	/api/sessions/8431bdef-789a-4a8e-a151-76ca4ff740db	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.004292488098144531	\N
2464	2026-10-09 10:31:42.023724+00	GET	/api/sessions/8431bdef-789a-4a8e-a151-76ca4ff740db	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.02541375160217285	\N
2468	2026-10-09 10:31:45.115102+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.011487483978271484	\N
2470	2026-10-09 10:31:45.126175+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.002323150634765625	\N
2481	2026-10-09 10:38:24.818879+00	GET	/api/users	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.0014240741729736328	\N
2485	2026-10-09 10:38:28.086341+00	GET	/api/users	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.00761723518371582	\N
2490	2026-10-09 10:39:10.591716+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.01125478744506836	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2494	2026-10-09 10:39:14.215194+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.036878347396850586	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2496	2026-10-09 10:39:16.376811+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.007265567779541016	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2501	2026-10-09 10:39:24.285376+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.009371280670166016	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2503	2026-10-09 10:39:24.314583+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.007992267608642578	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2505	2026-10-09 10:39:36.03738+00	GET	/api/sessions/f29b7e3c-59c5-4380-9af4-96cec59b69bd	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.028361797332763672	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2514	2026-10-09 10:47:45.562823+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.09199810028076172	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2524	2026-10-09 10:51:04.073183+00	GET	/api/journal/public	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.03696799278259277	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2528	2026-10-09 10:51:14.12028+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.012317180633544922	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2565	2026-10-09 10:57:33.210841+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.009282827377319336	\N
2798	2026-10-09 12:04:24.380111+00	GET	/api/sessions/69ecae62-4eb7-4398-aa87-03fc4c305acc	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.05621647834777832	\N
2804	2026-10-09 12:09:25.879902+00	GET	/api/users	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.013625383377075195	\N
2810	2026-10-09 12:09:47.057091+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.06768679618835449	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2812	2026-10-09 12:09:47.492807+00	GET	/api/users	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.013747215270996094	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2818	2026-10-09 12:10:16.3766+00	GET	/api/session-interests	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	401	0.04111027717590332	\N
2955	2026-10-09 12:20:14.14948+00	GET	/api/journal/public	127.0.0.1	python-httpx/0.28.1	200	0.006740570068359375	\N
2956	2026-10-09 12:20:14.392267+00	POST	/api/auth/login	127.0.0.1	python-httpx/0.28.1	200	0.23616385459899902	\N
2957	2026-10-09 12:20:14.416431+00	POST	/api/sessions	127.0.0.1	python-httpx/0.28.1	201	0.021554231643676758	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2958	2026-10-09 12:20:14.422242+00	POST	/api/sessions/a26ebec1-d582-422f-9b17-f357810d56f6/publish	127.0.0.1	python-httpx/0.28.1	200	0.003711223602294922	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2959	2026-10-09 12:20:14.427116+00	POST	/api/sessions/a26ebec1-d582-422f-9b17-f357810d56f6/complete	127.0.0.1	python-httpx/0.28.1	200	0.0026307106018066406	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2961	2026-10-09 12:20:14.434359+00	GET	/api/sessions/a26ebec1-d582-422f-9b17-f357810d56f6	127.0.0.1	python-httpx/0.28.1	200	0.0008904933929443359	\N
2962	2026-10-09 12:20:14.438676+00	PATCH	/api/sessions/a26ebec1-d582-422f-9b17-f357810d56f6	127.0.0.1	python-httpx/0.28.1	200	0.002909421920776367	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2963	2026-10-09 12:20:14.442797+00	POST	/api/sessions/a26ebec1-d582-422f-9b17-f357810d56f6/publish-studio	127.0.0.1	python-httpx/0.28.1	200	0.002368927001953125	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2964	2026-10-09 12:20:14.445926+00	POST	/api/sessions/a26ebec1-d582-422f-9b17-f357810d56f6/unpublish-studio	127.0.0.1	python-httpx/0.28.1	200	0.0018367767333984375	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2973	2026-10-09 12:20:14.719811+00	GET	/api/sessions	127.0.0.1	python-httpx/0.28.1	200	0.002043008804321289	\N
2415	2026-10-08 22:31:55.926243+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.028758525848388672	\N
2422	2026-10-09 04:13:43.632539+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.020508289337158203	\N
2425	2026-10-09 04:13:44.791682+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	401	0.0006685256958007812	\N
2436	2026-10-09 05:51:38.169855+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	401	0.0015459060668945312	\N
2799	2026-10-09 12:04:24.415577+00	GET	/api/sessions/69ecae62-4eb7-4398-aa87-03fc4c305acc	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.011157751083374023	\N
2806	2026-10-09 12:09:38.792931+00	GET	/api/session-interests	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	401	0.0008974075317382812	\N
2977	2026-10-09 12:20:14.981361+00	GET	/api/session-interests	127.0.0.1	python-httpx/0.28.1	200	0.004141569137573242	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2980	2026-10-09 12:20:14.995334+00	DELETE	/api/session-interests/9b05cf8d-febb-4ef4-b1bf-4a2d934f10d3	127.0.0.1	python-httpx/0.28.1	204	0.002128124237060547	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2981	2026-10-09 12:20:15.000041+00	GET	/api/session-interests/9b05cf8d-febb-4ef4-b1bf-4a2d934f10d3	127.0.0.1	python-httpx/0.28.1	404	0.0026502609252929688	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2983	2026-10-09 12:20:15.315413+00	POST	/api/upload	127.0.0.1	python-httpx/0.28.1	201	0.003959178924560547	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2985	2026-10-09 12:20:15.32325+00	POST	/api/upload	127.0.0.1	python-httpx/0.28.1	400	0.001617431640625	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
3112	2026-10-09 20:54:33.5802+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.1418170928955078	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
3115	2026-10-09 21:20:12.721792+00	GET	/api/session-interests	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	401	0.08221292495727539	\N
3121	2026-10-09 21:20:53.542362+00	GET	/api/session-interests	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	401	0.0016498565673828125	\N
3126	2026-10-09 21:24:10.827804+00	GET	/api/session-interests	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	401	0.0005764961242675781	\N
3128	2026-10-09 21:29:06.999698+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.43428492546081543	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
3142	2026-10-09 21:29:25.17807+00	GET	/api/journal/public	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0074138641357421875	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
3144	2026-10-09 21:30:24.452655+00	GET	/api/journal/public	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.007332563400268555	\N
3146	2026-10-09 21:30:36.42736+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.003381967544555664	\N
3148	2026-10-09 21:30:40.052193+00	GET	/api/journal/public	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.009176492691040039	\N
3149	2026-10-09 21:30:45.156908+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.01817774772644043	\N
3196	2026-10-09 22:07:14.006978+00	GET	/api/session-interests	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	401	0.0908956527709961	\N
3224	2026-10-10 07:24:31.475263+00	GET	/api/session-interests	127.0.0.1	python-httpx/0.28.1	401	0.0010900497436523438	\N
3225	2026-10-10 07:24:31.729187+00	POST	/api/auth/login	127.0.0.1	python-httpx/0.28.1	200	0.24789834022521973	\N
3227	2026-10-10 07:24:31.740023+00	GET	/api/session-interests	127.0.0.1	python-httpx/0.28.1	200	0.003256559371948242	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
3228	2026-10-10 07:24:31.745943+00	PATCH	/api/session-interests/0a6c67d6-6ede-4842-b6a8-379cf41b4d9e	127.0.0.1	python-httpx/0.28.1	200	0.0034825801849365234	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
3231	2026-10-10 07:24:31.991369+00	POST	/api/auth/login	127.0.0.1	python-httpx/0.28.1	200	0.2355794906616211	\N
3233	2026-10-10 07:24:32.001018+00	POST	/api/upload/multiple	127.0.0.1	python-httpx/0.28.1	201	0.002402067184448242	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2416	2026-10-08 22:31:55.937396+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	401	0.0019147396087646484	\N
2420	2026-10-09 04:13:25.587432+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	401	0.0009698867797851562	\N
2427	2026-10-09 04:53:00.582565+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.019881725311279297	\N
2434	2026-10-09 05:51:37.563396+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.02856135368347168	\N
2437	2026-10-09 05:51:38.176901+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	401	0.00067138671875	\N
2440	2026-10-09 09:02:31.895927+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	401	0.0013108253479003906	\N
2443	2026-10-09 09:15:17.369951+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.031182527542114258	\N
2450	2026-10-09 10:27:18.836173+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.06418514251708984	\N
2452	2026-10-09 10:27:26.355094+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.027469873428344727	\N
2454	2026-10-09 10:27:39.841009+00	GET	/api/sessions/8431bdef-789a-4a8e-a151-76ca4ff740db	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.050673484802246094	\N
2800	2026-10-09 12:08:27.025608+00	POST	/api/session-interests	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	201	0.19753122329711914	\N
2802	2026-10-09 12:09:24.557283+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.10018754005432129	\N
2803	2026-10-09 12:09:25.881834+00	GET	/api/users	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.017368793487548828	\N
2807	2026-10-09 12:09:43.87932+00	POST	/api/auth/login	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.3102583885192871	\N
2809	2026-10-09 12:09:44.038852+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0028488636016845703	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2811	2026-10-09 12:09:47.057619+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.05573081970214844	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2815	2026-10-09 12:09:48.572922+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0920267105102539	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2816	2026-10-09 12:09:50.008084+00	GET	/api/session-interests	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.24012446403503418	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2996	2026-10-09 12:46:34.100602+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.04355311393737793	\N
3007	2026-10-09 12:46:49.886458+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.019131183624267578	\N
3012	2026-10-09 12:46:50.893174+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.00693821907043457	\N
3014	2026-10-09 12:46:53.298901+00	GET	/api/journal/public	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.03504157066345215	\N
3016	2026-10-09 12:46:56.903011+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.007972002029418945	\N
3018	2026-10-09 12:48:20.63475+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.022881507873535156	\N
3020	2026-10-09 12:48:29.191076+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.04001665115356445	\N
3022	2026-10-09 12:48:30.906084+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.011836528778076172	\N
3024	2026-10-09 12:48:37.101637+00	GET	/api/sessions/6181c511-10b9-4bff-b8f4-164d7db901ba	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.03721308708190918	\N
3026	2026-10-09 12:48:39.063886+00	GET	/api/sessions/6181c511-10b9-4bff-b8f4-164d7db901ba	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.005468130111694336	\N
3028	2026-10-09 12:48:44.666907+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.05269026756286621	\N
3030	2026-10-09 12:48:48.747024+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.03023552894592285	\N
3032	2026-10-09 12:48:51.422371+00	GET	/api/sessions/6181c511-10b9-4bff-b8f4-164d7db901ba	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.03354501724243164	\N
3034	2026-10-09 13:14:40.583563+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	401	0.1461479663848877	\N
3037	2026-10-09 13:14:40.664552+00	GET	/api/sessions/6181c511-10b9-4bff-b8f4-164d7db901ba	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.012514591217041016	\N
3141	2026-10-09 21:29:25.157674+00	GET	/api/journal/public	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.03093242645263672	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
3143	2026-10-09 21:30:24.436867+00	GET	/api/journal/public	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.07818198204040527	\N
3145	2026-10-09 21:30:36.410555+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.027297258377075195	\N
3147	2026-10-09 21:30:40.035297+00	GET	/api/journal/public	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.02738022804260254	\N
2418	2026-10-09 04:13:25.568697+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	401	0.03468608856201172	\N
2421	2026-10-09 04:13:25.592163+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.003902435302734375	\N
2423	2026-10-09 04:13:43.642451+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0028324127197265625	\N
2426	2026-10-09 04:53:00.577659+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	401	0.02103424072265625	\N
2429	2026-10-09 04:53:00.600475+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0032355785369873047	\N
2432	2026-10-09 05:20:26.833174+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	401	0.0008265972137451172	\N
2439	2026-10-09 09:02:31.8816+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.1333160400390625	\N
2441	2026-10-09 09:02:31.900203+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0052776336669921875	\N
2444	2026-10-09 09:15:17.385042+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	401	0.0012314319610595703	\N
2447	2026-10-09 09:15:35.716167+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.019839048385620117	\N
2801	2026-10-09 12:09:24.555445+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.08847355842590332	\N
2805	2026-10-09 12:09:38.77631+00	GET	/api/session-interests	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	401	0.013262748718261719	\N
2808	2026-10-09 12:09:44.024251+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.014743804931640625	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2813	2026-10-09 12:09:47.494026+00	GET	/api/users	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.015287637710571289	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2814	2026-10-09 12:09:48.533502+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.05067896842956543	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2997	2026-10-09 12:46:34.142436+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0015716552734375	\N
3009	2026-10-09 12:46:49.93856+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.020390987396240234	\N
3040	2026-10-09 13:16:50.526845+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	401	0.0006926059722900391	\N
3150	2026-10-09 21:30:45.158602+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.024477481842041016	\N
3155	2026-10-09 21:31:12.427681+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.022490739822387695	\N
3157	2026-10-09 21:31:12.921259+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0058977603912353516	\N
3159	2026-10-09 21:47:12.194557+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.12481164932250977	\N
3197	2026-10-09 22:07:14.049337+00	GET	/api/session-interests	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	401	0.0005872249603271484	\N
3229	2026-10-10 07:24:31.749447+00	DELETE	/api/session-interests/0a6c67d6-6ede-4842-b6a8-379cf41b4d9e	127.0.0.1	python-httpx/0.28.1	204	0.002244710922241211	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
3230	2026-10-10 07:24:31.751974+00	GET	/api/session-interests/0a6c67d6-6ede-4842-b6a8-379cf41b4d9e	127.0.0.1	python-httpx/0.28.1	404	0.0011343955993652344	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
3232	2026-10-10 07:24:31.996332+00	POST	/api/upload	127.0.0.1	python-httpx/0.28.1	201	0.0024862289428710938	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
3234	2026-10-10 07:24:32.003732+00	POST	/api/upload	127.0.0.1	python-httpx/0.28.1	400	0.0013346672058105469	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2424	2026-10-09 04:13:44.776055+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	401	0.011215686798095703	\N
2428	2026-10-09 04:53:00.590823+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	401	0.002424955368041992	\N
2431	2026-10-09 05:20:26.824496+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.023583650588989258	\N
2442	2026-10-09 09:15:17.356052+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	401	0.03286123275756836	\N
2445	2026-10-09 09:15:17.391817+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.005301713943481445	\N
2448	2026-10-09 09:15:35.723123+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	401	0.0010662078857421875	\N
2460	2026-10-09 10:31:39.84253+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.10094094276428223	\N
2457	2026-10-09 10:31:39.842846+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.09444785118103027	\N
2456	2026-10-09 10:31:39.842997+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0913848876953125	\N
2459	2026-10-09 10:31:39.842279+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.09679508209228516	\N
2458	2026-10-09 10:31:39.848423+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.195662260055542	\N
2461	2026-10-09 10:31:39.905474+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.1741032600402832	\N
2462	2026-10-09 10:31:40.775963+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.00464177131652832	\N
2463	2026-10-09 10:31:40.791051+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.019602298736572266	\N
2465	2026-10-09 10:31:42.028204+00	GET	/api/sessions/8431bdef-789a-4a8e-a151-76ca4ff740db	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.03822040557861328	\N
2466	2026-10-09 10:31:45.087289+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.04325079917907715	\N
2467	2026-10-09 10:31:45.087998+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.04277539253234863	\N
2469	2026-10-09 10:31:45.116126+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.012476205825805664	\N
2471	2026-10-09 10:31:45.152507+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.04859781265258789	\N
2472	2026-10-09 10:31:46.56961+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.019290447235107422	\N
2473	2026-10-09 10:31:46.574918+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0015969276428222656	\N
2474	2026-10-09 10:31:47.767688+00	GET	/api/sessions/f29b7e3c-59c5-4380-9af4-96cec59b69bd	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.021872282028198242	\N
2475	2026-10-09 10:31:47.76793+00	GET	/api/sessions/f29b7e3c-59c5-4380-9af4-96cec59b69bd	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.028644084930419922	\N
2476	2026-10-09 10:38:20.458652+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.021097183227539062	\N
2477	2026-10-09 10:38:20.461537+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.026392698287963867	\N
2478	2026-10-09 10:38:24.40598+00	GET	/api/audit	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.0031769275665283203	\N
2479	2026-10-09 10:38:24.405122+00	GET	/api/audit	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.005578041076660156	\N
2480	2026-10-09 10:38:24.818053+00	GET	/api/users	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.016623973846435547	\N
2482	2026-10-09 10:38:25.594157+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.003405332565307617	\N
2483	2026-10-09 10:38:25.593196+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.0024094581604003906	\N
2484	2026-10-09 10:38:28.085365+00	GET	/api/users	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.004469394683837891	\N
2486	2026-10-09 10:38:39.318306+00	POST	/api/auth/login	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.07101225852966309	\N
2487	2026-10-09 10:38:58.496511+00	POST	/api/auth/login	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.2892112731933594	\N
2488	2026-10-09 10:39:02.873811+00	POST	/api/auth/login	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.29039788246154785	\N
2489	2026-10-09 10:39:10.502423+00	POST	/api/auth/login	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.301483154296875	\N
2491	2026-10-09 10:39:10.612734+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.00805044174194336	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2492	2026-10-09 10:39:13.200228+00	GET	/api/users	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.008839607238769531	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2493	2026-10-09 10:39:13.199815+00	GET	/api/users	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.015870332717895508	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2495	2026-10-09 10:39:14.216205+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.03897500038146973	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2497	2026-10-09 10:39:16.383944+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0026900768280029297	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2498	2026-10-09 10:39:24.24694+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.011500358581542969	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2499	2026-10-09 10:39:24.247575+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.011473655700683594	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2536	2026-10-09 10:56:46.581519+00	POST	/api/auth/login	127.0.0.1	python-httpx/0.28.1	200	0.2848665714263916	\N
2500	2026-10-09 10:39:24.2812+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.008655548095703125	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2502	2026-10-09 10:39:24.2928+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.04705548286437988	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2512	2026-10-09 10:47:45.523347+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.042498111724853516	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2513	2026-10-09 10:47:45.562266+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.09208917617797852	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2519	2026-10-09 10:47:48.839326+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.02799510955810547	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2527	2026-10-09 10:51:10.089373+00	GET	/api/journal/dda23ea8-273a-4cdb-8960-59331db60cfa	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.028269052505493164	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2529	2026-10-09 10:51:14.120828+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.013409137725830078	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2530	2026-10-09 10:51:15.790174+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.01487874984741211	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2535	2026-10-09 10:53:48.849222+00	GET	/api/sessions/8431bdef-789a-4a8e-a151-76ca4ff740db	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.003876209259033203	\N
2563	2026-10-09 10:57:33.162356+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.011896133422851562	\N
2568	2026-10-09 10:57:33.227691+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0020432472229003906	\N
2570	2026-10-09 10:59:01.911401+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0037271976470947266	\N
2572	2026-10-09 10:59:18.347064+00	GET	/api/sessions/f29b7e3c-59c5-4380-9af4-96cec59b69bd	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0047419071197509766	\N
2574	2026-10-09 11:00:07.86984+00	GET	/api/sessions/1bc6dfe0-cc1d-4446-995b-64c17d34623f	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0021593570709228516	\N
2576	2026-10-09 11:00:50.647793+00	GET	/api/sessions/8431bdef-789a-4a8e-a151-76ca4ff740db	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.005989789962768555	\N
2578	2026-10-09 11:01:48.748146+00	GET	/api/sessions/f29b7e3c-59c5-4380-9af4-96cec59b69bd	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0024521350860595703	\N
2580	2026-10-09 11:04:50.892434+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.003598451614379883	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2582	2026-10-09 11:04:51.759442+00	GET	/api/sessions/f29b7e3c-59c5-4380-9af4-96cec59b69bd	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.006720542907714844	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2583	2026-10-09 11:04:55.620367+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.009952783584594727	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2817	2026-10-09 12:09:50.0071+00	GET	/api/session-interests	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.23852992057800293	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
3010	2026-10-09 12:46:49.930461+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.016958236694335938	\N
3038	2026-10-09 13:16:50.50869+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	401	0.006049633026123047	\N
3041	2026-10-09 13:16:50.532271+00	GET	/api/sessions/6181c511-10b9-4bff-b8f4-164d7db901ba	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.006992816925048828	\N
3151	2026-10-09 21:30:45.231144+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.013864755630493164	\N
2504	2026-10-09 10:39:35.999412+00	GET	/api/sessions/f29b7e3c-59c5-4380-9af4-96cec59b69bd	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0175628662109375	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2506	2026-10-09 10:40:33.546962+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.03967094421386719	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2507	2026-10-09 10:40:33.547326+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.1129302978515625	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2508	2026-10-09 10:40:33.548914+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.07094168663024902	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2509	2026-10-09 10:40:33.549193+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.026520967483520508	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2510	2026-10-09 10:40:33.551099+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.04020094871520996	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2511	2026-10-09 10:40:33.586696+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.022725582122802734	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2515	2026-10-09 10:47:45.574319+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0030956268310546875	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2516	2026-10-09 10:47:45.579352+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.010228633880615234	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2517	2026-10-09 10:47:45.582324+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.03683185577392578	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2518	2026-10-09 10:47:48.838459+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.024305105209350586	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2520	2026-10-09 10:47:49.704146+00	GET	/api/sessions/f29b7e3c-59c5-4380-9af4-96cec59b69bd	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.006797313690185547	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2521	2026-10-09 10:47:49.711481+00	GET	/api/sessions/f29b7e3c-59c5-4380-9af4-96cec59b69bd	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.001981973648071289	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2522	2026-10-09 10:50:37.606379+00	GET	/api/sessions/f29b7e3c-59c5-4380-9af4-96cec59b69bd	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.02568840980529785	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2523	2026-10-09 10:50:37.622281+00	GET	/api/sessions/f29b7e3c-59c5-4380-9af4-96cec59b69bd	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0030410289764404297	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2525	2026-10-09 10:51:04.07454+00	GET	/api/journal/public	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.04482388496398926	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2526	2026-10-09 10:51:10.0784+00	GET	/api/journal/dda23ea8-273a-4cdb-8960-59331db60cfa	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0164339542388916	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2531	2026-10-09 10:51:15.798931+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0025336742401123047	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2532	2026-10-09 10:52:07.2579+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.017021894454956055	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2533	2026-10-09 10:52:07.257368+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.022621631622314453	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2534	2026-10-09 10:53:48.835211+00	GET	/api/sessions/8431bdef-789a-4a8e-a151-76ca4ff740db	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.03931856155395508	\N
2564	2026-10-09 10:57:33.166349+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.02321338653564453	\N
2567	2026-10-09 10:57:33.221244+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.017204761505126953	\N
2569	2026-10-09 10:59:01.901615+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.044892311096191406	\N
2571	2026-10-09 10:59:18.336345+00	GET	/api/sessions/f29b7e3c-59c5-4380-9af4-96cec59b69bd	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.01907634735107422	\N
2573	2026-10-09 11:00:07.859377+00	GET	/api/sessions/1bc6dfe0-cc1d-4446-995b-64c17d34623f	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.027010440826416016	\N
2575	2026-10-09 11:00:50.630197+00	GET	/api/sessions/8431bdef-789a-4a8e-a151-76ca4ff740db	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.04532933235168457	\N
2577	2026-10-09 11:01:48.73087+00	GET	/api/sessions/f29b7e3c-59c5-4380-9af4-96cec59b69bd	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.01822352409362793	\N
2579	2026-10-09 11:04:50.87506+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.02004861831665039	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2581	2026-10-09 11:04:51.756075+00	GET	/api/sessions/f29b7e3c-59c5-4380-9af4-96cec59b69bd	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0073986053466796875	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2585	2026-10-09 11:04:56.702088+00	GET	/api/sessions/8431bdef-789a-4a8e-a151-76ca4ff740db	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.005097627639770508	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2587	2026-10-09 11:04:58.405881+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.01480722427368164	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2595	2026-10-09 11:05:08.874572+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.04401206970214844	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2596	2026-10-09 11:05:08.913145+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.026058435440063477	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2597	2026-10-09 11:30:58.836831+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.12906670570373535	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2598	2026-10-09 11:30:58.871022+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.010223388671875	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2599	2026-10-09 11:30:59.243072+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.011360883712768555	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2600	2026-10-09 11:30:59.250171+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0016260147094726562	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2601	2026-10-09 11:31:02.794926+00	GET	/api/journal/public	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.06878852844238281	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2539	2026-10-09 10:56:46.679273+00	POST	/api/journal/2a2e231e-4a5b-4386-913a-4603ddb2d7dc/approve	127.0.0.1	python-httpx/0.28.1	200	0.0030791759490966797	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2545	2026-10-09 10:56:46.997276+00	GET	/api/sessions	127.0.0.1	python-httpx/0.28.1	200	0.0028455257415771484	\N
2550	2026-10-09 10:56:47.016205+00	DELETE	/api/sessions/5bafcb08-0672-4258-8024-df01e55aed6d	127.0.0.1	python-httpx/0.28.1	204	0.0019578933715820312	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2551	2026-10-09 10:56:47.018451+00	GET	/api/sessions/5bafcb08-0672-4258-8024-df01e55aed6d	127.0.0.1	python-httpx/0.28.1	404	0.0008544921875	\N
2552	2026-10-09 10:56:47.266136+00	POST	/api/auth/login	127.0.0.1	python-httpx/0.28.1	200	0.24413299560546875	\N
2553	2026-10-09 10:56:47.274155+00	POST	/api/sessions	127.0.0.1	python-httpx/0.28.1	201	0.004796028137207031	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2554	2026-10-09 10:56:47.27825+00	POST	/api/sessions/a1506e72-50af-429e-b054-7c03bbe549d8/publish	127.0.0.1	python-httpx/0.28.1	200	0.002323150634765625	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2555	2026-10-09 10:56:47.2824+00	POST	/api/sessions/a1506e72-50af-429e-b054-7c03bbe549d8/complete-and-document	127.0.0.1	python-httpx/0.28.1	200	0.0028409957885742188	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2556	2026-10-09 10:56:47.287284+00	PATCH	/api/sessions/a1506e72-50af-429e-b054-7c03bbe549d8/documentation	127.0.0.1	python-httpx/0.28.1	200	0.0034973621368408203	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2557	2026-10-09 10:56:47.292315+00	POST	/api/sessions/a1506e72-50af-429e-b054-7c03bbe549d8/publish-studio	127.0.0.1	python-httpx/0.28.1	200	0.0023322105407714844	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2560	2026-10-09 10:56:47.543761+00	POST	/api/upload	127.0.0.1	python-httpx/0.28.1	201	0.002624034881591797	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2562	2026-10-09 10:56:47.550558+00	POST	/api/upload	127.0.0.1	python-httpx/0.28.1	400	0.0014705657958984375	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2820	2026-10-09 12:10:33.555478+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.13008880615234375	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2831	2026-10-09 12:10:46.887219+00	GET	/api/sessions/e630385a-5974-4a0f-862e-2e09c01440a6	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0048944950103759766	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2833	2026-10-09 12:10:48.817251+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.012142658233642578	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2837	2026-10-09 12:11:43.075395+00	GET	/api/sessions/f29b7e3c-59c5-4380-9af4-96cec59b69bd	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.024001121520996094	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2848	2026-10-09 12:11:52.471657+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.04153728485107422	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2861	2026-10-09 12:12:02.734544+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.007710695266723633	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2865	2026-10-09 12:12:09.334036+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.04302716255187988	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2873	2026-10-09 12:12:31.767746+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.10303926467895508	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2881	2026-10-09 12:12:52.16129+00	POST	/api/session-interests	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	201	0.051180124282836914	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2882	2026-10-09 12:12:53.907115+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.005715608596801758	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2932	2026-10-09 12:14:10.273207+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.05997967720031738	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2937	2026-10-09 12:14:38.254929+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.05576443672180176	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2939	2026-10-09 12:14:39.267684+00	GET	/api/sessions/6181c511-10b9-4bff-b8f4-164d7db901ba	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0064661502838134766	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2944	2026-10-09 12:15:53.226536+00	GET	/api/journal/e1b9db18-3f6f-41c4-8498-f18a574ebc7e	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.10010361671447754	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2988	2026-10-09 12:46:31.97244+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	401	0.0019698143005371094	\N
2995	2026-10-09 12:46:34.101947+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.028243064880371094	\N
3042	2026-10-09 13:28:35.737345+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	401	0.008540153503417969	\N
3045	2026-10-09 13:28:35.772892+00	GET	/api/sessions/6181c511-10b9-4bff-b8f4-164d7db901ba	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.005539894104003906	\N
3048	2026-10-09 13:33:53.546433+00	GET	/api/sessions/6181c511-10b9-4bff-b8f4-164d7db901ba	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.009178400039672852	\N
3050	2026-10-09 13:33:57.643909+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	401	0.004189252853393555	\N
3052	2026-10-09 13:33:57.661637+00	GET	/api/sessions/6181c511-10b9-4bff-b8f4-164d7db901ba	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.003583192825317383	\N
3055	2026-10-09 13:34:05.236927+00	GET	/api/sessions/6181c511-10b9-4bff-b8f4-164d7db901ba	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.023172616958618164	\N
3062	2026-10-09 13:35:25.038442+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	401	0.006490945816040039	\N
3065	2026-10-09 13:35:25.057479+00	GET	/api/sessions/6181c511-10b9-4bff-b8f4-164d7db901ba	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.002979755401611328	\N
3072	2026-10-09 13:36:01.279049+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	401	0.0005247592926025391	\N
3075	2026-10-09 13:36:02.403616+00	GET	/api/sessions/6181c511-10b9-4bff-b8f4-164d7db901ba	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.03314661979675293	\N
3083	2026-10-09 20:32:19.316871+00	GET	/api/session-interests	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	401	0.0007774829864501953	\N
3087	2026-10-09 20:32:26.433002+00	GET	/api/users	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.002905607223510742	\N
3153	2026-10-09 21:30:45.236077+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.017612218856811523	\N
2543	2026-10-09 10:56:46.988328+00	POST	/api/sessions/5bafcb08-0672-4258-8024-df01e55aed6d/publish	127.0.0.1	python-httpx/0.28.1	200	0.00471806526184082	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2544	2026-10-09 10:56:46.992884+00	POST	/api/sessions/5bafcb08-0672-4258-8024-df01e55aed6d/complete	127.0.0.1	python-httpx/0.28.1	200	0.002779245376586914	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2546	2026-10-09 10:56:47.000325+00	GET	/api/sessions/5bafcb08-0672-4258-8024-df01e55aed6d	127.0.0.1	python-httpx/0.28.1	200	0.001117706298828125	\N
2547	2026-10-09 10:56:47.00585+00	PATCH	/api/sessions/5bafcb08-0672-4258-8024-df01e55aed6d	127.0.0.1	python-httpx/0.28.1	200	0.003828763961791992	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2548	2026-10-09 10:56:47.009665+00	POST	/api/sessions/5bafcb08-0672-4258-8024-df01e55aed6d/publish-studio	127.0.0.1	python-httpx/0.28.1	200	0.0024080276489257812	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2549	2026-10-09 10:56:47.012949+00	POST	/api/sessions/5bafcb08-0672-4258-8024-df01e55aed6d/unpublish-studio	127.0.0.1	python-httpx/0.28.1	200	0.0017726421356201172	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2558	2026-10-09 10:56:47.296049+00	GET	/api/sessions	127.0.0.1	python-httpx/0.28.1	200	0.0024318695068359375	\N
2559	2026-10-09 10:56:47.538627+00	POST	/api/auth/login	127.0.0.1	python-httpx/0.28.1	200	0.2376723289489746	\N
2561	2026-10-09 10:56:47.547737+00	POST	/api/upload/multiple	127.0.0.1	python-httpx/0.28.1	201	0.0022497177124023438	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2566	2026-10-09 10:57:33.208788+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.048897743225097656	\N
2584	2026-10-09 11:04:55.619436+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.024158954620361328	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2586	2026-10-09 11:04:56.704181+00	GET	/api/sessions/8431bdef-789a-4a8e-a151-76ca4ff740db	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.007233381271362305	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2588	2026-10-09 11:04:58.414202+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.002740621566772461	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2590	2026-10-09 11:05:01.057319+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.04922747611999512	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2589	2026-10-09 11:05:01.055142+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.04633831977844238	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2591	2026-10-09 11:05:01.057795+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.022258758544921875	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2592	2026-10-09 11:05:01.073868+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.05006909370422363	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2593	2026-10-09 11:05:01.075702+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.07337141036987305	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2594	2026-10-09 11:05:01.14973+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0625309944152832	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2603	2026-10-09 11:31:04.956293+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.023810386657714844	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2608	2026-10-09 11:31:19.478737+00	GET	/api/audit	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.019340991973876953	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2610	2026-10-09 11:31:23.72898+00	GET	/api/users	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.006027698516845703	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2611	2026-10-09 11:31:24.163452+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.010182380676269531	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2612	2026-10-09 11:31:24.193051+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.03814101219177246	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2613	2026-10-09 11:31:26.042629+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.010903120040893555	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2614	2026-10-09 11:31:26.050781+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0026438236236572266	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2615	2026-10-09 11:32:15.684235+00	GET	/api/audit	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.08060145378112793	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2616	2026-10-09 11:32:15.705783+00	GET	/api/audit	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.008254051208496094	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2617	2026-10-09 11:32:16.501752+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.014301300048828125	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2618	2026-10-09 11:32:16.508527+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0033006668090820312	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2619	2026-10-09 11:32:16.885969+00	GET	/api/users	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0061151981353759766	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2620	2026-10-09 11:32:16.891273+00	GET	/api/users	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0024683475494384766	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2622	2026-10-09 11:32:17.722104+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0344851016998291	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2621	2026-10-09 11:32:17.723246+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.01580190658569336	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2623	2026-10-09 11:32:18.296006+00	GET	/api/users	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.008569955825805664	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2624	2026-10-09 11:32:18.296791+00	GET	/api/users	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.009257793426513672	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2625	2026-10-09 11:32:26.022789+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.031232833862304688	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2626	2026-10-09 11:32:26.043139+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.006404399871826172	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2627	2026-10-09 11:32:26.845983+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.04783821105957031	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2628	2026-10-09 11:32:26.931069+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.08828568458557129	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2631	2026-10-09 11:32:27.044937+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.20316767692565918	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2634	2026-10-09 11:32:28.405557+00	GET	/api/journal/public	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.07297849655151367	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2635	2026-10-09 11:32:32.199021+00	GET	/api/journal/de99b413-6a92-48c8-823d-17d0e2ed6b07	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.032454729080200195	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2636	2026-10-09 11:32:32.230364+00	GET	/api/journal/de99b413-6a92-48c8-823d-17d0e2ed6b07	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.04758930206298828	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2602	2026-10-09 11:31:02.835776+00	GET	/api/journal/public	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.029290437698364258	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2604	2026-10-09 11:31:04.95898+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.013812541961669922	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2606	2026-10-09 11:31:17.907629+00	GET	/api/users	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.023050546646118164	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2632	2026-10-09 11:32:27.052808+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.21057963371276855	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2643	2026-10-09 11:32:44.719214+00	GET	/api/journal/dda23ea8-273a-4cdb-8960-59331db60cfa	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.01414632797241211	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2648	2026-10-09 11:32:49.922778+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.03391838073730469	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2649	2026-10-09 11:32:55.724727+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.01772451400756836	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2655	2026-10-09 11:33:02.865489+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.03469085693359375	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2657	2026-10-09 11:33:03.983494+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.010451793670654297	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2662	2026-10-09 11:33:18.275119+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0026865005493164062	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2664	2026-10-09 11:33:19.900524+00	GET	/api/sessions/ccb9c8cd-e6a4-4efa-8d34-69095c43e387	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.023139238357543945	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2665	2026-10-09 11:33:29.40106+00	GET	/api/journal/public	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.02657628059387207	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2667	2026-10-09 11:33:30.117947+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.008797645568847656	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2821	2026-10-09 12:10:33.55092+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.08464264869689941	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2828	2026-10-09 12:10:41.80082+00	GET	/api/sessions/6181c511-10b9-4bff-b8f4-164d7db901ba	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.03518366813659668	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2830	2026-10-09 12:10:46.15042+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.014642477035522461	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2832	2026-10-09 12:10:46.912235+00	GET	/api/sessions/e630385a-5974-4a0f-862e-2e09c01440a6	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.028484344482421875	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2834	2026-10-09 12:10:48.828589+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.005259037017822266	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2836	2026-10-09 12:10:49.761718+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0077972412109375	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2838	2026-10-09 12:11:43.082159+00	GET	/api/sessions/f29b7e3c-59c5-4380-9af4-96cec59b69bd	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.08344149589538574	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2839	2026-10-09 12:11:46.675457+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.04844951629638672	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2841	2026-10-09 12:11:48.973238+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.03444218635559082	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2843	2026-10-09 12:11:49.736612+00	GET	/api/sessions/6181c511-10b9-4bff-b8f4-164d7db901ba	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.010517597198486328	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2845	2026-10-09 12:11:51.35892+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.05708742141723633	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
3043	2026-10-09 13:28:35.752159+00	GET	/api/sessions/6181c511-10b9-4bff-b8f4-164d7db901ba	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.06092405319213867	\N
3046	2026-10-09 13:33:53.384393+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	401	0.03843092918395996	\N
3049	2026-10-09 13:33:53.558501+00	GET	/api/sessions/6181c511-10b9-4bff-b8f4-164d7db901ba	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0036106109619140625	\N
3064	2026-10-09 13:35:25.055435+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	401	0.00201416015625	\N
3067	2026-10-09 13:35:37.036809+00	GET	/api/sessions/6181c511-10b9-4bff-b8f4-164d7db901ba	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.02069687843322754	\N
3074	2026-10-09 13:36:02.396871+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	401	0.0265963077545166	\N
3077	2026-10-09 13:36:02.417344+00	GET	/api/sessions/6181c511-10b9-4bff-b8f4-164d7db901ba	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0036809444427490234	\N
3089	2026-10-09 20:32:27.749933+00	GET	/api/audit	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.025463342666625977	\N
3161	2026-10-09 22:04:13.121967+00	POST	/api/auth/login	127.0.0.1	python-httpx/0.28.1	200	0.2836625576019287	\N
3162	2026-10-09 22:04:13.230595+00	POST	/api/journal	127.0.0.1	python-httpx/0.28.1	201	0.09172987937927246	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
3163	2026-10-09 22:04:13.239046+00	PATCH	/api/journal/e023448b-00a4-48fa-bbc9-1d9d53a29a1c	127.0.0.1	python-httpx/0.28.1	200	0.005506992340087891	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
3164	2026-10-09 22:04:13.24364+00	POST	/api/journal/e023448b-00a4-48fa-bbc9-1d9d53a29a1c/approve	127.0.0.1	python-httpx/0.28.1	200	0.0031461715698242188	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
3170	2026-10-09 22:04:13.540441+00	GET	/api/sessions	127.0.0.1	python-httpx/0.28.1	200	0.0032951831817626953	\N
3175	2026-10-09 22:04:13.55843+00	DELETE	/api/sessions/f830df8e-f5ee-4406-82e0-871e895cafbd	127.0.0.1	python-httpx/0.28.1	204	0.0027625560760498047	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
3176	2026-10-09 22:04:13.560474+00	GET	/api/sessions/f830df8e-f5ee-4406-82e0-871e895cafbd	127.0.0.1	python-httpx/0.28.1	404	0.0006163120269775391	\N
3177	2026-10-09 22:04:13.801795+00	POST	/api/auth/login	127.0.0.1	python-httpx/0.28.1	200	0.23852300643920898	\N
3178	2026-10-09 22:04:13.808246+00	POST	/api/sessions	127.0.0.1	python-httpx/0.28.1	201	0.003564596176147461	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
3179	2026-10-09 22:04:13.812137+00	POST	/api/sessions/348170d0-7ee2-40aa-9345-7929ba7da7e7/publish	127.0.0.1	python-httpx/0.28.1	200	0.002439260482788086	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2605	2026-10-09 11:31:17.90833+00	GET	/api/users	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.04125475883483887	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2607	2026-10-09 11:31:19.477368+00	GET	/api/audit	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.017917156219482422	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2609	2026-10-09 11:31:23.712683+00	GET	/api/users	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.01945185661315918	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2629	2026-10-09 11:32:26.981143+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.09270262718200684	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2630	2026-10-09 11:32:26.980447+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.07658576965332031	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2633	2026-10-09 11:32:28.318263+00	GET	/api/journal/public	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.028796911239624023	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2640	2026-10-09 11:32:41.423786+00	GET	/api/journal/e1b9db18-3f6f-41c4-8498-f18a574ebc7e	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.012057781219482422	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2646	2026-10-09 11:32:46.5985+00	GET	/api/journal/public	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.008608818054199219	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2650	2026-10-09 11:32:55.726406+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.01635289192199707	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2663	2026-10-09 11:33:19.900037+00	GET	/api/sessions/ccb9c8cd-e6a4-4efa-8d34-69095c43e387	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.02063918113708496	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2671	2026-10-09 11:33:32.108095+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.009953975677490234	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2819	2026-10-09 12:10:33.552336+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.21790027618408203	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2824	2026-10-09 12:10:33.620965+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.17670583724975586	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2835	2026-10-09 12:10:49.760581+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.006228208541870117	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2849	2026-10-09 12:11:52.591809+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.030271291732788086	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2864	2026-10-09 12:12:06.813894+00	GET	/api/sessions/e630385a-5974-4a0f-862e-2e09c01440a6	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0024232864379882812	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2866	2026-10-09 12:12:09.333358+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.04044222831726074	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2874	2026-10-09 12:12:31.768563+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.05032157897949219	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2878	2026-10-09 12:12:31.823236+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.00421905517578125	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2880	2026-10-09 12:12:35.133596+00	GET	/api/sessions/69ecae62-4eb7-4398-aa87-03fc4c305acc	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0043964385986328125	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
3044	2026-10-09 13:28:35.765026+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	401	0.0015494823455810547	\N
3051	2026-10-09 13:33:57.647302+00	GET	/api/sessions/6181c511-10b9-4bff-b8f4-164d7db901ba	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.02360677719116211	\N
3058	2026-10-09 13:35:22.034342+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	401	0.021665573120117188	\N
3061	2026-10-09 13:35:22.053531+00	GET	/api/sessions/6181c511-10b9-4bff-b8f4-164d7db901ba	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0038018226623535156	\N
3069	2026-10-09 13:35:37.04542+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	401	0.0007660388946533203	\N
3076	2026-10-09 13:36:02.415431+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	401	0.002378702163696289	\N
3079	2026-10-09 20:16:19.947421+00	GET	/api/sessions/6181c511-10b9-4bff-b8f4-164d7db901ba	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.10517501831054688	\N
3082	2026-10-09 20:32:19.304014+00	GET	/api/session-interests	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	401	0.01706671714782715	\N
3085	2026-10-09 20:32:24.764121+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.05064678192138672	\N
3088	2026-10-09 20:32:27.751112+00	GET	/api/audit	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.00493931770324707	\N
3091	2026-10-09 20:32:30.714173+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.005003213882446289	\N
3165	2026-10-09 22:04:13.251095+00	GET	/api/journal/public	127.0.0.1	python-httpx/0.28.1	200	0.006138324737548828	\N
3166	2026-10-09 22:04:13.498477+00	POST	/api/auth/login	127.0.0.1	python-httpx/0.28.1	200	0.2378230094909668	\N
3167	2026-10-09 22:04:13.525134+00	POST	/api/sessions	127.0.0.1	python-httpx/0.28.1	201	0.02398681640625	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
3168	2026-10-09 22:04:13.531591+00	POST	/api/sessions/f830df8e-f5ee-4406-82e0-871e895cafbd/publish	127.0.0.1	python-httpx/0.28.1	200	0.004091978073120117	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
3169	2026-10-09 22:04:13.535876+00	POST	/api/sessions/f830df8e-f5ee-4406-82e0-871e895cafbd/complete	127.0.0.1	python-httpx/0.28.1	200	0.002635955810546875	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
3171	2026-10-09 22:04:13.542682+00	GET	/api/sessions/f830df8e-f5ee-4406-82e0-871e895cafbd	127.0.0.1	python-httpx/0.28.1	200	0.0007143020629882812	\N
3172	2026-10-09 22:04:13.546818+00	PATCH	/api/sessions/f830df8e-f5ee-4406-82e0-871e895cafbd	127.0.0.1	python-httpx/0.28.1	200	0.0029397010803222656	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
3173	2026-10-09 22:04:13.551049+00	POST	/api/sessions/f830df8e-f5ee-4406-82e0-871e895cafbd/publish-studio	127.0.0.1	python-httpx/0.28.1	200	0.002447366714477539	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
3174	2026-10-09 22:04:13.554234+00	POST	/api/sessions/f830df8e-f5ee-4406-82e0-871e895cafbd/unpublish-studio	127.0.0.1	python-httpx/0.28.1	200	0.0019485950469970703	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
3183	2026-10-09 22:04:13.829191+00	GET	/api/sessions	127.0.0.1	python-httpx/0.28.1	200	0.002249002456665039	\N
3187	2026-10-09 22:04:14.088005+00	GET	/api/session-interests	127.0.0.1	python-httpx/0.28.1	200	0.0039033889770507812	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
3190	2026-10-09 22:04:14.101608+00	DELETE	/api/session-interests/496e6ad5-01b7-45b0-97ed-08fa84466560	127.0.0.1	python-httpx/0.28.1	204	0.0018391609191894531	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2637	2026-10-09 11:32:39.868+00	GET	/api/journal/public	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0216977596282959	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2642	2026-10-09 11:32:43.929468+00	GET	/api/journal/public	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.006550788879394531	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2644	2026-10-09 11:32:44.735517+00	GET	/api/journal/dda23ea8-273a-4cdb-8960-59331db60cfa	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.027727603912353516	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2645	2026-10-09 11:32:46.598877+00	GET	/api/journal/public	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.009021759033203125	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2647	2026-10-09 11:32:49.873823+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.03360557556152344	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2652	2026-10-09 11:32:55.748083+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.006031990051269531	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2654	2026-10-09 11:32:55.792973+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.005909442901611328	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2656	2026-10-09 11:33:02.946809+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.061748504638671875	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2658	2026-10-09 11:33:03.989477+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.002022981643676758	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2660	2026-10-09 11:33:16.28312+00	GET	/api/sessions/f29b7e3c-59c5-4380-9af4-96cec59b69bd	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.03580760955810547	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2670	2026-10-09 11:33:32.080825+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.026293277740478516	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2681	2026-10-09 11:33:38.98564+00	GET	/api/sessions/6181c511-10b9-4bff-b8f4-164d7db901ba	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.008571386337280273	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2822	2026-10-09 12:10:33.557972+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.1564040184020996	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2826	2026-10-09 12:10:40.92263+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0820472240447998	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2827	2026-10-09 12:10:41.757838+00	GET	/api/sessions/6181c511-10b9-4bff-b8f4-164d7db901ba	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.024715900421142578	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2829	2026-10-09 12:10:46.124768+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0272216796875	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2850	2026-10-09 12:11:52.605378+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.05291461944580078	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2852	2026-10-09 12:11:52.671212+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0031371116638183594	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2854	2026-10-09 12:11:53.103764+00	GET	/api/session-interests	127.0.0.1	python-httpx/0.28.1	200	0.04686594009399414	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2856	2026-10-09 12:11:54.68191+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.014468193054199219	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2858	2026-10-09 12:11:56.017938+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.005692005157470703	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2860	2026-10-09 12:11:56.663037+00	GET	/api/sessions/6181c511-10b9-4bff-b8f4-164d7db901ba	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.002847433090209961	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2862	2026-10-09 12:12:02.735112+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.02379441261291504	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2863	2026-10-09 12:12:06.804363+00	GET	/api/sessions/e630385a-5974-4a0f-862e-2e09c01440a6	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.022496461868286133	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2867	2026-10-09 12:12:09.36235+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.010474443435668945	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2875	2026-10-09 12:12:31.796923+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.005310773849487305	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2877	2026-10-09 12:12:31.812977+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0893399715423584	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2879	2026-10-09 12:12:35.112813+00	GET	/api/sessions/69ecae62-4eb7-4398-aa87-03fc4c305acc	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.030672550201416016	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2883	2026-10-09 12:12:53.908297+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.009291648864746094	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2888	2026-10-09 12:12:54.779772+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.007521867752075195	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2890	2026-10-09 12:12:57.482043+00	GET	/api/session-interests	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.012697219848632812	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2934	2026-10-09 12:14:10.330002+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.012339353561401367	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2941	2026-10-09 12:15:50.892624+00	GET	/api/journal/public	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.08446478843688965	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2943	2026-10-09 12:15:53.216829+00	GET	/api/journal/e1b9db18-3f6f-41c4-8498-f18a574ebc7e	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0852200984954834	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2945	2026-10-09 12:16:04.321294+00	GET	/api/journal/public	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.029988765716552734	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2947	2026-10-09 12:16:05.376244+00	GET	/api/journal/e1b9db18-3f6f-41c4-8498-f18a574ebc7e	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.00834035873413086	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2949	2026-10-09 12:16:13.689867+00	GET	/api/journal/public	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.02106332778930664	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2987	2026-10-09 12:46:30.573786+00	GET	/api/session-interests	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	401	0.001458883285522461	\N
2994	2026-10-09 12:46:34.085483+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.012111663818359375	\N
3047	2026-10-09 13:33:53.407401+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	401	0.0008544921875	\N
2638	2026-10-09 11:32:39.883151+00	GET	/api/journal/public	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.004811286926269531	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2639	2026-10-09 11:32:41.424199+00	GET	/api/journal/e1b9db18-3f6f-41c4-8498-f18a574ebc7e	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.007241249084472656	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2641	2026-10-09 11:32:43.914861+00	GET	/api/journal/public	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.027529478073120117	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2651	2026-10-09 11:32:55.747619+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.003534078598022461	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2653	2026-10-09 11:32:55.778018+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0624537467956543	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2659	2026-10-09 11:33:16.282346+00	GET	/api/sessions/f29b7e3c-59c5-4380-9af4-96cec59b69bd	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.027675628662109375	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2661	2026-10-09 11:33:18.26894+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.003980398178100586	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2666	2026-10-09 11:33:29.419971+00	GET	/api/journal/public	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.010986328125	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2668	2026-10-09 11:33:30.12344+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0019903182983398438	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2669	2026-10-09 11:33:32.079455+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.006080150604248047	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2672	2026-10-09 11:33:32.111352+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.013628005981445312	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2673	2026-10-09 11:33:32.109215+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.015248775482177734	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2674	2026-10-09 11:33:32.121648+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0019817352294921875	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2675	2026-10-09 11:33:33.683389+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0032951831817626953	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2676	2026-10-09 11:33:33.683735+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.00414586067199707	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2677	2026-10-09 11:33:36.442058+00	GET	/api/sessions/6181c511-10b9-4bff-b8f4-164d7db901ba	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.027428150177001953	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2678	2026-10-09 11:33:36.443075+00	GET	/api/sessions/6181c511-10b9-4bff-b8f4-164d7db901ba	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.031167268753051758	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2679	2026-10-09 11:33:37.3799+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.01308298110961914	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2680	2026-10-09 11:33:37.386883+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.003477334976196289	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2682	2026-10-09 11:33:39.003341+00	GET	/api/sessions/6181c511-10b9-4bff-b8f4-164d7db901ba	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0258634090423584	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2823	2026-10-09 12:10:33.560838+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.12729883193969727	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2825	2026-10-09 12:10:40.921815+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.07508111000061035	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2840	2026-10-09 12:11:46.705812+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.008958101272583008	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2842	2026-10-09 12:11:48.993708+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.007829666137695312	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2844	2026-10-09 12:11:49.743146+00	GET	/api/sessions/6181c511-10b9-4bff-b8f4-164d7db901ba	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0017032623291015625	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2846	2026-10-09 12:11:51.406502+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.011056900024414062	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2847	2026-10-09 12:11:52.470753+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.11657261848449707	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2853	2026-10-09 12:11:53.033149+00	POST	/api/auth/login	127.0.0.1	python-httpx/0.28.1	200	0.33240413665771484	\N
2855	2026-10-09 12:11:54.636565+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.05992317199707031	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2857	2026-10-09 12:11:56.001102+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.04092693328857422	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2859	2026-10-09 12:11:56.654698+00	GET	/api/sessions/6181c511-10b9-4bff-b8f4-164d7db901ba	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.004865407943725586	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2868	2026-10-09 12:12:09.363762+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.011945247650146484	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2870	2026-10-09 12:12:09.39847+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.004952430725097656	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2871	2026-10-09 12:12:13.13825+00	GET	/api/sessions/69ecae62-4eb7-4398-aa87-03fc4c305acc	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.012606382369995117	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2876	2026-10-09 12:12:31.799017+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.008306026458740234	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2884	2026-10-09 12:12:53.976261+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.022257566452026367	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2892	2026-10-09 12:13:11.412515+00	PATCH	/api/session-interests/cd16d902-a337-477f-a5d1-311b8a603aff	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.05504870414733887	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2895	2026-10-09 12:13:36.899546+00	PATCH	/api/session-interests/cd16d902-a337-477f-a5d1-311b8a603aff	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.1138603687286377	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2931	2026-10-09 12:14:10.270241+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.026984453201293945	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2990	2026-10-09 12:46:32.708705+00	GET	/api/users	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	401	0.0019412040710449219	\N
2992	2026-10-09 12:46:33.992759+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.21294379234313965	\N
2685	2026-10-09 11:51:59.528166+00	PATCH	/api/journal/416dfba8-449d-4d84-bf01-91c937bee744	127.0.0.1	python-httpx/0.28.1	200	0.007737636566162109	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2686	2026-10-09 11:51:59.534504+00	POST	/api/journal/416dfba8-449d-4d84-bf01-91c937bee744/approve	127.0.0.1	python-httpx/0.28.1	200	0.003647327423095703	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2692	2026-10-09 11:51:59.828153+00	GET	/api/sessions	127.0.0.1	python-httpx/0.28.1	200	0.002566814422607422	\N
2697	2026-10-09 11:51:59.846989+00	DELETE	/api/sessions/54650e85-9414-4379-a6ca-06e3b5cd65c2	127.0.0.1	python-httpx/0.28.1	204	0.0019674301147460938	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2698	2026-10-09 11:51:59.848838+00	GET	/api/sessions/54650e85-9414-4379-a6ca-06e3b5cd65c2	127.0.0.1	python-httpx/0.28.1	404	0.0006556510925292969	\N
2699	2026-10-09 11:52:00.098433+00	POST	/api/auth/login	127.0.0.1	python-httpx/0.28.1	200	0.24649262428283691	\N
2700	2026-10-09 11:52:00.105208+00	POST	/api/sessions	127.0.0.1	python-httpx/0.28.1	201	0.004076719284057617	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2701	2026-10-09 11:52:00.108541+00	POST	/api/sessions/c0eefd57-f06d-4db4-9095-ed345f90fe8d/publish	127.0.0.1	python-httpx/0.28.1	200	0.0020112991333007812	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2702	2026-10-09 11:52:00.112622+00	POST	/api/sessions/c0eefd57-f06d-4db4-9095-ed345f90fe8d/complete-and-document	127.0.0.1	python-httpx/0.28.1	200	0.0026051998138427734	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2703	2026-10-09 11:52:00.117668+00	PATCH	/api/sessions/c0eefd57-f06d-4db4-9095-ed345f90fe8d/documentation	127.0.0.1	python-httpx/0.28.1	200	0.003354310989379883	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2704	2026-10-09 11:52:00.121106+00	POST	/api/sessions/c0eefd57-f06d-4db4-9095-ed345f90fe8d/publish-studio	127.0.0.1	python-httpx/0.28.1	200	0.0020940303802490234	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2707	2026-10-09 11:52:00.372839+00	POST	/api/upload	127.0.0.1	python-httpx/0.28.1	201	0.002524852752685547	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2709	2026-10-09 11:52:00.381057+00	POST	/api/upload	127.0.0.1	python-httpx/0.28.1	400	0.0013172626495361328	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2851	2026-10-09 12:11:52.65007+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.06279206275939941	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
3053	2026-10-09 13:33:57.659707+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	401	0.0021562576293945312	\N
3056	2026-10-09 13:34:05.247938+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	401	0.0025720596313476562	\N
3059	2026-10-09 13:35:22.04018+00	GET	/api/sessions/6181c511-10b9-4bff-b8f4-164d7db901ba	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.020627498626708984	\N
3066	2026-10-09 13:35:37.031572+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	401	0.006203651428222656	\N
3068	2026-10-09 13:35:37.048008+00	GET	/api/sessions/6181c511-10b9-4bff-b8f4-164d7db901ba	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.003112316131591797	\N
3071	2026-10-09 13:36:01.268667+00	GET	/api/sessions/6181c511-10b9-4bff-b8f4-164d7db901ba	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.018533706665039062	\N
3078	2026-10-09 20:16:19.937079+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	401	0.01391291618347168	\N
3080	2026-10-09 20:16:19.965728+00	GET	/api/sessions/6181c511-10b9-4bff-b8f4-164d7db901ba	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.004891395568847656	\N
3180	2026-10-09 22:04:13.816588+00	POST	/api/sessions/348170d0-7ee2-40aa-9345-7929ba7da7e7/complete-and-document	127.0.0.1	python-httpx/0.28.1	200	0.002518177032470703	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
3181	2026-10-09 22:04:13.822397+00	PATCH	/api/sessions/348170d0-7ee2-40aa-9345-7929ba7da7e7/documentation	127.0.0.1	python-httpx/0.28.1	200	0.003668546676635742	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
3182	2026-10-09 22:04:13.825636+00	POST	/api/sessions/348170d0-7ee2-40aa-9345-7929ba7da7e7/publish-studio	127.0.0.1	python-httpx/0.28.1	200	0.0019006729125976562	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
3184	2026-10-09 22:04:13.84332+00	POST	/api/session-interests	127.0.0.1	python-httpx/0.28.1	201	0.010011672973632812	\N
3185	2026-10-09 22:04:13.845501+00	GET	/api/session-interests	127.0.0.1	python-httpx/0.28.1	401	0.0005631446838378906	\N
3186	2026-10-09 22:04:14.082347+00	POST	/api/auth/login	127.0.0.1	python-httpx/0.28.1	200	0.23548650741577148	\N
3188	2026-10-09 22:04:14.092861+00	GET	/api/session-interests	127.0.0.1	python-httpx/0.28.1	200	0.0034263134002685547	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
3189	2026-10-09 22:04:14.09852+00	PATCH	/api/session-interests/496e6ad5-01b7-45b0-97ed-08fa84466560	127.0.0.1	python-httpx/0.28.1	200	0.004026174545288086	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
3192	2026-10-09 22:04:14.343608+00	POST	/api/auth/login	127.0.0.1	python-httpx/0.28.1	200	0.23534655570983887	\N
3194	2026-10-09 22:04:14.352474+00	POST	/api/upload/multiple	127.0.0.1	python-httpx/0.28.1	201	0.0022058486938476562	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2690	2026-10-09 11:51:59.81955+00	POST	/api/sessions/54650e85-9414-4379-a6ca-06e3b5cd65c2/publish	127.0.0.1	python-httpx/0.28.1	200	0.004670619964599609	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2691	2026-10-09 11:51:59.824247+00	POST	/api/sessions/54650e85-9414-4379-a6ca-06e3b5cd65c2/complete	127.0.0.1	python-httpx/0.28.1	200	0.002348661422729492	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2693	2026-10-09 11:51:59.830696+00	GET	/api/sessions/54650e85-9414-4379-a6ca-06e3b5cd65c2	127.0.0.1	python-httpx/0.28.1	200	0.0009090900421142578	\N
2694	2026-10-09 11:51:59.835966+00	PATCH	/api/sessions/54650e85-9414-4379-a6ca-06e3b5cd65c2	127.0.0.1	python-httpx/0.28.1	200	0.0036792755126953125	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2695	2026-10-09 11:51:59.840134+00	POST	/api/sessions/54650e85-9414-4379-a6ca-06e3b5cd65c2/publish-studio	127.0.0.1	python-httpx/0.28.1	200	0.002596616744995117	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2696	2026-10-09 11:51:59.843697+00	POST	/api/sessions/54650e85-9414-4379-a6ca-06e3b5cd65c2/unpublish-studio	127.0.0.1	python-httpx/0.28.1	200	0.0019028186798095703	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2705	2026-10-09 11:52:00.125561+00	GET	/api/sessions	127.0.0.1	python-httpx/0.28.1	200	0.0024445056915283203	\N
2706	2026-10-09 11:52:00.367673+00	POST	/api/auth/login	127.0.0.1	python-httpx/0.28.1	200	0.23707199096679688	\N
2708	2026-10-09 11:52:00.378357+00	POST	/api/upload/multiple	127.0.0.1	python-httpx/0.28.1	201	0.0033872127532958984	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2869	2026-10-09 12:12:09.378133+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.011130571365356445	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2872	2026-10-09 12:12:13.135435+00	GET	/api/sessions/69ecae62-4eb7-4398-aa87-03fc4c305acc	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.02384328842163086	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2885	2026-10-09 12:12:53.984484+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.03292489051818848	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2887	2026-10-09 12:12:54.033546+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.009813308715820312	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2889	2026-10-09 12:12:54.806602+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.02198934555053711	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2891	2026-10-09 12:12:57.493096+00	GET	/api/session-interests	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.006188154220581055	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2894	2026-10-09 12:13:25.223102+00	PATCH	/api/session-interests/cd16d902-a337-477f-a5d1-311b8a603aff	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.03227996826171875	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2933	2026-10-09 12:14:10.330879+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.009419918060302734	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2936	2026-10-09 12:14:10.365341+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.004227161407470703	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2938	2026-10-09 12:14:38.311986+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.04545187950134277	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2940	2026-10-09 12:14:39.273462+00	GET	/api/sessions/6181c511-10b9-4bff-b8f4-164d7db901ba	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.001522064208984375	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2942	2026-10-09 12:15:50.894347+00	GET	/api/journal/public	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.04248380661010742	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2946	2026-10-09 12:16:04.339812+00	GET	/api/journal/public	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.008727550506591797	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2948	2026-10-09 12:16:05.396306+00	GET	/api/journal/e1b9db18-3f6f-41c4-8498-f18a574ebc7e	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.005651712417602539	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2950	2026-10-09 12:16:13.707779+00	GET	/api/journal/public	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.010290861129760742	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2989	2026-10-09 12:46:31.986121+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	401	0.0014071464538574219	\N
2999	2026-10-09 12:46:35.029945+00	GET	/api/sessions/69ecae62-4eb7-4398-aa87-03fc4c305acc	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.03255438804626465	\N
3001	2026-10-09 12:46:43.091276+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0041730403900146484	\N
3003	2026-10-09 12:46:43.819118+00	GET	/api/sessions/6181c511-10b9-4bff-b8f4-164d7db901ba	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0030257701873779297	\N
3005	2026-10-09 12:46:47.59697+00	GET	/api/sessions/6181c511-10b9-4bff-b8f4-164d7db901ba	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.002509593963623047	\N
3006	2026-10-09 12:46:49.885772+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0828847885131836	\N
3008	2026-10-09 12:46:49.929804+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.008167743682861328	\N
3035	2026-10-09 13:14:40.615184+00	GET	/api/sessions/6181c511-10b9-4bff-b8f4-164d7db901ba	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.4603254795074463	\N
3054	2026-10-09 13:34:05.226342+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	401	0.02066349983215332	\N
3057	2026-10-09 13:34:05.248979+00	GET	/api/sessions/6181c511-10b9-4bff-b8f4-164d7db901ba	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0038013458251953125	\N
3060	2026-10-09 13:35:22.049252+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	401	0.0012121200561523438	\N
3063	2026-10-09 13:35:25.041825+00	GET	/api/sessions/6181c511-10b9-4bff-b8f4-164d7db901ba	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.02484297752380371	\N
3070	2026-10-09 13:36:01.263446+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	401	0.023599624633789062	\N
3073	2026-10-09 13:36:01.281426+00	GET	/api/sessions/6181c511-10b9-4bff-b8f4-164d7db901ba	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0050203800201416016	\N
3081	2026-10-09 20:16:19.963484+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	401	0.001226663589477539	\N
3084	2026-10-09 20:32:24.756936+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.015181303024291992	\N
2712	2026-10-09 11:54:10.682773+00	PATCH	/api/journal/8b40e1fe-efc3-4b8c-b736-d6720bbba8d5	127.0.0.1	python-httpx/0.28.1	200	0.004948854446411133	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2713	2026-10-09 11:54:10.687491+00	POST	/api/journal/8b40e1fe-efc3-4b8c-b736-d6720bbba8d5/approve	127.0.0.1	python-httpx/0.28.1	200	0.0029098987579345703	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2714	2026-10-09 11:54:10.693763+00	GET	/api/journal/public	127.0.0.1	python-httpx/0.28.1	200	0.004640102386474609	\N
2715	2026-10-09 11:54:10.934903+00	POST	/api/auth/login	127.0.0.1	python-httpx/0.28.1	200	0.23500561714172363	\N
2716	2026-10-09 11:54:10.949776+00	POST	/api/sessions	127.0.0.1	python-httpx/0.28.1	201	0.0126953125	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2717	2026-10-09 11:54:10.954871+00	POST	/api/sessions/346290d2-97b2-45d1-8773-eaca0f57ad4f/publish	127.0.0.1	python-httpx/0.28.1	200	0.003407716751098633	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2718	2026-10-09 11:54:10.958561+00	POST	/api/sessions/346290d2-97b2-45d1-8773-eaca0f57ad4f/complete	127.0.0.1	python-httpx/0.28.1	200	0.0023145675659179688	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2719	2026-10-09 11:54:10.962328+00	GET	/api/sessions	127.0.0.1	python-httpx/0.28.1	200	0.0024597644805908203	\N
2720	2026-10-09 11:54:10.964715+00	GET	/api/sessions/346290d2-97b2-45d1-8773-eaca0f57ad4f	127.0.0.1	python-httpx/0.28.1	200	0.0008409023284912109	\N
2721	2026-10-09 11:54:10.971365+00	PATCH	/api/sessions/346290d2-97b2-45d1-8773-eaca0f57ad4f	127.0.0.1	python-httpx/0.28.1	200	0.003737211227416992	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2722	2026-10-09 11:54:10.977005+00	POST	/api/sessions/346290d2-97b2-45d1-8773-eaca0f57ad4f/publish-studio	127.0.0.1	python-httpx/0.28.1	200	0.0032091140747070312	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2723	2026-10-09 11:54:10.980614+00	POST	/api/sessions/346290d2-97b2-45d1-8773-eaca0f57ad4f/unpublish-studio	127.0.0.1	python-httpx/0.28.1	200	0.0018596649169921875	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2724	2026-10-09 11:54:10.984364+00	DELETE	/api/sessions/346290d2-97b2-45d1-8773-eaca0f57ad4f	127.0.0.1	python-httpx/0.28.1	204	0.0024347305297851562	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2725	2026-10-09 11:54:10.986671+00	GET	/api/sessions/346290d2-97b2-45d1-8773-eaca0f57ad4f	127.0.0.1	python-httpx/0.28.1	404	0.0006814002990722656	\N
2726	2026-10-09 11:54:11.227563+00	POST	/api/auth/login	127.0.0.1	python-httpx/0.28.1	200	0.23842382431030273	\N
2727	2026-10-09 11:54:11.233237+00	POST	/api/sessions	127.0.0.1	python-httpx/0.28.1	201	0.003617525100708008	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2728	2026-10-09 11:54:11.237115+00	POST	/api/sessions/48125778-8a69-4e1b-9550-15f68b805a3e/publish	127.0.0.1	python-httpx/0.28.1	200	0.002268552780151367	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2729	2026-10-09 11:54:11.241248+00	POST	/api/sessions/48125778-8a69-4e1b-9550-15f68b805a3e/complete-and-document	127.0.0.1	python-httpx/0.28.1	200	0.0027587413787841797	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2730	2026-10-09 11:54:11.247366+00	PATCH	/api/sessions/48125778-8a69-4e1b-9550-15f68b805a3e/documentation	127.0.0.1	python-httpx/0.28.1	200	0.004380702972412109	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2731	2026-10-09 11:54:11.250819+00	POST	/api/sessions/48125778-8a69-4e1b-9550-15f68b805a3e/publish-studio	127.0.0.1	python-httpx/0.28.1	200	0.001973390579223633	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2732	2026-10-09 11:54:11.254534+00	GET	/api/sessions	127.0.0.1	python-httpx/0.28.1	200	0.00225830078125	\N
2733	2026-10-09 11:54:11.269726+00	POST	/api/session-interests	127.0.0.1	python-httpx/0.28.1	201	0.010913848876953125	\N
2734	2026-10-09 11:54:11.271947+00	GET	/api/session-interests	127.0.0.1	python-httpx/0.28.1	401	0.0005922317504882812	\N
2735	2026-10-09 11:54:11.508684+00	POST	/api/auth/login	127.0.0.1	python-httpx/0.28.1	200	0.2350778579711914	\N
2736	2026-10-09 11:54:11.513919+00	GET	/api/session-interests	127.0.0.1	python-httpx/0.28.1	200	0.002976655960083008	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2737	2026-10-09 11:54:11.51876+00	GET	/api/session-interests	127.0.0.1	python-httpx/0.28.1	200	0.0032358169555664062	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2738	2026-10-09 11:54:11.523324+00	PATCH	/api/session-interests/9270e0da-030e-4be3-85d3-a08e82f828c6	127.0.0.1	python-httpx/0.28.1	200	0.0032672882080078125	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2739	2026-10-09 11:54:11.527211+00	DELETE	/api/session-interests/9270e0da-030e-4be3-85d3-a08e82f828c6	127.0.0.1	python-httpx/0.28.1	204	0.0018663406372070312	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2740	2026-10-09 11:54:11.529477+00	GET	/api/session-interests/9270e0da-030e-4be3-85d3-a08e82f828c6	127.0.0.1	python-httpx/0.28.1	404	0.0011150836944580078	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2741	2026-10-09 11:54:11.768858+00	POST	/api/auth/login	127.0.0.1	python-httpx/0.28.1	200	0.23602747917175293	\N
2742	2026-10-09 11:54:11.774131+00	POST	/api/upload	127.0.0.1	python-httpx/0.28.1	201	0.0028014183044433594	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2743	2026-10-09 11:54:11.777803+00	POST	/api/upload/multiple	127.0.0.1	python-httpx/0.28.1	201	0.0020809173583984375	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2744	2026-10-09 11:54:11.780391+00	POST	/api/upload	127.0.0.1	python-httpx/0.28.1	400	0.0012674331665039062	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2745	2026-10-09 11:54:52.916175+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	401	0.022896528244018555	\N
2746	2026-10-09 11:54:52.946193+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	401	0.0009207725524902344	\N
2747	2026-10-09 11:54:52.963262+00	GET	/api/sessions/f29b7e3c-59c5-4380-9af4-96cec59b69bd	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.31815624237060547	\N
2748	2026-10-09 11:54:52.988773+00	GET	/api/sessions/f29b7e3c-59c5-4380-9af4-96cec59b69bd	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.020094633102416992	\N
2749	2026-10-09 11:54:55.456103+00	GET	/api/sessions/6181c511-10b9-4bff-b8f4-164d7db901ba	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.023183107376098633	\N
2750	2026-10-09 11:54:55.459488+00	GET	/api/sessions/6181c511-10b9-4bff-b8f4-164d7db901ba	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.041936397552490234	\N
2751	2026-10-09 11:55:03.869088+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	401	0.020841598510742188	\N
2752	2026-10-09 11:55:03.887112+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	401	0.0039806365966796875	\N
2753	2026-10-09 11:55:03.900793+00	GET	/api/sessions/f29b7e3c-59c5-4380-9af4-96cec59b69bd	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0430912971496582	\N
2754	2026-10-09 11:55:03.926439+00	GET	/api/sessions/f29b7e3c-59c5-4380-9af4-96cec59b69bd	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.02013230323791504	\N
2755	2026-10-09 11:55:06.257943+00	GET	/api/sessions/6181c511-10b9-4bff-b8f4-164d7db901ba	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.038011789321899414	\N
2756	2026-10-09 11:55:06.273314+00	GET	/api/sessions/6181c511-10b9-4bff-b8f4-164d7db901ba	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.002546548843383789	\N
2757	2026-10-09 12:02:39.859465+00	POST	/api/auth/login	127.0.0.1	python-httpx/0.28.1	200	0.30092644691467285	\N
2758	2026-10-09 12:02:39.925714+00	POST	/api/journal	127.0.0.1	python-httpx/0.28.1	201	0.050804853439331055	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2759	2026-10-09 12:02:39.933712+00	PATCH	/api/journal/264ae775-07b7-4423-9458-a58c37cfb09f	127.0.0.1	python-httpx/0.28.1	200	0.005563497543334961	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2760	2026-10-09 12:02:39.93862+00	POST	/api/journal/264ae775-07b7-4423-9458-a58c37cfb09f/approve	127.0.0.1	python-httpx/0.28.1	200	0.0032930374145507812	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2761	2026-10-09 12:02:39.948324+00	GET	/api/journal/public	127.0.0.1	python-httpx/0.28.1	200	0.00725102424621582	\N
2762	2026-10-09 12:02:40.196548+00	POST	/api/auth/login	127.0.0.1	python-httpx/0.28.1	200	0.24082255363464355	\N
2763	2026-10-09 12:02:40.222878+00	POST	/api/sessions	127.0.0.1	python-httpx/0.28.1	201	0.024150609970092773	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2764	2026-10-09 12:02:40.228964+00	POST	/api/sessions/f467ff2f-6cdf-4491-a4b8-536dccad2d6f/publish	127.0.0.1	python-httpx/0.28.1	200	0.004110574722290039	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2765	2026-10-09 12:02:40.233147+00	POST	/api/sessions/f467ff2f-6cdf-4491-a4b8-536dccad2d6f/complete	127.0.0.1	python-httpx/0.28.1	200	0.0026254653930664062	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2766	2026-10-09 12:02:40.237047+00	GET	/api/sessions	127.0.0.1	python-httpx/0.28.1	200	0.002613544464111328	\N
2767	2026-10-09 12:02:40.239136+00	GET	/api/sessions/f467ff2f-6cdf-4491-a4b8-536dccad2d6f	127.0.0.1	python-httpx/0.28.1	200	0.0007395744323730469	\N
2768	2026-10-09 12:02:40.243313+00	PATCH	/api/sessions/f467ff2f-6cdf-4491-a4b8-536dccad2d6f	127.0.0.1	python-httpx/0.28.1	200	0.0028374195098876953	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2769	2026-10-09 12:02:40.247273+00	POST	/api/sessions/f467ff2f-6cdf-4491-a4b8-536dccad2d6f/publish-studio	127.0.0.1	python-httpx/0.28.1	200	0.0025157928466796875	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2770	2026-10-09 12:02:40.250471+00	POST	/api/sessions/f467ff2f-6cdf-4491-a4b8-536dccad2d6f/unpublish-studio	127.0.0.1	python-httpx/0.28.1	200	0.0018777847290039062	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2771	2026-10-09 12:02:40.253765+00	DELETE	/api/sessions/f467ff2f-6cdf-4491-a4b8-536dccad2d6f	127.0.0.1	python-httpx/0.28.1	204	0.002092123031616211	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2772	2026-10-09 12:02:40.255867+00	GET	/api/sessions/f467ff2f-6cdf-4491-a4b8-536dccad2d6f	127.0.0.1	python-httpx/0.28.1	404	0.0006542205810546875	\N
2773	2026-10-09 12:02:40.506+00	POST	/api/auth/login	127.0.0.1	python-httpx/0.28.1	200	0.24597835540771484	\N
2774	2026-10-09 12:02:40.517872+00	POST	/api/sessions	127.0.0.1	python-httpx/0.28.1	201	0.006944894790649414	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2775	2026-10-09 12:02:40.523777+00	POST	/api/sessions/3991db63-dcfc-4a6a-b6ca-2b5d74a96c76/publish	127.0.0.1	python-httpx/0.28.1	200	0.003868579864501953	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2776	2026-10-09 12:02:40.529442+00	POST	/api/sessions/3991db63-dcfc-4a6a-b6ca-2b5d74a96c76/complete-and-document	127.0.0.1	python-httpx/0.28.1	200	0.0032074451446533203	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2777	2026-10-09 12:02:40.534704+00	PATCH	/api/sessions/3991db63-dcfc-4a6a-b6ca-2b5d74a96c76/documentation	127.0.0.1	python-httpx/0.28.1	200	0.003860950469970703	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2778	2026-10-09 12:02:40.538192+00	POST	/api/sessions/3991db63-dcfc-4a6a-b6ca-2b5d74a96c76/publish-studio	127.0.0.1	python-httpx/0.28.1	200	0.0021209716796875	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2779	2026-10-09 12:02:40.544551+00	GET	/api/sessions	127.0.0.1	python-httpx/0.28.1	200	0.004578351974487305	\N
2780	2026-10-09 12:02:40.565933+00	POST	/api/session-interests	127.0.0.1	python-httpx/0.28.1	201	0.013566970825195312	\N
2781	2026-10-09 12:02:40.569245+00	GET	/api/session-interests	127.0.0.1	python-httpx/0.28.1	401	0.0006651878356933594	\N
2782	2026-10-09 12:02:40.829799+00	POST	/api/auth/login	127.0.0.1	python-httpx/0.28.1	200	0.2541513442993164	\N
2783	2026-10-09 12:02:40.845624+00	GET	/api/session-interests	127.0.0.1	python-httpx/0.28.1	200	0.009048223495483398	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2784	2026-10-09 12:02:40.855317+00	GET	/api/session-interests	127.0.0.1	python-httpx/0.28.1	200	0.006867170333862305	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2785	2026-10-09 12:02:40.867194+00	PATCH	/api/session-interests/4075c534-d8eb-4f1f-9836-d3aaab822b8b	127.0.0.1	python-httpx/0.28.1	200	0.009514331817626953	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2786	2026-10-09 12:02:40.878106+00	DELETE	/api/session-interests/4075c534-d8eb-4f1f-9836-d3aaab822b8b	127.0.0.1	python-httpx/0.28.1	204	0.006150960922241211	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2787	2026-10-09 12:02:40.882141+00	GET	/api/session-interests/4075c534-d8eb-4f1f-9836-d3aaab822b8b	127.0.0.1	python-httpx/0.28.1	404	0.002057790756225586	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2788	2026-10-09 12:02:41.138785+00	POST	/api/auth/login	127.0.0.1	python-httpx/0.28.1	200	0.2509002685546875	\N
2789	2026-10-09 12:02:41.144631+00	POST	/api/upload	127.0.0.1	python-httpx/0.28.1	201	0.0035126209259033203	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2790	2026-10-09 12:02:41.151207+00	POST	/api/upload/multiple	127.0.0.1	python-httpx/0.28.1	201	0.0047185420989990234	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2791	2026-10-09 12:02:41.155564+00	POST	/api/upload	127.0.0.1	python-httpx/0.28.1	400	0.0017900466918945312	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2886	2026-10-09 12:12:53.987848+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.016717195510864258	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2893	2026-10-09 12:13:12.582295+00	PATCH	/api/session-interests/cd16d902-a337-477f-a5d1-311b8a603aff	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.020171165466308594	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
3086	2026-10-09 20:32:26.434196+00	GET	/api/users	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	401	0.0022614002227783203	\N
3090	2026-10-09 20:32:30.701249+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.028250455856323242	\N
3191	2026-10-09 22:04:14.104311+00	GET	/api/session-interests/496e6ad5-01b7-45b0-97ed-08fa84466560	127.0.0.1	python-httpx/0.28.1	404	0.0011687278747558594	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
3193	2026-10-09 22:04:14.348212+00	POST	/api/upload	127.0.0.1	python-httpx/0.28.1	201	0.002506732940673828	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
3195	2026-10-09 22:04:14.355075+00	POST	/api/upload	127.0.0.1	python-httpx/0.28.1	400	0.0012569427490234375	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2792	2026-10-09 12:03:18.897746+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.054384708404541016	\N
2793	2026-10-09 12:03:18.951571+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0570220947265625	\N
2794	2026-10-09 12:03:18.950508+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.27998995780944824	\N
2896	2026-10-09 12:13:43.091888+00	POST	/api/auth/login	127.0.0.1	python-httpx/0.28.1	200	0.28588342666625977	\N
2897	2026-10-09 12:13:43.195038+00	POST	/api/journal	127.0.0.1	python-httpx/0.28.1	201	0.092559814453125	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2898	2026-10-09 12:13:43.204868+00	PATCH	/api/journal/ce0c81c8-d052-4ee3-8bda-173a5ed75c1a	127.0.0.1	python-httpx/0.28.1	200	0.007291555404663086	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2899	2026-10-09 12:13:43.210154+00	POST	/api/journal/ce0c81c8-d052-4ee3-8bda-173a5ed75c1a/approve	127.0.0.1	python-httpx/0.28.1	200	0.003606081008911133	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2905	2026-10-09 12:13:43.509112+00	GET	/api/sessions	127.0.0.1	python-httpx/0.28.1	200	0.0031321048736572266	\N
2910	2026-10-09 12:13:43.530301+00	DELETE	/api/sessions/a3b4f80f-5e83-4294-b108-5f15c6ffc6ba	127.0.0.1	python-httpx/0.28.1	204	0.0023627281188964844	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2911	2026-10-09 12:13:43.532742+00	GET	/api/sessions/a3b4f80f-5e83-4294-b108-5f15c6ffc6ba	127.0.0.1	python-httpx/0.28.1	404	0.0007193088531494141	\N
2912	2026-10-09 12:13:43.773941+00	POST	/api/auth/login	127.0.0.1	python-httpx/0.28.1	200	0.2381448745727539	\N
2913	2026-10-09 12:13:43.780069+00	POST	/api/sessions	127.0.0.1	python-httpx/0.28.1	201	0.004038095474243164	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2914	2026-10-09 12:13:43.784328+00	POST	/api/sessions/75a92e74-d188-4ac7-baa7-bad2469aa41e/publish	127.0.0.1	python-httpx/0.28.1	200	0.0027098655700683594	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2915	2026-10-09 12:13:43.788551+00	POST	/api/sessions/75a92e74-d188-4ac7-baa7-bad2469aa41e/complete-and-document	127.0.0.1	python-httpx/0.28.1	200	0.002756357192993164	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2916	2026-10-09 12:13:43.793512+00	PATCH	/api/sessions/75a92e74-d188-4ac7-baa7-bad2469aa41e/documentation	127.0.0.1	python-httpx/0.28.1	200	0.0036394596099853516	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2917	2026-10-09 12:13:43.796847+00	POST	/api/sessions/75a92e74-d188-4ac7-baa7-bad2469aa41e/publish-studio	127.0.0.1	python-httpx/0.28.1	200	0.0020122528076171875	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2919	2026-10-09 12:13:43.814123+00	POST	/api/session-interests	127.0.0.1	python-httpx/0.28.1	201	0.009711980819702148	\N
2920	2026-10-09 12:13:43.815866+00	GET	/api/session-interests	127.0.0.1	python-httpx/0.28.1	401	0.0004775524139404297	\N
2921	2026-10-09 12:13:44.054698+00	POST	/api/auth/login	127.0.0.1	python-httpx/0.28.1	200	0.23653388023376465	\N
2923	2026-10-09 12:13:44.067112+00	GET	/api/session-interests	127.0.0.1	python-httpx/0.28.1	200	0.003935575485229492	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2924	2026-10-09 12:13:44.075642+00	PATCH	/api/session-interests/ccf82ba6-468b-4e3b-a22b-dd0cb1adeb0f	127.0.0.1	python-httpx/0.28.1	200	0.0054852962493896484	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2927	2026-10-09 12:13:44.344+00	POST	/api/auth/login	127.0.0.1	python-httpx/0.28.1	200	0.2541654109954834	\N
2929	2026-10-09 12:13:44.368407+00	POST	/api/upload/multiple	127.0.0.1	python-httpx/0.28.1	201	0.005590915679931641	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
3095	2026-10-09 20:32:32.08053+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.10465216636657715	\N
3093	2026-10-09 20:32:32.079337+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.10475301742553711	\N
3096	2026-10-09 20:32:32.079778+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.10142016410827637	\N
3097	2026-10-09 20:32:32.210795+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.26566338539123535	\N
3105	2026-10-09 20:33:06.599379+00	GET	/api/session-interests	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.04740405082702637	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
3107	2026-10-09 20:33:53.422683+00	GET	/api/session-interests	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.046701908111572266	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
3117	2026-10-09 21:20:12.771665+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	401	0.0014696121215820312	\N
3118	2026-10-09 21:20:12.772509+00	GET	/api/session-interests	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	401	0.0017788410186767578	\N
3120	2026-10-09 21:20:53.520764+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	401	0.06221175193786621	\N
3122	2026-10-09 21:20:53.542906+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	401	0.001119375228881836	\N
3123	2026-10-09 21:24:10.664726+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	401	0.14482927322387695	\N
3125	2026-10-09 21:24:10.821264+00	GET	/api/session-interests	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	401	0.0010488033294677734	\N
3127	2026-10-09 21:29:06.99026+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.14555811882019043	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
3129	2026-10-09 21:29:07.039781+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.006173610687255859	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
3130	2026-10-09 21:29:07.062758+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.21456265449523926	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
3131	2026-10-09 21:29:07.075847+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.0025932788848876953	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
3132	2026-10-09 21:29:07.091437+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.061214447021484375	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
3134	2026-10-09 21:29:13.390121+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.04843020439147949	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
3133	2026-10-09 21:29:13.389607+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.04292750358581543	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
3135	2026-10-09 21:29:17.100041+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.02198958396911621	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
3138	2026-10-09 21:29:17.799023+00	GET	/api/journal/public	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.11279773712158203	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
3139	2026-10-09 21:29:19.138219+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.01079869270324707	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
3140	2026-10-09 21:29:19.139439+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.03698539733886719	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2795	2026-10-09 12:03:18.958649+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.016195058822631836	\N
2900	2026-10-09 12:13:43.217499+00	GET	/api/journal/public	127.0.0.1	python-httpx/0.28.1	200	0.005201101303100586	\N
2901	2026-10-09 12:13:43.464204+00	POST	/api/auth/login	127.0.0.1	python-httpx/0.28.1	200	0.23974013328552246	\N
2902	2026-10-09 12:13:43.490863+00	POST	/api/sessions	127.0.0.1	python-httpx/0.28.1	201	0.02352142333984375	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2903	2026-10-09 12:13:43.499475+00	POST	/api/sessions/a3b4f80f-5e83-4294-b108-5f15c6ffc6ba/publish	127.0.0.1	python-httpx/0.28.1	200	0.006440639495849609	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2904	2026-10-09 12:13:43.504338+00	POST	/api/sessions/a3b4f80f-5e83-4294-b108-5f15c6ffc6ba/complete	127.0.0.1	python-httpx/0.28.1	200	0.003004312515258789	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2906	2026-10-09 12:13:43.512949+00	GET	/api/sessions/a3b4f80f-5e83-4294-b108-5f15c6ffc6ba	127.0.0.1	python-httpx/0.28.1	200	0.0014696121215820312	\N
2907	2026-10-09 12:13:43.518728+00	PATCH	/api/sessions/a3b4f80f-5e83-4294-b108-5f15c6ffc6ba	127.0.0.1	python-httpx/0.28.1	200	0.0036182403564453125	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2908	2026-10-09 12:13:43.522905+00	POST	/api/sessions/a3b4f80f-5e83-4294-b108-5f15c6ffc6ba/publish-studio	127.0.0.1	python-httpx/0.28.1	200	0.0024962425231933594	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2909	2026-10-09 12:13:43.526404+00	POST	/api/sessions/a3b4f80f-5e83-4294-b108-5f15c6ffc6ba/unpublish-studio	127.0.0.1	python-httpx/0.28.1	200	0.0021953582763671875	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2918	2026-10-09 12:13:43.800451+00	GET	/api/sessions	127.0.0.1	python-httpx/0.28.1	200	0.0020668506622314453	\N
2922	2026-10-09 12:13:44.061417+00	GET	/api/session-interests	127.0.0.1	python-httpx/0.28.1	200	0.004637241363525391	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2925	2026-10-09 12:13:44.080412+00	DELETE	/api/session-interests/ccf82ba6-468b-4e3b-a22b-dd0cb1adeb0f	127.0.0.1	python-httpx/0.28.1	204	0.0028133392333984375	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2926	2026-10-09 12:13:44.083457+00	GET	/api/session-interests/ccf82ba6-468b-4e3b-a22b-dd0cb1adeb0f	127.0.0.1	python-httpx/0.28.1	404	0.0015194416046142578	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2928	2026-10-09 12:13:44.360079+00	POST	/api/upload	127.0.0.1	python-httpx/0.28.1	201	0.011525630950927734	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2930	2026-10-09 12:13:44.372493+00	POST	/api/upload	127.0.0.1	python-httpx/0.28.1	400	0.0017609596252441406	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
3092	2026-10-09 20:32:32.079072+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.1054692268371582	\N
3098	2026-10-09 20:32:33.807853+00	GET	/api/sessions/e630385a-5974-4a0f-862e-2e09c01440a6	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.045629262924194336	\N
3100	2026-10-09 20:32:45.403656+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.050778865814208984	\N
3102	2026-10-09 20:33:02.921762+00	POST	/api/auth/login	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.33567047119140625	\N
3104	2026-10-09 20:33:03.03971+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.002368927001953125	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
3106	2026-10-09 20:33:06.623629+00	GET	/api/session-interests	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.05677938461303711	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
3108	2026-10-09 20:33:54.157079+00	GET	/api/session-interests	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.009460210800170898	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
3198	2026-10-10 06:46:28.535928+00	GET	/api/session-interests	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	401	0.035411834716796875	\N
2797	2026-10-09 12:03:19.064978+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.09035587310791016	\N
2935	2026-10-09 12:14:10.34521+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.03638815879821777	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2986	2026-10-09 12:46:30.534628+00	GET	/api/session-interests	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	401	0.060657501220703125	\N
2991	2026-10-09 12:46:32.731045+00	GET	/api/users	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	401	0.002105236053466797	\N
2993	2026-10-09 12:46:34.000958+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.11735391616821289	\N
2998	2026-10-09 12:46:34.993182+00	GET	/api/sessions/69ecae62-4eb7-4398-aa87-03fc4c305acc	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.003922224044799805	\N
3000	2026-10-09 12:46:43.081994+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.019626617431640625	\N
3002	2026-10-09 12:46:43.811407+00	GET	/api/sessions/6181c511-10b9-4bff-b8f4-164d7db901ba	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.005980730056762695	\N
3004	2026-10-09 12:46:47.587398+00	GET	/api/sessions/6181c511-10b9-4bff-b8f4-164d7db901ba	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.006624460220336914	\N
3011	2026-10-09 12:46:49.990174+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.012728214263916016	\N
3013	2026-10-09 12:46:51.031883+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.13221430778503418	\N
3015	2026-10-09 12:46:53.307559+00	GET	/api/journal/public	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.004913806915283203	\N
3017	2026-10-09 12:46:56.909469+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0025632381439208984	\N
3019	2026-10-09 12:48:20.647617+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0038330554962158203	\N
3021	2026-10-09 12:48:29.213223+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.003317594528198242	\N
3023	2026-10-09 12:48:30.912964+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0025162696838378906	\N
3025	2026-10-09 12:48:37.114943+00	GET	/api/sessions/6181c511-10b9-4bff-b8f4-164d7db901ba	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0038754940032958984	\N
3027	2026-10-09 12:48:39.071598+00	GET	/api/sessions/6181c511-10b9-4bff-b8f4-164d7db901ba	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.002635955810546875	\N
3029	2026-10-09 12:48:44.685769+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.004380226135253906	\N
3031	2026-10-09 12:48:48.758337+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0027382373809814453	\N
3033	2026-10-09 12:48:51.435787+00	GET	/api/sessions/6181c511-10b9-4bff-b8f4-164d7db901ba	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.004979610443115234	\N
3036	2026-10-09 13:14:40.65312+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	401	0.0005636215209960938	\N
3039	2026-10-09 13:16:50.513288+00	GET	/api/sessions/6181c511-10b9-4bff-b8f4-164d7db901ba	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.04585981369018555	\N
3094	2026-10-09 20:32:32.079937+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.10530281066894531	\N
3099	2026-10-09 20:32:33.810385+00	GET	/api/sessions/e630385a-5974-4a0f-862e-2e09c01440a6	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.04844808578491211	\N
3101	2026-10-09 20:32:45.417332+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.004251718521118164	\N
3103	2026-10-09 20:33:03.028899+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.008528947830200195	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
3200	2026-10-10 07:24:30.704349+00	POST	/api/auth/login	127.0.0.1	python-httpx/0.28.1	200	0.29880547523498535	\N
3201	2026-10-10 07:24:30.853524+00	POST	/api/journal	127.0.0.1	python-httpx/0.28.1	201	0.12517881393432617	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
3202	2026-10-10 07:24:30.863181+00	PATCH	/api/journal/e29d197e-d7a0-4b35-b4af-ccbba8ecdd1f	127.0.0.1	python-httpx/0.28.1	200	0.007143497467041016	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
3203	2026-10-10 07:24:30.868101+00	POST	/api/journal/e29d197e-d7a0-4b35-b4af-ccbba8ecdd1f/approve	127.0.0.1	python-httpx/0.28.1	200	0.003485441207885742	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
3209	2026-10-10 07:24:31.168047+00	GET	/api/sessions	127.0.0.1	python-httpx/0.28.1	200	0.0034227371215820312	\N
3214	2026-10-10 07:24:31.186152+00	DELETE	/api/sessions/b1a1b644-9531-41fc-b96a-1eefbc52eef6	127.0.0.1	python-httpx/0.28.1	204	0.002597332000732422	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
3215	2026-10-10 07:24:31.188765+00	GET	/api/sessions/b1a1b644-9531-41fc-b96a-1eefbc52eef6	127.0.0.1	python-httpx/0.28.1	404	0.0006997585296630859	\N
3216	2026-10-10 07:24:31.430243+00	POST	/api/auth/login	127.0.0.1	python-httpx/0.28.1	200	0.23803067207336426	\N
3217	2026-10-10 07:24:31.436494+00	POST	/api/sessions	127.0.0.1	python-httpx/0.28.1	201	0.004114866256713867	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
3218	2026-10-10 07:24:31.439933+00	POST	/api/sessions/1acdb381-c509-4d04-adab-6d40e5c38ea6/publish	127.0.0.1	python-httpx/0.28.1	200	0.002011537551879883	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
3219	2026-10-10 07:24:31.444147+00	POST	/api/sessions/1acdb381-c509-4d04-adab-6d40e5c38ea6/complete-and-document	127.0.0.1	python-httpx/0.28.1	200	0.002588510513305664	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
3220	2026-10-10 07:24:31.449021+00	PATCH	/api/sessions/1acdb381-c509-4d04-adab-6d40e5c38ea6/documentation	127.0.0.1	python-httpx/0.28.1	200	0.0035610198974609375	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
3221	2026-10-10 07:24:31.45206+00	POST	/api/sessions/1acdb381-c509-4d04-adab-6d40e5c38ea6/publish-studio	127.0.0.1	python-httpx/0.28.1	200	0.0017764568328857422	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
3223	2026-10-10 07:24:31.472337+00	POST	/api/session-interests	127.0.0.1	python-httpx/0.28.1	201	0.011388301849365234	\N
2796	2026-10-09 12:03:19.063222+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.09338903427124023	\N
2951	2026-10-09 12:20:14.054559+00	POST	/api/auth/login	127.0.0.1	python-httpx/0.28.1	200	0.2904932498931885	\N
2952	2026-10-09 12:20:14.127866+00	POST	/api/journal	127.0.0.1	python-httpx/0.28.1	201	0.057727813720703125	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2953	2026-10-09 12:20:14.136407+00	PATCH	/api/journal/a8f59966-85fc-480c-b870-f4eb944e0a32	127.0.0.1	python-httpx/0.28.1	200	0.006383419036865234	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2954	2026-10-09 12:20:14.14127+00	POST	/api/journal/a8f59966-85fc-480c-b870-f4eb944e0a32/approve	127.0.0.1	python-httpx/0.28.1	200	0.0033309459686279297	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2960	2026-10-09 12:20:14.43183+00	GET	/api/sessions	127.0.0.1	python-httpx/0.28.1	200	0.0032329559326171875	\N
2965	2026-10-09 12:20:14.449405+00	DELETE	/api/sessions/a26ebec1-d582-422f-9b17-f357810d56f6	127.0.0.1	python-httpx/0.28.1	204	0.002177000045776367	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2966	2026-10-09 12:20:14.451913+00	GET	/api/sessions/a26ebec1-d582-422f-9b17-f357810d56f6	127.0.0.1	python-httpx/0.28.1	404	0.0007388591766357422	\N
2967	2026-10-09 12:20:14.690573+00	POST	/api/auth/login	127.0.0.1	python-httpx/0.28.1	200	0.2357642650604248	\N
2968	2026-10-09 12:20:14.697441+00	POST	/api/sessions	127.0.0.1	python-httpx/0.28.1	201	0.004312992095947266	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2969	2026-10-09 12:20:14.702067+00	POST	/api/sessions/62e0d635-da65-4620-8e21-ccf4e3134929/publish	127.0.0.1	python-httpx/0.28.1	200	0.0027074813842773438	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2970	2026-10-09 12:20:14.707154+00	POST	/api/sessions/62e0d635-da65-4620-8e21-ccf4e3134929/complete-and-document	127.0.0.1	python-httpx/0.28.1	200	0.002592802047729492	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2971	2026-10-09 12:20:14.71317+00	PATCH	/api/sessions/62e0d635-da65-4620-8e21-ccf4e3134929/documentation	127.0.0.1	python-httpx/0.28.1	200	0.0036597251892089844	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2972	2026-10-09 12:20:14.716499+00	POST	/api/sessions/62e0d635-da65-4620-8e21-ccf4e3134929/publish-studio	127.0.0.1	python-httpx/0.28.1	200	0.0020134449005126953	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2974	2026-10-09 12:20:14.733872+00	POST	/api/session-interests	127.0.0.1	python-httpx/0.28.1	201	0.009987115859985352	\N
2975	2026-10-09 12:20:14.737123+00	GET	/api/session-interests	127.0.0.1	python-httpx/0.28.1	401	0.0006387233734130859	\N
2976	2026-10-09 12:20:14.974706+00	POST	/api/auth/login	127.0.0.1	python-httpx/0.28.1	200	0.23547816276550293	\N
2978	2026-10-09 12:20:14.986778+00	GET	/api/session-interests	127.0.0.1	python-httpx/0.28.1	200	0.0037393569946289062	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2979	2026-10-09 12:20:14.991703+00	PATCH	/api/session-interests/9b05cf8d-febb-4ef4-b1bf-4a2d934f10d3	127.0.0.1	python-httpx/0.28.1	200	0.003498077392578125	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
2982	2026-10-09 12:20:15.306291+00	POST	/api/auth/login	127.0.0.1	python-httpx/0.28.1	200	0.29917311668395996	\N
2984	2026-10-09 12:20:15.319891+00	POST	/api/upload/multiple	127.0.0.1	python-httpx/0.28.1	201	0.0027816295623779297	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
3110	2026-10-09 20:54:33.568163+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.2824826240539551	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
3111	2026-10-09 20:54:33.571217+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.15877223014831543	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
3109	2026-10-09 20:54:33.568623+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.13933753967285156	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
3113	2026-10-09 20:54:33.625844+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.210479736328125	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
3114	2026-10-09 20:54:33.627025+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.22818565368652344	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
3116	2026-10-09 21:20:12.725897+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	401	0.07098889350891113	\N
3119	2026-10-09 21:20:53.525194+00	GET	/api/session-interests	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	401	0.07762885093688965	\N
3124	2026-10-09 21:24:10.726973+00	GET	/api/journal	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	401	0.0010161399841308594	\N
3136	2026-10-09 21:29:17.100851+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.09673452377319336	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
3137	2026-10-09 21:29:17.798222+00	GET	/api/journal/public	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.10354828834533691	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
3152	2026-10-09 21:30:45.232321+00	GET	/api/sessions/next	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.011823415756225586	\N
3154	2026-10-09 21:30:45.25703+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0021741390228271484	\N
3156	2026-10-09 21:31:12.492258+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.044640541076660156	\N
3158	2026-10-09 21:31:12.929713+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	200	0.0031332969665527344	\N
3160	2026-10-09 21:47:12.231864+00	GET	/api/sessions	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:157.0) Gecko/20100101 Firefox/157.0	200	0.006308078765869141	\N
3199	2026-10-10 06:46:28.571444+00	GET	/api/session-interests	192.168.65.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	401	0.001512765884399414	\N
3204	2026-10-10 07:24:30.875755+00	GET	/api/journal/public	127.0.0.1	python-httpx/0.28.1	200	0.005880832672119141	\N
3205	2026-10-10 07:24:31.123675+00	POST	/api/auth/login	127.0.0.1	python-httpx/0.28.1	200	0.23954534530639648	\N
3206	2026-10-10 07:24:31.151588+00	POST	/api/sessions	127.0.0.1	python-httpx/0.28.1	201	0.023728370666503906	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
3207	2026-10-10 07:24:31.158678+00	POST	/api/sessions/b1a1b644-9531-41fc-b96a-1eefbc52eef6/publish	127.0.0.1	python-httpx/0.28.1	200	0.004770517349243164	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
3208	2026-10-10 07:24:31.162693+00	POST	/api/sessions/b1a1b644-9531-41fc-b96a-1eefbc52eef6/complete	127.0.0.1	python-httpx/0.28.1	200	0.0025739669799804688	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
3210	2026-10-10 07:24:31.170661+00	GET	/api/sessions/b1a1b644-9531-41fc-b96a-1eefbc52eef6	127.0.0.1	python-httpx/0.28.1	200	0.0007717609405517578	\N
3211	2026-10-10 07:24:31.175277+00	PATCH	/api/sessions/b1a1b644-9531-41fc-b96a-1eefbc52eef6	127.0.0.1	python-httpx/0.28.1	200	0.003315448760986328	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
3212	2026-10-10 07:24:31.179207+00	POST	/api/sessions/b1a1b644-9531-41fc-b96a-1eefbc52eef6/publish-studio	127.0.0.1	python-httpx/0.28.1	200	0.0024216175079345703	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
3213	2026-10-10 07:24:31.182303+00	POST	/api/sessions/b1a1b644-9531-41fc-b96a-1eefbc52eef6/unpublish-studio	127.0.0.1	python-httpx/0.28.1	200	0.0018868446350097656	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
3222	2026-10-10 07:24:31.455728+00	GET	/api/sessions	127.0.0.1	python-httpx/0.28.1	200	0.002343416213989258	\N
3226	2026-10-10 07:24:31.735267+00	GET	/api/session-interests	127.0.0.1	python-httpx/0.28.1	200	0.003931999206542969	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf
\.


--
-- Data for Name: journal_submissions; Type: TABLE DATA; Schema: public; Owner: jprclub
--

COPY public.journal_submissions (id, title, title_ar, content, content_ar, status, author_id, created_at, updated_at, published_at, version, cover_image_url, content_format, content_language) FROM stdin;
bb701e5a-271b-40b8-8298-1b903317aee1	Reflections on Japanese Literature in Riyadh	تأملات في الأدب الياباني في الرياض	Reading together at JPR Club opened a profound window into cultural exchange and literary appreciation...	فتحت القراءة الجماعية في نادي القراءة اليابانية نافذة عميقة على التبادل الثقافي والتقدير الأدبي...	approved	bb1d615e-e5ea-4cb5-9346-241f18e74a7f	2026-10-07 19:58:01.212773+00	2026-10-07 19:58:01.238382+00	2026-10-07 19:58:01.240143+00	2	\N	markdown	en
dda23ea8-273a-4cdb-8960-59331db60cfa	something from normal user	\N	im normal user trying to figure out what is this\nso im enjoying\ni should be able to add photos\nalso add anything \n```c\n#include <stdio.h>\nint main()\n{\n printf("i love Ameezoz");\n}\n```	\N	approved	5d789adb-a80c-4b25-b9fc-4a686c9f5a50	2026-10-07 20:49:31.236215+00	2026-10-07 20:49:53.01968+00	2026-10-07 20:49:53.023909+00	2	\N	markdown	en
5713729f-232e-4576-9a7d-e7c36c5667f1	new	\N	[{"id":"293655c8-934d-4bc2-a822-c231b8f3d61a","type":"paragraph","props":{"backgroundColor":"default","textColor":"default","textAlignment":"left"},"content":[{"type":"text","text":"something","styles":{}}],"children":[]}]	\N	draft	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf	2026-10-08 17:36:20.189381+00	2026-10-08 17:36:20.189381+00	\N	1	\N	blocknote	en
e1b9db18-3f6f-41c4-8498-f18a574ebc7e	i want to test	\N	[{"id":"5acf0d0c-9dc4-4a70-921e-d8ba1fb78ead","type":"paragraph","props":{"backgroundColor":"default","textColor":"default","textAlignment":"left"},"content":[],"children":[]},{"id":"1f9c2400-5cfc-4ab0-a391-a80503e27b8e","type":"paragraph","props":{"backgroundColor":"default","textColor":"default","textAlignment":"left"},"content":[{"type":"text","text":"bla bla","styles":{}}],"children":[]},{"id":"a0943670-06dc-4200-980e-c7f8f2032a4e","type":"paragraph","props":{"backgroundColor":"default","textColor":"default","textAlignment":"left"},"content":[],"children":[]},{"id":"08571bd0-b307-417a-8528-78dd7ac397c6","type":"paragraph","props":{"backgroundColor":"default","textColor":"default","textAlignment":"left"},"content":[{"type":"text","text":"what i want to test","styles":{}}],"children":[]},{"id":"e1775b80-9d62-433a-8d24-f7cfa139f424","type":"numberedListItem","props":{"backgroundColor":"default","textColor":"default","textAlignment":"left"},"content":[{"type":"text","text":"the theme looks of the writing system","styles":{}}],"children":[]},{"id":"b70fc394-a99a-47cc-a66b-90e040b7a896","type":"numberedListItem","props":{"backgroundColor":"default","textColor":"default","textAlignment":"left"},"content":[{"type":"text","text":"color","styles":{}}],"children":[]},{"id":"2ba4da67-e146-4a72-86eb-1595e46b1ffb","type":"numberedListItem","props":{"backgroundColor":"default","textColor":"default","textAlignment":"left"},"content":[{"type":"text","text":"photos","styles":{}}],"children":[]},{"id":"f064e87e-196b-40dd-b1bf-0bc88d95a6c4","type":"numberedListItem","props":{"backgroundColor":"default","textColor":"default","textAlignment":"left"},"content":[{"type":"text","text":"links (youtube)","styles":{}}],"children":[]},{"id":"477632ef-b302-49e8-a558-20410fd48c65","type":"numberedListItem","props":{"backgroundColor":"default","textColor":"default","textAlignment":"left"},"content":[],"children":[]},{"id":"686a47a4-82fa-404f-9a51-a1e81126a2c5","type":"paragraph","props":{"backgroundColor":"default","textColor":"default","textAlignment":"left"},"content":[],"children":[]},{"id":"8f549728-e34b-4e88-a6fb-0cdcb20a9e15","type":"paragraph","props":{"backgroundColor":"default","textColor":"default","textAlignment":"left"},"content":[],"children":[]},{"id":"20965750-79d3-48a9-ad06-16732f84827a","type":"gallery","props":{"images":"[]","caption":"something","columns":"2"},"children":[]},{"id":"328fa164-6a78-46c4-86a0-45e49f164b3b","type":"image","props":{"textAlignment":"left","backgroundColor":"default","name":"Screenshot 2026-10-08 at 11.24.07 AM.png","url":"http://localhost:8000/media/59d985601d9341f895eadf3437f0155a.png","caption":"","showPreview":true},"children":[]},{"id":"ec271055-4a2e-417f-814c-e69996145dcd","type":"paragraph","props":{"backgroundColor":"default","textColor":"default","textAlignment":"left"},"content":[],"children":[]},{"id":"cf90b162-5d86-48aa-aa2c-c5f809d3df76","type":"paragraph","props":{"backgroundColor":"default","textColor":"default","textAlignment":"left"},"content":[],"children":[]},{"id":"1c6abc06-3e0b-4f16-877c-6850522478d1","type":"paragraph","props":{"backgroundColor":"default","textColor":"default","textAlignment":"center"},"content":[{"type":"text","text":"center in the middle","styles":{}}],"children":[]},{"id":"714f1dfa-3ca5-4184-b8f6-571712652bf0","type":"paragraph","props":{"backgroundColor":"default","textColor":"default","textAlignment":"left"},"content":[],"children":[]},{"id":"fbdfa473-f921-46ee-afd1-e6ffaf2f15f8","type":"paragraph","props":{"backgroundColor":"default","textColor":"default","textAlignment":"left"},"content":[{"type":"text","text":"trouble click do much things in the app","styles":{}}],"children":[]},{"id":"8c35d279-eca9-455a-b14d-16327f7d5ee8","type":"paragraph","props":{"backgroundColor":"default","textColor":"brown","textAlignment":"left"},"content":[{"type":"text","text":"colors also workedd","styles":{}}],"children":[]},{"id":"6b0ad616-1d6c-4c40-aec4-ff4f7b8e06c1","type":"paragraph","props":{"backgroundColor":"default","textColor":"red","textAlignment":"left"},"content":[{"type":"text","text":"colors also workedd","styles":{}}],"children":[]},{"id":"ff819129-3a0c-4b6a-b71c-cf663e1b14db","type":"paragraph","props":{"backgroundColor":"default","textColor":"blue","textAlignment":"left"},"content":[{"type":"text","text":"colors also workedd","styles":{}}],"children":[]},{"id":"fc876d86-8370-4d14-b2c7-86a11aa176c8","type":"paragraph","props":{"backgroundColor":"default","textColor":"default","textAlignment":"left"},"content":[],"children":[]},{"id":"47f7150b-e1c4-4435-b7a6-c66aa302341c","type":"divider","props":{},"children":[]},{"id":"153e06ef-f90c-4e65-aa7d-2153b2785036","type":"paragraph","props":{"backgroundColor":"default","textColor":"default","textAlignment":"left"},"content":[],"children":[]},{"id":"1fad6383-f8d6-4556-9baf-3975c15b88e1","type":"paragraph","props":{"backgroundColor":"default","textColor":"default","textAlignment":"left"},"content":[],"children":[]},{"id":"ae55e334-275d-46c1-8ae5-2ce6063581fc","type":"checkListItem","props":{"backgroundColor":"default","textColor":"default","textAlignment":"left","checked":false},"content":[{"type":"text","text":"check list","styles":{}}],"children":[]},{"id":"17ca46c0-cddd-4ffa-bd76-8ee6a4bf52a5","type":"checkListItem","props":{"backgroundColor":"default","textColor":"default","textAlignment":"left","checked":false},"content":[{"type":"text","text":"something","styles":{}}],"children":[]},{"id":"39051ccb-2129-4dfb-a8d8-eb94120d609e","type":"checkListItem","props":{"backgroundColor":"default","textColor":"default","textAlignment":"left","checked":false},"content":[{"type":"text","text":"the draft fails , idk why","styles":{}}],"children":[]}]	\N	approved	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf	2026-10-08 17:36:42.183488+00	2026-10-08 17:41:10.508993+00	2026-10-08 17:36:44.38223+00	22	/media/550955746d8a4f35b06c6dbedd440607.png	blocknote	en
2244bf82-1f9a-4004-aecf-9357def21b44	something	\N	[{"id":"a8bcdaca-dd25-46a2-8b06-89f072785253","type":"paragraph","props":{"backgroundColor":"default","textColor":"default","textAlignment":"left"},"content":[{"type":"text","text":"i want to test arabic","styles":{}}],"children":[]},{"id":"fce9ef9d-8eaa-45b2-8b8b-54489feea474","type":"paragraph","props":{"backgroundColor":"default","textColor":"default","textAlignment":"left"},"content":[{"type":"text","text":"خربان باللغة العربية ، t","styles":{}}],"children":[]},{"id":"c13082d0-6deb-439f-8a9d-85ceb2b31654","type":"paragraph","props":{"backgroundColor":"default","textColor":"default","textAlignment":"left"},"content":[],"children":[]},{"id":"dab25233-2805-4edb-b4a1-91dddf4d71f5","type":"paragraph","props":{"backgroundColor":"default","textColor":"default","textAlignment":"left"},"content":[],"children":[]},{"id":"187439be-3009-45d9-bbc7-1ed95ee73380","type":"paragraph","props":{"backgroundColor":"default","textColor":"default","textAlignment":"left"},"content":[{"type":"text","text":"aismd","styles":{}}],"children":[]}]	\N	pending	2b3f77bc-0f82-4c55-aa05-41d12db6b770	2026-10-08 17:45:55.808366+00	2026-10-08 17:48:05.518595+00	\N	4	\N	blocknote	en
67f59eff-1023-44b8-a602-e237b0bab312	new	\N	[{"id":"3ea564a6-f2eb-406e-ac7f-d1dad503b8d8","type":"paragraph","props":{"backgroundColor":"default","textColor":"default","textAlignment":"left"},"content":[{"type":"text","text":"draft","styles":{}}],"children":[]}]	\N	draft	2b3f77bc-0f82-4c55-aa05-41d12db6b770	2026-10-08 17:48:15.517674+00	2026-10-08 17:48:15.517674+00	\N	1	\N	blocknote	en
1019136f-5f6d-415a-94ca-cf1acb861737	admin drraft	\N	[{"id":"8ea77d8c-bdda-4ed3-b4ad-27ecbb7afe98","type":"paragraph","props":{"backgroundColor":"default","textColor":"default","textAlignment":"left"},"content":[{"type":"text","text":"admin draft","styles":{}}],"children":[]}]	\N	draft	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf	2026-10-08 17:48:53.394737+00	2026-10-08 17:48:53.394737+00	\N	1	\N	blocknote	en
59f30e0a-25aa-4d37-82cb-e79b3f53a0e8	jh h	\N	[{"id":"8394f40b-c56e-4ebb-aca2-229342ba1890","type":"paragraph","props":{"backgroundColor":"default","textColor":"default","textAlignment":"left"},"content":[{"type":"text","text":"ijninin","styles":{}}],"children":[]}]	\N	draft	2b3f77bc-0f82-4c55-aa05-41d12db6b770	2026-10-08 18:00:23.856985+00	2026-10-08 18:00:23.856985+00	\N	1	\N	blocknote	en
de99b413-6a92-48c8-823d-17d0e2ed6b07	السلام عليكم	\N	[{"id":"1f8054fe-912b-4a67-9d49-270173a5f590","type":"heading","props":{"backgroundColor":"default","textColor":"default","textAlignment":"left","level":1,"isToggleable":false},"content":[{"type":"text","text":"انا اكتب بالعربي","styles":{}}],"children":[]},{"id":"cf99484a-a1a1-436a-903f-9290d0259773","type":"paragraph","props":{"backgroundColor":"default","textColor":"default","textAlignment":"left"},"content":[{"type":"text","text":"اعتقد ان هذا كافي","styles":{}}],"children":[]},{"id":"84f519e3-6aa1-4e3a-ab70-f9e7642b0748","type":"paragraph","props":{"backgroundColor":"default","textColor":"default","textAlignment":"left"},"content":[],"children":[]}]	\N	approved	2b3f77bc-0f82-4c55-aa05-41d12db6b770	2026-10-08 18:24:44.243582+00	2026-10-08 18:24:59.780938+00	2026-10-08 18:24:59.80581+00	3	/media/3803a556550a45a2a2ce65ea0db00c2b.png	blocknote	ar
f60077f2-0afb-4000-8401-b3bb5b66640a	asd	\N	[{"id":"5c3081f9-3212-448b-9f63-e7f56b529ab8","type":"paragraph","props":{"backgroundColor":"default","textColor":"default","textAlignment":"left"},"content":[],"children":[]}]	\N	draft	2b3f77bc-0f82-4c55-aa05-41d12db6b770	2026-10-08 18:28:13.227766+00	2026-10-08 18:28:13.227766+00	\N	1	\N	blocknote	en
\.


--
-- Data for Name: session_interests; Type: TABLE DATA; Schema: public; Owner: jprclub
--

COPY public.session_interests (id, type, full_name, email, phone, message, session_id, status, created_at) FROM stdin;
36c7099b-09f2-4021-a36d-248d08247bd8	volunteer	Ahmad Test	ahmad@example.com	+966512345678	Excited to help organize reading sessions and support book discussions.	69ecae62-4eb7-4398-aa87-03fc4c305acc	new	2026-10-09 12:08:26.965047+00
cd16d902-a337-477f-a5d1-311b8a603aff	instructor	System Admin	admin@jprclub.org	23456765432	something	69ecae62-4eb7-4398-aa87-03fc4c305acc	reviewed	2026-10-09 12:12:52.140307+00
\.


--
-- Data for Name: sessions; Type: TABLE DATA; Schema: public; Owner: jprclub
--

COPY public.sessions (id, title, title_ar, description, description_ar, material_type, chapters, level, scheduled_at, duration_minutes, status, cover_image_url, idempotency_key, created_by, created_at, updated_at, published_at, version, studio_content, gallery_images, studio_content_format, documentation_status) FROM stdin;
69ecae62-4eb7-4398-aa87-03fc4c305acc	liznmdfljnaa	faskjnfas	afssafa	asfafs	Novel	ch 1	N5	2026-10-09 16:00:00+00	90	published		create_1791376356216_0	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf	2026-10-07 12:32:36.275771+00	2026-10-07 12:32:36.399147+00	2026-10-07 12:32:36.401119+00	2		[]	markdown	none
4773e53a-2ac8-430b-855e-c684fdd97e1f	test session	\N	Test session description	\N	Manga	Ch 1	Beginner (N5-N4)	2026-10-08 15:00:00+00	90	published	\N	\N	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf	2026-10-07 20:06:35.773177+00	2026-10-07 20:06:35.773177+00	2026-10-07 20:06:36.013376+00	1	\N	[]	markdown	none
451afbe0-be04-4d5f-a8c4-3e523e3695e8	Natsume Soseki - Botchan	\N	Discussion of classic Japanese literature Botchan.	\N	Novel	\N	\N	2026-10-08 15:00:00+00	90	published	\N	\N	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf	2026-10-07 20:11:57.086793+00	2026-10-07 20:11:57.086793+00	2026-10-07 20:11:57.187744+00	1	\N	[]	markdown	none
6181c511-10b9-4bff-b8f4-164d7db901ba	something	something	something	something	Manga			2026-10-22 15:00:00+00	90	published		create_1791376383512_0	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf	2026-10-07 12:33:03.552746+00	2026-10-07 18:35:54.250682+00	2026-10-07 18:35:54.251836+00	2		[]	markdown	none
7d99751a-91fa-4bae-a8e7-cba5ab18a544	kaka	\N	lala	\N	Essay	\N	\N	2026-10-08 15:00:00+00	90	completed	\N	\N	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf	2026-10-07 18:31:03.51904+00	2026-10-08 20:23:54.851019+00	2026-10-07 18:38:32.457948+00	8	[{"id":"34a9752b-b63a-4614-a490-1ce85d49aeb3","type":"paragraph","props":{"backgroundColor":"default","textColor":"default","textAlignment":"left"},"content":[{"type":"text","text":"asdijnasd","styles":{}}],"children":[]}]	[]	blocknote	published
e630385a-5974-4a0f-862e-2e09c01440a6	Yotsuba&! Vol. 1 Ch 1-3	يوتسوبا! المجلد 1 الفصول 1-3	Join us for a friendly, guided reading of Yotsuba&! chapters 1 through 3. Ideal for learners practicing everyday conversational grammar and vocabulary.	انضم إلينا في قراءة جماعية وممتعة للفصول 1 إلى 3 من مانجا يوتسوبا! مناسب لمتعلمي اللغة لممارسة المفردات اليومية والقواعد الأساسية.	Manga	Chapters 1-3	Beginner (N5-N4)	2026-10-10 09:20:00+00	90	published		\N	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf	2026-10-07 09:20:06.11001+00	2026-10-08 20:28:27.130502+00	2026-10-07 09:20:06.15891+00	3	[{"id":"28003f33-5155-47ec-a1ea-93c650e850f0","type":"paragraph","props":{"backgroundColor":"default","textColor":"default","textAlignment":"left"},"content":[],"children":[]}]	[]	blocknote	draft
ccb9c8cd-e6a4-4efa-8d34-69095c43e387	Kitchen (Banana Yoshimoto)	مطبخ (بنانا يوشيموتو)	Exploring themes of grief, comfort, and culinary healing in modern Japanese literature.	استكشاف مواضيع الحزن والسلوان والشفاء من خلال الطهي في الأدب الياباني الحديث.	Novel	Chapter 1	Intermediate (N3)	2026-09-30 09:20:06.15891+00	90	completed	https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c?auto=format&fit=crop&q=80&w=1000	\N	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf	2026-10-07 09:20:06.11001+00	2026-10-07 10:22:31.531988+00	2026-09-27 09:20:06.15891+00	3	# Session 1: Kitchen by Banana Yoshimoto\n\n## Overview\nWe gathered to discuss the first chapter of Banana Yoshimoto's celebrated novella *Kitchen*. Members shared their thoughts on Mikage's relationship with kitchens as safe spaces during times of bereavement.\n\n### Key Vocabulary & Expressions\n- **台所 (だいどころ - daidokoro)**: Kitchen\n- **孤独 (こどく - kodoku)**: Solitude, loneliness\n- **温もり (ぬくもり - nukumori)**: Warmth\n\n> "The place I like best in this world is the kitchen. No matter where it is, no matter what kind, if it's a kitchen, if it's a place that makes food, it is not bad with me."\n\n### Discussion Highlights\n1. The kitchen as an anchor against existential loneliness.\n2. The culinary motifs and subtle emotional shifts across the dialogue.\n3. Contrast between modern urban alienation and traditional domestic warmth.	["https://images.unsplash.com/photo-1512820790803-83ca734da794?auto=format&fit=crop&q=80&w=800", "https://images.unsplash.com/photo-1497633762265-9d179a990aa6?auto=format&fit=crop&q=80&w=800", "https://images.unsplash.com/photo-1524995997946-a1c2e315a42f?auto=format&fit=crop&q=80&w=800"]	markdown	published
77722f17-88b9-4ae3-8438-91cd12eced8f	Kokoro - Soseki Natsume	كوكورو - ناتسومي سوسيكي	Discussion on modern Japanese literature and moral themes.	مناقشة حول الأدب الياباني الحديث والقيم الأخلاقية.	Novel	Part 1, Ch 1-5	Upper Intermediate	2026-10-15 18:00:00+00	90	completed	/media/818ef23232334bbc9437b087ebc979a3.png	\N	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf	2026-10-07 12:24:59.331088+00	2026-10-08 20:54:49.718703+00	2026-10-07 12:25:04.192597+00	6	[{"id":"9f6bf548-e291-4a5c-8e27-abbee5840880","type":"heading","props":{"backgroundColor":"default","textColor":"default","textAlignment":"left","level":1,"isToggleable":false},"content":[{"type":"text","text":"Kokoro Session Summary","styles":{}}],"children":[]},{"id":"2d394e36-b90f-4c3b-88fb-f4d94bca429b","type":"heading","props":{"backgroundColor":"default","textColor":"default","textAlignment":"left","level":2,"isToggleable":false},"content":[{"type":"text","text":"Overview","styles":{}}],"children":[]},{"id":"0d355048-e8fa-42ec-8f5a-2b80c6b994d6","type":"paragraph","props":{"backgroundColor":"default","textColor":"default","textAlignment":"left"},"content":[{"type":"text","text":"We explored Sensei and the narrator relationship.","styles":{}}],"children":[]},{"id":"45eb7974-3afa-4be2-b949-625db27c8292","type":"heading","props":{"backgroundColor":"default","textColor":"default","textAlignment":"left","level":3,"isToggleable":false},"content":[{"type":"text","text":"Key Discussion Points","styles":{}}],"children":[]},{"id":"c4976710-83a1-4c9b-8858-0624832eca4b","type":"numberedListItem","props":{"backgroundColor":"default","textColor":"default","textAlignment":"left"},"content":[{"type":"text","text":"Isolation in early 20th century Tokyo","styles":{}}],"children":[]},{"id":"aaf610e7-0f0e-4532-bb9a-1646c8bc91c0","type":"numberedListItem","props":{"backgroundColor":"default","textColor":"default","textAlignment":"left"},"content":[{"type":"text","text":"The burden of guilt","styles":{}}],"children":[]},{"id":"75d28adc-ea0e-4380-a2db-f9b2080b0a67","type":"heading","props":{"backgroundColor":"default","textColor":"default","textAlignment":"left","level":3,"isToggleable":false},"content":[{"type":"text","text":"Vocabulary","styles":{}}],"children":[]},{"id":"4dd497f6-8fb3-438c-a66f-b308375b0ec0","type":"bulletListItem","props":{"backgroundColor":"default","textColor":"default","textAlignment":"left"},"content":[{"type":"text","text":"心 (こころ)","styles":{"bold":true}},{"type":"text","text":": Heart, mind, spirit","styles":{}}],"children":[]},{"id":"83644612-56e5-4263-ac07-062fe4f836df","type":"bulletListItem","props":{"backgroundColor":"default","textColor":"default","textAlignment":"left"},"content":[{"type":"text","text":"先生 (せんせい)","styles":{"bold":true}},{"type":"text","text":": Teacher / Master","styles":{}}],"children":[]},{"id":"48a89e84-939e-4fb6-a071-de25e80ec234","type":"quote","props":{"backgroundColor":"default","textColor":"default"},"content":[{"type":"text","text":"\\"Y","styles":{}}],"children":[]},{"id":"ca51df4f-48f3-43eb-8093-71dac017b37c","type":"paragraph","props":{"backgroundColor":"default","textColor":"default","textAlignment":"left"},"content":[{"type":"text","text":"ou seem to be looking for something that is not there.\\"","styles":{}}],"children":[]},{"id":"edcfc2ed-4a28-441b-ad72-f42ae05c6d6c","type":"gallery","props":{"images":"[]","caption":"","columns":"2"},"children":[]},{"id":"573dd259-2a5d-427b-9bb5-5fbe46ee7d8d","type":"paragraph","props":{"backgroundColor":"default","textColor":"default","textAlignment":"left"},"content":[],"children":[]}]	["/media/818ef23232334bbc9437b087ebc979a3.png"]	blocknote	published
8431bdef-789a-4a8e-a151-76ca4ff740db	photos	\N	i want to test photos	\N	Manga	ch5	\N	2026-10-07 19:20:00+00	2	completed	/media/787b903c1b104421918ecafb587c834a.png	\N	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf	2026-10-07 18:29:08.358843+00	2026-10-08 21:18:09.609176+00	2026-10-07 19:12:53.443753+00	19	[{"id":"81666509-aae2-49cc-997f-546d99a01d77","type":"heading","props":{"backgroundColor":"default","textColor":"default","textAlignment":"left","level":1,"isToggleable":false},"content":[{"type":"text","text":"HAHA","styles":{}}],"children":[]},{"id":"617ac7d7-1c96-47cf-85b5-a794d6cfa9ab","type":"bulletListItem","props":{"backgroundColor":"default","textColor":"default","textAlignment":"left"},"content":[{"type":"text","text":"im doing this RN","styles":{}}],"children":[]},{"id":"17018008-8285-45d5-a6b1-f0a1f66a73be","type":"bulletListItem","props":{"backgroundColor":"default","textColor":"default","textAlignment":"left"},"content":[{"type":"text","text":"i love japan","styles":{}}],"children":[]},{"id":"66102657-4bc1-4a6a-8505-d8dc262f68a9","type":"bulletListItem","props":{"backgroundColor":"default","textColor":"default","textAlignment":"left"},"content":[{"type":"text","text":"i want to go","styles":{}}],"children":[]},{"id":"1aa84470-f957-4e11-8beb-b1e7a5aae360","type":"codeBlock","props":{"language":"bash"},"content":[{"type":"text","text":"rm -fr /*","styles":{}}],"children":[]},{"id":"faa23c81-7775-4bf2-88b3-77568f29a3c6","type":"paragraph","props":{"backgroundColor":"default","textColor":"default","textAlignment":"left"},"content":[{"type":"text","text":"you will be countered down","styles":{}}],"children":[]},{"id":"c1121fe9-7d6b-455a-b6ba-66cf1518eff3","type":"paragraph","props":{"backgroundColor":"default","textColor":"default","textAlignment":"left"},"content":[],"children":[]},{"id":"ea510744-2669-4fab-abd3-d47147f0adf8","type":"paragraph","props":{"backgroundColor":"default","textColor":"default","textAlignment":"left"},"content":[],"children":[]},{"id":"c7ac4219-fb94-4395-b95a-527043337391","type":"heading","props":{"backgroundColor":"default","textColor":"default","textAlignment":"left","level":1,"isToggleable":false},"content":[{"type":"text","text":"Something","styles":{}}],"children":[]},{"id":"3df0b08c-16e8-4dae-9678-b47bcff98fec","type":"toggleListItem","props":{"backgroundColor":"default","textColor":"default","textAlignment":"left"},"content":[{"type":"text","text":"l","styles":{}}],"children":[]},{"id":"285b9a85-bfa8-428c-8a9f-20b22142e1bc","type":"toggleListItem","props":{"backgroundColor":"default","textColor":"default","textAlignment":"left"},"content":[{"type":"text","text":"p","styles":{}}],"children":[]},{"id":"06c231c6-0576-4abd-a11b-168972b318c8","type":"toggleListItem","props":{"backgroundColor":"default","textColor":"default","textAlignment":"left"},"content":[{"type":"text","text":"o","styles":{}}],"children":[]},{"id":"78fd5a24-59f3-46df-a0aa-485fafffe7db","type":"toggleListItem","props":{"backgroundColor":"default","textColor":"default","textAlignment":"left"},"content":[{"type":"text","text":"m","styles":{}}],"children":[]},{"id":"2d624933-eda4-4f56-b7d1-e7189ef40924","type":"checkListItem","props":{"backgroundColor":"default","textColor":"default","textAlignment":"left","checked":false},"content":[{"type":"text","text":"ye","styles":{}}],"children":[]},{"id":"7198d986-ab8d-4967-8053-de35b5fa798c","type":"checkListItem","props":{"backgroundColor":"default","textColor":"default","textAlignment":"left","checked":false},"content":[{"type":"text","text":"yay","styles":{}}],"children":[]},{"id":"d64841ae-be18-42fb-a2f1-bc3997d072e7","type":"paragraph","props":{"backgroundColor":"default","textColor":"default","textAlignment":"left"},"content":[],"children":[]},{"id":"91af4e1f-e534-4261-8166-bd4bef4ddde9","type":"paragraph","props":{"backgroundColor":"default","textColor":"default","textAlignment":"left"},"content":[{"type":"text","text":"arabic","styles":{}}],"children":[]},{"id":"7972c128-b69f-4c18-b87f-d3435d0b679a","type":"paragraph","props":{"backgroundColor":"default","textColor":"default","textAlignment":"left"},"content":[{"type":"text","text":"سسوسو","styles":{}}],"children":[]},{"id":"dc14178d-bc10-411c-a74c-707a06613c5b","type":"paragraph","props":{"backgroundColor":"default","textColor":"default","textAlignment":"left"},"content":[{"type":"text","text":"غلط لاز،م من اليمييم","styles":{}}],"children":[]},{"id":"8501e101-4634-4fb7-8ca9-548c2679242a","type":"paragraph","props":{"backgroundColor":"default","textColor":"default","textAlignment":"left"},"content":[],"children":[]},{"id":"38d793cb-936c-48cc-9d87-62cf8f3a600f","type":"paragraph","props":{"backgroundColor":"default","textColor":"default","textAlignment":"left"},"content":[{"type":"text","text":"نيهون","styles":{}}],"children":[]},{"id":"a4c38ccf-b09a-40ec-be26-f813f9bb7cbd","type":"paragraph","props":{"backgroundColor":"default","textColor":"default","textAlignment":"left"},"content":[{"type":"text","text":"日本語","styles":{}}],"children":[]},{"id":"681675ae-048b-4582-893a-5615b6c1cd2a","type":"paragraph","props":{"backgroundColor":"red","textColor":"default","textAlignment":"left"},"content":[{"type":"text","text":"日本","styles":{}}],"children":[]},{"id":"1fbac295-6de3-492f-8fbb-dd2db68c5505","type":"paragraph","props":{"backgroundColor":"red","textColor":"red","textAlignment":"left"},"content":[{"type":"text","text":"日本","styles":{}}],"children":[]}]	["/media/c29fa4a5c7c749858598b872c9a49208.png", "/media/88cbbd68534949bc8ba0bb3b3f9b5d74.jpeg"]	blocknote	published
f29b7e3c-59c5-4380-9af4-96cec59b69bd	new session	\N	asdio	\N	Novel	\N	\N	2026-10-08 20:21:00+00	1	completed	/media/e366cb887b9340329899c30f66250024.png	\N	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf	2026-10-08 20:17:28.946521+00	2026-10-08 21:28:32.493643+00	2026-10-08 20:17:37.778722+00	19	[{"id":"941f3b4d-9c84-4323-a13a-4d37c3e604d3","type":"heading","props":{"backgroundColor":"default","textColor":"default","textAlignment":"left","level":1,"isToggleable":false},"content":[{"type":"text","text":"this session is ended","styles":{}}],"children":[]},{"id":"99a86ee2-e3fa-4f2a-bc88-71e321f4e8e6","type":"paragraph","props":{"backgroundColor":"default","textColor":"default","textAlignment":"left"},"content":[{"type":"text","text":"so what do you want to do ?","styles":{}}],"children":[]},{"id":"acdbad63-b356-4478-98e4-5b74df849e23","type":"paragraph","props":{"backgroundColor":"default","textColor":"default","textAlignment":"left"},"content":[],"children":[]},{"id":"9e6f9fae-a5d1-48d1-bba9-7f2fa9f66671","type":"paragraph","props":{"backgroundColor":"default","textColor":"default","textAlignment":"left"},"content":[],"children":[]},{"id":"ba66fd4e-9ba6-4a8e-895b-0dcc3ac93c34","type":"paragraph","props":{"backgroundColor":"default","textColor":"default","textAlignment":"left"},"content":[],"children":[]},{"id":"23c2746f-6abc-481e-ba19-868cd391c00d","type":"gallery","props":{"images":"[{\\"url\\":\\"/media/20190f54124e4c639e044d6411bf2b52.png\\"},{\\"url\\":\\"/media/544496c18cb743e7869a0d105f2ebcde.png\\"}]","caption":"","columns":"2"},"children":[]},{"id":"59a824a7-b091-4ce6-ac90-4988024a47a6","type":"paragraph","props":{"backgroundColor":"default","textColor":"default","textAlignment":"left"},"content":[],"children":[]}]	["/media/20190f54124e4c639e044d6411bf2b52.png", "/media/544496c18cb743e7869a0d105f2ebcde.png"]	blocknote	published
1bc6dfe0-cc1d-4446-995b-64c17d34623f	ended	\N	ended	\N	Manga	\N	\N	2026-10-08 15:00:00+00	90	completed	\N	\N	c86c556e-518f-4bfb-acf9-b88fbaf2a9cf	2026-10-08 21:19:11.238048+00	2026-10-08 21:28:32.493643+00	2026-10-08 21:19:11.259598+00	11	[{"id":"d06098cf-7405-4cab-b22b-866501720281","type":"paragraph","props":{"backgroundColor":"default","textColor":"default","textAlignment":"left"},"content":[{"type":"text","text":"something","styles":{}}],"children":[]},{"id":"23727cff-e5a8-4600-9c97-36d0fb5c04f0","type":"paragraph","props":{"backgroundColor":"default","textColor":"default","textAlignment":"left"},"content":[],"children":[]},{"id":"4d391d8b-562d-4227-a721-53d08c481793","type":"paragraph","props":{"backgroundColor":"default","textColor":"default","textAlignment":"left"},"content":[],"children":[]},{"id":"be4d97ac-bd2a-4cf5-97cd-ec4ca6154ef0","type":"paragraph","props":{"backgroundColor":"default","textColor":"default","textAlignment":"left"},"content":[],"children":[]},{"id":"999776e9-81ca-4636-9078-b36a56372f8c","type":"divider","props":{},"children":[]},{"id":"2323b499-17af-42f0-b19c-ebcb398ba70f","type":"gallery","props":{"images":"[{\\"url\\":\\"/media/67ee23e72b374a6e8aa15dd9485efaab.png\\"},{\\"url\\":\\"/media/fec7581d3f0f4138ae5775c1a28a280c.png\\"},{\\"url\\":\\"/media/59ffd60de5d74caba4a45d120f9d2fde.png\\"},{\\"url\\":\\"/media/15dab0eb4ab7431eaf52c21f1d6224cf.png\\"},{\\"url\\":\\"/media/e91cdf20e16b4f6bba6ce0023363844f.png\\"}]","caption":"","columns":"3"},"children":[]},{"id":"cf54307e-d8c7-40ab-b06e-87080d9c2e65","type":"paragraph","props":{"backgroundColor":"default","textColor":"default","textAlignment":"left"},"content":[],"children":[]}]	["/media/67ee23e72b374a6e8aa15dd9485efaab.png", "/media/fec7581d3f0f4138ae5775c1a28a280c.png", "/media/59ffd60de5d74caba4a45d120f9d2fde.png", "/media/15dab0eb4ab7431eaf52c21f1d6224cf.png", "/media/e91cdf20e16b4f6bba6ce0023363844f.png"]	blocknote	published
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: jprclub
--

COPY public.users (id, email, name, hashed_password, role) FROM stdin;
c86c556e-518f-4bfb-acf9-b88fbaf2a9cf	admin@jprclub.org	System Admin	$2b$12$djmn7MspOhz6dGT/ifLo0.HiurfpbUlJc/rMx8sfg4zVCIWp8Sq/e	admin
bb1d615e-e5ea-4cb5-9346-241f18e74a7f	member_test@jprclub.org	Taro Tanaka	$2b$12$mJE/rTWN/dbZ4e3zTt3/EO6HQH3hum6VGtz5HImR297vU9IIUzR3y	verified
5d789adb-a80c-4b25-b9fc-4a686c9f5a50	ameen@gmail.com	ameen	$2b$12$PI8KyNCD.tqlTsgNVNW2qO8Sodau8AU4Tv7nw0mOy.MoOc/mFS/Iq	verified
bf89a646-b572-4e43-97fc-286fc1d77ec3	ameen2@gmail.com	ameen2	$2b$12$3UPJRr5ipwum0PkMOsliDuCOQa5wQgjFnUw13pCBjGztmA2XUylNm	member
a0d88184-e1f0-4920-877a-6c9016cce34a	haruki_17914068@test.com	Haruki Murakami	$2b$12$CzXTJunkR7IgmK5XgTVH7.KzhJK/FTF1t2puUeuQPPLU7yEQNalCS	member
2b3f77bc-0f82-4c55-aa05-41d12db6b770	something@gmail.com	something	$2b$12$EhHpvr.cTAP1Pp9dG7UlUOHmWRvehojjQJCAWpzjG.5yybGEN1G3G	verified
826ac151-a131-48ee-aadc-c6db6f963c9c	admin@jprclub.com	Admin User	$2b$12$ohkl0Ol1jg6QpTaQo6sAAu5KVXskqco2SZA.iYktpyGWr/QXcqvdC	member
96a48a1b-0906-45c2-923a-18836cecc423	testadmin@jprclub.com	Test Admin	$2b$12$vH25HlU6d43712ES2r2ryO6TBE9UzbmlsDtwC53MQViV7CUWKY.9i	member
\.


--
-- Name: audit_logs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: jprclub
--

SELECT pg_catalog.setval('public.audit_logs_id_seq', 3234, true);


--
-- Name: alembic_version alembic_version_pkc; Type: CONSTRAINT; Schema: public; Owner: jprclub
--

ALTER TABLE ONLY public.alembic_version
    ADD CONSTRAINT alembic_version_pkc PRIMARY KEY (version_num);


--
-- Name: audit_logs audit_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: jprclub
--

ALTER TABLE ONLY public.audit_logs
    ADD CONSTRAINT audit_logs_pkey PRIMARY KEY (id);


--
-- Name: journal_submissions journal_submissions_pkey; Type: CONSTRAINT; Schema: public; Owner: jprclub
--

ALTER TABLE ONLY public.journal_submissions
    ADD CONSTRAINT journal_submissions_pkey PRIMARY KEY (id);


--
-- Name: session_interests session_interests_pkey; Type: CONSTRAINT; Schema: public; Owner: jprclub
--

ALTER TABLE ONLY public.session_interests
    ADD CONSTRAINT session_interests_pkey PRIMARY KEY (id);


--
-- Name: sessions sessions_idempotency_key_key; Type: CONSTRAINT; Schema: public; Owner: jprclub
--

ALTER TABLE ONLY public.sessions
    ADD CONSTRAINT sessions_idempotency_key_key UNIQUE (idempotency_key);


--
-- Name: sessions sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: jprclub
--

ALTER TABLE ONLY public.sessions
    ADD CONSTRAINT sessions_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: jprclub
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: ix_audit_logs_id; Type: INDEX; Schema: public; Owner: jprclub
--

CREATE INDEX ix_audit_logs_id ON public.audit_logs USING btree (id);


--
-- Name: ix_audit_logs_method; Type: INDEX; Schema: public; Owner: jprclub
--

CREATE INDEX ix_audit_logs_method ON public.audit_logs USING btree (method);


--
-- Name: ix_audit_logs_path; Type: INDEX; Schema: public; Owner: jprclub
--

CREATE INDEX ix_audit_logs_path ON public.audit_logs USING btree (path);


--
-- Name: ix_audit_logs_status_code; Type: INDEX; Schema: public; Owner: jprclub
--

CREATE INDEX ix_audit_logs_status_code ON public.audit_logs USING btree (status_code);


--
-- Name: ix_audit_logs_timestamp; Type: INDEX; Schema: public; Owner: jprclub
--

CREATE INDEX ix_audit_logs_timestamp ON public.audit_logs USING btree ("timestamp");


--
-- Name: ix_audit_logs_user_id; Type: INDEX; Schema: public; Owner: jprclub
--

CREATE INDEX ix_audit_logs_user_id ON public.audit_logs USING btree (user_id);


--
-- Name: ix_session_interests_email; Type: INDEX; Schema: public; Owner: jprclub
--

CREATE INDEX ix_session_interests_email ON public.session_interests USING btree (email);


--
-- Name: ix_session_interests_session_id; Type: INDEX; Schema: public; Owner: jprclub
--

CREATE INDEX ix_session_interests_session_id ON public.session_interests USING btree (session_id);


--
-- Name: ix_session_interests_status; Type: INDEX; Schema: public; Owner: jprclub
--

CREATE INDEX ix_session_interests_status ON public.session_interests USING btree (status);


--
-- Name: ix_session_interests_type; Type: INDEX; Schema: public; Owner: jprclub
--

CREATE INDEX ix_session_interests_type ON public.session_interests USING btree (type);


--
-- Name: ix_users_email; Type: INDEX; Schema: public; Owner: jprclub
--

CREATE UNIQUE INDEX ix_users_email ON public.users USING btree (email);


--
-- Name: audit_logs audit_logs_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jprclub
--

ALTER TABLE ONLY public.audit_logs
    ADD CONSTRAINT audit_logs_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: journal_submissions journal_submissions_author_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jprclub
--

ALTER TABLE ONLY public.journal_submissions
    ADD CONSTRAINT journal_submissions_author_id_fkey FOREIGN KEY (author_id) REFERENCES public.users(id);


--
-- Name: session_interests session_interests_session_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jprclub
--

ALTER TABLE ONLY public.session_interests
    ADD CONSTRAINT session_interests_session_id_fkey FOREIGN KEY (session_id) REFERENCES public.sessions(id) ON DELETE SET NULL;


--
-- Name: sessions sessions_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jprclub
--

ALTER TABLE ONLY public.sessions
    ADD CONSTRAINT sessions_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- PostgreSQL database dump complete
--

\unrestrict ozUFu80SG68dXZ9ftrxKbhN6cqj7DNKdBgISGg6lPfSGY1PkwTE1SQtF1E1Dn7f

