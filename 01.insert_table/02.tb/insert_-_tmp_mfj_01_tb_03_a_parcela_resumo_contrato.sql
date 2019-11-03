--
-------------------------------------------------------------------------------------------------------------------
--Custo=={35 segundos}
-->Tabela Parcela - FATO:
--{03} = {tmp_mfj_01_tb_03_a_parcela_resumo_contrato}
    /*
        03 = {tmp_mfj_01_tb_03_a_parcela_resumo_contrato}
                {
                    >Tabela Parcela - FATO:
                        [id_contrato] = identificador {origem==tmp_mfj_01_id_02_a_contrato}
                        [atraso] = atraso atual do contrato
                        [menor_vcto] = menor vencto {usado para calculo de atraso}
                        [maior_vcto] = maior vencto {pc - para conhecimento}
                        [maior_dt_vencido] = maior data vencida {usado para identificar vencido e a_vencer}
                        [ult_parc_pg] = numero da ultima parcela paga
                        [menor_parc] = numero da menor parcela aberta
                        [maior_parc] = numero da maior parcela aberta
                        [qtd_parc_ab] = quantidade de parcela aberta {menor_p [menos] maior_p + 1}
                        [menor_vlr_parc] = valor da menor parcela
                        [med_vlr_parc] = media do valor da parcela {caso tenha fluxo irregular - media}
                        [maior_vlr_parc] = valor da maior parcela
                        [vlr_risco_parc] = valor do risco {soma todas as parcelas abertas}
                        [vlr_vencido] = valor da soma das parcelas vencidas {pc - atualizacao}
                        [vlr_a_vencer] = valor da soma das parcelas nao vencidas
                }><m
    */
--
--SELECT * FROM public.tmp_mfj_01_tb_03_a_parcela_resumo_contrato ;
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
    cod_empresa int NOT NULL,
    cod_credor int NOT NULL,
    cod_entid_credor int NOT NULL,
    num_contr varchar(50) NOT NULL,
    dat_ent_contr date NOT NULL
) 
WITH (OIDS=TRUE) ;
CREATE INDEX tmp_idx_tb02_05_idcontr ON tmp_mfj_01_tb_02_a_contrato_basico__01 USING btree (id_contrato) ;
CREATE INDEX tmp_idx_tb02_13_dtentcontr ON tmp_mfj_01_tb_02_a_contrato_basico__01 
(cod_empresa, cod_credor, cod_entid_credor, num_contr, dat_ent_contr) ;
CREATE INDEX tmp_idx_tb02_33_dtentcontr ON tmp_mfj_01_tb_02_a_contrato_basico__01 (cod_credor, cod_entid_credor) ;
CREATE INDEX tmp_pkey_02_tb02_contrato ON tmp_mfj_01_tb_02_a_contrato_basico__01 
(num_contr, cod_empresa, cod_credor, cod_entid_credor) ;
CREATE INDEX tmp_idx_tb02_07_numcontr ON tmp_mfj_01_tb_02_a_contrato_basico__01 USING btree (num_contr) ;
CREATE INDEX tmp_idx_tb02_09_dtentcontr ON tmp_mfj_01_tb_02_a_contrato_basico__01 USING btree (dat_ent_contr) ;
CREATE INDEX tmp_idx_tb02_11_numcontr_cred ON tmp_mfj_01_tb_02_a_contrato_basico__01 (num_contr, cod_empresa, cod_credor) ;
-->@FIM_-_Tabela Temporaria Contrato - Fato
--
-->02_Tabela Temporaria Parcela
DROP TABLE IF EXISTS tmp_mfj_01_tb_03_a_parcela_resumo_contrato__02 ;
CREATE TEMPORARY TABLE tmp_mfj_01_tb_03_a_parcela_resumo_contrato__02 
(
    id_contrato int NOT NULL,
    num_prestacao int NOT NULL,
    dat_vencto date NOT NULL,
    vlr_prestacao numeric(15,6) NOT NULL
) 
WITH (OIDS=TRUE) ;
CREATE INDEX tmp_idx_id02_02_idcontr ON tmp_mfj_01_tb_03_a_parcela_resumo_contrato__02 USING btree (id_contrato) ;
CREATE INDEX tmp_idx_id01_01_dtvcto ON tmp_mfj_01_tb_03_a_parcela_resumo_contrato__02 USING btree (dat_vencto) ;
-->@FIM_-_Tabela Temporaria Parcela
--
-->03_Tabela Temporaria Parcela Resumido == tmp02__to__03
DROP TABLE IF EXISTS tmp02__to__03 ;
CREATE TEMPORARY TABLE tmp02__to__03 
(
    id_contrato int PRIMARY KEY,
    atraso int NOT NULL,
    menor_vcto date NOT NULL,
    maior_vcto date NOT NULL,
    maior_dt_vencido date NOT NULL,
    ult_parc_pg int NOT NULL,
    menor_parc int NOT NULL,
    maior_parc int NOT NULL,
    qtd_parc_ab int NOT NULL,
    menor_vlr_parc numeric(15,6) NOT NULL,
    med_vlr_parc numeric(15,6) NOT NULL,
    maior_vlr_parc numeric(15,6) NOT NULL,
    vlr_risco_parc numeric(15,6) NOT NULL,
    vlr_vencido numeric(15,6) NOT NULL,
    vlr_a_vencer numeric(15,6) NOT NULL
) 
WITH (OIDS=TRUE) ;
CREATE INDEX tmp_idx_id02_01_atraso ON tmp02__to__03 USING btree (atraso) ;
-->@FIM_-_Tabela Temporaria Parcela Resumido == tmp02__to__03
--
--INSERIR TABELAS TEMP
--
--01_Tabela Temporaria Contrato {tmp_mfj_01_tb_02_a_contrato_basico__01}
INSERT INTO tmp_mfj_01_tb_02_a_contrato_basico__01
SELECT 
    tmp01.id_contrato,
    tmp01.cod_empresa,
    tmp01.cod_credor,
    tmp01.cod_entid_credor,
    tmp01.num_contr,
    tmp01.dat_ent_contr
FROM public.tmp_mfj_01_tb_02_a_contrato_basico tmp01
WHERE tmp01.flg_status_ctt IN (1,2)
;
--
-->02_Tabela Temporaria Contrato - Fato
INSERT INTO tmp_mfj_01_tb_03_a_parcela_resumo_contrato__02
SELECT
    tmp01.id_contrato,
    tmp02.num_prestacao,
    tmp02.dat_vencto,
    tmp02.vlr_prestacao
FROM public.cob_contr_prest tmp02
JOIN tmp_mfj_01_tb_02_a_contrato_basico__01 tmp01
    ON tmp02.cod_empresa = tmp01.cod_empresa
    AND tmp02.cod_credor = tmp01.cod_credor
    AND tmp02.cod_entid_credor::int = tmp01.cod_entid_credor
    AND tmp02.num_contr = tmp01.num_contr
    AND tmp02.dat_ent_prest = tmp01.dat_ent_contr
WHERE tmp02.flg_prestacao_paga = 'N'
;
--LIMPA -01-
DROP TABLE IF EXISTS tmp_mfj_01_tb_02_a_contrato_basico__01 ;
--
--03_Tabela Temporaria Parcela Resumido == tmp02__to__03
INSERT INTO tmp02__to__03
SELECT
mfj02.id_contrato,
(CURRENT_DATE - mfj02.menor_vcto) AS atraso,
mfj02.menor_vcto,
mfj02.maior_vcto,
mfj02.maior_dt_vencido,
(mfj02.menor_parc-1) AS ult_parc_pg,
mfj02.menor_parc,
mfj02.maior_parc,
mfj02.qtd_parc_ab,
mfj02.menor_vlr_parc,
mfj02.med_vlr_parc,
mfj02.maior_vlr_parc,
mfj02.vlr_risco_parc,
mfj02.vlr_vencido,
(mfj02.vlr_risco_parc - mfj02.vlr_vencido) AS vlr_a_vencer
FROM
(
    SELECT
        tmp02.id_contrato,
        MIN(tmp02.dat_vencto) AS menor_vcto,
        MAX(tmp02.dat_vencto) AS maior_vcto,
        MIN(tmp02.num_prestacao) AS menor_parc,
        MAX(tmp02.num_prestacao) AS maior_parc,
        COUNT(tmp02.num_prestacao) AS qtd_parc_ab,
        AVG(tmp02.vlr_prestacao) AS med_vlr_parc,
        MIN(tmp02.vlr_prestacao) AS menor_vlr_parc,
        MAX(tmp02.vlr_prestacao) AS maior_vlr_parc,
        SUM(tmp02.vlr_prestacao) AS vlr_risco_parc,
        SUM(CASE
                WHEN (CURRENT_DATE - tmp02.dat_vencto) >= 1 THEN tmp02.vlr_prestacao
                ELSE 0 
            END) AS vlr_vencido,
        MAX(CASE
                WHEN (CURRENT_DATE - tmp02.dat_vencto) >= 1 THEN tmp02.dat_vencto
                ELSE '1900-01-01' 
            END)::date AS maior_dt_vencido
    FROM tmp_mfj_01_tb_03_a_parcela_resumo_contrato__02 tmp02
    GROUP BY tmp02.id_contrato
) mfj02
;
--LIMPA -02-
DROP TABLE IF EXISTS tmp_mfj_01_tb_03_a_parcela_resumo_contrato__02 ;
--
TRUNCATE TABLE public.tmp_mfj_01_tb_03_a_parcela_resumo_contrato ;
--
INSERT INTO public.tmp_mfj_01_tb_03_a_parcela_resumo_contrato
--
SELECT
    tmp03.id_contrato,
    (CASE
      WHEN tmp03.atraso IS NULL THEN 1
      WHEN tmp03.atraso <=1 THEN 1
      WHEN tmp03.atraso >=1801 THEN 1801
      ELSE tmp03.atraso
    END) AS id_atraso,
    tmp03.atraso,
    tmp03.menor_vcto,
    tmp03.maior_vcto,
    tmp03.maior_dt_vencido,
    tmp03.ult_parc_pg,
    tmp03.menor_parc,
    tmp03.maior_parc,
    tmp03.qtd_parc_ab,
    tmp03.menor_vlr_parc,
    tmp03.med_vlr_parc,
    tmp03.maior_vlr_parc,
    tmp03.vlr_risco_parc,
    tmp03.vlr_vencido,
    tmp03.vlr_a_vencer
FROM tmp02__to__03 tmp03
;
--
DROP TABLE IF EXISTS tmp_dt_atual_fil ;
DROP TABLE IF EXISTS tmp_mfj_01_tb_02_a_contrato_basico__01 ;
DROP TABLE IF EXISTS tmp_mfj_01_tb_03_a_parcela_resumo_contrato__02 ;
DROP TABLE IF EXISTS tmp02__to__03 ;
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