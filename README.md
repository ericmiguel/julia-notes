# Julia Notes

Minhas (100% for fun) notas de estudo sobre Julia.

## Ambientes

Alguns blocos de notas possuem dependências.

Felizmente, o gerenciador de pacotes e ambientes padrão da linguagem é excelente!

Para criar um novo ambiente, usa o terminal REPL no modo ```Pkg``` (]).

```bash
activate "{nome do ambiente}"
```

Se o ambiente não existir, ele será criado. Caso já exista, será ativado.

Para manipular os pacotes do ambiente, use:

```bash
# adicionar um novo pacote
add "{nome do pacote}"

# remover um pacote
remove "{nome do pacote}"  # rm também serve!

# atualizar um pacote
update "{nome do pacote}"  # up também serve!
```

Para aplicar alterações em um ambiente de uma vez só, use:

```bash
# para ver um resumo os pacotes instalados
status  # st também serve!

# para atualizar todos os pacotes
update  # up também serve!

# para pré-compilar as bibliotecas
precompile

# para desfazer a última alteração feita no ambiente
undo

# para refaer a última alteraçao feita no ambiente
redo
```