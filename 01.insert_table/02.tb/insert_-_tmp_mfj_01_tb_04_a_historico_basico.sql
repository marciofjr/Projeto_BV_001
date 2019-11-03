--
-------------------------------------------------------------------------------------------------------------------
--Custo=={45 segundos}
-->Tabela Historico Coleta - FATO:
--{04} = {tmp_mfj_01_tb_04_a_historico_basico}
    /*
        04 = {tmp_mfj_01_tb_04_a_historico_basico}
                {
                    >Tabela Historico Coleta - FATO:
                        [id_historico] = identificador {principal}
                        [id_cod_hst] = identificador {origem==tmp_mfj_01_dp_07_a_codigo_historico}
                        [id_contrato] = identificador {origem==tmp_mfj_01_id_02_a_contrato}
                        [id_cliente] = identificador {origem==tmp_mfj_01_id_01_a_cliente}
                        [cod_empresa] = codigo empresa {padraoBD}
                        [cod_credor] = codigo credor {padraoBD}
                        [cod_entid_credor] = codigo entidade {padraoBD}
                        [num_contr] = numero de contrato {padraoBD}
                        [num_cpf_cnpj] = numero documento cliente {padraoBD}
                        [cod_hist] = numero documento cliente {padraoBD}
                        [dat_data_hist] = numero documento cliente {padraoBD}
                        [cod_user] = numero documento cliente {padraoBD}
                }><m
    */
--
--SELECT * FROM public.tmp_mfj_01_tb_04_a_historico_basico ;
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
-->01_Tabela Temporaria Contrato - Fato
DROP TABLE IF EXISTS tmp_mfj_01_tb_02_a_contrato_basico__01 ;
CREATE TEMPORARY TABLE tmp_mfj_01_tb_02_a_contrato_basico__01
(
    id_contrato int PRIMARY KEY,
    id_cliente int NOT NULL,
    cod_empresa int NOT NULL,
    cod_credor int NOT NULL,
    cod_entid_credor int NOT NULL,
    num_contr varchar(50) NOT NULL
) 
WITH (OIDS=TRUE) ;
CREATE INDEX tmp_idx_tb02_05_idcontr ON tmp_mfj_01_tb_02_a_contrato_basico__01 USING btree (id_contrato) ;
CREATE INDEX tmp_idx_tb02_06_idcliente ON tmp_mfj_01_tb_02_a_contrato_basico__01 USING btree (id_cliente) ;
CREATE INDEX tmp_idx_tb02_13_contr ON tmp_mfj_01_tb_02_a_contrato_basico__01 
(cod_empresa, cod_credor, cod_entid_credor, num_contr) ;
CREATE INDEX tmp_pkey_02_tb02_contrato ON tmp_mfj_01_tb_02_a_contrato_basico__01 
(num_contr, cod_empresa, cod_credor, cod_entid_credor) ;
CREATE INDEX tmp_idx_tb02_33_entid ON tmp_mfj_01_tb_02_a_contrato_basico__01 (cod_empresa, cod_credor, cod_entid_credor) ;
CREATE INDEX tmp_idx_tb02_07_numcontr ON tmp_mfj_01_tb_02_a_contrato_basico__01 USING btree (num_contr) ;
CREATE INDEX tmp_idx_tb02_11_numcontr_cred ON tmp_mfj_01_tb_02_a_contrato_basico__01 (num_contr, cod_empresa, cod_credor) ;
-->@FIM_-_Tabela Temporaria Contrato - Fato
--
-->02_Tabela Temporaria Historico
DROP TABLE IF EXISTS tmp_mfj_01_tb_04_a_historico_basico__02 ;
CREATE TEMPORARY TABLE tmp_mfj_01_tb_04_a_historico_basico__02 
(
    id_historico int PRIMARY KEY,
    cod_empresa int NOT NULL,
    cod_credor int NOT NULL,
    cod_entid_credor int NOT NULL,
    num_contr varchar(50) NOT NULL,
    num_cpf_cnpj numeric(17) NOT NULL,
    cod_hist int NOT NULL,
    dat_data_hist timestamp NOT NULL,
    cod_user int NOT NULL
) 
WITH (OIDS=TRUE) ;
CREATE INDEX tmp_idx_tb04_04_numcontr ON tmp_mfj_01_tb_04_a_historico_basico__02 USING btree (num_contr) ;
CREATE INDEX tmp_idx_tb04_05_cpfcnpj ON tmp_mfj_01_tb_04_a_historico_basico__02 USING btree (num_cpf_cnpj) ;
CREATE INDEX tmp_idx_tb04_06_codhist ON tmp_mfj_01_tb_04_a_historico_basico__02 USING btree (cod_hist) ;
CREATE INDEX tmp_idx_tb04_07_dthist ON tmp_mfj_01_tb_04_a_historico_basico__02 USING btree (dat_data_hist) ;
CREATE INDEX tmp_idx_tb04_08_coduser ON tmp_mfj_01_tb_04_a_historico_basico__02 USING btree (cod_user) ;
CREATE INDEX tmp_idx_tb04_08_codentid ON tmp_mfj_01_tb_04_a_historico_basico__02 USING btree (cod_entid_credor) ;
CREATE INDEX tmp_idx_tb04_09_emp_cpfcnpj ON tmp_mfj_01_tb_04_a_historico_basico__02 (num_cpf_cnpj, cod_empresa) ;
CREATE INDEX tmp_idx_tb04_10_numcontr_ent ON tmp_mfj_01_tb_04_a_historico_basico__02 
(num_contr, cod_empresa, cod_credor, cod_entid_credor) ;
CREATE INDEX tmp_pkey_tb04_dp07_id_cod_hst ON tmp_mfj_01_tb_04_a_historico_basico__02 (cod_hist, cod_empresa, cod_credor) ;
CREATE INDEX tmp_idx_tb04_11_numcontr_cred ON tmp_mfj_01_tb_04_a_historico_basico__02 (num_contr, cod_empresa, cod_credor) ;
-->@FIM_-_Tabela Temporaria Historico
--
-->03_Tabela Temporaria Codigo Historico
DROP TABLE IF EXISTS tmp_mfj_01_dp_07_a_codigo_historico__03 ;
CREATE TEMPORARY TABLE tmp_mfj_01_dp_07_a_codigo_historico__03 
(
    id_cod_hst int PRIMARY KEY,
    cod_empresa int NOT NULL,
    cod_credor int NOT NULL,
    cod_hist int NOT NULL
) 
WITH (OIDS=TRUE) ;
CREATE INDEX tmp_pkey_02_dp07_id_cod_hst ON tmp_mfj_01_dp_07_a_codigo_historico__03 (cod_hist, cod_empresa, cod_credor) ;
CREATE INDEX tmp_idx_dp07_01_codhst ON tmp_mfj_01_dp_07_a_codigo_historico__03 USING btree (cod_hist) ;
-->@FIM_-_Tabela Temporaria Codigo Historico
--
--INSERIR TABELAS TEMP
--
--01_Tabela Temporaria Contrato {tmp_mfj_01_tb_02_a_contrato_basico__01}
INSERT INTO tmp_mfj_01_tb_02_a_contrato_basico__01
SELECT 
    tmp01.id_contrato,
    tmp01.id_cliente,
    tmp01.cod_empresa,
    tmp01.cod_credor,
    tmp01.cod_entid_credor,
    tmp01.num_contr
FROM public.tmp_mfj_01_tb_02_a_contrato_basico tmp01
;
--03_Tabela Temporaria Codigo Historico {tmp_mfj_01_dp_07_a_codigo_historico__03}
INSERT INTO tmp_mfj_01_dp_07_a_codigo_historico__03
SELECT 
    tmp03.id_cod_hst,
    tmp03.cod_empresa,
    tmp03.cod_credor,
    tmp03.cod_hist
FROM public.tmp_mfj_01_dp_07_a_codigo_historico tmp03
;
--
--Limpa Historico dos ultimos 2 dias + Hoje {03 dias totais}
DELETE
    FROM public.tmp_mfj_01_tb_04_a_historico_basico mdel
    WHERE mdel.dat_data_hist >= DATE_TRUNC('DAY', (CURRENT_DATE-2)::TIMESTAMP)
;
--@FIM _-_ Limpa Historico dos ultimos 2 dias + Hoje {3 dias totais}
--
INSERT INTO tmp_mfj_01_tb_04_a_historico_basico__02
SELECT
-- identificadores:::
tmp02.idt_hist AS id_historico,
tmp02.cod_empresa,
tmp02.cod_credor,
tmp02.cod_entid_credor::int,
tmp02.num_contr,
tmp02.num_cpf_cnpj,
-- hst info:::
tmp02.cod_hist::int,
tmp02.dat_data_hist::timestamp,
tmp02.cod_user
FROM public.cob_contr_hist tmp02
WHERE tmp02.idt_hist > 
    (SELECT 
        COALESCE(
            MAX(mft.id_historico),
                (SELECT 
                    COALESCE(MIN(sys_hst.idt_hist),0) AS idt_hist
                    FROM public.cob_contr_hist sys_hst
                    WHERE sys_hst.dat_data_hist BETWEEN DATE_TRUNC('YEAR', CURRENT_DATE-30) 
                        AND DATE_TRUNC('YEAR', CURRENT_DATE-30) + INTERVAL '3 day'
                )
                ) AS idt_hist 
            FROM public.tmp_mfj_01_tb_04_a_historico_basico 
    mft)
    AND tmp02.dat_data_hist 
        BETWEEN DATE_TRUNC('YEAR', CURRENT_DATE-30) 
            AND DATE_TRUNC('MINUTE', CURRENT_DATE+2)
    AND (tmp02.cod_hist ~ '^[0-9]+$') = '1'
    AND tmp02.cod_entid_credor IS NOT NULL
;
--
--TABLE public.tmp_mfj_01_tb_04_a_historico_basico ;
--
INSERT INTO public.tmp_mfj_01_tb_04_a_historico_basico
SELECT
    mfj02.*
FROM
(
SELECT
    -- identificadores:::
    tmp02.id_historico,
    COALESCE(tmp03.id_cod_hst,0) AS id_cod_hst,
    tmp01.id_contrato,
    tmp01.id_cliente,
    -- hst info:::
    tmp02.cod_empresa,
    tmp02.cod_credor,
    tmp02.cod_entid_credor,
    tmp02.num_contr,
    tmp02.num_cpf_cnpj,
    -- hst info2:::
    tmp02.cod_hist,
    tmp02.dat_data_hist,
    tmp02.cod_user
FROM tmp_mfj_01_tb_04_a_historico_basico__02 tmp02
JOIN tmp_mfj_01_tb_02_a_contrato_basico__01 tmp01
    ON tmp02.num_contr = tmp01.num_contr
    AND tmp02.cod_empresa = tmp01.cod_empresa
    AND tmp02.cod_credor = tmp01.cod_credor
    AND tmp02.cod_entid_credor = tmp01.cod_entid_credor
LEFT JOIN tmp_mfj_01_dp_07_a_codigo_historico__03 tmp03
    ON tmp02.cod_hist = tmp03.cod_hist
    AND tmp02.cod_empresa = tmp03.cod_empresa
    AND tmp02.cod_credor = tmp03.cod_credor
) mfj02
    WHERE mfj02.id_cod_hst <> 0
;
--
DROP TABLE IF EXISTS tmp_dt_atual_fil ;
DROP TABLE IF EXISTS tmp_mfj_01_tb_02_a_contrato_basico__01 ;
DROP TABLE IF EXISTS tmp_mfj_01_tb_04_a_historico_basico__02 ;
DROP TABLE IF EXISTS tmp_mfj_01_dp_07_a_codigo_historico__03 ;
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