#Include 'Totvs.ch'
#Include "fwmvcdef.ch"

/*/{Protheus.doc} zMVC01
    Exemplo de Cadastro de Artistas

    @author Rogerio Piveto
    @since 10/04/2024
/*/

Static cTitulo      := "Artistas"
Static cAliasMVC    := "ZD1"

User Function zMVC01()

    Local aArea     := GetArea()
    Local oBrowse
    Private aRotina := {}

    // Definicao do menu
    aRotina := MenuDef()

    // Monta o mBrowse para exibição dos registros
    oBrowse := FWMBrowse():New() // Inicializa o projeto
    oBrowse:SetAlias(cAliasMVC) // Indica a tabela a ser utilizada -- ZD1
    oBrowse:SetDescription(cTitulo)
    oBrowse:DisableDetails()

    oBrowse:Activate()

    RestArea(aArea)

Return Nil

/*/{Protheus.doc} menudef
    Menu de opcoes na funcao zMVC01

    @author Rogerio Piveto
    @since 10/04/2024
/*/

Static Function menudef()

    Local aRotina := {}

    ADD OPTION aRotina TITLE "Visualizar" ACTION "VIEWDEF.zMVC01" OPERATION 1 ACCESS 0
    ADD OPTION aRotina TITLE "Incluir"    ACTION "VIEWDEF.zMVC01" OPERATION 3 ACCESS 0
    ADD OPTION aRotina TITLE "Alterar"    ACTION "VIEWDEF.zMVC01" OPERATION 4 ACCESS 0
    ADD OPTION aRotina TITLE "Excluir"    ACTION "VIEWDEF.zMVC01" OPERATION 5 ACCESS 0

Return aRotina

/*/{Protheus.doc} modeldef
    Modelo de dados na funcao zMVC01

    @author Rogerio Piveto
    @since 10/04/2024
/*/

Static Function modeldef()

    Local oStruct   := FWFormStruct(1, cAliasMVC)
    Local oModel
    Local bPre      := Nil
    Local bPos      := Nil
    Local bCommit   := Nil
    Local bCancel   := Nil

    // Cria o modelo de dados para o cadastro
    oModel := MPFormModel():New("zMVC01M", bPre, bPos, bCommit, bCancel)
    oModel:AddFields("ZD1MASTER", /*cOwner*/, oStruct)
    oModel:SetDescription("Modelo de dados - " + cTitulo)
    oModel:GetModel("ZD1MASTER"):SetDescription( "Dados de - " + cTitulo)
    oModel:SetPrimaryKey({})

Return oModel

/*/{Protheus.doc} viewdef
    Visualizacao de dados na funcao zMVC01

    @author Rogerio Piveto
    @since 10/04/2024
/*/

Static Function viewdef()

    Local oModel  := FWLoadModel("zMVC01")
    Local oStruct := FWFormStruct(2, cAliasMVC)
    Local oView

    // Cria a visualizacao do cadastro
    oView := FWFormView():New()
    oView:SetModel(oModel)
    oView:AddField("VIEW_ZD1", oStruct, "ZD1MASTER")
    oView:CreateHorizontalBox("TELA", 100)
    oView:SetOwnerView("VIEW_ZD1", "TELA")

Return oView
