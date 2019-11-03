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