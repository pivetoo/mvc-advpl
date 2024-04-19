#Include 'Totvs.ch'
#Include 'fwmvcdef.ch'

Static cTitulo      := "Artistas (com separação em ambas)"
Static cAliasMVC    := "ZD1"

/*/{Protheus.doc} zMVC09
    Cadastro de artistas (com separação em abas)

    @author Rogerio Piveto
    @since 17/04/2024
/*/

User Function zMVC09()

    Local aArea     := GetArea()
    Local oBrowse
    Private aRotina := {}

    // Definicao do menu
    aRotina := menudef()

    oBrowse := FWMBrowse():New()
    oBrowse:SetAlias(cAliasMVC)
    oBrowse:SetDescription(cTitulo)
    oBrowse:DisableDetails()
    
    oBrowse:Activate()

    RestArea(aArea)

Return Nil

/*/{Protheus.doc} menudef
    Menu de dados da zMVC09

    @author Rogerio Piveto
    @since 17/04/2024
/*/

Static Function menudef()

    Local aRotina := {}

    ADD OPTION aRotina TITLE "Visualizar"   ACTION "VIEWDEF.zMVC09" OPERATION 1 ACCESS 0
    ADD OPTION aRotina TITLE "Incluir"      ACTION "VIEWDEF.zMVC09" OPERATION 3 ACCESS 0
    ADD OPTION aRotina TITLE "Alterar"      ACTION "VIEWDEF.zMVC09" OPERATION 4 ACCESS 0
    ADD OPTION aRotina TITLE "Excluir"      ACTION "VIEWDEF.zMVC09" OPERATION 5 ACCESS 0

Return aRotina

/*/{Protheus.doc} modeldef
    Modelo de dados da zMVC09

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

    oModel := MPFormModel():New("zMVC09M", bPre, bPos, bCommit, bCancel)
    oModel:AddFields("ZD1MASTER", /*cOwner*/, oStruct)
    oModel:SetDescription("Modelo de dados - " + cTitulo)
    oModel:GetModel("ZD1MASTER"):SetDescription("Dados de - " + cTitulo)
    oModel:SetPrimaryKey({})

Return oModel

/*/{Protheus.doc} viewdef
    Visualizacao de dados na funcao zMVC09

    @author Rogerio Piveto
    @since 17/04/2024
/*/

Static Function viewdef()

    Local cCamposPrin := "ZD1_CODIGO|ZD1_NOME"
    Local cCamposObse := "ZD1_DTFORM|ZD1_OBSERV"
    Local oModel := FWLoadModel("zMVC09")
    Local oStructPrin := FWFormStruct(2, cAliasMVC, {|cCampo| Alltrim(cCampo) $ cCamposPrin})
    Local oStructObse := FWFormStruct(2, cAliasMVC, {|cCampo| Alltrim(cCampo) $ cCamposObse})
    Local oView

    // Retira as abas padrões
    oStructPrin:SetNoFolder()
    oStructObse:SetNoFolder()

    // Cria a visualizacao do cadastro
    oView := FWFormView():New()
    oView:SetModel(oModel)
    oView:AddField("VIEW_PRIN", oStructPrin, "ZD1MASTER")
    oView:AddField("VIEW_OBSE", oStructObse, "ZD1MASTER")

    // Cria o controle de abas
    oView:CreateFolder('ABAS')
    oView:AddSheet('ABAS', 'ABA_PRIN', 'Aba principal do Cadastro')
    oView:AddSheet('ABAS', 'ABA_OBSE', 'Aba com campos de Observação')

    // Cria os box que serão vinculados as abas
    oView:CreateHorizontalBox('BOX_PRIN', 100, /*cOwner*/, /*lUsePixel*/, 'ABAS', 'ABA_PRIN')
    oView:CreateHorizontalBox('BOX_OBSE', 100, /*cOwner*/, /*lUsePixel*/, 'ABAS', 'ABA_OBSE')

    // Amarra as abas aos Views de Struct criados
    oView:SetOwnerView('VIEW_PRIN', 'BOX_PRIN')
    oView:SetOwnerView('VIEW_OBSE', 'BOX_OBSE')

Return oView
