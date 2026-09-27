-- Inserção do novo médico
INSERT INTO Medico (id, nome, altura) VALUES (4, 'elias', 1.68);

-- Query de busca
SELECT nome 
FROM Medico 
WHERE altura IN (
    SELECT MIN(altura) 
    FROM Medico
);