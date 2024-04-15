#Include 'Totvs.ch'
#Include 'fwmvcdef.ch'

/*/{Protheus.doc} zMVC02
    Modelo de dados na funcao zMVC02

    @author Rogerio Piveto
    @since 11/04/2024
/*/

Static cTitulo   := "Cadastro de Cds"
Static cTabPai   := "ZD2"
Static cTabFilho := "ZD3"

User Function zMVC02()

    Local aArea     := GetArea()
    Local oBrowse
    Private aRotina := {}

    // Definicao do menu
    aRotina := menudef()

    // Instanciando o browse
    oBrowse := FWMBrowse():New()
    oBrowse:SetAlias(cTabPai)
    oBrowse:SetDescription(cTitulo)
    oBrowse:DisableDetails()

    // Ativa o browse
    oBrowse:Activate()

    RestArea(aArea)

Return Nil

/*/{Protheus.doc} menudef
    Menu de opcoes na funcao zMVC02

    @author Rogerio Piveto
    @since 11/04/2024
/*/

Static Function menudef()

    Local aRotina := {}

    // Adicionando opcoes ao menu
    ADD OPTION aRotina TITLE "Visualizar"   ACTION "VIEWDEF.zMVC02" OPERATION 1 ACCESS 0
    ADD OPTION aRotina TITLE "Incluir"      ACTION "VIEWDEF.zMVC02" OPERATION 3 ACCESS 0
    ADD OPTION aRotina TITLE "Alterar"      ACTION "VIEWDEF.zMVC02" OPERATION 4 ACCESS 0
    ADD OPTION aRotina TITLE "Excluir"      ACTION "VIEWDEF.zMVC02" OPERATION 5 ACCESS 0

Return aRotina

/*/{Protheus.doc} modeldef
    Menu de opcoes na funcao zMVC02

    @author Rogerio Piveto
    @since 11/04/2024
/*/

Static Function modeldef()

    Local oStruPai   := FWFormStruct(1, cTabPai)
    Local oStruFilho := FWFormStruct(1, cTabFilho)
    Local oModel
    Local aRelation  := {}
    Local bPre       := Nil
    Local bPos       := Nil
    Local bCommit    := Nil
    Local bCancel    := Nil

    // Cria o modelo de dados para cadastro
    oModel := MPFormModel():New("zMVC02M", bPre, bPos, bCommit, bCancel)
    oModel:AddFields("ZD2MASTER", /*cOwner*/, oStruPai)
    oModel:AddGrid("ZD3DETAIL", "ZD2MASTER", oStruFilho, /*bLinePre*/, /*bLinePost*/, /*bPre - Grid Inteiro*/, /*bPos - Grid Inteiro*/, /*bLoad - Carga do modelo manualmente*/)
    oModel:SetDescription("Modelo de dados - " + cTitulo)
    oModel:GetModel("ZD2MASTER"):SetDescription("Dados de - " + cTitulo)
    oModel:GetModel("ZD3DETAIL"):SetDescription("Grid de - " + cTitulo)
    oModel:SetPrimaryKey({})
    
    // Fazendo o relacionamento
    aAdd(aRelation, {"ZD3_FILIAL", "FWxFilial('ZD3')"})
    aAdd(aRelation, {"ZD3_CD", "ZD2_CD"})
    oModel:SetRelation("ZD3DETAIL", aRelation, ZD3->(IndexKey(1)))

    // Definindo campos unicos da linha
    oModel:GetModel("ZD3DETAIL"):SetUniqueLine({'ZD3_MUSICA'})

Return oModel

/*/{Protheus.doc} viewdef
    Visualizacao de dados na funcao zMVC02

    @author Rogerio Piveto
    @since 12/04/2024
/*/

Static Function viewdef()

    Local oModel     := FWLoadModel("zMVC02")
    Local oStruPai   := FWFormStruct(2, cTabPai)
    Local oStruFilho := FWFormStruct(2, cTabFilho)
    Local oView

    // Cria a visualizacao do cadastro
    oView := FWFormView():New()
    oView:SetModel(oModel)
    oView:AddField("VIEW_ZD2", oStruPai, "ZD2MASTER")
    oView:AddGrid("VIEW_ZD3", oStruFilho, "ZD3DETAIL")

    // Partes da tela
    oView:CreateHorizontalBox("CABEC", 30)
    oView:CreateHorizontalBox("GRID", 70)
    oView:SetOwnerView("VIEW_ZD2", "CABEC")
    oView:SetOwnerVIew("VIEW_ZD3", "GRID")

    // Titulos
    oView:EnableTitleView("VIEW_ZD2", "Cabeçalho - ZD2 (CDs)")
    oView:EnableTitleView("VIEW_ZD3", "Grid - ZD3 (Musicas dos CDs)")

    // Removendo campos
    oStruFilho:RemoveField("ZD3_CD")

    // Adicionando campo incremental na GRID
    oView:AddIncrementField("VIEW_ZD3", "ZD3_ITEM")

Return oView
