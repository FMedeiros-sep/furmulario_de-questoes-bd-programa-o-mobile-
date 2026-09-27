-- Table: public.erp_user

-- DROP TABLE IF EXISTS public.erp_user;

-- 1. Criação da tabela users
CREATE TABLE users (
    id BIGSERIAL PRIMARY KEY,
    name TEXT,
    password TEXT
);

-- 2. Criação da tabela accounts
CREATE TABLE accounts (
    id BIGINT PRIMARY KEY,
    idade INTEGER,
    cpf INTEGER,
    user_id INTEGER UNIQUE,
    CONSTRAINT fk_user
        FOREIGN KEY (user_id) 
        REFERENCES users (id)
        ON DELETE CASCADE
);