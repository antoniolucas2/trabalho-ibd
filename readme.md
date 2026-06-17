# Projeto Final: Introdução A Banco de Dados

## Universidade Federal de Minas Gerais - Departamento de Ciência da Computação

## Introdução 

Esse projeto foi feito para cumprir com trabalho final
da disciplina de Introdução A Banco de Dados. O intuito do 
projeto era desenvolver um banco de dados utilizando alguma
base de dados reais. A base de dados escolhida foi a de
**Compras Públicas do governo**.

## Como Instalar o Banco

Para conseguir rodar o banco localmente, primeiramente, é necessario 
ter instalado na sua máquina:

- SGBD Postgress
- Python 3
- Make

Depois de clonar o repositório execute:

```bash
pip install requirements.txt

```

Para criar e popular o banco de dados rode:

```bash 
make populate <nome_banco_de_dados> <nome_usuario> <password>
```

Após essas sequências de comandos o banco deve estar pronto para ser usado.

## Executar Queries Pre-Definidas

Algumas queries já foram implementadas e estão disponíveis para serem executadas. 
Execute o seguinte comando:

```bash
  make execute_query USER=<nome_usuario> DB_NAME=<nome_banco_de_dados>
```

Um menu interativo deve aparecer no terminal:

![CLI Menu](images/cli_menu.png)
