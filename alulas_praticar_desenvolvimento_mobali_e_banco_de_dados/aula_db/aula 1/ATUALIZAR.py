from CONT import conn, cursor

def atualizar_usuario(id_usuario, novo_nome, novo_email):
    cursor.execute(
        "UPDATE usuarios SET nome = ?, email = ? WHERE id = ?",
        (novo_nome, novo_email, id_usuario)
    )
    conn.commit()
    
    if cursor.rowcount > 0:
        print(f"🔄 Usuário ID {id_usuario} atualizado com sucesso!")
    else:
        print(f"⚠️ Usuário ID {id_usuario} não foi encontrado.")

if __name__ == "__main__":
    print("--- EXECUTANDO UPDATE ---")

    # Altera o Carlos (ID 2) que criamos no arquivo 1
    atualizar_usuario(2, "jose S. Santos", "carlos.santos@email.com")