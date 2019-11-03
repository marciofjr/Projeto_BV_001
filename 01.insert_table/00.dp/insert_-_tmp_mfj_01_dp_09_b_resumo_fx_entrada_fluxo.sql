--
-------------------------------------------------------------------------------------------------------------------
--
-->Resumo Faixa Estoque e Fluxo:
--{09}-B = {tmp_mfj_01_dp_09_b_resumo_fx_entrada_fluxo}
    /*
        09-B = {tmp_mfj_01_dp_09_b_resumo_fx_entrada_fluxo}
                {
                    >Resumo Faixa Estoque e Fluxo:
                        [id_fx_flux_estoq] = identificador {01 até 14} 
                        [desc_fluxo_estoque] = descricao {fluxo ou estoque} e qual faixa atuacao
                }><m
    */
--
--SELECT * FROM public.tmp_mfj_01_dp_09_b_resumo_fx_entrada_fluxo;
INSERT INTO public.tmp_mfj_01_dp_09_b_resumo_fx_entrada_fluxo 
( id_fx_flux_estoq, desc_fluxo_estoque )
VALUES
( 1, '01.Fluxo 000 ~ 002' ), 
( 2, '02.Fluxo 003 ~ 005' ), 
( 3, '03.Fluxo 006 ~ 015' ), 
( 4, '04.Fluxo 016 ~ 030' ), 
( 5, '05.Fluxo 031 ~ 099' ), 
( 6, '06.Estoq 000 ~ 015' ), 
( 7, '07.Estoq 016 ~ 030' ), 
( 8, '08.Estoq 031 ~ 045' ), 
( 9, '09.Estoq 046 ~ 060' ), 
( 10, '10.Estoq 061 ~ 090' ), 
( 11, '11.Estoq 091 ~ 180' ), 
( 12, '12.Estoq 181 ~ 360' ), 
( 13, '13.Estoq 361 ~ 720' ), 
( 14, '14.Estoq Acima 720d' ),
( 99, '99.Contrato Inativo' )
;
--
-------------------------------------------------------------------------------------------------------------------
--