from CONT import cursor

def listar_usuarios():
    cursor.execute("SELECT id, nome, email FROM usuarios")
    usuarios = cursor.fetchall()
    
    print("\n--- LISTA DE USUÁRIOS ATUAIS ---")
    if not usuarios:
        print("Nenhum usuário cadastrado.")
    for usuario in usuarios:
        print(f"ID: {usuario[0]} | Nome: {usuario[1]} | E-mail: {usuario[2]}")
    print("--------------------------------\n")

if __name__ == "__main__":
    print("--- EXECUTANDO READ ---")
    listar_usuarios()