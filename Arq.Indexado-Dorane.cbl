      $Set sourceformat "free".

       identification division.
       program-id. "Arq.Indexado-Dorane".
       Author. "Dorane Antunes".
       date-written. 27/07/2020.
       date-compiled.

       environment division.
       configuration Section.
           special-names. decimal-point is comma.

       input-output Section.
       File-control.
      *> Cl�usula Selecte + nome do arquivo / Clausula assingn + Nome do Local.
           Select ArqAlunos assign "ArqAlunos.dat"
           organization is indexed *> Tipo de Organiza��o do arquivo, neste cado indexado.
           access mode is dynamic  *> Modo de acesso, neste caso dinamico.
           lock mode is automatic  *> Lock Mode, modo de bloqueio do Registo.
           record key is fd-cod    *> Especifica o item de dados do registro que ser� a chave prim�ria.
           file status is ws-fs-ArqAlunos. *> Status do Arquivo, identifica��o de poss�veis erros.

       I-O-Control.

       data division.
       file section.
       fd ArqAlunos. *> vari�veis dos arquivos indexados.

      *> Declara��o de Variaveis do fd.
       01  fd-alunos.
           05  fd-cod                                 pic 9(03).
           05  fd-aluno                               pic x(25).
           05  fd-endereco                            pic x(35).
           05  fd-mae                                 pic x(25).
           05  fd-pai                                 pic x(25).
           05  fd-telefone                            pic x(15).
           05  fd-notas.
               10  fd-nota1                           pic 9(02)v99.
               10  fd-nota2                           pic 9(02)v99.
               10  fd-nota3                           pic 9(02)v99.
               10  fd-nota4                           pic 9(02)v99.

       working-storage section.
      *> Declara��o das vari�veis do programa.
       77 ws-fs-ArqAlunos                          pic 9(02).

       01 wk-tela-menu.
          05  wk-cadastro-aluno                    pic  x(01).
          05  wk-cadastro-nota                     pic  x(01).
          05  wk-consulta-sequencial               pic  x(01).
          05  wk-consulta-indexada                 pic  x(01).
          05  wk-alterar                           pic  x(01).
          05  wk-deletar                           pic  x(01).
          05  wk-sair                              pic  x(01).

       77  menu                                    pic x(02).

       01  wk-alunos.
           05  wk-cod                              pic 9(03).
           05  wk-aluno                            pic x(25).
           05  wk-endereco                         pic x(35).
           05  wk-mae                              pic x(25).
           05  wk-pai                              pic x(25).
           05  wk-tel                              pic x(15).
           05  wk-media                            pic 9(02)v99 value 0.

       01  alunos.
           05  cod                                 pic 9(03).
           05  aluno                               pic x(25).
           05  endereco                            pic x(35).
           05  mae                                 pic x(25).
           05  pai                                 pic x(25).
           05  telefone                            pic x(15).
           05  notas.
               10  nota1                           pic 9(02)v99.
               10  nota2                           pic 9(02)v99.
               10  nota3                           pic 9(02)v99.
               10  nota4                           pic 9(02)v99.

       77 wk-msn                                   pic  x(50).

       01 ws-msn-erro.
          05 ws-msn-erro-ofsset                    pic 9(04).
          05 filler                                pic x(01) value "-".
          05 ws-msn-erro-cod                       pic 9(02).
          05 filler                                pic x(01) value space.
          05 ws-msn-erro-text                      pic x(42).

      *>Usado no programa chamado, vari�veis em comum.
       linkage section.


      *>constru��o de telas.
       screen section.
      *>Declara��o de telas.
       01  tela-menu.
      *> Declara��o da tela de menu, onde o usu�rio pode escolher a op��o desejada.

      *>                                0    1    1    2    2    3    3    4    4    5    5    6    6    7    7    8
      *>                                5    0    5    0    5    0    5    0    5    0    5    0    5    0    5    0
      *>                            ----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+
           05 blank screen.
           05 line 01 col 01 value "                                                                     [ ]Sair     ".
           05 line 02 col 01 value "                                Tela Principal                                   ".
           05 line 03 col 01 value "      MENU                                                                       ".
           05 line 04 col 01 value "        [ ]Cadastro de Alunos                                                    ".
           05 line 05 col 01 value "        [ ]Cadastro de Notas                                                     ".
           05 line 06 col 01 value "        [ ]Consulta Sequencial                                                   ".
           05 line 07 col 01 value "        [ ]Consulta Indexada                                                     ".
           05 line 08 col 01 value "        [ ]Alterar Dados                                                         ".
           05 line 09 col 01 value "        [ ]Deletar Dados                                                         ".



      *> Vari�veis da tela.
           05 sc-sair-menu                  line 01  col 71 pic x(01)
           using wk-sair                    foreground-color 12.

           05 sc-cadastro-aluno             line 04  col 10 pic x(01)
           using wk-cadastro-aluno          foreground-color 15.

           05 sc-cadastro-nota              line 05  col 10 pic x(01)
           using wk-cadastro-nota           foreground-color 15.

           05 sc-consulta-sequencial        line 06  col 10 pic x(01)
           using wk-consulta-sequencial     foreground-color 15.

           05 sc-consulta-indexado          line 07  col 10 pic x(01)
           using wk-consulta-indexada       foreground-color 15.

           05 sc-alterar                    line 08  col 10 pic x(01)
           using wk-alterar                 foreground-color 15.

           05 sc-deletar                    line 09  col 10 pic x(01)
           using wk-deletar                 foreground-color 15.


       01  tela-cad-aluno.
      *> declara��o da tela de cadastro de alunos.
      *>                                0    1    1    2    2    3    3    4    4    5    5    6    6    7    7    8
      *>                                5    0    5    0    5    0    5    0    5    0    5    0    5    0    5    0
      *>                            ----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+
           05 blank screen.
           05 line 01 col 01 value "                                                                     [ ]Sair     ".
           05 line 02 col 01 value "                                Cadastro de Alunos                               ".
           05 line 05 col 01 value "      COD Aluno:                                                                 ".
           05 line 06 col 01 value "      Aluno    :                                                                 ".
           05 line 07 col 01 value "      Endereco :                                                                 ".
           05 line 08 col 01 value "      Mae      :                                                                 ".
           05 line 09 col 01 value "      Pai      :                                                                 ".
           05 line 10 col 01 value "      Telefone :                                                                 ".
           05 line 22 col 01 value "              [__________________________________________________]               ".

      *> Vari�veis da tela.
           05 sc-sair-cad-alu          line 01  col 71 pic x(01)
           using wk-sair               foreground-color 12.

           05 sc-cod-cad-alu           line 05  col 17 pic 9(03)
           from wk-cod                 foreground-color 15.

           05 sc-aluno-cad-alu         line 06  col 17 pic x(25)
           using wk-aluno              foreground-color 15.

           05 sc-endereco-cad-alu      line 07  col 17 pic x(35)
           using wk-endereco           foreground-color 15.

           05 sc-mae-cad-alu           line 08  col 17 pic x(25)
           using wk-mae                foreground-color 15.

           05 sc-pai-cad-alu           line 09  col 17 pic x(25)
           using wk-pai                foreground-color 15.

           05 sc-tel-cad-alu           line 10  col 17 pic x(15)
           using wk-tel                foreground-color 15.

           05 sc-msn-cad-alu           line 22  col 16 pic x(50)
           from wk-msn                 foreground-color 15.




       01  tela-cad-notas.
      *> Declara��o da tela de cadastro de notas.
      *>                                0    1    1    2    2    3    3    4    4    5    5    6    6    7    7    8
      *>                                5    0    5    0    5    0    5    0    5    0    5    0    5    0    5    0
      *>                            ----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+
           05 blank screen.
           05 line 01 col 01 value "                                                                     [ ]Sair     ".
           05 line 02 col 01 value "                                Cadastro de Notas                                ".
           05 line 03 col 01 value "       Cod. Aluno:                                                               ".
           05 line 04 col 01 value "       Nota      :                                                               ".
           05 line 05 col 01 value "       Nota      :                                                               ".
           05 line 06 col 01 value "       Nota      :                                                               ".
           05 line 07 col 01 value "       Nota      :                                                               ".
           05 line 22 col 01 value "              [__________________________________________________]               ".

      *> Vari�veis da tela.
           05 sc-sair-cad-not         line 01  col 71 pic x(01)
           using wk-sair              foreground-color 12.

           05 sc-cod-aluno            line 03  col 19 pic 9(03)
           using wk-cod               foreground-color 15.

           05 sc-nota                 line 04  col 19 pic 9(02)v99
           using nota1                foreground-color 15.

           05 sc-nota                 line 05  col 19 pic 9(02)v99
           using nota2                foreground-color 15.

           05 sc-nota                 line 06  col 19 pic 9(02)v99
           using nota3                foreground-color 15.

           05 sc-nota                 line 07  col 19 pic 9(02)v99
           using nota4                foreground-color 15.

           05 sc-msn-cad-not          line 22  col 16 pic x(50)
           from wk-msn                foreground-color 15.


       01  tela-consulta-cad.
      *> Declara��o da tela de consulta do cadastro em formato sequencial.
      *> O primeiro codigo aparece na tela, conforme o usuario vai dando enter os proximos cadastros v�o aparecendo.
      *>
      *>                                0    1    1    2    2    3    3    4    4    5    5    6    6    7    7    8
      *>                                5    0    5    0    5    0    5    0    5    0    5    0    5    0    5    0
      *>                            ----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+
           05 blank screen.
           05 line 01 col 01 value "                                                                     [ ]Sair     ".
           05 line 02 col 01 value "                        Consulta Cadastro Sequencial                             ".
           05 line 05 col 01 value " Cod: Aluno:                    Endereco:                                        ".
           05 line 07 col 01 value " Mae:                     Pai:                     Telefone:          Media:     ".
           05 line 22 col 01 value "              [__________________________________________________]               ".

      *> Vari�veis da tela.

           05 sc-sair-con-cad         line 01  col 71 pic x(01)
           using wk-sair              foreground-color 12.

           05 sc-cad-aluno            line 06 col 02 pic 9(03)
           from cod                   foreground-color 15.

           05 sc-cad-aluno            line 06 col 07 pic x(25)
           from aluno                 foreground-color 15.

           05 sc-cad-aluno            line 06 col 33 pic x(35)
           from endereco              foreground-color 15.

           05 sc-cad-aluno            line 08 col 02 pic x(25)
           from mae                   foreground-color 15.

           05 sc-cad-aluno            line 08 col 27 pic x(25)
           from pai                   foreground-color 15.

           05 sc-cad-aluno            line 08 col 52 pic x(15)
           from telefone              foreground-color 15.

           05 sc-cad-aluno            line 08 col 71 pic 9(02)v99
           from wk-media              foreground-color 15.

           05 sc-msn-cad-aluno        line 22  col 16 pic x(50)
           from wk-msn                foreground-color 15.

       01  Tela-consulta-indexada.
      *> Declara��o de tela da consulta do cadastro de alunos em formato indexado.
      *> O usu�rio digita o cod do aluno e o cadastro referente ao cod aparece na tela.
      *>
      *>                                0    1    1    2    2    3    3    4    4    5    5    6    6    7    7    8
      *>                                5    0    5    0    5    0    5    0    5    0    5    0    5    0    5    0
      *>                            ----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+
           05 blank screen.
           05 line 01 col 01 value "                                                                     [ ]Sair     ".
           05 line 02 col 01 value "                         Consulta de Cadastro por Cod                            ".
           05 line 05 col 01 value "                       Digite o Cod que deseja Acessar:                          ".
           05 line 06 col 01 value "                                   [   ]                                        ".
           05 line 08 col 01 value " Aluno:                   Endereco:                                              ".
           05 line 10 col 01 value " Mae:                     Pai:                     Telefone:          Media:     ".
           05 line 22 col 01 value "              [__________________________________________________]               ".

      *> Vari�veis da tela.
           05 sc-sair-index         line 01  col 71 pic x(01)
           using wk-sair            foreground-color 12.

           05 sc-cad-index          line 06 col 37 pic 9(03)
           using wk-cod             foreground-color 12.

           05 sc-cad-aluno          line 09 col 02 pic x(25)
           from aluno               foreground-color 15.

           05 sc-cad-aluno          line 09 col 27 pic x(35)
           from endereco            foreground-color 15.

           05 sc-cad-aluno          line 11 col 02 pic x(25)
           from mae                 foreground-color 15.

           05 sc-cad-aluno          line 11 col 27 pic x(25)
           from pai                 foreground-color 15.

           05 sc-cad-aluno          line 11 col 52 pic x(15)
           from telefone            foreground-color 15.

           05 sc-cad-aluno          line 11 col 71 pic 9(02)v99
           from wk-media            foreground-color 15.

           05 sc-msn-cad-index      line 22  col 16 pic x(50)
           from wk-msn              foreground-color 15.


       01  Tela-alterar.
      *> Declara��o da tela para alterar dados do cadastro de alunos.
      *>
      *> O usu�rio digita o cod do cadastro que deseja alterar, o programa traz os dados do registro como est�o
      *> no cadastro.
      *> Ent�o ele apaga o registro do campo que esta incorreto e digita o dado correto, ou acrescenta o dado faltando conforme a necessidade
      *> depois ele d� o enter e o programa salva a altera��o no sistema.
      *>
      *>                                0    1    1    2    2    3    3    4    4    5    5    6    6    7    7    8
      *>                                5    0    5    0    5    0    5    0    5    0    5    0    5    0    5    0
      *>                            ----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+
           05 blank screen.
           05 line 01 col 01 value "                                                                     [ ]Sair     ".
           05 line 02 col 01 value "                            Altera��o de Cadastro                                ".
           05 line 05 col 01 value "                       Digite o Cod que deseja ALTERAR:                          ".
           05 line 06 col 01 value "                                    [   ]                                       ".
           05 line 08 col 01 value " ALTERAR CADASTRO:                                                               ".
           05 line 09 col 01 value " Aluno:                   Endereco:                                              ".
           05 line 11 col 01 value " Mae:                     Pai:                     Telefone:          Media:     ".
           05 line 13 col 01 value " Alterar Notas:                                                                  ".
           05 line 14 col 01 value " Nota:                                                                           ".
           05 line 15 col 01 value " Nota:                                                                           ".
           05 line 16 col 01 value " Nota:                                                                           ".
           05 line 17 col 01 value " Nota:                                                                           ".
           05 line 22 col 01 value "              [__________________________________________________]               ".

      *> Vari�veis da tela.
           05 sc-sair-alterar         line 01  col 71 pic x(01)
           using wk-sair              foreground-color 12.

           05 sc-cad-alterar          line 06 col 38 pic 9(03)
           using wk-cod               foreground-color 12.

           05 sc-cad-alterar          line 10 col 02 pic x(25)
           using aluno                foreground-color 15.

           05 sc-cad-alterar          line 10 col 27 pic x(35)
           using endereco             foreground-color 15.

           05 sc-cad-alterar          line 12 col 02 pic x(25)
           using mae                  foreground-color 15.

           05 sc-cad-alterar          line 12 col 27 pic x(25)
           using pai                  foreground-color 15.

           05 sc-cad-alterar          line 12 col 52 pic x(15)
           using telefone             foreground-color 15.

           05 sc-nota-alterar         line 14  col 08 pic 9(02)v99
           using nota1                foreground-color 15.

           05 sc-nota-alterar         line 15  col 08 pic 9(02)v99
           using nota2                foreground-color 15.

           05 sc-nota-alterar         line 16  col 08 pic 9(02)v99
           using nota3                foreground-color 15.

           05 sc-nota-alterar         line 17  col 08 pic 9(02)v99
           using nota4                foreground-color 15.

           05 sc-msn-cad-alterar      line 22  col 16 pic x(50)
           from wk-msn                foreground-color 15.

       01  Tela-deletar.
      *> Declara��o da tela deletar.
      *> O usuario digita o cod que deseja deletar e da enter, pronto. O arquivo ser� deletado.
      *>                                0    1    1    2    2    3    3    4    4    5    5    6    6    7    7    8
      *>                                5    0    5    0    5    0    5    0    5    0    5    0    5    0    5    0
      *>                            ----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+
           05 blank screen.
           05 line 01 col 01 value "                                                                     [ ]Sair     ".
           05 line 02 col 01 value "                            Alteracao de Cadastro                                ".
           05 line 05 col 01 value "                       Digite o Cod que deseja DELETAR:                          ".
           05 line 06 col 01 value "                                    [   ]                                        ".
           05 line 22 col 01 value "              [__________________________________________________]               ".

      *> Vari�veis da tela.

           05 sc-sair-deletar         line 01  col 71 pic x(01)
           using wk-sair              foreground-color 12.

           05 sc-cad-deletar          line 06 col 38 pic 9(03)
           using wk-cod               foreground-color 12.

           05 sc-msn-cad-deletar      line 22  col 16 pic x(50)
           from wk-msn                foreground-color 15.


      *>Declara��o dos Procedimentos, do corpo do programa
       Procedure Division.

      *> Perform para sinalizar a ordem de abertura das sections.
           perform inicializa.
           perform processamento.
           perform finaliza.

      *>-----------------------------------------------------------------
       inicializa section.
      *>-----------------------------------------------------------------

      *> Inicializa��o das vari�veis.
           move 0 to cod
           move 0 to fd-cod
           move 0 to wk-cod
           move  spaces      to     menu

      *> Abertura do Arquivo indexado, que tem 4 op��es de abertura, a escolhida foi o
      *> open i-o.

           open i-o ArqAlunos
           if ws-fs-ArqAlunos <> 0           *> Tratamento para identifica��o de poss�vel erro no programa.
           and ws-fs-ArqAlunos <> 05 then    *> Tratamento para seguir o programa, mesmo com a situa��o do erro 05.
               move 1                                to ws-msn-erro-ofsset *>|
               move ws-fs-ArqAlunos                  to ws-msn-erro-cod    *> Mensagem que ser� exibida para
               move "Erro ao abrir o arquivo"        to ws-msn-erro-text   *>|    reportar o erro.
               perform finaliza-anormal
           end-if



           .
       inicializa-exit.
       exit.

      *>-----------------------------------------------------------------
       processamento section.
      *>-----------------------------------------------------------------

      *> perform para gerar o op��o de sa�da da tela.
           perform until wk-sair = "X"
                      or wk-sair = "x"

      *>        inicializa��o das variaveis  da tela
                move   space  to  wk-cadastro-aluno
                move   space  to  wk-cadastro-nota
                move   space  to  wk-consulta-sequencial
                move   space  to  wk-consulta-indexada
                move   space  to  wk-alterar
                move   space  to  wk-deletar
                move   space  to  wk-sair

      *> display da tela de menu, com as op��es para o usu�rio.
                display tela-menu
                accept  tela-menu

      *> comando de ifs para identificar a op��o escolhida pelo usu�rio.
      *> e encaminh�-lo aos comandos que executar�o a op��o desejada.
                if wk-cadastro-aluno = "X"
                or wk-cadastro-aluno = "x" then
                       perform cadastrar-aluno
                end-if

                if wk-cadastro-nota = "X"
                or wk-cadastro-nota = "x" then
                       perform cadastrar-notas
                end-if

                if wk-consulta-sequencial = "X"
                or wk-consulta-sequencial = "x" then
                       perform consultar-cadastro-seq
                end-if

                if wk-consulta-indexada = "X"
                or wk-consulta-indexada = "x" then
                       perform consultar-cadastro-index
                end-if

                if wk-alterar = "X"
                or wk-alterar = "x" then
                       perform alterar
                end-if

                if wk-deletar = "X"
                or wk-deletar = "x" then
                       perform deletar
                end-if
           end-perform


           .
       processamento-exit.
       exit.
      *>-----------------------------------------------------------------------
       cadastrar-aluno section.
      *>-----------------------------------------------------------------------
      *> perform para gerar o op��o de sa�da da tela.
            perform until wk-sair = "V"
                       or wk-sair = "v"

      *> Inicializa��o das vari�veis.
               move   0             to  wk-cod
               move spaces          to  wk-aluno
               move spaces          to  wk-endereco
               move spaces          to  wk-mae
               move spaces          to  wk-pai
               move spaces          to  wk-tel

      *> Perform para idenficar qual o prox cod do cadastro.
      *> Ele gera o numero do cadastro de forma autom�tica na ordem crescente.
               perform buscar-cod
               move cod  to wk-cod

      *> display da tela de cadastro.
               display tela-cad-aluno
               accept tela-cad-aluno
      *> Tratamento para o programa n�o gravar dados com espa�os,
      *> gerados por enters do usu�rio.
               if wk-aluno <> space then

                   move wk-aluno      to aluno
                   move wk-endereco   to endereco
                   move wk-mae        to mae
                   move wk-pai        to pai
                   move wk-tel        to telefone

      *> comando para salvar os registros
      *> nas variaveis declaradas dentro do arquivo indexado.
                   write fd-alunos from alunos


                   if ws-fs-ArqAlunos <> 0 then                    *> Tratamento para identifica��o de poss�vel erro no programa.
                       move 2                                      to ws-msn-erro-ofsset *>|
                       move ws-fs-ArqAlunos                        to ws-msn-erro-cod    *> Mensagem que ser� exibida para
                       move "Erro ao escrever o arquivo"           to ws-msn-erro-text   *>|    reportar o erro.
                       perform finaliza-anormal
                   end-if
               end-if
            end-perform


           .
       cadastrar-aluno-exit.
       exit.

      *>------------------------------------------------------------------------
       cadastrar-notas section.
      *>------------------------------------------------------------------------
      *> perform para gerar o op��o de sa�da da tela.
           perform until wk-sair = "V"
                      or wk-sair = "v"

      *> inicializa��o das vari�veis.
               move zero to cod
               move zero to wk-cod
               move zero to nota1
               move zero to nota2
               move zero to nota3
               move zero to nota4

      *> display da tela de cadastro de notas.
               display tela-cad-notas
               accept tela-cad-notas

      *> tratamento para n�o gravar dados em um cod vazio ou zerado.
               If wk-cod <> 0 then
                   move wk-cod to fd-cod
      *> comando para leitura do arquivo indexado com os dados dos registros.
                   read ArqAlunos

                   if ws-fs-ArqAlunos <> 0 then              *> Tratamento para identifica��o de poss�vel erro no programa.
                       move 3                                to ws-msn-erro-ofsset *>|
                       move ws-fs-ArqAlunos                  to ws-msn-erro-cod    *> Mensagem que ser� exibida para
                       move "Erro de Leitura do arq. notas"  to ws-msn-erro-text   *>|    reportar o erro.
                       perform finaliza-anormal
                   end-if

                       move notas to fd-notas
      *> Inicializa��o do campo de mensagens.
                       move space   to    wk-msn

      *> comandos de ifs para tratamento do cadastro de notas,
      *> os valores cadastrados ficam dentro das notas aceit�veis de 0 - 10.
                       if   nota1 >= 0 and nota1 <= 10
                       and  nota2 >= 0 and nota2 <= 10
                       and  nota3 >= 0 and nota3 <= 10
                       and  nota4 >= 0 and nota4 <= 10 then

      *> Comando de reescrita, pois as notas est�o com dados de inicializa��o 11.
      *> Assim quando o usu�rio digitar as notas corretas, elas ser�o reescritas
      *> no arquivo.
                           rewrite fd-alunos
      *> op��o do if, caso o cadastro das notas n�o ocorra de forma correta.
                       else
                           move " Nota invalida " to wk-msn
                       end-if
                       accept tela-cad-notas
               end-if
           end-perform

           .
       cadastrar-notas-exit.
       exit.
      *>------------------------------------------------------------------------
       consultar-cadastro section.
      *>------------------------------------------------------------------------
      *> Inicializar o fd-cod, induzindo o primeiro registro para que a leitura
      *> siga a partir dele.

           Add 1 to fd-cod
      *> Condi��o de sa�da
           perform until wk-sair = "V"
                      or wk-sair = "v"

      *> Movendo para chave o cod digitado.
               move fd-cod to cod

      *> Lendo o arquivo
               read ArqAlunos into alunos

               move aluno       to wk-aluno
               move endereco    to wk-endereco
               move mae         to wk-mae
               move pai         to wk-pai
               move telefone    to wk-tel

      *> Preform media: encaminhamento a sec�o onde sera feito o c�lculo da media
      *> das notas fornecidas pelo usu�rio.
               perform media

      *> Identifica��o de erro
               if  ws-fs-ArqAlunos <> 0                     *> Tratamento para identifica��o de poss�vel erro no programa.
               and ws-fs-ArqAlunos <> 10 then               *> Tratamento para continuar o programa, mesmo que acuse o erro 10 de fim de arquivo.
                   move 4                                   to ws-msn-erro-ofsset *>|
                   move ws-fs-ArqAlunos                     to ws-msn-erro-cod    *> Mensagem que ser� exibida para
                   move "Erro ao Consultar arquivo"         to ws-msn-erro-text   *>|    reportar o erro.
                   perform finaliza-anormal
               else
                   if ws-fs-ArqAlunos = 23 then             *> Tratamento em caso de erro 23.
                   move "Cod informado invalida!" to wk-msn *> Mensagem mostrando o possivel erro do usu�rio.

               end-if

      *> Comando para leitura dos proximos registros.
                   read ArqAlunos next
                   if ws-fs-ArqAlunos = 10 and cod = 0 then
                      perform consultar-temp-sequencial-prev
                   end-if

                   display tela-consulta-cad
                   accept tela-consulta-cad

           end-perform

           .
       consultar-cadastro-exit.
       exit.


      *>------------------------------------------------------------------------
       consultar-cadastro-seq section.
      *>------------------------------------------------------------------------

           perform consultar-cadastro
      *> perform para gerar o op��o de sa�da da tela.
               perform until wk-sair = "V"
                          or wk-sair = "v"

               move wk-cod to fd-cod
      *> comando para leitura dos arquivos em sequencia
               read ArqAlunos next

               if  ws-fs-ArqAlunos <> 0  then                 *> Tratamento para identifica��o de poss�vel erro no programa.
                  if ws-fs-ArqAlunos = 10 then                *> Tratamento em caso aviso de fim de arquivo.
                      perform consultar-temp-sequencial-prev
                  else
                      move 5                                   to ws-msn-erro-ofsset *>|
                      move ws-fs-ArqAlunos                     to ws-msn-erro-cod    *> Mensagem que ser� exibida para
                      move "Erro ao Ler o arquivo seq"         to ws-msn-erro-text   *>|    reportar o erro.
                      perform finaliza-anormal
                  end-if
               end-if

                       move  fd-alunos       to  wk-alunos

               end-perform
           .
       consultar-cadastro-seq-exit.
       exit.
      *>------------------------------------------------------------------------
       consultar-temp-sequencial-prev section.
      *>------------------------------------------------------------------------
      *> perform para gerar o op��o de sa�da da tela.
           perform until wk-sair = "V"
                      or wk-sair = "v"

      *> Comando para leitura do arquivo de tras para frente
               read ArqAlunos previous
               if  ws-fs-ArqAlunos <> 0  then                  *> Tratamento para identifica��o de poss�vel erro no programa.
                  if ws-fs-ArqAlunos = 10 then                 *> Tratamento em caso aviso de fim de arquivo.
                      perform consultar-cadastro-seq
                  else
                      move 6                                   to ws-msn-erro-ofsset *>|
                      move ws-fs-ArqAlunos                     to ws-msn-erro-cod    *> Mensagem que ser� exibida para
                      move "Erro ao Ler arquivo seq-prev"      to ws-msn-erro-text   *>|    reportar o erro.
                      perform finaliza-anormal
                  end-if
               end-if

               move  fd-alunos       to  alunos

          end-perform


           .
       consultar-temp-seq-prev-exit.
           exit.

      *>------------------------------------------------------------------------
       consultar-cadastro-index section.
      *>------------------------------------------------------------------------
           initialize alunos
      *> perform para gerar o op��o de sa�da da tela.
               perform until wk-sair = "V"
                          or wk-sair = "v"

               display Tela-consulta-indexada
               accept Tela-consulta-indexada

               move wk-cod to fd-cod

      *> comando para leitura do arquivo.
               read ArqAlunos
               move  fd-alunos to alunos

      *> Perform media: encaminhamento para a sec��o onde ser� feito o c�lculo da m�dia
      *> das notas fornecidas pelo usu�rio.
               perform media

                   if ws-fs-ArqAlunos = 23 then                        *> Tratamento em caso de exibi��o do erro 23.
                       move "Cod informado invalido!" to wk-msn        *> Mensagem mostrando o possivel erro do usu�rio.
                       if  ws-fs-ArqAlunos <> 0  then
                           else
                               move 7                                   to ws-msn-erro-ofsset *>|
                               move ws-fs-ArqAlunos                     to ws-msn-erro-cod    *> Mensagem que ser� exibida para
                               move "Erro ao ler arquivo index"         to ws-msn-erro-text   *>|    reportar o erro.
                               perform finaliza-anormal
                       end-if
                   end-if
           end-perform

                               initialize alunos wk-cod

           .
       consultar-cadastro-index-exit.
       exit.

      *>------------------------------------------------------------------------
       alterar section.
      *>------------------------------------------------------------------------

           initialize alunos
      *> perform para gerar o op��o de sa�da da tela.
               perform until wk-sair = "V"
                          or wk-sair = "v"

               display Tela-alterar
               accept Tela-alterar

               move wk-cod to fd-cod

      *> Comando de leitura dos arquivos.
               read ArqAlunos
               move  fd-alunos to alunos

               display Tela-alterar
               accept Tela-alterar

                   if  ws-fs-ArqAlunos = 0 then                            *> Tratamento em caso de erros.
                       move " Cadastro alterado com sucesso " to wk-msn    *> Mensagem avisando ao usu�rio sobre sucesso da altera��o.
                   else
                       move 8                                   to ws-msn-erro-ofsset *>|
                       move ws-fs-ArqAlunos                     to ws-msn-erro-cod    *> Mensagem que ser� exibida para
                       move "Erro ao alterar o arquivo"         to ws-msn-erro-text   *>|    reportar o erro.
                       perform finaliza-anormal
                   end-if

                       move wk-cod to fd-cod
                       move alunos to fd-alunos

      *> Comando para reescrever os dados que est�o no arquivo.
                       rewrite fd-alunos

               end-perform
      *> inicializa��o das vari�veis do grupo alunos, para quando ser acessado novamente
      *> os campos estarem sem dados.
                       initialize alunos

           .
       alterar-exit.
       exit.

      *>------------------------------------------------------------------------
       deletar section.
      *>------------------------------------------------------------------------
      *> perform para gerar o op��o de sa�da da tela.
           perform until wk-sair = "V"
                      or wk-sair = "v"

           display Tela-deletar
           accept Tela-deletar

           move wk-cod to fd-cod

      *> Comando para deletar os dados do registro no arquivo.
           delete ArqAlunos
               if  ws-fs-ArqAlunos = 0 then                         *> Tratamento em caso de erros.
                   move " Cadastro deletado com sucesso" to wk-msn  *> Mensagem avisando ao usu�rio sobre sucesso em apagar o dado.
                   if ws-fs-ArqAlunos = 23 then                     *> tratamento em caso de erro 23
                       move "Cod informado invalido!"    to wk-msn  *> Mensagem avisando o usuario sobre o poss�vel erro.
                   else
                       if  ws-fs-ArqAlunos <> 0 then
                           move 9                                   to ws-msn-erro-ofsset *>|
                           move ws-fs-ArqAlunos                     to ws-msn-erro-cod    *> Mensagem que ser� exibida para
                           move "Erro ao Deletar o arquivo "        to ws-msn-erro-text   *>|    reportar o erro.
                           perform finaliza-anormal
                       end-if
                   end-if
               end-if

           .
       deletar-exit.
       exit.
      *>------------------------------------------------------------------------
       buscar-cod section.
      *>------------------------------------------------------------------------
      *> Inicializa��o do fd-cod
           move 1 to fd-cod
      *> Comando para leitura do arquivo
           read ArqAlunos

           if ws-fs-ArqAlunos = 23 then           *> tratamento do erro 23.
               move 1 to cod
           else
               perform until ws-fs-ArqAlunos = 10 *> tratamento do "erro" 10
                   read ArqAlunos next            *> Comando para leitura do arquivo em sequencia
               end-perform
               move fd-cod to cod
               add 1 to cod                        *> Acrescentando 1 ao cod para ele ler o pr�ximo.
           end-if
           .
       buscar-cod-exit.
       exit.

      *>------------------------------------------------------------------------
      *>C�lculo M�dia
      *>------------------------------------------------------------------------
       media section.
      *> C�lulo da m�dia das notas dos alunos.
           compute wk-media = (nota1 + nota2 + nota3 + nota4 ) / 4

           .
       media-exit.
       exit.
      *>------------------------------------------------------------------------
      *>  Finaliza��o Anormal
      *>------------------------------------------------------------------------
       finaliza-anormal section.
      *> Comando para limpar tela.
           display erase
           display ws-msn-erro *> Comando para exibi��o de mensagem reportando poss�vel erro.
           Stop run            *> Comando de fim do programa.

           .
       finaliza-anormal-exit.
       exit.

      *>-----------------------------------------------------------------
       finaliza section.
      *>-----------------------------------------------------------------
           close ArqAlunos                            *> Comando para fechar o arquivo indexado.
           if ws-fs-ArqAlunos <> 0 then               *> tratamento para exibi��o de poss�veis erros.
               move 10                                to ws-msn-erro-ofsset  *>|
               move ws-fs-ArqAlunos                   to ws-msn-erro-cod     *> Mensagem que ser� exibida para
               move "Erro ao fechar o arquivo"        to ws-msn-erro-text    *>|    reportar o erro.
               perform finaliza-anormal
           end-if

        Stop Run *> Comando para fim do programa.

           .
       finaliza-exit.
       exit.







