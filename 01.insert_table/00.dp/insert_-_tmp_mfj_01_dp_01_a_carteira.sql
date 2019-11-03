--
-------------------------------------------------------------------------------------------------------------------
--
-->Tipo de carteira
--{01} = {tmp_mfj_01_dp_01_a_carteira}
    /*
        01 = {tmp_mfj_01_dp_01_a_carteira}
                {
                    >Tipo de carteira:
                        [id_carteira] = identificador
                        [cod_credor] = codigo credor {padraoBD}
                        [cod_entid_credor] = codigo entidade credor {padraoBD}
                        [carteira_nome] = carteira nome {produto cliente}
                }><m
    */
-->dp_01_a_carteira    
-->Tipo de carteira
--
--SELECT * FROM public.tmp_mfj_01_dp_01_a_carteira;
INSERT INTO public.tmp_mfj_01_dp_01_a_carteira 
(id_carteira, cod_credor, cod_entid_credor, carteira_nome) 
VALUES 
( 1, 950, 100, 'Averbado' ), 
( 2, 6, 100, 'Desaverbado' ), 
( 3, 6, 600, 'Reneg' )
; 
--
-------------------------------------------------------------------------------------------------------------------
--