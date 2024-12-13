# Jogo de Adivinhação com Flask

Este é um simples jogo de adivinhação desenvolvido utilizando o framework Flask. O jogador deve adivinhar uma senha criada aleatoriamente, e o sistema fornecerá feedback sobre o número de letras corretas e suas respectivas posições.

## Funcionalidades

- Criação de um novo jogo com uma senha fornecida pelo usuário.
- Adivinhe a senha e receba feedback se as letras estão corretas e/ou em posições corretas.
- As senhas são armazenadas  utilizando base64.
- As adivinhações incorretas retornam uma mensagem com dicas.

## Estrutura do Projeto

Este projeto utiliza o Docker Compose para gerenciar a execução de múltiplos serviços. A configuração está definida no arquivo `docker-compose.yml` que contém os seguintes serviços:

* Banco de Dados (PostgreSQL)
* Backend (Flask)
* Frontend (React)
* Proxy Reverso (Nginx)

## Requisitos

- Docker e Docker Compose instalados no sistema.
- Certifique-se de que as portas 5432, 5000, 3000, e 80 estão disponíveis no host.

## Instalação

1. Instalação do Docker e Docker Compose no Ubuntu

```bash 
# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

# Verificar a Versão do Docker Compose
docker compose version

# Verificar a Versão do Docker
docker version

```

# Configuração dos Serviços

### **1. Banco de Dados (PostgreSQL)**

Este serviço fornece um banco de dados PostgreSQL para a aplicação.

 - Imagem: `postgres:15`
 - Container Name: `game_postgres`
 - Porta Exposta: `5432`
 - Rede: `game_network`
 - Variáveis de Ambiente:

    -   `POSTGRES_USER`: Nome do usuário administrador (default: `gameadmin`)
    -   `POSTGRES_PASSWORD`: Senha do administrador (default: `secretpassword`)
    -   `POSTGRES_DB`: Nome do banco de dados (default: `gamedb`)

Comando para acessar o banco de dados:

```bash
docker exec -it game_postgres psql -U gameadmin -d gamedb
```
### **2. Backend (Flask)**

Este serviço implementa a lógica de negócios usando Flask.

- Dockerfile: `Dockerfile-backend`
- Container Name: `flask-backend`
- Porta Exposta:` 5000`
- Variáveis de Ambiente:

    -   `FLASK_APP`: Arquivo principal do Flask (default: `run.py`)
    -   `FLASK_DB_TYPE`: Tipo do banco de dados (default: `postgres`)
    -   `FLASK_DB_USER`: Usuário do banco (default: `gameadmin`)
    -   `FLASK_DB_PASSWORD`: Senha do banco (default: `secretpassword`)
    -   `FLASK_DB_NAME`: Nome do banco (default: `gamedb`)
    -   `FLASK_DB_HOST`: Host do banco de dados (default: `db`)
    -   `FLASK_DB_PORT`: Porta do banco de dados (default: `5432`)

- Volume Persistente: Armazena os dados do banco em `pgdata` para persistência.
- Rede: `game_network`

Build do Backend:

Certifique-se de que o Dockerfile Dockerfile-backend está configurado corretamente. Para construir a imagem manualmente:

```bash
docker compose build backend
```

### **3. Frontend (React)**

Este serviço implementa a interface do usuário usando React.

-   **Dockerfile:** `Dockerfile-frontend`
-   **Container Name:** `react-frontend`
-   **Porta Exposta:** `3000`
-   **Variáveis de Ambiente:**
    -   `REACT_APP_BACKEND_URL`: URL do backend (default: `http://localhost:5000`)
-   **Dependências:** Depende do serviço `backend` para iniciar.
-   **Rede:** `game_network`

#### **Build do Frontend:**

Certifique-se de que o Dockerfile `Dockerfile-frontend` está configurado corretamente. Para construir a imagem manualmente:

```bash
docker compose build frontend
```

### **4. Proxy Reverso (Nginx)**

Este serviço implementa um proxy reverso usando Nginx para gerenciar o tráfego entre o frontend e o backend.

-   **Dockerfile:** `Dockerfile-nginx`
-   **Container Name:** `nginx-proxy`
-   **Porta Exposta:** `80`
-   **Dependências:** Depende do serviço `frontend` para iniciar.
-   **Rede:** `game_network`

## **Configuração de Volumes**

-   **Volume Persistente:** `pgdata`
    -   Local: `/var/lib/postgresql/data`
    -   Tipo: `local`
    -   Usado para persistir os dados do banco de dados PostgreSQL.

## **Como Executar a Aplicação**

### **Passo 1: Construir as Imagens**

Se necessário, você pode construir todas as imagens do projeto antes de iniciar:

`docker compose build` 

### **Passo 2: Subir os Contêineres**

Suba os serviços definidos no `docker-compose.yml`:


`docker compose up -d` 

-   O comando `-d` executa os serviços em segundo plano.


## **Gerenciamento de Contêineres**

### **Verificar o Status dos Serviços**

`docker compose ps` 

### **Parar os Contêineres**

`docker compose down` 

### **Reiniciar os Contêineres**

`docker compose restart` 

----------

## **Monitoramento e Debug**

### **Visualizar Logs**

Para visualizar os logs de todos os serviços:

`docker compose logs -f` 

Para visualizar logs de um serviço específico:


`docker compose logs -f <service_name>` 

### **Acessar um Contêiner**

Para acessar um terminal de dentro de um contêiner:

`docker exec -it <container_name> /bin/sh`

## **Considerações Finais**

Este setup utiliza o Docker Compose para facilitar o desenvolvimento, permitindo que todos os serviços sejam gerenciados de forma centralizada.

-   Certifique-se de configurar corretamente os arquivos `Dockerfile-*` e validar que todas as dependências estão instaladas nos serviços.
