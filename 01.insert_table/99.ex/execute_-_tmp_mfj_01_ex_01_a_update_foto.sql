--
-------------------------------------------------------------------------------------------------------------------
--Custo Total Execucao=={286 segundos} {01/11/2019}
-->Atualizacao Tabela Fato e Foto {Principal Atualizacao}:
--{01}-A = {tmp_mfj_01_ex_01_a_update_foto}
    /*
        01-A = {tmp_mfj_01_ex_01_a_update_foto}
                {
                    >Atualizacao Tabela Fato e Foto {Principal Atualizacao}:
                        [id]_[01-A] = {tmp_mfj_01_id_01_a_cliente}
                        [id]_[02-A] = {tmp_mfj_01_id_02_a_contrato}
                        [tb]_[01-A] = {tmp_mfj_01_tb_01_a_cliente}
                        [tb]_[02-A] = {tmp_mfj_01_tb_02_a_contrato_basico}
                        [tb]_[03-A] = {tmp_mfj_01_tb_03_a_parcela_resumo_contrato}
                        [tb]_[04-A] = {tmp_mfj_01_tb_04_a_historico_basico}
                        [tb]_[04-B] = {tmp_mfj_01_tb_04_b_historico_ult_ocorr_ctt}
                        [tb]_[05-A] = {tmp_mfj_01_tb_05_a_boleto_basico}
                        [id]_[03-A] = {tmp_mfj_01_id_03_a_foto_diaria}
                }><m
    */
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
--
-------------------------------------------------------------------------------------------------------------------
--
-->Tabela Cliente:
--{01} = {tmp_mfj_01_tb_01_a_cliente}
    /*
        01 = {tmp_mfj_01_tb_01_a_cliente}
                {
                    >Tabela Cliente - FATO:
                        [id_cliente] = identificador {origem==tmp_mfj_01_id_01_a_cliente}
                        [cod_empresa] = codigo empresa {padraoBD}
                        [num_cpf_cnpj] = numero documento cliente {padraoBD}
                        [cod_cliente] = codigo cliente {nao funciona na pratica}
                        [dat_nasc] = data de nascimento
                        [dat_digitacao] = data de cadastro
                        [uf] = uf, estado do cliente
                        [nom_munic] = nome da cidade
                        [nom_cliente] = nome do cliente
                }><m
    */
--
--SELECT * FROM public.tmp_mfj_01_tb_01_a_cliente;
--Inserir na Base
SET enable_seqscan = OFF;
DISCARD TEMP;
-->01_Tabela Temporaria Cliente - Fato
DROP TABLE IF EXISTS tmp_mfj_01_tb_01_a_cliente__01 ;
CREATE TEMPORARY TABLE tmp_mfj_01_tb_01_a_cliente__01
(
    cod_empresa int NOT NULL,
    num_cpf_cnpj numeric(17) NOT NULL,
    cod_cliente int NOT NULL,
    id_idade int NOT NULL,
    dat_nasc date NOT NULL,
    dat_digitacao date NOT NULL,
    uf char(2) NOT NULL,
    nom_munic varchar(60) NOT NULL,
    nom_cliente varchar(100) NOT NULL
) 
WITH (OIDS=TRUE) ;
CREATE UNIQUE INDEX tmp_pkey_02_tb01_cliente ON tmp_mfj_01_tb_01_a_cliente__01 (num_cpf_cnpj, cod_empresa) ;
CREATE INDEX tmp_idx_tb01_02_cpfcnpj ON tmp_mfj_01_tb_01_a_cliente__01 USING btree (num_cpf_cnpj) ;
-->@FIM_-_Tabela Temporaria Cliente - Fato
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
CREATE UNIQUE INDEX tmp_pkey_02_id01_num_cpf_cnpj ON tmp_mfj_01_id_01_a_cliente__02 (num_cpf_cnpj, cod_empresa) ;
CREATE INDEX tmp_idx_id01_01_cpfcnpj ON tmp_mfj_01_id_01_a_cliente__02 USING btree (num_cpf_cnpj) ;
-->@FIM_-_Tabela Temporaria ID Cliente
--
-->03_Tabela Temporaria REGIAO
DROP TABLE IF EXISTS tmp_mfj_01_dp_04_a_uf_regiao__03 ;
CREATE TEMPORARY TABLE tmp_mfj_01_dp_04_a_uf_regiao__03 
(
    id_uf int PRIMARY KEY,
    desc_uf varchar(30) NOT NULL,
    cod_uf varchar(2) NOT NULL,
    id_regiao int NOT NULL,
    desc_regiao varchar(30) NOT NULL
)
WITH (OIDS=TRUE) ;
CREATE UNIQUE INDEX tmp_pkey_02_dp04_uf ON tmp_mfj_01_dp_04_a_uf_regiao__03 USING btree (cod_uf) ;
CREATE INDEX tmp_idx_dp04_01_regiao ON tmp_mfj_01_dp_04_a_uf_regiao__03 USING btree (id_regiao) ;
-->@FIM_-_Tabela Temporaria REGIAO
--01_Tabela_CLIENTE
INSERT INTO tmp_mfj_01_tb_01_a_cliente__01
SELECT 
    m_sys.cod_empresa,
    m_sys.num_cpf_cnpj,
    m_sys.cod_cliente,
    EXTRACT(YEAR FROM AGE(NOW()::date, m_sys.dat_nasc))::int AS id_idade,
    m_sys.dat_nasc,
    m_sys.dat_digitacao::date,
    m_sys.sgl_uf AS uf,
    m_sys.nom_munic,
    m_sys.nom_cliente
FROM public.cob_cliente m_sys 
;
--02_ID_CLIENTE
INSERT INTO tmp_mfj_01_id_01_a_cliente__02
SELECT 
    m_idcli.id_cliente,
    m_idcli.cod_empresa,
    m_idcli.num_cpf_cnpj
FROM public.tmp_mfj_01_id_01_a_cliente m_idcli
;
--03_REGIAO
INSERT INTO tmp_mfj_01_dp_04_a_uf_regiao__03
SELECT 
    m_coduf.id_uf,
    m_coduf.desc_uf,
    m_coduf.cod_uf,
    m_coduf.id_regiao,
    m_coduf.desc_regiao
FROM public.tmp_mfj_01_dp_04_a_uf_regiao m_coduf
;
--
TRUNCATE TABLE public.tmp_mfj_01_tb_01_a_cliente ;
--
INSERT INTO public.tmp_mfj_01_tb_01_a_cliente
SELECT 
    m_idcli.id_cliente,
    COALESCE(m_coduf.id_uf, 99) AS id_uf,
    (
        CASE
            WHEN m_sys.id_idade BETWEEN 1 AND 150 THEN m_sys.id_idade
    	ELSE 1 
        END
    ) AS id_idade,
    m_sys.cod_empresa,
    m_sys.num_cpf_cnpj,
    m_sys.cod_cliente,
    m_sys.dat_nasc,
    m_sys.dat_digitacao,
    COALESCE(m_coduf.cod_uf, 'SS') AS uf,
    m_sys.nom_munic,
    m_sys.nom_cliente
FROM tmp_mfj_01_tb_01_a_cliente__01 m_sys 
JOIN tmp_mfj_01_id_01_a_cliente__02 m_idcli
    ON m_sys.num_cpf_cnpj = m_idcli.num_cpf_cnpj
    AND m_sys.cod_empresa = m_idcli.cod_empresa
LEFT JOIN tmp_mfj_01_dp_04_a_uf_regiao__03 m_coduf
    ON m_sys.uf = m_coduf.cod_uf
;
--
DROP TABLE IF EXISTS tmp_mfj_01_tb_01_a_cliente__01 ;
DROP TABLE IF EXISTS tmp_mfj_01_id_01_a_cliente__02 ;
DROP TABLE IF EXISTS tmp_mfj_01_dp_04_a_uf_regiao__03 ;
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
DROP TABLE IF EXISTS tmp_mfj_01_dp_09_a_fx_entrada_fluxo__06 ;
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
--
-------------------------------------------------------------------------------------------------------------------
--Custo=={25 segundos}
-->Tabela Boleto Coleta - FATO:
--{05}-A = {tmp_mfj_01_tb_05_a_boleto_basico}
    /*
        05-A = {tmp_mfj_01_tb_05_a_boleto_basico}
                {
                    >Tabela Boleto Coleta - FATO:
                        [id_contrato] = identificador {origem==tmp_mfj_01_id_02_a_contrato}
                        [id_cliente] = identificador {origem==tmp_mfj_01_id_01_a_cliente}
                        [cod_empresa] = codigo empresa {padraoBD}
                        [cod_credor] = codigo credor {padraoBD}
                        [cod_entid_credor] = codigo entidade {padraoBD}
                        [num_contr] = numero de contrato {padraoBD}
                        [num_cpf_cnpj] = numero documento cliente {padraoBD}
                        [cod_operador] = operador identificacao
                        [cod_controle_boleto] = {0==Aberto, 1==Cancelado, 2==Baixado Manual, 3==Baixado Lote}
                        [dat_emissao_boleto] = data emissao boleto
                        [dat_vencto_boleto] = data vencto boleto
                        [dat_pagamento] = data pagamento boleto
                        [vlr_boleto] = valor do boleto
                        [vlr_pago] = valor do pagamento do boleto
                }><m
    */
--
--SELECT * FROM public.tmp_mfj_01_tb_05_a_boleto_basico ;
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
CREATE INDEX tmp_idx_tb02_02_idcli ON tmp_mfj_01_tb_02_a_contrato_basico__01 USING btree (id_cliente) ;
CREATE INDEX tmp_idx_tb02_03_dtentcontr ON tmp_mfj_01_tb_02_a_contrato_basico__01 (cod_credor, cod_entid_credor) ;
CREATE INDEX tmp_pkey_01_tb02_contrato ON tmp_mfj_01_tb_02_a_contrato_basico__01 
(num_contr, cod_empresa, cod_credor, cod_entid_credor) ;
CREATE INDEX tmp_idx_tb02_04_numcontr ON tmp_mfj_01_tb_02_a_contrato_basico__01 USING btree (num_contr) ;
CREATE INDEX tmp_idx_tb02_05_numcontr_cred ON tmp_mfj_01_tb_02_a_contrato_basico__01 (num_contr, cod_empresa, cod_credor) ;
-->@FIM_-_Tabela Temporaria Contrato - Fato
--
-->02_Tabela Temporaria Boleto - Fato
DROP TABLE IF EXISTS tmp_mfj_01_tb_05_a_boleto_basico__02 ;
CREATE TEMPORARY TABLE tmp_mfj_01_tb_05_a_boleto_basico__02
(
    cod_empresa int NOT NULL,
    cod_credor int NOT NULL,
    cod_entid_credor int NOT NULL,
    num_contr varchar(50) NOT NULL,
    num_cpf_cnpj numeric(17) NOT NULL,
    cod_operador int NOT NULL,
    cod_controle_boleto int NOT NULL,
    dat_emissao_boleto date NOT NULL,
    dat_vencto_boleto date NOT NULL,
    dat_pagamento date NOT NULL,
    vlr_boleto numeric(11,2) NOT NULL,
    vlr_pago numeric(11,2) NOT NULL
) WITH (OIDS=TRUE);
CREATE INDEX tmp_idx_tb05_01_numcontr ON tmp_mfj_01_tb_05_a_boleto_basico__02 USING btree (num_contr) ;
CREATE INDEX tmp_idx_tb05_02_cpfcnpj ON tmp_mfj_01_tb_05_a_boleto_basico__02 USING btree (num_cpf_cnpj) ;
CREATE INDEX tmp_idx_tb05_03_codoperador ON tmp_mfj_01_tb_05_a_boleto_basico__02 USING btree (cod_operador) ;
CREATE INDEX tmp_idx_tb05_04_emissao ON tmp_mfj_01_tb_05_a_boleto_basico__02 USING btree (dat_emissao_boleto) ;
CREATE INDEX tmp_idx_tb05_05_vencto ON tmp_mfj_01_tb_05_a_boleto_basico__02 USING btree (dat_vencto_boleto) ;
CREATE INDEX tmp_idx_tb05_06_pagto ON tmp_mfj_01_tb_05_a_boleto_basico__02 USING btree (dat_pagamento) ;
CREATE INDEX tmp_idx_tb05_07_emp_cpfcnpj ON tmp_mfj_01_tb_05_a_boleto_basico__02 (num_cpf_cnpj, cod_empresa) ;
CREATE INDEX tmp_idx_tb05_08_numcontr_ent ON tmp_mfj_01_tb_05_a_boleto_basico__02 (num_contr, cod_empresa, cod_credor, cod_entid_credor) ;
CREATE INDEX tmp_idx_tb05_09_numcontr_cred ON tmp_mfj_01_tb_05_a_boleto_basico__02 (num_contr, cod_empresa, cod_credor) ;
--
-->@FIM_-_Tabela Temporaria Historico ctt ult - Fato
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
--
--02_Tabela Temporaria Historico {tmp_mfj_01_tb_05_a_boleto_basico__02}
INSERT INTO tmp_mfj_01_tb_05_a_boleto_basico__02
SELECT 
    tmp02.cod_empresa,
    tmp02.cod_credor,
    tmp02.cod_entid_credor::int,
    tmp02.num_contr,
    tmp02.num_cpf_cnpj,
    tmp02.cod_operador,
    tmp02.cod_controle_boleto::int,
    tmp02.dat_emissao_boleto::date,
    tmp02.dat_vencto_boleto,
    tmp02.dat_pagamento,
    tmp02.vlr_boleto,
    tmp02.vlr_pago
FROM public.cco_boleto tmp02
WHERE tmp02.cod_controle_boleto <> '1'
;
--
--Limpa
TRUNCATE TABLE public.tmp_mfj_01_tb_05_a_boleto_basico;
;
--@Fim - limpa
--
INSERT INTO public.tmp_mfj_01_tb_05_a_boleto_basico
SELECT
    tmp01.id_contrato,
    tmp01.id_cliente,
    tmp02.cod_empresa,
    tmp02.cod_credor,
    tmp02.cod_entid_credor,
    tmp02.num_contr,
    tmp02.num_cpf_cnpj,
    tmp02.cod_operador,
    tmp02.cod_controle_boleto,
    tmp02.dat_emissao_boleto,
    tmp02.dat_vencto_boleto,
    tmp02.dat_pagamento,
    tmp02.vlr_boleto,
    tmp02.vlr_pago
FROM tmp_mfj_01_tb_05_a_boleto_basico__02 tmp02
JOIN tmp_mfj_01_tb_02_a_contrato_basico__01 tmp01
    ON tmp02.num_contr = tmp01.num_contr
    AND tmp02.cod_empresa = tmp01.cod_empresa
    AND tmp02.cod_credor = tmp01.cod_credor
    AND tmp02.cod_entid_credor = tmp01.cod_entid_credor
;
--
DROP TABLE IF EXISTS tmp_dt_atual_fil ;
DROP TABLE IF EXISTS tmp_mfj_01_tb_02_a_contrato_basico__01 ;
DROP TABLE IF EXISTS tmp_mfj_01_tb_05_a_boleto_basico__02 ;
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
--FOTO TABELA BACKUP:::
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