--
-------------------------------------------------------------------------------------------------------------------
--
-->Produto do Contrato
--{02} = {tmp_mfj_01_dp_02_a_produto}
    /*
        02 = {tmp_mfj_01_dp_02_a_produto}
                {
                    >Produto do Contrato - Segmentacao:
                        [id_prod] = identificador
                        [desc_prod] = descricao produto
                        [rel_prod] = descricao produto {resumo}
                }><m
    */
-->dp_02_a_produto    
-->Produto do Contrato
--
--SELECT * FROM public.tmp_mfj_01_dp_02_a_produto;
INSERT INTO public.tmp_mfj_01_dp_02_a_produto 
(id_prod, desc_prod, rel_prod) 
VALUES 
( 1, 'CONSIGNADO INSS', 'INSS' ), 
( 2, 'CONSIGNADO PREFEITURA DE SAO PAULO', 'PREF. SP' ), 
( 3, 'CONSIGNADO PRIVADO', 'PRIVADO' ), 
( 4, 'CONSIGNADO PUBLICO', 'PUBLICO' ), 
( 5, 'CONSIGNADO PUBLICO - EXERCITO', 'EXERCITO' ), 
( 6, 'CONSIGNADO VIA BANCO - DIVERSOS', 'DIVERSOS' ),
--SEM PRODUTO:::
( 99, 'SEM PRODUTO', 'SEM PROD' )
;
--
-------------------------------------------------------------------------------------------------------------------
--