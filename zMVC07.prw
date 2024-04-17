#Include 'Totvs.ch'
#Include 'fwmvcdef.ch'

Static cTitulo      := "Artistas (com botões na viewdef)"
Static cAliasMVC    := "ZD1"

/*/{Protheus.doc} zMVC07
    Cadastro de Artistas (com botões na viewdef)

    @author Rogerio Piveto
    @since 17/04/2024
/*/

User Function zMVC07()

    Local aArea     := GetArea()
    Local oBrowse
    Private aRotina := {}

    // Definicao do menu
    aRotina := menudef()

    // Instanciando o browse
    oBrowse := FWMBrowse():New()
    oBrowse:SetDescription(cTitulo)
    oBrowse:SetAlias(cAliasMVC)
    oBrowse:DisableDetails()

    // Ativa o browse
    oBrowse:Activate()

    RestArea(aArea)

Return Nil

/*/{Protheus.doc} menudef
    Menu de opcoes na funcao zMVC01

    @author Rogerio Piveto
    @since 17/04/2024
/*/

Static Function menudef()

    Local aRotina := {}

    // Adicionando opcoes do menu
    ADD OPTION aRotina TITLE "Visualizar"   ACTION "VIEWDEF.zMVC07" OPERATION 1 ACCESS 0
    ADD OPTION aRotina TITLE "Incluir"      ACTION "VIEWDEF.zMVC07" OPERATION 3 ACCESS 0
    ADD OPTION aRotina TITLE "Alterar"      ACTION "VIEWDEF.zMVC07" OPERATION 4 ACCESS 0
    ADD OPTION aRotina TITLE "Excluir"      ACTION "VIEWDEF.zMVC07" OPERATION 5 ACCESS 0

Return aRotina

/*/{Protheus.doc} modeldef
    Modelo de dados na funcao zMVC07

    @author Rogerio Piveto
    @since 17/04/2024
/*/

Static Function modeldef()

    Local oStruct   := FWFormStruct(1, cAliasMVC)
    Local oModel
    Local bPre      := Nil
    Local bPos      := Nil
    Local bCommit   := Nil
    Local bCancel   := Nil

    // Cria o modelo de dados para cadastro
    oModel := MPFormModel():New("zMVC07M", bPre, bPos, bCommit, bCancel)
    oModel:AddFields("ZD1MASTER", /*cOwner*/, oStruct)
    oModel:SetDescription("Modelo de dados - " + cTitulo)
    oModel:GetModel("ZD1MASTER"):SetDescription("Dados de - " + cTitulo)
    oModel:SetPrimaryKey({})

Return oModel

/*/{Protheus.doc} viewdef
    Visualizacao de dados na funcao zMVC07

    @author Rogerio Piveto
    @since 17/04/2024
/*/

Static Function viewdef()

    Local oModel    := FWLoadModel("zMVC07")
    Local oStruct   := FWFormStruct(2, cAliasMVC)
    Local oView

    // Cria a visualizacao do cadastro
    oView := FWFormView():New()
    oView:SetModel(oModel)
    oView:AddField("VIEW_ZD1", oStruct, "ZD1MASTER")
    oView:CreateHorizontalBox("TELA", 100)
    oView:SetOwnerView("VIEW_ZD1", "TELA")

    // Adiciona botões direto no Outras Ações da ViewDef
    // Parâmetros do método addUserButton - (cTitle >, <cResource >, <bBloco >, [ cToolTip ], [ nShortCut ], [ aOptions ], [ lShowBar ])
    oView:addUserButton("Mensagem", "MAGIC_BMP", {|| Alert("Apenas uma mensagem de teste")}, , , , .T.)
    oView:addUserButton("Imprimir", "MAGIC_BMP", {|| Alert("Em construção"               )}, , , , .F.)

Return oView
