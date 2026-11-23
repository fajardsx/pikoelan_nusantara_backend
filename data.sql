SET session_replication_role = replica;

--
-- PostgreSQL database dump
--

-- \restrict 1fjVKJUYd7FReUe1FpHauCNHD2ZcmlCtAGqoiqgZv9BmFRiN9qa31SwC2kJSENy

-- Dumped from database version 17.6
-- Dumped by pg_dump version 17.12

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Data for Name: audit_log_entries; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY "auth"."audit_log_entries" ("instance_id", "id", "payload", "created_at", "ip_address") FROM stdin;
\.


--
-- Data for Name: custom_oauth_providers; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY "auth"."custom_oauth_providers" ("id", "provider_type", "identifier", "name", "client_id", "client_secret", "acceptable_client_ids", "scopes", "pkce_enabled", "attribute_mapping", "authorization_params", "enabled", "email_optional", "issuer", "discovery_url", "skip_nonce_check", "cached_discovery", "discovery_cached_at", "authorization_url", "token_url", "userinfo_url", "jwks_uri", "created_at", "updated_at", "custom_claims_allowlist") FROM stdin;
\.


--
-- Data for Name: flow_state; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY "auth"."flow_state" ("id", "user_id", "auth_code", "code_challenge_method", "code_challenge", "provider_type", "provider_access_token", "provider_refresh_token", "created_at", "updated_at", "authentication_method", "auth_code_issued_at", "invite_token", "referrer", "oauth_client_state_id", "linking_target_id", "email_optional") FROM stdin;
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY "auth"."users" ("instance_id", "id", "aud", "role", "email", "encrypted_password", "email_confirmed_at", "invited_at", "confirmation_token", "confirmation_sent_at", "recovery_token", "recovery_sent_at", "email_change_token_new", "email_change", "email_change_sent_at", "last_sign_in_at", "raw_app_meta_data", "raw_user_meta_data", "is_super_admin", "created_at", "updated_at", "phone", "phone_confirmed_at", "phone_change", "phone_change_token", "phone_change_sent_at", "email_change_token_current", "email_change_confirm_status", "banned_until", "reauthentication_token", "reauthentication_sent_at", "is_sso_user", "deleted_at", "is_anonymous") FROM stdin;
\.


--
-- Data for Name: identities; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY "auth"."identities" ("provider_id", "user_id", "identity_data", "provider", "last_sign_in_at", "created_at", "updated_at", "id") FROM stdin;
\.


--
-- Data for Name: instances; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY "auth"."instances" ("id", "uuid", "raw_base_config", "created_at", "updated_at") FROM stdin;
\.


--
-- Data for Name: oauth_clients; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY "auth"."oauth_clients" ("id", "client_secret_hash", "registration_type", "redirect_uris", "grant_types", "client_name", "client_uri", "logo_uri", "created_at", "updated_at", "deleted_at", "client_type", "token_endpoint_auth_method") FROM stdin;
\.


--
-- Data for Name: sessions; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY "auth"."sessions" ("id", "user_id", "created_at", "updated_at", "factor_id", "aal", "not_after", "refreshed_at", "user_agent", "ip", "tag", "oauth_client_id", "refresh_token_hmac_key", "refresh_token_counter", "scopes") FROM stdin;
\.


--
-- Data for Name: mfa_amr_claims; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY "auth"."mfa_amr_claims" ("session_id", "created_at", "updated_at", "authentication_method", "id") FROM stdin;
\.


--
-- Data for Name: mfa_factors; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY "auth"."mfa_factors" ("id", "user_id", "friendly_name", "factor_type", "status", "created_at", "updated_at", "secret", "phone", "last_challenged_at", "web_authn_credential", "web_authn_aaguid", "last_webauthn_challenge_data") FROM stdin;
\.


--
-- Data for Name: mfa_challenges; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY "auth"."mfa_challenges" ("id", "factor_id", "created_at", "verified_at", "ip_address", "otp_code", "web_authn_session_data") FROM stdin;
\.


--
-- Data for Name: mfa_recovery_code_sets; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY "auth"."mfa_recovery_code_sets" ("id", "user_id", "mfa_factor_id", "failed_verification_count", "verification_locked_until", "created_at", "updated_at") FROM stdin;
\.


--
-- Data for Name: mfa_recovery_codes; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY "auth"."mfa_recovery_codes" ("id", "mfa_recovery_code_set_id", "code_hash", "consumed_at", "created_at") FROM stdin;
\.


--
-- Data for Name: oauth_authorizations; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY "auth"."oauth_authorizations" ("id", "authorization_id", "client_id", "user_id", "redirect_uri", "scope", "state", "resource", "code_challenge", "code_challenge_method", "response_type", "status", "authorization_code", "created_at", "expires_at", "approved_at", "nonce") FROM stdin;
\.


--
-- Data for Name: oauth_client_states; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY "auth"."oauth_client_states" ("id", "provider_type", "code_verifier", "created_at") FROM stdin;
\.


--
-- Data for Name: oauth_consents; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY "auth"."oauth_consents" ("id", "user_id", "client_id", "scopes", "granted_at", "revoked_at") FROM stdin;
\.


--
-- Data for Name: one_time_tokens; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY "auth"."one_time_tokens" ("id", "user_id", "token_type", "token_hash", "relates_to", "created_at", "updated_at", "expires_at", "link_token_hash") FROM stdin;
\.


--
-- Data for Name: refresh_tokens; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY "auth"."refresh_tokens" ("instance_id", "id", "token", "user_id", "revoked", "created_at", "updated_at", "parent", "session_id") FROM stdin;
\.


--
-- Data for Name: sso_providers; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY "auth"."sso_providers" ("id", "resource_id", "created_at", "updated_at", "disabled") FROM stdin;
\.


--
-- Data for Name: saml_providers; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY "auth"."saml_providers" ("id", "sso_provider_id", "entity_id", "metadata_xml", "metadata_url", "attribute_mapping", "created_at", "updated_at", "name_id_format", "dedicated_scope") FROM stdin;
\.


--
-- Data for Name: saml_relay_states; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY "auth"."saml_relay_states" ("id", "sso_provider_id", "request_id", "for_email", "redirect_to", "created_at", "updated_at", "flow_state_id") FROM stdin;
\.


--
-- Data for Name: scim_tokens; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY "auth"."scim_tokens" ("id", "sso_provider_id", "token_hash", "prefix", "created_at", "expires_at", "revoked_at", "last_used_at") FROM stdin;
\.


--
-- Data for Name: scim_users; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY "auth"."scim_users" ("id", "sso_provider_id", "user_id", "resource", "created_at", "updated_at", "deleted_at") FROM stdin;
\.


--
-- Data for Name: sso_domains; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY "auth"."sso_domains" ("id", "sso_provider_id", "domain", "created_at", "updated_at") FROM stdin;
\.


--
-- Data for Name: webauthn_challenges; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY "auth"."webauthn_challenges" ("id", "user_id", "challenge_type", "session_data", "created_at", "expires_at") FROM stdin;
\.


--
-- Data for Name: webauthn_credentials; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY "auth"."webauthn_credentials" ("id", "user_id", "credential_id", "public_key", "attestation_type", "aaguid", "sign_count", "transports", "backup_eligible", "backed_up", "friendly_name", "created_at", "updated_at", "last_used_at") FROM stdin;
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "public"."users" ("id", "name", "email", "password", "profile_picture", "created_at", "updated_at", "tenant_id", "role", "email_verified", "email_verification_token", "email_verification_expires", "reset_password_token", "reset_password_expires") FROM stdin;
2	Super Admin	admin@yopmail.com	$2b$10$Uivtutqrz3Lo74SMfOtigu/N3Ugza2Nd5zZuHqVx5VEFAR6LKEs0W	\N	2026-07-28 14:21:06.315+07	2026-07-28 14:21:06.315+07	\N	superadmin	f	\N	\N	\N	\N
4	Lukas	lukasowner@yopmail.com	$2b$10$qwWoqKwKSd4dA0eWoEFMle5eZABFjCl56bZ4VWb3rWylbaNnKOtnq	\N	2026-09-29 21:24:55.619+07	2026-09-29 21:26:01.975+07	2	owner	t	1e64c78cd2e4a5177ae0162f0a27dbed9f2291f4910c0353bf035fd01c42b118	2026-09-30 21:26:01.975+07	\N	\N
3	Siti	adminfajar@yopmail.com	$2b$10$iSaurDsIAEEbRPV0.f5CweNWB7ZGJF5LBroYtrS4uMntUjZEl8e5W	\N	2026-07-28 14:28:21.178+07	2026-07-28 14:28:21.178+07	1	owner	t	\N	\N	\N	\N
6	Yanti	yanti123@yopmail.com	$2b$10$rs58XCIpHauCFiSp2s1tLuuO7IZzSQY5/PAvqODocAukfOSdjMFii	\N	2026-10-11 21:16:35.877+07	2026-10-11 21:16:35.877+07	1	kasir	f	\N	\N	\N	\N
7	Budi	budi123@yopmail.com	$2b$10$0Iz8RD06FKgXEjvchPk4wOVEpUrLwt8jmPNfRhVF4uaRNV1wg6mce	\N	2026-10-11 22:07:20.713+07	2026-10-11 22:07:20.713+07	1	kitchen	f	\N	\N	\N	\N
8	mamang	mamang123@yopmail.com	$2b$10$NE1iFfpldoZYpNVdHkFsWOQ/Oho5oOg0sRFZJ4yMHB6U6eOEtFDRS	\N	2026-10-11 22:08:37.29+07	2026-10-11 22:08:37.29+07	1	waiter	f	\N	\N	\N	\N
10	Kasir_1	kasir1@yopmail.com	$2b$10$cfTtIr0QYEm4v2SABPbJj.K8XJaYMDWyP6pGg4WIxXDVo/qdc9d6i	\N	2026-10-30 17:29:00.881+07	2026-10-30 17:29:00.881+07	2	kasir	f	\N	\N	\N	\N
11	Dapur_1	dapur1@yopmail.com	$2b$10$EFpnOp/WtcVlZ8GANMUHK.9T7r29CmjdTEDj8hLfGhf/PD4zGZi1O	\N	2026-10-30 17:29:36.268+07	2026-10-30 17:29:36.268+07	2	kitchen	f	\N	\N	\N	\N
12	Pelayan_1	pelayan1@yopmail.com	$2b$10$kXhZYB2IGaBdRxRwKvVbA./ivw65Z/Cu162AdnsT2M.eDzxs2ahru	\N	2026-10-30 17:32:26.074+07	2026-10-30 17:32:26.074+07	2	waiter	f	\N	\N	\N	\N
\.


--
-- Data for Name: tenants; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "public"."tenants" ("id", "name", "slug", "address", "phone", "email", "logo_url", "plan", "is_active", "created_at", "updated_at", "owner_id", "bank_account_number", "qris_url") FROM stdin;
1	Warung Nasi Uduk	warung-nasi-uduk	JL. melati no.21	0878827282	\N	https://obaybiymhuukucvvgdsq.supabase.co/storage/v1/object/public/uploads/tenants/9ddc66ee-2019-45e1-99df-d7fae3da54d2.jpg	free	t	2026-07-28 14:28:20.999+07	2026-10-24 00:22:59.589+07	3	123445555	https://obaybiymhuukucvvgdsq.supabase.co/storage/v1/object/public/uploads/qris/4ad91b09-a2ed-40b3-aabc-96235bc05c4b.jpg
2	Pikoelan Nusantara	pikoelan-nusantara	Rusun ASN TNI & POLRI, kemayoran Tower 3	628118823200	\N	https://obaybiymhuukucvvgdsq.supabase.co/storage/v1/object/public/uploads/tenants/6e8de250-2aa6-4495-a282-ff8cda35fb57.jpg	free	t	2026-09-29 21:24:55.091+07	2026-10-29 01:37:43.158+07	4	111111111	\N
\.


--
-- Data for Name: Message; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "public"."Message" ("id", "sender_id", "sender_name", "recipient_id", "message", "read", "created_at", "updated_at", "tenant_id") FROM stdin;
\.


--
-- Data for Name: members; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "public"."members" ("id", "tenant_id", "member_code", "name", "phone", "email", "tier", "points", "total_spent", "total_visits", "birth_date", "join_date", "address", "notes", "is_active", "created_at", "updated_at") FROM stdin;
2	1	MBR-1-0001	Fajar	087828288299	\N	bronze	0	0.00	0	\N	2026-10-31	\N	\N	t	2026-10-31 18:31:48.931+07	2026-10-31 18:31:48.931+07
\.


--
-- Data for Name: promo_codes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "public"."promo_codes" ("id", "tenant_id", "code", "title", "description", "discount_type", "discount_value", "min_order_amount", "max_discount_amount", "usage_limit", "usage_count", "start_date", "end_date", "applicable_tier", "is_active", "created_at", "updated_at") FROM stdin;
2	1	GAJIAN	Promo gajian	minimal pembelian Rp.50.000 dapatkan potongan 10% maksimal Rp.10.000	percentage	10.00	50000.00	10000.00	\N	0	2026-10-31 00:00:00+07	2026-11-05 00:00:00+07	all	t	2026-10-31 15:08:01.491+07	2026-10-31 15:08:01.491+07
3	1	11.11	PROMO 11.11	potongan 10% dengan pembelian min Rp.50.000. maksimal potongan Rp.10.000	percentage	10.00	50000.00	10000.00	\N	0	2026-11-11 07:00:00+07	2026-11-11 07:00:00+07	all	t	2026-11-09 18:11:26.821+07	2026-11-09 18:11:26.821+07
\.


--
-- Data for Name: orders; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "public"."orders" ("id", "tenant_id", "order_number", "order_type", "table_number", "customer_name", "status", "total_amount", "notes", "created_by", "created_at", "updated_at", "source", "payment_method", "address", "phone", "payment_confirmation", "subtotal", "discount_amount", "member_id", "promo_code_id", "points_earned", "points_redeemed") FROM stdin;
90	1	ORD-20261109-0001	takeaway	\N	adi	new	19500.00	\N	3	2026-11-09 23:21:28+07	2026-11-09 23:22:08.879+07	staff	cash	\N	\N	t	19500.00	0.00	\N	\N	0	0
141	2	ORD-20261119-0007	dine_in	06	xxxxx	new	212000.00	\N	10	2026-11-19 12:30:38+07	2026-11-19 12:30:45.881+07	staff	qrcode	\N	\N	t	212000.00	0.00	\N	\N	0	0
114	2	ORD-20261118-0009	takeaway	\N	.	new	35000.00	sedang	10	2026-11-18 18:14:51+07	2026-11-18 18:14:57.84+07	staff	qrcode	\N	\N	t	35000.00	0.00	\N	\N	0	0
92	1	ORD-20261111-0001	takeaway	\N	VAVak	completed	19500.00	jangan pedas	6	2026-11-11 08:39:21+07	2026-11-11 03:45:59.045+07	staff	cash	\N	\N	t	19500.00	0.00	\N	\N	0	0
96	2	ORD-20261112-0004	dine_in	01	jo	new	8000.00	\N	10	2026-11-12 02:20:34+07	2026-11-12 19:20:34.511+07	staff	\N	\N	\N	f	8000.00	0.00	\N	\N	0	0
98	2	ORD-20261112-0006	dine_in	01	c	new	5000.00	\N	10	2026-11-12 02:23:01+07	2026-11-12 19:23:01.931+07	staff	\N	\N	\N	f	5000.00	0.00	\N	\N	0	0
99	2	ORD-20261112-0007	dine_in	3	ji	new	5000.00	\N	10	2026-11-12 02:25:16+07	2026-11-12 19:25:16.5+07	staff	\N	\N	\N	f	5000.00	0.00	\N	\N	0	0
154	2	ORD-20261119-0020	dine_in	08	xxxx	cancelled	38000.00	\N	4	2026-11-19 19:28:25+07	2026-11-19 19:44:18.852+07	staff	qrcode	\N	\N	f	38000.00	0.00	\N	\N	0	0
116	2	ORD-20261118-0011	takeaway	\N	fara	new	118000.00	\N	10	2026-11-18 18:19:51+07	2026-11-18 18:19:58.007+07	staff	qrcode	\N	\N	t	118000.00	0.00	\N	\N	0	0
115	2	ORD-20261118-0010	dine_in	08	ami	new	76000.00	\N	10	2026-11-18 18:17:44+07	2026-11-18 18:46:17.057+07	staff	qrcode	\N	\N	t	76000.00	0.00	\N	\N	0	0
103	2	ORD-20261113-0003	takeaway	\N	-	cancelled	70000.00	biasa aja	10	2026-11-13 10:27:34+07	2026-11-13 10:29:52.979+07	staff	qrcode	\N	\N	f	70000.00	0.00	\N	\N	0	0
101	2	ORD-20261113-0001	takeaway	\N	y	cancelled	5000.00	y	10	2026-11-13 10:10:41+07	2026-11-13 10:30:03.096+07	staff	qrcode	\N	\N	f	5000.00	0.00	\N	\N	0	0
143	2	ORD-20261119-0009	takeaway	\N	ayam berani	new	63000.00	\N	4	2026-11-19 17:05:07+07	2026-11-19 17:05:16.876+07	staff	qrcode	\N	\N	t	63000.00	0.00	\N	\N	0	0
105	2	ORD-20261113-0005	dine_in	06	jk	new	26000.00	pedes	10	2026-11-13 10:38:54+07	2026-11-13 10:39:37.137+07	staff	qrcode	\N	\N	t	26000.00	0.00	\N	\N	0	0
118	2	ORD-20261118-0013	dine_in	10	kiya	new	55000.00	\N	10	2026-11-18 18:47:01+07	2026-11-18 18:47:39.909+07	staff	qrcode	\N	\N	t	55000.00	0.00	\N	\N	0	0
107	2	ORD-20261118-0002	dine_in	02	gio	cancelled	5000.00	\N	10	2026-11-18 16:06:58+07	2026-11-18 16:08:01.378+07	staff	qrcode	\N	\N	f	5000.00	0.00	\N	\N	0	0
122	2	ORD-20261118-0017	takeaway	\N	xxxx	new	166000.00	\N	10	2026-11-18 19:23:40+07	2026-11-18 19:23:40.135+07	staff	\N	\N	\N	f	166000.00	0.00	\N	\N	0	0
109	2	ORD-20261118-0004	dine_in	07	xxxxx	new	53000.00	\N	4	2026-11-18 17:53:46+07	2026-11-18 17:53:58.421+07	staff	qrcode	\N	\N	t	53000.00	0.00	\N	\N	0	0
127	2	ORD-20261118-0022	dine_in	10	xxx	cancelled	171000.00	nasgor tuna pedes \njeruk Tampa gula\nnaga Tampa es	10	2026-11-18 19:44:44+07	2026-11-18 19:48:59.87+07	staff	qrcode	\N	\N	f	171000.00	0.00	\N	\N	0	0
130	2	ORD-20261118-0025	takeaway	\N	xxx	new	65000.00	\N	10	2026-11-18 20:03:35+07	2026-11-18 20:03:35.629+07	staff	\N	\N	\N	f	65000.00	0.00	\N	\N	0	0
145	2	ORD-20261119-0011	dine_in	10	xxx	new	41000.00	nasgor sedeng	4	2026-11-19 18:11:51+07	2026-11-19 18:11:58.382+07	staff	qrcode	\N	\N	t	41000.00	0.00	\N	\N	0	0
131	2	ORD-20261118-0026	dine_in	10	:::::::	new	38000.00	nasgor sedeng	10	2026-11-18 20:05:34+07	2026-11-18 20:05:41.492+07	staff	qrcode	\N	\N	t	38000.00	0.00	\N	\N	0	0
132	2	ORD-20261118-0027	takeaway	\N	roy	new	5000.00	\N	10	2026-11-18 20:06:45+07	2026-11-18 20:06:45.376+07	staff	\N	\N	\N	f	5000.00	0.00	\N	\N	0	0
133	2	ORD-20261118-0028	takeaway	\N	xxx	new	5000.00	\N	10	2026-11-18 20:07:13+07	2026-11-18 20:07:13.071+07	staff	\N	\N	\N	f	5000.00	0.00	\N	\N	0	0
134	2	ORD-20261118-0029	dine_in	08	xxxx	cancelled	30000.00	\N	10	2026-11-18 20:09:41+07	2026-11-18 20:11:45.231+07	staff	qrcode	\N	\N	f	30000.00	0.00	\N	\N	0	0
146	2	ORD-20261119-0012	takeaway	\N	xxxx	new	28000.00	sedeng	4	2026-11-19 18:12:38+07	2026-11-19 18:12:45.103+07	staff	qrcode	\N	\N	t	28000.00	0.00	\N	\N	0	0
136	2	ORD-20261119-0002	dine_in	04	xxx	cancelled	190000.00	kwitiau godog pedes	10	2026-11-19 12:07:31+07	2026-11-19 12:07:59.505+07	staff	\N	\N	\N	f	190000.00	0.00	\N	\N	0	0
137	2	ORD-20261119-0003	dine_in	04	xxxx	new	163000.00	\N	10	2026-11-19 12:11:04+07	2026-11-19 12:11:26.558+07	staff	qrcode	\N	\N	t	163000.00	0.00	\N	\N	0	0
148	2	ORD-20261119-0014	dine_in	2	xxx	new	32000.00	\N	4	2026-11-19 18:52:28+07	2026-11-19 18:52:28.751+07	staff	\N	\N	\N	f	32000.00	0.00	\N	\N	0	0
139	2	ORD-20261119-0005	dine_in	08	xxxx	new	50000.00	nasgor sedeng	10	2026-11-19 12:19:40+07	2026-11-19 12:19:48.234+07	staff	qrcode	\N	\N	t	50000.00	0.00	\N	\N	0	0
161	2	ORD-20261119-0027	dine_in	03	Mami keke	new	169000.00	\N	4	2026-11-19 21:25:44+07	2026-11-19 21:26:01.486+07	staff	qrcode	\N	\N	t	169000.00	0.00	\N	\N	0	0
149	2	ORD-20261119-0015	dine_in	02	xxxx	new	32000.00	\N	4	2026-11-19 18:53:16+07	2026-11-19 18:53:26.046+07	staff	qrcode	\N	\N	t	32000.00	0.00	\N	\N	0	0
151	2	ORD-20261119-0017	dine_in	.	agung	new	226000.00	nasi goreng sedang	4	2026-11-19 19:08:19+07	2026-11-19 19:08:40.293+07	staff	qrcode	\N	\N	t	226000.00	0.00	\N	\N	0	0
153	2	ORD-20261119-0019	dine_in	08	xxx	new	38000.00	\N	4	2026-11-19 19:27:59+07	2026-11-19 19:27:59.806+07	staff	\N	\N	\N	f	38000.00	0.00	\N	\N	0	0
164	2	ORD-20261119-0030	dine_in	06	xxxx	new	79000.00	Kalasan paha	4	2026-11-19 21:47:11+07	2026-11-19 21:47:24.226+07	staff	qrcode	\N	\N	t	79000.00	0.00	\N	\N	0	0
174	2	ORD-20261120-0010	dine_in	03	Ibu july	new	322000.00	\N	4	2026-11-20 14:00:53+07	2026-11-20 14:01:02.148+07	staff	qrcode	\N	\N	t	322000.00	0.00	\N	\N	0	0
156	2	ORD-20261119-0022	takeaway	\N	xxxx	new	35000.00	pedesssssssss	4	2026-11-19 19:38:34+07	2026-11-19 19:38:43.262+07	staff	qrcode	\N	\N	t	35000.00	0.00	\N	\N	0	0
166	2	ORD-20261120-0002	takeaway	\N	xxx	new	38000.00	\N	4	2026-11-20 11:50:42+07	2026-11-20 11:50:51.31+07	staff	qrcode	\N	\N	t	38000.00	0.00	\N	\N	0	0
175	2	ORD-20261120-0011	dine_in	06	xxxx	new	41000.00	\N	4	2026-11-20 14:14:44+07	2026-11-20 14:14:53.685+07	staff	qrcode	\N	\N	t	41000.00	0.00	\N	\N	0	0
168	2	ORD-20261120-0004	dine_in	06	xxx	completed	33000.00	\N	4	2026-11-20 12:18:28+07	2026-11-20 12:49:07.146+07	staff	qrcode	\N	\N	t	33000.00	0.00	\N	\N	0	0
171	2	ORD-20261120-0007	dine_in	02	Ibu yanti	new	727000.00	\N	4	2026-11-20 13:53:29+07	2026-11-20 13:53:57.41+07	staff	qrcode	\N	\N	t	727000.00	0.00	\N	\N	0	0
180	2	ORD-20261120-0016	dine_in	02	xxxx	new	137000.00	mie goreng pedes\nnasgor TDK pedas Tampa kecombrang	4	2026-11-20 18:45:06+07	2026-11-20 18:45:19.795+07	staff	qrcode	\N	\N	t	137000.00	0.00	\N	\N	0	0
177	2	ORD-20261120-0013	takeaway	\N	xxx	new	33000.00	\N	4	2026-11-20 15:57:54+07	2026-11-20 15:58:01.487+07	staff	qrcode	\N	\N	t	33000.00	0.00	\N	\N	0	0
179	2	ORD-20261120-0015	takeaway	\N	xxxx	completed	33000.00	sedeng	4	2026-11-20 18:21:03+07	2026-11-20 18:22:41.701+07	staff	qrcode	\N	\N	t	33000.00	0.00	\N	\N	0	0
181	2	ORD-20261120-0017	dine_in	01	xxxx	new	174000.00	nasi ikan Tampa sambel \nKalasan dada	4	2026-11-20 18:49:13+07	2026-11-20 18:49:24.714+07	staff	qrcode	\N	\N	t	174000.00	0.00	\N	\N	0	0
182	2	ORD-20261120-0018	dine_in	07	xxxx	new	92000.00	jbds less sugar\nmie godog pedes	4	2026-11-20 19:08:11+07	2026-11-20 19:08:28.641+07	staff	qrcode	\N	\N	t	92000.00	0.00	\N	\N	0	0
183	2	ORD-20261120-0019	dine_in	03	pak hermawan	new	138000.00	\N	4	2026-11-20 19:30:34+07	2026-11-20 19:30:41.001+07	staff	qrcode	\N	\N	t	138000.00	0.00	\N	\N	0	0
184	2	ORD-20261120-0020	dine_in	06	xxxxx	new	118000.00	gado TDK pedas	4	2026-11-20 19:52:50+07	2026-11-20 19:53:04.165+07	staff	qrcode	\N	\N	t	118000.00	0.00	\N	\N	0	0
185	2	ORD-20261120-0021	dine_in	04	xxx	new	65000.00	\N	4	2026-11-20 19:56:14+07	2026-11-20 19:56:21.666+07	staff	qrcode	\N	\N	t	65000.00	0.00	\N	\N	0	0
187	2	ORD-20261120-0023	dine_in	04	xxx	new	163000.00	\N	4	2026-11-20 19:59:28+07	2026-11-20 19:59:34.991+07	staff	qrcode	\N	\N	t	163000.00	0.00	\N	\N	0	0
188	2	ORD-20261120-0024	dine_in	08	xxxx	new	79000.00	\N	4	2026-11-20 20:00:48+07	2026-11-20 20:00:55.05+07	staff	qrcode	\N	\N	t	79000.00	0.00	\N	\N	0	0
189	2	ORD-20261120-0025	dine_in	08	xxxx	new	38000.00	\N	4	2026-11-20 20:13:30+07	2026-11-20 20:13:36.184+07	staff	qrcode	\N	\N	t	38000.00	0.00	\N	\N	0	0
186	2	ORD-20261120-0022	dine_in	02	xxxx	cancelled	33000.00	\N	4	2026-11-20 19:56:44+07	2026-11-20 21:21:59.595+07	staff	qrcode	\N	\N	f	33000.00	0.00	\N	\N	0	0
113	2	ORD-20261118-0008	dine_in	08	ami	cancelled	71000.00	\N	10	2026-11-18 18:13:30+07	2026-11-18 18:16:56.669+07	staff	qrcode	\N	\N	f	71000.00	0.00	\N	\N	0	0
112	2	ORD-20261118-0007	dine_in	01	jo	cancelled	5000.00	dingin	10	2026-11-18 18:11:01+07	2026-11-18 18:17:57.092+07	staff	qrcode	\N	\N	f	5000.00	0.00	\N	\N	0	0
88	1	ORD-20261103-0001	takeaway	\N	Yanto	new	15000.00	pedas	6	2026-11-03 22:41:46+07	2026-11-03 22:42:02.173+07	staff	qrcode	\N	\N	t	15000.00	0.00	\N	\N	0	0
150	2	ORD-20261119-0016	takeaway	\N	xxxx	new	53000.00	\N	4	2026-11-19 18:55:00+07	2026-11-19 18:55:11.481+07	staff	qrcode	\N	\N	t	53000.00	0.00	\N	\N	0	0
91	2	ORD-20261110-0001	dine_in	01	gege	new	9000.00	\N	10	2026-11-10 20:15:05+07	2026-11-11 17:17:02.703+07	staff	qrcode	\N	\N	t	9000.00	0.00	\N	\N	0	0
135	2	ORD-20261119-0001	dine_in	03	ronald	new	9000.00	jgn pedas	10	2026-11-19 11:15:20+07	2026-11-19 11:15:53.346+07	staff	cash	\N	\N	t	9000.00	0.00	\N	\N	0	0
119	2	ORD-20261118-0014	dine_in	66	xxxx	new	213000.00	\N	10	2026-11-18 18:53:59+07	2026-11-18 18:54:28.042+07	staff	qrcode	\N	\N	t	213000.00	0.00	\N	\N	0	0
100	1	ORD-20261112-0001	dine_in	1	nai	new	11000.00	\N	6	2026-11-12 21:47:45+07	2026-11-12 21:47:46.197+07	staff	\N	\N	\N	f	11000.00	0.00	\N	\N	0	0
93	2	ORD-20261112-0001	takeaway	\N	gio	new	15000.00	\N	10	2026-11-12 02:17:53+07	2026-11-12 19:17:53.245+07	staff	\N	\N	\N	f	15000.00	0.00	\N	\N	0	0
94	2	ORD-20261112-0002	takeaway	\N	gio	new	5000.00	\N	10	2026-11-12 02:18:34+07	2026-11-12 19:18:34.547+07	staff	\N	\N	\N	f	5000.00	0.00	\N	\N	0	0
95	2	ORD-20261112-0003	takeaway	\N	gio	new	32000.00	\N	10	2026-11-12 02:19:07+07	2026-11-12 19:19:07.385+07	staff	\N	\N	\N	f	32000.00	0.00	\N	\N	0	0
97	2	ORD-20261112-0005	dine_in	14	so	new	10000.00	\N	10	2026-11-12 02:21:37+07	2026-11-12 19:21:37.203+07	staff	\N	\N	\N	f	10000.00	0.00	\N	\N	0	0
89	1	ORD-20261104-0001	dine_in	1	Zamzam	new	42000.00	pedass	6	2026-11-04 00:29:39+07	2026-11-04 01:37:58.552+07	staff	qrcode	\N	\N	t	42000.00	0.00	\N	\N	0	0
120	2	ORD-20261118-0015	dine_in	8	xxxx	new	98000.00	bihun TDK pedas\nnasgor tuna sedng	10	2026-11-18 18:59:00+07	2026-11-18 18:59:17.284+07	staff	qrcode	\N	\N	t	98000.00	0.00	\N	\N	0	0
117	2	ORD-20261118-0012	dine_in	.	rey	cancelled	110000.00	\N	10	2026-11-18 18:25:59+07	2026-11-18 18:59:44.406+07	staff	qrcode	\N	\N	f	110000.00	0.00	\N	\N	0	0
104	2	ORD-20261113-0004	takeaway	\N	-	new	70000.00	sedeng	10	2026-11-13 10:29:07+07	2026-11-13 10:29:16.324+07	staff	qrcode	\N	\N	t	70000.00	0.00	\N	\N	0	0
102	2	ORD-20261113-0002	dine_in	01	jo	cancelled	35000.00	pedas	10	2026-11-13 10:15:50+07	2026-11-13 10:29:58.694+07	staff	qrcode	\N	\N	f	35000.00	0.00	\N	\N	0	0
106	2	ORD-20261118-0001	dine_in	01	jo	cancelled	5000.00	\N	10	2026-11-18 15:43:26+07	2026-11-18 16:08:03.594+07	staff	qrcode	\N	\N	f	5000.00	0.00	\N	\N	0	0
108	2	ORD-20261118-0003	dine_in	07	xxxx	new	33000.00	\N	4	2026-11-18 17:52:04+07	2026-11-18 17:52:04.577+07	staff	\N	\N	\N	f	33000.00	0.00	\N	\N	0	0
121	2	ORD-20261118-0016	dine_in	08	rey	new	114000.00	\N	10	2026-11-18 19:00:28+07	2026-11-18 19:00:34.496+07	staff	qrcode	\N	\N	t	114000.00	0.00	\N	\N	0	0
110	2	ORD-20261118-0005	dine_in	06	Ryko	new	395000.00	\N	4	2026-11-18 17:56:35+07	2026-11-18 17:56:43.419+07	staff	qrcode	\N	\N	t	395000.00	0.00	\N	\N	0	0
111	2	ORD-20261118-0006	dine_in	100	Mr.giovaj	new	86000.00	Tampa bawang putih	4	2026-11-18 18:01:50+07	2026-11-18 18:01:50.96+07	staff	\N	\N	\N	f	86000.00	0.00	\N	\N	0	0
83	1	ORD-20261031-0001	takeaway	\N	Andre	new	12000.00	\N	6	2026-10-31 18:50:00+07	2026-10-31 18:50:56.904+07	staff	qrcode	\N	\N	t	12000.00	0.00	\N	\N	0	0
138	2	ORD-20261119-0004	dine_in	03	xxxx	new	30000.00	\N	10	2026-11-19 12:15:19+07	2026-11-19 12:15:29.237+07	staff	qrcode	\N	\N	t	30000.00	0.00	\N	\N	0	0
84	1	ORD-20261101-0001	takeaway	\N	AJi	proses	19500.00	\N	6	2026-11-02 04:52:52+07	2026-11-01 22:15:33.293+07	staff	\N	\N	\N	f	19500.00	0.00	\N	\N	0	0
85	2	ORD-20261103-0001	dine_in	-	budi	cancelled	5000.00	\N	10	2026-11-03 23:36:13+07	2026-11-03 16:36:29.045+07	staff	\N	\N	\N	f	5000.00	0.00	\N	\N	0	0
86	2	ORD-20261103-0002	dine_in	3	jo	new	30000.00	\N	10	2026-11-03 23:39:56+07	2026-11-03 16:41:26.49+07	staff	qrcode	\N	\N	t	30000.00	0.00	\N	\N	0	0
87	2	ORD-20261103-0003	dine_in	-	jo	new	5000.00	\N	10	2026-11-03 23:45:33+07	2026-11-03 16:45:33.09+07	staff	\N	\N	\N	f	5000.00	0.00	\N	\N	0	0
123	2	ORD-20261118-0018	takeaway	\N	messi	new	137000.00	ayam dada semua	10	2026-11-18 19:29:23+07	2026-11-18 19:29:39.57+07	staff	qrcode	\N	\N	t	137000.00	0.00	\N	\N	0	0
124	2	ORD-20261118-0019	dine_in	000	xxx	new	9000.00	\N	10	2026-11-18 19:30:25+07	2026-11-18 19:30:25.726+07	staff	\N	\N	\N	f	9000.00	0.00	\N	\N	0	0
140	2	ORD-20261119-0006	dine_in	02	xxx	new	373000.00	\N	10	2026-11-19 12:27:16+07	2026-11-19 12:27:41.167+07	staff	qrcode	\N	\N	t	373000.00	0.00	\N	\N	0	0
125	2	ORD-20261118-0020	dine_in	08	asl	new	9000.00	.	10	2026-11-18 19:31:36+07	2026-11-18 19:31:46.05+07	staff	qrcode	\N	\N	t	9000.00	0.00	\N	\N	0	0
126	2	ORD-20261118-0021	dine_in	07	xxx	new	90000.00	nasgor pedes\nkwitiau sedeng Tampa otak2	10	2026-11-18 19:35:51+07	2026-11-18 19:36:05.389+07	staff	qrcode	\N	\N	t	90000.00	0.00	\N	\N	0	0
128	2	ORD-20261118-0023	takeaway	\N	xxxx	new	65000.00	kwitiau pedes bangat	10	2026-11-18 19:59:30+07	2026-11-18 19:59:30.094+07	staff	\N	\N	\N	f	65000.00	0.00	\N	\N	0	0
129	2	ORD-20261118-0024	takeaway	\N	xxx	new	65000.00	kwitiau pedes bangattttt	10	2026-11-18 20:00:30+07	2026-11-18 20:00:30.857+07	staff	\N	\N	\N	f	65000.00	0.00	\N	\N	0	0
152	2	ORD-20261119-0018	takeaway	\N	xxxxx	new	88000.00	\N	4	2026-11-19 19:15:23+07	2026-11-19 19:15:41.292+07	staff	qrcode	\N	\N	t	88000.00	0.00	\N	\N	0	0
142	2	ORD-20261119-0008	takeaway	\N	jo	new	5000.00	\N	10	2026-11-19 13:24:26+07	2026-11-19 13:24:32.705+07	staff	qrcode	\N	\N	t	5000.00	0.00	\N	\N	0	0
144	2	ORD-20261119-0010	dine_in	07	xxx	new	188000.00	nasgor pedes\nektra sambel mata	4	2026-11-19 17:15:47+07	2026-11-19 17:16:12.36+07	staff	qrcode	\N	\N	t	188000.00	0.00	\N	\N	0	0
147	2	ORD-20261119-0013	dine_in	07	xxxx	new	183000.00	\N	4	2026-11-19 18:41:41+07	2026-11-19 18:42:09.985+07	staff	qrcode	\N	\N	t	183000.00	0.00	\N	\N	0	0
159	2	ORD-20261119-0025	dine_in	01	xxxxx	cancelled	103000.00	\N	4	2026-11-19 19:46:52+07	2026-11-19 19:47:18.391+07	staff	\N	\N	\N	f	103000.00	0.00	\N	\N	0	0
155	2	ORD-20261119-0021	dine_in	02	xxxx	new	58000.00	\N	4	2026-11-19 19:31:40+07	2026-11-19 19:31:46.325+07	staff	qrcode	\N	\N	t	58000.00	0.00	\N	\N	0	0
165	2	ORD-20261120-0001	takeaway	\N	xxxx	new	56000.00	\N	4	2026-11-20 11:21:35+07	2026-11-20 11:21:41.895+07	staff	qrcode	\N	\N	t	56000.00	0.00	\N	\N	0	0
158	2	ORD-20261119-0024	takeaway	\N	xxxx	cancelled	70000.00	\N	4	2026-11-19 19:44:10+07	2026-11-19 19:44:22.272+07	staff	\N	\N	\N	f	70000.00	0.00	\N	\N	0	0
163	2	ORD-20261119-0029	dine_in	03	xxx	new	152000.00	\N	4	2026-11-19 21:42:26+07	2026-11-19 21:42:33.107+07	staff	qrcode	\N	\N	t	152000.00	0.00	\N	\N	0	0
160	2	ORD-20261119-0026	dine_in	01	xxxxx	new	173000.00	\N	4	2026-11-19 19:48:16+07	2026-11-19 19:48:30.485+07	staff	qrcode	\N	\N	t	173000.00	0.00	\N	\N	0	0
157	2	ORD-20261119-0023	takeaway	\N	xxxxx	cancelled	70000.00	\N	4	2026-11-19 19:42:54+07	2026-11-19 19:48:52.561+07	staff	qrcode	\N	\N	f	70000.00	0.00	\N	\N	0	0
162	2	ORD-20261119-0028	dine_in	04	kantorr	new	1053000.00	\N	4	2026-11-19 21:41:38+07	2026-11-19 21:48:25.606+07	staff	qrcode	\N	\N	t	1053000.00	0.00	\N	\N	0	0
167	2	ORD-20261120-0003	takeaway	\N	x xx	new	38000.00	\N	4	2026-11-20 11:58:45+07	2026-11-20 11:58:53.984+07	staff	qrcode	\N	\N	t	38000.00	0.00	\N	\N	0	0
169	2	ORD-20261120-0005	takeaway	\N	xxx	new	20000.00	\N	4	2026-11-20 12:49:03+07	2026-11-20 12:49:10.206+07	staff	qrcode	\N	\N	t	20000.00	0.00	\N	\N	0	0
170	2	ORD-20261120-0006	takeaway	\N	xxx	new	35000.00	\N	4	2026-11-20 12:51:02+07	2026-11-20 12:51:09.4+07	staff	qrcode	\N	\N	t	35000.00	0.00	\N	\N	0	0
172	2	ORD-20261120-0008	dine_in	02	azizz goboyyyyy	new	25000.00	\N	4	2026-11-20 13:55:18+07	2026-11-20 13:55:26.325+07	staff	qrcode	\N	\N	t	25000.00	0.00	\N	\N	0	0
173	2	ORD-20261120-0009	takeaway	\N	xxx	new	70000.00	\N	4	2026-11-20 13:57:22+07	2026-11-20 13:57:29.178+07	staff	qrcode	\N	\N	t	70000.00	0.00	\N	\N	0	0
176	2	ORD-20261120-0012	takeaway	\N	xxxx	new	35000.00	\N	4	2026-11-20 14:47:17+07	2026-11-20 14:47:24.884+07	staff	qrcode	\N	\N	t	35000.00	0.00	\N	\N	0	0
178	2	ORD-20261120-0014	takeaway	\N	xxxx	cancelled	33000.00	\N	4	2026-11-20 18:20:42+07	2026-11-20 18:21:09.278+07	staff	\N	\N	\N	f	33000.00	0.00	\N	\N	0	0
190	2	ORD-20261120-0026	dine_in	10	xxx	cancelled	84000.00	kwitiau sedeng dikit	4	2026-11-20 20:15:29+07	2026-11-20 21:22:01.514+07	staff	qrcode	\N	\N	f	84000.00	0.00	\N	\N	0	0
191	2	ORD-20261120-0027	dine_in	10	xxxx	new	84000.00	\N	4	2026-11-20 21:31:31+07	2026-11-20 21:31:44.414+07	staff	qrcode	\N	\N	t	84000.00	0.00	\N	\N	0	0
192	2	ORD-20261120-0028	dine_in	10	xxx	new	6000.00	\N	4	2026-11-20 21:33:35+07	2026-11-20 21:33:41.029+07	staff	qrcode	\N	\N	t	6000.00	0.00	\N	\N	0	0
219	2	ORD-20261122-0006	takeaway	\N	xxx	new	54000.00	1 Tampa kol	4	2026-11-22 12:13:41+07	2026-11-22 12:13:52.511+07	staff	qrcode	\N	\N	t	54000.00	0.00	\N	\N	0	0
209	2	ORD-20261121-0017	takeaway	\N	xxx	completed	108000.00	\N	4	2026-11-21 19:09:57+07	2026-11-21 19:11:05.162+07	staff	qrcode	\N	\N	t	108000.00	0.00	\N	\N	0	0
193	2	ORD-20261121-0001	dine_in	02	xxx	new	98000.00	\N	4	2026-11-21 10:59:45+07	2026-11-21 11:06:38.315+07	staff	qrcode	\N	\N	t	98000.00	0.00	\N	\N	0	0
194	2	ORD-20261121-0002	dine_in	04	xxxx	new	152000.00	\N	4	2026-11-21 11:06:30+07	2026-11-21 11:06:43.33+07	staff	qrcode	\N	\N	t	152000.00	0.00	\N	\N	0	0
208	2	ORD-20261121-0016	dine_in	02	xxx	completed	228000.00	\N	4	2026-11-21 15:50:28+07	2026-11-21 19:11:10.032+07	staff	qrcode	\N	\N	t	228000.00	0.00	\N	\N	0	0
195	2	ORD-20261121-0003	dine_in	02	xxxx	new	277000.00	\N	4	2026-11-21 12:32:31+07	2026-11-21 12:32:36.901+07	staff	qrcode	\N	\N	t	277000.00	0.00	\N	\N	0	0
207	2	ORD-20261121-0015	takeaway	\N	xxxxx	completed	244000.00	\N	4	2026-11-21 15:30:32+07	2026-11-21 19:11:11.368+07	staff	qrcode	\N	\N	t	244000.00	0.00	\N	\N	0	0
196	2	ORD-20261121-0004	dine_in	08	xxxx	new	43000.00	\N	4	2026-11-21 12:33:08+07	2026-11-21 12:33:16.062+07	staff	qrcode	\N	\N	t	43000.00	0.00	\N	\N	0	0
206	2	ORD-20261121-0014	dine_in	02	xxxx	completed	50000.00	\N	4	2026-11-21 14:37:04+07	2026-11-21 19:11:13.363+07	staff	qrcode	\N	\N	t	50000.00	0.00	\N	\N	0	0
197	2	ORD-20261121-0005	dine_in	04	xxxx	new	263000.00	\N	4	2026-11-21 12:51:19+07	2026-11-21 12:51:26.334+07	staff	qrcode	\N	\N	t	263000.00	0.00	\N	\N	0	0
205	2	ORD-20261121-0013	dine_in	02	xxx	completed	72000.00	\N	4	2026-11-21 14:20:11+07	2026-11-21 19:11:14.196+07	staff	qrcode	\N	\N	t	72000.00	0.00	\N	\N	0	0
198	2	ORD-20261121-0006	dine_in	08	xxx	new	76000.00	\N	4	2026-11-21 13:23:40+07	2026-11-21 13:23:46.747+07	staff	qrcode	\N	\N	t	76000.00	0.00	\N	\N	0	0
199	2	ORD-20261121-0007	takeaway	\N	xxxx	new	125000.00	\N	4	2026-11-21 13:34:01+07	2026-11-21 13:34:06.88+07	staff	qrcode	\N	\N	t	125000.00	0.00	\N	\N	0	0
201	2	ORD-20261121-0009	dine_in	60	xxxx	new	229000.00	\N	4	2026-11-21 13:52:41+07	2026-11-21 13:53:20.964+07	staff	qrcode	\N	\N	t	229000.00	0.00	\N	\N	0	0
202	2	ORD-20261121-0010	dine_in	07	xxxxx	new	83000.00	\N	4	2026-11-21 13:56:23+07	2026-11-21 13:56:23.492+07	staff	\N	\N	\N	f	83000.00	0.00	\N	\N	0	0
203	2	ORD-20261121-0011	dine_in	02	xxxx	new	150000.00	\N	4	2026-11-21 13:58:59+07	2026-11-21 13:58:59.154+07	staff	\N	\N	\N	f	150000.00	0.00	\N	\N	0	0
211	2	ORD-20261121-0019	takeaway	\N	xxx	new	38000.00	\N	4	2026-11-21 19:18:02+07	2026-11-21 19:18:03.019+07	staff	\N	\N	\N	f	38000.00	0.00	\N	\N	0	0
200	2	ORD-20261121-0008	dine_in	02	xxxx	completed	72000.00	\N	4	2026-11-21 13:51:04+07	2026-11-21 14:14:18.289+07	staff	qrcode	\N	\N	t	72000.00	0.00	\N	\N	0	0
204	2	ORD-20261121-0012	takeaway	\N	xxx	new	12000.00	\N	4	2026-11-21 14:14:11+07	2026-11-21 14:14:20.957+07	staff	qrcode	\N	\N	t	12000.00	0.00	\N	\N	0	0
220	2	ORD-20261122-0007	takeaway	\N	xxx	new	70000.00	\N	4	2026-11-22 12:16:31+07	2026-11-22 12:16:37.845+07	staff	qrcode	\N	\N	t	70000.00	0.00	\N	\N	0	0
212	2	ORD-20261121-0020	takeaway	\N	xxx	new	38000.00	\N	4	2026-11-21 19:18:16+07	2026-11-21 19:18:16.848+07	staff	\N	\N	\N	f	38000.00	0.00	\N	\N	0	0
227	2	ORD-20261122-0014	dine_in	07	xxx	new	38000.00	\N	4	2026-11-22 14:26:55+07	2026-11-22 14:27:02.215+07	staff	qrcode	\N	\N	t	38000.00	0.00	\N	\N	0	0
221	2	ORD-20261122-0008	takeaway	\N	xxx	new	20000.00	\N	4	2026-11-22 12:21:26+07	2026-11-22 12:21:31.344+07	staff	qrcode	\N	\N	t	20000.00	0.00	\N	\N	0	0
210	2	ORD-20261121-0018	dine_in	05	xxx	completed	204000.00	\N	4	2026-11-21 19:13:01+07	2026-11-21 19:19:02.473+07	staff	qrcode	\N	\N	t	204000.00	0.00	\N	\N	0	0
213	2	ORD-20261121-0021	takeaway	\N	x x	new	38000.00	\N	4	2026-11-21 19:18:44+07	2026-11-21 19:20:10.134+07	staff	qrcode	\N	\N	t	38000.00	0.00	\N	\N	0	0
214	2	ORD-20261122-0001	takeaway	\N	sela	new	345000.00	\N	4	2026-11-22 11:08:55+07	2026-11-22 11:09:00.736+07	staff	qrcode	\N	\N	t	345000.00	0.00	\N	\N	0	0
222	2	ORD-20261122-0009	dine_in	02	xxxxx	new	89000.00	nasgor tuna pedas	4	2026-11-22 12:46:15+07	2026-11-22 12:46:22.273+07	staff	qrcode	\N	\N	t	89000.00	0.00	\N	\N	0	0
215	2	ORD-20261122-0002	dine_in	03	xxx	new	38000.00	\N	4	2026-11-22 11:22:02+07	2026-11-22 11:22:08+07	staff	qrcode	\N	\N	t	38000.00	0.00	\N	\N	0	0
216	2	ORD-20261122-0003	dine_in	02	xxx	new	123000.00	\N	4	2026-11-22 11:37:44+07	2026-11-22 11:37:50.776+07	staff	qrcode	\N	\N	t	123000.00	0.00	\N	\N	0	0
229	2	ORD-20261122-0016	dine_in	02	xxxx	completed	76000.00	\N	4	2026-11-22 15:07:25+07	2026-11-22 15:59:29.797+07	staff	qrcode	\N	\N	t	76000.00	0.00	\N	\N	0	0
217	2	ORD-20261122-0004	dine_in	01	xxx	new	93000.00	\N	4	2026-11-22 12:03:34+07	2026-11-22 12:03:43.215+07	staff	qrcode	\N	\N	t	93000.00	0.00	\N	\N	0	0
223	2	ORD-20261122-0010	takeaway	\N	xxx	new	104000.00	\N	4	2026-11-22 14:01:11+07	2026-11-22 14:01:18.41+07	staff	qrcode	\N	\N	t	104000.00	0.00	\N	\N	0	0
218	2	ORD-20261122-0005	dine_in	07	xxx	new	26000.00	\N	4	2026-11-22 12:12:17+07	2026-11-22 12:12:24.105+07	staff	qrcode	\N	\N	t	26000.00	0.00	\N	\N	0	0
228	2	ORD-20261122-0015	dine_in	08	xxxxx	new	266000.00	\N	4	2026-11-22 14:29:52+07	2026-11-22 14:30:00.768+07	staff	qrcode	\N	\N	t	266000.00	0.00	\N	\N	0	0
232	2	ORD-20261122-0019	dine_in	04	xxxxx	new	467000.00	ayam penyet sambel Kalasan \nnasgor tuna sedeng\ngado sedeng\nkalalasan dada	4	2026-11-22 15:52:45+07	2026-11-22 15:53:24.539+07	staff	qrcode	\N	\N	t	467000.00	0.00	\N	\N	0	0
224	2	ORD-20261122-0011	dine_in	06	xxxx	new	124000.00	\N	4	2026-11-22 14:04:35+07	2026-11-22 14:07:49.488+07	staff	qrcode	\N	\N	t	124000.00	0.00	\N	\N	0	0
225	2	ORD-20261122-0012	dine_in	04	xxx	new	143000.00	\N	4	2026-11-22 14:05:49+07	2026-11-22 14:07:53.082+07	staff	qrcode	\N	\N	t	143000.00	0.00	\N	\N	0	0
226	2	ORD-20261122-0013	dine_in	02	xxx	new	148000.00	\N	4	2026-11-22 14:07:10+07	2026-11-22 14:07:55.772+07	staff	qrcode	\N	\N	t	148000.00	0.00	\N	\N	0	0
235	2	ORD-20261122-0022	dine_in	02	ibu yanti	new	252000.00	\N	4	2026-11-22 16:14:50+07	2026-11-22 16:15:01.198+07	staff	qrcode	\N	\N	t	252000.00	0.00	\N	\N	0	0
233	2	ORD-20261122-0020	dine_in	04	xxx	new	80000.00	\N	4	2026-11-22 15:55:35+07	2026-11-22 15:55:44.171+07	staff	qrcode	\N	\N	t	80000.00	0.00	\N	\N	0	0
231	2	ORD-20261122-0018	dine_in	08	xx	completed	60000.00	\N	4	2026-11-22 15:28:59+07	2026-11-22 15:58:58.848+07	staff	qrcode	\N	\N	t	60000.00	0.00	\N	\N	0	0
230	2	ORD-20261122-0017	takeaway	\N	ni	completed	55000.00	\N	4	2026-11-22 15:09:02+07	2026-11-22 15:59:24.669+07	staff	qrcode	\N	\N	t	55000.00	0.00	\N	\N	0	0
234	2	ORD-20261122-0021	dine_in	10	xxxx	completed	58000.00	Tampa kecombrang	4	2026-11-22 16:07:53+07	2026-11-22 16:10:40.016+07	staff	qrcode	\N	\N	t	58000.00	0.00	\N	\N	0	0
236	2	ORD-20261122-0023	dine_in	11	xxx	new	407000.00	gado sedeng\nnasi goreng sedang	4	2026-11-22 16:20:32+07	2026-11-22 16:20:48.692+07	staff	qrcode	\N	\N	t	407000.00	0.00	\N	\N	0	0
237	2	ORD-20261122-0024	dine_in	06	xxxx	new	62000.00	\N	4	2026-11-22 16:27:35+07	2026-11-22 16:27:42.481+07	staff	qrcode	\N	\N	t	62000.00	0.00	\N	\N	0	0
238	2	ORD-20261122-0025	dine_in	02	ibu yanti	new	30000.00	\N	4	2026-11-22 16:29:20+07	2026-11-22 16:29:25.609+07	staff	qrcode	\N	\N	t	30000.00	0.00	\N	\N	0	0
239	2	ORD-20261122-0026	dine_in	04	sela	new	10000.00	\N	4	2026-11-22 16:29:54+07	2026-11-22 16:29:54.87+07	staff	\N	\N	\N	f	10000.00	0.00	\N	\N	0	0
240	2	ORD-20261122-0027	dine_in	13	xxx	new	153000.00	\N	4	2026-11-22 16:32:55+07	2026-11-22 16:33:07.111+07	staff	qrcode	\N	\N	t	153000.00	0.00	\N	\N	0	0
241	2	ORD-20261122-0028	takeaway	\N	sela	new	100000.00	\N	4	2026-11-22 16:49:37+07	2026-11-22 16:49:42.406+07	staff	qrcode	\N	\N	t	100000.00	0.00	\N	\N	0	0
242	2	ORD-20261122-0029	dine_in	02	ibu yanti	completed	5000.00	\N	4	2026-11-22 16:59:14+07	2026-11-22 16:59:24.262+07	staff	qrcode	\N	\N	t	5000.00	0.00	\N	\N	0	0
243	2	ORD-20261122-0030	dine_in	13	xxxx	new	39000.00	\N	4	2026-11-22 17:00:48+07	2026-11-22 17:00:55.233+07	staff	qrcode	\N	\N	t	39000.00	0.00	\N	\N	0	0
244	2	ORD-20261122-0031	dine_in	13	xxx	new	63000.00	\N	4	2026-11-22 17:01:35+07	2026-11-22 17:01:42.493+07	staff	qrcode	\N	\N	t	63000.00	0.00	\N	\N	0	0
245	2	ORD-20261122-0032	dine_in	13	xxx	new	20000.00	\N	4	2026-11-22 17:04:22+07	2026-11-22 17:04:29.45+07	staff	qrcode	\N	\N	t	20000.00	0.00	\N	\N	0	0
246	2	ORD-20261122-0033	dine_in	02	ibu yanti	new	105000.00	\N	4	2026-11-22 17:13:40+07	2026-11-22 17:13:45.784+07	staff	qrcode	\N	\N	t	105000.00	0.00	\N	\N	0	0
260	2	ORD-20261122-0047	takeaway	\N	xxxx	new	33000.00	gado2 pedes	4	2026-11-22 20:14:27+07	2026-11-22 20:14:35.791+07	staff	qrcode	\N	\N	t	33000.00	0.00	\N	\N	0	0
247	2	ORD-20261122-0034	dine_in	13	xxxx	new	100000.00	mie godog pedes\ngado sedeng nasi	4	2026-11-22 17:18:03+07	2026-11-22 17:18:09.544+07	staff	qrcode	\N	\N	t	100000.00	0.00	\N	\N	0	0
248	2	ORD-20261122-0035	dine_in	14	xxxx	new	135000.00	1 nasi setengah \nnasgor tuna TDK pedas	4	2026-11-22 17:31:48+07	2026-11-22 17:32:52.359+07	staff	qrcode	\N	\N	t	135000.00	0.00	\N	\N	0	0
249	2	ORD-20261122-0036	dine_in	13	xxxx	new	79000.00	\N	4	2026-11-22 17:46:48+07	2026-11-22 17:46:54.896+07	staff	qrcode	\N	\N	t	79000.00	0.00	\N	\N	0	0
250	2	ORD-20261122-0037	dine_in	07	xxx	new	252000.00	gado2 sedeng	4	2026-11-22 17:51:59+07	2026-11-22 17:52:07.014+07	staff	qrcode	\N	\N	t	252000.00	0.00	\N	\N	0	0
256	2	ORD-20261122-0043	dine_in	07	xxxxx	cancelled	78000.00	nasgor pedes	4	2026-11-22 19:22:12+07	2026-11-22 20:56:48.836+07	staff	qrcode	\N	\N	f	78000.00	0.00	\N	\N	0	0
251	2	ORD-20261122-0038	dine_in	15	xxxx	new	84000.00	nasi goreng kecombrang pedes bangat\nnasi goreng tuna TDK pedas Tampa kecombrang	4	2026-11-22 18:42:59+07	2026-11-22 18:43:14.941+07	staff	qrcode	\N	\N	t	84000.00	0.00	\N	\N	0	0
261	2	ORD-20261122-0048	dine_in	02	xxxx	cancelled	53000.00	\N	4	2026-11-22 20:18:52+07	2026-11-22 20:56:49.603+07	staff	qrcode	\N	\N	f	53000.00	0.00	\N	\N	0	0
252	2	ORD-20261122-0039	dine_in	06	xxx	new	129000.00	nasgor sedeng	4	2026-11-22 18:45:07+07	2026-11-22 18:45:13.757+07	staff	qrcode	\N	\N	t	129000.00	0.00	\N	\N	0	0
253	2	ORD-20261122-0040	takeaway	\N	xxxx	new	104000.00	\N	4	2026-11-22 18:47:40+07	2026-11-22 18:47:47.068+07	staff	qrcode	\N	\N	t	104000.00	0.00	\N	\N	0	0
254	2	ORD-20261122-0041	dine_in	14	xxx	new	145000.00	\N	4	2026-11-22 19:05:28+07	2026-11-22 19:05:34.367+07	staff	qrcode	\N	\N	t	145000.00	0.00	\N	\N	0	0
262	2	ORD-20261122-0049	dine_in	06	xxxx	new	408000.00	\N	4	2026-11-22 20:59:10+07	2026-11-22 20:59:18.09+07	staff	qrcode	\N	\N	t	408000.00	0.00	\N	\N	0	0
255	2	ORD-20261122-0042	dine_in	20	xxxx	new	151000.00	kwetiau pedes dikit\nnasgor tuna TDK pedas Tampa kecomrang	4	2026-11-22 19:09:08+07	2026-11-22 19:09:22.768+07	staff	qrcode	\N	\N	t	151000.00	0.00	\N	\N	0	0
257	2	ORD-20261122-0044	dine_in	99	xxxx	new	131000.00	pedes\nTampa kecomrang	4	2026-11-22 19:32:50+07	2026-11-22 19:32:54.746+07	staff	qrcode	\N	\N	t	131000.00	0.00	\N	\N	0	0
263	2	ORD-20261123-0001	takeaway	\N	xxxx	new	30000.00	\N	4	2026-11-23 11:50:37+07	2026-11-23 11:50:42.024+07	staff	qrcode	\N	\N	t	30000.00	0.00	\N	\N	0	0
258	2	ORD-20261122-0045	dine_in	01	xxxxx	new	197000.00	nasgor tuna sedeng \n(rahang tuna bungkus)	4	2026-11-22 20:03:09+07	2026-11-22 20:03:16.797+07	staff	qrcode	\N	\N	t	197000.00	0.00	\N	\N	0	0
259	2	ORD-20261122-0046	dine_in	03	xxx	new	50000.00	nasgor pedes	4	2026-11-22 20:10:24+07	2026-11-22 20:10:30.392+07	staff	qrcode	\N	\N	t	50000.00	0.00	\N	\N	0	0
264	2	ORD-20261123-0002	dine_in	06	xxxx	new	178000.00	\N	4	2026-11-23 13:02:15+07	2026-11-23 13:02:21.025+07	staff	qrcode	\N	\N	t	178000.00	0.00	\N	\N	0	0
265	2	ORD-20261123-0003	takeaway	\N	xxxx	new	257000.00	\N	4	2026-11-23 13:23:10+07	2026-11-23 13:23:18.428+07	staff	qrcode	\N	\N	t	257000.00	0.00	\N	\N	0	0
\.


--
-- Data for Name: member_point_histories; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "public"."member_point_histories" ("id", "tenant_id", "member_id", "order_id", "type", "points", "description", "created_at", "updated_at") FROM stdin;
\.


--
-- Data for Name: menu_categories; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "public"."menu_categories" ("id", "tenant_id", "name", "sort_order", "is_active", "created_at", "updated_at", "categories_picture") FROM stdin;
3	1	Cemilan	0	t	2026-10-04 02:33:48.332+07	2026-10-16 00:15:37.927+07	https://obaybiymhuukucvvgdsq.supabase.co/storage/v1/object/public/uploads/menu/ac08d500-1837-4a0a-b4ea-81ec913e9ee2.jpg
1	1	Makanan	0	t	2026-07-28 14:40:51.168+07	2026-10-16 00:15:52.601+07	https://obaybiymhuukucvvgdsq.supabase.co/storage/v1/object/public/uploads/menu/971e2659-c458-4f40-8512-a232443e0a75.jpg
2	1	Minuman	0	t	2026-07-28 14:40:57.752+07	2026-10-16 00:16:02.013+07	https://obaybiymhuukucvvgdsq.supabase.co/storage/v1/object/public/uploads/menu/f6e2e451-5c1d-4616-b7a2-5b6886db2ad2.jpg
4	2	Makanan	0	t	2026-10-27 11:12:45.404+07	2026-10-27 11:12:45.404+07	\N
8	2	Minuman	0	t	2026-10-29 00:25:37.89+07	2026-10-29 00:25:37.89+07	\N
9	2	Ikan	0	t	2026-11-18 17:12:03.942+07	2026-11-18 17:12:03.942+07	\N
10	2	Coffee&Latte	0	t	2026-11-19 14:01:48.144+07	2026-11-19 14:01:48.144+07	\N
\.


--
-- Data for Name: menu_items; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "public"."menu_items" ("id", "tenant_id", "category_id", "name", "description", "price", "image_url", "is_available", "sort_order", "created_at", "updated_at", "original_price", "is_favorite", "is_banner") FROM stdin;
11	2	4	Bandeng Bakar Tanpa Duri	Bandeng bakar tanpa duri	70000.00	https://obaybiymhuukucvvgdsq.supabase.co/storage/v1/object/public/uploads/menu/d098c54d-234d-4e5a-ba19-90b2399c97f7.png	t	0	2026-10-28 23:11:59.211+07	2026-10-28 23:11:59.211+07	\N	f	f
13	2	4	Nasi Goreng tuna	\N	38000.00	https://obaybiymhuukucvvgdsq.supabase.co/storage/v1/object/public/uploads/menu/10576ddf-ded6-45f5-aa08-1f36ab40b517.jpg	t	0	2026-10-28 23:20:54.163+07	2026-10-28 23:21:38.169+07	0.00	t	t
14	2	4	Cah Kangkung	\N	25000.00	https://obaybiymhuukucvvgdsq.supabase.co/storage/v1/object/public/uploads/menu/6abf3e81-2771-438a-ae10-9f7e97ffac89.png	t	0	2026-10-28 23:28:36.034+07	2026-10-28 23:28:36.034+07	\N	f	f
16	2	4	Nasi Putih	\N	9000.00	https://obaybiymhuukucvvgdsq.supabase.co/storage/v1/object/public/uploads/menu/97aaf187-0f44-4af8-b7c3-368ea090c714.png	t	0	2026-10-28 23:30:22.645+07	2026-10-28 23:30:22.645+07	\N	f	f
17	2	4	Sambal Pikoelan	\N	0.00	https://obaybiymhuukucvvgdsq.supabase.co/storage/v1/object/public/uploads/menu/ba4a059e-552e-4170-a1e3-cc6cb33b3499.png	t	0	2026-10-28 23:31:14.247+07	2026-10-28 23:31:14.247+07	\N	f	f
18	2	4	Sambal Matah	\N	0.00	https://obaybiymhuukucvvgdsq.supabase.co/storage/v1/object/public/uploads/menu/bb1cd64c-c763-44ba-967b-d7a9dd786b85.png	t	0	2026-10-28 23:31:42.799+07	2026-10-28 23:31:42.799+07	\N	f	f
24	2	4	Nasi Goreng + Kecombrang	\N	35000.00	https://obaybiymhuukucvvgdsq.supabase.co/storage/v1/object/public/uploads/menu/4e64d155-8973-44af-9ad2-f4679646e729.jpg	t	0	2026-10-28 23:49:03.524+07	2026-10-28 23:49:03.524+07	\N	t	f
2	1	2	Teh Manis Dingin	Teh manis dengan es menyegarkan hati	7500.00	https://obaybiymhuukucvvgdsq.supabase.co/storage/v1/object/public/uploads/menu/46de5e3f-e732-4376-88ca-0c2ae209d663.jpg	t	0	2026-07-28 14:42:17.845+07	2026-10-12 00:47:09.802+07	0.00	t	t
1	1	1	Nasi Uduk	Nasi uduk	12000.00	https://obaybiymhuukucvvgdsq.supabase.co/storage/v1/object/public/uploads/menu/7ff274a9-bf01-41e1-9fb1-1c551478cd7e.jpeg	t	0	2026-07-28 14:41:31.894+07	2026-10-14 00:42:17.45+07	15000.00	t	t
4	1	1	Bihun Goreng	bihun dengan rasa manis semanis pandangan pertama	11000.00	https://obaybiymhuukucvvgdsq.supabase.co/storage/v1/object/public/uploads/menu/bf24f741-f32c-4707-9f7e-3b14fd35f12a.jpeg	t	0	2026-07-28 15:47:25.152+07	2026-10-19 01:23:11.973+07	12000.00	t	f
31	2	4	Kwetiau Goreng Belacan	\N	35000.00	https://obaybiymhuukucvvgdsq.supabase.co/storage/v1/object/public/uploads/menu/9e0b9465-ec91-4d25-9323-93df1460b1ff.jpg	t	0	2026-10-29 00:01:03.087+07	2026-10-29 00:01:03.087+07	\N	t	t
3	1	2	Teh Manis Panas	Teh manis yang menghangatkan hati	5000.00	https://obaybiymhuukucvvgdsq.supabase.co/storage/v1/object/public/uploads/menu/2d8e2a08-08aa-49b5-a592-8b68c8908690.jpg	t	0	2026-07-28 14:42:53.025+07	2026-10-19 01:24:26.554+07	0.00	f	f
32	2	4	Bakmi Goreng	\N	35000.00	https://obaybiymhuukucvvgdsq.supabase.co/storage/v1/object/public/uploads/menu/2431ac12-0e3f-41de-81e8-0e6f9b625e53.png	t	0	2026-10-29 00:01:39.232+07	2026-10-29 00:01:39.232+07	\N	f	f
19	2	4	Nasi Ayam Kalasan	\N	38000.00	https://obaybiymhuukucvvgdsq.supabase.co/storage/v1/object/public/uploads/menu/68515861-cac8-4137-bcb6-4aee4f1083bc.jpg	t	0	2026-10-28 23:35:56.314+07	2026-11-03 16:59:19.69+07	0.00	t	t
33	2	4	Bihun Goreng	\N	35000.00	https://obaybiymhuukucvvgdsq.supabase.co/storage/v1/object/public/uploads/menu/52903915-f4a5-495a-99a5-1980d5b556c0.png	t	0	2026-10-29 00:02:06.32+07	2026-10-29 00:02:06.32+07	\N	f	f
34	2	4	Kwetiau Godog Jawa	\N	30000.00	https://obaybiymhuukucvvgdsq.supabase.co/storage/v1/object/public/uploads/menu/51509b5a-279f-4fdc-95da-0a01fe5cf28a.png	t	0	2026-10-29 00:02:47.603+07	2026-10-29 00:02:47.603+07	\N	f	f
25	2	4	Nasi Goreng Merah	\N	35000.00	https://obaybiymhuukucvvgdsq.supabase.co/storage/v1/object/public/uploads/menu/01161ac6-9079-4987-8a11-bbc99892001c.png	t	0	2026-10-28 23:49:52.457+07	2026-11-18 15:50:19.318+07	0.00	f	f
20	2	4	Nasi Ayam Geprek	\N	38000.00	https://obaybiymhuukucvvgdsq.supabase.co/storage/v1/object/public/uploads/menu/6fc61063-9fed-4082-885d-18b5345349b8.png	t	0	2026-10-28 23:40:04.876+07	2026-11-03 16:59:59.828+07	0.00	f	f
23	2	4	Nasi Chicken Katsu Sambal Matah	\N	38000.00	https://obaybiymhuukucvvgdsq.supabase.co/storage/v1/object/public/uploads/menu/c6c70227-ec91-442b-90bc-0be2ec79dd21.png	t	0	2026-10-28 23:42:29.677+07	2026-11-03 17:00:45.808+07	0.00	f	f
22	2	4	Nasi Chicken Katsu Sambal Pikoelan	\N	38000.00	https://obaybiymhuukucvvgdsq.supabase.co/storage/v1/object/public/uploads/menu/b37a9b6d-5516-4685-b3de-10c2b2ff5b65.png	t	0	2026-10-28 23:41:49.062+07	2026-11-03 17:00:58.428+07	0.00	f	f
30	2	4	Nasi Sarang Ayam	\N	38000.00	https://obaybiymhuukucvvgdsq.supabase.co/storage/v1/object/public/uploads/menu/1c2f291a-3199-43bd-81d8-cd5e7895cfed.png	t	0	2026-10-28 23:53:21.682+07	2026-11-03 17:03:31.267+07	0.00	f	f
29	2	4	Nasi Kulit Sambal Matah	\N	38000.00	https://obaybiymhuukucvvgdsq.supabase.co/storage/v1/object/public/uploads/menu/6157a733-c1f8-4b0e-aaba-e73327fe32a5.png	t	0	2026-10-28 23:52:43.761+07	2026-11-03 17:03:53.121+07	0.00	f	f
28	2	4	Nasi Kulit Sambal Pikoelan	\N	38000.00	https://obaybiymhuukucvvgdsq.supabase.co/storage/v1/object/public/uploads/menu/d4325060-d482-4662-8eae-d99547224156.png	t	0	2026-10-28 23:52:04.524+07	2026-11-03 17:04:01.723+07	0.00	f	f
9	2	9	Tuna Belly Bakar	Tuna belly bakar	53000.00	https://obaybiymhuukucvvgdsq.supabase.co/storage/v1/object/public/uploads/menu/002c5e0b-3b18-48ee-954b-3e07a616856c.png	t	0	2026-10-28 23:09:21.554+07	2026-11-19 13:58:28.529+07	0.00	f	f
27	2	4	Nasi Ikan Dori Sambal Matah	\N	38000.00	https://obaybiymhuukucvvgdsq.supabase.co/storage/v1/object/public/uploads/menu/054f333f-3d19-464b-8441-a2a2e540b6cb.png	t	0	2026-10-28 23:51:13.271+07	2026-11-03 17:07:56.155+07	0.00	f	f
26	2	4	Nasi Ikan Dori Sambal Pikoelan	\N	38000.00	https://obaybiymhuukucvvgdsq.supabase.co/storage/v1/object/public/uploads/menu/942da5d3-e5bb-494e-90f8-ca532a2c0951.png	t	0	2026-10-28 23:50:33.151+07	2026-11-03 17:11:08.689+07	0.00	f	f
15	2	4	Bakwan Jagung ( isi 3 Pcs)	\N	30000.00	https://obaybiymhuukucvvgdsq.supabase.co/storage/v1/object/public/uploads/menu/12916880-6810-41fb-ad49-3427d3254b13.png	t	0	2026-10-28 23:29:36.907+07	2026-11-03 17:28:15.765+07	0.00	f	f
21	2	4	Nasi Ayam Penyet Sambel Matah	\N	38000.00	https://obaybiymhuukucvvgdsq.supabase.co/storage/v1/object/public/uploads/menu/e41dbd9d-dc9b-4fe9-a352-a19817b6474f.png	t	0	2026-10-28 23:40:45.719+07	2026-11-18 15:50:00.271+07	0.00	f	f
8	2	9	Paket Nasi Rahang Tuna	paket nasi rahang tuna ( Rahang Tuna, Nasi, Kumis Kangkung, dan Sambal Pikoelan )	78000.00	https://obaybiymhuukucvvgdsq.supabase.co/storage/v1/object/public/uploads/menu/1b3a8e6f-f5f4-44a4-bccc-44167fc1081a.png	t	0	2026-10-28 23:08:19.527+07	2026-11-19 13:58:49.11+07	0.00	t	t
7	2	9	Rahang Tuna	Rahang tuna	100000.00	https://obaybiymhuukucvvgdsq.supabase.co/storage/v1/object/public/uploads/menu/52d92720-316e-4b00-9c23-a00c5be9ebf0.jpg	t	0	2026-10-28 23:06:34.276+07	2026-11-19 13:59:26.829+07	0.00	t	f
10	2	9	Sate Tuna	Sate dengan bahan daging tuna	53000.00	https://obaybiymhuukucvvgdsq.supabase.co/storage/v1/object/public/uploads/menu/aec13522-f214-4b55-a200-1c2ffc0667ac.png	t	0	2026-10-28 23:09:57.251+07	2026-11-19 14:00:07.042+07	0.00	t	f
12	2	9	Bandeng Bakar Tanpa Duri	Bandeng bakar khas pikoelan	70000.00	https://obaybiymhuukucvvgdsq.supabase.co/storage/v1/object/public/uploads/menu/2bcca085-79ef-49f1-9b70-7586daf02da1.png	t	0	2026-10-28 23:14:05.62+07	2026-11-19 14:00:57.157+07	0.00	f	f
35	2	4	Mie Godog Jawa	\N	30000.00	https://obaybiymhuukucvvgdsq.supabase.co/storage/v1/object/public/uploads/menu/d481605a-9eeb-49aa-a53a-15233e92bfed.png	t	0	2026-10-29 00:03:13.531+07	2026-10-29 00:03:13.531+07	\N	f	f
36	2	4	Bihun Godog Jawa	\N	30000.00	https://obaybiymhuukucvvgdsq.supabase.co/storage/v1/object/public/uploads/menu/ad025e7d-ecdc-4916-aa03-6c6c39eeed04.png	t	0	2026-10-29 00:03:47.192+07	2026-10-29 00:03:47.192+07	\N	f	f
40	2	4	Soto Ayam + Nasi	\N	33000.00	https://obaybiymhuukucvvgdsq.supabase.co/storage/v1/object/public/uploads/menu/fab3b866-5633-46a6-bd1b-eed2ffe2c0d3.png	t	0	2026-10-29 00:09:28.659+07	2026-10-29 00:09:28.659+07	\N	f	f
41	2	4	Capcay	\N	30000.00	https://obaybiymhuukucvvgdsq.supabase.co/storage/v1/object/public/uploads/menu/9273752c-479f-47b2-99fd-04d71a4ef854.png	t	0	2026-10-29 00:09:53.038+07	2026-10-29 00:09:53.038+07	\N	f	f
42	2	4	Capcay + Nasi	\N	38000.00	https://obaybiymhuukucvvgdsq.supabase.co/storage/v1/object/public/uploads/menu/d2fa4625-b273-4946-84b2-bc5b81c8ed2a.png	t	0	2026-10-29 00:10:23.255+07	2026-10-29 00:10:23.255+07	\N	f	f
43	2	4	Sate Ayam	\N	30000.00	https://obaybiymhuukucvvgdsq.supabase.co/storage/v1/object/public/uploads/menu/56c371c2-4acf-49c3-add4-5b3ea236ad3d.png	t	0	2026-10-29 00:11:14.594+07	2026-10-29 00:11:14.594+07	\N	f	f
44	2	4	Sate Ayam + Lontong	\N	35000.00	https://obaybiymhuukucvvgdsq.supabase.co/storage/v1/object/public/uploads/menu/4c484d1e-5987-4d6b-b01d-d82b23507629.png	t	0	2026-10-29 00:11:51.819+07	2026-10-29 00:11:51.819+07	\N	f	f
45	2	4	Sate Ayam + Nasi	\N	38000.00	https://obaybiymhuukucvvgdsq.supabase.co/storage/v1/object/public/uploads/menu/00bbca05-ff0e-4a52-b33c-f097d5f21b70.png	t	0	2026-10-29 00:12:27.197+07	2026-10-29 00:12:27.197+07	\N	f	f
46	2	4	Aneka Gorengan perPcs	Macam-macam gorengan seperti tempe goreng, tahu goreng, bakwan goreng	4000.00	https://obaybiymhuukucvvgdsq.supabase.co/storage/v1/object/public/uploads/menu/193ce1c9-08b8-4ac3-840e-502d58e00fd0.png	t	0	2026-10-29 00:13:56.492+07	2026-10-29 00:13:56.492+07	\N	f	f
47	2	4	Bakso	\N	25000.00	https://obaybiymhuukucvvgdsq.supabase.co/storage/v1/object/public/uploads/menu/6d2db1b6-7cdd-4924-a8ad-6811bcb8d355.jpg	t	0	2026-10-29 00:17:49.24+07	2026-10-29 00:17:49.24+07	\N	t	f
53	2	4	Bihun Ayam Sambal Geledek (SPECIAL)	\N	32000.00	https://obaybiymhuukucvvgdsq.supabase.co/storage/v1/object/public/uploads/menu/fc86d4cb-0261-4900-8e36-c6cfca4cb70a.png	t	0	2026-10-29 00:23:59.669+07	2026-11-03 17:19:01.08+07	0.00	f	f
54	2	4	Pangsit Goreng	\N	15000.00	https://obaybiymhuukucvvgdsq.supabase.co/storage/v1/object/public/uploads/menu/c5aa30bd-5d11-44d0-b4e3-ab90115c8cab.png	t	0	2026-10-29 00:24:35.721+07	2026-10-29 00:24:35.721+07	\N	f	f
55	2	8	ES Surga	\N	30000.00	https://obaybiymhuukucvvgdsq.supabase.co/storage/v1/object/public/uploads/menu/91939c21-be8e-4302-b7e4-d448930af25b.png	t	0	2026-10-29 00:34:27.411+07	2026-10-29 00:34:27.411+07	\N	t	t
38	2	4	Gado-gado Lontong / Nasi	\N	33000.00	https://obaybiymhuukucvvgdsq.supabase.co/storage/v1/object/public/uploads/menu/bd2122b9-c398-4361-a127-869614704e68.jpg	t	0	2026-10-29 00:08:33.072+07	2026-11-03 17:15:05.396+07	0.00	f	f
39	2	4	Soto Ayam	\N	27000.00	https://obaybiymhuukucvvgdsq.supabase.co/storage/v1/object/public/uploads/menu/0f46a7e1-41b9-4ad0-be05-67ac13c9c1f0.png	t	0	2026-10-29 00:09:04.225+07	2026-11-03 17:15:57.632+07	0.00	f	f
51	2	4	Kwetiau Ayam Sambal Geledek (SPECIAL)	\N	32000.00	https://obaybiymhuukucvvgdsq.supabase.co/storage/v1/object/public/uploads/menu/945715e0-74b9-4ae1-b28e-c8da6f4284b9.png	t	0	2026-10-29 00:22:03.353+07	2026-11-03 17:17:50.129+07	0.00	f	f
50	2	4	Kwetiau Ayam Sambal Gledek (Biasa)	\N	26000.00	https://obaybiymhuukucvvgdsq.supabase.co/storage/v1/object/public/uploads/menu/787e4abf-6f02-41a4-a542-87f15a8fd9d1.png	t	0	2026-10-29 00:21:07.153+07	2026-11-03 17:18:30.337+07	0.00	f	f
52	2	4	Bihun Ayam Sambal Geledek (Biasa)	\N	26000.00	https://obaybiymhuukucvvgdsq.supabase.co/storage/v1/object/public/uploads/menu/6c663b01-3b47-4ff7-98d7-d923ac95f693.png	t	0	2026-10-29 00:22:52.109+07	2026-11-03 17:19:15.177+07	0.00	f	f
48	2	4	Bakmi Ayam Sambal Geledek (Biasa)	\N	26000.00	https://obaybiymhuukucvvgdsq.supabase.co/storage/v1/object/public/uploads/menu/1755bf29-7a70-4e68-a459-3714d0b422e2.png	t	0	2026-10-29 00:18:51.035+07	2026-11-03 17:19:44.329+07	0.00	f	f
49	2	4	Bakmi Ayam Sambal Geledek ( SPECIAL )	\N	32000.00	https://obaybiymhuukucvvgdsq.supabase.co/storage/v1/object/public/uploads/menu/c1cf2dd8-b9e5-48cc-9bba-1ce1ab7ee570.png	t	0	2026-10-29 00:19:39.445+07	2026-11-03 17:19:56.983+07	0.00	f	f
56	2	8	ES Jangan Biarkan Daku Sendiri	\N	25000.00	https://obaybiymhuukucvvgdsq.supabase.co/storage/v1/object/public/uploads/menu/2068e71a-adba-46a4-ae6c-575e77e17465.jpg	t	0	2026-10-29 00:35:13.804+07	2026-11-03 17:20:45.481+07	0.00	f	f
64	2	8	Jus Alpukat	\N	20000.00	https://obaybiymhuukucvvgdsq.supabase.co/storage/v1/object/public/uploads/menu/7b45c8d5-d9a1-4175-96c1-9a8f3eed9eb5.jpg	t	0	2026-10-29 03:00:36.457+07	2026-11-03 17:23:33.978+07	0.00	f	f
61	2	8	Jus Belimbing	\N	20000.00	https://obaybiymhuukucvvgdsq.supabase.co/storage/v1/object/public/uploads/menu/988a2bfe-c496-41ce-9250-0d9b9bb27f85.jpg	t	0	2026-10-29 03:00:29.923+07	2026-11-03 17:23:45.211+07	0.00	f	f
65	2	8	Jus Buah Naga	\N	20000.00	https://obaybiymhuukucvvgdsq.supabase.co/storage/v1/object/public/uploads/menu/386633fb-a598-4528-bcee-cbea4bdfbdbd.jpg	t	0	2026-10-29 03:00:38.405+07	2026-11-03 17:23:55.807+07	0.00	f	f
60	2	8	Jus Jambu	\N	20000.00	https://obaybiymhuukucvvgdsq.supabase.co/storage/v1/object/public/uploads/menu/681bc2d8-98ec-43a9-a27e-85ec256d9712.jpg	t	0	2026-10-29 03:00:27.335+07	2026-11-03 17:24:11.725+07	0.00	f	f
66	2	8	Jus Mangga	\N	20000.00	https://obaybiymhuukucvvgdsq.supabase.co/storage/v1/object/public/uploads/menu/2c1d02c6-818e-42b7-a044-613eda130bd8.jpg	t	0	2026-10-29 03:00:40.417+07	2026-11-03 17:24:29.077+07	0.00	f	f
58	2	8	Jus Melon	\N	20000.00	https://obaybiymhuukucvvgdsq.supabase.co/storage/v1/object/public/uploads/menu/3b09282f-1b32-4119-89f4-24f226f86e04.jpg	t	0	2026-10-29 03:00:23.252+07	2026-11-03 17:24:41.273+07	0.00	f	f
63	2	8	Jus Sirsak	\N	20000.00	https://obaybiymhuukucvvgdsq.supabase.co/storage/v1/object/public/uploads/menu/72f6ec41-3ca1-4fa8-8c36-accda6f8b167.jpg	t	0	2026-10-29 03:00:34.555+07	2026-11-03 17:25:06.078+07	0.00	f	f
59	2	8	Jus Strawberry	\N	20000.00	https://obaybiymhuukucvvgdsq.supabase.co/storage/v1/object/public/uploads/menu/e5e983d2-92fd-4b38-9910-c76e788397ef.jpg	t	0	2026-10-29 03:00:25.239+07	2026-11-03 17:25:24.244+07	0.00	f	f
62	2	8	Jus Wortel	\N	20000.00	https://obaybiymhuukucvvgdsq.supabase.co/storage/v1/object/public/uploads/menu/4cac14bc-aa6c-4d18-a959-23b48aa6da95.jpg	t	0	2026-10-29 03:00:32.173+07	2026-11-03 17:25:41.949+07	0.00	f	f
6	2	9	Rahang Tuna Super (Diatas 1 Kg)	Rahang Super 1KG	125000.00	https://obaybiymhuukucvvgdsq.supabase.co/storage/v1/object/public/uploads/menu/313b3b8a-4bbe-4692-b4a2-642c86569659.jpg	t	0	2026-10-28 02:24:10.057+07	2026-11-19 13:59:49.226+07	0.00	t	t
69	2	8	Sari Kacang Hijau	\N	20000.00	https://obaybiymhuukucvvgdsq.supabase.co/storage/v1/object/public/uploads/menu/99a8c4af-94da-4d64-b67e-7f8dc7865a5b.jpg	t	0	2026-10-29 03:00:46.022+07	2026-10-29 03:00:46.022+07	\N	f	f
83	2	8	Air Mineral	\N	5000.00	https://obaybiymhuukucvvgdsq.supabase.co/storage/v1/object/public/uploads/menu/60a7f5a1-ad24-4cc5-8208-a83f5d29469a.jpg	t	0	2026-10-29 03:01:12.316+07	2026-10-29 03:01:12.316+07	\N	f	f
80	2	8	Es Teh Manis	\N	6000.00	https://obaybiymhuukucvvgdsq.supabase.co/storage/v1/object/public/uploads/menu/0862718b-4105-4d0b-bd06-ea1b6d30e2ec.jpg	t	0	2026-10-29 03:01:07.34+07	2026-11-03 17:21:24.15+07	0.00	f	f
81	2	8	Es Teh Tawar	\N	5000.00	https://obaybiymhuukucvvgdsq.supabase.co/storage/v1/object/public/uploads/menu/e95eb35d-e905-4a14-be57-122aa34b2d0f.jpg	t	0	2026-10-29 03:01:08.96+07	2026-11-03 17:21:33.77+07	0.00	f	f
84	2	8	Es Batu	\N	3000.00	https://obaybiymhuukucvvgdsq.supabase.co/storage/v1/object/public/uploads/menu/bb49952e-433b-43d6-9065-f1831ae86485.jpg	t	0	2026-10-29 03:01:14.312+07	2026-11-03 17:21:43.085+07	0.00	f	f
72	2	8	ES Lidah Buaya	\N	20000.00	https://obaybiymhuukucvvgdsq.supabase.co/storage/v1/object/public/uploads/menu/6096a53a-5f39-40c2-96b8-9436439426b6.jpg	t	0	2026-10-29 03:00:51.769+07	2026-11-03 17:21:54.455+07	0.00	f	f
70	2	8	Lemon Tea	\N	20000.00	https://obaybiymhuukucvvgdsq.supabase.co/storage/v1/object/public/uploads/menu/a7afe5ac-ec36-427c-8c90-ff8654227d13.jpg	t	0	2026-10-29 03:00:47.379+07	2026-11-03 17:25:56.34+07	0.00	f	f
71	2	8	ES Jeruk	\N	20000.00	https://obaybiymhuukucvvgdsq.supabase.co/storage/v1/object/public/uploads/menu/3b4c1e9e-7a5a-41f5-9c8f-a021d4c7f46a.jpg	t	0	2026-10-29 03:00:49.205+07	2026-11-19 14:02:35.36+07	0.00	f	f
75	2	8	ES Kelapa Alpukat	\N	20000.00	https://obaybiymhuukucvvgdsq.supabase.co/storage/v1/object/public/uploads/menu/580cd905-a4e9-4520-88bb-56c445a21405.jpg	t	0	2026-10-29 03:00:56.847+07	2026-10-29 03:00:56.847+07	\N	f	f
76	2	8	ES Jeruk Sonkit Kiamboy	\N	20000.00	https://obaybiymhuukucvvgdsq.supabase.co/storage/v1/object/public/uploads/menu/5aeb96f7-62ab-4c4b-9ee7-7671c3e50f13.jpg	t	0	2026-10-29 03:00:58.902+07	2026-10-29 03:00:58.902+07	\N	f	f
79	2	8	Teh Tarik	\N	15000.00	https://obaybiymhuukucvvgdsq.supabase.co/storage/v1/object/public/uploads/menu/c2fd6b3e-21bd-462e-a1ea-387bb11f81db.jpg	t	0	2026-10-29 03:01:05.109+07	2026-10-29 03:01:05.109+07	\N	f	f
37	2	4	Gado-Gado Sayur	\N	28000.00	https://obaybiymhuukucvvgdsq.supabase.co/storage/v1/object/public/uploads/menu/acf25aa8-34a0-49c3-8c13-c4e276a2eeb9.jpg	t	0	2026-10-29 00:07:57.105+07	2026-11-03 17:14:49.29+07	0.00	t	f
77	2	8	ES Jeruk Nipis	\N	20000.00	https://obaybiymhuukucvvgdsq.supabase.co/storage/v1/object/public/uploads/menu/18dd3e57-9c7d-41f8-b8f4-2df06576ca2f.jpg	t	0	2026-10-29 03:01:00.673+07	2026-11-03 17:22:57.765+07	0.00	f	f
82	2	8	Teh Tawar Hangat	\N	4000.00	https://obaybiymhuukucvvgdsq.supabase.co/storage/v1/object/public/uploads/menu/2bec9493-3f9c-45c7-92ff-fe26681a7995.jpg	t	0	2026-10-29 03:01:10.488+07	2026-11-03 17:26:36.575+07	0.00	f	f
85	2	4	Bihun Bakso	\N	30000.00	\N	t	0	2026-11-18 15:53:37.505+07	2026-11-18 15:57:32.488+07	0.00	f	f
86	2	4	Pangsit Goreng	\N	15000.00	\N	t	0	2026-11-18 15:58:29.445+07	2026-11-18 15:58:29.445+07	\N	f	f
87	2	4	Tahu Bacem	\N	5000.00	\N	t	0	2026-11-18 16:00:10.018+07	2026-11-18 16:00:10.018+07	\N	f	f
88	2	4	Tempe Bacem	\N	5000.00	\N	t	0	2026-11-18 16:00:25.526+07	2026-11-18 16:00:25.526+07	\N	f	f
89	2	8	Es Surga	\N	30000.00	\N	t	0	2026-11-18 16:01:10.696+07	2026-11-18 16:01:10.696+07	\N	f	f
91	2	8	Kopi Tubruk	\N	20000.00	\N	t	0	2026-11-18 16:03:04.165+07	2026-11-18 16:03:04.165+07	\N	f	f
92	2	10	kopi Tubruk	\N	20000.00	\N	t	0	2026-11-19 11:34:15.087+07	2026-11-19 14:03:05.312+07	0.00	f	f
93	2	10	Vietnam Drip	\N	20000.00	\N	t	0	2026-11-19 14:07:24.592+07	2026-11-19 14:07:24.592+07	\N	f	f
94	2	10	Americano (Hot)	\N	22000.00	\N	t	0	2026-11-19 14:07:56.831+07	2026-11-19 14:07:56.831+07	\N	f	f
95	2	10	Americano (Ice)	\N	25000.00	\N	t	0	2026-11-19 14:08:23.98+07	2026-11-19 14:08:35.888+07	0.00	f	f
96	2	10	Aren Latte (Hot)	\N	22000.00	\N	t	0	2026-11-19 14:21:39.896+07	2026-11-19 14:21:39.896+07	\N	f	f
97	2	10	Aren Latte(Ice)	\N	25000.00	\N	t	0	2026-11-19 14:23:48.008+07	2026-11-19 14:23:48.008+07	\N	f	f
98	2	10	Cappuccino	\N	25000.00	\N	t	0	2026-11-19 14:25:03.377+07	2026-11-19 14:25:03.377+07	\N	f	f
99	2	10	Pandan Latte(Hot)	\N	25000.00	\N	t	0	2026-11-19 14:25:52.628+07	2026-11-19 14:25:52.628+07	\N	f	f
100	2	10	Pandan Latte(Ice)	\N	28000.00	\N	t	0	2026-11-19 14:26:20.994+07	2026-11-19 14:26:20.994+07	\N	f	f
101	2	10	Caramel Latte (Hot)	\N	25000.00	\N	t	0	2026-11-19 15:30:58.989+07	2026-11-19 15:30:58.989+07	\N	f	f
103	2	10	Caramel Latte (Ice)	\N	28000.00	\N	t	0	2026-11-19 15:32:07.056+07	2026-11-19 15:32:07.056+07	\N	f	f
104	2	10	Caramel Latte (Ice)	\N	28000.00	\N	t	0	2026-11-19 15:32:38.366+07	2026-11-19 15:32:38.366+07	\N	f	f
105	2	\N	Caramel Latte (Ice)	\N	28000.00	\N	t	0	2026-11-19 15:33:08.051+07	2026-11-19 15:33:08.051+07	\N	f	f
106	2	10	Hazelnut Latte (Hot)	\N	25000.00	\N	t	0	2026-11-19 15:33:57.037+07	2026-11-19 15:33:57.037+07	\N	f	f
107	2	10	Caramel Latte (Ice)	\N	28000.00	\N	t	0	2026-11-19 15:34:48.451+07	2026-11-19 15:34:48.451+07	\N	f	f
110	2	10	Caramel Latte (Ice)	\N	28000.00	\N	t	0	2026-11-19 15:40:49.621+07	2026-11-19 15:40:49.621+07	\N	f	f
102	2	10	Caramel (Ice)	\N	28000.00	\N	t	0	2026-11-19 15:31:20.466+07	2026-11-19 15:31:20.466+07	\N	f	f
111	2	4	Ayam Kalasan (Ayam nya saja)	\N	30000.00	\N	t	0	2026-11-20 15:15:36.722+07	2026-11-20 15:15:36.722+07	\N	f	f
112	2	4	Ayam Geprek (Ayamnya saja)	\N	30000.00	\N	t	0	2026-11-20 15:16:02.043+07	2026-11-20 15:16:02.043+07	\N	f	f
113	2	4	Ikan Dori (Ikan nya Saja)	\N	30000.00	\N	t	0	2026-11-20 15:16:37.356+07	2026-11-20 15:16:37.356+07	\N	f	f
114	2	10	Vanilla Latte (Hot)	\N	25000.00	\N	t	0	2026-11-20 17:23:01.733+07	2026-11-20 17:23:01.733+07	\N	f	f
115	2	10	Vanilla Latte (Ice)	\N	28000.00	\N	t	0	2026-11-20 17:23:23.616+07	2026-11-20 17:23:23.616+07	\N	f	f
116	2	10	Caramel Latte (Hot)	\N	25000.00	\N	t	0	2026-11-20 17:24:06.125+07	2026-11-20 17:24:06.125+07	\N	f	f
117	2	10	Caramel Latte (Ice)	\N	28000.00	\N	t	0	2026-11-20 17:29:54.457+07	2026-11-20 17:29:54.457+07	\N	f	f
118	2	10	Hazelnut Latte (Hot)	\N	25000.00	\N	t	0	2026-11-20 17:31:20.482+07	2026-11-20 17:31:20.482+07	\N	f	f
119	2	10	Matcha Latte	\N	20000.00	\N	t	0	2026-11-22 15:19:20.802+07	2026-11-22 15:19:20.802+07	\N	f	f
120	2	10	Taro Latte	\N	20000.00	\N	t	0	2026-11-22 15:20:13.797+07	2026-11-22 15:20:13.797+07	\N	f	f
121	2	10	choco Milo	\N	20000.00	\N	t	0	2026-11-22 15:20:39.418+07	2026-11-22 15:20:39.418+07	\N	f	f
122	2	4	telur	\N	5000.00	\N	t	0	2026-11-22 15:21:51.917+07	2026-11-22 15:22:32.064+07	0.00	f	f
\.


--
-- Data for Name: stock_categories; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "public"."stock_categories" ("id", "tenant_id", "name", "description", "is_active", "created_at", "updated_at") FROM stdin;
1	1	Minuman	\N	t	2026-11-06 23:19:09.831+07	2026-11-06 23:19:09.831+07
2	1	Bahan Makanan	bahan untuk membuat menu	t	2026-11-07 22:07:17.559+07	2026-11-07 22:07:17.559+07
\.


--
-- Data for Name: stock_units; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "public"."stock_units" ("id", "tenant_id", "name", "symbol", "conversion_factor", "base_unit", "description", "is_active", "created_at", "updated_at") FROM stdin;
1	1	Botol	btl	1.000000	1	unit untuk botol	t	2026-11-06 23:29:25.319+07	2026-11-06 23:29:25.319+07
2	1	Liter	lt	1.000000	1	\N	t	2026-11-08 01:50:35.68+07	2026-11-08 01:50:35.68+07
\.


--
-- Data for Name: stock_items; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "public"."stock_items" ("id", "tenant_id", "category_id", "unit_id", "sku", "name", "description", "current_stock", "minimum_stock", "cost_price", "supplier", "notes", "is_active", "created_at", "updated_at") FROM stdin;
3	1	2	2	10002	Gandum	gandum	20.0000	5.0000	18000.00	\N	\N	t	2026-11-08 02:00:23.147+07	2026-11-08 16:23:01.33+07
2	1	2	2	1000000	Beras	beras harum	50.0000	10.0000	13333.33	\N	\N	t	2026-11-08 01:54:13.962+07	2026-11-08 16:43:56.584+07
5	1	2	2	\N	Bihun	\N	10.0000	2.0000	0.00	\N	\N	t	2026-11-08 17:17:04.918+07	2026-11-08 17:17:04.918+07
4	1	2	2	\N	Kacang Ijo	\N	10.0000	4.0000	10000.00	\N	\N	t	2026-11-08 02:07:19.835+07	2026-11-08 17:59:14.42+07
1	1	1	1	\N	AIr mineal	\N	0.0000	1.0000	10000.00	\N	\N	t	2026-11-06 23:30:31.863+07	2026-11-08 18:03:15.508+07
\.


--
-- Data for Name: menu_item_stocks; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "public"."menu_item_stocks" ("id", "tenant_id", "menu_item_id", "stock_item_id", "quantity_per_serving", "notes", "created_at", "updated_at") FROM stdin;
\.


--
-- Data for Name: order_items; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "public"."order_items" ("id", "order_id", "menu_item_id", "item_name", "price", "quantity", "subtotal", "notes", "created_at", "updated_at") FROM stdin;
139	90	1	Nasi Uduk	12000.00	1	12000.00	\N	2026-11-09 23:21:29.14+07	2026-11-09 23:21:29.14+07
140	90	2	Teh Manis Dingin	7500.00	1	7500.00	\N	2026-11-09 23:21:29.14+07	2026-11-09 23:21:29.14+07
143	92	1	Nasi Uduk	12000.00	1	12000.00	\N	2026-11-11 01:39:21.382+07	2026-11-11 01:39:21.382+07
144	92	2	Teh Manis Dingin	7500.00	1	7500.00	\N	2026-11-11 01:39:21.382+07	2026-11-11 01:39:21.382+07
148	96	46	Aneka Gorengan perPcs	4000.00	2	8000.00	\N	2026-11-12 19:20:34.507+07	2026-11-12 19:20:34.507+07
150	98	83	Air Mineral	5000.00	1	5000.00	\N	2026-11-12 19:23:01.926+07	2026-11-12 19:23:01.926+07
151	99	83	Air Mineral	5000.00	1	5000.00	\N	2026-11-12 19:25:16.497+07	2026-11-12 19:25:16.497+07
153	101	83	Air Mineral	5000.00	1	5000.00	\N	2026-11-13 10:10:41.379+07	2026-11-13 10:10:41.379+07
155	103	32	Bakmi Goreng	35000.00	2	70000.00	\N	2026-11-13 10:27:35.018+07	2026-11-13 10:27:35.018+07
157	105	48	Bakmi Ayam Sambal Geledek (Biasa)	26000.00	1	26000.00	\N	2026-11-13 10:38:55.015+07	2026-11-13 10:38:55.015+07
159	107	83	Air Mineral	5000.00	1	5000.00	\N	2026-11-18 16:06:58.225+07	2026-11-18 16:06:58.225+07
161	109	40	Soto Ayam + Nasi	33000.00	1	33000.00	\N	2026-11-18 17:53:46.404+07	2026-11-18 17:53:46.404+07
162	109	71	ES Jeruk Hangat	20000.00	1	20000.00	\N	2026-11-18 17:53:46.404+07	2026-11-18 17:53:46.404+07
183	117	12	Bandeng Bakar Tanpa Duri	70000.00	1	70000.00	\N	2026-11-18 18:25:59.387+07	2026-11-18 18:25:59.387+07
184	117	33	Bihun Goreng	35000.00	1	35000.00	\N	2026-11-18 18:25:59.387+07	2026-11-18 18:25:59.387+07
185	117	83	Air Mineral	5000.00	1	5000.00	\N	2026-11-18 18:25:59.387+07	2026-11-18 18:25:59.387+07
188	119	7	Rahang Tuna	100000.00	1	100000.00	\N	2026-11-18 18:53:59.989+07	2026-11-18 18:53:59.989+07
189	119	16	Nasi Putih	9000.00	2	18000.00	\N	2026-11-18 18:53:59.989+07	2026-11-18 18:53:59.989+07
190	119	14	Cah Kangkung	25000.00	1	25000.00	\N	2026-11-18 18:53:59.989+07	2026-11-18 18:53:59.989+07
191	119	15	Bakwan Jagung ( isi 3 Pcs)	30000.00	1	30000.00	\N	2026-11-18 18:53:59.989+07	2026-11-18 18:53:59.989+07
192	119	77	ES Jeruk Nipis	20000.00	1	20000.00	\N	2026-11-18 18:53:59.989+07	2026-11-18 18:53:59.989+07
193	119	63	Jus Sirsak	20000.00	1	20000.00	\N	2026-11-18 18:53:59.989+07	2026-11-18 18:53:59.989+07
201	122	19	Nasi Ayam Kalasan	38000.00	2	76000.00	\N	2026-11-18 19:23:40.13+07	2026-11-18 19:23:40.13+07
202	122	15	Bakwan Jagung ( isi 3 Pcs)	30000.00	3	90000.00	\N	2026-11-18 19:23:40.13+07	2026-11-18 19:23:40.13+07
212	127	10	Sate Tuna	53000.00	1	53000.00	\N	2026-11-18 19:44:44.668+07	2026-11-18 19:44:44.668+07
213	127	8	Paket Nasi Rahang Tuna	78000.00	1	78000.00	\N	2026-11-18 19:44:44.668+07	2026-11-18 19:44:44.668+07
214	127	71	ES Jeruk Hangat	20000.00	1	20000.00	\N	2026-11-18 19:44:44.668+07	2026-11-18 19:44:44.668+07
215	127	65	Jus Buah Naga	20000.00	1	20000.00	\N	2026-11-18 19:44:44.668+07	2026-11-18 19:44:44.668+07
220	130	15	Bakwan Jagung ( isi 3 Pcs)	30000.00	1	30000.00	\N	2026-11-18 20:03:35.623+07	2026-11-18 20:03:35.623+07
221	130	31	Kwetiau Goreng Belacan	35000.00	1	35000.00	\N	2026-11-18 20:03:35.623+07	2026-11-18 20:03:35.623+07
222	131	13	Nasi Goreng tuna	38000.00	1	38000.00	\N	2026-11-18 20:05:34.941+07	2026-11-18 20:05:34.941+07
223	132	83	Air Mineral	5000.00	1	5000.00	\N	2026-11-18 20:06:45.372+07	2026-11-18 20:06:45.372+07
224	133	83	Air Mineral	5000.00	1	5000.00	\N	2026-11-18 20:07:13.068+07	2026-11-18 20:07:13.068+07
225	134	34	Kwetiau Godog Jawa	30000.00	1	30000.00	\N	2026-11-18 20:09:41.684+07	2026-11-18 20:09:41.684+07
228	136	40	Soto Ayam + Nasi	33000.00	1	33000.00	\N	2026-11-19 12:07:31.378+07	2026-11-19 12:07:31.378+07
229	136	34	Kwetiau Godog Jawa	30000.00	1	30000.00	\N	2026-11-19 12:07:31.378+07	2026-11-19 12:07:31.378+07
230	136	21	Nasi Ayam Penyet Sambel Matah	38000.00	1	38000.00	\N	2026-11-19 12:07:31.378+07	2026-11-19 12:07:31.378+07
231	136	81	Es Teh Tawar	5000.00	1	5000.00	\N	2026-11-19 12:07:31.378+07	2026-11-19 12:07:31.378+07
232	136	35	Mie Godog Jawa	30000.00	1	30000.00	\N	2026-11-19 12:07:31.378+07	2026-11-19 12:07:31.378+07
233	136	39	Soto Ayam	27000.00	2	54000.00	\N	2026-11-19 12:07:31.378+07	2026-11-19 12:07:31.378+07
234	137	39	Soto Ayam	27000.00	1	27000.00	\N	2026-11-19 12:11:04.131+07	2026-11-19 12:11:04.131+07
235	137	40	Soto Ayam + Nasi	33000.00	1	33000.00	\N	2026-11-19 12:11:04.131+07	2026-11-19 12:11:04.131+07
236	137	21	Nasi Ayam Penyet Sambel Matah	38000.00	1	38000.00	\N	2026-11-19 12:11:04.131+07	2026-11-19 12:11:04.131+07
237	137	34	Kwetiau Godog Jawa	30000.00	1	30000.00	\N	2026-11-19 12:11:04.131+07	2026-11-19 12:11:04.131+07
238	137	35	Mie Godog Jawa	30000.00	1	30000.00	\N	2026-11-19 12:11:04.131+07	2026-11-19 12:11:04.131+07
239	137	81	Es Teh Tawar	5000.00	1	5000.00	\N	2026-11-19 12:11:04.131+07	2026-11-19 12:11:04.131+07
241	139	46	Aneka Gorengan perPcs	4000.00	2	8000.00	\N	2026-11-19 12:19:40.916+07	2026-11-19 12:19:40.916+07
242	139	13	Nasi Goreng tuna	38000.00	1	38000.00	\N	2026-11-19 12:19:40.916+07	2026-11-19 12:19:40.916+07
243	139	82	Teh Tawar Hangat	4000.00	1	4000.00	\N	2026-11-19 12:19:40.916+07	2026-11-19 12:19:40.916+07
254	141	24	Nasi Goreng + Kecombrang	35000.00	1	35000.00	\N	2026-11-19 12:30:38.345+07	2026-11-19 12:30:38.345+07
255	141	13	Nasi Goreng tuna	38000.00	1	38000.00	\N	2026-11-19 12:30:38.345+07	2026-11-19 12:30:38.345+07
256	141	7	Rahang Tuna	100000.00	1	100000.00	\N	2026-11-19 12:30:38.345+07	2026-11-19 12:30:38.345+07
257	141	82	Teh Tawar Hangat	4000.00	1	4000.00	\N	2026-11-19 12:30:38.345+07	2026-11-19 12:30:38.345+07
258	141	81	Es Teh Tawar	5000.00	1	5000.00	\N	2026-11-19 12:30:38.345+07	2026-11-19 12:30:38.345+07
259	141	15	Bakwan Jagung ( isi 3 Pcs)	30000.00	1	30000.00	\N	2026-11-19 12:30:38.345+07	2026-11-19 12:30:38.345+07
261	143	30	Nasi Sarang Ayam	38000.00	1	38000.00	\N	2026-11-19 17:05:07.568+07	2026-11-19 17:05:07.568+07
262	143	56	ES Jangan Biarkan Daku Sendiri	25000.00	1	25000.00	\N	2026-11-19 17:05:07.568+07	2026-11-19 17:05:07.568+07
265	144	83	Air Mineral	5000.00	2	10000.00	\N	2026-11-19 17:15:47.036+07	2026-11-19 17:15:47.036+07
266	144	80	Es Teh Manis	6000.00	1	6000.00	\N	2026-11-19 17:15:47.036+07	2026-11-19 17:15:47.036+07
267	144	12	Bandeng Bakar Tanpa Duri	70000.00	1	70000.00	\N	2026-11-19 17:15:47.036+07	2026-11-19 17:15:47.036+07
268	144	14	Cah Kangkung	25000.00	1	25000.00	\N	2026-11-19 17:15:47.036+07	2026-11-19 17:15:47.036+07
269	144	16	Nasi Putih	9000.00	1	9000.00	\N	2026-11-19 17:15:47.036+07	2026-11-19 17:15:47.036+07
270	145	24	Nasi Goreng + Kecombrang	35000.00	1	35000.00	\N	2026-11-19 18:11:51.654+07	2026-11-19 18:11:51.654+07
271	145	80	Es Teh Manis	6000.00	1	6000.00	\N	2026-11-19 18:11:51.654+07	2026-11-19 18:11:51.654+07
272	146	37	Gado-Gado Sayur	28000.00	1	28000.00	\N	2026-11-19 18:12:38.419+07	2026-11-19 18:12:38.419+07
273	147	15	Bakwan Jagung ( isi 3 Pcs)	30000.00	1	30000.00	\N	2026-11-19 18:41:41.187+07	2026-11-19 18:41:41.187+07
274	147	21	Nasi Ayam Penyet Sambel Matah	38000.00	1	38000.00	\N	2026-11-19 18:41:41.187+07	2026-11-19 18:41:41.187+07
275	147	83	Air Mineral	5000.00	1	5000.00	\N	2026-11-19 18:41:41.187+07	2026-11-19 18:41:41.187+07
276	147	80	Es Teh Manis	6000.00	1	6000.00	\N	2026-11-19 18:41:41.187+07	2026-11-19 18:41:41.187+07
277	147	12	Bandeng Bakar Tanpa Duri	70000.00	1	70000.00	\N	2026-11-19 18:41:41.187+07	2026-11-19 18:41:41.187+07
278	147	16	Nasi Putih	9000.00	1	9000.00	\N	2026-11-19 18:41:41.187+07	2026-11-19 18:41:41.187+07
279	147	14	Cah Kangkung	25000.00	1	25000.00	\N	2026-11-19 18:41:41.187+07	2026-11-19 18:41:41.187+07
280	148	49	Bakmi Ayam Sambal Geledek ( SPECIAL )	32000.00	1	32000.00	\N	2026-11-19 18:52:28.747+07	2026-11-19 18:52:28.747+07
281	149	49	Bakmi Ayam Sambal Geledek ( SPECIAL )	32000.00	1	32000.00	\N	2026-11-19 18:53:16.485+07	2026-11-19 18:53:16.485+07
282	150	9	Tuna Belly Bakar	53000.00	1	53000.00	\N	2026-11-19 18:55:00.696+07	2026-11-19 18:55:00.696+07
283	151	12	Bandeng Bakar Tanpa Duri	70000.00	1	70000.00	\N	2026-11-19 19:08:19.771+07	2026-11-19 19:08:19.771+07
284	151	15	Bakwan Jagung ( isi 3 Pcs)	30000.00	1	30000.00	\N	2026-11-19 19:08:19.771+07	2026-11-19 19:08:19.771+07
285	151	37	Gado-Gado Sayur	28000.00	1	28000.00	\N	2026-11-19 19:08:19.771+07	2026-11-19 19:08:19.771+07
286	151	39	Soto Ayam	27000.00	1	27000.00	\N	2026-11-19 19:08:19.771+07	2026-11-19 19:08:19.771+07
141	91	83	Air Mineral	5000.00	1	5000.00	\N	2026-11-10 13:15:05.334+07	2026-11-10 13:15:05.334+07
142	91	46	Aneka Gorengan perPcs	4000.00	1	4000.00	\N	2026-11-10 13:15:05.334+07	2026-11-10 13:15:05.334+07
145	93	83	Air Mineral	5000.00	3	15000.00	\N	2026-11-12 19:17:53.236+07	2026-11-12 19:17:53.236+07
146	94	83	Air Mineral	5000.00	1	5000.00	\N	2026-11-12 19:18:34.545+07	2026-11-12 19:18:34.545+07
147	95	49	Bakmi Ayam Sambal Geledek ( SPECIAL )	32000.00	1	32000.00	\N	2026-11-12 19:19:07.377+07	2026-11-12 19:19:07.377+07
149	97	83	Air Mineral	5000.00	2	10000.00	\N	2026-11-12 19:21:37.199+07	2026-11-12 19:21:37.199+07
152	100	4	Bihun Goreng	11000.00	1	11000.00	\N	2026-11-12 21:47:45.946+07	2026-11-12 21:47:45.946+07
154	102	32	Bakmi Goreng	35000.00	1	35000.00	\N	2026-11-13 10:15:50.809+07	2026-11-13 10:15:50.809+07
156	104	32	Bakmi Goreng	35000.00	2	70000.00	\N	2026-11-13 10:29:07.605+07	2026-11-13 10:29:07.605+07
158	106	83	Air Mineral	5000.00	1	5000.00	\N	2026-11-18 15:43:26.691+07	2026-11-18 15:43:26.691+07
160	108	40	Soto Ayam + Nasi	33000.00	1	33000.00	\N	2026-11-18 17:52:04.57+07	2026-11-18 17:52:04.57+07
163	110	47	Bakso	25000.00	3	75000.00	\N	2026-11-18 17:56:35.532+07	2026-11-18 17:56:35.532+07
164	110	56	ES Jangan Biarkan Daku Sendiri	25000.00	3	75000.00	\N	2026-11-18 17:56:35.532+07	2026-11-18 17:56:35.532+07
165	110	13	Nasi Goreng tuna	38000.00	2	76000.00	\N	2026-11-18 17:56:35.532+07	2026-11-18 17:56:35.532+07
166	110	15	Bakwan Jagung ( isi 3 Pcs)	30000.00	2	60000.00	\N	2026-11-18 17:56:35.532+07	2026-11-18 17:56:35.532+07
167	110	46	Aneka Gorengan perPcs	4000.00	4	16000.00	\N	2026-11-18 17:56:35.532+07	2026-11-18 17:56:35.532+07
168	110	10	Sate Tuna	53000.00	1	53000.00	\N	2026-11-18 17:56:35.532+07	2026-11-18 17:56:35.532+07
169	110	71	ES Jeruk Hangat	20000.00	2	40000.00	\N	2026-11-18 17:56:35.532+07	2026-11-18 17:56:35.532+07
170	111	48	Bakmi Ayam Sambal Geledek (Biasa)	26000.00	1	26000.00	\N	2026-11-18 18:01:50.956+07	2026-11-18 18:01:50.956+07
171	111	36	Bihun Godog Jawa	30000.00	2	60000.00	\N	2026-11-18 18:01:50.956+07	2026-11-18 18:01:50.956+07
172	112	83	Air Mineral	5000.00	1	5000.00	\N	2026-11-18 18:11:01.44+07	2026-11-18 18:11:01.44+07
173	113	40	Soto Ayam + Nasi	33000.00	1	33000.00	\N	2026-11-18 18:13:30.153+07	2026-11-18 18:13:30.153+07
174	113	21	Nasi Ayam Penyet Sambel Matah	38000.00	1	38000.00	\N	2026-11-18 18:13:30.153+07	2026-11-18 18:13:30.153+07
175	114	31	Kwetiau Goreng Belacan	35000.00	1	35000.00	\N	2026-11-18 18:14:51.723+07	2026-11-18 18:14:51.723+07
176	115	81	Es Teh Tawar	5000.00	1	5000.00	\N	2026-11-18 18:17:44.084+07	2026-11-18 18:17:44.084+07
177	115	21	Nasi Ayam Penyet Sambel Matah	38000.00	1	38000.00	\N	2026-11-18 18:17:44.084+07	2026-11-18 18:17:44.084+07
178	115	40	Soto Ayam + Nasi	33000.00	1	33000.00	\N	2026-11-18 18:17:44.084+07	2026-11-18 18:17:44.084+07
179	116	15	Bakwan Jagung ( isi 3 Pcs)	30000.00	1	30000.00	\N	2026-11-18 18:19:51.036+07	2026-11-18 18:19:51.036+07
180	116	71	ES Jeruk Hangat	20000.00	1	20000.00	\N	2026-11-18 18:19:51.036+07	2026-11-18 18:19:51.036+07
181	116	40	Soto Ayam + Nasi	33000.00	1	33000.00	\N	2026-11-18 18:19:51.036+07	2026-11-18 18:19:51.036+07
182	116	31	Kwetiau Goreng Belacan	35000.00	1	35000.00	\N	2026-11-18 18:19:51.036+07	2026-11-18 18:19:51.036+07
186	118	89	Es Surga	30000.00	1	30000.00	\N	2026-11-18 18:47:01.29+07	2026-11-18 18:47:01.29+07
187	118	47	Bakso	25000.00	1	25000.00	\N	2026-11-18 18:47:01.29+07	2026-11-18 18:47:01.29+07
194	120	33	Bihun Goreng	35000.00	1	35000.00	\N	2026-11-18 18:59:00.541+07	2026-11-18 18:59:00.541+07
195	120	13	Nasi Goreng tuna	38000.00	1	38000.00	\N	2026-11-18 18:59:00.541+07	2026-11-18 18:59:00.541+07
196	120	83	Air Mineral	5000.00	1	5000.00	\N	2026-11-18 18:59:00.541+07	2026-11-18 18:59:00.541+07
197	120	64	Jus Alpukat	20000.00	1	20000.00	\N	2026-11-18 18:59:00.541+07	2026-11-18 18:59:00.541+07
198	121	33	Bihun Goreng	35000.00	1	35000.00	\N	2026-11-18 19:00:28.733+07	2026-11-18 19:00:28.733+07
199	121	16	Nasi Putih	9000.00	1	9000.00	\N	2026-11-18 19:00:28.733+07	2026-11-18 19:00:28.733+07
200	121	12	Bandeng Bakar Tanpa Duri	70000.00	1	70000.00	\N	2026-11-18 19:00:28.733+07	2026-11-18 19:00:28.733+07
203	123	19	Nasi Ayam Kalasan	38000.00	2	76000.00	\N	2026-11-18 19:29:23.785+07	2026-11-18 19:29:23.785+07
204	123	14	Cah Kangkung	25000.00	1	25000.00	\N	2026-11-18 19:29:23.785+07	2026-11-18 19:29:23.785+07
205	123	15	Bakwan Jagung ( isi 3 Pcs)	30000.00	1	30000.00	\N	2026-11-18 19:29:23.785+07	2026-11-18 19:29:23.785+07
206	123	80	Es Teh Manis	6000.00	1	6000.00	\N	2026-11-18 19:29:23.785+07	2026-11-18 19:29:23.785+07
207	124	16	Nasi Putih	9000.00	1	9000.00	\N	2026-11-18 19:30:25.686+07	2026-11-18 19:30:25.686+07
208	125	16	Nasi Putih	9000.00	1	9000.00	\N	2026-11-18 19:31:36.629+07	2026-11-18 19:31:36.629+07
209	126	31	Kwetiau Goreng Belacan	35000.00	1	35000.00	\N	2026-11-18 19:35:51.902+07	2026-11-18 19:35:51.902+07
129	83	1	Nasi Uduk	12000.00	1	12000.00	\N	2026-10-31 18:50:00.22+07	2026-10-31 18:50:00.22+07
130	84	1	Nasi Uduk	12000.00	1	12000.00	\N	2026-11-01 21:52:52.308+07	2026-11-01 21:52:52.308+07
131	84	2	Teh Manis Dingin	7500.00	1	7500.00	\N	2026-11-01 21:52:52.308+07	2026-11-01 21:52:52.308+07
132	85	83	Air Mineral	5000.00	1	5000.00	\N	2026-11-03 16:36:13.366+07	2026-11-03 16:36:13.366+07
133	86	49	Bakmi Ayam Sambal Geledek ( SPECIAL )	30000.00	1	30000.00	\N	2026-11-03 16:39:56.567+07	2026-11-03 16:39:56.567+07
134	87	83	Air Mineral	5000.00	1	5000.00	\N	2026-11-03 16:45:33.086+07	2026-11-03 16:45:33.086+07
136	89	1	Nasi Uduk	12000.00	1	12000.00	\N	2026-11-04 00:29:39.27+07	2026-11-04 00:29:39.27+07
137	89	2	Teh Manis Dingin	7500.00	2	15000.00	\N	2026-11-04 00:29:39.27+07	2026-11-04 00:29:39.27+07
135	88	\N	Gado-gado	15000.00	1	15000.00	\N	2026-11-03 22:41:46.864+07	2026-11-03 22:41:46.864+07
138	89	\N	Gado-gado	15000.00	1	15000.00	\N	2026-11-04 00:29:39.27+07	2026-11-04 00:29:39.27+07
210	126	25	Nasi Goreng Merah	35000.00	1	35000.00	\N	2026-11-18 19:35:51.902+07	2026-11-18 19:35:51.902+07
211	126	71	ES Jeruk Hangat	20000.00	1	20000.00	\N	2026-11-18 19:35:51.902+07	2026-11-18 19:35:51.902+07
216	128	15	Bakwan Jagung ( isi 3 Pcs)	30000.00	1	30000.00	\N	2026-11-18 19:59:30.09+07	2026-11-18 19:59:30.09+07
217	128	31	Kwetiau Goreng Belacan	35000.00	1	35000.00	\N	2026-11-18 19:59:30.09+07	2026-11-18 19:59:30.09+07
218	129	15	Bakwan Jagung ( isi 3 Pcs)	30000.00	1	30000.00	\N	2026-11-18 20:00:30.853+07	2026-11-18 20:00:30.853+07
219	129	31	Kwetiau Goreng Belacan	35000.00	1	35000.00	\N	2026-11-18 20:00:30.853+07	2026-11-18 20:00:30.853+07
226	135	46	Aneka Gorengan perPcs	4000.00	1	4000.00	\N	2026-11-19 11:15:20.941+07	2026-11-19 11:15:20.941+07
227	135	83	Air Mineral	5000.00	1	5000.00	\N	2026-11-19 11:15:20.941+07	2026-11-19 11:15:20.941+07
240	138	15	Bakwan Jagung ( isi 3 Pcs)	30000.00	1	30000.00	\N	2026-11-19 12:15:19.361+07	2026-11-19 12:15:19.361+07
244	140	7	Rahang Tuna	100000.00	1	100000.00	\N	2026-11-19 12:27:16.76+07	2026-11-19 12:27:16.76+07
245	140	12	Bandeng Bakar Tanpa Duri	70000.00	1	70000.00	\N	2026-11-19 12:27:16.76+07	2026-11-19 12:27:16.76+07
246	140	14	Cah Kangkung	25000.00	1	25000.00	\N	2026-11-19 12:27:16.76+07	2026-11-19 12:27:16.76+07
247	140	87	Tahu Bacem	5000.00	1	5000.00	\N	2026-11-19 12:27:16.76+07	2026-11-19 12:27:16.76+07
248	140	15	Bakwan Jagung ( isi 3 Pcs)	30000.00	2	60000.00	\N	2026-11-19 12:27:16.76+07	2026-11-19 12:27:16.76+07
249	140	16	Nasi Putih	9000.00	5	45000.00	\N	2026-11-19 12:27:16.76+07	2026-11-19 12:27:16.76+07
250	140	37	Gado-Gado Sayur	28000.00	1	28000.00	\N	2026-11-19 12:27:16.76+07	2026-11-19 12:27:16.76+07
251	140	65	Jus Buah Naga	20000.00	1	20000.00	\N	2026-11-19 12:27:16.76+07	2026-11-19 12:27:16.76+07
252	140	83	Air Mineral	5000.00	2	10000.00	\N	2026-11-19 12:27:16.76+07	2026-11-19 12:27:16.76+07
253	140	81	Es Teh Tawar	5000.00	2	10000.00	\N	2026-11-19 12:27:16.76+07	2026-11-19 12:27:16.76+07
260	142	83	Air Mineral	5000.00	1	5000.00	\N	2026-11-19 13:24:26.072+07	2026-11-19 13:24:26.072+07
263	144	40	Soto Ayam + Nasi	33000.00	1	33000.00	\N	2026-11-19 17:15:47.036+07	2026-11-19 17:15:47.036+07
264	144	24	Nasi Goreng + Kecombrang	35000.00	1	35000.00	\N	2026-11-19 17:15:47.036+07	2026-11-19 17:15:47.036+07
287	151	82	Teh Tawar Hangat	4000.00	1	4000.00	\N	2026-11-19 19:08:19.771+07	2026-11-19 19:08:19.771+07
288	151	83	Air Mineral	5000.00	1	5000.00	\N	2026-11-19 19:08:19.771+07	2026-11-19 19:08:19.771+07
289	151	13	Nasi Goreng tuna	38000.00	1	38000.00	\N	2026-11-19 19:08:19.771+07	2026-11-19 19:08:19.771+07
290	151	80	Es Teh Manis	6000.00	1	6000.00	\N	2026-11-19 19:08:19.771+07	2026-11-19 19:08:19.771+07
291	151	16	Nasi Putih	9000.00	2	18000.00	\N	2026-11-19 19:08:19.771+07	2026-11-19 19:08:19.771+07
292	152	13	Nasi Goreng tuna	38000.00	1	38000.00	\N	2026-11-19 19:15:23.374+07	2026-11-19 19:15:23.374+07
293	152	66	Jus Mangga	20000.00	1	20000.00	\N	2026-11-19 19:15:23.374+07	2026-11-19 19:15:23.374+07
294	152	15	Bakwan Jagung ( isi 3 Pcs)	30000.00	1	30000.00	\N	2026-11-19 19:15:23.374+07	2026-11-19 19:15:23.374+07
295	153	13	Nasi Goreng tuna	38000.00	1	38000.00	\N	2026-11-19 19:27:59.801+07	2026-11-19 19:27:59.801+07
296	154	13	Nasi Goreng tuna	38000.00	1	38000.00	\N	2026-11-19 19:28:25.342+07	2026-11-19 19:28:25.342+07
297	155	13	Nasi Goreng tuna	38000.00	1	38000.00	\N	2026-11-19 19:31:40.559+07	2026-11-19 19:31:40.559+07
298	155	59	Jus Strawberry	20000.00	1	20000.00	\N	2026-11-19 19:31:40.559+07	2026-11-19 19:31:40.559+07
299	156	24	Nasi Goreng + Kecombrang	35000.00	1	35000.00	\N	2026-11-19 19:38:35.059+07	2026-11-19 19:38:35.059+07
300	157	12	Bandeng Bakar Tanpa Duri	70000.00	1	70000.00	\N	2026-11-19 19:42:54.751+07	2026-11-19 19:42:54.751+07
301	158	12	Bandeng Bakar Tanpa Duri	70000.00	1	70000.00	\N	2026-11-19 19:44:10.138+07	2026-11-19 19:44:10.138+07
302	159	35	Mie Godog Jawa	30000.00	1	30000.00	\N	2026-11-19 19:46:52.883+07	2026-11-19 19:46:52.883+07
303	159	49	Bakmi Ayam Sambal Geledek ( SPECIAL )	32000.00	1	32000.00	\N	2026-11-19 19:46:52.883+07	2026-11-19 19:46:52.883+07
304	159	86	Pangsit Goreng	15000.00	1	15000.00	\N	2026-11-19 19:46:52.883+07	2026-11-19 19:46:52.883+07
305	159	80	Es Teh Manis	6000.00	1	6000.00	\N	2026-11-19 19:46:52.883+07	2026-11-19 19:46:52.883+07
306	159	75	ES Kelapa Alpukat	20000.00	1	20000.00	\N	2026-11-19 19:46:52.883+07	2026-11-19 19:46:52.883+07
307	160	35	Mie Godog Jawa	30000.00	1	30000.00	\N	2026-11-19 19:48:16.229+07	2026-11-19 19:48:16.229+07
308	160	49	Bakmi Ayam Sambal Geledek ( SPECIAL )	32000.00	1	32000.00	\N	2026-11-19 19:48:16.229+07	2026-11-19 19:48:16.229+07
309	160	86	Pangsit Goreng	15000.00	1	15000.00	\N	2026-11-19 19:48:16.229+07	2026-11-19 19:48:16.229+07
310	160	80	Es Teh Manis	6000.00	1	6000.00	\N	2026-11-19 19:48:16.229+07	2026-11-19 19:48:16.229+07
311	160	64	Jus Alpukat	20000.00	1	20000.00	\N	2026-11-19 19:48:16.229+07	2026-11-19 19:48:16.229+07
312	160	12	Bandeng Bakar Tanpa Duri	70000.00	1	70000.00	\N	2026-11-19 19:48:16.229+07	2026-11-19 19:48:16.229+07
313	161	33	Bihun Goreng	35000.00	2	70000.00	\N	2026-11-19 21:25:44.186+07	2026-11-19 21:25:44.186+07
314	161	16	Nasi Putih	9000.00	1	9000.00	\N	2026-11-19 21:25:44.186+07	2026-11-19 21:25:44.186+07
315	161	86	Pangsit Goreng	15000.00	2	30000.00	\N	2026-11-19 21:25:44.186+07	2026-11-19 21:25:44.186+07
316	161	89	Es Surga	30000.00	2	60000.00	\N	2026-11-19 21:25:44.186+07	2026-11-19 21:25:44.186+07
317	162	7	Rahang Tuna	100000.00	3	300000.00	\N	2026-11-19 21:41:38.513+07	2026-11-19 21:41:38.513+07
318	162	12	Bandeng Bakar Tanpa Duri	70000.00	3	210000.00	\N	2026-11-19 21:41:38.513+07	2026-11-19 21:41:38.513+07
319	162	15	Bakwan Jagung ( isi 3 Pcs)	30000.00	3	90000.00	\N	2026-11-19 21:41:38.513+07	2026-11-19 21:41:38.513+07
320	162	14	Cah Kangkung	25000.00	2	50000.00	\N	2026-11-19 21:41:38.513+07	2026-11-19 21:41:38.513+07
321	162	32	Bakmi Goreng	35000.00	1	35000.00	\N	2026-11-19 21:41:38.513+07	2026-11-19 21:41:38.513+07
322	162	13	Nasi Goreng tuna	38000.00	1	38000.00	\N	2026-11-19 21:41:38.513+07	2026-11-19 21:41:38.513+07
323	162	31	Kwetiau Goreng Belacan	35000.00	1	35000.00	\N	2026-11-19 21:41:38.513+07	2026-11-19 21:41:38.513+07
324	162	41	Capcay	30000.00	2	60000.00	\N	2026-11-19 21:41:38.513+07	2026-11-19 21:41:38.513+07
325	162	16	Nasi Putih	9000.00	9	81000.00	\N	2026-11-19 21:41:38.513+07	2026-11-19 21:41:38.513+07
326	162	27	Nasi Ikan Dori Sambal Matah	38000.00	1	38000.00	\N	2026-11-19 21:41:38.513+07	2026-11-19 21:41:38.513+07
327	162	80	Es Teh Manis	6000.00	1	6000.00	\N	2026-11-19 21:41:38.513+07	2026-11-19 21:41:38.513+07
328	162	81	Es Teh Tawar	5000.00	2	10000.00	\N	2026-11-19 21:41:38.513+07	2026-11-19 21:41:38.513+07
329	162	82	Teh Tawar Hangat	4000.00	5	20000.00	\N	2026-11-19 21:41:38.513+07	2026-11-19 21:41:38.513+07
330	162	71	ES Jeruk	20000.00	1	20000.00	\N	2026-11-19 21:41:38.513+07	2026-11-19 21:41:38.513+07
331	162	83	Air Mineral	5000.00	1	5000.00	\N	2026-11-19 21:41:38.513+07	2026-11-19 21:41:38.513+07
332	162	56	ES Jangan Biarkan Daku Sendiri	25000.00	1	25000.00	\N	2026-11-19 21:41:38.513+07	2026-11-19 21:41:38.513+07
333	162	89	Es Surga	30000.00	1	30000.00	\N	2026-11-19 21:41:38.513+07	2026-11-19 21:41:38.513+07
334	163	39	Soto Ayam	27000.00	1	27000.00	\N	2026-11-19 21:42:26.13+07	2026-11-19 21:42:26.13+07
335	163	7	Rahang Tuna	100000.00	1	100000.00	\N	2026-11-19 21:42:26.13+07	2026-11-19 21:42:26.13+07
336	163	14	Cah Kangkung	25000.00	1	25000.00	\N	2026-11-19 21:42:26.13+07	2026-11-19 21:42:26.13+07
337	164	85	Bihun Bakso	30000.00	1	30000.00	\N	2026-11-19 21:47:11.501+07	2026-11-19 21:47:11.501+07
338	164	19	Nasi Ayam Kalasan	38000.00	1	38000.00	\N	2026-11-19 21:47:11.501+07	2026-11-19 21:47:11.501+07
339	164	83	Air Mineral	5000.00	1	5000.00	\N	2026-11-19 21:47:11.501+07	2026-11-19 21:47:11.501+07
340	164	80	Es Teh Manis	6000.00	1	6000.00	\N	2026-11-19 21:47:11.501+07	2026-11-19 21:47:11.501+07
341	165	50	Kwetiau Ayam Sambal Gledek (Biasa)	26000.00	1	26000.00	\N	2026-11-20 11:21:35.352+07	2026-11-20 11:21:35.352+07
342	165	41	Capcay	30000.00	1	30000.00	\N	2026-11-20 11:21:35.352+07	2026-11-20 11:21:35.352+07
343	166	13	Nasi Goreng tuna	38000.00	1	38000.00	\N	2026-11-20 11:50:42.075+07	2026-11-20 11:50:42.075+07
344	167	13	Nasi Goreng tuna	38000.00	1	38000.00	\N	2026-11-20 11:58:45.354+07	2026-11-20 11:58:45.354+07
345	168	47	Bakso	25000.00	1	25000.00	\N	2026-11-20 12:18:29.048+07	2026-11-20 12:18:29.048+07
346	168	46	Aneka Gorengan perPcs	4000.00	2	8000.00	\N	2026-11-20 12:18:29.048+07	2026-11-20 12:18:29.048+07
347	169	66	Jus Mangga	20000.00	1	20000.00	\N	2026-11-20 12:49:03.843+07	2026-11-20 12:49:03.843+07
348	170	32	Bakmi Goreng	35000.00	1	35000.00	\N	2026-11-20 12:51:02.393+07	2026-11-20 12:51:02.393+07
349	171	39	Soto Ayam	27000.00	1	27000.00	\N	2026-11-20 13:53:29.667+07	2026-11-20 13:53:29.667+07
350	171	23	Nasi Chicken Katsu Sambal Matah	38000.00	1	38000.00	\N	2026-11-20 13:53:29.667+07	2026-11-20 13:53:29.667+07
351	171	24	Nasi Goreng + Kecombrang	35000.00	2	70000.00	\N	2026-11-20 13:53:29.667+07	2026-11-20 13:53:29.667+07
352	171	7	Rahang Tuna	100000.00	1	100000.00	\N	2026-11-20 13:53:29.667+07	2026-11-20 13:53:29.667+07
353	171	12	Bandeng Bakar Tanpa Duri	70000.00	1	70000.00	\N	2026-11-20 13:53:29.667+07	2026-11-20 13:53:29.667+07
354	171	9	Tuna Belly Bakar	53000.00	1	53000.00	\N	2026-11-20 13:53:29.667+07	2026-11-20 13:53:29.667+07
355	171	71	ES Jeruk	20000.00	1	20000.00	\N	2026-11-20 13:53:29.667+07	2026-11-20 13:53:29.667+07
356	171	81	Es Teh Tawar	5000.00	4	20000.00	\N	2026-11-20 13:53:29.667+07	2026-11-20 13:53:29.667+07
357	171	80	Es Teh Manis	6000.00	2	12000.00	\N	2026-11-20 13:53:29.667+07	2026-11-20 13:53:29.667+07
358	171	15	Bakwan Jagung ( isi 3 Pcs)	30000.00	2	60000.00	\N	2026-11-20 13:53:29.667+07	2026-11-20 13:53:29.667+07
359	171	27	Nasi Ikan Dori Sambal Matah	38000.00	1	38000.00	\N	2026-11-20 13:53:29.667+07	2026-11-20 13:53:29.667+07
360	171	86	Pangsit Goreng	15000.00	3	45000.00	\N	2026-11-20 13:53:29.667+07	2026-11-20 13:53:29.667+07
361	171	14	Cah Kangkung	25000.00	1	25000.00	\N	2026-11-20 13:53:29.667+07	2026-11-20 13:53:29.667+07
362	171	32	Bakmi Goreng	35000.00	1	35000.00	\N	2026-11-20 13:53:29.667+07	2026-11-20 13:53:29.667+07
363	171	16	Nasi Putih	9000.00	2	18000.00	\N	2026-11-20 13:53:29.667+07	2026-11-20 13:53:29.667+07
364	171	56	ES Jangan Biarkan Daku Sendiri	25000.00	1	25000.00	\N	2026-11-20 13:53:29.667+07	2026-11-20 13:53:29.667+07
365	171	38	Gado-gado Lontong / Nasi	33000.00	1	33000.00	\N	2026-11-20 13:53:29.667+07	2026-11-20 13:53:29.667+07
366	171	19	Nasi Ayam Kalasan	38000.00	1	38000.00	\N	2026-11-20 13:53:29.667+07	2026-11-20 13:53:29.667+07
367	172	97	Aren Latte(Ice)	25000.00	1	25000.00	\N	2026-11-20 13:55:18.161+07	2026-11-20 13:55:18.161+07
368	173	12	Bandeng Bakar Tanpa Duri	70000.00	1	70000.00	\N	2026-11-20 13:57:22.669+07	2026-11-20 13:57:22.669+07
369	174	37	Gado-Gado Sayur	28000.00	2	56000.00	\N	2026-11-20 14:00:53.029+07	2026-11-20 14:00:53.029+07
370	174	7	Rahang Tuna	100000.00	1	100000.00	\N	2026-11-20 14:00:53.029+07	2026-11-20 14:00:53.029+07
371	174	15	Bakwan Jagung ( isi 3 Pcs)	30000.00	1	30000.00	\N	2026-11-20 14:00:53.029+07	2026-11-20 14:00:53.029+07
372	174	81	Es Teh Tawar	5000.00	4	20000.00	\N	2026-11-20 14:00:53.029+07	2026-11-20 14:00:53.029+07
373	174	24	Nasi Goreng + Kecombrang	35000.00	1	35000.00	\N	2026-11-20 14:00:53.029+07	2026-11-20 14:00:53.029+07
374	174	97	Aren Latte(Ice)	25000.00	3	75000.00	\N	2026-11-20 14:00:53.029+07	2026-11-20 14:00:53.029+07
375	174	80	Es Teh Manis	6000.00	1	6000.00	\N	2026-11-20 14:00:53.029+07	2026-11-20 14:00:53.029+07
376	175	24	Nasi Goreng + Kecombrang	35000.00	1	35000.00	\N	2026-11-20 14:14:44.798+07	2026-11-20 14:14:44.798+07
377	175	80	Es Teh Manis	6000.00	1	6000.00	\N	2026-11-20 14:14:44.798+07	2026-11-20 14:14:44.798+07
378	176	24	Nasi Goreng + Kecombrang	35000.00	1	35000.00	\N	2026-11-20 14:47:17.26+07	2026-11-20 14:47:17.26+07
379	177	38	Gado-gado Lontong / Nasi	33000.00	1	33000.00	\N	2026-11-20 15:57:54.232+07	2026-11-20 15:57:54.232+07
380	178	38	Gado-gado Lontong / Nasi	33000.00	1	33000.00	\N	2026-11-20 18:20:42.751+07	2026-11-20 18:20:42.751+07
381	179	38	Gado-gado Lontong / Nasi	33000.00	1	33000.00	\N	2026-11-20 18:21:03.238+07	2026-11-20 18:21:03.238+07
382	180	32	Bakmi Goreng	35000.00	1	35000.00	\N	2026-11-20 18:45:07.082+07	2026-11-20 18:45:07.082+07
383	180	80	Es Teh Manis	6000.00	2	12000.00	\N	2026-11-20 18:45:07.082+07	2026-11-20 18:45:07.082+07
384	180	71	ES Jeruk	20000.00	1	20000.00	\N	2026-11-20 18:45:07.082+07	2026-11-20 18:45:07.082+07
385	180	44	Sate Ayam + Lontong	35000.00	1	35000.00	\N	2026-11-20 18:45:07.082+07	2026-11-20 18:45:07.082+07
386	180	24	Nasi Goreng + Kecombrang	35000.00	1	35000.00	\N	2026-11-20 18:45:07.082+07	2026-11-20 18:45:07.082+07
387	181	21	Nasi Ayam Penyet Sambel Matah	38000.00	1	38000.00	\N	2026-11-20 18:49:13.689+07	2026-11-20 18:49:13.689+07
388	181	26	Nasi Ikan Dori Sambal Pikoelan	38000.00	1	38000.00	\N	2026-11-20 18:49:13.689+07	2026-11-20 18:49:13.689+07
389	181	15	Bakwan Jagung ( isi 3 Pcs)	30000.00	1	30000.00	\N	2026-11-20 18:49:13.689+07	2026-11-20 18:49:13.689+07
390	181	14	Cah Kangkung	25000.00	1	25000.00	\N	2026-11-20 18:49:13.689+07	2026-11-20 18:49:13.689+07
391	181	19	Nasi Ayam Kalasan	38000.00	1	38000.00	\N	2026-11-20 18:49:13.689+07	2026-11-20 18:49:13.689+07
392	181	81	Es Teh Tawar	5000.00	1	5000.00	\N	2026-11-20 18:49:13.689+07	2026-11-20 18:49:13.689+07
393	182	51	Kwetiau Ayam Sambal Geledek (SPECIAL)	32000.00	1	32000.00	\N	2026-11-20 19:08:11.182+07	2026-11-20 19:08:11.182+07
394	182	56	ES Jangan Biarkan Daku Sendiri	25000.00	1	25000.00	\N	2026-11-20 19:08:11.182+07	2026-11-20 19:08:11.182+07
395	182	35	Mie Godog Jawa	30000.00	1	30000.00	\N	2026-11-20 19:08:11.182+07	2026-11-20 19:08:11.182+07
396	182	81	Es Teh Tawar	5000.00	1	5000.00	\N	2026-11-20 19:08:11.182+07	2026-11-20 19:08:11.182+07
397	183	44	Sate Ayam + Lontong	35000.00	1	35000.00	\N	2026-11-20 19:30:34.079+07	2026-11-20 19:30:34.079+07
398	183	21	Nasi Ayam Penyet Sambel Matah	38000.00	1	38000.00	\N	2026-11-20 19:30:34.079+07	2026-11-20 19:30:34.079+07
399	183	37	Gado-Gado Sayur	28000.00	1	28000.00	\N	2026-11-20 19:30:34.079+07	2026-11-20 19:30:34.079+07
400	183	38	Gado-gado Lontong / Nasi	33000.00	1	33000.00	\N	2026-11-20 19:30:34.079+07	2026-11-20 19:30:34.079+07
401	183	82	Teh Tawar Hangat	4000.00	1	4000.00	\N	2026-11-20 19:30:34.079+07	2026-11-20 19:30:34.079+07
402	184	37	Gado-Gado Sayur	28000.00	1	28000.00	\N	2026-11-20 19:52:50.962+07	2026-11-20 19:52:50.962+07
403	184	26	Nasi Ikan Dori Sambal Pikoelan	38000.00	2	76000.00	\N	2026-11-20 19:52:50.962+07	2026-11-20 19:52:50.962+07
404	184	82	Teh Tawar Hangat	4000.00	1	4000.00	\N	2026-11-20 19:52:50.962+07	2026-11-20 19:52:50.962+07
405	184	81	Es Teh Tawar	5000.00	2	10000.00	\N	2026-11-20 19:52:50.962+07	2026-11-20 19:52:50.962+07
406	185	44	Sate Ayam + Lontong	35000.00	1	35000.00	\N	2026-11-20 19:56:14.926+07	2026-11-20 19:56:14.926+07
407	185	89	Es Surga	30000.00	1	30000.00	\N	2026-11-20 19:56:14.926+07	2026-11-20 19:56:14.926+07
408	186	38	Gado-gado Lontong / Nasi	33000.00	1	33000.00	\N	2026-11-20 19:56:44.16+07	2026-11-20 19:56:44.16+07
409	187	12	Bandeng Bakar Tanpa Duri	70000.00	1	70000.00	\N	2026-11-20 19:59:28.849+07	2026-11-20 19:59:28.849+07
410	187	16	Nasi Putih	9000.00	2	18000.00	\N	2026-11-20 19:59:28.849+07	2026-11-20 19:59:28.849+07
411	187	56	ES Jangan Biarkan Daku Sendiri	25000.00	2	50000.00	\N	2026-11-20 19:59:28.849+07	2026-11-20 19:59:28.849+07
412	187	14	Cah Kangkung	25000.00	1	25000.00	\N	2026-11-20 19:59:28.849+07	2026-11-20 19:59:28.849+07
413	188	12	Bandeng Bakar Tanpa Duri	70000.00	1	70000.00	\N	2026-11-20 20:00:48.835+07	2026-11-20 20:00:48.835+07
414	188	16	Nasi Putih	9000.00	1	9000.00	\N	2026-11-20 20:00:48.835+07	2026-11-20 20:00:48.835+07
415	189	21	Nasi Ayam Penyet Sambel Matah	38000.00	1	38000.00	\N	2026-11-20 20:13:30.692+07	2026-11-20 20:13:30.692+07
416	190	31	Kwetiau Goreng Belacan	35000.00	1	35000.00	\N	2026-11-20 20:15:29.197+07	2026-11-20 20:15:29.197+07
417	190	81	Es Teh Tawar	5000.00	1	5000.00	\N	2026-11-20 20:15:29.197+07	2026-11-20 20:15:29.197+07
418	190	80	Es Teh Manis	6000.00	1	6000.00	\N	2026-11-20 20:15:29.197+07	2026-11-20 20:15:29.197+07
419	190	30	Nasi Sarang Ayam	38000.00	1	38000.00	\N	2026-11-20 20:15:29.197+07	2026-11-20 20:15:29.197+07
420	191	31	Kwetiau Goreng Belacan	35000.00	1	35000.00	\N	2026-11-20 21:31:31.468+07	2026-11-20 21:31:31.468+07
421	191	30	Nasi Sarang Ayam	38000.00	1	38000.00	\N	2026-11-20 21:31:31.468+07	2026-11-20 21:31:31.468+07
422	191	80	Es Teh Manis	6000.00	1	6000.00	\N	2026-11-20 21:31:31.468+07	2026-11-20 21:31:31.468+07
423	191	81	Es Teh Tawar	5000.00	1	5000.00	\N	2026-11-20 21:31:31.468+07	2026-11-20 21:31:31.468+07
424	192	80	Es Teh Manis	6000.00	1	6000.00	\N	2026-11-20 21:33:35.433+07	2026-11-20 21:33:35.433+07
425	193	35	Mie Godog Jawa	30000.00	1	30000.00	\N	2026-11-21 10:59:45.495+07	2026-11-21 10:59:45.495+07
426	193	20	Nasi Ayam Geprek	38000.00	1	38000.00	\N	2026-11-21 10:59:45.495+07	2026-11-21 10:59:45.495+07
427	193	56	ES Jangan Biarkan Daku Sendiri	25000.00	1	25000.00	\N	2026-11-21 10:59:45.495+07	2026-11-21 10:59:45.495+07
428	193	83	Air Mineral	5000.00	1	5000.00	\N	2026-11-21 10:59:45.495+07	2026-11-21 10:59:45.495+07
429	194	89	Es Surga	30000.00	1	30000.00	\N	2026-11-21 11:06:30.528+07	2026-11-21 11:06:30.528+07
430	194	80	Es Teh Manis	6000.00	1	6000.00	\N	2026-11-21 11:06:30.528+07	2026-11-21 11:06:30.528+07
431	194	83	Air Mineral	5000.00	1	5000.00	\N	2026-11-21 11:06:30.528+07	2026-11-21 11:06:30.528+07
432	194	43	Sate Ayam	30000.00	1	30000.00	\N	2026-11-21 11:06:30.528+07	2026-11-21 11:06:30.528+07
433	194	42	Capcay + Nasi	38000.00	1	38000.00	\N	2026-11-21 11:06:30.528+07	2026-11-21 11:06:30.528+07
434	194	24	Nasi Goreng + Kecombrang	35000.00	1	35000.00	\N	2026-11-21 11:06:30.528+07	2026-11-21 11:06:30.528+07
435	194	46	Aneka Gorengan perPcs	4000.00	2	8000.00	\N	2026-11-21 11:06:30.528+07	2026-11-21 11:06:30.528+07
436	195	13	Nasi Goreng tuna	38000.00	1	38000.00	\N	2026-11-21 12:32:31.064+07	2026-11-21 12:32:31.064+07
437	195	9	Tuna Belly Bakar	53000.00	2	106000.00	\N	2026-11-21 12:32:31.064+07	2026-11-21 12:32:31.064+07
438	195	16	Nasi Putih	9000.00	2	18000.00	\N	2026-11-21 12:32:31.064+07	2026-11-21 12:32:31.064+07
439	195	14	Cah Kangkung	25000.00	1	25000.00	\N	2026-11-21 12:32:31.064+07	2026-11-21 12:32:31.064+07
440	195	40	Soto Ayam + Nasi	33000.00	1	33000.00	\N	2026-11-21 12:32:31.064+07	2026-11-21 12:32:31.064+07
441	195	15	Bakwan Jagung ( isi 3 Pcs)	30000.00	1	30000.00	\N	2026-11-21 12:32:31.064+07	2026-11-21 12:32:31.064+07
442	195	83	Air Mineral	5000.00	3	15000.00	\N	2026-11-21 12:32:31.064+07	2026-11-21 12:32:31.064+07
443	195	80	Es Teh Manis	6000.00	2	12000.00	\N	2026-11-21 12:32:31.064+07	2026-11-21 12:32:31.064+07
444	196	23	Nasi Chicken Katsu Sambal Matah	38000.00	1	38000.00	\N	2026-11-21 12:33:08.43+07	2026-11-21 12:33:08.43+07
445	196	83	Air Mineral	5000.00	1	5000.00	\N	2026-11-21 12:33:08.43+07	2026-11-21 12:33:08.43+07
446	197	35	Mie Godog Jawa	30000.00	1	30000.00	\N	2026-11-21 12:51:19.364+07	2026-11-21 12:51:19.364+07
447	197	40	Soto Ayam + Nasi	33000.00	1	33000.00	\N	2026-11-21 12:51:19.364+07	2026-11-21 12:51:19.364+07
448	197	21	Nasi Ayam Penyet Sambel Matah	38000.00	2	76000.00	\N	2026-11-21 12:51:19.364+07	2026-11-21 12:51:19.364+07
449	197	16	Nasi Putih	9000.00	1	9000.00	\N	2026-11-21 12:51:19.364+07	2026-11-21 12:51:19.364+07
450	197	12	Bandeng Bakar Tanpa Duri	70000.00	1	70000.00	\N	2026-11-21 12:51:19.364+07	2026-11-21 12:51:19.364+07
451	197	71	ES Jeruk	20000.00	2	40000.00	\N	2026-11-21 12:51:19.364+07	2026-11-21 12:51:19.364+07
452	197	81	Es Teh Tawar	5000.00	1	5000.00	\N	2026-11-21 12:51:19.364+07	2026-11-21 12:51:19.364+07
453	198	13	Nasi Goreng tuna	38000.00	1	38000.00	\N	2026-11-21 13:23:40.864+07	2026-11-21 13:23:40.864+07
454	198	21	Nasi Ayam Penyet Sambel Matah	38000.00	1	38000.00	\N	2026-11-21 13:23:40.864+07	2026-11-21 13:23:40.864+07
455	199	12	Bandeng Bakar Tanpa Duri	70000.00	1	70000.00	\N	2026-11-21 13:34:01.772+07	2026-11-21 13:34:01.772+07
456	199	14	Cah Kangkung	25000.00	1	25000.00	\N	2026-11-21 13:34:01.772+07	2026-11-21 13:34:01.772+07
457	199	15	Bakwan Jagung ( isi 3 Pcs)	30000.00	1	30000.00	\N	2026-11-21 13:34:01.772+07	2026-11-21 13:34:01.772+07
458	200	35	Mie Godog Jawa	30000.00	2	60000.00	\N	2026-11-21 13:51:04.978+07	2026-11-21 13:51:04.978+07
459	200	80	Es Teh Manis	6000.00	2	12000.00	\N	2026-11-21 13:51:04.978+07	2026-11-21 13:51:04.978+07
460	201	35	Mie Godog Jawa	30000.00	1	30000.00	\N	2026-11-21 13:52:41.965+07	2026-11-21 13:52:41.965+07
461	201	15	Bakwan Jagung ( isi 3 Pcs)	30000.00	2	60000.00	\N	2026-11-21 13:52:41.965+07	2026-11-21 13:52:41.965+07
462	201	7	Rahang Tuna	100000.00	1	100000.00	\N	2026-11-21 13:52:41.965+07	2026-11-21 13:52:41.965+07
463	201	16	Nasi Putih	9000.00	1	9000.00	\N	2026-11-21 13:52:41.965+07	2026-11-21 13:52:41.965+07
464	201	14	Cah Kangkung	25000.00	1	25000.00	\N	2026-11-21 13:52:41.965+07	2026-11-21 13:52:41.965+07
465	201	81	Es Teh Tawar	5000.00	1	5000.00	\N	2026-11-21 13:52:41.965+07	2026-11-21 13:52:41.965+07
466	202	13	Nasi Goreng tuna	38000.00	1	38000.00	\N	2026-11-21 13:56:23.487+07	2026-11-21 13:56:23.487+07
467	202	80	Es Teh Manis	6000.00	2	12000.00	\N	2026-11-21 13:56:23.487+07	2026-11-21 13:56:23.487+07
468	202	38	Gado-gado Lontong / Nasi	33000.00	1	33000.00	\N	2026-11-21 13:56:23.487+07	2026-11-21 13:56:23.487+07
469	203	14	Cah Kangkung	25000.00	1	25000.00	\N	2026-11-21 13:58:59.15+07	2026-11-21 13:58:59.15+07
470	203	15	Bakwan Jagung ( isi 3 Pcs)	30000.00	1	30000.00	\N	2026-11-21 13:58:59.15+07	2026-11-21 13:58:59.15+07
471	203	16	Nasi Putih	9000.00	3	27000.00	\N	2026-11-21 13:58:59.15+07	2026-11-21 13:58:59.15+07
472	203	83	Air Mineral	5000.00	1	5000.00	\N	2026-11-21 13:58:59.15+07	2026-11-21 13:58:59.15+07
473	203	81	Es Teh Tawar	5000.00	1	5000.00	\N	2026-11-21 13:58:59.15+07	2026-11-21 13:58:59.15+07
474	203	72	ES Lidah Buaya	20000.00	1	20000.00	\N	2026-11-21 13:58:59.15+07	2026-11-21 13:58:59.15+07
475	203	13	Nasi Goreng tuna	38000.00	1	38000.00	\N	2026-11-21 13:58:59.15+07	2026-11-21 13:58:59.15+07
476	204	80	Es Teh Manis	6000.00	2	12000.00	\N	2026-11-21 14:14:11.986+07	2026-11-21 14:14:11.986+07
477	205	35	Mie Godog Jawa	30000.00	2	60000.00	\N	2026-11-21 14:20:11.955+07	2026-11-21 14:20:11.955+07
478	205	80	Es Teh Manis	6000.00	2	12000.00	\N	2026-11-21 14:20:11.955+07	2026-11-21 14:20:11.955+07
479	206	85	Bihun Bakso	30000.00	1	30000.00	\N	2026-11-21 14:37:04.21+07	2026-11-21 14:37:04.21+07
480	206	71	ES Jeruk	20000.00	1	20000.00	\N	2026-11-21 14:37:04.21+07	2026-11-21 14:37:04.21+07
481	207	40	Soto Ayam + Nasi	33000.00	1	33000.00	\N	2026-11-21 15:30:32.781+07	2026-11-21 15:30:32.781+07
482	207	21	Nasi Ayam Penyet Sambel Matah	38000.00	2	76000.00	\N	2026-11-21 15:30:32.781+07	2026-11-21 15:30:32.781+07
483	207	31	Kwetiau Goreng Belacan	35000.00	2	70000.00	\N	2026-11-21 15:30:32.781+07	2026-11-21 15:30:32.781+07
484	207	15	Bakwan Jagung ( isi 3 Pcs)	30000.00	1	30000.00	\N	2026-11-21 15:30:32.781+07	2026-11-21 15:30:32.781+07
485	207	24	Nasi Goreng + Kecombrang	35000.00	1	35000.00	\N	2026-11-21 15:30:32.781+07	2026-11-21 15:30:32.781+07
486	208	12	Bandeng Bakar Tanpa Duri	70000.00	1	70000.00	\N	2026-11-21 15:50:28.315+07	2026-11-21 15:50:28.315+07
487	208	13	Nasi Goreng tuna	38000.00	2	76000.00	\N	2026-11-21 15:50:28.315+07	2026-11-21 15:50:28.315+07
488	208	16	Nasi Putih	9000.00	1	9000.00	\N	2026-11-21 15:50:28.315+07	2026-11-21 15:50:28.315+07
489	208	14	Cah Kangkung	25000.00	1	25000.00	\N	2026-11-21 15:50:28.315+07	2026-11-21 15:50:28.315+07
490	208	96	Aren Latte (Hot)	22000.00	2	44000.00	\N	2026-11-21 15:50:28.315+07	2026-11-21 15:50:28.315+07
491	208	82	Teh Tawar Hangat	4000.00	1	4000.00	\N	2026-11-21 15:50:28.315+07	2026-11-21 15:50:28.315+07
492	209	24	Nasi Goreng + Kecombrang	35000.00	2	70000.00	\N	2026-11-21 19:09:57.869+07	2026-11-21 19:09:57.869+07
493	209	13	Nasi Goreng tuna	38000.00	1	38000.00	\N	2026-11-21 19:09:57.869+07	2026-11-21 19:09:57.869+07
494	210	21	Nasi Ayam Penyet Sambel Matah	38000.00	2	76000.00	\N	2026-11-21 19:13:01.156+07	2026-11-21 19:13:01.156+07
495	210	100	Pandan Latte(Ice)	28000.00	1	28000.00	\N	2026-11-21 19:13:01.156+07	2026-11-21 19:13:01.156+07
496	210	71	ES Jeruk	20000.00	1	20000.00	\N	2026-11-21 19:13:01.156+07	2026-11-21 19:13:01.156+07
497	210	89	Es Surga	30000.00	2	60000.00	\N	2026-11-21 19:13:01.156+07	2026-11-21 19:13:01.156+07
498	210	64	Jus Alpukat	20000.00	1	20000.00	\N	2026-11-21 19:13:01.156+07	2026-11-21 19:13:01.156+07
499	211	23	Nasi Chicken Katsu Sambal Matah	38000.00	1	38000.00	\N	2026-11-21 19:18:03.016+07	2026-11-21 19:18:03.016+07
500	212	23	Nasi Chicken Katsu Sambal Matah	38000.00	1	38000.00	\N	2026-11-21 19:18:16.845+07	2026-11-21 19:18:16.845+07
501	213	23	Nasi Chicken Katsu Sambal Matah	38000.00	1	38000.00	\N	2026-11-21 19:18:44.336+07	2026-11-21 19:18:44.336+07
502	214	33	Bihun Goreng	35000.00	9	315000.00	\N	2026-11-22 11:08:55.173+07	2026-11-22 11:08:55.173+07
503	214	86	Pangsit Goreng	15000.00	2	30000.00	\N	2026-11-22 11:08:55.173+07	2026-11-22 11:08:55.173+07
504	215	22	Nasi Chicken Katsu Sambal Pikoelan	38000.00	1	38000.00	\N	2026-11-22 11:22:02.928+07	2026-11-22 11:22:02.928+07
505	216	24	Nasi Goreng + Kecombrang	35000.00	2	70000.00	\N	2026-11-22 11:37:44.782+07	2026-11-22 11:37:44.782+07
506	216	13	Nasi Goreng tuna	38000.00	1	38000.00	\N	2026-11-22 11:37:44.782+07	2026-11-22 11:37:44.782+07
507	216	81	Es Teh Tawar	5000.00	3	15000.00	\N	2026-11-22 11:37:44.782+07	2026-11-22 11:37:44.782+07
508	217	21	Nasi Ayam Penyet Sambel Matah	38000.00	2	76000.00	\N	2026-11-22 12:03:34.352+07	2026-11-22 12:03:34.352+07
509	217	80	Es Teh Manis	6000.00	2	12000.00	\N	2026-11-22 12:03:34.352+07	2026-11-22 12:03:34.352+07
510	217	83	Air Mineral	5000.00	1	5000.00	\N	2026-11-22 12:03:34.352+07	2026-11-22 12:03:34.352+07
511	218	64	Jus Alpukat	20000.00	1	20000.00	\N	2026-11-22 12:12:17.946+07	2026-11-22 12:12:17.946+07
512	218	80	Es Teh Manis	6000.00	1	6000.00	\N	2026-11-22 12:12:17.946+07	2026-11-22 12:12:17.946+07
513	219	39	Soto Ayam	27000.00	2	54000.00	\N	2026-11-22 12:13:41.03+07	2026-11-22 12:13:41.03+07
514	220	44	Sate Ayam + Lontong	35000.00	1	35000.00	\N	2026-11-22 12:16:31.016+07	2026-11-22 12:16:31.016+07
515	220	31	Kwetiau Goreng Belacan	35000.00	1	35000.00	\N	2026-11-22 12:16:31.016+07	2026-11-22 12:16:31.016+07
516	221	64	Jus Alpukat	20000.00	1	20000.00	\N	2026-11-22 12:21:26.712+07	2026-11-22 12:21:26.712+07
517	222	13	Nasi Goreng tuna	38000.00	1	38000.00	\N	2026-11-22 12:46:15.495+07	2026-11-22 12:46:15.495+07
518	222	48	Bakmi Ayam Sambal Geledek (Biasa)	26000.00	1	26000.00	\N	2026-11-22 12:46:15.495+07	2026-11-22 12:46:15.495+07
519	222	71	ES Jeruk	20000.00	1	20000.00	\N	2026-11-22 12:46:15.495+07	2026-11-22 12:46:15.495+07
520	222	81	Es Teh Tawar	5000.00	1	5000.00	\N	2026-11-22 12:46:15.495+07	2026-11-22 12:46:15.495+07
521	223	21	Nasi Ayam Penyet Sambel Matah	38000.00	1	38000.00	\N	2026-11-22 14:01:11.236+07	2026-11-22 14:01:11.236+07
522	223	13	Nasi Goreng tuna	38000.00	1	38000.00	\N	2026-11-22 14:01:11.236+07	2026-11-22 14:01:11.236+07
523	223	37	Gado-Gado Sayur	28000.00	1	28000.00	\N	2026-11-22 14:01:11.236+07	2026-11-22 14:01:11.236+07
524	224	12	Bandeng Bakar Tanpa Duri	70000.00	1	70000.00	\N	2026-11-22 14:04:35.377+07	2026-11-22 14:04:35.377+07
525	224	16	Nasi Putih	9000.00	2	18000.00	\N	2026-11-22 14:04:35.377+07	2026-11-22 14:04:35.377+07
526	224	14	Cah Kangkung	25000.00	1	25000.00	\N	2026-11-22 14:04:35.377+07	2026-11-22 14:04:35.377+07
527	224	80	Es Teh Manis	6000.00	1	6000.00	\N	2026-11-22 14:04:35.377+07	2026-11-22 14:04:35.377+07
528	224	81	Es Teh Tawar	5000.00	1	5000.00	\N	2026-11-22 14:04:35.377+07	2026-11-22 14:04:35.377+07
529	225	24	Nasi Goreng + Kecombrang	35000.00	1	35000.00	\N	2026-11-22 14:05:49.376+07	2026-11-22 14:05:49.376+07
530	225	30	Nasi Sarang Ayam	38000.00	1	38000.00	\N	2026-11-22 14:05:49.376+07	2026-11-22 14:05:49.376+07
531	225	19	Nasi Ayam Kalasan	38000.00	1	38000.00	\N	2026-11-22 14:05:49.376+07	2026-11-22 14:05:49.376+07
532	225	80	Es Teh Manis	6000.00	2	12000.00	\N	2026-11-22 14:05:49.376+07	2026-11-22 14:05:49.376+07
533	225	71	ES Jeruk	20000.00	1	20000.00	\N	2026-11-22 14:05:49.376+07	2026-11-22 14:05:49.376+07
534	226	12	Bandeng Bakar Tanpa Duri	70000.00	1	70000.00	\N	2026-11-22 14:07:10.546+07	2026-11-22 14:07:10.546+07
535	226	14	Cah Kangkung	25000.00	1	25000.00	\N	2026-11-22 14:07:10.546+07	2026-11-22 14:07:10.546+07
536	226	16	Nasi Putih	9000.00	2	18000.00	\N	2026-11-22 14:07:10.546+07	2026-11-22 14:07:10.546+07
537	226	89	Es Surga	30000.00	1	30000.00	\N	2026-11-22 14:07:10.546+07	2026-11-22 14:07:10.546+07
538	226	81	Es Teh Tawar	5000.00	1	5000.00	\N	2026-11-22 14:07:10.546+07	2026-11-22 14:07:10.546+07
539	227	21	Nasi Ayam Penyet Sambel Matah	38000.00	1	38000.00	\N	2026-11-22 14:26:55.408+07	2026-11-22 14:26:55.408+07
540	228	19	Nasi Ayam Kalasan	38000.00	2	76000.00	\N	2026-11-22 14:29:52.674+07	2026-11-22 14:29:52.674+07
541	228	27	Nasi Ikan Dori Sambal Matah	38000.00	1	38000.00	\N	2026-11-22 14:29:52.674+07	2026-11-22 14:29:52.674+07
542	228	14	Cah Kangkung	25000.00	1	25000.00	\N	2026-11-22 14:29:52.674+07	2026-11-22 14:29:52.674+07
543	228	38	Gado-gado Lontong / Nasi	33000.00	1	33000.00	\N	2026-11-22 14:29:52.674+07	2026-11-22 14:29:52.674+07
544	228	81	Es Teh Tawar	5000.00	2	10000.00	\N	2026-11-22 14:29:52.674+07	2026-11-22 14:29:52.674+07
545	228	80	Es Teh Manis	6000.00	4	24000.00	\N	2026-11-22 14:29:52.674+07	2026-11-22 14:29:52.674+07
546	228	89	Es Surga	30000.00	1	30000.00	\N	2026-11-22 14:29:52.674+07	2026-11-22 14:29:52.674+07
547	228	15	Bakwan Jagung ( isi 3 Pcs)	30000.00	1	30000.00	\N	2026-11-22 14:29:52.674+07	2026-11-22 14:29:52.674+07
548	229	27	Nasi Ikan Dori Sambal Matah	38000.00	1	38000.00	\N	2026-11-22 15:07:25.492+07	2026-11-22 15:07:25.492+07
549	229	30	Nasi Sarang Ayam	38000.00	1	38000.00	\N	2026-11-22 15:07:25.492+07	2026-11-22 15:07:25.492+07
550	230	14	Cah Kangkung	25000.00	1	25000.00	\N	2026-11-22 15:09:02.834+07	2026-11-22 15:09:02.834+07
551	230	15	Bakwan Jagung ( isi 3 Pcs)	30000.00	1	30000.00	\N	2026-11-22 15:09:02.834+07	2026-11-22 15:09:02.834+07
552	231	44	Sate Ayam + Lontong	35000.00	1	35000.00	\N	2026-11-22 15:28:59.151+07	2026-11-22 15:28:59.151+07
553	231	56	ES Jangan Biarkan Daku Sendiri	25000.00	1	25000.00	\N	2026-11-22 15:28:59.151+07	2026-11-22 15:28:59.151+07
554	232	21	Nasi Ayam Penyet Sambel Matah	38000.00	2	76000.00	\N	2026-11-22 15:52:45.381+07	2026-11-22 15:52:45.381+07
555	232	13	Nasi Goreng tuna	38000.00	2	76000.00	\N	2026-11-22 15:52:45.381+07	2026-11-22 15:52:45.381+07
556	232	37	Gado-Gado Sayur	28000.00	1	28000.00	\N	2026-11-22 15:52:45.381+07	2026-11-22 15:52:45.381+07
557	232	19	Nasi Ayam Kalasan	38000.00	1	38000.00	\N	2026-11-22 15:52:45.381+07	2026-11-22 15:52:45.381+07
558	232	26	Nasi Ikan Dori Sambal Pikoelan	38000.00	1	38000.00	\N	2026-11-22 15:52:45.381+07	2026-11-22 15:52:45.381+07
559	232	6	Rahang Tuna Super (Diatas 1 Kg)	125000.00	1	125000.00	\N	2026-11-22 15:52:45.381+07	2026-11-22 15:52:45.381+07
560	232	15	Bakwan Jagung ( isi 3 Pcs)	30000.00	2	60000.00	\N	2026-11-22 15:52:45.381+07	2026-11-22 15:52:45.381+07
561	232	80	Es Teh Manis	6000.00	1	6000.00	\N	2026-11-22 15:52:45.381+07	2026-11-22 15:52:45.381+07
562	232	86	Pangsit Goreng	15000.00	1	15000.00	\N	2026-11-22 15:52:45.381+07	2026-11-22 15:52:45.381+07
563	232	81	Es Teh Tawar	5000.00	1	5000.00	\N	2026-11-22 15:52:45.381+07	2026-11-22 15:52:45.381+07
564	233	44	Sate Ayam + Lontong	35000.00	1	35000.00	\N	2026-11-22 15:55:35.456+07	2026-11-22 15:55:35.456+07
565	233	40	Soto Ayam + Nasi	33000.00	1	33000.00	\N	2026-11-22 15:55:35.456+07	2026-11-22 15:55:35.456+07
566	233	80	Es Teh Manis	6000.00	2	12000.00	\N	2026-11-22 15:55:35.456+07	2026-11-22 15:55:35.456+07
567	234	13	Nasi Goreng tuna	38000.00	1	38000.00	\N	2026-11-22 16:07:53.217+07	2026-11-22 16:07:53.217+07
568	234	119	Matcha Latte	20000.00	1	20000.00	\N	2026-11-22 16:07:53.217+07	2026-11-22 16:07:53.217+07
569	235	51	Kwetiau Ayam Sambal Geledek (SPECIAL)	32000.00	1	32000.00	\N	2026-11-22 16:14:50.954+07	2026-11-22 16:14:50.954+07
570	235	85	Bihun Bakso	30000.00	1	30000.00	\N	2026-11-22 16:14:50.954+07	2026-11-22 16:14:50.954+07
571	235	7	Rahang Tuna	100000.00	1	100000.00	\N	2026-11-22 16:14:50.954+07	2026-11-22 16:14:50.954+07
572	235	12	Bandeng Bakar Tanpa Duri	70000.00	1	70000.00	\N	2026-11-22 16:14:50.954+07	2026-11-22 16:14:50.954+07
573	235	71	ES Jeruk	20000.00	1	20000.00	\N	2026-11-22 16:14:50.954+07	2026-11-22 16:14:50.954+07
574	236	6	Rahang Tuna Super (Diatas 1 Kg)	125000.00	1	125000.00	\N	2026-11-22 16:20:32.955+07	2026-11-22 16:20:32.955+07
575	236	12	Bandeng Bakar Tanpa Duri	70000.00	1	70000.00	\N	2026-11-22 16:20:32.955+07	2026-11-22 16:20:32.955+07
576	236	37	Gado-Gado Sayur	28000.00	1	28000.00	\N	2026-11-22 16:20:32.955+07	2026-11-22 16:20:32.955+07
577	236	14	Cah Kangkung	25000.00	2	50000.00	\N	2026-11-22 16:20:32.955+07	2026-11-22 16:20:32.955+07
578	236	15	Bakwan Jagung ( isi 3 Pcs)	30000.00	1	30000.00	\N	2026-11-22 16:20:32.955+07	2026-11-22 16:20:32.955+07
579	236	88	Tempe Bacem	5000.00	3	15000.00	\N	2026-11-22 16:20:32.955+07	2026-11-22 16:20:32.955+07
580	236	87	Tahu Bacem	5000.00	3	15000.00	\N	2026-11-22 16:20:32.955+07	2026-11-22 16:20:32.955+07
581	236	24	Nasi Goreng + Kecombrang	35000.00	2	70000.00	\N	2026-11-22 16:20:32.955+07	2026-11-22 16:20:32.955+07
582	236	82	Teh Tawar Hangat	4000.00	1	4000.00	\N	2026-11-22 16:20:32.955+07	2026-11-22 16:20:32.955+07
583	237	22	Nasi Chicken Katsu Sambal Pikoelan	38000.00	1	38000.00	\N	2026-11-22 16:27:35.549+07	2026-11-22 16:27:35.549+07
584	237	82	Teh Tawar Hangat	4000.00	1	4000.00	\N	2026-11-22 16:27:35.549+07	2026-11-22 16:27:35.549+07
585	237	72	ES Lidah Buaya	20000.00	1	20000.00	\N	2026-11-22 16:27:35.549+07	2026-11-22 16:27:35.549+07
586	238	15	Bakwan Jagung ( isi 3 Pcs)	30000.00	1	30000.00	\N	2026-11-22 16:29:20.367+07	2026-11-22 16:29:20.367+07
587	239	83	Air Mineral	5000.00	2	10000.00	\N	2026-11-22 16:29:54.867+07	2026-11-22 16:29:54.867+07
588	240	12	Bandeng Bakar Tanpa Duri	70000.00	1	70000.00	\N	2026-11-22 16:32:55.859+07	2026-11-22 16:32:55.859+07
589	240	14	Cah Kangkung	25000.00	1	25000.00	\N	2026-11-22 16:32:55.859+07	2026-11-22 16:32:55.859+07
590	240	15	Bakwan Jagung ( isi 3 Pcs)	30000.00	1	30000.00	\N	2026-11-22 16:32:55.859+07	2026-11-22 16:32:55.859+07
591	240	87	Tahu Bacem	5000.00	1	5000.00	\N	2026-11-22 16:32:55.859+07	2026-11-22 16:32:55.859+07
592	240	88	Tempe Bacem	5000.00	1	5000.00	\N	2026-11-22 16:32:55.859+07	2026-11-22 16:32:55.859+07
593	240	16	Nasi Putih	9000.00	2	18000.00	\N	2026-11-22 16:32:55.859+07	2026-11-22 16:32:55.859+07
594	241	7	Rahang Tuna	100000.00	1	100000.00	\N	2026-11-22 16:49:37.213+07	2026-11-22 16:49:37.213+07
595	242	83	Air Mineral	5000.00	1	5000.00	\N	2026-11-22 16:59:14.077+07	2026-11-22 16:59:14.077+07
596	243	16	Nasi Putih	9000.00	1	9000.00	\N	2026-11-22 17:00:48.549+07	2026-11-22 17:00:48.549+07
597	243	89	Es Surga	30000.00	1	30000.00	\N	2026-11-22 17:00:48.549+07	2026-11-22 17:00:48.549+07
598	244	35	Mie Godog Jawa	30000.00	1	30000.00	\N	2026-11-22 17:01:35.976+07	2026-11-22 17:01:35.976+07
599	244	40	Soto Ayam + Nasi	33000.00	1	33000.00	\N	2026-11-22 17:01:35.976+07	2026-11-22 17:01:35.976+07
600	245	92	kopi Tubruk	20000.00	1	20000.00	\N	2026-11-22 17:04:22.856+07	2026-11-22 17:04:22.856+07
601	246	12	Bandeng Bakar Tanpa Duri	70000.00	1	70000.00	\N	2026-11-22 17:13:40.358+07	2026-11-22 17:13:40.358+07
602	246	15	Bakwan Jagung ( isi 3 Pcs)	30000.00	1	30000.00	\N	2026-11-22 17:13:40.358+07	2026-11-22 17:13:40.358+07
603	246	83	Air Mineral	5000.00	1	5000.00	\N	2026-11-22 17:13:40.358+07	2026-11-22 17:13:40.358+07
604	247	35	Mie Godog Jawa	30000.00	1	30000.00	\N	2026-11-22 17:18:03.326+07	2026-11-22 17:18:03.326+07
605	247	38	Gado-gado Lontong / Nasi	33000.00	1	33000.00	\N	2026-11-22 17:18:03.326+07	2026-11-22 17:18:03.326+07
606	247	86	Pangsit Goreng	15000.00	1	15000.00	\N	2026-11-22 17:18:03.326+07	2026-11-22 17:18:03.326+07
607	247	94	Americano (Hot)	22000.00	1	22000.00	\N	2026-11-22 17:18:03.326+07	2026-11-22 17:18:03.326+07
608	248	9	Tuna Belly Bakar	53000.00	1	53000.00	\N	2026-11-22 17:31:48.975+07	2026-11-22 17:31:48.975+07
609	248	16	Nasi Putih	9000.00	1	9000.00	\N	2026-11-22 17:31:48.975+07	2026-11-22 17:31:48.975+07
610	248	14	Cah Kangkung	25000.00	1	25000.00	\N	2026-11-22 17:31:48.975+07	2026-11-22 17:31:48.975+07
611	248	81	Es Teh Tawar	5000.00	2	10000.00	\N	2026-11-22 17:31:48.975+07	2026-11-22 17:31:48.975+07
612	248	13	Nasi Goreng tuna	38000.00	1	38000.00	\N	2026-11-22 17:31:48.975+07	2026-11-22 17:31:48.975+07
613	249	12	Bandeng Bakar Tanpa Duri	70000.00	1	70000.00	\N	2026-11-22 17:46:48.567+07	2026-11-22 17:46:48.567+07
614	249	16	Nasi Putih	9000.00	1	9000.00	\N	2026-11-22 17:46:48.567+07	2026-11-22 17:46:48.567+07
615	250	7	Rahang Tuna	100000.00	1	100000.00	\N	2026-11-22 17:51:59.198+07	2026-11-22 17:51:59.198+07
616	250	37	Gado-Gado Sayur	28000.00	1	28000.00	\N	2026-11-22 17:51:59.198+07	2026-11-22 17:51:59.198+07
617	250	21	Nasi Ayam Penyet Sambel Matah	38000.00	1	38000.00	\N	2026-11-22 17:51:59.198+07	2026-11-22 17:51:59.198+07
618	250	15	Bakwan Jagung ( isi 3 Pcs)	30000.00	1	30000.00	\N	2026-11-22 17:51:59.198+07	2026-11-22 17:51:59.198+07
619	250	16	Nasi Putih	9000.00	3	27000.00	\N	2026-11-22 17:51:59.198+07	2026-11-22 17:51:59.198+07
620	250	56	ES Jangan Biarkan Daku Sendiri	25000.00	1	25000.00	\N	2026-11-22 17:51:59.198+07	2026-11-22 17:51:59.198+07
621	250	82	Teh Tawar Hangat	4000.00	1	4000.00	\N	2026-11-22 17:51:59.198+07	2026-11-22 17:51:59.198+07
622	251	24	Nasi Goreng + Kecombrang	35000.00	1	35000.00	\N	2026-11-22 18:42:59.563+07	2026-11-22 18:42:59.563+07
623	251	13	Nasi Goreng tuna	38000.00	1	38000.00	\N	2026-11-22 18:42:59.563+07	2026-11-22 18:42:59.563+07
624	251	80	Es Teh Manis	6000.00	1	6000.00	\N	2026-11-22 18:42:59.563+07	2026-11-22 18:42:59.563+07
625	251	83	Air Mineral	5000.00	1	5000.00	\N	2026-11-22 18:42:59.563+07	2026-11-22 18:42:59.563+07
626	252	13	Nasi Goreng tuna	38000.00	2	76000.00	\N	2026-11-22 18:45:07.426+07	2026-11-22 18:45:07.426+07
627	252	10	Sate Tuna	53000.00	1	53000.00	\N	2026-11-22 18:45:07.426+07	2026-11-22 18:45:07.426+07
628	253	13	Nasi Goreng tuna	38000.00	1	38000.00	\N	2026-11-22 18:47:40.843+07	2026-11-22 18:47:40.843+07
629	253	38	Gado-gado Lontong / Nasi	33000.00	2	66000.00	\N	2026-11-22 18:47:40.843+07	2026-11-22 18:47:40.843+07
630	254	40	Soto Ayam + Nasi	33000.00	1	33000.00	\N	2026-11-22 19:05:28.363+07	2026-11-22 19:05:28.363+07
631	254	111	Ayam Kalasan (Ayam nya saja)	30000.00	1	30000.00	\N	2026-11-22 19:05:28.363+07	2026-11-22 19:05:28.363+07
632	254	82	Teh Tawar Hangat	4000.00	1	4000.00	\N	2026-11-22 19:05:28.363+07	2026-11-22 19:05:28.363+07
633	254	30	Nasi Sarang Ayam	38000.00	1	38000.00	\N	2026-11-22 19:05:28.363+07	2026-11-22 19:05:28.363+07
634	254	113	Ikan Dori (Ikan nya Saja)	30000.00	1	30000.00	\N	2026-11-22 19:05:28.363+07	2026-11-22 19:05:28.363+07
635	254	83	Air Mineral	5000.00	2	10000.00	\N	2026-11-22 19:05:28.363+07	2026-11-22 19:05:28.363+07
636	255	31	Kwetiau Goreng Belacan	35000.00	1	35000.00	\N	2026-11-22 19:09:08.565+07	2026-11-22 19:09:08.565+07
637	255	80	Es Teh Manis	6000.00	1	6000.00	\N	2026-11-22 19:09:08.565+07	2026-11-22 19:09:08.565+07
638	255	86	Pangsit Goreng	15000.00	1	15000.00	\N	2026-11-22 19:09:08.565+07	2026-11-22 19:09:08.565+07
639	255	13	Nasi Goreng tuna	38000.00	1	38000.00	\N	2026-11-22 19:09:08.565+07	2026-11-22 19:09:08.565+07
640	255	49	Bakmi Ayam Sambal Geledek ( SPECIAL )	32000.00	1	32000.00	\N	2026-11-22 19:09:08.565+07	2026-11-22 19:09:08.565+07
641	255	81	Es Teh Tawar	5000.00	1	5000.00	\N	2026-11-22 19:09:08.565+07	2026-11-22 19:09:08.565+07
642	255	66	Jus Mangga	20000.00	1	20000.00	\N	2026-11-22 19:09:08.565+07	2026-11-22 19:09:08.565+07
643	256	24	Nasi Goreng + Kecombrang	35000.00	1	35000.00	\N	2026-11-22 19:22:12.273+07	2026-11-22 19:22:12.273+07
644	256	40	Soto Ayam + Nasi	33000.00	1	33000.00	\N	2026-11-22 19:22:12.273+07	2026-11-22 19:22:12.273+07
645	256	83	Air Mineral	5000.00	2	10000.00	\N	2026-11-22 19:22:12.273+07	2026-11-22 19:22:12.273+07
646	257	13	Nasi Goreng tuna	38000.00	3	114000.00	\N	2026-11-22 19:32:50.218+07	2026-11-22 19:32:50.218+07
647	257	81	Es Teh Tawar	5000.00	1	5000.00	\N	2026-11-22 19:32:50.218+07	2026-11-22 19:32:50.218+07
648	257	80	Es Teh Manis	6000.00	2	12000.00	\N	2026-11-22 19:32:50.218+07	2026-11-22 19:32:50.218+07
649	258	13	Nasi Goreng tuna	38000.00	1	38000.00	\N	2026-11-22 20:03:09.931+07	2026-11-22 20:03:09.931+07
650	258	85	Bihun Bakso	30000.00	1	30000.00	\N	2026-11-22 20:03:09.931+07	2026-11-22 20:03:09.931+07
651	258	56	ES Jangan Biarkan Daku Sendiri	25000.00	1	25000.00	\N	2026-11-22 20:03:09.931+07	2026-11-22 20:03:09.931+07
652	258	82	Teh Tawar Hangat	4000.00	1	4000.00	\N	2026-11-22 20:03:09.931+07	2026-11-22 20:03:09.931+07
653	258	7	Rahang Tuna	100000.00	1	100000.00	\N	2026-11-22 20:03:09.931+07	2026-11-22 20:03:09.931+07
654	259	25	Nasi Goreng Merah	35000.00	1	35000.00	\N	2026-11-22 20:10:24.498+07	2026-11-22 20:10:24.498+07
655	259	79	Teh Tarik	15000.00	1	15000.00	\N	2026-11-22 20:10:24.498+07	2026-11-22 20:10:24.498+07
656	260	38	Gado-gado Lontong / Nasi	33000.00	1	33000.00	\N	2026-11-22 20:14:27.678+07	2026-11-22 20:14:27.678+07
657	261	40	Soto Ayam + Nasi	33000.00	1	33000.00	\N	2026-11-22 20:18:52.263+07	2026-11-22 20:18:52.263+07
658	261	71	ES Jeruk	20000.00	1	20000.00	\N	2026-11-22 20:18:52.263+07	2026-11-22 20:18:52.263+07
659	262	24	Nasi Goreng + Kecombrang	35000.00	1	35000.00	\N	2026-11-22 20:59:11.047+07	2026-11-22 20:59:11.047+07
660	262	40	Soto Ayam + Nasi	33000.00	2	66000.00	\N	2026-11-22 20:59:11.047+07	2026-11-22 20:59:11.047+07
661	262	83	Air Mineral	5000.00	2	10000.00	\N	2026-11-22 20:59:11.047+07	2026-11-22 20:59:11.047+07
662	262	89	Es Surga	30000.00	5	150000.00	\N	2026-11-22 20:59:11.047+07	2026-11-22 20:59:11.047+07
663	262	94	Americano (Hot)	22000.00	1	22000.00	\N	2026-11-22 20:59:11.047+07	2026-11-22 20:59:11.047+07
664	262	86	Pangsit Goreng	15000.00	1	15000.00	\N	2026-11-22 20:59:11.047+07	2026-11-22 20:59:11.047+07
665	262	56	ES Jangan Biarkan Daku Sendiri	25000.00	1	25000.00	\N	2026-11-22 20:59:11.047+07	2026-11-22 20:59:11.047+07
666	262	82	Teh Tawar Hangat	4000.00	1	4000.00	\N	2026-11-22 20:59:11.047+07	2026-11-22 20:59:11.047+07
667	262	97	Aren Latte(Ice)	25000.00	1	25000.00	\N	2026-11-22 20:59:11.047+07	2026-11-22 20:59:11.047+07
668	262	100	Pandan Latte(Ice)	28000.00	2	56000.00	\N	2026-11-22 20:59:11.047+07	2026-11-22 20:59:11.047+07
669	263	113	Ikan Dori (Ikan nya Saja)	30000.00	1	30000.00	\N	2026-11-23 11:50:37.595+07	2026-11-23 11:50:37.595+07
670	264	44	Sate Ayam + Lontong	35000.00	1	35000.00	\N	2026-11-23 13:02:15.432+07	2026-11-23 13:02:15.432+07
671	264	45	Sate Ayam + Nasi	38000.00	1	38000.00	\N	2026-11-23 13:02:15.432+07	2026-11-23 13:02:15.432+07
672	264	32	Bakmi Goreng	35000.00	1	35000.00	\N	2026-11-23 13:02:15.432+07	2026-11-23 13:02:15.432+07
673	264	15	Bakwan Jagung ( isi 3 Pcs)	30000.00	1	30000.00	\N	2026-11-23 13:02:15.432+07	2026-11-23 13:02:15.432+07
674	264	72	ES Lidah Buaya	20000.00	2	40000.00	\N	2026-11-23 13:02:15.432+07	2026-11-23 13:02:15.432+07
675	265	29	Nasi Kulit Sambal Matah	38000.00	1	38000.00	\N	2026-11-23 13:23:10.953+07	2026-11-23 13:23:10.953+07
676	265	7	Rahang Tuna	100000.00	1	100000.00	\N	2026-11-23 13:23:10.953+07	2026-11-23 13:23:10.953+07
677	265	16	Nasi Putih	9000.00	2	18000.00	\N	2026-11-23 13:23:10.953+07	2026-11-23 13:23:10.953+07
678	265	19	Nasi Ayam Kalasan	38000.00	2	76000.00	\N	2026-11-23 13:23:10.953+07	2026-11-23 13:23:10.953+07
679	265	14	Cah Kangkung	25000.00	1	25000.00	\N	2026-11-23 13:23:10.953+07	2026-11-23 13:23:10.953+07
\.


--
-- Data for Name: promo_usages; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "public"."promo_usages" ("id", "tenant_id", "promo_id", "order_id", "member_id", "discount_amount", "order_amount", "created_at", "updated_at") FROM stdin;
\.


--
-- Data for Name: role_permissions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "public"."role_permissions" ("id", "tenant_id", "role", "menu_key", "can_create", "can_read", "can_update", "can_delete", "created_at", "updated_at") FROM stdin;
29	1	manager	dashboard	t	t	t	f	2026-10-23 21:21:35.199+07	2026-10-23 21:21:35.199+07
30	1	manager	menu	t	t	t	t	2026-10-23 21:21:35.446+07	2026-10-23 21:21:35.446+07
31	1	manager	staff	t	t	t	t	2026-10-23 21:21:35.518+07	2026-10-23 21:21:35.518+07
32	1	manager	transactions	t	t	t	f	2026-10-23 21:21:35.617+07	2026-10-23 21:21:35.617+07
33	1	manager	reports	t	t	t	f	2026-10-23 21:21:35.952+07	2026-10-23 21:21:35.952+07
34	1	manager	settings	t	t	t	f	2026-10-23 21:21:36.251+07	2026-10-23 21:21:36.251+07
35	1	manager	notifications	t	t	t	f	2026-10-23 21:21:36.478+07	2026-10-23 21:21:36.478+07
22	1	kasir	dashboard	f	t	f	f	2026-10-23 21:20:58.446+07	2026-11-12 22:46:24.618+07
8	1	waiter	dashboard	f	t	f	f	2026-10-23 21:19:47.837+07	2026-11-02 21:14:57.023+07
9	1	waiter	menu	f	t	f	f	2026-10-23 21:19:47.895+07	2026-11-02 21:14:57.058+07
10	1	waiter	staff	f	f	f	f	2026-10-23 21:19:48.077+07	2026-11-02 21:14:57.085+07
11	1	waiter	transactions	t	t	t	f	2026-10-23 21:19:48.387+07	2026-11-02 21:14:57.111+07
12	1	waiter	reports	f	f	f	f	2026-10-23 21:19:48.623+07	2026-11-02 21:14:57.137+07
13	1	waiter	settings	f	f	f	f	2026-10-23 21:19:48.828+07	2026-11-02 21:14:57.163+07
14	1	waiter	notifications	f	t	f	f	2026-10-23 21:19:49.034+07	2026-11-02 21:14:57.188+07
52	1	waiter	promos	f	f	f	f	2026-11-02 21:14:57.213+07	2026-11-02 21:14:57.213+07
53	1	waiter	memberships	f	f	f	f	2026-11-02 21:14:57.24+07	2026-11-02 21:14:57.24+07
23	1	kasir	menu	f	t	f	f	2026-10-23 21:20:58.644+07	2026-11-12 22:46:24.66+07
24	1	kasir	staff	f	f	f	f	2026-10-23 21:20:58.731+07	2026-11-12 22:46:24.686+07
25	1	kasir	transactions	t	t	t	t	2026-10-23 21:20:58.952+07	2026-11-12 22:46:24.711+07
26	1	kasir	reports	f	t	f	f	2026-10-23 21:20:59.196+07	2026-11-12 22:46:24.74+07
27	1	kasir	settings	f	f	f	f	2026-10-23 21:20:59.505+07	2026-11-12 22:46:24.766+07
28	1	kasir	notifications	f	t	f	f	2026-10-23 21:20:59.73+07	2026-11-12 22:46:24.79+07
43	1	kasir	promos	f	t	f	f	2026-11-02 21:12:07.887+07	2026-11-12 22:46:24.816+07
44	1	kasir	memberships	t	t	t	f	2026-11-02 21:12:07.96+07	2026-11-12 22:46:24.847+07
108	1	kasir	stock	f	t	t	f	2026-11-04 02:54:30.529+07	2026-11-12 22:46:24.875+07
179	2	manager	dashboard	t	t	t	f	2026-11-11 16:34:32.436+07	2026-11-11 16:34:32.436+07
180	2	manager	menu	t	t	t	t	2026-11-11 16:34:32.462+07	2026-11-11 16:34:32.462+07
181	2	manager	staff	t	t	t	f	2026-11-11 16:34:32.467+07	2026-11-11 16:34:32.467+07
182	2	manager	transactions	t	t	t	f	2026-11-11 16:34:32.472+07	2026-11-11 16:34:32.472+07
183	2	manager	reports	t	t	t	f	2026-11-11 16:34:32.49+07	2026-11-11 16:34:32.49+07
184	2	manager	settings	t	t	t	f	2026-11-11 16:34:32.494+07	2026-11-11 16:34:32.494+07
185	2	manager	notifications	t	t	t	f	2026-11-11 16:34:32.499+07	2026-11-11 16:34:32.499+07
186	2	manager	promos	t	t	t	t	2026-11-11 16:34:32.503+07	2026-11-11 16:34:32.503+07
187	2	manager	memberships	t	t	t	t	2026-11-11 16:34:32.506+07	2026-11-11 16:34:32.506+07
188	2	manager	stock	t	t	t	t	2026-11-11 16:34:32.51+07	2026-11-11 16:34:32.51+07
169	2	kitchen	dashboard	f	t	f	f	2026-11-10 18:11:14.706+07	2026-11-11 16:35:47.662+07
170	2	kitchen	menu	f	t	f	f	2026-11-10 18:11:14.712+07	2026-11-11 16:35:47.666+07
171	2	kitchen	staff	f	f	f	f	2026-11-10 18:11:14.716+07	2026-11-11 16:35:47.668+07
172	2	kitchen	transactions	f	t	t	f	2026-11-10 18:11:14.756+07	2026-11-11 16:35:47.671+07
15	1	kitchen	dashboard	f	t	f	f	2026-10-23 21:20:17.848+07	2026-11-08 22:59:37.242+07
16	1	kitchen	menu	f	f	f	f	2026-10-23 21:20:22.479+07	2026-11-08 22:59:37.286+07
17	1	kitchen	staff	f	f	f	f	2026-10-23 21:20:22.623+07	2026-11-08 22:59:37.314+07
18	1	kitchen	transactions	f	t	t	f	2026-10-23 21:20:23.019+07	2026-11-08 22:59:37.342+07
19	1	kitchen	reports	f	f	f	f	2026-10-23 21:20:23.326+07	2026-11-08 22:59:37.368+07
20	1	kitchen	settings	f	f	f	f	2026-10-23 21:20:23.366+07	2026-11-08 22:59:37.396+07
21	1	kitchen	notifications	f	t	f	f	2026-10-23 21:20:23.75+07	2026-11-08 22:59:37.422+07
61	1	kitchen	promos	f	f	f	f	2026-11-02 21:15:19.628+07	2026-11-08 22:59:37.451+07
62	1	kitchen	memberships	f	f	f	f	2026-11-02 21:15:19.664+07	2026-11-08 22:59:37.477+07
128	1	kitchen	stock	t	t	t	f	2026-11-08 22:12:04.379+07	2026-11-08 22:59:37.503+07
173	2	kitchen	reports	f	f	f	f	2026-11-10 18:11:14.759+07	2026-11-11 16:35:47.674+07
174	2	kitchen	settings	f	f	f	f	2026-11-10 18:11:14.763+07	2026-11-11 16:35:47.677+07
175	2	kitchen	notifications	f	f	f	f	2026-11-10 18:11:14.766+07	2026-11-11 16:35:47.679+07
176	2	kitchen	promos	f	f	f	f	2026-11-10 18:11:14.77+07	2026-11-11 16:35:47.682+07
177	2	kitchen	memberships	f	f	f	f	2026-11-10 18:11:14.773+07	2026-11-11 16:35:47.69+07
178	2	kitchen	stock	t	t	t	f	2026-11-10 18:11:14.776+07	2026-11-11 16:35:47.693+07
139	2	staff	dashboard	f	t	f	f	2026-11-10 18:09:57.247+07	2026-11-11 16:35:13.948+07
140	2	staff	menu	f	t	f	f	2026-11-10 18:09:57.265+07	2026-11-11 16:35:13.964+07
141	2	staff	staff	f	t	f	f	2026-11-10 18:09:57.269+07	2026-11-11 16:35:13.968+07
142	2	staff	transactions	t	t	t	f	2026-11-10 18:09:57.273+07	2026-11-11 16:35:13.972+07
143	2	staff	reports	f	f	f	f	2026-11-10 18:09:57.277+07	2026-11-11 16:35:13.976+07
144	2	staff	settings	f	f	f	f	2026-11-10 18:09:57.281+07	2026-11-11 16:35:13.979+07
145	2	staff	notifications	f	f	f	f	2026-11-10 18:09:57.286+07	2026-11-11 16:35:13.982+07
146	2	staff	promos	f	t	f	f	2026-11-10 18:09:57.289+07	2026-11-11 16:35:13.985+07
147	2	staff	memberships	f	f	f	f	2026-11-10 18:09:57.291+07	2026-11-11 16:35:13.988+07
148	2	staff	stock	f	t	t	f	2026-11-10 18:09:57.294+07	2026-11-11 16:35:13.992+07
159	2	waiter	dashboard	f	t	f	f	2026-11-10 18:10:49.309+07	2026-11-11 16:36:58.959+07
160	2	waiter	menu	t	t	t	f	2026-11-10 18:10:49.313+07	2026-11-11 16:36:58.962+07
161	2	waiter	staff	f	f	f	f	2026-11-10 18:10:49.317+07	2026-11-11 16:36:58.965+07
162	2	waiter	transactions	t	t	t	f	2026-11-10 18:10:49.321+07	2026-11-11 16:36:58.968+07
163	2	waiter	reports	f	f	f	f	2026-11-10 18:10:49.324+07	2026-11-11 16:36:58.971+07
164	2	waiter	settings	f	f	f	f	2026-11-10 18:10:49.328+07	2026-11-11 16:36:58.974+07
165	2	waiter	notifications	f	f	f	f	2026-11-10 18:10:49.332+07	2026-11-11 16:36:58.976+07
166	2	waiter	promos	f	t	f	f	2026-11-10 18:10:49.336+07	2026-11-11 16:36:58.979+07
167	2	waiter	memberships	f	t	f	f	2026-11-10 18:10:49.355+07	2026-11-11 16:36:58.982+07
168	2	waiter	stock	f	f	f	f	2026-11-10 18:10:49.359+07	2026-11-11 16:36:58.99+07
149	2	kasir	dashboard	f	t	f	f	2026-11-10 18:10:26.786+07	2026-11-11 16:37:24.449+07
150	2	kasir	menu	t	t	t	f	2026-11-10 18:10:26.789+07	2026-11-11 16:37:24.453+07
151	2	kasir	staff	f	f	f	f	2026-11-10 18:10:26.792+07	2026-11-11 16:37:24.456+07
152	2	kasir	transactions	t	t	t	f	2026-11-10 18:10:26.795+07	2026-11-11 16:37:24.46+07
153	2	kasir	reports	f	t	f	f	2026-11-10 18:10:26.798+07	2026-11-11 16:37:24.464+07
154	2	kasir	settings	f	f	f	f	2026-11-10 18:10:26.801+07	2026-11-11 16:37:24.468+07
155	2	kasir	notifications	f	f	f	f	2026-11-10 18:10:26.804+07	2026-11-11 16:37:24.493+07
156	2	kasir	promos	f	t	f	f	2026-11-10 18:10:26.807+07	2026-11-11 16:37:24.497+07
157	2	kasir	memberships	f	t	f	f	2026-11-10 18:10:26.81+07	2026-11-11 16:37:24.501+07
158	2	kasir	stock	t	t	t	f	2026-11-10 18:10:26.813+07	2026-11-11 16:37:24.504+07
1	1	staff	dashboard	f	t	f	f	2026-10-23 21:18:22.393+07	2026-11-12 22:46:59.746+07
2	1	staff	menu	f	t	f	f	2026-10-23 21:18:22.476+07	2026-11-12 22:46:59.968+07
3	1	staff	staff	f	f	f	f	2026-10-23 21:18:22.797+07	2026-11-12 22:47:00.152+07
4	1	staff	transactions	t	t	t	f	2026-10-23 21:18:22.856+07	2026-11-12 22:47:00.358+07
5	1	staff	reports	f	f	f	f	2026-10-23 21:18:22.922+07	2026-11-12 22:47:00.559+07
6	1	staff	settings	f	f	f	f	2026-10-23 21:18:23.509+07	2026-11-12 22:47:00.646+07
7	1	staff	notifications	f	t	f	f	2026-10-23 21:18:23.722+07	2026-11-12 22:47:00.855+07
79	1	staff	promos	f	t	f	f	2026-11-02 21:27:33.42+07	2026-11-12 22:47:00.98+07
80	1	staff	memberships	f	f	f	f	2026-11-02 21:27:33.447+07	2026-11-12 22:47:01.282+07
268	1	staff	stock	f	t	f	f	2026-11-12 22:47:01.586+07	2026-11-12 22:47:01.586+07
\.


--
-- Data for Name: stock_movements; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "public"."stock_movements" ("id", "tenant_id", "stock_item_id", "user_id", "type", "reason", "quantity", "stock_before", "stock_after", "unit_cost", "total_cost", "reference_number", "notes", "movement_date", "created_at", "updated_at") FROM stdin;
1	1	1	3	out	production	5.0000	10.0000	5.0000	10000.00	50000.00	\N	\N	2026-11-08	2026-11-08 16:27:45.677+07	2026-11-08 16:27:45.677+07
2	1	2	3	in	purchase	50.0000	100.0000	150.0000	10000.00	500000.00	\N	\N	2026-11-08	2026-11-08 16:28:59.605+07	2026-11-08 16:28:59.605+07
3	1	1	3	in	purchase	10.0000	5.0000	15.0000	10000.00	100000.00	\N	\N	2026-11-08	2026-11-08 16:39:39.904+07	2026-11-08 16:39:39.904+07
4	1	2	3	out	production	80.0000	150.0000	70.0000	\N	\N	\N	\N	2026-11-08	2026-11-08 16:42:14.809+07	2026-11-08 16:42:14.809+07
5	1	2	3	out	production	20.0000	70.0000	50.0000	\N	\N	\N	\N	2026-11-08	2026-11-08 16:43:56.544+07	2026-11-08 16:43:56.544+07
6	1	1	3	out	production	13.0000	15.0000	2.0000	\N	\N	\N	\N	2026-11-08	2026-11-08 17:40:25.87+07	2026-11-08 17:40:25.87+07
7	1	1	3	out	production	2.0000	2.0000	0.0000	\N	\N	\N	\N	2026-11-08	2026-11-08 18:03:15.369+07	2026-11-08 18:03:15.369+07
\.


--
-- Data for Name: tenant_payment; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "public"."tenant_payment" ("id", "tenant_id", "qris_url", "bank_account_name", "bank_account_number", "phone_confirmation", "delivery_description", "created_at", "updated_at") FROM stdin;
1	1	https://obaybiymhuukucvvgdsq.supabase.co/storage/v1/object/public/uploads/qris/4ad91b09-a2ed-40b3-aabc-96235bc05c4b.jpg	ss	123445555	123	OKE	2026-10-24 18:50:16.129+07	2026-10-24 18:52:38.731+07
2	2	\N	Pikoelan Nusantara	111111111	08118823200	Gratis pengiriman sekitar Rusun ASN kemayoran	2026-10-28 02:18:03.763+07	2026-10-29 01:35:18.815+07
\.


--
-- Data for Name: buckets; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY "storage"."buckets" ("id", "name", "owner", "created_at", "updated_at", "public", "avif_autodetection", "file_size_limit", "allowed_mime_types", "owner_id", "type", "versioning_status", "lifecycle_configuration", "lifecycle_configuration_generation") FROM stdin;
uploads	uploads	\N	2026-08-06 16:53:53.111058+07	2026-08-06 16:53:53.111058+07	t	f	31457280	{image/jpeg,image/jpg,image/png,image/webp,image/bmp}	\N	STANDARD	DISABLED	\N	\N
\.


--
-- Data for Name: bucket_lifecycle_states; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY "storage"."bucket_lifecycle_states" ("bucket_id", "generation", "next_run_at", "claim_id", "claim_until", "continuation", "last_started_at", "last_completed_at", "last_success_at", "last_result", "failure_count", "last_error", "updated_at") FROM stdin;
\.


--
-- Data for Name: buckets_analytics; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY "storage"."buckets_analytics" ("name", "type", "format", "created_at", "updated_at", "id", "deleted_at") FROM stdin;
\.


--
-- Data for Name: lifecycle_abandoned_artifacts; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY "storage"."lifecycle_abandoned_artifacts" ("bucket_id", "key", "name", "version", "attempted_at") FROM stdin;
\.


--
-- Data for Name: objects; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY "storage"."objects" ("id", "bucket_id", "name", "owner", "created_at", "updated_at", "last_accessed_at", "metadata", "version", "owner_id", "user_metadata", "archived_at", "is_delete_marker", "is_versioned") FROM stdin;
4ac0b08c-c77c-4b4b-8a99-0168ccba8e77	uploads	cart-air.png	\N	2026-10-04 10:11:18.77339+07	2026-10-04 10:11:18.77339+07	2026-10-04 10:11:18.77339+07	{"eTag": "\\"f836c72e27912d373e04842d7845bdef-1\\"", "size": 773, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2026-10-04T03:11:19.000Z", "contentLength": 773, "httpStatusCode": 200}	e0821e41-715f-418b-9d3d-0dddf8afd513	\N	\N	\N	f	f
8e03bca8-85bb-4cee-a8d1-607f1fd82434	uploads	menu/3ef6048c-3c2a-47b2-afce-898e283e3e5d.jpg	\N	2026-10-04 13:17:14.470579+07	2026-10-04 13:17:14.470579+07	2026-10-04 13:17:14.470579+07	{"eTag": "\\"14faebf6ae8d41fbaf3dbff9c8bf13e4\\"", "size": 845, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-10-04T06:17:15.000Z", "contentLength": 845, "httpStatusCode": 200}	6cfc4997-93b5-4d3c-82f7-3cdb396b5cfa	\N	{}	\N	f	f
a50299c4-19b3-4725-a9eb-92593a97a21e	uploads	tenants/bb7cfd96-0f93-4248-972e-73e584a7fc07.jpg	\N	2026-10-29 01:35:05.987979+07	2026-10-29 01:35:05.987979+07	2026-10-29 01:35:05.987979+07	{"eTag": "\\"51953d8ba90f7a9e7455fdc40d6e4388\\"", "size": 1445487, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-10-28T18:35:06.000Z", "contentLength": 1445487, "httpStatusCode": 200}	8dd78feb-0426-4c8e-b34f-92dd97b9b5fd	\N	{}	\N	f	f
ce56101c-94b4-473e-874a-7309885d98d9	uploads	menu/b1890fa3-ed3a-4229-afc9-14871590d0f1.jpg	\N	2026-10-04 21:59:54.50903+07	2026-10-04 21:59:54.50903+07	2026-10-04 21:59:54.50903+07	{"eTag": "\\"d8e29e0dd996434733065503366e7c81\\"", "size": 38716, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-10-04T14:59:55.000Z", "contentLength": 38716, "httpStatusCode": 200}	eb4c3bee-cb6e-4207-bffe-81ffc242e29d	\N	{}	\N	f	f
aa27ad22-c30d-4f2e-8e08-871cd71e005b	uploads	menu/bf24f741-f32c-4707-9f7e-3b14fd35f12a.jpeg	\N	2026-10-10 21:33:16.769753+07	2026-10-10 21:33:16.769753+07	2026-10-10 21:33:16.769753+07	{"eTag": "\\"96d3aa20b5622e97fd32fcaadb572753\\"", "size": 123191, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-10-10T14:33:17.000Z", "contentLength": 123191, "httpStatusCode": 200}	93157fe6-53a0-41ac-801d-78caa7392263	\N	{}	\N	f	f
8dc80cf6-6559-454a-9c23-84a26d96e3ea	uploads	tenants/92841bda-ac83-45bf-ab2f-7cfe9fbe14f7.jpg	\N	2026-10-29 01:35:19.087546+07	2026-10-29 01:35:19.087546+07	2026-10-29 01:35:19.087546+07	{"eTag": "\\"51953d8ba90f7a9e7455fdc40d6e4388\\"", "size": 1445487, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-10-28T18:35:20.000Z", "contentLength": 1445487, "httpStatusCode": 200}	8ebd3431-a86d-4c82-9e28-cf9845da2c7e	\N	{}	\N	f	f
9d6e98a2-7fbe-4884-9bd7-c784aa0136b6	uploads	menu/7ff274a9-bf01-41e1-9fb1-1c551478cd7e.jpeg	\N	2026-10-10 21:39:34.719322+07	2026-10-10 21:39:34.719322+07	2026-10-10 21:39:34.719322+07	{"eTag": "\\"e59cc547ba8f7739e466d34612e8762a\\"", "size": 116232, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-10-10T14:39:35.000Z", "contentLength": 116232, "httpStatusCode": 200}	aea02f20-cf79-4b84-ae34-24677dee8f9a	\N	{}	\N	f	f
1700e761-f294-4391-940b-d7ba9b2de4c3	uploads	menu/7943478a-6e34-4546-b39f-8432b624e5fa.jpg	\N	2026-10-10 21:40:07.628142+07	2026-10-10 21:40:07.628142+07	2026-10-10 21:40:07.628142+07	{"eTag": "\\"82cbe6f0f68a3d1b810779de47ce5760\\"", "size": 103875, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-10-10T14:40:08.000Z", "contentLength": 103875, "httpStatusCode": 200}	2f727bae-d14b-48ae-950d-e35b7cf16f56	\N	{}	\N	f	f
f08702b5-3e23-484e-8d7b-fdd31263cd07	uploads	tenants/6e8de250-2aa6-4495-a282-ff8cda35fb57.jpg	\N	2026-10-29 01:37:43.488568+07	2026-10-29 01:37:43.488568+07	2026-10-29 01:37:43.488568+07	{"eTag": "\\"b1b7e99db508ac906cd5127503427e9a\\"", "size": 1034558, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-10-28T18:37:44.000Z", "contentLength": 1034558, "httpStatusCode": 200}	7501ed9c-7a03-4ffd-9c9f-05ef456d9cf7	\N	{}	\N	f	f
6f6a0ebf-01c8-4cca-a794-b8d40e00a02c	uploads	menu/2d8e2a08-08aa-49b5-a592-8b68c8908690.jpg	\N	2026-10-10 21:40:34.858423+07	2026-10-10 21:40:34.858423+07	2026-10-10 21:40:34.858423+07	{"eTag": "\\"51cb1a33cabe980526d717e68b19c40c\\"", "size": 88527, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-10-10T14:40:35.000Z", "contentLength": 88527, "httpStatusCode": 200}	6c7cdd2e-7fee-4677-9456-5dcb06b4bb1c	\N	{}	\N	f	f
a4282b3c-f4fa-471b-be0f-3e769e076543	uploads	menu/46de5e3f-e732-4376-88ca-0c2ae209d663.jpg	\N	2026-10-10 22:02:12.814673+07	2026-10-10 22:02:12.814673+07	2026-10-10 22:02:12.814673+07	{"eTag": "\\"82cbe6f0f68a3d1b810779de47ce5760\\"", "size": 103875, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-10-10T15:02:13.000Z", "contentLength": 103875, "httpStatusCode": 200}	016534c4-ff1f-45c5-b410-813d1cb72652	\N	{}	\N	f	f
ac341372-0063-4c65-b241-c783cf5d3b30	uploads	tenants/b053a82c-6dde-4266-b690-3e8fa9c65ade.jpeg	\N	2026-10-11 00:03:37.024974+07	2026-10-11 00:03:37.024974+07	2026-10-11 00:03:37.024974+07	{"eTag": "\\"84c7828bf1035f4200731ff04e0a2557\\"", "size": 136686, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-10-10T17:03:37.000Z", "contentLength": 136686, "httpStatusCode": 200}	19c0d19a-6d8d-493b-9752-a61971bb06fd	\N	{}	\N	f	f
adf217a5-ac33-4cd1-acb1-e79eae970c13	uploads	menu/ac08d500-1837-4a0a-b4ea-81ec913e9ee2.jpg	\N	2026-10-16 00:15:37.873889+07	2026-10-16 00:15:37.873889+07	2026-10-16 00:15:37.873889+07	{"eTag": "\\"ad8cd291c64a82441a284da4af4be291\\"", "size": 33212, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-10-15T17:15:38.000Z", "contentLength": 33212, "httpStatusCode": 200}	6facf4da-53a5-4b04-8a3d-0ebb003605b4	\N	{}	\N	f	f
0721078d-1880-4400-8ecb-f8eb0a517c1f	uploads	menu/971e2659-c458-4f40-8512-a232443e0a75.jpg	\N	2026-10-16 00:15:52.585676+07	2026-10-16 00:15:52.585676+07	2026-10-16 00:15:52.585676+07	{"eTag": "\\"5484595e81ec4fc821b0a15f39f0d021\\"", "size": 46915, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-10-15T17:15:53.000Z", "contentLength": 46915, "httpStatusCode": 200}	fc44b3f8-46d6-4b4e-95ba-e293ce77fa40	\N	{}	\N	f	f
4fb07226-bc48-46c3-8a25-8ba67df2f3a4	uploads	menu/bd2122b9-c398-4361-a127-869614704e68.jpg	\N	2026-10-29 00:08:33.268136+07	2026-10-29 00:08:33.268136+07	2026-10-29 00:08:33.268136+07	{"eTag": "\\"cb9cb73cba13a784b9e35d63b5d3f777\\"", "size": 130585, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-10-28T17:08:34.000Z", "contentLength": 130585, "httpStatusCode": 200}	0ab66545-127d-4ad9-88f1-9abc9199cf92	\N	{}	\N	f	f
a40b99f4-bddc-45ba-80e7-ecb1068df32f	uploads	menu/f6e2e451-5c1d-4616-b7a2-5b6886db2ad2.jpg	\N	2026-10-16 00:16:02.001109+07	2026-10-16 00:16:02.001109+07	2026-10-16 00:16:02.001109+07	{"eTag": "\\"f7b043f73229901acc3ec7929764942f\\"", "size": 21239, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-10-15T17:16:02.000Z", "contentLength": 21239, "httpStatusCode": 200}	e98d1073-4761-43ea-bbb6-68923e9b565e	\N	{}	\N	f	f
a9e72d74-c64e-4feb-93f9-fd5429b6d27e	uploads	tenants/f7f56372-a6b7-47fb-a4f4-121d40d45329.png	\N	2026-10-20 00:27:14.626058+07	2026-10-20 00:27:14.626058+07	2026-10-20 00:27:14.626058+07	{"eTag": "\\"7a738f17eaa505bf30294bd2bf980d69\\"", "size": 24132, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2026-10-19T17:27:15.000Z", "contentLength": 24132, "httpStatusCode": 200}	98e50e81-5c1f-40e0-90c1-9f2ef1417249	\N	{}	\N	f	f
5d8ab9f5-e5d5-486e-9251-01c4ff566bf5	uploads	menu/d2fa4625-b273-4946-84b2-bc5b81c8ed2a.png	\N	2026-10-29 00:10:23.452956+07	2026-10-29 00:10:23.452956+07	2026-10-29 00:10:23.452956+07	{"eTag": "\\"b4202086dae2c749e1a71dde74513afa\\"", "size": 384056, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2026-10-28T17:10:24.000Z", "contentLength": 384056, "httpStatusCode": 200}	6876339d-8342-4ed6-8dd5-d295e2375270	\N	{}	\N	f	f
c083d71e-b6c4-4a86-a231-740a103a44db	uploads	tenants/9ddc66ee-2019-45e1-99df-d7fae3da54d2.jpg	\N	2026-10-20 01:01:37.431327+07	2026-10-20 01:01:37.431327+07	2026-10-20 01:01:37.431327+07	{"eTag": "\\"8d585208df063e4a17ac1be177b00f28\\"", "size": 265722, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-10-19T18:01:38.000Z", "contentLength": 265722, "httpStatusCode": 200}	73a0bbe8-72cd-4aab-a8ca-5381e97ad053	\N	{}	\N	f	f
1b11cbd1-c0cb-4a62-b958-9fda91679c7b	uploads	qris/4f3acbd3-d129-4694-a90d-9a66c87992d3.jpg	\N	2026-10-20 01:11:37.065062+07	2026-10-20 01:11:37.065062+07	2026-10-20 01:11:37.065062+07	{"eTag": "\\"61204e6d69b111902369e24ea6b40e1c\\"", "size": 29418, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-10-19T18:11:38.000Z", "contentLength": 29418, "httpStatusCode": 200}	e04ca21f-4ef4-415b-a153-7e03e9a19ec1	\N	{}	\N	f	f
9b637039-4ae0-49c6-ae09-58266a79b5c5	uploads	menu/56c371c2-4acf-49c3-add4-5b3ea236ad3d.png	\N	2026-10-29 00:11:14.788365+07	2026-10-29 00:11:14.788365+07	2026-10-29 00:11:14.788365+07	{"eTag": "\\"1aae7ef5c38300ccbfdfed6d32a33685\\"", "size": 487823, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2026-10-28T17:11:15.000Z", "contentLength": 487823, "httpStatusCode": 200}	802e803d-1a03-4f1a-9750-34a08cc8b04a	\N	{}	\N	f	f
c37e5d41-66f6-4e84-b766-177c8adb30e3	uploads	qris/a3aca4f1-c471-4a54-b846-f24a40e232cd.jpg	\N	2026-10-23 23:45:08.94071+07	2026-10-23 23:45:08.94071+07	2026-10-23 23:45:08.94071+07	{"eTag": "\\"61204e6d69b111902369e24ea6b40e1c\\"", "size": 29418, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-10-23T16:45:09.000Z", "contentLength": 29418, "httpStatusCode": 200}	1f3fa56b-8344-494f-8a43-d7102120da7a	\N	{}	\N	f	f
18327f07-c9a5-4114-b06d-17b1e80d4794	uploads	qris/85a0fe26-6611-4014-901e-8fd6ca35696e.jpg	\N	2026-10-23 23:55:11.851289+07	2026-10-23 23:55:11.851289+07	2026-10-23 23:55:11.851289+07	{"eTag": "\\"61204e6d69b111902369e24ea6b40e1c\\"", "size": 29418, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-10-23T16:55:12.000Z", "contentLength": 29418, "httpStatusCode": 200}	044a538b-75cb-4674-9401-51713e03e394	\N	{}	\N	f	f
60e04537-0d27-43cf-9385-5ee660c0cf2e	uploads	menu/4c484d1e-5987-4d6b-b01d-d82b23507629.png	\N	2026-10-29 00:11:52.0149+07	2026-10-29 00:11:52.0149+07	2026-10-29 00:11:52.0149+07	{"eTag": "\\"1aae7ef5c38300ccbfdfed6d32a33685\\"", "size": 487823, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2026-10-28T17:11:52.000Z", "contentLength": 487823, "httpStatusCode": 200}	81e73be0-710a-4805-bcb1-7de664cd54f0	\N	{}	\N	f	f
c58dd6d3-47bb-4422-953c-7c980265c5e2	uploads	qris/4ad91b09-a2ed-40b3-aabc-96235bc05c4b.jpg	\N	2026-10-24 00:10:39.27543+07	2026-10-24 00:10:39.27543+07	2026-10-24 00:10:39.27543+07	{"eTag": "\\"61204e6d69b111902369e24ea6b40e1c\\"", "size": 29418, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-10-23T17:10:40.000Z", "contentLength": 29418, "httpStatusCode": 200}	dc36c7ee-a795-4150-be95-e9ea67f28968	\N	{}	\N	f	f
fe2fda1c-c33e-4c47-86ae-5ad2d62f3e62	uploads	menu/313b3b8a-4bbe-4692-b4a2-642c86569659.jpg	\N	2026-10-28 02:24:09.954724+07	2026-10-28 02:24:09.954724+07	2026-10-28 02:24:09.954724+07	{"eTag": "\\"d77b8a5bb7e1cb56d896abb56dc7d7c3\\"", "size": 133194, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-10-27T19:24:10.000Z", "contentLength": 133194, "httpStatusCode": 200}	ec225623-428b-4523-8494-6aef5c6d219d	\N	{}	\N	f	f
059bf170-0982-40e9-bee9-30875a1cfda8	uploads	tenants/872e6c07-54a2-4e4f-b822-8dd3e2020c5f.png	\N	2026-10-28 23:03:37.977671+07	2026-10-28 23:03:37.977671+07	2026-10-28 23:03:37.977671+07	{"eTag": "\\"da6c9283455377f45c32cc3b0c9bceba\\"", "size": 10778, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2026-10-28T16:03:38.000Z", "contentLength": 10778, "httpStatusCode": 200}	896138b0-fc01-4f7d-bedc-853da19935db	\N	{}	\N	f	f
4c9e28cb-3093-4df1-94ea-fc2e91aaf244	uploads	menu/52d92720-316e-4b00-9c23-a00c5be9ebf0.jpg	\N	2026-10-28 23:06:34.393883+07	2026-10-28 23:06:34.393883+07	2026-10-28 23:06:34.393883+07	{"eTag": "\\"d77b8a5bb7e1cb56d896abb56dc7d7c3\\"", "size": 133194, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-10-28T16:06:35.000Z", "contentLength": 133194, "httpStatusCode": 200}	2b0b1f37-41a2-40ad-b9d8-cbda0ed683b0	\N	{}	\N	f	f
e5d6c254-b149-49f2-8f26-b42ed0233be3	uploads	menu/1b3a8e6f-f5f4-44a4-bccc-44167fc1081a.png	\N	2026-10-28 23:08:19.649967+07	2026-10-28 23:08:19.649967+07	2026-10-28 23:08:19.649967+07	{"eTag": "\\"0b55085c4339a3da227964b1faee10ce\\"", "size": 851149, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2026-10-28T16:08:20.000Z", "contentLength": 851149, "httpStatusCode": 200}	91dfe77e-d36d-45a9-a30b-b7ae5b1c0086	\N	{}	\N	f	f
826b0439-1ca7-41e3-8597-14770ceafb22	uploads	menu/0f46a7e1-41b9-4ad0-be05-67ac13c9c1f0.png	\N	2026-10-29 00:09:04.413297+07	2026-10-29 00:09:04.413297+07	2026-10-29 00:09:04.413297+07	{"eTag": "\\"ac02b7207ab7c2fd1a609cfa7f6315d3\\"", "size": 348071, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2026-10-28T17:09:05.000Z", "contentLength": 348071, "httpStatusCode": 200}	054bc380-8905-4f86-a70c-edddc3b9fd32	\N	{}	\N	f	f
30353a8c-ab31-4d8f-b69c-87d60c6af741	uploads	menu/002c5e0b-3b18-48ee-954b-3e07a616856c.png	\N	2026-10-28 23:09:21.680105+07	2026-10-28 23:09:21.680105+07	2026-10-28 23:09:21.680105+07	{"eTag": "\\"eb661cea730f35e85043146fc231f68f\\"", "size": 775132, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2026-10-28T16:09:22.000Z", "contentLength": 775132, "httpStatusCode": 200}	861bd1c9-9080-4bda-8331-c1ebdacadd8a	\N	{}	\N	f	f
2b59f309-4244-4404-94da-6335547fbf46	uploads	menu/aec13522-f214-4b55-a200-1c2ffc0667ac.png	\N	2026-10-28 23:09:57.369795+07	2026-10-28 23:09:57.369795+07	2026-10-28 23:09:57.369795+07	{"eTag": "\\"b32ddc01e603e1ea8404ec9d8c02f10b\\"", "size": 814305, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2026-10-28T16:09:58.000Z", "contentLength": 814305, "httpStatusCode": 200}	eeb93975-9412-438f-badb-806acba02bba	\N	{}	\N	f	f
1f959841-aebd-4045-ad2f-6f5128d36f15	uploads	menu/fab3b866-5633-46a6-bd1b-eed2ffe2c0d3.png	\N	2026-10-29 00:09:28.858803+07	2026-10-29 00:09:28.858803+07	2026-10-29 00:09:28.858803+07	{"eTag": "\\"ac02b7207ab7c2fd1a609cfa7f6315d3\\"", "size": 348071, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2026-10-28T17:09:29.000Z", "contentLength": 348071, "httpStatusCode": 200}	aa8084d7-146f-4594-8bf7-e29483765161	\N	{}	\N	f	f
883ef59d-9167-4c0e-88ac-2b5aaa4b0b5b	uploads	menu/d098c54d-234d-4e5a-ba19-90b2399c97f7.png	\N	2026-10-28 23:11:59.332578+07	2026-10-28 23:11:59.332578+07	2026-10-28 23:11:59.332578+07	{"eTag": "\\"ac456c743c7ccbf2b904600140682c30\\"", "size": 897308, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2026-10-28T16:12:00.000Z", "contentLength": 897308, "httpStatusCode": 200}	9e988b5a-3e83-437a-b029-486c46fa78c1	\N	{}	\N	f	f
d3140f1e-3440-4ec2-885f-33f93fe0c241	uploads	menu/2bcca085-79ef-49f1-9b70-7586daf02da1.png	\N	2026-10-28 23:14:05.742342+07	2026-10-28 23:14:05.742342+07	2026-10-28 23:14:05.742342+07	{"eTag": "\\"ac456c743c7ccbf2b904600140682c30\\"", "size": 897308, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2026-10-28T16:14:06.000Z", "contentLength": 897308, "httpStatusCode": 200}	f4986f34-4874-4b24-80e3-90ac88ccab0a	\N	{}	\N	f	f
430c315c-599f-41cd-a29f-f93d5a238b81	uploads	menu/9273752c-479f-47b2-99fd-04d71a4ef854.png	\N	2026-10-29 00:09:53.232504+07	2026-10-29 00:09:53.232504+07	2026-10-29 00:09:53.232504+07	{"eTag": "\\"b4202086dae2c749e1a71dde74513afa\\"", "size": 384056, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2026-10-28T17:09:54.000Z", "contentLength": 384056, "httpStatusCode": 200}	6d0bfb27-caa8-4b8b-a40a-eae54f171ddd	\N	{}	\N	f	f
5840011e-5333-4199-ac12-f7928a16acc5	uploads	menu/10576ddf-ded6-45f5-aa08-1f36ab40b517.jpg	\N	2026-10-28 23:20:54.288959+07	2026-10-28 23:20:54.288959+07	2026-10-28 23:20:54.288959+07	{"eTag": "\\"ef55cd1da37cd2d213c321084f28ffd3\\"", "size": 124094, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-10-28T16:20:55.000Z", "contentLength": 124094, "httpStatusCode": 200}	468eb01a-8bab-4750-a1f6-0aaf8035b2e8	\N	{}	\N	f	f
caf4e23b-838f-4074-a6a7-d4f4e5bac9fc	uploads	menu/6abf3e81-2771-438a-ae10-9f7e97ffac89.png	\N	2026-10-28 23:28:36.171072+07	2026-10-28 23:28:36.171072+07	2026-10-28 23:28:36.171072+07	{"eTag": "\\"b6256976e8e3569fb6829eed6454e39b\\"", "size": 1149836, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2026-10-28T16:28:37.000Z", "contentLength": 1149836, "httpStatusCode": 200}	8652d913-14bb-438e-9848-70edd1b4eab9	\N	{}	\N	f	f
9b4ea819-e38d-4e3f-a374-04b686552c5d	uploads	menu/00baae83-4b76-420d-888f-0f511f3f2ef5.png	\N	2026-10-29 02:01:18.651165+07	2026-10-29 02:01:18.651165+07	2026-10-29 02:01:18.651165+07	{"eTag": "\\"83425eb4efc1872c9675e607c020fbda\\"", "size": 1264423, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2026-10-28T19:01:19.000Z", "contentLength": 1264423, "httpStatusCode": 200}	4853d059-f675-4593-bd0f-431892df7eda	\N	{}	\N	f	f
b8de6262-3678-455d-ba13-6294206e2e7f	uploads	menu/12916880-6810-41fb-ad49-3427d3254b13.png	\N	2026-10-28 23:29:37.045905+07	2026-10-28 23:29:37.045905+07	2026-10-28 23:29:37.045905+07	{"eTag": "\\"cd397eddc06ba76f261fa6c081681564\\"", "size": 1143308, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2026-10-28T16:29:38.000Z", "contentLength": 1143308, "httpStatusCode": 200}	a7be7e3e-625b-4361-aef3-f64852308de6	\N	{}	\N	f	f
e2a61808-7a4e-498c-80e0-2970cca087b9	uploads	menu/97aaf187-0f44-4af8-b7c3-368ea090c714.png	\N	2026-10-28 23:30:22.784873+07	2026-10-28 23:30:22.784873+07	2026-10-28 23:30:22.784873+07	{"eTag": "\\"8d15fbf487c8e7f6a2b7c5ad4714e765\\"", "size": 1020547, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2026-10-28T16:30:23.000Z", "contentLength": 1020547, "httpStatusCode": 200}	697acc01-d0be-48dd-badf-f847310f2ee3	\N	{}	\N	f	f
6d5e28e2-23ba-433f-9a79-89e2a0cc0cad	uploads	menu/ba4a059e-552e-4170-a1e3-cc6cb33b3499.png	\N	2026-10-28 23:31:14.379876+07	2026-10-28 23:31:14.379876+07	2026-10-28 23:31:14.379876+07	{"eTag": "\\"cecc9fe17d4d6b4df1067062894720ce\\"", "size": 1172169, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2026-10-28T16:31:15.000Z", "contentLength": 1172169, "httpStatusCode": 200}	31547de3-88c9-4251-80d7-40193b7a541e	\N	{}	\N	f	f
c26fb4de-fc67-4b02-8cc7-f15eeaeefc85	uploads	menu/00bbca05-ff0e-4a52-b33c-f097d5f21b70.png	\N	2026-10-29 00:12:27.413474+07	2026-10-29 00:12:27.413474+07	2026-10-29 00:12:27.413474+07	{"eTag": "\\"1aae7ef5c38300ccbfdfed6d32a33685\\"", "size": 487823, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2026-10-28T17:12:28.000Z", "contentLength": 487823, "httpStatusCode": 200}	77b23b5e-aec9-46df-98f2-bfc9946421ec	\N	{}	\N	f	f
dd76b071-6bb5-4f28-8582-40c7aca61de5	uploads	menu/bb1cd64c-c763-44ba-967b-d7a9dd786b85.png	\N	2026-10-28 23:31:42.94743+07	2026-10-28 23:31:42.94743+07	2026-10-28 23:31:42.94743+07	{"eTag": "\\"cecc9fe17d4d6b4df1067062894720ce\\"", "size": 1172169, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2026-10-28T16:31:43.000Z", "contentLength": 1172169, "httpStatusCode": 200}	8bec451f-9770-45f2-8b61-d1d1505b348d	\N	{}	\N	f	f
67ce44cd-e041-44ac-81d6-832a1ae9d4ef	uploads	menu/68515861-cac8-4137-bcb6-4aee4f1083bc.jpg	\N	2026-10-28 23:35:56.465364+07	2026-10-28 23:35:56.465364+07	2026-10-28 23:35:56.465364+07	{"eTag": "\\"ba84e876bbb0ccc9e1763bc40204b9e6\\"", "size": 134406, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-10-28T16:35:57.000Z", "contentLength": 134406, "httpStatusCode": 200}	6af614a4-634f-49c4-a2e9-cfdf011e2196	\N	{}	\N	f	f
0203efcd-a396-4e3a-b437-f2fb2aa6e5db	uploads	menu/193ce1c9-08b8-4ac3-840e-502d58e00fd0.png	\N	2026-10-29 00:13:56.718856+07	2026-10-29 00:13:56.718856+07	2026-10-29 00:13:56.718856+07	{"eTag": "\\"57690cacb497956bbe0c0b009afe41dc\\"", "size": 432292, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2026-10-28T17:13:57.000Z", "contentLength": 432292, "httpStatusCode": 200}	05f38d55-b24e-46fc-90ac-e77c6c960a2b	\N	{}	\N	f	f
fac3f689-91c9-41ed-9a14-1176c3369e4a	uploads	menu/6fc61063-9fed-4082-885d-18b5345349b8.png	\N	2026-10-28 23:40:05.035775+07	2026-10-28 23:40:05.035775+07	2026-10-28 23:40:05.035775+07	{"eTag": "\\"58ff0635dba4ef8c268e961eafb130c6\\"", "size": 538525, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2026-10-28T16:40:05.000Z", "contentLength": 538525, "httpStatusCode": 200}	047e1ea5-c9dd-4033-8b7b-f5f120581358	\N	{}	\N	f	f
e2d81d23-be23-459e-879d-6c027dd1414e	uploads	menu/e41dbd9d-dc9b-4fe9-a352-a19817b6474f.png	\N	2026-10-28 23:40:45.400258+07	2026-10-28 23:40:45.400258+07	2026-10-28 23:40:45.400258+07	{"eTag": "\\"b259afe53910bc93621b676e6a7b91cc\\"", "size": 644206, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2026-10-28T16:40:46.000Z", "contentLength": 644206, "httpStatusCode": 200}	2837d2fa-8357-4187-8a46-b9f9131261b4	\N	{}	\N	f	f
80ce3f02-a83a-4364-9949-953234877eb4	uploads	menu/6d2db1b6-7cdd-4924-a8ad-6811bcb8d355.jpg	\N	2026-10-29 00:17:49.470347+07	2026-10-29 00:17:49.470347+07	2026-10-29 00:17:49.470347+07	{"eTag": "\\"d6eea5bbd99c274c386eb36ea2d86351\\"", "size": 124600, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-10-28T17:17:50.000Z", "contentLength": 124600, "httpStatusCode": 200}	4169d970-9ab1-41c8-8b0c-e42ef413fd44	\N	{}	\N	f	f
b21205e1-b98a-4d5a-8a3f-8e1ba497137f	uploads	menu/b37a9b6d-5516-4685-b3de-10c2b2ff5b65.png	\N	2026-10-28 23:41:49.207061+07	2026-10-28 23:41:49.207061+07	2026-10-28 23:41:49.207061+07	{"eTag": "\\"fcd25c07f1ba4011854c78c9287859f1\\"", "size": 359956, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2026-10-28T16:41:50.000Z", "contentLength": 359956, "httpStatusCode": 200}	c3cd185d-d18c-408a-afec-02de236f181f	\N	{}	\N	f	f
cfaa748c-eca2-4d49-a88c-92a7d4a28bb2	uploads	menu/c6c70227-ec91-442b-90bc-0be2ec79dd21.png	\N	2026-10-28 23:42:29.831606+07	2026-10-28 23:42:29.831606+07	2026-10-28 23:42:29.831606+07	{"eTag": "\\"bdc6496a69b264e0fadb2af84cab597b\\"", "size": 419592, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2026-10-28T16:42:30.000Z", "contentLength": 419592, "httpStatusCode": 200}	9c5ba1cc-a081-48b7-98c9-f036fa89eda5	\N	{}	\N	f	f
46f1e3b3-a513-4955-8534-243ae77ec3c3	uploads	menu/1755bf29-7a70-4e68-a459-3714d0b422e2.png	\N	2026-10-29 00:18:51.279589+07	2026-10-29 00:18:51.279589+07	2026-10-29 00:18:51.279589+07	{"eTag": "\\"09bb059f954e6389f95dfd164e895bc4\\"", "size": 122245, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2026-10-28T17:18:52.000Z", "contentLength": 122245, "httpStatusCode": 200}	fde986ae-c635-4ec9-8dd7-9585673022ab	\N	{}	\N	f	f
27a9bc79-ef1e-43ff-a3c1-a0da247b8ced	uploads	menu/4e64d155-8973-44af-9ad2-f4679646e729.jpg	\N	2026-10-28 23:49:03.695745+07	2026-10-28 23:49:03.695745+07	2026-10-28 23:49:03.695745+07	{"eTag": "\\"dd0e580742742bb1c8b39cad9b0735cc\\"", "size": 123618, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-10-28T16:49:04.000Z", "contentLength": 123618, "httpStatusCode": 200}	626f7850-c64f-4ee7-88ce-f5ae0d84a9ee	\N	{}	\N	f	f
554fe382-084b-45d9-b5ee-1474cf0be60a	uploads	menu/01161ac6-9079-4987-8a11-bbc99892001c.png	\N	2026-10-28 23:49:52.515442+07	2026-10-28 23:49:52.515442+07	2026-10-28 23:49:52.515442+07	{"eTag": "\\"0b01fcfe6158574a2fda3a93034e7511\\"", "size": 266787, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2026-10-28T16:49:53.000Z", "contentLength": 266787, "httpStatusCode": 200}	6fa47000-9d94-4593-be04-a5bc1ab0c749	\N	{}	\N	f	f
ee2fecbc-05ce-412a-a9e5-f021f1a27037	uploads	menu/942da5d3-e5bb-494e-90f8-ca532a2c0951.png	\N	2026-10-28 23:50:33.323091+07	2026-10-28 23:50:33.323091+07	2026-10-28 23:50:33.323091+07	{"eTag": "\\"956ffc008fae5b90d7540675aa630157\\"", "size": 256653, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2026-10-28T16:50:34.000Z", "contentLength": 256653, "httpStatusCode": 200}	de976429-cce4-4dee-9311-382d99458832	\N	{}	\N	f	f
1c6ccf77-dcbf-449d-8e31-16c946ee9da5	uploads	menu/054f333f-3d19-464b-8441-a2a2e540b6cb.png	\N	2026-10-28 23:51:13.438458+07	2026-10-28 23:51:13.438458+07	2026-10-28 23:51:13.438458+07	{"eTag": "\\"2b983afbcec8f0957bb79c17f11ed696\\"", "size": 233092, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2026-10-28T16:51:14.000Z", "contentLength": 233092, "httpStatusCode": 200}	57fe71e6-4f95-4fcf-9431-c5cfb728900e	\N	{}	\N	f	f
4522d8c0-1ac6-4d94-abe5-b37e4f3fda9b	uploads	menu/c1cf2dd8-b9e5-48cc-9bba-1ce1ab7ee570.png	\N	2026-10-29 00:19:39.69107+07	2026-10-29 00:19:39.69107+07	2026-10-29 00:19:39.69107+07	{"eTag": "\\"09bb059f954e6389f95dfd164e895bc4\\"", "size": 122245, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2026-10-28T17:19:40.000Z", "contentLength": 122245, "httpStatusCode": 200}	05392a3a-c311-4152-902a-728c26dd8cdf	\N	{}	\N	f	f
a4fa7488-a9f4-4201-a736-afad0a3f7ad4	uploads	menu/d4325060-d482-4662-8eae-d99547224156.png	\N	2026-10-28 23:52:04.692001+07	2026-10-28 23:52:04.692001+07	2026-10-28 23:52:04.692001+07	{"eTag": "\\"2cc17146420685d3d72a3b7a8956ab4c\\"", "size": 250043, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2026-10-28T16:52:05.000Z", "contentLength": 250043, "httpStatusCode": 200}	a7589efb-904a-4fd9-89ef-68f726887a2f	\N	{}	\N	f	f
6defe8d8-dd66-4e3f-a13e-51d51dd9d314	uploads	menu/6157a733-c1f8-4b0e-aaba-e73327fe32a5.png	\N	2026-10-28 23:52:43.919356+07	2026-10-28 23:52:43.919356+07	2026-10-28 23:52:43.919356+07	{"eTag": "\\"3d1e2c287f9574fccb8bd2e8eb360270\\"", "size": 266237, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2026-10-28T16:52:44.000Z", "contentLength": 266237, "httpStatusCode": 200}	4096faef-a176-46f5-bcbf-f422d51c016b	\N	{}	\N	f	f
3dba8a91-fc91-4741-b99a-8548f5bdd95a	uploads	menu/787e4abf-6f02-41a4-a542-87f15a8fd9d1.png	\N	2026-10-29 00:21:07.395257+07	2026-10-29 00:21:07.395257+07	2026-10-29 00:21:07.395257+07	{"eTag": "\\"fec1b6e3f11370e0d6d1b87beb7d20bf\\"", "size": 390678, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2026-10-28T17:21:08.000Z", "contentLength": 390678, "httpStatusCode": 200}	5a5753ed-61fd-43ac-9c59-89d1e9a4b44c	\N	{}	\N	f	f
6c2977de-bfbe-4785-b54a-3bb7e1fe1989	uploads	menu/1c2f291a-3199-43bd-81d8-cd5e7895cfed.png	\N	2026-10-28 23:53:21.85459+07	2026-10-28 23:53:21.85459+07	2026-10-28 23:53:21.85459+07	{"eTag": "\\"ce1b687e194790134ae56af206b62b3f\\"", "size": 254381, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2026-10-28T16:53:22.000Z", "contentLength": 254381, "httpStatusCode": 200}	0d67c96a-b6c0-41ad-9cb4-0a351ceea058	\N	{}	\N	f	f
4c135282-ad09-454e-9463-da47e88c76df	uploads	menu/9e0b9465-ec91-4d25-9323-93df1460b1ff.jpg	\N	2026-10-29 00:01:03.261535+07	2026-10-29 00:01:03.261535+07	2026-10-29 00:01:03.261535+07	{"eTag": "\\"415a3814044c891fd9632c96f76bceb5\\"", "size": 126384, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-10-28T17:01:04.000Z", "contentLength": 126384, "httpStatusCode": 200}	f8597046-5075-4ab1-a930-7a3f2c73ed06	\N	{}	\N	f	f
d76d78e2-201f-40f5-85f3-ca39abada5ed	uploads	menu/945715e0-74b9-4ae1-b28e-c8da6f4284b9.png	\N	2026-10-29 00:22:03.433915+07	2026-10-29 00:22:03.433915+07	2026-10-29 00:22:03.433915+07	{"eTag": "\\"fec1b6e3f11370e0d6d1b87beb7d20bf\\"", "size": 390678, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2026-10-28T17:22:04.000Z", "contentLength": 390678, "httpStatusCode": 200}	bf75a7d5-cfd3-49c4-900b-712aa41bb91a	\N	{}	\N	f	f
cb123c5e-bd96-49fe-a866-dfc5098edf6b	uploads	menu/2431ac12-0e3f-41de-81e8-0e6f9b625e53.png	\N	2026-10-29 00:01:39.400844+07	2026-10-29 00:01:39.400844+07	2026-10-29 00:01:39.400844+07	{"eTag": "\\"8f53491a85badcd45c2466cefb8895dc\\"", "size": 351666, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2026-10-28T17:01:40.000Z", "contentLength": 351666, "httpStatusCode": 200}	299a2642-bdaf-4b98-9179-81130c441e9e	\N	{}	\N	f	f
31d86e5a-d6db-4ae6-8109-19491ea3a0b5	uploads	menu/52903915-f4a5-495a-99a5-1980d5b556c0.png	\N	2026-10-29 00:02:06.497703+07	2026-10-29 00:02:06.497703+07	2026-10-29 00:02:06.497703+07	{"eTag": "\\"89cff25a28789beadcf298438e85d0ad\\"", "size": 368389, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2026-10-28T17:02:07.000Z", "contentLength": 368389, "httpStatusCode": 200}	b047ed13-c37e-4fcf-af2d-a6effa32945d	\N	{}	\N	f	f
3b3d0471-91b1-4cb2-a66e-acdad60e59fd	uploads	menu/6c663b01-3b47-4ff7-98d7-d923ac95f693.png	\N	2026-10-29 00:22:52.365995+07	2026-10-29 00:22:52.365995+07	2026-10-29 00:22:52.365995+07	{"eTag": "\\"346b81be6ceded492c3dbd7762093b33\\"", "size": 370458, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2026-10-28T17:22:53.000Z", "contentLength": 370458, "httpStatusCode": 200}	b2e0189f-8644-4803-9bdc-53e778e876ee	\N	{}	\N	f	f
d96c33b7-716e-40ea-b8e0-43aa07ad2f6c	uploads	menu/51509b5a-279f-4fdc-95da-0a01fe5cf28a.png	\N	2026-10-29 00:02:47.779009+07	2026-10-29 00:02:47.779009+07	2026-10-29 00:02:47.779009+07	{"eTag": "\\"cb71197a276a18a503f0988341b84d80\\"", "size": 240356, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2026-10-28T17:02:48.000Z", "contentLength": 240356, "httpStatusCode": 200}	8247e7e5-ec22-453a-9a35-11d0be7b2e7e	\N	{}	\N	f	f
a5f210e7-0975-4b8d-b434-580cf5ec7ac3	uploads	menu/d481605a-9eeb-49aa-a53a-15233e92bfed.png	\N	2026-10-29 00:03:13.712825+07	2026-10-29 00:03:13.712825+07	2026-10-29 00:03:13.712825+07	{"eTag": "\\"4b9440bf6b8a342214c3ec191201d973\\"", "size": 270126, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2026-10-28T17:03:14.000Z", "contentLength": 270126, "httpStatusCode": 200}	58fd11f8-6dff-49e6-91f6-ef0be4f51157	\N	{}	\N	f	f
956912ef-00ae-4589-be81-0c7545040353	uploads	menu/ad025e7d-ecdc-4916-aa03-6c6c39eeed04.png	\N	2026-10-29 00:03:47.372561+07	2026-10-29 00:03:47.372561+07	2026-10-29 00:03:47.372561+07	{"eTag": "\\"97afe97f1906adc2d9f51d12d5f11113\\"", "size": 227436, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2026-10-28T17:03:48.000Z", "contentLength": 227436, "httpStatusCode": 200}	5c0afebc-c7cf-47dc-8bdd-fd3752058f6b	\N	{}	\N	f	f
6fb0e754-40cc-4924-8347-150eabda772e	uploads	menu/acf25aa8-34a0-49c3-8c13-c4e276a2eeb9.jpg	\N	2026-10-29 00:07:57.284439+07	2026-10-29 00:07:57.284439+07	2026-10-29 00:07:57.284439+07	{"eTag": "\\"cb9cb73cba13a784b9e35d63b5d3f777\\"", "size": 130585, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-10-28T17:07:58.000Z", "contentLength": 130585, "httpStatusCode": 200}	49645ed8-995e-4a2d-a3dd-aebca6561b4a	\N	{}	\N	f	f
0191a2db-0b1d-439f-9527-2ff316c8bc30	uploads	menu/fc86d4cb-0261-4900-8e36-c6cfca4cb70a.png	\N	2026-10-29 00:23:59.915848+07	2026-10-29 00:23:59.915848+07	2026-10-29 00:23:59.915848+07	{"eTag": "\\"346b81be6ceded492c3dbd7762093b33\\"", "size": 370458, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2026-10-28T17:24:00.000Z", "contentLength": 370458, "httpStatusCode": 200}	18ad6911-26cc-4c4a-a5e1-e54ee1d064fb	\N	{}	\N	f	f
3bcb46e6-0807-435c-b76a-227499cc330e	uploads	menu/c5aa30bd-5d11-44d0-b4e3-ab90115c8cab.png	\N	2026-10-29 00:24:35.971784+07	2026-10-29 00:24:35.971784+07	2026-10-29 00:24:35.971784+07	{"eTag": "\\"fcb8da7dfa8a0962a4a20b7bfb55f138\\"", "size": 397193, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2026-10-28T17:24:36.000Z", "contentLength": 397193, "httpStatusCode": 200}	2ae96db6-4ca0-405d-b30b-3309af9e4792	\N	{}	\N	f	f
18c2b1e9-cc17-4820-95e7-2e22aebed9c2	uploads	menu/91939c21-be8e-4302-b7e4-d448930af25b.png	\N	2026-10-29 00:34:27.684262+07	2026-10-29 00:34:27.684262+07	2026-10-29 00:34:27.684262+07	{"eTag": "\\"f58f6ec74fe48fc30d52e3bb6f548ac1\\"", "size": 388934, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2026-10-28T17:34:28.000Z", "contentLength": 388934, "httpStatusCode": 200}	2536e31c-adef-4a23-84d9-602d959806d4	\N	{}	\N	f	f
450088ad-d3a4-4eb9-a180-72ef47a37685	uploads	menu/2068e71a-adba-46a4-ae6c-575e77e17465.jpg	\N	2026-10-29 00:35:14.079366+07	2026-10-29 00:35:14.079366+07	2026-10-29 00:35:14.079366+07	{"eTag": "\\"e81c03a9a77145daeaa84422a3ee8b9f\\"", "size": 77859, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-10-28T17:35:14.000Z", "contentLength": 77859, "httpStatusCode": 200}	4220facf-534b-4304-ac5e-de2d1480a9d2	\N	{}	\N	f	f
efd4687c-7cea-4d7f-ba60-08b663ebef26	uploads	menu/3b09282f-1b32-4119-89f4-24f226f86e04.jpg	\N	2026-10-29 03:00:23.471034+07	2026-10-29 03:00:23.471034+07	2026-10-29 03:00:23.471034+07	{"eTag": "\\"83425eb4efc1872c9675e607c020fbda\\"", "size": 1264423, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-10-28T20:00:24.000Z", "contentLength": 1264423, "httpStatusCode": 200}	3a09ec5d-6cd9-4389-8247-5e9f1278c200	\N	{}	\N	f	f
2311e156-2a16-42a5-a379-e894ce9f42eb	uploads	menu/e5e983d2-92fd-4b38-9910-c76e788397ef.jpg	\N	2026-10-29 03:00:25.51203+07	2026-10-29 03:00:25.51203+07	2026-10-29 03:00:25.51203+07	{"eTag": "\\"83425eb4efc1872c9675e607c020fbda\\"", "size": 1264423, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-10-28T20:00:26.000Z", "contentLength": 1264423, "httpStatusCode": 200}	285228f9-53b2-4c3c-a7c9-7a833f21715f	\N	{}	\N	f	f
c077b655-2808-426f-8a41-ad02e23bf4e1	uploads	menu/681bc2d8-98ec-43a9-a27e-85ec256d9712.jpg	\N	2026-10-29 03:00:27.60826+07	2026-10-29 03:00:27.60826+07	2026-10-29 03:00:27.60826+07	{"eTag": "\\"83425eb4efc1872c9675e607c020fbda\\"", "size": 1264423, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-10-28T20:00:28.000Z", "contentLength": 1264423, "httpStatusCode": 200}	e5ca803d-bba0-41ae-8787-66627cc2e42d	\N	{}	\N	f	f
53c760cd-5a95-4eb5-a6db-99ae10dcefd3	uploads	menu/988a2bfe-c496-41ce-9250-0d9b9bb27f85.jpg	\N	2026-10-29 03:00:30.19363+07	2026-10-29 03:00:30.19363+07	2026-10-29 03:00:30.19363+07	{"eTag": "\\"83425eb4efc1872c9675e607c020fbda\\"", "size": 1264423, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-10-28T20:00:31.000Z", "contentLength": 1264423, "httpStatusCode": 200}	3becd7d1-1f13-4be1-ada2-1cbf5833d1de	\N	{}	\N	f	f
2270ab75-aa83-47fa-8f45-6461b305fcdf	uploads	menu/4cac14bc-aa6c-4d18-a959-23b48aa6da95.jpg	\N	2026-10-29 03:00:32.438584+07	2026-10-29 03:00:32.438584+07	2026-10-29 03:00:32.438584+07	{"eTag": "\\"83425eb4efc1872c9675e607c020fbda\\"", "size": 1264423, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-10-28T20:00:33.000Z", "contentLength": 1264423, "httpStatusCode": 200}	86870002-4b01-4059-8023-fa9d6674d434	\N	{}	\N	f	f
2436e733-c8d2-4e62-8927-06a27a40cfd1	uploads	menu/72f6ec41-3ca1-4fa8-8c36-accda6f8b167.jpg	\N	2026-10-29 03:00:34.825284+07	2026-10-29 03:00:34.825284+07	2026-10-29 03:00:34.825284+07	{"eTag": "\\"83425eb4efc1872c9675e607c020fbda\\"", "size": 1264423, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-10-28T20:00:35.000Z", "contentLength": 1264423, "httpStatusCode": 200}	f119e9ea-cd79-4b36-8079-4355ec9aa030	\N	{}	\N	f	f
addd16eb-5eb7-418a-aa0f-d5e46815674e	uploads	menu/7b45c8d5-d9a1-4175-96c1-9a8f3eed9eb5.jpg	\N	2026-10-29 03:00:36.723757+07	2026-10-29 03:00:36.723757+07	2026-10-29 03:00:36.723757+07	{"eTag": "\\"83425eb4efc1872c9675e607c020fbda\\"", "size": 1264423, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-10-28T20:00:37.000Z", "contentLength": 1264423, "httpStatusCode": 200}	d2bfe9d8-1dc7-485c-8e1f-a235f889418f	\N	{}	\N	f	f
074e4909-4242-4963-a0cd-7bbcc44b5333	uploads	menu/386633fb-a598-4528-bcee-cbea4bdfbdbd.jpg	\N	2026-10-29 03:00:38.671272+07	2026-10-29 03:00:38.671272+07	2026-10-29 03:00:38.671272+07	{"eTag": "\\"83425eb4efc1872c9675e607c020fbda\\"", "size": 1264423, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-10-28T20:00:39.000Z", "contentLength": 1264423, "httpStatusCode": 200}	b3c05999-07a6-404c-83fd-01c08719f332	\N	{}	\N	f	f
ea31ef68-1d56-4dca-869d-ca12a7298000	uploads	menu/89fd8837-8c78-4d7f-8460-fde87cb45577.jpg	\N	2026-10-29 03:00:53.340569+07	2026-10-29 03:00:53.340569+07	2026-10-29 03:00:53.340569+07	{"eTag": "\\"83425eb4efc1872c9675e607c020fbda\\"", "size": 1264423, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-10-28T20:00:54.000Z", "contentLength": 1264423, "httpStatusCode": 200}	348379ce-acf0-43ec-886e-ca47d59f0426	\N	{}	\N	f	f
dfa76039-a8e2-4c25-8935-6093ccb739db	uploads	menu/1487547d-7878-463b-9986-c160e5884d05.jpg	\N	2026-10-29 03:00:54.957934+07	2026-10-29 03:00:54.957934+07	2026-10-29 03:00:54.957934+07	{"eTag": "\\"83425eb4efc1872c9675e607c020fbda\\"", "size": 1264423, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-10-28T20:00:55.000Z", "contentLength": 1264423, "httpStatusCode": 200}	74529cf0-5683-4529-b301-e3a63cbcaec2	\N	{}	\N	f	f
570fa9b4-1835-4456-a298-85e37e1b7cd8	uploads	menu/5aeb96f7-62ab-4c4b-9ee7-7671c3e50f13.jpg	\N	2026-10-29 03:00:59.174412+07	2026-10-29 03:00:59.174412+07	2026-10-29 03:00:59.174412+07	{"eTag": "\\"83425eb4efc1872c9675e607c020fbda\\"", "size": 1264423, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-10-28T20:01:00.000Z", "contentLength": 1264423, "httpStatusCode": 200}	09fd7845-20b8-46b4-b20d-33ecfa0463ef	\N	{}	\N	f	f
35e897db-73ea-44f0-9cd2-03b32027c8f4	uploads	menu/2c1d02c6-818e-42b7-a044-613eda130bd8.jpg	\N	2026-10-29 03:00:40.663885+07	2026-10-29 03:00:40.663885+07	2026-10-29 03:00:40.663885+07	{"eTag": "\\"83425eb4efc1872c9675e607c020fbda\\"", "size": 1264423, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-10-28T20:00:41.000Z", "contentLength": 1264423, "httpStatusCode": 200}	39175f13-c5b5-4d06-99a7-85c35ffda26f	\N	{}	\N	f	f
46790f39-cddc-4cc7-a681-a5bba87df0f4	uploads	menu/408c41a8-d77b-49a1-87c3-f7790d755c5c.jpg	\N	2026-10-29 03:00:42.85688+07	2026-10-29 03:00:42.85688+07	2026-10-29 03:00:42.85688+07	{"eTag": "\\"83425eb4efc1872c9675e607c020fbda\\"", "size": 1264423, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-10-28T20:00:43.000Z", "contentLength": 1264423, "httpStatusCode": 200}	8e24c523-da0c-49c9-b0fe-d406a9927d86	\N	{}	\N	f	f
a53fa32c-fd51-4f99-8825-f118ca89991d	uploads	menu/b680888f-88a8-4ad3-b326-8babcc73a7cb.jpg	\N	2026-10-29 03:00:44.595778+07	2026-10-29 03:00:44.595778+07	2026-10-29 03:00:44.595778+07	{"eTag": "\\"83425eb4efc1872c9675e607c020fbda\\"", "size": 1264423, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-10-28T20:00:45.000Z", "contentLength": 1264423, "httpStatusCode": 200}	4b07a5e9-c880-4d55-b634-7f687a6005b3	\N	{}	\N	f	f
f47c6765-4e8f-4cff-a972-faeeb58b8e7c	uploads	menu/99a8c4af-94da-4d64-b67e-7f8dc7865a5b.jpg	\N	2026-10-29 03:00:46.246768+07	2026-10-29 03:00:46.246768+07	2026-10-29 03:00:46.246768+07	{"eTag": "\\"83425eb4efc1872c9675e607c020fbda\\"", "size": 1264423, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-10-28T20:00:47.000Z", "contentLength": 1264423, "httpStatusCode": 200}	c52de846-b756-4811-b524-198522a599c7	\N	{}	\N	f	f
78c6e37f-25ee-448d-828e-3ad89c53dd20	uploads	menu/a7afe5ac-ec36-427c-8c90-ff8654227d13.jpg	\N	2026-10-29 03:00:47.642122+07	2026-10-29 03:00:47.642122+07	2026-10-29 03:00:47.642122+07	{"eTag": "\\"83425eb4efc1872c9675e607c020fbda\\"", "size": 1264423, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-10-28T20:00:48.000Z", "contentLength": 1264423, "httpStatusCode": 200}	b937449e-0c32-486c-957f-98d80b950bda	\N	{}	\N	f	f
9ca5bb1c-5794-4e8c-be16-5eda782c5d7e	uploads	menu/3b4c1e9e-7a5a-41f5-9c8f-a021d4c7f46a.jpg	\N	2026-10-29 03:00:49.344712+07	2026-10-29 03:00:49.344712+07	2026-10-29 03:00:49.344712+07	{"eTag": "\\"83425eb4efc1872c9675e607c020fbda\\"", "size": 1264423, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-10-28T20:00:50.000Z", "contentLength": 1264423, "httpStatusCode": 200}	fa48b0c5-effa-404c-864a-644ba43a397e	\N	{}	\N	f	f
76d7f343-b5ba-4b5d-92ac-bd1d4a02d79f	uploads	menu/6096a53a-5f39-40c2-96b8-9436439426b6.jpg	\N	2026-10-29 03:00:51.248395+07	2026-10-29 03:00:51.248395+07	2026-10-29 03:00:51.248395+07	{"eTag": "\\"83425eb4efc1872c9675e607c020fbda\\"", "size": 1264423, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-10-28T20:00:52.000Z", "contentLength": 1264423, "httpStatusCode": 200}	0141f3e4-0748-4e99-bdb3-f09d08361a9d	\N	{}	\N	f	f
082caaa0-aff9-41e4-acc8-4f4af524b626	uploads	menu/580cd905-a4e9-4520-88bb-56c445a21405.jpg	\N	2026-10-29 03:00:57.119456+07	2026-10-29 03:00:57.119456+07	2026-10-29 03:00:57.119456+07	{"eTag": "\\"83425eb4efc1872c9675e607c020fbda\\"", "size": 1264423, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-10-28T20:00:58.000Z", "contentLength": 1264423, "httpStatusCode": 200}	ec9b5a8b-4f71-4969-b817-711169579f0c	\N	{}	\N	f	f
1c872402-6c43-444a-9887-284af3abee0a	uploads	menu/18dd3e57-9c7d-41f8-b8f4-2df06576ca2f.jpg	\N	2026-10-29 03:01:00.9421+07	2026-10-29 03:01:00.9421+07	2026-10-29 03:01:00.9421+07	{"eTag": "\\"83425eb4efc1872c9675e607c020fbda\\"", "size": 1264423, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-10-28T20:01:01.000Z", "contentLength": 1264423, "httpStatusCode": 200}	98055d0c-4e1e-4593-9e12-e36dc524f02f	\N	{}	\N	f	f
d0c76ee3-eef6-409d-a867-603395db20bb	uploads	menu/363dd776-4292-444b-9b8a-829af67604ac.jpg	\N	2026-10-29 03:01:03.173677+07	2026-10-29 03:01:03.173677+07	2026-10-29 03:01:03.173677+07	{"eTag": "\\"83425eb4efc1872c9675e607c020fbda\\"", "size": 1264423, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-10-28T20:01:04.000Z", "contentLength": 1264423, "httpStatusCode": 200}	1b65cae3-f02d-47c0-9e46-2730992ad23a	\N	{}	\N	f	f
9f158df9-be9c-4cd3-9fa5-e197f87f979e	uploads	menu/c2fd6b3e-21bd-462e-a1ea-387bb11f81db.jpg	\N	2026-10-29 03:01:05.388671+07	2026-10-29 03:01:05.388671+07	2026-10-29 03:01:05.388671+07	{"eTag": "\\"83425eb4efc1872c9675e607c020fbda\\"", "size": 1264423, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-10-28T20:01:06.000Z", "contentLength": 1264423, "httpStatusCode": 200}	fbdd15a8-52ed-4b63-a145-1622861d3288	\N	{}	\N	f	f
c8239f7f-b0e4-4311-a5a8-3f011cfba3b9	uploads	menu/0862718b-4105-4d0b-bd06-ea1b6d30e2ec.jpg	\N	2026-10-29 03:01:07.624332+07	2026-10-29 03:01:07.624332+07	2026-10-29 03:01:07.624332+07	{"eTag": "\\"83425eb4efc1872c9675e607c020fbda\\"", "size": 1264423, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-10-28T20:01:08.000Z", "contentLength": 1264423, "httpStatusCode": 200}	e649defa-fbb5-413c-b499-b5282b67c972	\N	{}	\N	f	f
a2a93c50-dea8-4969-a7b7-fcad71ff2020	uploads	menu/e95eb35d-e905-4a14-be57-122aa34b2d0f.jpg	\N	2026-10-29 03:01:09.220653+07	2026-10-29 03:01:09.220653+07	2026-10-29 03:01:09.220653+07	{"eTag": "\\"83425eb4efc1872c9675e607c020fbda\\"", "size": 1264423, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-10-28T20:01:10.000Z", "contentLength": 1264423, "httpStatusCode": 200}	40d2e8b8-10f5-4b30-8898-64f5a6cc7142	\N	{}	\N	f	f
5e410611-601c-42c5-908f-15b5e6406c9c	uploads	menu/2bec9493-3f9c-45c7-92ff-fe26681a7995.jpg	\N	2026-10-29 03:01:10.757833+07	2026-10-29 03:01:10.757833+07	2026-10-29 03:01:10.757833+07	{"eTag": "\\"83425eb4efc1872c9675e607c020fbda\\"", "size": 1264423, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-10-28T20:01:11.000Z", "contentLength": 1264423, "httpStatusCode": 200}	03429533-abaf-4512-b8ed-43dcdbade695	\N	{}	\N	f	f
1b065651-106f-4bbc-82eb-89f0b6e30307	uploads	menu/60a7f5a1-ad24-4cc5-8208-a83f5d29469a.jpg	\N	2026-10-29 03:01:12.582377+07	2026-10-29 03:01:12.582377+07	2026-10-29 03:01:12.582377+07	{"eTag": "\\"83425eb4efc1872c9675e607c020fbda\\"", "size": 1264423, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-10-28T20:01:13.000Z", "contentLength": 1264423, "httpStatusCode": 200}	0042077e-de83-4e77-9456-c0795c98e597	\N	{}	\N	f	f
27e2f9e5-7d3a-4b24-becc-8ff3d10c65a6	uploads	menu/bb49952e-433b-43d6-9065-f1831ae86485.jpg	\N	2026-10-29 03:01:14.592946+07	2026-10-29 03:01:14.592946+07	2026-10-29 03:01:14.592946+07	{"eTag": "\\"83425eb4efc1872c9675e607c020fbda\\"", "size": 1264423, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-10-28T20:01:15.000Z", "contentLength": 1264423, "httpStatusCode": 200}	51a976df-6142-491d-9911-ef92591c7806	\N	{}	\N	f	f
\.


--
-- Data for Name: s3_multipart_uploads; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY "storage"."s3_multipart_uploads" ("id", "in_progress_size", "upload_signature", "bucket_id", "key", "version", "owner_id", "created_at", "user_metadata", "metadata") FROM stdin;
\.


--
-- Data for Name: s3_multipart_uploads_parts; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY "storage"."s3_multipart_uploads_parts" ("id", "upload_id", "size", "part_number", "bucket_id", "key", "etag", "owner_id", "version", "created_at") FROM stdin;
\.


--
-- Name: refresh_tokens_id_seq; Type: SEQUENCE SET; Schema: auth; Owner: supabase_auth_admin
--

SELECT pg_catalog.setval('"auth"."refresh_tokens_id_seq"', 1, false);


--
-- Name: Message_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."Message_id_seq"', 1, false);


--
-- Name: member_point_histories_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."member_point_histories_id_seq"', 1, false);


--
-- Name: members_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."members_id_seq"', 2, true);


--
-- Name: menu_categories_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."menu_categories_id_seq"', 11, true);


--
-- Name: menu_item_stocks_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."menu_item_stocks_id_seq"', 1, false);


--
-- Name: menu_items_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."menu_items_id_seq"', 122, true);


--
-- Name: order_items_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."order_items_id_seq"', 679, true);


--
-- Name: orders_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."orders_id_seq"', 265, true);


--
-- Name: promo_codes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."promo_codes_id_seq"', 3, true);


--
-- Name: promo_usages_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."promo_usages_id_seq"', 1, false);


--
-- Name: role_permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."role_permissions_id_seq"', 268, true);


--
-- Name: stock_categories_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."stock_categories_id_seq"', 2, true);


--
-- Name: stock_items_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."stock_items_id_seq"', 5, true);


--
-- Name: stock_movements_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."stock_movements_id_seq"', 7, true);


--
-- Name: stock_units_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."stock_units_id_seq"', 2, true);


--
-- Name: tenant_payment_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."tenant_payment_id_seq"', 2, true);


--
-- Name: tenants_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."tenants_id_seq"', 2, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."users_id_seq"', 12, true);


--
-- PostgreSQL database dump complete
--

-- \unrestrict 1fjVKJUYd7FReUe1FpHauCNHD2ZcmlCtAGqoiqgZv9BmFRiN9qa31SwC2kJSENy

RESET ALL;
