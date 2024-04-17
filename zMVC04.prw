#Include 'Totvs.ch'
#Include 'fwmvcdef.ch'

Static cTitulo  := "Premiações"
Static cCamposChv   := "ZD4_ANO;"

/*/{Protheus.doc} zMVC04
    Função para cadastro de Premiações de Artistas

    @author Rogerio Piveto
    @since 15/04/2024
/*/

User Function zMVC04()

    Local aArea     := GetArea()
    Local oBrowse

    // Cria o browse para a ZD4
    oBrowse := FWMBrowse():New()
    oBrowse:SetAlias("ZD4")
    oBrowse:SetDescription(cTitulo)
    oBrowse:Activate()

    RestArea(aArea)

Return Nil

/*/{Protheus.doc} menudef
    Menu de opcoes na funcao zMVC04

    @author Rogerio Piveto
    @since 15/04/2024
/*/

Static Function menudef()

    Local aRotina := {}

    ADD OPTION aRotina TITLE "Visualizar"   ACTION "VIEWDEF.zMVC04" OPERATION 1 ACCESS 0
    ADD OPTION aRotina TITLE "Incluir"      ACTION "VIEWDEF.zMVC04" OPERATION 3 ACCESS 0
    ADD OPTION aRotina TITLE "Alterar"      ACTION "VIEWDEF.zMVC04" OPERATION 4 ACCESS 0
    ADD OPTION aRotina TITLE "Excluir"      ACTION "VIEWDEF.zMVC04" OPERATION 5 ACCESS 0

Return aRotina

/*/{Protheus.doc} modeldef
    Modelo de dados na funcao zMVC04

    @author Rogerio Piveto
    @since 15/04/2024
/*/

Static Function modeldef()

    /*Na montagem da estrutura do modelo de dados, o cabeçalho filtrará e exibirá somente os campos chave, 
    já a grid irá carregar a estrutura inteira conforme a funcao fModStruct*/
    Local oModel    := Nil
    Local oStruCab  := FWFormStruct(1, 'ZD4', {|cCampo| AllTrim(cCampo) $ cCamposChv})
    Local oStruGrid := fModStruct()
    Local bPre      := Nil
    Local bPos      := Nil
    Local bCommit   := Nil
    Local bCancel   := Nil
    
    // Monta o modelo de dados
    oModel := MPFormModel():New('zMVC04M', bPre, bPos, bCommit, bCancel)

    // Agora, define no modelo de dados, que terá um cabeçalho e uma grid apontando para estruturas acima
    oModel:AddFields('MdFieldZD4', Nil, oStruCab)
    oModel:AddGrid('MdGridZD4', 'MdFieldZD4', oStruGrid, ,)

    // Monta o relacionamento entre grid e cabeçalho, as expressões da esquerda representam o campo da grid e da direita do cabeçalho
    oModel:SetRelation('MdGridZD4', {;
        {'ZD4_FILIAL', 'xFilial("ZD4")'},;
        {'ZD4_ANO',    'ZD4_ANO'};
    }, ZD4->(IndexKey(1)))

    // Definindo outras informações do modelo e da grid
    oModel:GetModel("MdGridZD4"):SetMaxLine(9999)
    oModel:SetDescription("Cadastro de Premiações")
    oModel:SetPrimaryKey({"ZD4_FILIAL", "ZD4_ANO"})

Return oModel

/*/{Protheus.doc} viewdef
    Visualizacao de dados na funcao zMVC04

    @author Rogerio Piveto
    @since 15/04/2024
/*/

Static Function viewdef()

    /* Na montagem da estrutura de visualização de dados, vamos chamar o modelo criado anteriormente,
    no cabeçalho vamos mostrar somente os campos chave, e na grid vamos carregar conforme a funcao fViewStruct*/
    Local oView     := Nil
    Local oModel    := FWLoadModel('zMVC04')
    Local oStruCab  := FWFormStruct(2, "ZD4", {|cCampo| Alltrim(cCampo) $ cCamposChv})
    Local oStruGrid := fViewStruct()

    // Define que no cabeçalho não terá separação de abas (SXA)
    oStruCab:SetNoFolder()

    // Cria o View
    oView := FWFormView():New()
    oView:SetModel(oModel)

    // Cria uma área de Field vinculando a estrutura do cabelaçho com MDFieldZD4, e uma grid vinculando com MDGridZD4
    oView:AddField('VIEW_ZD4', oStruCab, 'MdFieldZD4')
    oView:AddGrid('GRID_ZD4', oStruGrid, 'MdGridZD4')

    // O cabeçalho (MAIN) terá 25% de tamanho, e o restante de 75% irá para a GRID
    oView:CreateHorizontalBox("MAIN", 25)
    oView:CreateHorizontalBox("GRID", 75)

    // Vincula o MAIN com a VIEW_ZD4 e a GRID com a GRID_ZD4
    oView:SetOwnerView('VIEW_ZD4', 'MAIN')
    oView:SetOwnerView('GRID_ZD4', 'GRID')
    oView:EnableControlBar(.T.)

    // Define o campo incremental da GRID como o ZD4_ITEM
    oView:AddIncrementField('GRID_ZD4', 'ZD4_ITEM')

Return oView

/*/{Protheus.doc} fModStruct
    Funcao chamada para montar o modelo de dados da Grid (retorna todos os campos)

    @author Rogerio Piveto
    @since 15/04/2024
/*/

Static Function fModStruct()

    Local oStruct
    oStruct := FWFormStruct(1, 'ZD4')

Return oStruct

/*/{Protheus.doc} fViewStruct
    Funcao chamada para montar a visualizacao de dados da Grid (retorna os campos, excluindo os campos chave)

    @author Rogerio Piveto
    @since 15/04/2024
/*/

Static Function fViewStruct()

    Local oStruct
    oStruct := FWFormStruct(2, "ZD4", {|cCampo| !(Alltrim(cCampo) $ cCamposChv)})

Return oStruct
