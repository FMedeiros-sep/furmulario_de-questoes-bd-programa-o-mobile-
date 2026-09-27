-- QUESTÃO 20: Pacientes que realizaram consulta ao menos uma vez
SELECT 'Questão 20' AS questao, nome 
FROM Paciente 
WHERE id IN (
    SELECT idPaciente 
    FROM Consulta
);