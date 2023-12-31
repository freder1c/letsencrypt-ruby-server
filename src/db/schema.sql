--
-- PostgreSQL database dump
--

-- Dumped from database version 15.2 (Debian 15.2-1.pgdg110+1)
-- Dumped by pg_dump version 15.4

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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: accounts; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.accounts (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    email text NOT NULL,
    encrypted_password text NOT NULL,
    reset_password_token text,
    reset_password_sent_at timestamp(6) without time zone,
    failed_attempts integer DEFAULT 0 NOT NULL,
    unlock_token text,
    locked_at timestamp(6) without time zone,
    locale text,
    created_at timestamp(6) without time zone NOT NULL,
    key_id text
);


ALTER TABLE public.accounts OWNER TO root;

--
-- Name: challenges; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.challenges (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    order_id uuid NOT NULL,
    url text NOT NULL,
    token text NOT NULL,
    status text NOT NULL,
    type text NOT NULL,
    content jsonb NOT NULL,
    created_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.challenges OWNER TO root;

--
-- Name: keys; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.keys (
    id text NOT NULL,
    account_id uuid NOT NULL,
    created_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.keys OWNER TO root;

--
-- Name: orders; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.orders (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    account_id text NOT NULL,
    key_id text NOT NULL,
    url text NOT NULL,
    status text,
    identifier text NOT NULL,
    finalize_url text NOT NULL,
    certificate_url text,
    created_at timestamp(6) without time zone NOT NULL,
    finalized_at timestamp(6) without time zone,
    expires_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.orders OWNER TO root;

--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.schema_migrations (
    filename text NOT NULL
);


ALTER TABLE public.schema_migrations OWNER TO root;

--
-- Name: sessions; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.sessions (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    account_id uuid NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    expires_at timestamp(6) without time zone
);


ALTER TABLE public.sessions OWNER TO root;

--
-- Name: accounts accounts_pkey; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.accounts
    ADD CONSTRAINT accounts_pkey PRIMARY KEY (id);


--
-- Name: challenges challenges_pkey; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.challenges
    ADD CONSTRAINT challenges_pkey PRIMARY KEY (id);


--
-- Name: keys keys_pkey; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.keys
    ADD CONSTRAINT keys_pkey PRIMARY KEY (id, account_id);


--
-- Name: orders orders_pkey; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (filename);


--
-- Name: sessions sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.sessions
    ADD CONSTRAINT sessions_pkey PRIMARY KEY (id);


--
-- Name: accounts_email_index; Type: INDEX; Schema: public; Owner: root
--

CREATE UNIQUE INDEX accounts_email_index ON public.accounts USING btree (email);


--
-- Name: keys_id_account_id_index; Type: INDEX; Schema: public; Owner: root
--

CREATE UNIQUE INDEX keys_id_account_id_index ON public.keys USING btree (id, account_id);


--
-- Name: orders_account_id_index; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX orders_account_id_index ON public.orders USING btree (account_id);


--
-- Name: sessions_account_id_index; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX sessions_account_id_index ON public.sessions USING btree (account_id);


--
-- PostgreSQL database dump complete
--

