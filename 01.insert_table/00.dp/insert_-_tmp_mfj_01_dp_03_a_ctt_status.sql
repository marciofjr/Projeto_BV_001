--
-------------------------------------------------------------------------------------------------------------------
--
-->Posicao do Contrato - Status:
--{03} = {tmp_mfj_01_dp_03_a_ctt_status}
    /*
        03 = {tmp_mfj_01_dp_03_a_ctt_status}
                {
                    >Posicao do Contrato - Status:
                        [id_status_ctt] = identificador
                        [cod_empresa] = codigo empresa {padraoBD}
                        [cod_credor] = codigo credor {padraoBD}
                        [flg_status_ctt] = flag status {0:Inativo, 1:Ativo, 2:Suspenso}
                        [cod_posicao_contr] = codigo posicao do contrato {padraoBD}
                        [nom_posicao_contr] = descricao posicao contrato {padraoBD}
                        [flg_bloqueia_calculo] = flag {0:Inativo, 1:Ativo}
                        [flg_performa] = flag {0:Inativo, 1:Ativo}
                        [flg_exibe_pesquisa] = flag {0:Inativo, 1:Ativo}
                        [flg_notifica] = flag {0:Inativo, 1:Ativo}
                        [flg_inibe_historico] = flag {0:Inativo, 1:Ativo}
                        [flg_inibe_historico_troca_pos] = flag {0:Inativo, 1:Ativo}
                }><m
    */
--
--SELECT * FROM public.tmp_mfj_01_dp_03_a_ctt_status;
INSERT INTO public.tmp_mfj_01_dp_03_a_ctt_status 
(id_status_ctt, cod_empresa, cod_credor, flg_status_ctt, 
cod_posicao_contr, nom_posicao_contr, flg_bloqueia_calculo, 
flg_performa, flg_exibe_pesquisa, flg_notifica, 
flg_inibe_historico, flg_inibe_historico_troca_pos)
VALUES
( 1, 1, 6, 1, '0', 'Sem Acordo', 0, 0, 1, 1, 0, 0 ), 
( 2, 1, 950, 1, '0', 'Sem Acordo', 0, 0, 1, 0, 0, 0 ), 
( 3, 1, 6, 0, '1', 'Liquidado', 1, 1, 1, 0, 0, 0 ), 
( 4, 1, 950, 0, '1', 'Liquidado', 1, 0, 1, 0, 0, 0 ), 
( 5, 1, 950, 1, '2', 'Atualizado', 1, 0, 1, 0, 0, 0 ), 
( 6, 1, 6, 1, '2', 'Atualizado', 1, 1, 1, 0, 0, 0 ), 
( 7, 1, 950, 0, '3', 'Acordo', 1, 0, 1, 0, 0, 0 ), 
( 8, 1, 6, 0, '3', 'Acordo', 1, 1, 1, 0, 0, 0 ), 
( 9, 1, 950, 0, '4', 'Adormecido', 1, 0, 1, 0, 0, 0 ), 
( 10, 1, 6, 0, '4', 'Adormecido', 1, 1, 1, 0, 0, 0 ), 
( 11, 1, 6, 0, '5', 'Devolvido', 1, 1, 1, 0, 0, 0 ), 
( 12, 1, 950, 0, '5', 'Devolvido', 1, 0, 1, 0, 0, 0 ), 
( 13, 1, 950, 0, '6', 'Acordo falhado', 1, 0, 1, 0, 0, 0 ), 
( 14, 1, 6, 0, '6', 'Acordo falhado', 1, 1, 1, 0, 0, 0 ), 
( 15, 1, 950, 0, '7', 'Pagamento direto', 1, 0, 1, 0, 0, 0 ), 
( 16, 1, 6, 0, '7', 'Pagamento direto', 1, 1, 1, 0, 0, 0 ), 
( 17, 1, 6, 0, '8', 'Credor solicitou', 1, 1, 1, 0, 0, 0 ), 
( 18, 1, 950, 0, '8', 'Credor solicitou', 1, 0, 1, 0, 0, 0 ), 
( 19, 1, 950, 1, '9', 'Pesquisa', 1, 0, 1, 0, 0, 0 ), 
( 20, 1, 6, 0, 'c', 'Inibir cobrança', 1, 0, 0, 0, 0, 0 ), 
( 21, 1, 6, 1, 'D', 'Cliente sem localização', 0, 0, 1, 0, 0, 0 ), 
( 22, 1, 6, 1, 'E', 'Cliente sem condições', 0, 1, 1, 0, 0, 0 ), 
( 23, 1, 6, 1, 'F', 'Telefone não atende', 0, 1, 1, 0, 0, 0 ), 
( 24, 1, 6, 1, 'I', 'inclusao manual lista', 0, 1, 1, 0, 0, 0 ), 
( 25, 1, 6, 1, 'o', 'Pendência de Repasse', 1, 1, 1, 0, 0, 0 ), 
( 26, 1, 6, 1, 'P', 'Pendência', 1, 1, 1, 0, 0, 0 ), 
( 27, 1, 6, 1, 'R', 'Recado', 0, 1, 1, 0, 0, 0 ), 
( 28, 1, 950, 1, 'R', 'Recado', 0, 1, 1, 0, 0, 0 ), 
( 29, 1, 6, 2, 's', 'Suspensão', 1, 0, 1, 0, 0, 0 ), 
( 30, 1, 950, 2, 's', 'Suspensão', 1, 0, 1, 0, 0, 0 ), 
( 31, 1, 6, 1, 'T', 'Promessa de pagamento para', 0, 1, 1, 0, 0, 0 ), 
( 32, 1, 6, 0, 'V', 'Veículo vendido', 1, 0, 1, 0, 0, 0 ), 
( 33, 1, 6, 1, 'y', 'Formalizado Acordo', 0, 0, 1, 0, 0, 0 ), 
( 34, 1, 6, 1, 'Z', 'Cliente tem interesse no pagam', 0, 1, 1, 0, 0, 0 )
;
--
-------------------------------------------------------------------------------------------------------------------
--