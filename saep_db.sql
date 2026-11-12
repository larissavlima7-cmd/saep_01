-- criar o banco
CREATE DATABASE saep_dvp1;

-- tabela de usuários
CREATE TABLE IF NOT EXISTS usuarios (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(128) NOT NULL,
    email VARCHAR(128) NOT NULL,
    senha_hash VARCHAR(128) NOT NULL,
    perfil VARCHAR(128) NOT NULL CHECK (perfil IN ('admin', 'veterinario', 'recepcionista')),
    criado_em TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

--  tabela Tutores
CREATE TABLE IF NOT EXISTS tutores (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(128) NOT NULL,
    cpf_criptografado VARCHAR(128) NOT NULL,
    telefone VARCHAR(128) NOT NULL,
    email VARCHAR(128) NOT NULL,
    criado_em TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- tabela de Pets
CREATE TABLE IF NOT EXISTS pets (
    id SERIAL PRIMARY KEY,
    tutor_id INTEGER NOT NULL REFERENCES tutores(id) ON DELETE CASCADE,
    nome VARCHAR(128) NOT NULL,
    especie VARCHAR(128) NOT NULL,
    raca VARCHAR(128) NOT NULL,
    data_nascimento DATE NOT NULL,
    cadastrado_em TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- tabela de Agendamentos - Ordenada
CREATE TABLE IF NOT EXISTS agendamentos (
    id SERIAL PRIMARY KEY,
    tutor_id INTEGER NOT NULL REFERENCES tutores(id) ON DELETE CASCADE,
    pet_id INTEGER NOT NULL REFERENCES pets(id) ON DELETE CASCADE,
    usuario_id INTEGER NOT NULL REFERENCES usuarios(id) ON DELETE CASCADE,
    data_agendamento DATE NOT NULL,
    hora_agendamento TIME NOT NULL,
    servico VARCHAR(128) NOT NULL,
    status VARCHAR(128) NOT NULL DEFAULT 'AGENDADO' CHECK (status IN ('AGENDADO', 'CONCLUIDO', 'CANCELADO')),
    observacao TEXT,
    criado_em TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO usuarios (nome, email, senha_hash, perfil) VALUES
('Dra. Maria Albuquerque', 'mariaal.vet@cuidamigos.com', '$2y$12$vIkXeCv8cOXjJ5QFpbRSxODd27KOZIYEad6xXhBVHVAd8HJLxS21e', 'veterinario'),
('Matias Bueno', 'matias.recepcao@cuidamigos.com', '$2y$12$vIkXeCv8cOXjJ5QFpbRSxODd27KOZIYEad6xXhBVHVAd8HJLxS21e', 'recepcionista'),
('Isabela Costa', 'gestao@cuidamigos.com', '$2y$12$vIkXeCv8cOXjJ5QFpbRSxODd27KOZIYEad6xXhBVHVAd8HJLxS21e', 'admin');

INSERT INTO tutores (id, nome, cpf_criptografado, telefone, email) VALUES
(1, 'Thais Silva Santos', 'u6P8bE2VdG8rS1k9xL4q+w==', '(11) 98765-4321', 'thais.silva@email.com'),
(2, 'Beatriz Vieira Martins', 'z8K9jF3WdH9sT2l0yM5r+x==', '(11) 97654-3210', 'beatriz.martins@email.com'),
(3, 'Thiago Novais Lima', 'w7L0kG4XeI0tU3m1zN6s+y==', '(19) 99123-4567', 'thiago.lima@email.com');

INSERT INTO pets (id, tutor_id, nome, especie, raca, data_nascimento) VALUES
(1, 1, 'Paçoca', 'Canina', 'Golden Retriever', '2021-05-10'),
(2, 2, 'Amora', 'Felina', 'Siamês', '2022-08-15'),
(3, 3, 'Mel', 'Canina', 'Bulldog Francês', '2020-02-20');

INSERT INTO agendamentos (id, tutor_id, pet_id, usuario_id, data_agendamento, hora_agendamento, servico, status, observacao) VALUES
(1, 1, 1, 1, '2024-11-15', '09:30:00', 'Consulta Geral e Vacinação Anual', 'CONCLUIDO', 'Animal dócil e com carteira atualizada'),
(2, 2, 2, 1, '2025-06-20', '14:00:00', 'Profilaxia Dentária e Tartarectomia', 'CONCLUIDO', 'Exames pré-operatórios normais'),
(3, 3, 3, 2, '2026-03-10', '10:30:00', 'Check-up Preventivo e Exame de Sangue', 'AGENDADO', 'Paciente alérgico a dipirona');

SELECT setval('usuarios_id_seq', (SELECT MAX(id) FROM usuarios));
SELECT setval('tutores_id_seq', (SELECT MAX(id) FROM tutores));
SELECT setval('pets_id_seq', (SELECT MAX(id) FROM pets));
SELECT setval('agendamentos_id_seq', (SELECT MAX(id) FROM agendamentos));