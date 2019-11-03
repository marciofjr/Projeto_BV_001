--
-------------------------------------------------------------------------------------------------------------------
--
-->Identificador Cliente:
--{01} = {tmp_mfj_01_id_01_a_cliente}
    /*
        01 = {tmp_mfj_01_id_01_a_cliente}
                {
                    >Identificador Cliente:
                        [id_cliente] = identificador Cliente
                        [cod_empresa] = codigo empresa {padraoBD}
                        [num_cpf_cnpj] = numero documento cliente {padraoBD}
                }><m
id_cliente int DEFAULT NEXTVAL('tmp_mfj_01_id_01_a_cliente_seq') PRIMARY KEY,
cod_empresa int NOT NULL,
num_cpf_cnpj numeric(17) NOT NULL
    */
--
--SELECT * FROM public.tmp_mfj_01_id_01_a_cliente;
--Ajusta a Sequencia de ID:::
SELECT 
    SETVAL('public.tmp_mfj_01_id_01_a_cliente_seq', 
        (
            SELECT 
                COALESCE(MAX(m_id.id_cliente),1) m_id_m 
            FROM public.tmp_mfj_01_id_01_a_cliente m_id
        ), 
        TRUE);
--Inserir na Base
INSERT INTO public.tmp_mfj_01_id_01_a_cliente
SELECT
    nextval('public.tmp_mfj_01_id_01_a_cliente_seq') AS id_cliente,
    m_coleta.cod_empresa,
    m_coleta.num_cpf_cnpj
FROM(
    SELECT 
        m_sys.cod_empresa, 
        m_sys.num_cpf_cnpj
    FROM public.cob_cliente m_sys
    WHERE NOT EXISTS
        ( 
            SELECT 
                m_ft.id_cliente 
            FROM public.tmp_mfj_01_id_01_a_cliente m_ft
            WHERE m_sys.num_cpf_cnpj = m_ft.num_cpf_cnpj
                AND m_sys.cod_empresa = m_ft.cod_empresa 
        ) 
) m_coleta
;
--
-------------------------------------------------------------------------------------------------------------------
--