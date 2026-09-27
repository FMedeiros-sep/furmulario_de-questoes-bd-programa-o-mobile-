import sqlite3

# Conecta ao banco de dados
conn = sqlite3.connect("sistema.db")
cursor = conn.cursor()

cursor.execute("""
        CREATE TABLE IF NOT EXISTS usuarios (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nome TEXT NOT NULL,
            email TEXT UNIQUE NOT NULL
        )
    """)
