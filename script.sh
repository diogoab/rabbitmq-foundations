#!/bin/bash

# Atualizar e instalar dependências necessárias
sudo apt-get update
sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common

# Adicionar chave GPG oficial do Docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Adicionar repositório Docker
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Atualizar novamente e instalar Docker
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io

# Instalar Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/download/v2.17.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Verificar as instalações
docker --version
docker-compose --version

# Criar diretório para o projeto do RabbitMQ
mkdir -p ~/rabbitmq-cluster
cd ~/rabbitmq-cluster

# Criar arquivo docker-compose.yml
cat <<EOL > docker-compose.yml
version: '3.8'

services:
  rabbitmq1:
    image: rabbitmq:3.12-management
    hostname: rabbitmq1
    container_name: rabbitmq1
    environment:
      - RABBITMQ_ERLANG_COOKIE=MY_SECRET_COOKIE
      - RABBITMQ_NODENAME=rabbit@rabbitmq1
    volumes:
      - rabbitmq1-data:/var/lib/rabbitmq
    networks:
      rabbitmq-cluster:
        aliases:
          - rabbitmq1
    ports:
      - "15672:15672"  # Porta de gerenciamento do nó 1
      - "5672:5672"    # Porta AMQP do nó 1
    restart: unless-stopped

  rabbitmq2:
    image: rabbitmq:3.12-management
    hostname: rabbitmq2
    container_name: rabbitmq2
    environment:
      - RABBITMQ_ERLANG_COOKIE=MY_SECRET_COOKIE
      - RABBITMQ_NODENAME=rabbit@rabbitmq2
    volumes:
      - rabbitmq2-data:/var/lib/rabbitmq
    networks:
      rabbitmq-cluster:
        aliases:
          - rabbitmq2
    restart: unless-stopped

  rabbitmq3:
    image: rabbitmq:3.12-management
    hostname: rabbitmq3
    container_name: rabbitmq3
    environment:
      - RABBITMQ_ERLANG_COOKIE=MY_SECRET_COOKIE
      - RABBITMQ_NODENAME=rabbit@rabbitmq3
    volumes:
      - rabbitmq3-data:/var/lib/rabbitmq
    networks:
      rabbitmq-cluster:
        aliases:
          - rabbitmq3
    restart: unless-stopped

networks:
  rabbitmq-cluster:
    driver: bridge

volumes:
  rabbitmq1-data:
  rabbitmq2-data:
  rabbitmq3-data:
EOL

# Informar ao usuário que o script foi concluído
echo "Instalação do Docker, Docker Compose e configuração do RabbitMQ Cluster concluídas."
echo "Você pode iniciar o cluster executando: docker-compose up -d"
