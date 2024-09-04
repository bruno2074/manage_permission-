#!/bin/bash

# desafio 1 - Sistemas Computacionais

# pede o nome do usuário para identificá-lo
printf "Digite o nome do usuário: "
read username

if id -u "$username" > /dev/null; then
    echo "Digite sua senha: "
    read -s senha_user
else
    printf "Deseja criar um usuário? (S/n): "
    read resposta_novo_usuario
    if [ "$resposta_novo_usuario" == "S" ] || [ "$resposta_novo_usuario" == "s" ]; then
        # Função para criar um novo usuário
        cr() {
            # Exibir usuários existentes:
            clear
            echo "Usuário(s) existente(s):"
            echo "_____"
            egrep '^[1][0-9]{3}' /etc/passwd | cut -d: -f1
            echo "_____"
            
            # Nome:
            echo -e "\n(Dica: Não coloque espaço e alguns caracteres especiais)\n"
            read -p "Crie um usuário: " novo_usuario
            
            # Senha:
            pass() {
                read -p "Digite a senha: " -s senha1
                echo -en "\nRedigite a senha: "
                read -s senha2
            }
            pass
            
            # Verificando senha:
            while [ "$senha1" != "$senha2" ]; do
                clear
                echo " ____"
                echo "|A senha não é igual; tente novamente|"
                echo -e "|____|\n"
                pass
            done
            
            # Criando o usuário:
            if sudo useradd -m "$novo_usuario" -p "$(openssl passwd -1 "$senha1")" -s /bin/bash; then
                clear
                echo "[Ok] Usuário [$novo_usuario] foi criado"
                echo "-------------------------------------------------------"
            else
                clear
                echo "[Erro] Ao criar o usuário [$novo_usuario]"
                echo "-------------------------------------------------------"
            fi
        }
        cr
    fi
fi

# pede o nome do projeto
printf "Digite o nome do projeto: "
read projeto

# avalia se o projeto citado acima já existe
if [ -d "$projeto" ]; then
    echo "Seu diretório existe e seu conteúdo é: "
    cd "$projeto"
    ls -l
else
    printf "Você deseja criar um novo projeto? (S/n): "
    read resposta
    if [ "$resposta" == "S" ] || [ "$resposta" == "s" ]; then
        # cria o grupo com o nome do projeto
        sudo addgroup "$projeto"
        
        # cria o diretório com nome do projeto dentro do diretório /shared
        diretorio="/shared/$projeto"
        sudo mkdir -p "$diretorio"
        
        # atribui projeto ao username
        sudo usermod -aG "$projeto" "$username"
        
        # cria um diretório com permissões
        sudo mkdir -p -v -m 770 "$diretorio"
        
        printf "Usuário '$username' adicionado ao grupo '$projeto'.\n"
        
        # altera a propriedade do diretório
        sudo chown "$username:$projeto" "$diretorio"
        
        sudo touch "$diretorio/arquivo.txt"
        
        echo "Permissões definidas para 770."
        echo "Configuração concluída."
    else
        echo "Olá mundo"
    fi
fi