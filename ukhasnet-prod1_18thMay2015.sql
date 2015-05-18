--
-- PostgreSQL database dump
--

-- Dumped from database version 9.3.6
-- Dumped by pg_dump version 9.3.6
-- Started on 2015-05-18 10:23:03 BST

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'SQL_ASCII';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- TOC entry 7 (class 2615 OID 17044)
-- Name: ukhasnet; Type: SCHEMA; Schema: -; Owner: g_ukhasnet
--

CREATE SCHEMA ukhasnet;


ALTER SCHEMA ukhasnet OWNER TO g_ukhasnet;

--
-- TOC entry 193 (class 3079 OID 11787)
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- TOC entry 2118 (class 0 OID 0)
-- Dependencies: 193
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = ukhasnet, pg_catalog;

--
-- TOC entry 578 (class 1247 OID 17054)
-- Name: ftypes; Type: TYPE; Schema: ukhasnet; Owner: postgres
--

CREATE TYPE ftypes AS ENUM (
    'Float',
    'String',
    'Integer',
    'Location',
    'NULL'
);


ALTER TYPE ukhasnet.ftypes OWNER TO postgres;

--
-- TOC entry 581 (class 1247 OID 18651)
-- Name: msgstate; Type: TYPE; Schema: ukhasnet; Owner: mike
--

CREATE TYPE msgstate AS ENUM (
    'Pending',
    'Sent'
);


ALTER TYPE ukhasnet.msgstate OWNER TO mike;

--
-- TOC entry 575 (class 1247 OID 17046)
-- Name: state; Type: TYPE; Schema: ukhasnet; Owner: postgres
--

CREATE TYPE state AS ENUM (
    'Pending',
    'Error',
    'Processed'
);


ALTER TYPE ukhasnet.state OWNER TO postgres;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- TOC entry 184 (class 1259 OID 17162)
-- Name: data_float; Type: TABLE; Schema: ukhasnet; Owner: g_ukhasnet; Tablespace: 
--

CREATE TABLE data_float (
    id integer NOT NULL,
    packetid integer NOT NULL,
    fieldid integer,
    data double precision,
    "position" smallint NOT NULL
);


ALTER TABLE ukhasnet.data_float OWNER TO g_ukhasnet;

--
-- TOC entry 183 (class 1259 OID 17160)
-- Name: data_float_id_seq; Type: SEQUENCE; Schema: ukhasnet; Owner: g_ukhasnet
--

CREATE SEQUENCE data_float_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE ukhasnet.data_float_id_seq OWNER TO g_ukhasnet;

--
-- TOC entry 2119 (class 0 OID 0)
-- Dependencies: 183
-- Name: data_float_id_seq; Type: SEQUENCE OWNED BY; Schema: ukhasnet; Owner: g_ukhasnet
--

ALTER SEQUENCE data_float_id_seq OWNED BY data_float.id;


--
-- TOC entry 188 (class 1259 OID 17196)
-- Name: data_location; Type: TABLE; Schema: ukhasnet; Owner: g_ukhasnet; Tablespace: 
--

CREATE TABLE data_location (
    id integer NOT NULL,
    packetid integer NOT NULL,
    latitude double precision NOT NULL,
    longitude double precision NOT NULL,
    altitude double precision
);


ALTER TABLE ukhasnet.data_location OWNER TO g_ukhasnet;

--
-- TOC entry 187 (class 1259 OID 17194)
-- Name: data_location_id_seq; Type: SEQUENCE; Schema: ukhasnet; Owner: g_ukhasnet
--

CREATE SEQUENCE data_location_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE ukhasnet.data_location_id_seq OWNER TO g_ukhasnet;

--
-- TOC entry 2120 (class 0 OID 0)
-- Dependencies: 187
-- Name: data_location_id_seq; Type: SEQUENCE OWNED BY; Schema: ukhasnet; Owner: g_ukhasnet
--

ALTER SEQUENCE data_location_id_seq OWNED BY data_location.id;


--
-- TOC entry 172 (class 1259 OID 17067)
-- Name: fieldtypes; Type: TABLE; Schema: ukhasnet; Owner: g_ukhasnet; Tablespace: 
--

CREATE TABLE fieldtypes (
    id integer NOT NULL,
    type ftypes NOT NULL,
    name character varying(20) DEFAULT NULL::character varying,
    dataid character(1) DEFAULT NULL::bpchar
);


ALTER TABLE ukhasnet.fieldtypes OWNER TO g_ukhasnet;

--
-- TOC entry 171 (class 1259 OID 17065)
-- Name: fieldtypes_id_seq; Type: SEQUENCE; Schema: ukhasnet; Owner: g_ukhasnet
--

CREATE SEQUENCE fieldtypes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE ukhasnet.fieldtypes_id_seq OWNER TO g_ukhasnet;

--
-- TOC entry 2121 (class 0 OID 0)
-- Dependencies: 171
-- Name: fieldtypes_id_seq; Type: SEQUENCE OWNED BY; Schema: ukhasnet; Owner: g_ukhasnet
--

ALTER SEQUENCE fieldtypes_id_seq OWNED BY fieldtypes.id;


--
-- TOC entry 192 (class 1259 OID 18657)
-- Name: irc_msg; Type: TABLE; Schema: ukhasnet; Owner: mike; Tablespace: 
--

CREATE TABLE irc_msg (
    id integer NOT NULL,
    "time" timestamp without time zone DEFAULT now() NOT NULL,
    src_nick character varying(20) NOT NULL,
    src_chan character varying(20) NOT NULL,
    gatewayid integer NOT NULL,
    nodeid integer NOT NULL,
    message character varying(100) NOT NULL,
    status msgstate DEFAULT 'Pending'::msgstate NOT NULL
);


ALTER TABLE ukhasnet.irc_msg OWNER TO mike;

--
-- TOC entry 191 (class 1259 OID 18655)
-- Name: irc_msg_id_seq; Type: SEQUENCE; Schema: ukhasnet; Owner: mike
--

CREATE SEQUENCE irc_msg_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE ukhasnet.irc_msg_id_seq OWNER TO mike;

--
-- TOC entry 2122 (class 0 OID 0)
-- Dependencies: 191
-- Name: irc_msg_id_seq; Type: SEQUENCE OWNED BY; Schema: ukhasnet; Owner: mike
--

ALTER SEQUENCE irc_msg_id_seq OWNED BY irc_msg.id;


--
-- TOC entry 174 (class 1259 OID 17077)
-- Name: nodes; Type: TABLE; Schema: ukhasnet; Owner: g_ukhasnet; Tablespace: 
--

CREATE TABLE nodes (
    id integer NOT NULL,
    name character varying(16) NOT NULL,
    owner character varying(500),
    locationid integer,
    typeid integer,
    lastpacket integer
);


ALTER TABLE ukhasnet.nodes OWNER TO g_ukhasnet;

--
-- TOC entry 173 (class 1259 OID 17075)
-- Name: nodes_id_seq; Type: SEQUENCE; Schema: ukhasnet; Owner: g_ukhasnet
--

CREATE SEQUENCE nodes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE ukhasnet.nodes_id_seq OWNER TO g_ukhasnet;

--
-- TOC entry 2123 (class 0 OID 0)
-- Dependencies: 173
-- Name: nodes_id_seq; Type: SEQUENCE OWNED BY; Schema: ukhasnet; Owner: g_ukhasnet
--

ALTER SEQUENCE nodes_id_seq OWNED BY nodes.id;


--
-- TOC entry 190 (class 1259 OID 18325)
-- Name: nodetypes; Type: TABLE; Schema: ukhasnet; Owner: g_ukhasnet; Tablespace: 
--

CREATE TABLE nodetypes (
    id integer NOT NULL,
    description character varying(20) NOT NULL,
    icon character varying(20) DEFAULT 'node.png'::character varying NOT NULL
);


ALTER TABLE ukhasnet.nodetypes OWNER TO g_ukhasnet;

--
-- TOC entry 189 (class 1259 OID 18323)
-- Name: nodetypes_id_seq; Type: SEQUENCE; Schema: ukhasnet; Owner: g_ukhasnet
--

CREATE SEQUENCE nodetypes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE ukhasnet.nodetypes_id_seq OWNER TO g_ukhasnet;

--
-- TOC entry 2124 (class 0 OID 0)
-- Dependencies: 189
-- Name: nodetypes_id_seq; Type: SEQUENCE OWNED BY; Schema: ukhasnet; Owner: g_ukhasnet
--

ALTER SEQUENCE nodetypes_id_seq OWNED BY nodetypes.id;


--
-- TOC entry 176 (class 1259 OID 17085)
-- Name: packet; Type: TABLE; Schema: ukhasnet; Owner: g_ukhasnet; Tablespace: 
--

CREATE TABLE packet (
    id integer NOT NULL,
    originid integer NOT NULL,
    sequence character(1) NOT NULL,
    checksum integer NOT NULL
);


ALTER TABLE ukhasnet.packet OWNER TO g_ukhasnet;

--
-- TOC entry 175 (class 1259 OID 17083)
-- Name: packet_id_seq; Type: SEQUENCE; Schema: ukhasnet; Owner: g_ukhasnet
--

CREATE SEQUENCE packet_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE ukhasnet.packet_id_seq OWNER TO g_ukhasnet;

--
-- TOC entry 2125 (class 0 OID 0)
-- Dependencies: 175
-- Name: packet_id_seq; Type: SEQUENCE OWNED BY; Schema: ukhasnet; Owner: g_ukhasnet
--

ALTER SEQUENCE packet_id_seq OWNED BY packet.id;


--
-- TOC entry 180 (class 1259 OID 17119)
-- Name: packet_rx; Type: TABLE; Schema: ukhasnet; Owner: g_ukhasnet; Tablespace: 
--

CREATE TABLE packet_rx (
    id integer NOT NULL,
    packetid integer NOT NULL,
    gatewayid integer NOT NULL,
    packet_rx_time timestamp without time zone NOT NULL,
    uploadid integer NOT NULL
);


ALTER TABLE ukhasnet.packet_rx OWNER TO g_ukhasnet;

--
-- TOC entry 179 (class 1259 OID 17117)
-- Name: packet_rx_id_seq; Type: SEQUENCE; Schema: ukhasnet; Owner: g_ukhasnet
--

CREATE SEQUENCE packet_rx_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE ukhasnet.packet_rx_id_seq OWNER TO g_ukhasnet;

--
-- TOC entry 2126 (class 0 OID 0)
-- Dependencies: 179
-- Name: packet_rx_id_seq; Type: SEQUENCE OWNED BY; Schema: ukhasnet; Owner: g_ukhasnet
--

ALTER SEQUENCE packet_rx_id_seq OWNED BY packet_rx.id;


--
-- TOC entry 182 (class 1259 OID 17144)
-- Name: path; Type: TABLE; Schema: ukhasnet; Owner: g_ukhasnet; Tablespace: 
--

CREATE TABLE path (
    id integer NOT NULL,
    packet_rx_id integer NOT NULL,
    "position" smallint NOT NULL,
    nodeid integer NOT NULL
);


ALTER TABLE ukhasnet.path OWNER TO g_ukhasnet;

--
-- TOC entry 181 (class 1259 OID 17142)
-- Name: path_id_seq; Type: SEQUENCE; Schema: ukhasnet; Owner: g_ukhasnet
--

CREATE SEQUENCE path_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE ukhasnet.path_id_seq OWNER TO g_ukhasnet;

--
-- TOC entry 2127 (class 0 OID 0)
-- Dependencies: 181
-- Name: path_id_seq; Type: SEQUENCE OWNED BY; Schema: ukhasnet; Owner: g_ukhasnet
--

ALTER SEQUENCE path_id_seq OWNED BY path.id;


--
-- TOC entry 186 (class 1259 OID 17182)
-- Name: rawdata; Type: TABLE; Schema: ukhasnet; Owner: g_ukhasnet; Tablespace: 
--

CREATE TABLE rawdata (
    id integer NOT NULL,
    packetid integer NOT NULL,
    data character varying(100) NOT NULL,
    state state DEFAULT 'Error'::state NOT NULL
);


ALTER TABLE ukhasnet.rawdata OWNER TO g_ukhasnet;

--
-- TOC entry 185 (class 1259 OID 17180)
-- Name: rawdata_id_seq; Type: SEQUENCE; Schema: ukhasnet; Owner: g_ukhasnet
--

CREATE SEQUENCE rawdata_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE ukhasnet.rawdata_id_seq OWNER TO g_ukhasnet;

--
-- TOC entry 2128 (class 0 OID 0)
-- Dependencies: 185
-- Name: rawdata_id_seq; Type: SEQUENCE OWNED BY; Schema: ukhasnet; Owner: g_ukhasnet
--

ALTER SEQUENCE rawdata_id_seq OWNED BY rawdata.id;


--
-- TOC entry 178 (class 1259 OID 17098)
-- Name: upload; Type: TABLE; Schema: ukhasnet; Owner: g_ukhasnet; Tablespace: 
--

CREATE TABLE upload (
    id integer NOT NULL,
    nodeid integer NOT NULL,
    "time" timestamp without time zone DEFAULT now() NOT NULL,
    packet character varying(100) NOT NULL,
    packetid integer,
    state state DEFAULT 'Pending'::state NOT NULL,
    rssi integer
);


ALTER TABLE ukhasnet.upload OWNER TO g_ukhasnet;

--
-- TOC entry 177 (class 1259 OID 17096)
-- Name: upload_id_seq; Type: SEQUENCE; Schema: ukhasnet; Owner: g_ukhasnet
--

CREATE SEQUENCE upload_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE ukhasnet.upload_id_seq OWNER TO g_ukhasnet;

--
-- TOC entry 2129 (class 0 OID 0)
-- Dependencies: 177
-- Name: upload_id_seq; Type: SEQUENCE OWNED BY; Schema: ukhasnet; Owner: g_ukhasnet
--

ALTER SEQUENCE upload_id_seq OWNED BY upload.id;


--
-- TOC entry 1941 (class 2604 OID 17165)
-- Name: id; Type: DEFAULT; Schema: ukhasnet; Owner: g_ukhasnet
--

ALTER TABLE ONLY data_float ALTER COLUMN id SET DEFAULT nextval('data_float_id_seq'::regclass);


--
-- TOC entry 1944 (class 2604 OID 17199)
-- Name: id; Type: DEFAULT; Schema: ukhasnet; Owner: g_ukhasnet
--

ALTER TABLE ONLY data_location ALTER COLUMN id SET DEFAULT nextval('data_location_id_seq'::regclass);


--
-- TOC entry 1931 (class 2604 OID 17070)
-- Name: id; Type: DEFAULT; Schema: ukhasnet; Owner: g_ukhasnet
--

ALTER TABLE ONLY fieldtypes ALTER COLUMN id SET DEFAULT nextval('fieldtypes_id_seq'::regclass);


--
-- TOC entry 1947 (class 2604 OID 18660)
-- Name: id; Type: DEFAULT; Schema: ukhasnet; Owner: mike
--

ALTER TABLE ONLY irc_msg ALTER COLUMN id SET DEFAULT nextval('irc_msg_id_seq'::regclass);


--
-- TOC entry 1934 (class 2604 OID 17080)
-- Name: id; Type: DEFAULT; Schema: ukhasnet; Owner: g_ukhasnet
--

ALTER TABLE ONLY nodes ALTER COLUMN id SET DEFAULT nextval('nodes_id_seq'::regclass);


--
-- TOC entry 1945 (class 2604 OID 18328)
-- Name: id; Type: DEFAULT; Schema: ukhasnet; Owner: g_ukhasnet
--

ALTER TABLE ONLY nodetypes ALTER COLUMN id SET DEFAULT nextval('nodetypes_id_seq'::regclass);


--
-- TOC entry 1935 (class 2604 OID 17088)
-- Name: id; Type: DEFAULT; Schema: ukhasnet; Owner: g_ukhasnet
--

ALTER TABLE ONLY packet ALTER COLUMN id SET DEFAULT nextval('packet_id_seq'::regclass);


--
-- TOC entry 1939 (class 2604 OID 17122)
-- Name: id; Type: DEFAULT; Schema: ukhasnet; Owner: g_ukhasnet
--

ALTER TABLE ONLY packet_rx ALTER COLUMN id SET DEFAULT nextval('packet_rx_id_seq'::regclass);


--
-- TOC entry 1940 (class 2604 OID 17147)
-- Name: id; Type: DEFAULT; Schema: ukhasnet; Owner: g_ukhasnet
--

ALTER TABLE ONLY path ALTER COLUMN id SET DEFAULT nextval('path_id_seq'::regclass);


--
-- TOC entry 1942 (class 2604 OID 17185)
-- Name: id; Type: DEFAULT; Schema: ukhasnet; Owner: g_ukhasnet
--

ALTER TABLE ONLY rawdata ALTER COLUMN id SET DEFAULT nextval('rawdata_id_seq'::regclass);


--
-- TOC entry 1936 (class 2604 OID 17101)
-- Name: id; Type: DEFAULT; Schema: ukhasnet; Owner: g_ukhasnet
--

ALTER TABLE ONLY upload ALTER COLUMN id SET DEFAULT nextval('upload_id_seq'::regclass);


--
-- TOC entry 1975 (class 2606 OID 17167)
-- Name: data_float_pkey; Type: CONSTRAINT; Schema: ukhasnet; Owner: g_ukhasnet; Tablespace: 
--

ALTER TABLE ONLY data_float
    ADD CONSTRAINT data_float_pkey PRIMARY KEY (id);


--
-- TOC entry 1981 (class 2606 OID 17201)
-- Name: data_location_pkey; Type: CONSTRAINT; Schema: ukhasnet; Owner: g_ukhasnet; Tablespace: 
--

ALTER TABLE ONLY data_location
    ADD CONSTRAINT data_location_pkey PRIMARY KEY (id);


--
-- TOC entry 1951 (class 2606 OID 17074)
-- Name: fieldtypes_pkey; Type: CONSTRAINT; Schema: ukhasnet; Owner: g_ukhasnet; Tablespace: 
--

ALTER TABLE ONLY fieldtypes
    ADD CONSTRAINT fieldtypes_pkey PRIMARY KEY (id);


--
-- TOC entry 1985 (class 2606 OID 18664)
-- Name: irc_msg_pkey; Type: CONSTRAINT; Schema: ukhasnet; Owner: mike; Tablespace: 
--

ALTER TABLE ONLY irc_msg
    ADD CONSTRAINT irc_msg_pkey PRIMARY KEY (id);


--
-- TOC entry 1953 (class 2606 OID 17082)
-- Name: nodes_pkey; Type: CONSTRAINT; Schema: ukhasnet; Owner: g_ukhasnet; Tablespace: 
--

ALTER TABLE ONLY nodes
    ADD CONSTRAINT nodes_pkey PRIMARY KEY (id);


--
-- TOC entry 1983 (class 2606 OID 18331)
-- Name: nodetypes_pkey; Type: CONSTRAINT; Schema: ukhasnet; Owner: g_ukhasnet; Tablespace: 
--

ALTER TABLE ONLY nodetypes
    ADD CONSTRAINT nodetypes_pkey PRIMARY KEY (id);


--
-- TOC entry 1957 (class 2606 OID 17090)
-- Name: packet_pkey; Type: CONSTRAINT; Schema: ukhasnet; Owner: g_ukhasnet; Tablespace: 
--

ALTER TABLE ONLY packet
    ADD CONSTRAINT packet_pkey PRIMARY KEY (id);


--
-- TOC entry 1968 (class 2606 OID 17124)
-- Name: packet_rx_pkey; Type: CONSTRAINT; Schema: ukhasnet; Owner: g_ukhasnet; Tablespace: 
--

ALTER TABLE ONLY packet_rx
    ADD CONSTRAINT packet_rx_pkey PRIMARY KEY (id);


--
-- TOC entry 1971 (class 2606 OID 17149)
-- Name: path_pkey; Type: CONSTRAINT; Schema: ukhasnet; Owner: g_ukhasnet; Tablespace: 
--

ALTER TABLE ONLY path
    ADD CONSTRAINT path_pkey PRIMARY KEY (id);


--
-- TOC entry 1977 (class 2606 OID 17188)
-- Name: rawdata_pkey; Type: CONSTRAINT; Schema: ukhasnet; Owner: g_ukhasnet; Tablespace: 
--

ALTER TABLE ONLY rawdata
    ADD CONSTRAINT rawdata_pkey PRIMARY KEY (id);


--
-- TOC entry 1961 (class 2606 OID 17105)
-- Name: upload_pkey; Type: CONSTRAINT; Schema: ukhasnet; Owner: g_ukhasnet; Tablespace: 
--

ALTER TABLE ONLY upload
    ADD CONSTRAINT upload_pkey PRIMARY KEY (id);


--
-- TOC entry 1972 (class 1259 OID 17178)
-- Name: data_float_fieldid_idx; Type: INDEX; Schema: ukhasnet; Owner: g_ukhasnet; Tablespace: 
--

CREATE INDEX data_float_fieldid_idx ON data_float USING btree (fieldid);


--
-- TOC entry 1973 (class 1259 OID 17179)
-- Name: data_float_packetid_idx; Type: INDEX; Schema: ukhasnet; Owner: g_ukhasnet; Tablespace: 
--

CREATE INDEX data_float_packetid_idx ON data_float USING btree (packetid);


--
-- TOC entry 1979 (class 1259 OID 17207)
-- Name: data_location_packetid_idx; Type: INDEX; Schema: ukhasnet; Owner: g_ukhasnet; Tablespace: 
--

CREATE INDEX data_location_packetid_idx ON data_location USING btree (packetid);


--
-- TOC entry 1958 (class 1259 OID 18776)
-- Name: idx_upload_nodeid; Type: INDEX; Schema: ukhasnet; Owner: g_ukhasnet; Tablespace: 
--

CREATE INDEX idx_upload_nodeid ON upload USING btree (nodeid);


--
-- TOC entry 1959 (class 1259 OID 26969)
-- Name: idx_upload_packetid; Type: INDEX; Schema: ukhasnet; Owner: g_ukhasnet; Tablespace: 
--

CREATE INDEX idx_upload_packetid ON upload USING hash (packetid);


--
-- TOC entry 1954 (class 1259 OID 41840)
-- Name: packet_checksum_idx; Type: INDEX; Schema: ukhasnet; Owner: g_ukhasnet; Tablespace: 
--

CREATE INDEX packet_checksum_idx ON packet USING btree (checksum);


--
-- TOC entry 1955 (class 1259 OID 17116)
-- Name: packet_originid_idx; Type: INDEX; Schema: ukhasnet; Owner: g_ukhasnet; Tablespace: 
--

CREATE INDEX packet_originid_idx ON packet USING btree (originid);


--
-- TOC entry 1964 (class 1259 OID 18772)
-- Name: packet_rx_gatewayid_idx; Type: INDEX; Schema: ukhasnet; Owner: g_ukhasnet; Tablespace: 
--

CREATE INDEX packet_rx_gatewayid_idx ON packet_rx USING btree (gatewayid);


--
-- TOC entry 1965 (class 1259 OID 17140)
-- Name: packet_rx_packet_rx_time_idx; Type: INDEX; Schema: ukhasnet; Owner: g_ukhasnet; Tablespace: 
--

CREATE INDEX packet_rx_packet_rx_time_idx ON packet_rx USING btree (packet_rx_time);


--
-- TOC entry 1966 (class 1259 OID 17141)
-- Name: packet_rx_packetid_idx; Type: INDEX; Schema: ukhasnet; Owner: g_ukhasnet; Tablespace: 
--

CREATE INDEX packet_rx_packetid_idx ON packet_rx USING btree (packetid);


--
-- TOC entry 1969 (class 1259 OID 18771)
-- Name: path_packet_rx_id_idx; Type: INDEX; Schema: ukhasnet; Owner: g_ukhasnet; Tablespace: 
--

CREATE INDEX path_packet_rx_id_idx ON path USING btree (packet_rx_id);


--
-- TOC entry 1978 (class 1259 OID 41843)
-- Name: rawdata_state_idx; Type: INDEX; Schema: ukhasnet; Owner: g_ukhasnet; Tablespace: 
--

CREATE INDEX rawdata_state_idx ON rawdata USING btree (state);


--
-- TOC entry 1962 (class 1259 OID 41842)
-- Name: upload_state_idx; Type: INDEX; Schema: ukhasnet; Owner: g_ukhasnet; Tablespace: 
--

CREATE INDEX upload_state_idx ON upload USING btree (state);


--
-- TOC entry 1963 (class 1259 OID 18363)
-- Name: upload_time; Type: INDEX; Schema: ukhasnet; Owner: g_ukhasnet; Tablespace: 
--

CREATE INDEX upload_time ON upload USING btree ("time" DESC);


--
-- TOC entry 1997 (class 2606 OID 18684)
-- Name: data_float_fieldid_fkey; Type: FK CONSTRAINT; Schema: ukhasnet; Owner: g_ukhasnet
--

ALTER TABLE ONLY data_float
    ADD CONSTRAINT data_float_fieldid_fkey FOREIGN KEY (fieldid) REFERENCES fieldtypes(id) ON DELETE CASCADE;


--
-- TOC entry 1998 (class 2606 OID 18689)
-- Name: data_float_packetid_fkey; Type: FK CONSTRAINT; Schema: ukhasnet; Owner: g_ukhasnet
--

ALTER TABLE ONLY data_float
    ADD CONSTRAINT data_float_packetid_fkey FOREIGN KEY (packetid) REFERENCES packet(id) ON DELETE CASCADE;


--
-- TOC entry 2000 (class 2606 OID 18694)
-- Name: data_location_packetid_fkey; Type: FK CONSTRAINT; Schema: ukhasnet; Owner: g_ukhasnet
--

ALTER TABLE ONLY data_location
    ADD CONSTRAINT data_location_packetid_fkey FOREIGN KEY (packetid) REFERENCES packet(id) ON DELETE CASCADE;


--
-- TOC entry 2001 (class 2606 OID 18699)
-- Name: irc_msg_gatewayid_fkey; Type: FK CONSTRAINT; Schema: ukhasnet; Owner: mike
--

ALTER TABLE ONLY irc_msg
    ADD CONSTRAINT irc_msg_gatewayid_fkey FOREIGN KEY (gatewayid) REFERENCES nodes(id) ON DELETE CASCADE;


--
-- TOC entry 2002 (class 2606 OID 18704)
-- Name: irc_msg_nodeid_fkey; Type: FK CONSTRAINT; Schema: ukhasnet; Owner: mike
--

ALTER TABLE ONLY irc_msg
    ADD CONSTRAINT irc_msg_nodeid_fkey FOREIGN KEY (nodeid) REFERENCES nodes(id) ON DELETE CASCADE;


--
-- TOC entry 1986 (class 2606 OID 18709)
-- Name: nodes_lastpacket_fkey; Type: FK CONSTRAINT; Schema: ukhasnet; Owner: g_ukhasnet
--

ALTER TABLE ONLY nodes
    ADD CONSTRAINT nodes_lastpacket_fkey FOREIGN KEY (lastpacket) REFERENCES packet(id) ON DELETE CASCADE;


--
-- TOC entry 1987 (class 2606 OID 18714)
-- Name: nodes_locationid_fkey; Type: FK CONSTRAINT; Schema: ukhasnet; Owner: g_ukhasnet
--

ALTER TABLE ONLY nodes
    ADD CONSTRAINT nodes_locationid_fkey FOREIGN KEY (locationid) REFERENCES data_location(id) ON DELETE CASCADE;


--
-- TOC entry 1988 (class 2606 OID 18719)
-- Name: nodes_typeid_fkey; Type: FK CONSTRAINT; Schema: ukhasnet; Owner: g_ukhasnet
--

ALTER TABLE ONLY nodes
    ADD CONSTRAINT nodes_typeid_fkey FOREIGN KEY (typeid) REFERENCES nodetypes(id) ON DELETE CASCADE;


--
-- TOC entry 1989 (class 2606 OID 18724)
-- Name: packet_originid_fkey; Type: FK CONSTRAINT; Schema: ukhasnet; Owner: g_ukhasnet
--

ALTER TABLE ONLY packet
    ADD CONSTRAINT packet_originid_fkey FOREIGN KEY (originid) REFERENCES nodes(id) ON DELETE CASCADE;


--
-- TOC entry 1992 (class 2606 OID 18729)
-- Name: packet_rx_gatewayid_fkey; Type: FK CONSTRAINT; Schema: ukhasnet; Owner: g_ukhasnet
--

ALTER TABLE ONLY packet_rx
    ADD CONSTRAINT packet_rx_gatewayid_fkey FOREIGN KEY (gatewayid) REFERENCES nodes(id) ON DELETE CASCADE;


--
-- TOC entry 1993 (class 2606 OID 18734)
-- Name: packet_rx_packetid_fkey; Type: FK CONSTRAINT; Schema: ukhasnet; Owner: g_ukhasnet
--

ALTER TABLE ONLY packet_rx
    ADD CONSTRAINT packet_rx_packetid_fkey FOREIGN KEY (packetid) REFERENCES packet(id) ON DELETE CASCADE;


--
-- TOC entry 1994 (class 2606 OID 18739)
-- Name: packet_rx_uploadid_fkey; Type: FK CONSTRAINT; Schema: ukhasnet; Owner: g_ukhasnet
--

ALTER TABLE ONLY packet_rx
    ADD CONSTRAINT packet_rx_uploadid_fkey FOREIGN KEY (uploadid) REFERENCES upload(id) ON DELETE CASCADE;


--
-- TOC entry 1995 (class 2606 OID 18744)
-- Name: path_nodeid_fkey; Type: FK CONSTRAINT; Schema: ukhasnet; Owner: g_ukhasnet
--

ALTER TABLE ONLY path
    ADD CONSTRAINT path_nodeid_fkey FOREIGN KEY (nodeid) REFERENCES nodes(id) ON DELETE CASCADE;


--
-- TOC entry 1996 (class 2606 OID 18749)
-- Name: path_packet_rx_id_fkey; Type: FK CONSTRAINT; Schema: ukhasnet; Owner: g_ukhasnet
--

ALTER TABLE ONLY path
    ADD CONSTRAINT path_packet_rx_id_fkey FOREIGN KEY (packet_rx_id) REFERENCES packet_rx(id) ON DELETE CASCADE;


--
-- TOC entry 1999 (class 2606 OID 18754)
-- Name: rawdata_packetid_fkey; Type: FK CONSTRAINT; Schema: ukhasnet; Owner: g_ukhasnet
--

ALTER TABLE ONLY rawdata
    ADD CONSTRAINT rawdata_packetid_fkey FOREIGN KEY (packetid) REFERENCES packet(id) ON DELETE CASCADE;


--
-- TOC entry 1990 (class 2606 OID 18759)
-- Name: upload_nodeid_fkey; Type: FK CONSTRAINT; Schema: ukhasnet; Owner: g_ukhasnet
--

ALTER TABLE ONLY upload
    ADD CONSTRAINT upload_nodeid_fkey FOREIGN KEY (nodeid) REFERENCES nodes(id) ON DELETE CASCADE;


--
-- TOC entry 1991 (class 2606 OID 18764)
-- Name: upload_packetid_fkey; Type: FK CONSTRAINT; Schema: ukhasnet; Owner: g_ukhasnet
--

ALTER TABLE ONLY upload
    ADD CONSTRAINT upload_packetid_fkey FOREIGN KEY (packetid) REFERENCES packet(id) ON DELETE CASCADE;


--
-- TOC entry 2116 (class 0 OID 0)
-- Dependencies: 5
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- TOC entry 2117 (class 0 OID 0)
-- Dependencies: 7
-- Name: ukhasnet; Type: ACL; Schema: -; Owner: g_ukhasnet
--

REVOKE ALL ON SCHEMA ukhasnet FROM PUBLIC;


--
-- TOC entry 1563 (class 826 OID 18678)
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: ukhasnet; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA ukhasnet REVOKE ALL ON TABLES  FROM PUBLIC;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA ukhasnet REVOKE ALL ON TABLES  FROM postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA ukhasnet GRANT SELECT ON TABLES  TO prod_readonly;


-- Completed on 2015-05-18 10:23:21 BST

--
-- PostgreSQL database dump complete
--

