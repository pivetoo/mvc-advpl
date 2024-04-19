#Include 'Totvs.ch'
#Include 'fwmvcdef.ch'

Static cTitulo  := "Cadastro de CDs"
Static cTabPai  := "ZD2"
Static cTabFilho := "ZD3"

/*/{Protheus.doc} zMVC10
    CDs (com validações no bPre, bPos, bCancel e bLinePos)

    @author Rogerio Piveto
/*/

User Function zMVC10()

    Local aArea     := GetArea()
    Local oBrowse
    Private aRotina := {}

    aRotina := menudef()

    oBrowse := FWMBrowse():New()
    oBrowse:SetAlias(cTabPai)
    oBrowse:SetDescription(cTitulo)
    oBrowse:DisableDetails()

    oBrowse:Activate()

    RestArea(aArea)

Return Nil

/*/{Protheus.doc} menudef
    Menu de opcoes da zMVC10

    @author Rogerio Piveto
    @since 17/04/2024
/*/

Static Function menudef()

    Local aRotina := {}

    ADD OPTION aRotina TITLE "Visualizar"   ACTION "VIEWDEF.zMVC10" OPERATION 1 ACCESS 0
    ADD OPTION aRotina TITLE "Incluir"      ACTION "VIEWDEF.zMVC10" OPERATION 3 ACCESS 0
    ADD OPTION aRotina TITLE "Alterar"      ACTION "VIEWDEF.zMVC10" OPERATION 4 ACCESS 0
    ADD OPTION aRotina TITLE "Excluir"      ACTION "VIEWDEF.zMVC10" OPERATION 5 ACCESS 0

Return aRotina

/*/{Protheus.doc} modeldef
    Modelo de dados da zMVC10

    @author Rogerio Piveto
    @since 17/04/2024
/*/

Static Function modeldef()

    Local oStruPai      := FWFormStruct(1, cTabPai)
    Local oStruFilho    := FWFormStruct(1, cTabFilho)
    Local aRelation     := {}
    Local oModel
    Local bPre          := {|| u_zMVCbPre()}
    Local bPos          := {|| u_zMVCbPos()}
    Local bCommit       := Nil
    Local bCancel       := Nil
    Local bLinePos      := {|oMdl| u_zMVCbLinP(oModel)}

    // Cria o modelo de dados para o cadastro
    oModel := MPFormModel():New("zMVC10M", bPre, bPos, bCommit, bCancel)
    oModel:AddFields("ZD2MASTER", /*cOwner*/, oStruPai)
	oModel:AddGrid("ZD3DETAIL", "ZD2MASTER", oStruFilho, /*bLinePre*/, bLinePos, /*bPre - Grid Inteiro*/, /*bPos - Grid Inteiro*/, /*bLoad - Carga do modelo manualmente*/)
    oModel:SetDescription("Modelo de dados - " + cTitulo)
    oModel:GetModel("ZD2MASTER"):SetDescription("Dados de - " + cTitulo)
    oModel:GetModel("ZD3DETAIL"):SetDescription("Grid de - " + cTitulo)
    oModel:SetPrimaryKey({})

    // Fazendo o relacionamento
    aAdd(aRelation, {"ZD3_FILIAL", "FWxFilial('ZD3')"})
    aAdd(aRelation, {"ZD3_CD", "ZD2_CD"})
    oModel:SetRelation("ZD3DETAIL", aRelation, ZD3->(IndexKey(1)))

    // Definindo campos unicos da linha
    oModel:GetModel("ZD3DETAIL"):SetUniqueLine({"ZD3_MUSICA"})

Return oModel

/*/{Protheus.doc} viewdef
    Visualizacao de dados da zMVC10

    @author Rogerio Piveto
    @since 17/04/2024
/*/

Static Function viewdef()

    Local oModel        := FWLoadModel("zMVC10")
    Local oStruPai      := FWFormStruct(2, cTabPai)
    Local oStruFilho    := FWFormStruct(2, cTabFilho)
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
    oView:SetOwnerView("VIEW_ZD3", "GRID")

    // Titulos
    oView:EnableTitleView("VIEW_ZD2", "Cabeçalho - ZD2 (CDs)")
    oView:EnableTitleView("VIEW_ZD3", "Grid - ZD3 (Musicas dos CDs)")

    // Removendo campos
    oStruFilho:RemoveField("ZD3_CD")

    // Adicionando campo incremental na GRID
    oView:AddIncrementField("VIEW_ZD3", "ZD3_ITEM")

Return oView

/*/{Protheus.doc} zMVCbPre
    Funcao chamada na criacao do Modelo de Dados (pre-validacao)

    @author Rogerio Piveto
    @since 17/04/2024
/*/

User Function zMVCbPre()

    Local oModelPad := FWModelActive()
    Local lRet      := .T.

    oModelPad:GetModel('ZD2MASTER'):GetStruct():SetProperty('ZD2_NOMECD', MODEL_FIELD_WHEN, FwBuildFeature(STRUCT_FEATURE_WHEN, 'INCLUI'))

Return lRet

/*/{Protheus.doc} zMVCbPos
    Função chamada no clique do botão Ok do Modelo de Dados (pós-validação)

    @author Rogerio Piveto
    @since 18/04/2024
/*/

User Function zMVCbPos()

    Local oModelPad := FWModelActive()
    Local cNomeCD   := oModelPad:GetValue('ZD2MASTER', 'ZD2_NOMECD')
    Local lRet      := .T.

    // Se o nome do CD estiver vazio
    If Empty(cNomeCD) .Or. Len(Alltrim(cNomeCD)) < 3
        Help(, , "Help", , "Nome do CD inválido", 1, 0, , , , , , {"Insira um nome válido que tenha mais que 3 caracteres"})
        lRet := .F.
    EndIf

Return lRet

/*/{Protheus.doc} zMVCbLinP
    Função chamada ao trocar de linha na grid (bloco bLinePos)

    @author Rogerio Piveto
    @since 18/04/2024
/*/

User Function zMVCbLinP(oModel)

    Local oModelZD3     := oModel:GetModel('ZD3DETAIL')
    Local nOperation    := oModel:GetOperation()
    Local lRet          := .T.
    Local cMusica       := oModelZD3:GetValue('ZD3_MUSICA')

    // Se não for exclusão e nem visualizacao
    If nOperation != MODEL_OPERATION_DELETE .And. nOperation != MODEL_OPERATION_VIEW

        // Se a musica estiver vazia, ou for menor que 3
        If Empty(cMusica) .Or. Len(Alltrim(cMusica)) < 3
            Help(, , "Help", , "Nome da música inválida", 1, 0, , , , , , {"Insira um nome válido que tenha mais que 3 caracteres"})
            lRet := .F.
        EndIf

    EndIf

Return lRet
