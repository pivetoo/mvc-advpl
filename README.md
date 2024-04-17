# mvc-advpl
Exemplos de códigos para conhecimento em MVC | Modelos 1, 2, 3, X

zMVC01 ->
zMVC02 ->
zMVC03 ->
zMVC04 ->
zMVC05 ->
zMVC06 ->
zMVC07 ->
zMVC08 ->
zMVC09 ->
zMVC10 ->
zMVC11 ->
zMVC12 ->
zMVC13 ->
zMVC14 ->
zMVC15 ->
zMVC16 ->
zMVC17 ->
zMVC18 ->
zMVC19 ->
zMVC20 ->


Tabelas criadas no Configurador:
Tabela ZD1 - Artistas - Totalmente Compartilhada
Campos:
    Campo      | Tipo      | Tamanho | Contexto | Modo       | Título          | Inic. Padrão                   | Obrigatório | Browse | Usado
    ZD1_CODIGO | Caractere |       6 | Real     | Visualizar | Código          | GetSXENum("ZD1", "ZD1_CODIGO") | Não         | Sim    | Sim
    ZD1_NOME   | Caractere |     100 | Real     | Alterar    | Nome            |                                | Sim         | Sim    | Sim
    ZD1_DTFORM | Data      |       8 | Real     | Alterar    | Data Formação   |                                | Não         | Não    | Sim
    ZD1_OBSERV | Caractere |     100 | Real     | Alterar    | Observações     |                                | Não         | Não    | Sim
    ZD1_OK     | Caractere |       2 | Real     | Alterar    | Ok (marcado)    |                                | Não         | Não    | Não
Índices:
    (1): ZD1_FILIAL + ZD1_CODIGO

+===+

Consulta Padrão - ZD1
    Descrição: Artistas
    Tabela ZD1
    Índice (1), campos ZD1_CODIGO e ZD1_NOME
    Retorno ZD1->ZD1_CODIGO

+===+

Tabela ZD2 - CDs - Totalmente Compartilhada
Campos:
    Campo      | Tipo      | Tamanho | Contexto | Modo       | Título        | Inic. Padrão                                                                                | Inic. Browse                                                        | Modo Edição | Cons Padrão | Obrigatório | Browse
    ZD2_CD     | Caractere |       6 | Real     | Visualizar | CD            | GetSXENum("ZD2", "ZD2_CD")                                                                  |                                                                     |             |             | Não         | Sim
    ZD2_ARTIST | Caractere |       6 | Real     | Alterar    | Artista       |                                                                                             |                                                                     | INCLUI      | ZD1         | Sim         | Sim
    ZD2_NOME   | Caractere |     100 | Virtual  | Visualizar | Nome Artista  | IIF(INCLUI, "", POSICIONE("ZD1", 1, FWXFILIAL("ZD1") + FWFLDGET("ZD2_ARTIST"), "ZD1_NOME")) | Posicione("ZD1", 1, FWxFilial("ZD1") + ZD2->ZD2_ARTIST, "ZD1_NOME") |             |             | Não         | Sim
    ZD2_NOMECD | Caractere |     100 | Real     | Alterar    | Nome CD       |                                                                                             |                                                                     |             |             | Sim         | Sim
Índices:
    (1): ZD2_FILIAL + ZD2_CD

+===+

Gatilho
    Campo:        ZD2_ARTIST
    Sequencia:    001
    Cnt. Dominio: ZD2_NOME
    Tipo:         Primario
    Regra:        ZD1->ZD1_NOME
    Posiciona:    Sim
    Alias:        ZD1
    Ordem:        1
    Chave:        FWXFILIAL("ZD1") + FWFLDGET("ZD2_ARTIST")

+===+

Tabela ZD3 - Musicas dos CDs - Totalmente Compartilhada
Campos:
    Campo      | Tipo      | Tamanho | Contexto | Modo       | Título        | Modo Edição | Cons Padrão | Obrigatório | Browse
    ZD3_CD     | Caractere |       6 | Real     | Alterar    | CD            |             |             | Não         | Sim
    ZD3_ITEM   | Caractere |       2 | Real     | Alterar    | Item          |             |             | Não         | Sim
    ZD3_MUSICA | Caractere |     100 | Real     | Alterar    | Musica        |             |             | Sim         | Sim
Índices:
    (1): ZD3_FILIAL + ZD3_CD + ZD3_ITEM

+===+

Tabela ZD4 - Premiações - Totalmente Compartilhada
Campos:
    Campo      | Tipo      | Tamanho | Contexto | Modo       | Título        | Inic. Padrão                                                                                | Inic. Browse                                                        | Modo Edição | Cons Padrão | Validação de Usuário             | Obrigatório | Browse
    ZD4_ANO    | Caractere |       4 | Real     | Visualizar | Ano           |                                                                                             |                                                                     |             |             | ExistChav( "ZD4", &(ReadVar()) ) | Não         | Sim
    ZD4_ITEM   | Caractere |       2 | Real     | Alterar    | Item          |                                                                                             |                                                                     |             |             |                                  | Não         | Sim
    ZD4_ARTIST | Caractere |       6 | Real     | Alterar    | Artista       |                                                                                             |                                                                     | INCLUI      | ZD1         |                                  | Sim         | Sim
    ZD4_NOME   | Caractere |     100 | Virtual  | Visualizar | Nome Artista  | IIF(INCLUI, "", Posicione("ZD1", 1, FWxFilial("ZD1") + ZD4->ZD4_ARTIST, "ZD1_NOME"))        | Posicione("ZD1", 1, FWxFilial("ZD1") + ZD4->ZD4_ARTIST, "ZD1_NOME") |             |             |                                  | Não         | Sim
    ZD4_PREMIO | Caractere |     100 | Real     | Alterar    | Premio Desc.  |                                                                                             |                                                                     |             |             |                                  | Sim         | Sim
Índices:
    (1): ZD4_FILIAL + ZD4_ANO

+===+

Gatilho
    Campo:        ZD4_ARTIST
    Sequencia:    001
    Cnt. Dominio: ZD4_NOME
    Tipo:         Primario
    Regra:        ZD1->ZD1_NOME
    Posiciona:    Sim
    Alias:        ZD1
    Ordem:        1
    Chave:        FWXFILIAL("ZD1") + FWFLDGET("ZD4_ARTIST")
