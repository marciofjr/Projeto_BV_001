--
-------------------------------------------------------------------------------------------------------------------
--
-->Identificador Foto Diaria:
--{03}-A = {tmp_mfj_01_id_03_a_foto_diaria}
    /*
        03-A = {tmp_mfj_01_id_03_a_foto_diaria}
                {
                    >Identificador Foto Diaria:
                        [id_foto] = identificador
                        [id_contrato] = identificador {origem==tmp_mfj_01_id_02_a_contrato}
                        [id_carteira] = identificador {origem==tmp_mfj_01_dp_01_a_carteira}
                        [dat_ent_contr] = identificador para alteracao {id_foto}
                }><m
id_foto int DEFAULT NEXTVAL('tmp_mfj_01_id_03_a_foto_diaria_seq') PRIMARY KEY,
id_contrato int NOT NULL,
id_carteira int NOT NULL,
dat_ent_contr date NOT NULL
    */
--
--SELECT * FROM public.tmp_mfj_01_id_03_a_foto_diaria;
--Ajusta a Sequencia de ID:::
SELECT 
    SETVAL('public.tmp_mfj_01_id_03_a_foto_diaria_seq', 
        (
            SELECT 
                COALESCE(MAX(m_id.id_foto),1) m_id_m 
            FROM public.tmp_mfj_01_id_03_a_foto_diaria m_id
        ), 
        TRUE);
--Inserir na Base
INSERT INTO public.tmp_mfj_01_id_03_a_foto_diaria
SELECT
NEXTVAL('public.tmp_mfj_01_id_03_a_foto_diaria_seq') AS id_foto,
m_ctt.id_contrato,
m_ctt.id_carteira,
m_ctt.dat_ent_contr
FROM public.tmp_mfj_01_tb_02_a_contrato_basico m_ctt
WHERE m_ctt.flg_status_ctt IN (1,2)
	AND NOT EXISTS
        ( 
            SELECT 
                m_ft.id_foto 
            FROM public.tmp_mfj_01_id_03_a_foto_diaria m_ft
            WHERE m_ctt.id_contrato = m_ft.id_contrato
                AND m_ctt.id_carteira = m_ft.id_carteira
                AND m_ctt.dat_ent_contr = m_ft.dat_ent_contr
        )
;
--
-------------------------------------------------------------------------------------------------------------------
--