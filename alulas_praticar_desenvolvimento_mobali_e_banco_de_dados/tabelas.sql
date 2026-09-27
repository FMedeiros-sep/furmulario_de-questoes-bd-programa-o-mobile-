-- Criar tabelas iniciais
CREATE TABLE Medico (
    id INT PRIMARY KEY,
    nome VARCHAR(50),
    altura NUMERIC(3,2)
);

CREATE TABLE Paciente (
    id INT PRIMARY KEY,
    nome VARCHAR(50)
);

-- Inserir dados iniciais da questão 14
INSERT INTO Medico (id, nome, altura) VALUES
(1, 'mt', 1.7),
(2, 'andre', 1.8),
(3, 'fernando', 1.9),
(4, 'elias', 1.68);

INSERT INTO Paciente (id, nome) VALUES
(1, 'maria'),
(2, 'jose'),
(3, 'ana');