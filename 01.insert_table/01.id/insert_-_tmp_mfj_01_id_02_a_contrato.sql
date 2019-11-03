--
-------------------------------------------------------------------------------------------------------------------
--
-->Identificador Contrato:
--{02} = {tmp_mfj_01_id_02_a_contrato}
    /*
        02 = {tmp_mfj_01_id_02_a_contrato}
                {
                    >Identificador Contrato:
                        [id_contrato] = identificador Cliente
                        [cod_empresa] = codigo empresa {padraoBD}
                        [cod_credor] = codigo credor {padraoBD}
                        [cod_entid_credor] = codigo entidade {padraoBD}
                        [num_contr] = numero de contrato {padraoBD}
                }><m
id_contrato int DEFAULT NEXTVAL('tmp_mfj_01_id_02_a_contrato_seq') PRIMARY KEY,
cod_empresa int NOT NULL,
cod_credor int NOT NULL,
cod_entid_credor int NOT NULL,
num_contr varchar(50) NOT NULL
    */
--
--SELECT * FROM public.tmp_mfj_01_id_02_a_contrato;
--Ajusta a Sequencia de ID:::
SELECT 
    SETVAL('public.tmp_mfj_01_id_02_a_contrato_seq', 
        (
            SELECT 
                COALESCE(MAX(m_id.id_contrato),1) m_id_m 
            FROM public.tmp_mfj_01_id_02_a_contrato m_id
        ), 
        TRUE);
--Inserir na Base
INSERT INTO public.tmp_mfj_01_id_02_a_contrato
SELECT
    nextval('public.tmp_mfj_01_id_02_a_contrato_seq') AS id_contrato,
    m_coleta.cod_empresa,
    m_coleta.cod_credor,
    m_coleta.cod_entid_credor,
    m_coleta.num_contr
FROM
(
SELECT
        m_sys02.cod_empresa, 
        m_sys02.cod_credor,
        m_sys02.cod_entid_credor,
        m_sys02.num_contr
FROM 
(
    SELECT 
        m_sys.cod_empresa, 
        m_sys.cod_credor,
        m_sys.cod_entid_credor::int,
        m_sys.num_contr
    FROM public.cob_contr m_sys
    JOIN tmp_mfj_01_dp_01_a_carteira m_fil_cart
        ON m_sys.cod_credor = m_fil_cart.cod_credor
	    AND m_sys.cod_entid_credor::int = m_fil_cart.cod_entid_credor
	WHERE m_sys.cod_empresa = 1
) m_sys02
	WHERE NOT EXISTS
        ( 
            SELECT 
                m_ft.id_contrato 
            FROM public.tmp_mfj_01_id_02_a_contrato m_ft
            WHERE m_sys02.num_contr = m_ft.num_contr
                AND m_sys02.cod_empresa = m_ft.cod_empresa
                AND m_sys02.cod_credor = m_ft.cod_credor
                AND m_sys02.cod_entid_credor = m_ft.cod_entid_credor
        ) 
ORDER BY m_sys02.num_contr, m_sys02.cod_empresa, m_sys02.cod_credor, m_sys02.cod_entid_credor
) m_coleta
;
--
-------------------------------------------------------------------------------------------------------------------
--