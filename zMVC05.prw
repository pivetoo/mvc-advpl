#Include 'Totvs.ch'
#Include 'fwmvcdef.ch'

Static cTitulo := "Seleção do Cadastro de Artistas"

/*/{Protheus.doc} zMVC05
    MarkBrow em MVC da tabela de Artistas

    @author Rogerio Piveto
    @since 16/04/2024
/*/

User Function zMVC05()

    Private oMark
    
    // Criando o MarkBrow
    oMark := FWMarkBrowse():New()
    oMark:SetAlias('ZD1')

    // Setando semáforo, descrição e campo de mark
    oMark:SetSemaphore(.T.)
    oMark:SetDescription(cTitulo)
    oMark:SetFieldMark('ZD1_OK')

    // Ativando a janela
    oMark:Activate()

Return Nil

/*/{Protheus.doc} menudef
    Menu de opcoes na funcao zMVC05

    @author Rogerio Piveto
    @since 16/04/2024
/*/

Static Function menudef()

    Local aRotina := {}

    ADD OPTION aRotina TITLE 'Processar' ACTION 'u_zMarkProc' OPERATION 2 ACCESS 0

Return aRotina

/*/{Protheus.doc} zMarkProc
    Rotina para processamento e verificação de quantos registros estão marcados

    @author Rogerio Piveto
    @since 16/04/2024
/*/

User Function zMarkProc()

    Local aArea     := GetArea()
    Local cMarca    := oMark:Mark()
    Local nTotal    := 0

    // Percorrendo os registros da ZD1
    ZD1->(DbGoTop())
    While ! ZD1->(EOF())
        // Caso esteja marcado, aumenta o contador
        If oMark:IsMark(cMarca)
            ntotal++

            // Limpando a marca
            RecLock('ZD1', .F.)
                ZD1_OK := ''
            ZD1->(MsUnlock())
        EndIf

        // Pulando registro
        ZD1->(DbSkip())
    EndDo

    // Mostrando a mensagem de registros marcados
    MsgInfo('Foram marcados <b>' + cValToChar(nTotal) + ' artistas </b>', "Atenção")

    // Restaurando área armazenada
    RestArea(aArea)
Return
