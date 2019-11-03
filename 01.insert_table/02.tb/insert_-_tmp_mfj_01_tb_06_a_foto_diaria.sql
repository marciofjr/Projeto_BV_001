--
-------------------------------------------------------------------------------------------------------------------
--Custo=={18 segundos}
-->Tabela Foto Diaria - FATO:
--{06}-A = {tmp_mfj_01_tb_06_a_foto_diaria}
    /*
        06-A = {tmp_mfj_01_tb_06_a_foto_diaria}
                {
                    >Tabela Foto Diaria - FATO:
                        --:::{Key}:::--
                        [dt_foto] = identificador {data==foto}
                        [id_foto] = identificador {origem==tmp_mfj_01_id_03_a_foto_diaria}
                        [dat_ent_contr] = data entrada do contrato {consta no id_foto --- repetir}
                        --:::{Identificadores}:::--
                        [per_ent_contr] = dias do contrato no escritorio {[hoje] - [dat_ent_contr]}
                        [id_contrato] = identificador {origem==tmp_mfj_01_id_02_a_contrato}
                        [id_cliente] = identificador {origem==tmp_mfj_01_id_01_a_cliente}
                        [id_carteira] = identificador {origem==tmp_mfj_01_dp_01_a_carteira}
                        [id_status_ctt] = identificador {origem==tmp_mfj_01_dp_03_a_ctt_status}
                        [id_fx_flux_estoq] = identificador {origem==tmp_mfj_01_dp_09_b_resumo_fx_entrada_fluxo}
                        [id_atraso] = identificador {origem==tmp_mfj_01_dp_06_a_fx_atraso}
                        [id_historico] = identificador {principal} -- Ultimo ID no dia da Foto
                        --:::{Parcela}:::--
                        [atraso] = atraso atual do contrato {conforme menor parcela vencida - no dia foto}
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
                        --:::{Historico}:::--
                        [id_cod_hst] = identificador {origem==tmp_mfj_01_dp_07_a_codigo_historico}
                        [dat_data_hist] = data da ultima ocorrencia {padraoBD}
                        [d_defasagem] = dias sem acionamento { [hoje] - [dat_data_hist] }
                        [cod_user] = numero documento cliente {padraoBD}
                }><m
    */
--
--SELECT * FROM public.tmp_mfj_01_tb_06_a_foto_diaria ;
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
-->01_Tabela Temporaria Id Contrato - Fato
DROP TABLE IF EXISTS tmp_mfj_01_id_03_a_foto_diaria__01 ;
CREATE TEMPORARY TABLE tmp_mfj_01_id_03_a_foto_diaria__01
(
    id_foto int PRIMARY KEY,
    id_contrato int NOT NULL,
    id_carteira int NOT NULL,
    dat_ent_contr date NOT NULL,
    id_cliente int NOT NULL,
    id_status_ctt int NOT NULL,
    id_fx_flux_estoq int NOT NULL,
    per_ent_contr int NOT NULL
) 
WITH (OIDS=TRUE) ;
--CREATE UNIQUE INDEX pkey_01_id03_id_foto ON tmp_mfj_01_id_03_a_foto_diaria__01 USING btree (id_foto) ;
CREATE UNIQUE INDEX tmp_pkey_02_id03_idctt ON tmp_mfj_01_id_03_a_foto_diaria__01 (id_contrato, id_carteira, dat_ent_contr) ;
CREATE INDEX tmp_idx_id03_01_idft_ctt ON tmp_mfj_01_id_03_a_foto_diaria__01 USING btree (id_foto, id_contrato, id_carteira, dat_ent_contr) ;
CREATE INDEX tmp_idx_id03_02_idctt ON tmp_mfj_01_id_03_a_foto_diaria__01 USING btree (id_contrato) ;
CREATE INDEX tmp_idx_id03_03_idcart ON tmp_mfj_01_id_03_a_foto_diaria__01 USING btree (id_carteira) ;
CREATE INDEX tmp_idx_id03_04_dtctt ON tmp_mfj_01_id_03_a_foto_diaria__01 USING btree (dat_ent_contr) ;
-->@FIM_-_Tabela Temporaria Id Contrato - Fato
--
-->02_Tabela Temporaria Contrato Basico - Fato
DROP TABLE IF EXISTS tmp_mfj_01_tb_02_a_contrato_basico__02 ;
CREATE TEMPORARY TABLE tmp_mfj_01_tb_02_a_contrato_basico__02
(
    id_contrato int PRIMARY KEY,
    id_carteira int NOT NULL,
    dat_ent_contr date NOT NULL,
    id_cliente int NOT NULL,
    id_status_ctt int NOT NULL,
    id_fx_flux_estoq int NOT NULL,
    per_ent_contr int NOT NULL
) WITH (OIDS=TRUE);
--CREATE UNIQUE INDEX pkey_01_tb02_id_contrato ON tmp_mfj_01_tb_02_a_contrato_basico USING btree (id_contrato) ;
CREATE UNIQUE INDEX tmp_pkey_02_tb02_contrato ON tmp_mfj_01_tb_02_a_contrato_basico__02 (id_contrato, id_carteira, dat_ent_contr) ;
CREATE INDEX tmp_idx_tb02_01_idcliente ON tmp_mfj_01_tb_02_a_contrato_basico__02 USING btree (id_cliente) ;
CREATE INDEX tmp_idx_tb02_02_idcarteira ON tmp_mfj_01_tb_02_a_contrato_basico__02 USING btree (id_carteira) ;
CREATE INDEX tmp_idx_tb02_03_idstatus_ctt ON tmp_mfj_01_tb_02_a_contrato_basico__02 USING btree (id_status_ctt) ;
CREATE INDEX tmp_idx_tb02_04_idfx_flux_estoq ON tmp_mfj_01_tb_02_a_contrato_basico__02 USING btree (id_fx_flux_estoq) ;
CREATE INDEX tmp_idx_tb02_05_per_contr ON tmp_mfj_01_tb_02_a_contrato_basico__02 USING btree (per_ent_contr) ;
-->@FIM_-_Tabela Temporaria Contrato Basico - Fato
--
-->03_Tabela Temporaria Parcela Resumo Contrato - Fato
DROP TABLE IF EXISTS tmp_mfj_01_tb_03_a_parcela_resumo_contrato__03 ;
CREATE TEMPORARY TABLE tmp_mfj_01_tb_03_a_parcela_resumo_contrato__03
(
    id_contrato int PRIMARY KEY,
    id_atraso int NOT NULL,
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
) WITH (OIDS=TRUE);
--CREATE UNIQUE INDEX tmp_pkey_01_tb02_id_contrato ON tmp_mfj_01_tb_03_a_parcela_resumo_contrato__03 USING btree (id_contrato) ;
--um salve para galera
-->@FIM_-_Tabela Temporaria Parcela Resumo Contrato - Fato
--
--INSERIR TABELAS TEMP
--
--02_Tabela Temporaria Historico {tmp_mfj_01_tb_02_a_contrato_basico__02}
INSERT INTO tmp_mfj_01_tb_02_a_contrato_basico__02
SELECT 
    tmp02.id_contrato,
    tmp02.id_carteira,
    tmp02.dat_ent_contr,
    tmp02.id_cliente,
    tmp02.id_status_ctt,
    tmp02.id_fx_flux_estoq,
    tmp02.per_ent_contr
FROM public.tmp_mfj_01_tb_02_a_contrato_basico tmp02
WHERE tmp02.flg_status_ctt IN (1,2)
;
--
--01_Tabela Temporaria Contrato {tmp_mfj_01_id_03_a_foto_diaria__01}
INSERT INTO tmp_mfj_01_id_03_a_foto_diaria__01
SELECT 
    tmp01.id_foto,
    tmp01.id_contrato,
    tmp01.id_carteira,
    tmp02.dat_ent_contr,
    tmp02.id_cliente,
    tmp02.id_status_ctt,
    tmp02.id_fx_flux_estoq,
    tmp02.per_ent_contr
FROM public.tmp_mfj_01_id_03_a_foto_diaria tmp01
JOIN tmp_mfj_01_tb_02_a_contrato_basico__02 tmp02
    ON tmp01.id_contrato = tmp02.id_contrato
    AND tmp01.id_carteira = tmp02.id_carteira
    AND tmp01.dat_ent_contr = tmp02.dat_ent_contr
;
--
--03_Tabela Temporaria Parcela Resumo Contrato {tmp_mfj_01_tb_03_a_parcela_resumo_contrato__03}
INSERT INTO tmp_mfj_01_tb_03_a_parcela_resumo_contrato__03
SELECT 
    tmp03.id_contrato,
    tmp03.id_atraso,
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
FROM public.tmp_mfj_01_tb_03_a_parcela_resumo_contrato tmp03
JOIN tmp_mfj_01_tb_02_a_contrato_basico__02 tmp02
    ON tmp03.id_contrato = tmp02.id_contrato
;
--
DROP TABLE IF EXISTS tmp_mfj_01_tb_02_a_contrato_basico__02 ;
--
--Limpa
TRUNCATE TABLE public.tmp_mfj_01_tb_06_a_foto_diaria ;
;
--@Fim - limpa
--
INSERT INTO public.tmp_mfj_01_tb_06_a_foto_diaria
SELECT
    --:::{Key}:::--
    CURRENT_DATE AS dt_foto,
    tmp01.id_foto,
    tmp01.dat_ent_contr,
    --:::{Identificadores}:::--
    tmp01.per_ent_contr,
    tmp01.id_contrato,
    tmp01.id_cliente,
    tmp01.id_carteira,
    tmp01.id_status_ctt,
    tmp01.id_fx_flux_estoq,
    COALESCE(tmp03.id_atraso,0) AS id_atraso,
    COALESCE(m_hst.id_historico,0) AS id_historico,
    --:::{Parcela}:::--
    COALESCE(tmp03.atraso,0) AS atraso,
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
    tmp03.vlr_a_vencer,
    --:::{Historico - Ultimo da Foto}:::--
    COALESCE(m_hst.id_cod_hst,0) AS id_cod_hst,
    m_hst.dat_data_hist,
    m_hst.d_defasagem,
    COALESCE(m_hst.cod_user,0) AS cod_user
FROM tmp_mfj_01_id_03_a_foto_diaria__01 tmp01
--
LEFT JOIN tmp_mfj_01_tb_03_a_parcela_resumo_contrato__03 tmp03
    ON tmp01.id_contrato = tmp03.id_contrato
LEFT JOIN public.tmp_mfj_01_tb_04_b_historico_ult_ocorr_ctt m_hst
    ON tmp01.id_contrato = m_hst.id_contrato
WHERE 
    tmp01.id_foto IS NOT NULL
    AND tmp01.dat_ent_contr IS NOT NULL
    AND tmp01.id_contrato IS NOT NULL
    AND tmp01.id_cliente IS NOT NULL
    AND tmp01.id_carteira IS NOT NULL
    AND NOT EXISTS
    (SELECT 
        m_ft.id_foto
        FROM public.tmp_mfj_01_tb_06_a_foto_diaria m_ft
        WHERE 
            (CURRENT_DATE) = m_ft.dt_foto
            AND tmp01.id_foto = m_ft.id_foto
                AND tmp01.dat_ent_contr = m_ft.dat_ent_contr
    )
;
--
DROP TABLE IF EXISTS tmp_dt_atual_fil ;
DROP TABLE IF EXISTS tmp_mfj_01_id_03_a_foto_diaria__01 ;
DROP TABLE IF EXISTS tmp_mfj_01_tb_02_a_contrato_basico__02 ;
DROP TABLE IF EXISTS tmp_mfj_01_tb_03_a_parcela_resumo_contrato__03 ;
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