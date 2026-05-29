import json


def treat_population(pop: str):
    try:
        population = int(pop)
        return population
    except ValueError:
        return 'NULL'


def generate_populate(file_path: str, output_path: str):
    cmd = [(
        "INSERT INTO Municipio(codigo_ibge, nome_municipio,"
        "sigla_uf, regiao, populacao) VALUES"
    )]

    with open(file_path, 'r') as input:
        data = json.load(input)
        cities_amount = len(data)
        counter = 0
        for city in data:
            counter += 1
            ibge = city["codigo_ibge"]
            name = city["nome"].replace("'", "''")
            acronym_uf = city["sigla_uf"]
            region = city["regiao"]
            population = treat_population(city["populacao"])
            line = (
                  f"({ibge}, '{name}', '{acronym_uf}', "
                  f"'{region}', {population})"
            )
            if counter < cities_amount:
                line += ','
            elif counter == cities_amount:
                line += ';'
            cmd.append(line)
    with open(output_path, 'w') as output:
        out_data = "\n".join(cmd)
        output.write(out_data)


def main():
    print("Running Populate Country Script...")
    JSON_PATH = 'municipios.json'
    OUTPUT_PATH = '../populate1/01_municipios.sql'
    generate_populate(JSON_PATH, OUTPUT_PATH)


if __name__ == '__main__':
    main()
