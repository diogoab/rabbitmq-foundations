# RabbitMQ Foundations
#### Este repositorio é dedicado ao treinamento - RabbitMQ Foundations
- Aula 01 - Introdução
- Aula 02 - Hand Ons - Parte 1
- Aula 03 - Hand Ons - Parte2

### O que o script faz:

**Instalação do Docker**: 
- Adiciona o repositório Docker, instala o Docker e o Docker Compose na máquina.

**Criação do `docker-compose.yml`**:
- Gera um arquivo `docker-compose.yml` configurado para rodar um cluster RabbitMQ com três nós.

**Configuração do RabbitMQ Cluster**:
- Cada nó RabbitMQ é configurado com um nome único e utiliza o mesmo cookie Erlang (`MY_SECRET_COOKIE`) para se autenticar como parte do cluster.
- As portas de gerenciamento (`15672`) e de comunicação (`5672`) do primeiro nó são mapeadas para a máquina host. Os outros nós só podem ser acessados via rede interna do Docker.

### Como usar:

1. Salve o script acima em um arquivo, por exemplo, `install_rabbitmq_cluster.sh`.
2. Torne o script executável: `chmod +x install_rabbitmq_cluster.sh`.
3. Execute o script: `./install_rabbitmq_cluster.sh`.
4. Para iniciar o cluster RabbitMQ: `cd ~/rabbitmq-cluster && docker-compose up -d`.

Isso irá iniciar o cluster RabbitMQ com três nós. Você pode acessar a interface de gerenciamento do RabbitMQ no endereço `http://localhost:15672` usando o nome de usuário `guest` e a senha `guest`.
