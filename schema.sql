


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


COMMENT ON SCHEMA "public" IS 'standard public schema';



CREATE EXTENSION IF NOT EXISTS "pg_stat_statements" WITH SCHEMA "extensions";






CREATE EXTENSION IF NOT EXISTS "pgcrypto" WITH SCHEMA "extensions";






CREATE EXTENSION IF NOT EXISTS "supabase_vault" WITH SCHEMA "vault";






CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA "extensions";






CREATE TYPE "public"."enum_member_point_histories_type" AS ENUM (
    'earn',
    'redeem',
    'adjustment'
);


ALTER TYPE "public"."enum_member_point_histories_type" OWNER TO "postgres";


CREATE TYPE "public"."enum_members_tier" AS ENUM (
    'bronze',
    'silver',
    'gold',
    'platinum'
);


ALTER TYPE "public"."enum_members_tier" OWNER TO "postgres";


CREATE TYPE "public"."enum_orders_order_type" AS ENUM (
    'dine_in',
    'takeaway',
    'delivery'
);


ALTER TYPE "public"."enum_orders_order_type" OWNER TO "postgres";


CREATE TYPE "public"."enum_orders_payment_method" AS ENUM (
    'qrcode',
    'cash',
    'transfer'
);


ALTER TYPE "public"."enum_orders_payment_method" OWNER TO "postgres";


CREATE TYPE "public"."enum_orders_source" AS ENUM (
    'staff',
    'waiter',
    'customer'
);


ALTER TYPE "public"."enum_orders_source" OWNER TO "postgres";


CREATE TYPE "public"."enum_orders_status" AS ENUM (
    'pending',
    'preparing',
    'new',
    'proses',
    'ready',
    'deliver',
    'completed',
    'cancelled'
);


ALTER TYPE "public"."enum_orders_status" OWNER TO "postgres";


CREATE TYPE "public"."enum_promo_codes_applicable_tier" AS ENUM (
    'all',
    'bronze',
    'silver',
    'gold',
    'platinum'
);


ALTER TYPE "public"."enum_promo_codes_applicable_tier" OWNER TO "postgres";


CREATE TYPE "public"."enum_promo_codes_discount_type" AS ENUM (
    'percentage',
    'fixed'
);


ALTER TYPE "public"."enum_promo_codes_discount_type" OWNER TO "postgres";


CREATE TYPE "public"."enum_role_permissions_role" AS ENUM (
    'superadmin',
    'owner',
    'manager',
    'staff',
    'kasir',
    'waiter',
    'kitchen'
);


ALTER TYPE "public"."enum_role_permissions_role" OWNER TO "postgres";


CREATE TYPE "public"."enum_stock_movements_reason" AS ENUM (
    'purchase',
    'production',
    'waste',
    'return',
    'transfer',
    'adjustment',
    'initial'
);


ALTER TYPE "public"."enum_stock_movements_reason" OWNER TO "postgres";


CREATE TYPE "public"."enum_stock_movements_type" AS ENUM (
    'in',
    'out',
    'adjustment'
);


ALTER TYPE "public"."enum_stock_movements_type" OWNER TO "postgres";


CREATE TYPE "public"."enum_tenants_plan" AS ENUM (
    'free',
    'basic',
    'pro'
);


ALTER TYPE "public"."enum_tenants_plan" OWNER TO "postgres";


CREATE TYPE "public"."enum_users_role" AS ENUM (
    'superadmin',
    'owner',
    'manager',
    'staff',
    'kasir',
    'waiters',
    'waiter',
    'kitchen'
);


ALTER TYPE "public"."enum_users_role" OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."rls_auto_enable"() RETURNS "event_trigger"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'pg_catalog'
    AS $$
DECLARE
  cmd record;
BEGIN
  FOR cmd IN
    SELECT *
    FROM pg_event_trigger_ddl_commands()
    WHERE command_tag IN ('CREATE TABLE', 'CREATE TABLE AS', 'SELECT INTO')
      AND object_type IN ('table','partitioned table')
  LOOP
     IF cmd.schema_name IS NOT NULL AND cmd.schema_name IN ('public') AND cmd.schema_name NOT IN ('pg_catalog','information_schema') AND cmd.schema_name NOT LIKE 'pg_toast%' AND cmd.schema_name NOT LIKE 'pg_temp%' THEN
      BEGIN
        EXECUTE format('alter table if exists %s enable row level security', cmd.object_identity);
        RAISE LOG 'rls_auto_enable: enabled RLS on %', cmd.object_identity;
      EXCEPTION
        WHEN OTHERS THEN
          RAISE LOG 'rls_auto_enable: failed to enable RLS on %', cmd.object_identity;
      END;
     ELSE
        RAISE LOG 'rls_auto_enable: skip % (either system schema or not in enforced list: %.)', cmd.object_identity, cmd.schema_name;
     END IF;
  END LOOP;
END;
$$;


ALTER FUNCTION "public"."rls_auto_enable"() OWNER TO "postgres";

SET default_tablespace = '';

SET default_table_access_method = "heap";


CREATE TABLE IF NOT EXISTS "public"."Message" (
    "id" integer NOT NULL,
    "sender_id" integer NOT NULL,
    "sender_name" character varying(255) NOT NULL,
    "recipient_id" integer,
    "message" character varying(255) NOT NULL,
    "read" boolean DEFAULT false,
    "created_at" timestamp with time zone NOT NULL,
    "updated_at" timestamp with time zone NOT NULL,
    "tenant_id" integer NOT NULL
);


ALTER TABLE "public"."Message" OWNER TO "postgres";


CREATE SEQUENCE IF NOT EXISTS "public"."Message_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "public"."Message_id_seq" OWNER TO "postgres";


ALTER SEQUENCE "public"."Message_id_seq" OWNED BY "public"."Message"."id";



CREATE TABLE IF NOT EXISTS "public"."member_point_histories" (
    "id" integer NOT NULL,
    "tenant_id" integer NOT NULL,
    "member_id" integer NOT NULL,
    "order_id" integer,
    "type" "public"."enum_member_point_histories_type" DEFAULT 'earn'::"public"."enum_member_point_histories_type" NOT NULL,
    "points" integer NOT NULL,
    "description" character varying(255),
    "created_at" timestamp with time zone NOT NULL,
    "updated_at" timestamp with time zone NOT NULL
);


ALTER TABLE "public"."member_point_histories" OWNER TO "postgres";


CREATE SEQUENCE IF NOT EXISTS "public"."member_point_histories_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "public"."member_point_histories_id_seq" OWNER TO "postgres";


ALTER SEQUENCE "public"."member_point_histories_id_seq" OWNED BY "public"."member_point_histories"."id";



CREATE TABLE IF NOT EXISTS "public"."members" (
    "id" integer NOT NULL,
    "tenant_id" integer NOT NULL,
    "member_code" character varying(50) NOT NULL,
    "name" character varying(150) NOT NULL,
    "phone" character varying(30) NOT NULL,
    "email" character varying(150),
    "tier" "public"."enum_members_tier" DEFAULT 'bronze'::"public"."enum_members_tier" NOT NULL,
    "points" integer DEFAULT 0 NOT NULL,
    "total_spent" numeric(14,2) DEFAULT 0 NOT NULL,
    "total_visits" integer DEFAULT 0 NOT NULL,
    "birth_date" "date",
    "join_date" "date" NOT NULL,
    "address" "text",
    "notes" "text",
    "is_active" boolean DEFAULT true NOT NULL,
    "created_at" timestamp with time zone NOT NULL,
    "updated_at" timestamp with time zone NOT NULL
);


ALTER TABLE "public"."members" OWNER TO "postgres";


CREATE SEQUENCE IF NOT EXISTS "public"."members_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "public"."members_id_seq" OWNER TO "postgres";


ALTER SEQUENCE "public"."members_id_seq" OWNED BY "public"."members"."id";



CREATE TABLE IF NOT EXISTS "public"."menu_categories" (
    "id" integer NOT NULL,
    "tenant_id" integer NOT NULL,
    "name" character varying(255) NOT NULL,
    "sort_order" integer DEFAULT 0 NOT NULL,
    "is_active" boolean DEFAULT true NOT NULL,
    "created_at" timestamp with time zone NOT NULL,
    "updated_at" timestamp with time zone NOT NULL,
    "categories_picture" character varying(255) DEFAULT NULL::character varying
);


ALTER TABLE "public"."menu_categories" OWNER TO "postgres";


CREATE SEQUENCE IF NOT EXISTS "public"."menu_categories_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "public"."menu_categories_id_seq" OWNER TO "postgres";


ALTER SEQUENCE "public"."menu_categories_id_seq" OWNED BY "public"."menu_categories"."id";



CREATE TABLE IF NOT EXISTS "public"."menu_item_stocks" (
    "id" integer NOT NULL,
    "tenant_id" integer NOT NULL,
    "menu_item_id" integer NOT NULL,
    "stock_item_id" integer NOT NULL,
    "quantity_per_serving" numeric(14,4) NOT NULL,
    "notes" "text",
    "created_at" timestamp with time zone NOT NULL,
    "updated_at" timestamp with time zone NOT NULL
);


ALTER TABLE "public"."menu_item_stocks" OWNER TO "postgres";


CREATE SEQUENCE IF NOT EXISTS "public"."menu_item_stocks_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "public"."menu_item_stocks_id_seq" OWNER TO "postgres";


ALTER SEQUENCE "public"."menu_item_stocks_id_seq" OWNED BY "public"."menu_item_stocks"."id";



CREATE TABLE IF NOT EXISTS "public"."menu_items" (
    "id" integer NOT NULL,
    "tenant_id" integer NOT NULL,
    "category_id" integer,
    "name" character varying(255) NOT NULL,
    "description" "text",
    "price" numeric(12,2) NOT NULL,
    "image_url" character varying(255) DEFAULT NULL::character varying,
    "is_available" boolean DEFAULT true NOT NULL,
    "sort_order" integer DEFAULT 0 NOT NULL,
    "created_at" timestamp with time zone NOT NULL,
    "updated_at" timestamp with time zone NOT NULL,
    "original_price" numeric(12,2),
    "is_favorite" boolean DEFAULT false NOT NULL,
    "is_banner" boolean DEFAULT false NOT NULL
);


ALTER TABLE "public"."menu_items" OWNER TO "postgres";


CREATE SEQUENCE IF NOT EXISTS "public"."menu_items_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "public"."menu_items_id_seq" OWNER TO "postgres";


ALTER SEQUENCE "public"."menu_items_id_seq" OWNED BY "public"."menu_items"."id";



CREATE TABLE IF NOT EXISTS "public"."order_items" (
    "id" integer NOT NULL,
    "order_id" integer NOT NULL,
    "menu_item_id" integer,
    "item_name" character varying(255) NOT NULL,
    "price" numeric(12,2) NOT NULL,
    "quantity" integer DEFAULT 1 NOT NULL,
    "subtotal" numeric(12,2) NOT NULL,
    "notes" character varying(255),
    "created_at" timestamp with time zone NOT NULL,
    "updated_at" timestamp with time zone NOT NULL
);


ALTER TABLE "public"."order_items" OWNER TO "postgres";


CREATE SEQUENCE IF NOT EXISTS "public"."order_items_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "public"."order_items_id_seq" OWNER TO "postgres";


ALTER SEQUENCE "public"."order_items_id_seq" OWNED BY "public"."order_items"."id";



CREATE TABLE IF NOT EXISTS "public"."orders" (
    "id" integer NOT NULL,
    "tenant_id" integer NOT NULL,
    "order_number" character varying(255) NOT NULL,
    "order_type" "public"."enum_orders_order_type" DEFAULT 'dine_in'::"public"."enum_orders_order_type" NOT NULL,
    "table_number" character varying(255),
    "customer_name" character varying(255),
    "status" "public"."enum_orders_status" DEFAULT 'new'::"public"."enum_orders_status" NOT NULL,
    "total_amount" numeric(12,2) DEFAULT 0 NOT NULL,
    "notes" "text",
    "created_by" integer,
    "created_at" timestamp with time zone NOT NULL,
    "updated_at" timestamp with time zone NOT NULL,
    "source" "public"."enum_orders_source" DEFAULT 'staff'::"public"."enum_orders_source" NOT NULL,
    "payment_method" "public"."enum_orders_payment_method",
    "address" character varying(255),
    "phone" character varying(255),
    "payment_confirmation" boolean DEFAULT false NOT NULL,
    "subtotal" numeric(12,2) DEFAULT 0 NOT NULL,
    "discount_amount" numeric(12,2) DEFAULT 0 NOT NULL,
    "member_id" integer,
    "promo_code_id" integer,
    "points_earned" integer DEFAULT 0 NOT NULL,
    "points_redeemed" integer DEFAULT 0 NOT NULL
);


ALTER TABLE "public"."orders" OWNER TO "postgres";


CREATE SEQUENCE IF NOT EXISTS "public"."orders_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "public"."orders_id_seq" OWNER TO "postgres";


ALTER SEQUENCE "public"."orders_id_seq" OWNED BY "public"."orders"."id";



CREATE TABLE IF NOT EXISTS "public"."promo_codes" (
    "id" integer NOT NULL,
    "tenant_id" integer NOT NULL,
    "code" character varying(50) NOT NULL,
    "title" character varying(150) NOT NULL,
    "description" "text",
    "discount_type" "public"."enum_promo_codes_discount_type" DEFAULT 'fixed'::"public"."enum_promo_codes_discount_type" NOT NULL,
    "discount_value" numeric(12,2) NOT NULL,
    "min_order_amount" numeric(12,2) DEFAULT 0 NOT NULL,
    "max_discount_amount" numeric(12,2),
    "usage_limit" integer,
    "usage_count" integer DEFAULT 0 NOT NULL,
    "start_date" timestamp with time zone,
    "end_date" timestamp with time zone,
    "applicable_tier" "public"."enum_promo_codes_applicable_tier" DEFAULT 'all'::"public"."enum_promo_codes_applicable_tier" NOT NULL,
    "is_active" boolean DEFAULT true NOT NULL,
    "created_at" timestamp with time zone NOT NULL,
    "updated_at" timestamp with time zone NOT NULL
);


ALTER TABLE "public"."promo_codes" OWNER TO "postgres";


CREATE SEQUENCE IF NOT EXISTS "public"."promo_codes_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "public"."promo_codes_id_seq" OWNER TO "postgres";


ALTER SEQUENCE "public"."promo_codes_id_seq" OWNED BY "public"."promo_codes"."id";



CREATE TABLE IF NOT EXISTS "public"."promo_usages" (
    "id" integer NOT NULL,
    "tenant_id" integer NOT NULL,
    "promo_id" integer NOT NULL,
    "order_id" integer NOT NULL,
    "member_id" integer,
    "discount_amount" numeric(12,2) DEFAULT 0 NOT NULL,
    "order_amount" numeric(12,2) DEFAULT 0 NOT NULL,
    "created_at" timestamp with time zone NOT NULL,
    "updated_at" timestamp with time zone NOT NULL
);


ALTER TABLE "public"."promo_usages" OWNER TO "postgres";


CREATE SEQUENCE IF NOT EXISTS "public"."promo_usages_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "public"."promo_usages_id_seq" OWNER TO "postgres";


ALTER SEQUENCE "public"."promo_usages_id_seq" OWNED BY "public"."promo_usages"."id";



CREATE TABLE IF NOT EXISTS "public"."role_permissions" (
    "id" integer NOT NULL,
    "tenant_id" integer NOT NULL,
    "role" "public"."enum_role_permissions_role" NOT NULL,
    "menu_key" character varying(255) NOT NULL,
    "can_create" boolean DEFAULT false NOT NULL,
    "can_read" boolean DEFAULT false NOT NULL,
    "can_update" boolean DEFAULT false NOT NULL,
    "can_delete" boolean DEFAULT false NOT NULL,
    "created_at" timestamp with time zone NOT NULL,
    "updated_at" timestamp with time zone NOT NULL
);


ALTER TABLE "public"."role_permissions" OWNER TO "postgres";


CREATE SEQUENCE IF NOT EXISTS "public"."role_permissions_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "public"."role_permissions_id_seq" OWNER TO "postgres";


ALTER SEQUENCE "public"."role_permissions_id_seq" OWNED BY "public"."role_permissions"."id";



CREATE TABLE IF NOT EXISTS "public"."stock_categories" (
    "id" integer NOT NULL,
    "tenant_id" integer NOT NULL,
    "name" character varying(100) NOT NULL,
    "description" "text",
    "is_active" boolean DEFAULT true NOT NULL,
    "created_at" timestamp with time zone NOT NULL,
    "updated_at" timestamp with time zone NOT NULL
);


ALTER TABLE "public"."stock_categories" OWNER TO "postgres";


CREATE SEQUENCE IF NOT EXISTS "public"."stock_categories_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "public"."stock_categories_id_seq" OWNER TO "postgres";


ALTER SEQUENCE "public"."stock_categories_id_seq" OWNED BY "public"."stock_categories"."id";



CREATE TABLE IF NOT EXISTS "public"."stock_items" (
    "id" integer NOT NULL,
    "tenant_id" integer NOT NULL,
    "category_id" integer,
    "unit_id" integer NOT NULL,
    "sku" character varying(60),
    "name" character varying(150) NOT NULL,
    "description" "text",
    "current_stock" numeric(14,4) DEFAULT 0 NOT NULL,
    "minimum_stock" numeric(14,4) DEFAULT 0 NOT NULL,
    "cost_price" numeric(14,2) DEFAULT 0,
    "supplier" character varying(200),
    "notes" "text",
    "is_active" boolean DEFAULT true NOT NULL,
    "created_at" timestamp with time zone NOT NULL,
    "updated_at" timestamp with time zone NOT NULL
);


ALTER TABLE "public"."stock_items" OWNER TO "postgres";


CREATE SEQUENCE IF NOT EXISTS "public"."stock_items_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "public"."stock_items_id_seq" OWNER TO "postgres";


ALTER SEQUENCE "public"."stock_items_id_seq" OWNED BY "public"."stock_items"."id";



CREATE TABLE IF NOT EXISTS "public"."stock_movements" (
    "id" integer NOT NULL,
    "tenant_id" integer NOT NULL,
    "stock_item_id" integer NOT NULL,
    "user_id" integer,
    "type" "public"."enum_stock_movements_type" NOT NULL,
    "reason" "public"."enum_stock_movements_reason" DEFAULT 'adjustment'::"public"."enum_stock_movements_reason" NOT NULL,
    "quantity" numeric(14,4) NOT NULL,
    "stock_before" numeric(14,4) NOT NULL,
    "stock_after" numeric(14,4) NOT NULL,
    "unit_cost" numeric(14,2),
    "total_cost" numeric(14,2),
    "reference_number" character varying(100),
    "notes" "text",
    "movement_date" "date" NOT NULL,
    "created_at" timestamp with time zone NOT NULL,
    "updated_at" timestamp with time zone NOT NULL
);


ALTER TABLE "public"."stock_movements" OWNER TO "postgres";


CREATE SEQUENCE IF NOT EXISTS "public"."stock_movements_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "public"."stock_movements_id_seq" OWNER TO "postgres";


ALTER SEQUENCE "public"."stock_movements_id_seq" OWNED BY "public"."stock_movements"."id";



CREATE TABLE IF NOT EXISTS "public"."stock_units" (
    "id" integer NOT NULL,
    "tenant_id" integer NOT NULL,
    "name" character varying(100) NOT NULL,
    "symbol" character varying(20) NOT NULL,
    "conversion_factor" numeric(14,6) DEFAULT 1,
    "base_unit" character varying(20),
    "description" "text",
    "is_active" boolean DEFAULT true NOT NULL,
    "created_at" timestamp with time zone NOT NULL,
    "updated_at" timestamp with time zone NOT NULL
);


ALTER TABLE "public"."stock_units" OWNER TO "postgres";


CREATE SEQUENCE IF NOT EXISTS "public"."stock_units_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "public"."stock_units_id_seq" OWNER TO "postgres";


ALTER SEQUENCE "public"."stock_units_id_seq" OWNED BY "public"."stock_units"."id";



CREATE TABLE IF NOT EXISTS "public"."tenant_payment" (
    "id" integer NOT NULL,
    "tenant_id" integer NOT NULL,
    "qris_url" character varying(255) DEFAULT NULL::character varying,
    "bank_account_name" character varying(255),
    "bank_account_number" character varying(255),
    "phone_confirmation" character varying(255),
    "delivery_description" character varying(255),
    "created_at" timestamp with time zone NOT NULL,
    "updated_at" timestamp with time zone NOT NULL
);


ALTER TABLE "public"."tenant_payment" OWNER TO "postgres";


CREATE SEQUENCE IF NOT EXISTS "public"."tenant_payment_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "public"."tenant_payment_id_seq" OWNER TO "postgres";


ALTER SEQUENCE "public"."tenant_payment_id_seq" OWNED BY "public"."tenant_payment"."id";



CREATE TABLE IF NOT EXISTS "public"."tenants" (
    "id" integer NOT NULL,
    "name" character varying(255) NOT NULL,
    "slug" character varying(255) NOT NULL,
    "address" character varying(255),
    "phone" character varying(255),
    "email" character varying(255),
    "logo_url" character varying(255) DEFAULT NULL::character varying,
    "plan" "public"."enum_tenants_plan" DEFAULT 'free'::"public"."enum_tenants_plan" NOT NULL,
    "is_active" boolean DEFAULT true NOT NULL,
    "created_at" timestamp with time zone NOT NULL,
    "updated_at" timestamp with time zone NOT NULL,
    "owner_id" integer,
    "bank_account_number" character varying(255),
    "qris_url" character varying(255) DEFAULT NULL::character varying
);


ALTER TABLE "public"."tenants" OWNER TO "postgres";


CREATE SEQUENCE IF NOT EXISTS "public"."tenants_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "public"."tenants_id_seq" OWNER TO "postgres";


ALTER SEQUENCE "public"."tenants_id_seq" OWNED BY "public"."tenants"."id";



CREATE TABLE IF NOT EXISTS "public"."users" (
    "id" integer NOT NULL,
    "name" character varying(255) NOT NULL,
    "email" character varying(255) NOT NULL,
    "password" character varying(255) NOT NULL,
    "profile_picture" character varying(255) DEFAULT NULL::character varying,
    "created_at" timestamp with time zone NOT NULL,
    "updated_at" timestamp with time zone NOT NULL,
    "tenant_id" integer,
    "role" "public"."enum_users_role" DEFAULT 'staff'::"public"."enum_users_role" NOT NULL,
    "email_verified" boolean DEFAULT false NOT NULL,
    "email_verification_token" character varying(255) DEFAULT NULL::character varying,
    "email_verification_expires" timestamp with time zone,
    "reset_password_token" character varying(255) DEFAULT NULL::character varying,
    "reset_password_expires" timestamp with time zone
);


ALTER TABLE "public"."users" OWNER TO "postgres";


CREATE SEQUENCE IF NOT EXISTS "public"."users_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "public"."users_id_seq" OWNER TO "postgres";


ALTER SEQUENCE "public"."users_id_seq" OWNED BY "public"."users"."id";



ALTER TABLE ONLY "public"."Message" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."Message_id_seq"'::"regclass");



ALTER TABLE ONLY "public"."member_point_histories" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."member_point_histories_id_seq"'::"regclass");



ALTER TABLE ONLY "public"."members" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."members_id_seq"'::"regclass");



ALTER TABLE ONLY "public"."menu_categories" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."menu_categories_id_seq"'::"regclass");



ALTER TABLE ONLY "public"."menu_item_stocks" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."menu_item_stocks_id_seq"'::"regclass");



ALTER TABLE ONLY "public"."menu_items" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."menu_items_id_seq"'::"regclass");



ALTER TABLE ONLY "public"."order_items" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."order_items_id_seq"'::"regclass");



ALTER TABLE ONLY "public"."orders" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."orders_id_seq"'::"regclass");



ALTER TABLE ONLY "public"."promo_codes" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."promo_codes_id_seq"'::"regclass");



ALTER TABLE ONLY "public"."promo_usages" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."promo_usages_id_seq"'::"regclass");



ALTER TABLE ONLY "public"."role_permissions" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."role_permissions_id_seq"'::"regclass");



ALTER TABLE ONLY "public"."stock_categories" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."stock_categories_id_seq"'::"regclass");



ALTER TABLE ONLY "public"."stock_items" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."stock_items_id_seq"'::"regclass");



ALTER TABLE ONLY "public"."stock_movements" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."stock_movements_id_seq"'::"regclass");



ALTER TABLE ONLY "public"."stock_units" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."stock_units_id_seq"'::"regclass");



ALTER TABLE ONLY "public"."tenant_payment" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."tenant_payment_id_seq"'::"regclass");



ALTER TABLE ONLY "public"."tenants" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."tenants_id_seq"'::"regclass");



ALTER TABLE ONLY "public"."users" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."users_id_seq"'::"regclass");



ALTER TABLE ONLY "public"."Message"
    ADD CONSTRAINT "Message_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."member_point_histories"
    ADD CONSTRAINT "member_point_histories_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."members"
    ADD CONSTRAINT "members_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."menu_categories"
    ADD CONSTRAINT "menu_categories_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."menu_item_stocks"
    ADD CONSTRAINT "menu_item_stocks_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."menu_items"
    ADD CONSTRAINT "menu_items_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."order_items"
    ADD CONSTRAINT "order_items_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."orders"
    ADD CONSTRAINT "orders_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."promo_codes"
    ADD CONSTRAINT "promo_codes_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."promo_usages"
    ADD CONSTRAINT "promo_usages_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."role_permissions"
    ADD CONSTRAINT "role_permissions_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."stock_categories"
    ADD CONSTRAINT "stock_categories_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."stock_items"
    ADD CONSTRAINT "stock_items_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."stock_movements"
    ADD CONSTRAINT "stock_movements_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."stock_units"
    ADD CONSTRAINT "stock_units_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."tenant_payment"
    ADD CONSTRAINT "tenant_payment_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key1" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key10" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key100" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key101" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key102" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key103" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key104" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key105" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key106" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key107" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key108" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key109" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key11" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key110" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key111" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key112" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key113" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key114" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key115" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key116" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key117" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key118" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key119" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key12" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key120" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key121" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key122" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key123" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key124" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key125" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key126" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key127" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key128" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key129" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key13" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key130" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key131" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key132" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key133" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key134" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key135" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key136" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key137" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key138" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key139" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key14" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key140" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key141" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key142" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key143" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key144" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key145" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key146" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key147" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key148" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key149" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key15" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key150" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key151" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key152" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key153" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key154" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key155" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key156" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key157" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key158" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key159" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key16" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key160" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key161" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key162" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key163" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key164" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key165" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key166" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key167" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key168" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key169" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key17" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key170" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key171" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key172" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key173" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key174" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key175" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key176" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key177" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key178" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key179" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key18" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key180" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key181" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key182" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key183" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key184" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key185" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key186" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key187" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key188" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key189" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key19" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key190" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key191" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key192" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key193" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key194" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key195" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key196" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key197" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key198" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key199" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key2" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key20" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key200" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key201" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key202" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key203" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key204" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key205" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key206" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key207" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key208" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key209" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key21" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key210" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key211" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key212" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key213" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key214" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key215" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key216" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key217" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key218" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key219" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key22" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key220" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key221" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key222" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key223" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key224" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key225" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key226" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key227" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key228" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key229" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key23" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key230" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key231" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key232" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key233" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key234" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key235" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key236" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key237" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key238" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key239" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key24" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key240" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key241" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key242" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key243" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key244" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key245" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key246" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key247" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key248" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key249" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key25" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key250" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key251" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key252" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key253" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key254" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key255" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key256" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key257" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key258" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key259" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key26" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key260" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key261" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key262" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key263" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key264" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key265" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key266" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key267" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key268" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key269" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key27" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key270" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key271" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key272" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key273" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key274" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key275" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key276" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key277" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key278" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key279" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key28" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key280" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key281" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key282" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key283" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key284" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key285" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key286" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key287" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key288" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key289" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key29" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key290" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key291" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key292" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key293" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key294" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key295" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key296" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key297" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key298" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key299" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key3" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key30" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key300" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key301" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key302" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key303" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key304" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key305" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key306" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key307" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key308" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key309" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key31" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key310" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key311" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key312" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key313" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key314" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key315" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key316" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key317" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key318" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key319" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key32" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key320" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key321" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key322" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key323" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key324" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key325" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key326" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key327" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key328" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key329" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key33" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key330" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key331" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key332" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key333" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key334" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key335" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key336" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key337" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key338" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key339" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key34" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key340" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key341" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key342" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key343" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key344" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key345" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key346" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key347" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key348" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key349" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key35" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key350" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key351" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key352" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key353" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key354" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key355" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key356" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key357" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key358" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key359" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key36" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key360" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key361" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key362" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key363" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key364" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key365" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key366" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key367" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key368" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key369" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key37" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key370" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key371" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key372" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key373" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key374" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key375" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key376" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key377" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key378" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key379" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key38" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key380" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key381" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key382" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key383" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key384" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key385" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key386" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key387" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key388" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key389" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key39" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key390" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key391" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key392" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key393" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key394" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key395" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key396" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key397" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key398" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key399" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key4" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key40" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key400" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key401" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key402" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key403" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key404" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key41" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key42" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key43" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key44" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key45" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key46" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key47" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key48" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key49" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key5" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key50" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key51" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key52" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key53" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key54" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key55" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key56" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key57" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key58" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key59" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key6" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key60" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key61" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key62" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key63" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key64" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key65" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key66" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key67" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key68" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key69" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key7" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key70" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key71" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key72" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key73" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key74" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key75" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key76" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key77" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key78" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key79" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key8" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key80" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key81" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key82" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key83" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key84" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key85" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key86" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key87" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key88" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key89" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key9" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key90" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key91" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key92" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key93" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key94" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key95" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key96" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key97" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key98" UNIQUE ("slug");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_slug_key99" UNIQUE ("slug");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key1" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key10" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key100" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key101" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key102" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key103" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key104" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key105" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key106" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key107" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key108" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key109" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key11" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key110" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key111" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key112" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key113" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key114" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key115" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key116" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key117" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key118" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key119" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key12" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key120" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key121" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key122" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key123" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key124" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key125" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key126" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key127" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key128" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key129" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key13" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key130" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key131" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key132" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key133" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key134" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key135" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key136" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key137" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key138" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key139" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key14" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key140" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key141" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key142" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key143" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key144" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key145" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key146" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key147" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key148" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key149" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key15" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key150" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key151" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key152" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key153" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key154" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key155" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key156" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key157" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key158" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key159" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key16" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key160" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key161" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key162" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key163" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key164" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key165" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key166" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key167" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key168" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key169" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key17" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key170" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key171" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key172" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key173" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key174" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key175" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key176" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key177" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key178" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key179" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key18" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key180" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key181" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key182" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key183" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key184" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key185" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key186" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key187" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key188" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key189" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key19" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key190" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key191" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key192" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key193" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key194" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key195" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key196" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key197" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key198" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key199" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key2" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key20" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key200" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key201" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key202" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key203" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key204" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key205" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key206" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key207" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key208" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key209" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key21" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key210" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key211" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key212" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key213" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key214" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key215" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key216" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key217" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key218" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key219" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key22" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key220" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key221" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key222" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key223" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key224" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key225" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key226" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key227" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key228" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key229" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key23" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key230" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key231" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key232" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key233" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key234" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key235" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key236" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key237" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key238" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key239" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key24" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key240" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key241" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key242" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key243" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key244" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key245" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key246" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key247" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key248" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key249" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key25" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key250" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key251" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key252" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key253" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key254" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key255" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key256" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key257" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key258" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key259" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key26" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key260" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key261" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key262" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key263" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key264" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key265" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key266" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key267" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key268" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key269" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key27" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key270" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key271" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key272" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key273" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key274" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key275" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key276" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key277" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key278" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key279" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key28" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key280" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key281" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key282" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key283" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key284" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key285" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key286" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key287" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key288" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key289" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key29" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key290" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key291" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key292" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key293" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key294" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key295" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key296" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key297" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key298" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key299" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key3" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key30" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key300" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key301" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key302" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key303" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key304" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key305" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key306" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key307" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key308" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key309" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key31" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key310" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key311" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key312" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key313" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key314" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key315" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key316" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key317" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key318" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key319" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key32" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key320" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key321" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key322" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key323" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key324" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key325" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key326" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key327" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key328" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key329" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key33" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key330" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key331" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key332" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key333" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key334" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key335" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key336" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key337" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key338" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key339" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key34" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key340" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key341" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key342" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key343" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key344" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key345" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key346" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key347" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key348" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key349" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key35" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key350" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key351" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key352" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key353" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key354" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key355" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key356" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key357" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key358" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key359" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key36" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key360" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key361" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key362" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key363" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key364" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key365" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key366" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key367" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key368" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key369" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key37" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key370" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key371" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key372" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key373" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key374" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key375" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key376" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key377" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key378" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key379" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key38" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key380" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key381" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key382" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key383" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key384" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key385" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key386" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key387" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key388" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key389" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key39" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key390" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key391" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key392" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key393" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key394" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key395" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key396" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key397" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key398" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key399" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key4" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key40" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key41" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key42" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key43" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key44" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key45" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key46" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key47" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key48" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key49" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key5" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key50" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key51" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key52" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key53" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key54" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key55" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key56" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key57" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key58" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key59" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key6" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key60" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key61" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key62" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key63" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key64" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key65" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key66" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key67" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key68" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key69" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key7" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key70" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key71" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key72" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key73" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key74" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key75" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key76" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key77" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key78" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key79" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key8" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key80" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key81" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key82" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key83" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key84" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key85" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key86" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key87" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key88" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key89" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key9" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key90" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key91" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key92" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key93" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key94" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key95" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key96" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key97" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key98" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key99" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_pkey" PRIMARY KEY ("id");



CREATE UNIQUE INDEX "members_tenant_id_member_code" ON "public"."members" USING "btree" ("tenant_id", "member_code");



CREATE UNIQUE INDEX "members_tenant_id_phone" ON "public"."members" USING "btree" ("tenant_id", "phone");



CREATE UNIQUE INDEX "menu_item_stocks_menu_item_id_stock_item_id" ON "public"."menu_item_stocks" USING "btree" ("menu_item_id", "stock_item_id");



CREATE UNIQUE INDEX "promo_codes_tenant_id_code" ON "public"."promo_codes" USING "btree" ("tenant_id", "code");



CREATE UNIQUE INDEX "role_permissions_tenant_role_menu_unique" ON "public"."role_permissions" USING "btree" ("tenant_id", "role", "menu_key");



CREATE UNIQUE INDEX "stock_categories_tenant_id_name" ON "public"."stock_categories" USING "btree" ("tenant_id", "name");



CREATE UNIQUE INDEX "stock_items_tenant_id_name" ON "public"."stock_items" USING "btree" ("tenant_id", "name");



CREATE INDEX "stock_items_tenant_id_sku" ON "public"."stock_items" USING "btree" ("tenant_id", "sku");



CREATE INDEX "stock_movements_tenant_id_movement_date" ON "public"."stock_movements" USING "btree" ("tenant_id", "movement_date");



CREATE INDEX "stock_movements_tenant_id_stock_item_id" ON "public"."stock_movements" USING "btree" ("tenant_id", "stock_item_id");



CREATE UNIQUE INDEX "stock_units_tenant_id_symbol" ON "public"."stock_units" USING "btree" ("tenant_id", "symbol");



ALTER TABLE ONLY "public"."Message"
    ADD CONSTRAINT "Message_tenant_id_fkey" FOREIGN KEY ("tenant_id") REFERENCES "public"."tenants"("id") ON UPDATE CASCADE ON DELETE CASCADE;



ALTER TABLE ONLY "public"."member_point_histories"
    ADD CONSTRAINT "member_point_histories_member_id_fkey" FOREIGN KEY ("member_id") REFERENCES "public"."members"("id") ON UPDATE CASCADE ON DELETE CASCADE;



ALTER TABLE ONLY "public"."member_point_histories"
    ADD CONSTRAINT "member_point_histories_order_id_fkey" FOREIGN KEY ("order_id") REFERENCES "public"."orders"("id");



ALTER TABLE ONLY "public"."member_point_histories"
    ADD CONSTRAINT "member_point_histories_tenant_id_fkey" FOREIGN KEY ("tenant_id") REFERENCES "public"."tenants"("id");



ALTER TABLE ONLY "public"."members"
    ADD CONSTRAINT "members_tenant_id_fkey" FOREIGN KEY ("tenant_id") REFERENCES "public"."tenants"("id") ON UPDATE CASCADE ON DELETE CASCADE;



ALTER TABLE ONLY "public"."menu_categories"
    ADD CONSTRAINT "menu_categories_tenant_id_fkey" FOREIGN KEY ("tenant_id") REFERENCES "public"."tenants"("id") ON UPDATE CASCADE ON DELETE CASCADE;



ALTER TABLE ONLY "public"."menu_item_stocks"
    ADD CONSTRAINT "menu_item_stocks_menu_item_id_fkey" FOREIGN KEY ("menu_item_id") REFERENCES "public"."menu_items"("id") ON UPDATE CASCADE ON DELETE CASCADE;



ALTER TABLE ONLY "public"."menu_item_stocks"
    ADD CONSTRAINT "menu_item_stocks_stock_item_id_fkey" FOREIGN KEY ("stock_item_id") REFERENCES "public"."stock_items"("id") ON UPDATE CASCADE ON DELETE CASCADE;



ALTER TABLE ONLY "public"."menu_item_stocks"
    ADD CONSTRAINT "menu_item_stocks_tenant_id_fkey" FOREIGN KEY ("tenant_id") REFERENCES "public"."tenants"("id") ON UPDATE CASCADE ON DELETE CASCADE;



ALTER TABLE ONLY "public"."menu_items"
    ADD CONSTRAINT "menu_items_category_id_fkey" FOREIGN KEY ("category_id") REFERENCES "public"."menu_categories"("id") ON UPDATE CASCADE ON DELETE SET NULL;



ALTER TABLE ONLY "public"."menu_items"
    ADD CONSTRAINT "menu_items_tenant_id_fkey" FOREIGN KEY ("tenant_id") REFERENCES "public"."tenants"("id") ON UPDATE CASCADE ON DELETE CASCADE;



ALTER TABLE ONLY "public"."order_items"
    ADD CONSTRAINT "order_items_menu_item_id_fkey" FOREIGN KEY ("menu_item_id") REFERENCES "public"."menu_items"("id") ON UPDATE CASCADE ON DELETE SET NULL;



ALTER TABLE ONLY "public"."order_items"
    ADD CONSTRAINT "order_items_order_id_fkey" FOREIGN KEY ("order_id") REFERENCES "public"."orders"("id") ON UPDATE CASCADE ON DELETE CASCADE;



ALTER TABLE ONLY "public"."orders"
    ADD CONSTRAINT "orders_created_by_fkey" FOREIGN KEY ("created_by") REFERENCES "public"."users"("id") ON UPDATE CASCADE ON DELETE SET NULL;



ALTER TABLE ONLY "public"."orders"
    ADD CONSTRAINT "orders_member_id_fkey" FOREIGN KEY ("member_id") REFERENCES "public"."members"("id") ON UPDATE CASCADE ON DELETE SET NULL;



ALTER TABLE ONLY "public"."orders"
    ADD CONSTRAINT "orders_promo_code_id_fkey" FOREIGN KEY ("promo_code_id") REFERENCES "public"."promo_codes"("id") ON UPDATE CASCADE ON DELETE SET NULL;



ALTER TABLE ONLY "public"."orders"
    ADD CONSTRAINT "orders_tenant_id_fkey" FOREIGN KEY ("tenant_id") REFERENCES "public"."tenants"("id") ON UPDATE CASCADE ON DELETE CASCADE;



ALTER TABLE ONLY "public"."promo_codes"
    ADD CONSTRAINT "promo_codes_tenant_id_fkey" FOREIGN KEY ("tenant_id") REFERENCES "public"."tenants"("id") ON UPDATE CASCADE ON DELETE CASCADE;



ALTER TABLE ONLY "public"."promo_usages"
    ADD CONSTRAINT "promo_usages_member_id_fkey" FOREIGN KEY ("member_id") REFERENCES "public"."members"("id") ON UPDATE CASCADE ON DELETE SET NULL;



ALTER TABLE ONLY "public"."promo_usages"
    ADD CONSTRAINT "promo_usages_order_id_fkey" FOREIGN KEY ("order_id") REFERENCES "public"."orders"("id") ON UPDATE CASCADE ON DELETE CASCADE;



ALTER TABLE ONLY "public"."promo_usages"
    ADD CONSTRAINT "promo_usages_promo_id_fkey" FOREIGN KEY ("promo_id") REFERENCES "public"."promo_codes"("id") ON UPDATE CASCADE ON DELETE CASCADE;



ALTER TABLE ONLY "public"."promo_usages"
    ADD CONSTRAINT "promo_usages_tenant_id_fkey" FOREIGN KEY ("tenant_id") REFERENCES "public"."tenants"("id");



ALTER TABLE ONLY "public"."role_permissions"
    ADD CONSTRAINT "role_permissions_tenant_id_fkey" FOREIGN KEY ("tenant_id") REFERENCES "public"."tenants"("id") ON UPDATE CASCADE;



ALTER TABLE ONLY "public"."stock_categories"
    ADD CONSTRAINT "stock_categories_tenant_id_fkey" FOREIGN KEY ("tenant_id") REFERENCES "public"."tenants"("id") ON UPDATE CASCADE ON DELETE CASCADE;



ALTER TABLE ONLY "public"."stock_items"
    ADD CONSTRAINT "stock_items_category_id_fkey" FOREIGN KEY ("category_id") REFERENCES "public"."stock_categories"("id") ON UPDATE CASCADE ON DELETE SET NULL;



ALTER TABLE ONLY "public"."stock_items"
    ADD CONSTRAINT "stock_items_tenant_id_fkey" FOREIGN KEY ("tenant_id") REFERENCES "public"."tenants"("id") ON UPDATE CASCADE ON DELETE CASCADE;



ALTER TABLE ONLY "public"."stock_items"
    ADD CONSTRAINT "stock_items_unit_id_fkey" FOREIGN KEY ("unit_id") REFERENCES "public"."stock_units"("id") ON UPDATE CASCADE ON DELETE CASCADE;



ALTER TABLE ONLY "public"."stock_movements"
    ADD CONSTRAINT "stock_movements_stock_item_id_fkey" FOREIGN KEY ("stock_item_id") REFERENCES "public"."stock_items"("id") ON UPDATE CASCADE ON DELETE CASCADE;



ALTER TABLE ONLY "public"."stock_movements"
    ADD CONSTRAINT "stock_movements_tenant_id_fkey" FOREIGN KEY ("tenant_id") REFERENCES "public"."tenants"("id") ON UPDATE CASCADE ON DELETE CASCADE;



ALTER TABLE ONLY "public"."stock_movements"
    ADD CONSTRAINT "stock_movements_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON UPDATE CASCADE ON DELETE SET NULL;



ALTER TABLE ONLY "public"."stock_units"
    ADD CONSTRAINT "stock_units_tenant_id_fkey" FOREIGN KEY ("tenant_id") REFERENCES "public"."tenants"("id") ON UPDATE CASCADE ON DELETE CASCADE;



ALTER TABLE ONLY "public"."tenant_payment"
    ADD CONSTRAINT "tenant_payment_tenant_id_fkey" FOREIGN KEY ("tenant_id") REFERENCES "public"."tenants"("id") ON UPDATE CASCADE ON DELETE CASCADE;



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_owner_id_fkey" FOREIGN KEY ("owner_id") REFERENCES "public"."users"("id") ON UPDATE CASCADE ON DELETE SET NULL;



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_tenant_id_fkey" FOREIGN KEY ("tenant_id") REFERENCES "public"."tenants"("id") ON UPDATE CASCADE ON DELETE SET NULL;



ALTER TABLE "public"."Message" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."member_point_histories" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."members" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."menu_categories" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."menu_item_stocks" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."menu_items" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."order_items" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."orders" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."promo_codes" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."promo_usages" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."role_permissions" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."stock_categories" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."stock_items" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."stock_movements" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."stock_units" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."tenant_payment" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."tenants" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."users" ENABLE ROW LEVEL SECURITY;




ALTER PUBLICATION "supabase_realtime" OWNER TO "postgres";


GRANT USAGE ON SCHEMA "public" TO "postgres";
GRANT USAGE ON SCHEMA "public" TO "anon";
GRANT USAGE ON SCHEMA "public" TO "authenticated";
GRANT USAGE ON SCHEMA "public" TO "service_role";






















































































































































GRANT ALL ON FUNCTION "public"."rls_auto_enable"() TO "anon";
GRANT ALL ON FUNCTION "public"."rls_auto_enable"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."rls_auto_enable"() TO "service_role";


















GRANT ALL ON TABLE "public"."Message" TO "anon";
GRANT ALL ON TABLE "public"."Message" TO "authenticated";
GRANT ALL ON TABLE "public"."Message" TO "service_role";



GRANT ALL ON SEQUENCE "public"."Message_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."Message_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."Message_id_seq" TO "service_role";



GRANT ALL ON TABLE "public"."member_point_histories" TO "anon";
GRANT ALL ON TABLE "public"."member_point_histories" TO "authenticated";
GRANT ALL ON TABLE "public"."member_point_histories" TO "service_role";



GRANT ALL ON SEQUENCE "public"."member_point_histories_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."member_point_histories_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."member_point_histories_id_seq" TO "service_role";



GRANT ALL ON TABLE "public"."members" TO "anon";
GRANT ALL ON TABLE "public"."members" TO "authenticated";
GRANT ALL ON TABLE "public"."members" TO "service_role";



GRANT ALL ON SEQUENCE "public"."members_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."members_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."members_id_seq" TO "service_role";



GRANT ALL ON TABLE "public"."menu_categories" TO "anon";
GRANT ALL ON TABLE "public"."menu_categories" TO "authenticated";
GRANT ALL ON TABLE "public"."menu_categories" TO "service_role";



GRANT ALL ON SEQUENCE "public"."menu_categories_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."menu_categories_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."menu_categories_id_seq" TO "service_role";



GRANT ALL ON TABLE "public"."menu_item_stocks" TO "anon";
GRANT ALL ON TABLE "public"."menu_item_stocks" TO "authenticated";
GRANT ALL ON TABLE "public"."menu_item_stocks" TO "service_role";



GRANT ALL ON SEQUENCE "public"."menu_item_stocks_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."menu_item_stocks_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."menu_item_stocks_id_seq" TO "service_role";



GRANT ALL ON TABLE "public"."menu_items" TO "anon";
GRANT ALL ON TABLE "public"."menu_items" TO "authenticated";
GRANT ALL ON TABLE "public"."menu_items" TO "service_role";



GRANT ALL ON SEQUENCE "public"."menu_items_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."menu_items_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."menu_items_id_seq" TO "service_role";



GRANT ALL ON TABLE "public"."order_items" TO "anon";
GRANT ALL ON TABLE "public"."order_items" TO "authenticated";
GRANT ALL ON TABLE "public"."order_items" TO "service_role";



GRANT ALL ON SEQUENCE "public"."order_items_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."order_items_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."order_items_id_seq" TO "service_role";



GRANT ALL ON TABLE "public"."orders" TO "anon";
GRANT ALL ON TABLE "public"."orders" TO "authenticated";
GRANT ALL ON TABLE "public"."orders" TO "service_role";



GRANT ALL ON SEQUENCE "public"."orders_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."orders_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."orders_id_seq" TO "service_role";



GRANT ALL ON TABLE "public"."promo_codes" TO "anon";
GRANT ALL ON TABLE "public"."promo_codes" TO "authenticated";
GRANT ALL ON TABLE "public"."promo_codes" TO "service_role";



GRANT ALL ON SEQUENCE "public"."promo_codes_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."promo_codes_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."promo_codes_id_seq" TO "service_role";



GRANT ALL ON TABLE "public"."promo_usages" TO "anon";
GRANT ALL ON TABLE "public"."promo_usages" TO "authenticated";
GRANT ALL ON TABLE "public"."promo_usages" TO "service_role";



GRANT ALL ON SEQUENCE "public"."promo_usages_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."promo_usages_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."promo_usages_id_seq" TO "service_role";



GRANT ALL ON TABLE "public"."role_permissions" TO "anon";
GRANT ALL ON TABLE "public"."role_permissions" TO "authenticated";
GRANT ALL ON TABLE "public"."role_permissions" TO "service_role";



GRANT ALL ON SEQUENCE "public"."role_permissions_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."role_permissions_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."role_permissions_id_seq" TO "service_role";



GRANT ALL ON TABLE "public"."stock_categories" TO "anon";
GRANT ALL ON TABLE "public"."stock_categories" TO "authenticated";
GRANT ALL ON TABLE "public"."stock_categories" TO "service_role";



GRANT ALL ON SEQUENCE "public"."stock_categories_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."stock_categories_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."stock_categories_id_seq" TO "service_role";



GRANT ALL ON TABLE "public"."stock_items" TO "anon";
GRANT ALL ON TABLE "public"."stock_items" TO "authenticated";
GRANT ALL ON TABLE "public"."stock_items" TO "service_role";



GRANT ALL ON SEQUENCE "public"."stock_items_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."stock_items_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."stock_items_id_seq" TO "service_role";



GRANT ALL ON TABLE "public"."stock_movements" TO "anon";
GRANT ALL ON TABLE "public"."stock_movements" TO "authenticated";
GRANT ALL ON TABLE "public"."stock_movements" TO "service_role";



GRANT ALL ON SEQUENCE "public"."stock_movements_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."stock_movements_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."stock_movements_id_seq" TO "service_role";



GRANT ALL ON TABLE "public"."stock_units" TO "anon";
GRANT ALL ON TABLE "public"."stock_units" TO "authenticated";
GRANT ALL ON TABLE "public"."stock_units" TO "service_role";



GRANT ALL ON SEQUENCE "public"."stock_units_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."stock_units_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."stock_units_id_seq" TO "service_role";



GRANT ALL ON TABLE "public"."tenant_payment" TO "anon";
GRANT ALL ON TABLE "public"."tenant_payment" TO "authenticated";
GRANT ALL ON TABLE "public"."tenant_payment" TO "service_role";



GRANT ALL ON SEQUENCE "public"."tenant_payment_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."tenant_payment_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."tenant_payment_id_seq" TO "service_role";



GRANT ALL ON TABLE "public"."tenants" TO "anon";
GRANT ALL ON TABLE "public"."tenants" TO "authenticated";
GRANT ALL ON TABLE "public"."tenants" TO "service_role";



GRANT ALL ON SEQUENCE "public"."tenants_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."tenants_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."tenants_id_seq" TO "service_role";



GRANT ALL ON TABLE "public"."users" TO "anon";
GRANT ALL ON TABLE "public"."users" TO "authenticated";
GRANT ALL ON TABLE "public"."users" TO "service_role";



GRANT ALL ON SEQUENCE "public"."users_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."users_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."users_id_seq" TO "service_role";









ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES TO "service_role";






ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS TO "service_role";






ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES TO "service_role";



































