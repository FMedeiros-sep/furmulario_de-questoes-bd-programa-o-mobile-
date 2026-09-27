from CONT import conn, cursor

def deletar_usuario(id_usuario):
    cursor.execute("DELETE FROM usuarios WHERE id = ?", (id_usuario,))
    conn.commit()
    
    if cursor.rowcount > 0:
        print(f"🗑️ Usuário ID {id_usuario} removido com sucesso!")
    else:
        print(f"⚠️ Usuário ID {id_usuario} não foi encontrado.")

if __name__ == "__main__":
    print("--- EXECUTANDO DELETE ---")

    # Deleta a Ana (ID 1)
    deletar_usuario(1)