-- ============================================================
-- 0. LIMPEZA PREVIA DO BANCO (Para evitar conflitos de reexecução)
-- ============================================================
DROP TABLE IF EXISTS Consulta CASCADE;
DROP TABLE IF EXISTS Medico CASCADE;
DROP TABLE IF EXISTS Paciente CASCADE;
DROP TABLE IF EXISTS Especialidade CASCADE;


-- ============================================================
-- 1. ESTRUTURA E DADOS INICIAIS (Questão 14)
-- ============================================================

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

-- Inserir dados iniciais
INSERT INTO Medico (id, nome, altura) VALUES
(1, 'M1', 1.70),
(2, 'M2', 1.80),
(3, 'M3', 1.90),
(4, 'M4', 1.68);

INSERT INTO Paciente (id, nome) VALUES
(1, 'P1'),
(2, 'P2'),
(3, 'P3');

-- QUESTÃO 14: Nome do médico mais alto usando IN
SELECT 'Questão 14' AS questao, nome 
FROM Medico 
WHERE altura IN (
    SELECT MAX(altura) 
    FROM Medico
);


-- ============================================================
-- 2. QUESTÃO 15
-- ============================================================

-- Inserção do novo médico
INSERT INTO Medico (id, nome, altura) VALUES (5, 'M5', 1.68);

-- QUESTÃO 15: Nome do médico mais baixo usando IN
SELECT 'Questão 15' AS questao, nome 
FROM Medico 
WHERE altura IN (
    SELECT MIN(altura) 
    FROM Medico
);


-- ============================================================
-- 3. QUESTÃO 16
-- ============================================================

-- Criar tabela Consulta
CREATE TABLE Consulta (
    id INT PRIMARY KEY,
    idPaciente INT REFERENCES Paciente(id),
    idMedico INT REFERENCES Medico(id),
    data DATE
);

-- Inserir dados das consultas
INSERT INTO Consulta (id, idPaciente, idMedico, data) VALUES
(1, 1, 1, '2016-10-10'),
(2, 2, 1, '2016-12-05'),
(3, 3, 2, '2017-02-03'),
(4, 1, 3, '2016-12-15');

-- QUESTÃO 16: Médicos com consulta em dezembro/2016 usando IN
SELECT 'Questão 16' AS questao, nome 
FROM Medico 
WHERE id IN (
    SELECT idMedico 
    FROM Consulta 
    WHERE data BETWEEN '2016-12-01' AND '2016-12-31'
);


-- ============================================================
-- 4. QUESTÃO 17 E 18
-- ============================================================

-- Adicionar coluna idade e atualizar dados
ALTER TABLE Paciente ADD COLUMN idade INT;

UPDATE Paciente SET idade = 10 WHERE id = 1;
UPDATE Paciente SET idade = 22 WHERE id = 2;
UPDATE Paciente SET idade = 38 WHERE id = 3;

-- QUESTÃO 17: Pacientes > 21 anos com consulta marcada usando IN
SELECT 'Questão 17' AS questao, nome 
FROM Paciente 
WHERE idade > 21 
  AND id IN (
      SELECT idPaciente 
      FROM Consulta
  );

-- QUESTÃO 18: Pacientes exceto o mais jovem usando ANY
SELECT 'Questão 18' AS questao, nome 
FROM Paciente 
WHERE idade > ANY (
    SELECT idade 
    FROM Paciente
);


-- ============================================================
-- 5. QUESTÃO 19
-- ============================================================

-- Criar tabela Especialidade
CREATE TABLE Especialidade (
    id INT PRIMARY KEY,
    nome VARCHAR(50)
);

INSERT INTO Especialidade (id, nome) VALUES
(1, 'Cardiologia'),
(2, 'Ortopedia'),
(3, 'Pediatria');

-- Alterar tabela Medico
ALTER TABLE Medico ADD COLUMN salario NUMERIC(10,2);
ALTER TABLE Medico ADD COLUMN idEspecialidade INT REFERENCES Especialidade(id);

-- Atualizar salários e especialidades dos médicos
UPDATE Medico SET salario = 1000.00, idEspecialidade = 3 WHERE id = 1;
UPDATE Medico SET salario = 5000.00, idEspecialidade = 2 WHERE id = 2;
UPDATE Medico SET salario = 10000.00, idEspecialidade = 1 WHERE id = 3;
UPDATE Medico SET salario = 12000.00, idEspecialidade = 3 WHERE id = 4;
UPDATE Medico SET salario = 15000.00, idEspecialidade = 1 WHERE id = 5;

-- QUESTÃO 19: Médicos com salário superior a TODOS os de Pediatria (usando ALL)
SELECT 'Questão 19' AS questao, nome 
FROM Medico 
WHERE salario > ALL (
    SELECT m.salario 
    FROM Medico m
    JOIN Especialidade e ON m.idEspecialidade = e.id
    WHERE e.nome = 'Pediatria'
);


-- ============================================================
-- 6. QUESTÃO 20
-- ============================================================

-- Inserir novo paciente
INSERT INTO Paciente (id, nome, idade) VALUES (4, 'P4', 44);

-- QUESTÃO 20: Pacientes que realizaram consulta ao menos uma vez
SELECT 'Questão 20' AS questao, nome 
FROM Paciente 
WHERE id IN (
    SELECT idPaciente 
    FROM Consulta
);