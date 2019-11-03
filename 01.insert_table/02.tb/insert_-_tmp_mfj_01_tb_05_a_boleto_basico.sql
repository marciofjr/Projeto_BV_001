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