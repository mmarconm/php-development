# Projeto PHP/Laravel com DevContainer by Marcelo Marcon

Este projeto é configurado para ser utilizado com o [DevContainer](https://code.visualstudio.com/docs/remote/containers) do Visual Studio Code, permitindo um ambiente de desenvolvimento consistente e isolado.

## Pré-requisitos

- [Docker](https://www.docker.com/get-started) instalado e em execução.
- [Visual Studio Code](https://code.visualstudio.com/) com a extensão [Remote - Containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) instalada.

## Estrutura do Projeto

- **Dockerfile:** Configura a imagem do container com PHP 8.2 e Apache.
- **docker-compose.yml:** Define os serviços `codephp`, `db` (MariaDB) e `adminer`.
- **.devcontainer/devcontainer.json:** Configura o ambiente DevContainer para o VS Code.

## Instruções de Uso

1. **Abrir o Projeto no VS Code:**

   - Abra o VS Code na raiz do projeto.
   - Selecione a opção **Remote-Containers: Reopen in Container** a partir da paleta de comandos (`Ctrl+Shift+P` ou `F1`).

2. **Construção e Inicialização do Container:**

   - O VS Code usará o arquivo [devcontainer.json](.devcontainer/devcontainer.json) para configurar o container usando o arquivo [docker-compose.yml](docker-compose.yml) e o [Dockerfile](Dockerfile).
   - Aguarde a compilação e configuração do container na primeira vez.

3. **Desenvolvimento:**

   - O container expõe a porta `8000` para acesso à aplicação PHP.
   - O workspace dentro do container está localizado em `/home/coder/app`.
   - Utilize o terminal integrado do VS Code para executar comandos dentro do container.
   - Utilize as extensões pré-configuradas (como [xdebug.php-debug](https://marketplace.visualstudio.com/items?itemName=xdebug.php-debug)) para depurar e aprimorar o desenvolvimento.

4. **Serviços Auxiliares:**

   - **Banco de Dados:** Serviço `db` (postgres) está configurado com as credenciais:
     - Usuário: `codephp`
     - Senha: `adminadmin`
     - Banco: `codephp`
   - **Adminer:** Acesse [pgadmin4](http://localhost:8080) para gerenciar o banco de dados.
   - caso precise de outro banco de dados como mariadb (mysql) apenas modifique o docker-compose.yml para o banco e gerenciador que melhor lhe atenda.

5. **Comandos Úteis:**

   - Para rebuildar o container, abra o comando **Remote-Containers: Rebuild Container** na paleta de comandos.
   - Para visualizar logs do docker-compose, use o terminal integrado e execute:
   ```sh
     docker-compose logs -f
   ```
   ```sh
     # Exemplos de como desenvolver com laravel
     - composer require laravel/laravel # https://laravel.com/docs/12.x/installation
     - composer create-project laravel/laravel my-app

     # desenvolvimento com breeze
     - cd my-app
     - composer require laravel/breeze --dev # https://laravel.com/docs/12.x/starter-kits
     - php artisan breeze:install 
   ```

## Observações e considerações finais
Ainda não sou especialista em PHP/Laravel; estou estudando há pouco tempo. Com o objetivo de padronizar meu ambiente de desenvolvimento tanto no Windows quanto no Linux, e para evitar depender da instalação do XAMPP, criei um ambiente simplificado para facilitar meus projetos com Laravel.

Reconheço que há bastante espaço para melhorias neste ambiente. Pretendo aperfeiçoá-lo gradualmente, à medida que adquirir mais experiência e conhecimento na ferramenta.

Este ambiente DevContainer visa simplificar o processo de configuração e garantir um ambiente consistente para todos os desenvolvedores. Caso precise de alterações, ajuste os arquivos [Dockerfile](Dockerfile), [docker-compose.yml](docker-compose.yml) ou [.devcontainer/devcontainer.json](.devcontainer/devcontainer.json).

Happy Coding!