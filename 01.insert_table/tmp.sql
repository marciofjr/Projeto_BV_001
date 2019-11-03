
SELECT * FROM public.cob_contr;

--
-------------------------------------------------------------------------------------------------------------------
--Custo=={110 segundos}
-->Tabela Contrato - FATO BASICO:
--{02} = {tmp_mfj_01_tb_02_a_contrato_basico}
    /*
        02 = {tmp_mfj_01_tb_02_a_contrato_basico}
                {
                    >Tabela Contrato - FATO BASICO:
                        [id_contrato] = identificador {origem==tmp_mfj_01_id_02_a_contrato}
                        [id_cliente] = identificador {origem==tmp_mfj_01_id_01_a_cliente}
                        [id_carteira] = identificador {origem==tmp_mfj_01_dp_01_a_carteira}
                        [id_status_ctt] = identificador {origem==tmp_mfj_01_dp_03_a_ctt_status}
                        [id_fx_flux_estoq] = identificador {origem==tmp_mfj_01_dp_09_b_resumo_fx_entrada_fluxo}
                        [cod_empresa] = codigo empresa {padraoBD}
                        [cod_credor] = codigo credor {padraoBD}
                        [cod_entid_credor] = codigo entidade {padraoBD}
                        [num_contr] = numero de contrato {padraoBD}
                        [num_cpf_cnpj] = numero documento cliente {padraoBD}
                        [dat_ent_contr] = data entrada do contrato {importante para filtro parcela}
                        [per_ent_contr] = dias do contrato no escritorio {[hoje] - [dat_ent_contr]}
                        [cod_pos_contr] = codigo posicao contrato
                        [flg_status_ctt] = flag status {0:Inativo, 1:Ativo, 2:Suspenso}
                }><m
    */
--
--SELECT * FROM public.tmp_mfj_01_tb_02_a_contrato_basico;
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
    id_contrato int NOT NULL,
    cod_empresa int NOT NULL,
    cod_credor int NOT NULL,
    cod_entid_credor int NOT NULL,
    num_contr varchar(50) NOT NULL,
    num_cpf_cnpj numeric(17) NOT NULL,
    dat_ent_contr date NOT NULL,
    ent_mes int NOT NULL,
    ent_ano int NOT NULL,
    id_entrada int NOT NULL,
    per_ent_contr int NOT NULL,
    cod_posicao_contr char(1) NOT NULL
) 
WITH (OIDS=TRUE) ;
CREATE INDEX tmp_pkey_02_tb02_contrato ON tmp_mfj_01_tb_02_a_contrato_basico__01 
(num_contr, cod_empresa, cod_credor, cod_entid_credor) ;
CREATE INDEX tmp_idx_tb02_04_identr ON tmp_mfj_01_tb_02_a_contrato_basico__01 USING btree (id_entrada) ;
CREATE INDEX tmp_idx_tb02_05_idcontr ON tmp_mfj_01_tb_02_a_contrato_basico__01 USING btree (id_contrato) ;
CREATE INDEX tmp_idx_tb02_07_numcontr ON tmp_mfj_01_tb_02_a_contrato_basico__01 USING btree (num_contr) ;
CREATE INDEX tmp_idx_tb02_08_cpfcnpj ON tmp_mfj_01_tb_02_a_contrato_basico__01 USING btree (num_cpf_cnpj) ;
CREATE INDEX tmp_idx_tb02_09_dtentcontr ON tmp_mfj_01_tb_02_a_contrato_basico__01 USING btree (dat_ent_contr) ;
CREATE INDEX tmp_idx_tb02_10_poscontr ON tmp_mfj_01_tb_02_a_contrato_basico__01 USING btree (cod_posicao_contr) ;
CREATE INDEX tmp_idx_tb02_11_numcontr_cred ON tmp_mfj_01_tb_02_a_contrato_basico__01 (num_contr, cod_empresa, cod_credor) ;
CREATE INDEX tmp_idx_tb02_12_emp_cpfcnpj ON tmp_mfj_01_tb_02_a_contrato_basico__01 (num_cpf_cnpj, cod_empresa) ;
CREATE INDEX tmp_idx_tb02_13_dtentcontr ON tmp_mfj_01_tb_02_a_contrato_basico__01 
(cod_empresa, cod_credor, cod_entid_credor, num_contr, dat_ent_contr);
CREATE INDEX tmp_idx_tb02_33_dtentcontr ON tmp_mfj_01_tb_02_a_contrato_basico__01 (cod_credor,cod_entid_credor) ;
-->@FIM_-_Tabela Temporaria Contrato - Fato
--
-->02_Tabela Temporaria ID Cliente
DROP TABLE IF EXISTS tmp_mfj_01_id_01_a_cliente__02 ;
CREATE TEMPORARY TABLE tmp_mfj_01_id_01_a_cliente__02 
(
    id_cliente int PRIMARY KEY,
    cod_empresa int NOT NULL,
    num_cpf_cnpj numeric(17) NOT NULL
) 
WITH (OIDS=TRUE) ;
CREATE INDEX tmp_pkey_02_id01_num_cpf_cnpj ON tmp_mfj_01_id_01_a_cliente__02 (num_cpf_cnpj, cod_empresa) ;
CREATE INDEX tmp_idx_id01_01_cpfcnpj ON tmp_mfj_01_id_01_a_cliente__02 USING btree (num_cpf_cnpj) ;
-->@FIM_-_Tabela Temporaria ID Cliente
--
-->03_Tabela Temporaria ID Contrato
DROP TABLE IF EXISTS tmp_mfj_01_id_02_a_contrato__03 ;
CREATE TEMPORARY TABLE tmp_mfj_01_id_02_a_contrato__03 
(
    id_contrato int PRIMARY KEY,
    cod_empresa int NOT NULL,
    cod_credor int NOT NULL,
    cod_entid_credor int NOT NULL,
    num_contr varchar(50) NOT NULL
) 
WITH (OIDS=TRUE) ;
CREATE INDEX tmp_pkey_02_id02_ctt ON tmp_mfj_01_id_02_a_contrato__03 (num_contr, cod_empresa, cod_credor, cod_entid_credor) ;
CREATE INDEX tmp_idx_id02_01_numcontr ON tmp_mfj_01_id_02_a_contrato__03 USING btree (num_contr) ;
-->@FIM_-_Tabela Temporaria ID Contrato
--
-->04_Tabela Temporaria ID Carteira
DROP TABLE IF EXISTS tmp_mfj_01_dp_01_a_carteira__04 ;
CREATE TEMPORARY TABLE tmp_mfj_01_dp_01_a_carteira__04 
(
    id_carteira int PRIMARY KEY,
    cod_credor int NOT NULL,
    cod_entid_credor int NOT NULL,
    carteira_nome varchar(30) NOT NULL
) 
WITH (OIDS=TRUE) ;
CREATE INDEX tmp_idx_dp01_01_credor_entid ON tmp_mfj_01_dp_01_a_carteira__04 (cod_credor,cod_entid_credor) ;
-->@FIM_-_Tabela Temporaria ID Carteira
--
-->05_Tabela Temporaria ID Status Contrato
DROP TABLE IF EXISTS tmp_mfj_01_dp_03_a_ctt_status__05 ;
CREATE TEMPORARY TABLE tmp_mfj_01_dp_03_a_ctt_status__05
(
    id_status_ctt int PRIMARY KEY,
    cod_empresa int NOT NULL,
    cod_credor int NOT NULL,
    flg_status_ctt int NOT NULL,
    cod_posicao_contr varchar(5) NOT NULL,
    nom_posicao_contr varchar(30) NOT NULL
) WITH (OIDS=TRUE);
CREATE INDEX tmp_pkey_01_dp03_posctt ON tmp_mfj_01_dp_03_a_ctt_status__05 (cod_posicao_contr, cod_empresa, cod_credor) ;
CREATE INDEX tmp_idx_dp03_01_credor ON tmp_mfj_01_dp_03_a_ctt_status__05 USING btree (cod_credor) ;
CREATE INDEX tmp_idx_dp03_02_codpos_ctt ON tmp_mfj_01_dp_03_a_ctt_status__05 USING btree (cod_posicao_contr) ;
-->@FIM_-_05_Tabela Temporaria ID Status Contrato
--
-->06_Tabela Temporaria Fluxo e Estoque {converter==id_fx_flux_estoq}
DROP TABLE IF EXISTS tmp_mfj_01_dp_09_a_fx_entrada_fluxo__06 ;
CREATE TEMPORARY TABLE tmp_mfj_01_dp_09_a_fx_entrada_fluxo__06
(
    id_entrada int PRIMARY KEY,
    id_fx_fluxo int NOT NULL,
    id_fx_estoque int NOT NULL
) WITH (OIDS=TRUE);
CREATE INDEX tmp_idx_dp09_01_idfx_fluxo ON tmp_mfj_01_dp_09_a_fx_entrada_fluxo__06 USING btree (id_fx_fluxo) ;
CREATE INDEX tmp_idx_dp09_02_idfx_estoque ON tmp_mfj_01_dp_09_a_fx_entrada_fluxo__06 USING btree (id_fx_estoque) ;
-->@FIM_-_06_Tabela Temporaria Fluxo e Estoque
--
--INSERIR TABELAS TEMP
--
--03_Tabela Temporaria ID Contrato {tmp_mfj_01_id_02_a_contrato__03}
INSERT INTO tmp_mfj_01_id_02_a_contrato__03
SELECT 
    tmp03.id_contrato,
    tmp03.cod_empresa,
    tmp03.cod_credor,
    tmp03.cod_entid_credor,
    tmp03.num_contr
FROM public.tmp_mfj_01_id_02_a_contrato tmp03
;
--
-->01_Tabela Temporaria Contrato - Fato
INSERT INTO tmp_mfj_01_tb_02_a_contrato_basico__01
SELECT
    mfj02.id_contrato,
    mfj02.cod_empresa,
    mfj02.cod_credor,
    mfj02.cod_entid_credor,
    mfj02.num_contr,
    mfj02.num_cpf_cnpj,
    mfj02.dat_ent_contr,
    mfj02.ent_mes,
    mfj02.ent_ano,
    (
    CASE
        WHEN mfj02.per_ent_contr <= 1 THEN 1
        WHEN mfj02.per_ent_contr > 999 THEN 14
        WHEN mfj02.per_ent_contr IS NULL THEN 1
        ELSE mfj02.per_ent_contr 
    END) AS id_entrada,
    COALESCE(mfj02.per_ent_contr,0) AS per_ent_contr,
    mfj02.cod_posicao_contr
FROM
(
    SELECT 
        tmp03.id_contrato,
        tmp01.cod_empresa,
        tmp01.cod_credor,
        tmp01.cod_entid_credor::int,
        tmp01.num_contr,
        tmp01.num_cpf_cnpj,
        tmp01.dat_ent_contr,
        EXTRACT(MONTH FROM tmp01.dat_ent_contr) AS ent_mes,
        EXTRACT(YEAR FROM tmp01.dat_ent_contr) AS ent_ano,
        (CURRENT_DATE - tmp01.dat_ent_contr) AS per_ent_contr,
        tmp01.cod_pos_contr AS cod_posicao_contr
    FROM public.cob_contr tmp01
    JOIN tmp_mfj_01_id_02_a_contrato__03 tmp03
        ON tmp01.num_contr = tmp03.num_contr
        AND tmp01.cod_empresa = tmp03.cod_empresa
        AND tmp01.cod_credor = tmp03.cod_credor
        AND tmp01.cod_entid_credor::int = tmp03.cod_entid_credor
) mfj02
;
--
-->02_Tabela Temporaria ID Cliente
INSERT INTO tmp_mfj_01_id_01_a_cliente__02
SELECT
    tmp02.id_cliente,
    tmp02.cod_empresa,
    tmp02.num_cpf_cnpj
FROM public.tmp_mfj_01_id_01_a_cliente tmp02
;
--
-->04_Tabela Temporaria ID Carteira
INSERT INTO tmp_mfj_01_dp_01_a_carteira__04
SELECT
    tmp04.id_carteira,
    tmp04.cod_credor,
    tmp04.cod_entid_credor,
    tmp04.carteira_nome
FROM public.tmp_mfj_01_dp_01_a_carteira tmp04
;
--
-->05_Tabela Temporaria ID Status Contrato
INSERT INTO tmp_mfj_01_dp_03_a_ctt_status__05
SELECT
    tmp05.id_status_ctt,
    tmp05.cod_empresa,
    tmp05.cod_credor,
    tmp05.flg_status_ctt,
    tmp05.cod_posicao_contr,
    tmp05.nom_posicao_contr
FROM public.tmp_mfj_01_dp_03_a_ctt_status tmp05
;
--
-->06_Tabela Temporaria Fluxo e Estoque {converter==id_fx_flux_estoq}
INSERT INTO tmp_mfj_01_dp_09_a_fx_entrada_fluxo__06
SELECT
    tmp06.id_entrada,
    tmp06.id_fx_fluxo,
    tmp06.id_fx_estoque
FROM public.tmp_mfj_01_dp_09_a_fx_entrada_fluxo tmp06
;
--LIMPA -03-
DROP TABLE IF EXISTS tmp_mfj_01_id_02_a_contrato__03 ;
--
TRUNCATE TABLE public.tmp_mfj_01_tb_02_a_contrato_basico ;
--
INSERT INTO public.tmp_mfj_01_tb_02_a_contrato_basico
--
SELECT
        mfj02.id_contrato,
        mfj02.id_cliente,
        mfj02.id_carteira,
        mfj02.id_status_ctt,
        (CASE
          WHEN mfj02.flg_status_ctt = 0 THEN 99
          WHEN mfj02.ent_mes = mfj02.hj_mes
            AND mfj02.ent_ano = mfj02.hj_ano
             THEN tmp06.id_fx_fluxo
          ELSE tmp06.id_fx_estoque
        END) AS id_fx_flux_estoq,
        mfj02.cod_empresa,
        mfj02.cod_credor,
        mfj02.cod_entid_credor,
        mfj02.num_contr,
        mfj02.num_cpf_cnpj,
        mfj02.dat_ent_contr,
        mfj02.per_ent_contr,
        mfj02.cod_posicao_contr,
        mfj02.flg_status_ctt
FROM
(
    SELECT
        tmp01.id_contrato,
        tmp02.id_cliente,
        tmp04.id_carteira,
        tmp05.id_status_ctt,
        tmp01.cod_empresa,
        tmp01.cod_credor,
        tmp01.cod_entid_credor,
        tmp01.num_contr,
        tmp01.num_cpf_cnpj,
        tmp01.dat_ent_contr,
        (SELECT MAX(m_fil.int_01) FROM tmp_dt_atual_fil m_fil WHERE m_fil.id_filtro=1) AS hj_mes,
        (SELECT MAX(m_fil.int_02) FROM tmp_dt_atual_fil m_fil WHERE m_fil.id_filtro=1) AS hj_ano,
        tmp01.ent_mes,
        tmp01.ent_ano,
        tmp01.id_entrada,
        tmp01.per_ent_contr,
        tmp01.cod_posicao_contr,
        tmp05.flg_status_ctt
    FROM tmp_mfj_01_tb_02_a_contrato_basico__01 tmp01 
    JOIN tmp_mfj_01_id_01_a_cliente__02 tmp02
        ON tmp01.num_cpf_cnpj = tmp02.num_cpf_cnpj
        AND tmp01.cod_empresa = tmp02.cod_empresa
    JOIN tmp_mfj_01_dp_01_a_carteira__04 tmp04
        ON tmp01.cod_credor = tmp04.cod_credor
        AND tmp01.cod_entid_credor = tmp04.cod_entid_credor
    JOIN tmp_mfj_01_dp_03_a_ctt_status__05 tmp05
        ON tmp01.cod_posicao_contr = tmp05.cod_posicao_contr
        AND tmp01.cod_empresa = tmp05.cod_empresa
        AND tmp01.cod_credor = tmp05.cod_credor
) mfj02
    JOIN tmp_mfj_01_dp_09_a_fx_entrada_fluxo__06 tmp06
        ON mfj02.id_entrada = tmp06.id_entrada
;
--
DROP TABLE IF EXISTS tmp_dt_atual_fil ;
DROP TABLE IF EXISTS tmp_mfj_01_tb_02_a_contrato_basico__01 ;
DROP TABLE IF EXISTS tmp_mfj_01_id_01_a_cliente__02 ;
DROP TABLE IF EXISTS tmp_mfj_01_id_02_a_contrato__03 ;
DROP TABLE IF EXISTS tmp_mfj_01_dp_01_a_carteira__04 ;
DROP TABLE IF EXISTS tmp_mfj_01_dp_03_a_ctt_status__05 ;
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
