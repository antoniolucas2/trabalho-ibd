import psycopg2
import os
import sys
import subprocess

DEFAULT_USER = 'postgres'
DEFAULT_DATA_BASE = 'compras_publicas'
DEFAULT_PASSWORD = ''
DB_CONFIG = "dbname=<data_base> user=<user> host=localhost password=<password>"

CLASS_FILE = 'data/classe.jsonl'
GROUP_FILE = 'data/grupo.jsonl'
CNAE_FILE = 'data/cnae.jsonl'
MATERIALS_FILE = 'data/materiais.jsonl'
SERVICES_FILE = 'data/servico.jsonl'
TOWNS_FILE = 'data/municipios.jsonl'
BODY_FILE = 'data/orgaos.jsonl'
UASG_FILE = 'data/uasg.jsonl'
BIDDING_FILE = 'data/licitacoes.jsonl'
ITEMS_FILE = 'data/itens_licitacoes.jsonl'
PROVIDERS_FILE = 'data/fornecedores.jsonl'

DATA_BASE_DUMP_FILE = 'scripts/data_base_dump.sql'

def create_staging_table(cur, conn, table_name, file_path):
    print(f"Creating temporary table : {table_name}")

    cur.execute(f"DROP TABLE IF EXISTS {table_name};")
    cur.execute(f"""
        CREATE TABLE {table_name} (
            content_json JSONB
        );
    """)

    conn.commit()

    sql_copy = f"COPY {table_name} (content_json) FROM STDIN WITH (FORMAT text);"

    with open(file_path, 'r', encoding='utf-8') as file:
        cur.copy_expert(sql_copy, file)

    conn.commit()

    print(f"{table_name} injection concluded with success.")


def insert_into(cur, conn, sql_insertion):
    cur.execute(sql_insertion)
    conn.commit()


def remove_staging_table(cur, conn, table_name):
    cur.execute(f"DROP TABLE IF EXISTS {table_name};")
    conn.commit()


def inject_cnea(cur, conn):
    staging_table = "staging_cnae_json"
    create_staging_table(cur, conn, staging_table, CNAE_FILE)

    sql_insertion = f"""
        INSERT INTO CNAE (codigo_cnae, nome_cnae)
        SELECT (content_json->>'codigo_cnae')::INT as codigo_cnae,
                content_json->>'nome_cnae' as nome_cnae
        FROM {staging_table}
        ON CONFLICT (codigo_cnae) DO NOTHING;

    """
    insert_into(cur, conn, sql_insertion)
    remove_staging_table(cur, conn, staging_table)
    print("CNAE table populated with success.")


def inject_group(cur, conn):
    staging_table = "staging_grupo_json"
    create_staging_table(cur, conn, staging_table, GROUP_FILE)

    sql_insertion = f"""
        INSERT INTO Grupo (codigo_grupo, nome_grupo, tipo_item)
        SELECT (content_json->>'codigo_grupo')::INT as codigo_grupo,
        content_json->>'nome_grupo' as nome_grupo,
        content_json->>'tipo_item' as tipo_item
        FROM {staging_table}
        ON CONFLICT (codigo_grupo) DO NOTHING;
    """

    insert_into(cur, conn, sql_insertion)
    remove_staging_table(cur, conn, staging_table)
    print("Grupo table populated with success.")


def inject_class(cur, conn):
    staging_table = "staging_class_json"
    create_staging_table(cur, conn, staging_table, CLASS_FILE)

    cur.execute(f"""
            UPDATE {staging_table}
            SET content_json = jsonb_set(
                content_json,
                '{{nome_classe}}',
                '"Nao Definido"'
            )
            WHERE content_json->>'nome_classe' IS NULL;
            """)
    conn.commit()

    sql_insertion = f"""
        INSERT INTO Classe (codigo_classe, nome_classe, codigo_grupo)
        SELECT (content_json->>'codigo_classe')::INT as codigo_grupo,
               content_json->>'nome_classe' as nome_classe,
               (content_json->>'codigo_grupo')::INT as codigo_grupo
        FROM {staging_table}
        WHERE content_json->>'codigo_classe' IS NOT NULL
        ON CONFLICT (codigo_classe) DO NOTHING;
    """

    insert_into(cur, conn, sql_insertion)
    remove_staging_table(cur, conn, staging_table)
    print("Classe table populated with success.")


def inject_material(cur, conn):
    staging_table = "staging_materials_json"
    create_staging_table(cur, conn, staging_table, MATERIALS_FILE)

    sql_insertion = f"""
        INSERT INTO Material (codigo_item, nome_material,
                              descricao_item, item_sustentavel, status, codigo_classe)
        SELECT (content_json->>'codigo_item')::INT as codigo_item,
               content_json->>'nome_material' as nome_material,
               SUBSTRING(content_json->>'descricao_item' FROM 1 FOR 800) as descricao_item,
               (content_json->>'item_sustentavel')::BOOLEAN as item_sustentavel,
               (content_json->>'status')::BOOLEAN as status,
               (content_json->>'codigo_classe')::INT as codigo_classe
        FROM {staging_table}
        ON CONFLICT DO NOTHING;
    """

    insert_into(cur, conn, sql_insertion)
    remove_staging_table(cur, conn, staging_table)
    print("Material table populated with success")


def inject_service(cur, conn):
    staging_table = "staging_services_json"
    create_staging_table(cur, conn, staging_table, SERVICES_FILE)

    sql_insertion = f"""
        INSERT INTO Servico (codigo_servico, nome_servico,
                             status, codigo_classe)
        SELECT (content_json->>'codigo_servico')::INT as codigo_servico,
               content_json->>'nome_servico' as nome_servico,
               (content_json->>'status')::BOOLEAN as status,
               (content_json->>'codigo_classe')::INT as codigo_classe
        FROM {staging_table}
        ON CONFLICT DO NOTHING;
    """

    insert_into(cur, conn, sql_insertion)
    remove_staging_table(cur, conn, staging_table)
    print("Servico table populated with success")


def inject_town(cur, conn):
    staging_table = 'staging_towns_table'
    create_staging_table(cur, conn, staging_table, TOWNS_FILE)

    sql_insertion = f"""
        INSERT INTO Municipio (codigo_ibge, nome_municipio, sigla_uf,
                               regiao, populacao)
        SELECT (content_json->>'codigo_ibge')::INT as codigo_ibge,
                content_json->>'nome' as nome_municipio,
                content_json->>'sigla_uf' as sigla_uf,
                content_json->>'regiao' as regiao,
                (content_json->>'populacao')::INT as populacao
        FROM {staging_table}
        ON CONFLICT DO NOTHING;
    """
    insert_into(cur, conn, sql_insertion)
    remove_staging_table(cur, conn, staging_table)
    print("Municipio table populated with success")


def inject_body(cur, conn):
    staging_table = 'staging_bodies_table'
    create_staging_table(cur, conn, staging_table, BODY_FILE)

    sql_insertion_adm_type = f"""
        INSERT INTO TipoAdm (codigo_adm, nome_adm)
        SELECT (content_json->>'codigo_adm')::INT as codigo_adm,
                content_json->>'nome_adm' as nome_adm
        FROM {staging_table}
        ON CONFLICT DO NOTHING;
    """

    sql_insertion_body = f"""
        ALTER TABLE Orgao
        DROP CONSTRAINT fk_orgao_superior;

        INSERT INTO Orgao (codigo_orgao, nome_orgao, codigo_municipio,
                            codigo_orgao_superior, codigo_adm, poder, esfera)
        SELECT (content_json->>'codigo_orgao')::INT as codigo_orgao,
               content_json->>'nome_orgao' as nome_orgao,
               (content_json->>'codigo_municipio')::INT as codigo_municipio,
               (content_json->>'codigo_orgao_superior')::INT as codigo_orgao_superior,
               (content_json->>'codigo_adm')::INT as codigo_adm,
               content_json->>'poder' as poder,
               content_json->>'esfera' as esfera
        FROM {staging_table}
        ON CONFLICT DO NOTHING;

        ALTER TABLE Orgao
        ADD CONSTRAINT fk_orgao_superior
        FOREIGN KEY (codigo_orgao_superior)
        REFERENCES Orgao(codigo_orgao)
        ON UPDATE CASCADE
        ON DELETE SET NULL;
    """

    insert_into(cur, conn, sql_insertion_adm_type)
    insert_into(cur, conn, sql_insertion_body)
    remove_staging_table(cur, conn, staging_table)
    print("TipoAdm and Orgao tables populated with success")


def inject_uasg(cur, conn):
    staging_table = 'staging_uasgs_table'
    create_staging_table(cur, conn, staging_table, UASG_FILE)

    sql_insertion = f"""
        INSERT INTO Uasg (codigo_uasg, nome_uasg, codigo_orgao,
                          codigo_municipio)
        SELECT (content_json->>'codigo_uasg') as codigo_uasg,
                content_json->>'nome_uasg' as nome_uasg,
                (content_json->>'codigo_orgao')::INT as codigo_orgao,
                (content_json->>'codigo_municipio')::INT as codigo_municipio
        FROM {staging_table}
        ON CONFLICT DO NOTHING;
    """
    insert_into(cur, conn, sql_insertion)
    remove_staging_table(cur, conn, staging_table)
    print("Uasg table populated with success")


def inject_provider(cur, conn):
    staging_table = 'staging_providers_table'
    create_staging_table(cur, conn, staging_table, PROVIDERS_FILE)

    sql_insertion = f"""
        INSERT INTO Fornecedor (cnpj, codigo_cnae,
                                codigo_municipio, nome_razao_social)
        SELECT content_json->>'cnpj' as cnpj,
        (content_json->>'codigo_cnae')::INT as codigo_cnae,
        (content_json->>'codigo_municipio')::INT as codigo_municipio,
        content_json->>'nome_razao_social' as nome_razao_social
        FROM {staging_table}
        ON CONFLICT DO NOTHING;
    """

    insert_into(cur, conn, sql_insertion)
    remove_staging_table(cur, conn, staging_table)
    print("Forncedor table populated with success")


def inject_bidding(cur, conn):
    staging_table = 'staging_biddings_table'
    create_staging_table(cur, conn, staging_table, BIDDING_FILE)

    sql_modality_insertion = f"""
        INSERT INTO ModalidadeLicitacao (codigo_modalidade, nome_modalidade)
        SELECT (content_json->>'codigo_modalidade')::INT as codigo_modalidade,
                content_json->>'nome_modalidade' as nome_modalidade
        FROM {staging_table}
        WHERE content_json->>'codigo_modalidade' IS NOT NULL
        ON CONFLICT DO NOTHING;
    """

    sql_bidding_insertion = f"""
        INSERT INTO Licitacao (id_compra, uasg, codigo_municipio,
                              codigo_modalidade, numero_licitacao,
                              nome_responsavel, numero_itens,
                              valor_total, data_publicacao)
        SELECT content_json->>'id_compra' as id_compra,
               content_json->>'uasg' as uasg,
               (content_json->>'codigo_municipio')::INT as codigo_municipio,
               (content_json->>'codigo_modalidade')::INT as codigo_modalidade,
               (content_json->>'numero_licitacao')::INT as numero_licitacao,
               content_json->>'nome_responsavel' as nome_responsavel,
               (content_json->>'numero_itens')::INT as numero_itens,
               ABS((content_json->>'valor_total')::DECIMAL(15,2)) as valor_total,
               (content_json->>'data_publicacao')::DATE as data_publicacao
        FROM {staging_table}
        ON CONFLICT DO NOTHING;
    """

    insert_into(cur, conn, sql_modality_insertion)
    insert_into(cur, conn, sql_bidding_insertion)
    remove_staging_table(cur, conn, staging_table)
    print("ModalidadeLicitacao e Licitacao tables populated with success")

def inject_item(cur, conn):
    staging_table = 'staging_items_table'
    create_staging_table(cur, conn, staging_table, ITEMS_FILE)

    sql_item_insertion = f"""
        INSERT INTO ItemLicitacao (id_compra_item, id_compra,
                                   numero_item_licitacao,
                                   uasg, criterio_julgamento,
                                   codigo_item_material, codigo_item_servico,
                                   quantidade, valor_estimado, cnpj_fornecedor,
                                   situacao_item, descricao_item)
        SELECT content_json->>'id_compra_item' as id_compra_item,
               content_json->>'id_compra' as id_compra,
               (content_json->>'numero_item_licitacao')::INT as numero_item_licitacao,
               content_json->>'uasg' as uasg,
               content_json->>'criterio_julgamento' as criterio_julgamento,
               (content_json->>'codigo_item_material')::INT as codigo_item_material,
               (content_json->>'codigo_servico')::INT as codigo_item_servico,
               (content_json->>'quantidade')::INT as quantidade,
               ABS((content_json->>'valor_estimado')::DECIMAL(15,2)) as valor_estimado,
               content_json->>'cnpj_fornecedor' as cnpj_fornecedor,
               content_json->>'situacao_item' as situacao_item,
               SUBSTRING(content_json->>'descricao_item' FROM 1 FOR 1000) as descricao_item
        FROM {staging_table}
        WHERE (content_json->>'codigo_item_material' IS NOT NULL)
              OR (content_json->>'codigo_servico' IS NOT NULL)
        ON CONFLICT DO NOTHING;
    """

    insert_into(cur, conn, sql_item_insertion)
    remove_staging_table(cur, conn, staging_table)
    print("Item table populated with success")


def populate_provider_uasg(cur, conn):
    sql_query = """
        INSERT INTO FornecedorUasg (cnpj_fornecedor, uasg)
        SELECT I.cnpj_fornecedor as cnpj_fornecedor, I.uasg as uasg
        FROM ItemLicitacao as I
        WHERE (I.uasg is not null) AND
              (I.cnpj_fornecedor is not null)
        ON CONFLICT DO NOTHING;
    """

    insert_into(cur, conn, sql_query)
    print("FornecedorUasg table populated with success")


def pipeline_injection(data_base: str, user: str, password: str):
    print(f"Connecting to DataBase ({data_base}) Postgres. User: {user}")
    config = (DB_CONFIG.replace("<data_base>", data_base)
              .replace("<user>", user)).replace("<password>", password)

    conn = psycopg2.connect(config)
    cur = conn.cursor()

    print("Starting DataBase populating...")
    try:
        inject_cnea(cur, conn)
        inject_group(cur, conn)
        inject_class(cur, conn)
        inject_material(cur, conn)
        inject_service(cur, conn)
        inject_town(cur, conn)
        inject_body(cur, conn)
        inject_uasg(cur, conn)
        inject_provider(cur, conn)
        inject_bidding(cur, conn)
        inject_item(cur, conn)
        populate_provider_uasg(cur, conn)
    except Exception as e:
        conn.rollback()
        print(f"Critical Error. {e}")
        print("All alterations was rollbacked. Nothing was saved.")
    finally:
        cur.close()
        conn.close()


def is_data_base_populated(data_base: str, user: str, password: str):
    config = (DB_CONFIG.replace("<data_base>", data_base,)
              .replace("<user>", user).replace("<password>", password))

    conn = psycopg2.connect(config)
    cur = conn.cursor()

    sql_query = """
            SELECT table_name
            FROM information_schema.tables
            WHERE table_schema = 'public';
    """

    cur.execute(sql_query)
    tables = cur.fetchall()

    for table in tables:
        sql_query = f"""
            SELECT EXISTS (SELECT 1 FROM {table[0]})
        """
        cur.execute(sql_query)
        has_column = cur.fetchone()

        if has_column[0]:
            return True

    return False


def populate_with_dump_file(data_base: str, user: str, password: str):
    is_populated = is_data_base_populated(data_base, user, password)

    if is_populated:
        print("DataBase is already populated.")
        answer = input(("Do you want to procceed populating"
                        " anyway (This can cause errors)? [y/n] "))
        if answer != 'y':
            return True

    try:
        cmd = ['psql',
               '-U', user,
               '-d', data_base,
               '-f', DATA_BASE_DUMP_FILE]

        result = subprocess.run(cmd, capture_output=True, text=True)
        result.check_returncode()
        return True
    except subprocess.CalledProcessError as e:
        print(f"Command failed with exit code: {e.returncode}")
        print("Error Output:\n", e.stderr)
        return False


def display_help():
    print(f"Program Usage: \n{sys.argv[0]} <data_base_name> <user_name> <password>")


def set_up(data_base: str, user: str):
    print(f"Creating DataBase: {data_base}")
    try:
        cmd = ['make', 'setup', f"USER={user}", f"DB_NAME={data_base}"]
        result = subprocess.run(cmd, capture_output=True, text=True)
        print("Output: ", result.stdout)
    except subprocess.CalledProcessError as e:
        print(f"Error Code: {e.returncode}")
        print("Error Output:\n", e.stderr)


def main():
    user = DEFAULT_USER
    data_base = DEFAULT_DATA_BASE
    password = DEFAULT_PASSWORD

    if len(sys.argv) > 1 and sys.argv[1] == 'help':
        display_help()
        return

    if len(sys.argv) == 4:
        data_base = sys.argv[1]
        user = sys.argv[2]
        password = sys.argv[3]
    elif len(sys.argv) > 4 or len(sys.argv) != 1:
        print("Invalid use. Please try again.")
        display_help()
        return
    try:
        exists_dump_file = os.path.isfile(DATA_BASE_DUMP_FILE)
        has_succeeded = False
        if exists_dump_file:
            print("Trying to run dump file...")
            has_succeeded = populate_with_dump_file(data_base, user, password)

        if (not exists_dump_file) or (not has_succeeded):
            if not has_succeeded:
                print("Dump file failed. Trying pipeline injection...")
            set_up(data_base, user)
            pipeline_injection(data_base, user, password)

    except Exception as e:
        print(f"A critical error has happened. {e}")
        return


if __name__ == '__main__':
    main()
