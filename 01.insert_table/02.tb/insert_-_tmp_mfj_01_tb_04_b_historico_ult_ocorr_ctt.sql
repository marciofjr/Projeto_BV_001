--
-------------------------------------------------------------------------------------------------------------------
--Custo=={10 segundos}
-->Tabela Historico Coleta - Ultimo Ocorrencia Contrato - FATO:
--{04}-B = {tmp_mfj_01_tb_04_b_historico_ult_ocorr_ctt}
    /*
        04-B = {tmp_mfj_01_tb_04_b_historico_ult_ocorr_ctt}
                {
                    >Tabela Historico Coleta - Ultimo Ocorrencia Contrato - FATO:
                        [id_historico] = identificador {principal} -- Ultimo ID
                        [id_cod_hst] = identificador {origem==tmp_mfj_01_dp_07_a_codigo_historico}
                        [id_contrato] = identificador {origem==tmp_mfj_01_id_02_a_contrato}
                        [id_cliente] = identificador {origem==tmp_mfj_01_id_01_a_cliente}
                        [dat_data_hist] = numero documento cliente {padraoBD}
                        [d_defasagem] = dias sem acionamento { [hoje] - [dat_data_hist] }
                        [cod_user] = numero documento cliente {padraoBD}
                }><m
    */
--
--SELECT * FROM public.tmp_mfj_01_tb_04_b_historico_ult_ocorr_ctt ;
--Inserir na Base
SET enable_seqscan = OFF;
DISCARD TEMP;
--
-->00_filtro_simplificado
DROP TABLE IF EXISTS tmp_dt_atual_fil ;
CREATE TEMPORARY TABLE tmp_dt_atual_fil
(
    id_filtro int PRIMARY KEY,
    tipo_filtro varchar (50) NOT NULL,
    int_01 int NULL,
    int_02 int NULL,
    int_03 int NULL,
    data_01 date NULL,
    data_02 date NULL,
    data_03 date NULL,
    txt_01 varchar(30) NULL,
    txt_02 varchar(30) NULL,
    txt_03 varchar(30) NULL
) 
WITH (OIDS=TRUE) ;
--
--00_Filtro Simplificado Inserir {tmp_dt_atual_fil}
INSERT INTO tmp_dt_atual_fil
( id_filtro, tipo_filtro, int_01, int_02, int_03, 
    data_01, data_02, data_03, txt_01, txt_02, txt_03 )
VALUES
--{ini}{id==01}
( 
    1, --{id_filtro}
    'DT_Atual{int01=mes}{int02=ano}', --{tipo_filtro}
    (SELECT EXTRACT(MONTH FROM CURRENT_DATE)::int), --{int_01}
    (SELECT EXTRACT(YEAR FROM CURRENT_DATE)::int), --{int_02}
    NULL, --{int_03}
    NULL, --{data_01}
    NULL, --{data_02}
    NULL, --{data_03}
    NULL, --{txt_01}
    NULL, --{txt_02}
    NULL  --{txt_03}
) --{fim}{id==01}
;
--
-->01_Tabela Temporaria Historico ctt ult - Fato
DROP TABLE IF EXISTS tmp_mfj_01_tb_04_a_historico_basico__01 ;
CREATE TEMPORARY TABLE tmp_mfj_01_tb_04_a_historico_basico__01
(
    id_contrato int NOT NULL,
    id_historico int NOT NULL
) 
WITH (OIDS=TRUE) ;
CREATE INDEX tmp_idx_tb04_01_idcontr ON tmp_mfj_01_tb_04_a_historico_basico__01 USING btree (id_contrato) ;
CREATE INDEX tmp_idx_tb04_02_idhst ON tmp_mfj_01_tb_04_a_historico_basico__01 USING btree (id_historico) ;
-->@FIM_-_Tabela Temporaria Historico ctt ult - Fato
--
--INSERIR TABELAS TEMP
--
--01_Tabela Temporaria Contrato {tmp_mfj_01_tb_04_a_historico_basico__01}
INSERT INTO tmp_mfj_01_tb_04_a_historico_basico__01
SELECT 
    tmp01.id_contrato,
    MAX(tmp01.id_historico) AS id_historico
FROM public.tmp_mfj_01_tb_04_a_historico_basico tmp01
GROUP BY tmp01.id_contrato
;
--
--Limpa
TRUNCATE TABLE public.tmp_mfj_01_tb_04_b_historico_ult_ocorr_ctt;
;
--@Fim - limpa
--
INSERT INTO public.tmp_mfj_01_tb_04_b_historico_ult_ocorr_ctt
SELECT
    tmp01.id_historico,
    m_hist.id_cod_hst,
    tmp01.id_contrato,
    m_hist.id_cliente,
    m_hist.dat_data_hist,
    (CURRENT_DATE - m_hist.dat_data_hist::date) AS d_defasagem,
    m_hist.cod_user
FROM tmp_mfj_01_tb_04_a_historico_basico__01 tmp01
JOIN public.tmp_mfj_01_tb_04_a_historico_basico m_hist
    ON tmp01.id_historico = m_hist.id_historico
;
--
DROP TABLE IF EXISTS tmp_dt_atual_fil ;
DROP TABLE IF EXISTS tmp_mfj_01_tb_04_a_historico_basico__01 ;
--
SET SESSION AUTHORIZATION DEFAULT;
RESET ALL;
DEALLOCATE ALL;
CLOSE ALL;
UNLISTEN *;
DISCARD PLANS;
DISCARD SEQUENCES;
DISCARD TEMP
;
--
-------------------------------------------------------------------------------------------------------------------
--