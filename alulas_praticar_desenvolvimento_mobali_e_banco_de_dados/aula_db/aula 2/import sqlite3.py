import sqlite3

# Conecta ao banco de dados
conn = sqlite3.connect("sistema.db")
cursor = conn.cursor()

# Ativa chaves estrangeiras
cursor.execute("PRAGMA foreign_keys = ON;")


def inicializar_banco():
    """Cria as tabelas usuarios e pedidos se não existirem."""
    cursor.execute("""
        CREATE TABLE IF NOT EXISTS usuarios (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nome TEXT NOT NULL,
            email TEXT UNIQUE NOT NULL
        )
    """)

    # Tabela auxiliar para permitir JOIN e GROUP BY
    cursor.execute("""
        CREATE TABLE IF NOT EXISTS pedidos (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            usuario_id INTEGER NOT NULL,
            valor REAL NOT NULL,
            FOREIGN KEY (usuario_id) REFERENCES usuarios (id) ON DELETE CASCADE
        )
    """)
    conn.commit()


# Inicializa o banco
inicializar_banco()


# ==========================================
# FUNÇÕES DO CRUD BÁSICO
# ==========================================


def criar_usuario(nome: str, email: str):
    try:
        cursor.execute(
            "INSERT INTO usuarios (nome, email) VALUES (?, ?)", (nome, email)
        )
        conn.commit()
        print(
            f"\n✅ Usuário '{nome}' cadastrado com sucesso! (ID: {cursor.lastrowid})"
        )
    except sqlite3.IntegrityError:
        print(f"\n❌ Erro: O e-mail '{email}' já está cadastrado.")


def criar_pedido(usuario_id: int, valor: float):
    """Função auxiliar para cadastrar compras/pedidos para os testes."""
    try:
        cursor.execute(
            "INSERT INTO pedidos (usuario_id, valor) VALUES (?, ?)",
            (usuario_id, valor),
        )
        conn.commit()
        print(f"\n✅ Pedido de R$ {valor:.2f} registrado para o Usuário ID {usuario_id}!")
    except sqlite3.IntegrityError:
        print(f"\n❌ Erro: Usuário ID {usuario_id} não existe.")


def atualizar_usuario(usuario_id: int, novo_nome: str, novo_email: str):
    cursor.execute(
        "SELECT nome, email FROM usuarios WHERE id = ?", (usuario_id,)
    )
    usuario = cursor.fetchone()
    if not usuario:
        print(f"\n⚠️ Usuário com ID {usuario_id} não encontrado.")
        return

    nome_final = novo_nome if novo_nome.strip() else usuario[0]
    email_final = novo_email if novo_email.strip() else usuario[1]

    try:
        cursor.execute(
            "UPDATE usuarios SET nome = ?, email = ? WHERE id = ?",
            (nome_final, email_final, usuario_id),
        )
        conn.commit()
        print(f"\n✅ Usuário ID {usuario_id} atualizado com sucesso!")
    except sqlite3.IntegrityError:
        print(
            f"\n❌ Erro: O e-mail '{novo_email}' já pertence a outro usuário."
        )


def deletar_usuario(usuario_id: int):
    cursor.execute("DELETE FROM usuarios WHERE id = ?", (usuario_id,))
    conn.commit()
    if cursor.rowcount > 0:
        print(f"\n✅ Usuário ID {usuario_id} removido com sucesso!")
    else:
        print(f"\n⚠️ Nenhum usuário encontrado com o ID {usuario_id}.")


# ==========================================
# CONSULTAS SQL (SELECT, JOIN, GROUP BY / HAVING)
# ==========================================


def consultar_select_simples():
    """1. SELECT Simples: Busca apenas nomes e emails ordenados por nome."""
    cursor.execute("SELECT id, nome, email FROM usuarios ORDER BY nome ASC")
    resultados = cursor.fetchall()

    print("\n--- [SELECT] LISTA DE USUÁRIOS (ORDEM ALFABÉTICA) ---")
    if not resultados:
        print("Nenhum usuário cadastrado.")
        return

    print(f"{'ID':<5} | {'NOME':<20} | {'E-MAIL':<25}")
    print("-" * 55)
    for u in resultados:
        print(f"{u[0]:<5} | {u[1]:<20} | {u[2]:<25}")


def consultar_join():
    """2. INNER JOIN: Junta a tabela 'usuarios' com a tabela 'pedidos'."""
    query = """
        SELECT 
            usuarios.id, 
            usuarios.nome, 
            pedidos.id AS pedido_id, 
            pedidos.valor 
        FROM usuarios
        INNER JOIN pedidos ON usuarios.id = pedidos.usuario_id
    """
    cursor.execute(query)
    resultados = cursor.fetchall()

    print("\n--- [JOIN] USUÁRIOS E SEUS PEDIDOS ---")
    if not resultados:
        print("Nenhum pedido encontrado ligado a um usuário.")
        return

    print(f"{'ID USR':<8} | {'NOME':<20} | {'ID PEDIDO':<10} | {'VALOR':<10}")
    print("-" * 58)
    for r in resultados:
        print(f"{r[0]:<8} | {r[1]:<20} | {r[2]:<10} | R$ {r[3]:<8.2f}")


def consultar_group_by_having(min_gastos: float = 100.0):
    """3. GROUP BY + HAVING: Agrupa o total gasto por usuário e filtra quem gastou acima do valor."""
    query = """
        SELECT 
            usuarios.nome, 
            COUNT(pedidos.id) AS total_pedidos, 
            SUM(pedidos.valor) AS total_gasto
        FROM usuarios
        INNER JOIN pedidos ON usuarios.id = pedidos.usuario_id
        GROUP BY usuarios.id, usuarios.nome
        HAVING total_gasto >= ?
    """
    cursor.execute(query, (min_gastos,))
    resultados = cursor.fetchall()

    print(
        f"\n--- [GROUP BY + HAVING] USUÁRIOS COM GASTO TOTAL >= R$ {min_gastos:.2f} ---"
    )
    if not resultados:
        print(
            f"Nenhum usuário atingiu o limite mínimo de R$ {min_gastos:.2f}."
        )
        return

    print(f"{'NOME':<20} | {'QTD PEDIDOS':<12} | {'TOTAL GASTO':<12}")
    print("-" * 50)
    for r in resultados:
        print(f"{r[0]:<20} | {r[1]:<12} | R$ {r[2]:<10.2f}")


# ==========================================
# INTERFACE DO MENU INTERATIVO
# ==========================================


def menu():
    while True:
        print("\n==============================")
        print("    GERENCIADOR DE USUÁRIOS   ")
        print("==============================")
        print("1. Cadastrar Usuário")
        print("2. Registrar Pedido para Usuário (Para testes)")
        print("3. [SELECT] Listar Todos os Usuários")
        print("4. [JOIN] Listar Usuários + Pedidos")
        print("5. [GROUP BY / HAVING] Filtrar Clientes por Total Gasto")
        print("6. Atualizar Usuário")
        print("7. Deletar Usuário")
        print("0. Sair")
        print("==============================")

        opcao = input("Escolha uma opção: ").strip()

        if opcao == "1":
            nome = input("Nome: ").strip()
            email = input("E-mail: ").strip()
            if nome and email:
                criar_usuario(nome, email)

        elif opcao == "2":
            try:
                usr_id = int(input("ID do Usuário: "))
                valor = float(input("Valor do Pedido (R$): "))
                criar_pedido(usr_id, valor)
            except ValueError:
                print("\n❌ Entrada inválida. Digite números válidos.")

        elif opcao == "3":
            consultar_select_simples()

        elif opcao == "4":
            consultar_join()

        elif opcao == "5":
            try:
                valor_min = float(
                    input("Filtrar clientes com total gasto a partir de R$: ")
                )
                consultar_group_by_having(valor_min)
            except ValueError:
                print("\n❌ Por favor, digite um número válido.")

        elif opcao == "6":
            try:
                usr_id = int(input("\nID do usuário a atualizar: "))
                novo_nome = input("Novo Nome (ENTER p/ manter): ")
                novo_email = input("Novo E-mail (ENTER p/ manter): ")
                atualizar_usuario(usr_id, novo_nome, novo_email)
            except ValueError:
                print("\n❌ Digite um ID numérico válido.")

        elif opcao == "7":
            try:
                usr_id = int(input("\nID do usuário a deletar: "))
                if (
                    input(f"Deletar ID {usr_id}? (s/n): ").strip().lower()
                    == "s"
                ):
                    deletar_usuario(usr_id)
            except ValueError:
                print("\n❌ Digite um ID numérico válido.")

        elif opcao == "0":
            print("\nEncerrando e fechando o banco...")
            conn.close()
            break


if __name__ == "__main__":
    menu()