# Importa as variáveis do arquivo database.py
import sqlite3

from CONT import conn, cursor

def cadastrar_usuario(nome, email):
    try:
        cursor.execute(
            "INSERT INTO usuarios (nome, email) VALUES (?, ?)", 
            (nome, email)
        )
        conn.commit()
        print(f"✅ Usuário '{nome}' cadastrado com sucesso!")
    except sqlite3.IntegrityError:
        print(f"❌ Erro: O e-mail '{email}' já existe no banco.")

# Executa o teste ao rodar este arquivo
if __name__ == "__main__":
    print("--- EXECUTANDO CREATE ---")
    cadastrar_usuario("Ana Silva", "ana@email.com")
    cadastrar_usuario("Carlos Souza", "carlos@email.com")
    cadastrar_usuario("Mateus de Paula", "mtps18_@hotmail.com")