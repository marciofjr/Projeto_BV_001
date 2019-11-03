--Limpeza Geral
--Nao Executar --- Organizar antes... add
--<tb_--<m>DROP>
--<m>DROP TABLE IF EXISTS public.tmp_mfj_01_tb_01_a_cliente ;
--<m>DROP TABLE IF EXISTS public.tmp_mfj_01_tb_02_a_contrato_basico ;
--<m>DROP TABLE IF EXISTS public.tmp_mfj_01_tb_03_a_parcela_resumo_contrato ;
--<m>DROP TABLE IF EXISTS public.tmp_mfj_01_tb_04_a_historico_basico ;
--<m>DROP TABLE IF EXISTS public.tmp_mfj_01_tb_04_b_historico_ult_ocorr_ctt ;
--<m>DROP TABLE IF EXISTS public.tmp_mfj_01_tb_05_a_boleto_basico ;
--<id_--<m>DROP>
--<m>DROP TABLE IF EXISTS public.tmp_mfj_01_id_01_a_cliente ;
--<m>DROP SEQUENCE IF EXISTS public.tmp_mfj_01_id_01_a_cliente_seq ;
--<m>DROP TABLE IF EXISTS public.tmp_mfj_01_id_02_a_contrato ;
--<m>DROP SEQUENCE IF EXISTS public.tmp_mfj_01_id_02_a_contrato_seq ;
--<dp_--<m>DROP>
--<m>DROP TABLE IF EXISTS public.tmp_mfj_00_gb_01_a_calendario ;
--<m>DROP TABLE IF EXISTS public.tmp_mfj_01_dp_01_a_carteira ;
--<m>DROP TABLE IF EXISTS public.tmp_mfj_01_dp_02_a_produto ;
--<m>DROP TABLE IF EXISTS public.tmp_mfj_01_dp_03_a_ctt_status ;
--<m>DROP TABLE IF EXISTS public.tmp_mfj_01_dp_04_a_uf_regiao ;
--<m>DROP TABLE IF EXISTS public.tmp_mfj_01_dp_05_a_fx_risco ;
--<m>DROP TABLE IF EXISTS public.tmp_mfj_01_dp_06_a_fx_atraso ;
--<m>DROP TABLE IF EXISTS public.tmp_mfj_01_dp_07_a_codigo_historico ;
--<m>DROP TABLE IF EXISTS public.tmp_mfj_01_dp_08_a_fx_idade ;
--<m>DROP TABLE IF EXISTS public.tmp_mfj_01_dp_09_a_fx_entrada_fluxo ;
--<m>DROP TABLE IF EXISTS public.tmp_mfj_01_dp_09_b_resumo_fx_entrada_fluxo ;
--
--{ini}{gb-global}-----------------------------------------------------------------------------------------------------------------
--
-->Tabela Calendario:
--{01}-A = {tmp_mfj_00_gb_01_a_calendario}
    /*
        01-A = {tmp_mfj_00_gb_01_a_calendario}
                {
                    >Tabela Calendario:
                        [dt_calend] = identificador {campo principal}
                        [sem_dia] = dia da semana {dom=01, seg=02, ter=03, qua=04, ... sab=07}
                        [sem_mes] = semana do mes {visao real da semana do mes}
                        [dt_du] = dia util dentro do mes {sabados=71,72,73,74,75}
                        [ano_n] = ano numero
                        [mes_n] = mes numero
                        [mes_du] = total dia util mes
                        [sem_rel] = numero semana dentro do mes {ajustado para ter 4 semanas, regra em codigo}
                        [qtd_du_sem] = qts dias util considerados para == [sem_rel] {regra em codigo}
                }><m
    */
-->gb_01_a_calendario 
-->Tabela Calendario:
--
--<m>DROP TABLE IF EXISTS public.tmp_mfj_00_gb_01_a_calendario ;
CREATE TABLE public.tmp_mfj_00_gb_01_a_calendario
(dt_calend date NOT NULL,
sem_dia int NOT NULL,
sem_mes int NOT NULL,
dt_du int NOT NULL,
ano_n int NOT NULL,
mes_n int NOT NULL,
mes_du int NOT NULL,
sem_rel int NOT NULL,
qtd_du_sem int NOT NULL
) WITH (OIDS=TRUE);
CREATE UNIQUE INDEX pkey_01_gb01_calendario ON tmp_mfj_00_gb_01_a_calendario USING btree (dt_calend);
CREATE INDEX idx_gb01_01_ano ON tmp_mfj_00_gb_01_a_calendario USING btree (ano_n) ;
CREATE INDEX idx_gb01_02_mes ON tmp_mfj_00_gb_01_a_calendario USING btree (mes_n) ;
--
--{ini}{dp-de-para}-----------------------------------------------------------------------------------------------------------------
--
-->Tipo de carteira
--{01}-A = {tmp_mfj_01_dp_01_a_carteira}
    /*
        01-A = {tmp_mfj_01_dp_01_a_carteira}
                {
                    >Tipo de carteira:
                        [id_carteira] = identificador
                        [cod_credor] = codigo credor {padraoBD}
                        [cod_entid_credor] = codigo entidade credor {padraoBD}
                        [carteira_nome] = carteira nome {produto cliente}
                }><m
    */
-->dp_01_a_carteira    
-->Tipo de carteira
--
--<m>DROP TABLE IF EXISTS public.tmp_mfj_01_dp_01_a_carteira ;
CREATE TABLE public.tmp_mfj_01_dp_01_a_carteira
(id_carteira int PRIMARY KEY,
cod_credor int NOT NULL,
cod_entid_credor int NOT NULL,
carteira_nome varchar(30) NOT NULL
) WITH (OIDS=TRUE);
--CREATE UNIQUE INDEX pkey_01_dp01_id_carteira ON tmp_mfj_01_dp_01_a_carteira USING btree (id_carteira);
CREATE INDEX idx_dp01_01_credor_entid ON tmp_mfj_01_dp_01_a_carteira (cod_credor,cod_entid_credor) ;
--
-------------------------------------------------------------------------------------------------------------------
--
-->Produto do Contrato
--{02}-A = {tmp_mfj_01_dp_02_a_produto}
    /*
        02-A = {tmp_mfj_01_dp_02_a_produto}
                {
                    >Produto do Contrato - Segmentacao:
                        [id_prod] = identificador
                        [desc_prod] = descricao produto
                        [rel_prod] = descricao produto {resumo}
                }><m
    */
-->dp_02_a_produto    
-->Produto do Contrato
--
--<m>DROP TABLE IF EXISTS public.tmp_mfj_01_dp_02_a_produto ;
CREATE TABLE public.tmp_mfj_01_dp_02_a_produto (
id_prod int PRIMARY KEY,
desc_prod varchar(50) NULL,
rel_prod varchar(30) NULL
) WITH (OIDS=TRUE);
--CREATE UNIQUE INDEX pkey_01_dp02_produto ON tmp_mfj_01_dp_02_a_produto USING btree (id_prod) ;
--
-------------------------------------------------------------------------------------------------------------------
--
-->Posicao do Contrato - Status:
--{03}-A = {tmp_mfj_01_dp_03_a_ctt_status}
    /*
        03-A = {tmp_mfj_01_dp_03_a_ctt_status}
                {
                    >Posicao do Contrato - Status:
                        [id_status_ctt] = identificador
                        [cod_empresa] = codigo empresa {padraoBD}
                        [cod_credor] = codigo credor {padraoBD}
                        [flg_status_ctt] = flag status {0:Inativo, 1:Ativo, 2:Suspenso}
                        [cod_posicao_contr] = codigo posicao do contrato {padraoBD}
                        [nom_posicao_contr] = descricao posicao contrato {padraoBD}
                        [flg_bloqueia_calculo] = flag {0:Inativo, 1:Ativo}
                        [flg_performa] = flag {0:Inativo, 1:Ativo}
                        [flg_exibe_pesquisa] = flag {0:Inativo, 1:Ativo}
                        [flg_notifica] = flag {0:Inativo, 1:Ativo}
                        [flg_inibe_historico] = flag {0:Inativo, 1:Ativo}
                        [flg_inibe_historico_troca_pos] = flag {0:Inativo, 1:Ativo}
                }><m
    */
--
--<m>DROP TABLE IF EXISTS public.tmp_mfj_01_dp_03_a_ctt_status ;
CREATE TABLE public.tmp_mfj_01_dp_03_a_ctt_status (
id_status_ctt int PRIMARY KEY,
cod_empresa int NOT NULL,
cod_credor int NOT NULL,
flg_status_ctt int NOT NULL,
cod_posicao_contr varchar(5) NOT NULL,
nom_posicao_contr varchar(30) NOT NULL,
flg_bloqueia_calculo int NOT NULL,
flg_performa int NOT NULL,
flg_exibe_pesquisa int NOT NULL,
flg_notifica int NOT NULL,
flg_inibe_historico int NOT NULL,
flg_inibe_historico_troca_pos int NOT NULL
) WITH (OIDS=TRUE);
--CREATE UNIQUE INDEX pkey_01_dp03_ctt_status ON tmp_mfj_01_dp_03_a_ctt_status USING btree (id_status_ctt) ;
CREATE UNIQUE INDEX pkey_01_dp03_posctt ON tmp_mfj_01_dp_03_a_ctt_status (cod_posicao_contr, cod_empresa, cod_credor) ;
CREATE INDEX idx_dp03_01_credor ON tmp_mfj_01_dp_03_a_ctt_status USING btree (cod_credor) ;
CREATE INDEX idx_dp03_02_codpos_ctt ON tmp_mfj_01_dp_03_a_ctt_status USING btree (cod_posicao_contr) ;
--
-------------------------------------------------------------------------------------------------------------------
--
-->Regiao / Estado:
--{04}-A = {tmp_mfj_01_dp_04_a_uf_regiao}
    /*
        04-A = {tmp_mfj_01_dp_04_a_uf_regiao}
                {
                    >Regiao / Estado:
                        [id_uf] = identificador
                        [desc_uf] = descricao uf {nome estado}
                        [cod_uf] = codigo uf {sigla do estado}
                        [id_regiao] = identificador da regiao
                        [desc_regiao] = descricao regiao {nome regiao}
                }><m
    */
--
--<m>DROP TABLE IF EXISTS public.tmp_mfj_01_dp_04_a_uf_regiao ;
CREATE TABLE public.tmp_mfj_01_dp_04_a_uf_regiao (
id_uf int PRIMARY KEY,
desc_uf varchar(30) NOT NULL,
cod_uf varchar(2) NOT NULL,
id_regiao int NOT NULL,
desc_regiao varchar(30) NOT NULL
) WITH (OIDS=TRUE);
--CREATE UNIQUE INDEX pkey_01_dp_04_uf_regiao ON tmp_mfj_01_dp_04_a_uf_regiao USING btree (id_uf) ;
CREATE UNIQUE INDEX pkey_02_dp04_uf ON tmp_mfj_01_dp_04_a_uf_regiao USING btree (cod_uf) ;
CREATE INDEX idx_dp04_01_regiao ON tmp_mfj_01_dp_04_a_uf_regiao USING btree (id_regiao) ;
--
-------------------------------------------------------------------------------------------------------------------
--
-->Faixa de Risco:
--{05}-A = {tmp_mfj_01_dp_05_a_fx_risco}
    /*
        05-A = {tmp_mfj_01_dp_05_a_fx_risco}
                {
                    >Faixa de Risco:
                        [id_risco] = identificador
                        [fx_risco] = faixa de risco {divisao por faixa de valores}
                        [fx_risco_res] = faixa resumida de risco {Nulo, Baixo, Médio, Médio-Alto, Alto, Alto Impacto}
                }><m
    */
--
--<m>DROP TABLE IF EXISTS public.tmp_mfj_01_dp_05_a_fx_risco ;
CREATE TABLE public.tmp_mfj_01_dp_05_a_fx_risco (
id_risco int PRIMARY KEY,
fx_risco varchar(30) NOT NULL,
fx_risco_res varchar(30) NOT NULL
) WITH (OIDS=TRUE);
--CREATE UNIQUE INDEX pkey_01_dp05_fx_risco ON tmp_mfj_01_dp_05_a_fx_risco USING btree (id_risco) ;
--
-------------------------------------------------------------------------------------------------------------------
--
-->Faixa de Atraso:
--{06}-A = {tmp_mfj_01_dp_06_a_fx_atraso}
    /*
        06-A = {tmp_mfj_01_dp_06_a_fx_atraso}
                {
                    >Faixa de Atraso:
                        [id_atraso] = identificador {01 até 1800 --- 1801==Acima de 5 anos --- 1801tbm==Sem_Atraso}
                            {optado por 1 = 1 --- do que resumido, por conta do cliente mudar}
                        [fx_atraso_cli_01] = faixa de atraso {visao 01 cliente}
                        [fx_atraso_cli_02] = faixa de atraso {visao 02 cliente}
                        [fx_atraso_nv01] = faixa de atraso {interna - visão 01 escritório}
                        [fx_atraso_nv02] = faixa de atraso {interna - visão 02 escritório}
                        [fx_atraso_nv03] = faixa de atraso {interna - visão 03 escritório}
                }><m
    */
--
--<m>DROP TABLE IF EXISTS public.tmp_mfj_01_dp_06_a_fx_atraso ;
CREATE TABLE public.tmp_mfj_01_dp_06_a_fx_atraso (
id_atraso int PRIMARY KEY,
fx_atraso_cli_01 varchar(30) NOT NULL,
fx_atraso_cli_02 varchar(30) NOT NULL,
fx_atraso_nv01 varchar(30) NOT NULL,
fx_atraso_nv02 varchar(30) NOT NULL,
fx_atraso_nv03 varchar(30) NOT NULL
) WITH (OIDS=TRUE);
--CREATE UNIQUE INDEX pkey_01_dp06_fx_atraso ON tmp_mfj_01_dp_06_a_fx_atraso USING btree (id_atraso) ;
CREATE INDEX idx_dp06_01_fx_nv01 ON tmp_mfj_01_dp_06_a_fx_atraso USING btree (fx_atraso_nv01) ;
--
-------------------------------------------------------------------------------------------------------------------
--
-->Codigo Historico:
--{07}-A = {tmp_mfj_01_dp_07_a_codigo_historico}
    /*
        07-A = {tmp_mfj_01_dp_07_a_codigo_historico}
                {
                    >Codigo Historico:
                        [id_cod_hst] = identificador
                        [cod_empresa] = codigo empresa {padraoBD}
                        [cod_credor] = codigo credor {padraoBD}
                        [id_perfil_cob] = parametrizado para filtro {02=supervisor/cobrador}
                        [cod_hist] = codigo historico {padraoBD}
                        [des_hist] = descricao do codigo historico
                        [cod_acao_cob_flt] = codigo da acao {identificador da acao}
                        [cod_compl] = codigo do hst para cliente {categoria + tipo + complemento}
                        [c01m] = acao 01 {categoria}
                        [c02m] = acao 02 {tipo}
                        [c03m] = acao 03 {complemento}
                        [ocor_p] = ocorrencia considerada positiva {KPI_hst}
                        [acio] = acionamento considerado {KPI_hst}
                        [alo] = alo, alguem atendeu {KPI_hst}
                        [cpc] = cpc, contato com a pessoa certa {KPI_hst}
                        [opac] = oportunidade de acordo {KPI_hst}
                        [ac] = proposta formalizada {KPI_hst}
                        [badcall] = ligacao caiu {KPI_hst}
                        [hang_up] = queda na transferencia de ligacao atendida (indisponibilidade de ramal) {KPI_hst}
                        [tel_inv] = telefone invalido {KPI_hst}
                }><m
    */
--
--<m>DROP TABLE IF EXISTS public.tmp_mfj_01_dp_07_a_codigo_historico ;
CREATE TABLE public.tmp_mfj_01_dp_07_a_codigo_historico (
id_cod_hst int PRIMARY KEY,
cod_empresa int NOT NULL,
cod_credor int NOT NULL,
id_perfil_cob int NOT NULL,
cod_hist int NOT NULL,
des_hist varchar(60) NOT NULL,
cod_acao_cob_flt int NOT NULL,
cod_compl char(6) NOT NULL,
c01m char(2) NOT NULL,
c02m char(2) NOT NULL,
c03m char(2) NOT NULL,
ocor_p int NOT NULL,
acio int NOT NULL,
alo int NOT NULL,
cpc int NOT NULL,
opac int NOT NULL,
ac int NOT NULL,
badcall int NOT NULL,
hang_up int NOT NULL,
tel_inv int NOT NULL
) WITH (OIDS=TRUE);
--CREATE UNIQUE INDEX pkey_01_dp07_id_cod_hst ON tmp_mfj_01_dp_07_a_codigo_historico USING btree (id_cod_hst) ;
CREATE UNIQUE INDEX pkey_02_dp07_id_cod_hst ON tmp_mfj_01_dp_07_a_codigo_historico (cod_hist, cod_empresa, cod_credor) ;
CREATE INDEX idx_dp07_01_codhst ON tmp_mfj_01_dp_07_a_codigo_historico USING btree (cod_hist) ;
CREATE INDEX idx_dp07_02_idperf ON tmp_mfj_01_dp_07_a_codigo_historico USING btree (id_perfil_cob) ;
CREATE INDEX idx_dp07_03_codcompl ON tmp_mfj_01_dp_07_a_codigo_historico USING btree (cod_compl) ;
--
-------------------------------------------------------------------------------------------------------------------
--
-->Faixa Idade:
--{08}-A = {tmp_mfj_01_dp_08_a_fx_idade}
    /*
        08-A = {tmp_mfj_01_dp_08_a_fx_idade}
                {
                    >Faixa Idade:
                        [id_idade] = identificador {01 até 150 --- 151==Sem.Idade}
                        [id_fx_idade] = numeracao resumo da faixa de idade {simplificar}
                        [fx_idade_nv01] = faixa de idade {interna - visão 01 escritório}
                }><m
    */
--
--<m>DROP TABLE IF EXISTS public.tmp_mfj_01_dp_08_a_fx_idade ;
CREATE TABLE public.tmp_mfj_01_dp_08_a_fx_idade (
id_idade int PRIMARY KEY,
id_fx_idade int NOT NULL,
fx_idade_nv01 varchar(30) NOT NULL
) WITH (OIDS=TRUE);
--CREATE UNIQUE INDEX pkey_01_dp_08_id_idade ON tmp_mfj_01_dp_08_a_fx_idade USING btree (id_idade) ;
CREATE INDEX idx_dp08_01_idfx_idade ON tmp_mfj_01_dp_08_a_fx_idade USING btree (id_fx_idade) ;
--
-------------------------------------------------------------------------------------------------------------------
--
-->Faixa Estoque e Fluxo:
--{09}-A = {tmp_mfj_01_dp_09_a_fx_entrada_fluxo}
    /*
        09-A = {tmp_mfj_01_dp_09_a_fx_entrada_fluxo}
                {
                    >Faixa Estoque e Fluxo:
                        [id_entrada] = identificador {01 até 999} 
                        [ {menor ou igual 00} = id_fx_fluxo==1 --- maior que 999 id_fx_estoque==14 ]
                        [id_fx_fluxo] = identificador para id_fx_flux_estoq {tmp_mfj_01_dp_09_b_resumo_fx_entrada_fluxo}
                        [id_fx_estoque] = identificador para id_fx_flux_estoq {tmp_mfj_01_dp_09_b_resumo_fx_entrada_fluxo}
                }><m
    */
--
--<m>DROP TABLE IF EXISTS public.tmp_mfj_01_dp_09_a_fx_entrada_fluxo ;
CREATE TABLE public.tmp_mfj_01_dp_09_a_fx_entrada_fluxo (
id_entrada int PRIMARY KEY,
id_fx_fluxo int NOT NULL,
id_fx_estoque int NOT NULL
) WITH (OIDS=TRUE);
--CREATE UNIQUE INDEX pkey_01_dp_09_fx_id_entrada ON tmp_mfj_01_dp_09_a_fx_entrada_fluxo USING btree (id_entrada) ;
CREATE INDEX idx_dp09_01_idfx_fluxo ON tmp_mfj_01_dp_09_a_fx_entrada_fluxo USING btree (id_fx_fluxo) ;
CREATE INDEX idx_dp09_02_idfx_estoque ON tmp_mfj_01_dp_09_a_fx_entrada_fluxo USING btree (id_fx_estoque) ;
--
-------------------------------------------------------------------------------------------------------------------
--
-->Resumo Faixa Estoque e Fluxo:
--{09}-B = {tmp_mfj_01_dp_09_b_resumo_fx_entrada_fluxo}
    /*
        09-B = {tmp_mfj_01_dp_09_b_resumo_fx_entrada_fluxo}
                {
                    >Resumo Faixa Estoque e Fluxo:
                        [id_fx_flux_estoq] = identificador {01 até 14} 
                        [desc_fluxo_estoque] = descricao {fluxo ou estoque} e qual faixa atuacao
                }><m
    */
--
--<m>DROP TABLE IF EXISTS public.tmp_mfj_01_dp_09_b_resumo_fx_entrada_fluxo ;
CREATE TABLE public.tmp_mfj_01_dp_09_b_resumo_fx_entrada_fluxo (
id_fx_flux_estoq int PRIMARY KEY,
desc_fluxo_estoque varchar(30) NOT NULL
) WITH (OIDS=TRUE);
--CREATE UNIQUE INDEX pkey_01_dp_09_fx_id_fx_flux_estoq ON tmp_mfj_01_dp_09_b_resumo_fx_entrada_fluxo USING btree (id_fx_flux_estoq) ;
--
--{ini}{id-IDENTIFICADOR}-----------------------------------------------------------------------------------------------------------------
--
-->Identificador Cliente:
--{01}-A = {tmp_mfj_01_id_01_a_cliente}
    /*
        01-A = {tmp_mfj_01_id_01_a_cliente}
                {
                    >Identificador Cliente:
                        [id_cliente] = identificador Cliente
                        [cod_empresa] = codigo empresa {padraoBD}
                        [num_cpf_cnpj] = numero documento cliente {padraoBD}
                }><m
    */
--
--<m>DROP TABLE IF EXISTS public.tmp_mfj_01_id_01_a_cliente ;
--<m>DROP SEQUENCE IF EXISTS public.tmp_mfj_01_id_01_a_cliente_seq ;
CREATE SEQUENCE public.tmp_mfj_01_id_01_a_cliente_seq
INCREMENT 1
MINVALUE 1
MAXVALUE 9223372036854775807
START 1
CACHE 1;
CREATE TABLE public.tmp_mfj_01_id_01_a_cliente (
id_cliente int DEFAULT NEXTVAL('tmp_mfj_01_id_01_a_cliente_seq') PRIMARY KEY,
cod_empresa int NOT NULL,
num_cpf_cnpj numeric(17) NOT NULL
) WITH (OIDS=TRUE);
--CREATE UNIQUE INDEX pkey_01_id01_id_cliente ON tmp_mfj_01_id_01_a_cliente USING btree (id_cliente) ;
CREATE UNIQUE INDEX pkey_02_id01_num_cpf_cnpj ON tmp_mfj_01_id_01_a_cliente (num_cpf_cnpj, cod_empresa) ;
CREATE INDEX idx_id01_01_cpfcnpj ON tmp_mfj_01_id_01_a_cliente USING btree (num_cpf_cnpj) ;
--
-------------------------------------------------------------------------------------------------------------------
--
-->Identificador Contrato:
--{02}-A = {tmp_mfj_01_id_02_a_contrato}
    /*
        02-A = {tmp_mfj_01_id_02_a_contrato}
                {
                    >Identificador Contrato:
                        [id_contrato] = identificador Cliente
                        [cod_empresa] = codigo empresa {padraoBD}
                        [cod_credor] = codigo credor {padraoBD}
                        [cod_entid_credor] = codigo entidade {padraoBD}
                        [num_contr] = numero de contrato {padraoBD}
                }><m
    */
--
--<m>DROP TABLE IF EXISTS public.tmp_mfj_01_id_02_a_contrato ;
--<m>DROP SEQUENCE IF EXISTS public.tmp_mfj_01_id_02_a_contrato_seq ;
CREATE SEQUENCE public.tmp_mfj_01_id_02_a_contrato_seq
INCREMENT 1
MINVALUE 1
MAXVALUE 9223372036854775807
START 1
CACHE 1;
CREATE TABLE public.tmp_mfj_01_id_02_a_contrato (
id_contrato int DEFAULT NEXTVAL('tmp_mfj_01_id_02_a_contrato_seq') PRIMARY KEY,
cod_empresa int NOT NULL,
cod_credor int NOT NULL,
cod_entid_credor int NOT NULL,
num_contr varchar(50) NOT NULL
) WITH (OIDS=TRUE);
--CREATE UNIQUE INDEX pkey_01_id02_id_contrato ON tmp_mfj_01_id_02_a_contrato USING btree (id_contrato) ;
CREATE UNIQUE INDEX pkey_02_id02_ctt ON tmp_mfj_01_id_02_a_contrato (num_contr, cod_empresa, cod_credor, cod_entid_credor) ;
CREATE INDEX idx_id02_01_numcontr ON tmp_mfj_01_id_02_a_contrato USING btree (num_contr) ;
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
    */
--
--<m>DROP TABLE IF EXISTS public.tmp_mfj_01_id_03_a_foto_diaria ;
--<m>DROP SEQUENCE IF EXISTS public.tmp_mfj_01_id_03_a_foto_diaria_seq ;
CREATE SEQUENCE public.tmp_mfj_01_id_03_a_foto_diaria_seq
INCREMENT 1
MINVALUE 1
MAXVALUE 9223372036854775807
START 1
CACHE 1;
CREATE TABLE public.tmp_mfj_01_id_03_a_foto_diaria (
id_foto int DEFAULT NEXTVAL('tmp_mfj_01_id_03_a_foto_diaria_seq') PRIMARY KEY,
id_contrato int NOT NULL,
id_carteira int NOT NULL,
dat_ent_contr date NOT NULL
) WITH (OIDS=TRUE);
--CREATE UNIQUE INDEX pkey_01_id03_id_foto ON tmp_mfj_01_id_03_a_foto_diaria USING btree (id_foto) ;
CREATE UNIQUE INDEX pkey_02_id03_idctt ON tmp_mfj_01_id_03_a_foto_diaria (id_contrato, id_carteira, dat_ent_contr) ;
CREATE INDEX idx_id03_01_idctt ON tmp_mfj_01_id_03_a_foto_diaria USING btree (id_contrato) ;
CREATE INDEX idx_id03_02_idcarteira ON tmp_mfj_01_id_03_a_foto_diaria USING btree (id_carteira) ;
CREATE INDEX idx_id03_03_dtentctt ON tmp_mfj_01_id_03_a_foto_diaria USING btree (dat_ent_contr) ;
--
--{ini}{tb-FATO}-----------------------------------------------------------------------------------------------------------------
--
-->Tabela Cliente:
--{01}-A = {tmp_mfj_01_tb_01_a_cliente}
    /*
        01-A = {tmp_mfj_01_tb_01_a_cliente}
                {
                    >Tabela Cliente - FATO:
                        [id_cliente] = identificador {origem==tmp_mfj_01_id_01_a_cliente}
                        [id_uf] = identificador {origem==tmp_mfj_01_dp_04_a_uf_regiao}
                        [id_idade] = identificador  {origem==tmp_mfj_01_dp_08_a_fx_idade} {01 até 150 --- 151==Sem.Idade}
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
--<m>DROP TABLE IF EXISTS public.tmp_mfj_01_tb_01_a_cliente ;
CREATE TABLE public.tmp_mfj_01_tb_01_a_cliente (
id_cliente int PRIMARY KEY,
id_uf int NOT NULL,
id_idade int NOT NULL,
cod_empresa int NOT NULL,
num_cpf_cnpj numeric(17) NOT NULL,
cod_cliente int NOT NULL,
dat_nasc date NOT NULL,
dat_digitacao date NOT NULL,
uf char(2) NOT NULL,
nom_munic varchar(60) NOT NULL,
nom_cliente varchar(100) NOT NULL
) WITH (OIDS=TRUE);
--CREATE UNIQUE INDEX pkey_01_tb01_id_cliente ON tmp_mfj_01_tb_01_a_cliente USING btree (id_cliente) ;
CREATE UNIQUE INDEX pkey_02_tb01_cliente ON tmp_mfj_01_tb_01_a_cliente (num_cpf_cnpj, cod_empresa) ;
CREATE INDEX idx_tb01_01_codcli ON tmp_mfj_01_tb_01_a_cliente USING btree (cod_cliente) ;
CREATE INDEX idx_tb01_02_cpfcnpj ON tmp_mfj_01_tb_01_a_cliente USING btree (num_cpf_cnpj) ;
CREATE INDEX idx_tb01_03_iduf ON tmp_mfj_01_tb_01_a_cliente USING btree (id_uf) ;
CREATE INDEX idx_tb01_04_ididade ON tmp_mfj_01_tb_01_a_cliente USING btree (id_idade) ;
--<m--::: VINCULOS {REFERENCES} :::-->--
--id_cliente = {tmp_mfj_01_id_01_a_cliente}
ALTER TABLE public.tmp_mfj_01_tb_01_a_cliente
ADD CONSTRAINT fkey_tb_01_a_cliente_id_cliente
FOREIGN KEY (id_cliente)
REFERENCES public.tmp_mfj_01_id_01_a_cliente (id_cliente) ON UPDATE CASCADE ;
--id_uf = {tmp_mfj_01_dp_04_a_uf_regiao}
ALTER TABLE public.tmp_mfj_01_tb_01_a_cliente
ADD CONSTRAINT fkey_tb_01_a_cliente_id_uf
FOREIGN KEY (id_uf)
REFERENCES public.tmp_mfj_01_dp_04_a_uf_regiao (id_uf) ON UPDATE CASCADE ;
--id_idade = {tmp_mfj_01_dp_08_a_fx_idade}
ALTER TABLE public.tmp_mfj_01_tb_01_a_cliente
ADD CONSTRAINT fkey_tb_01_a_cliente_id_idade
FOREIGN KEY (id_idade)
REFERENCES public.tmp_mfj_01_dp_08_a_fx_idade (id_idade) ON UPDATE CASCADE ;
--
-------------------------------------------------------------------------------------------------------------------
--
-->Tabela Contrato:
--{02}-A = {tmp_mfj_01_tb_02_a_contrato_basico}
    /*
        02-A = {tmp_mfj_01_tb_02_a_contrato_basico}
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
                        [cod_posicao_contr] = codigo posicao contrato
                        [flg_status_ctt] = flag status {0:Inativo, 1:Ativo, 2:Suspenso}
                }><m
    */
--
--<m>DROP TABLE IF EXISTS public.tmp_mfj_01_tb_02_a_contrato_basico ;
CREATE TABLE public.tmp_mfj_01_tb_02_a_contrato_basico (
id_contrato int PRIMARY KEY,
id_cliente int NOT NULL,
id_carteira int NOT NULL,
id_status_ctt int NOT NULL,
id_fx_flux_estoq int NOT NULL,
cod_empresa int NOT NULL,
cod_credor int NOT NULL,
cod_entid_credor int NOT NULL,
num_contr varchar(50) NOT NULL,
num_cpf_cnpj numeric(17) NOT NULL,
dat_ent_contr date NOT NULL,
per_ent_contr int NOT NULL,
cod_posicao_contr char(1) NOT NULL,
flg_status_ctt int NOT NULL
) WITH (OIDS=TRUE);
--CREATE UNIQUE INDEX pkey_01_tb02_id_contrato ON tmp_mfj_01_tb_02_a_contrato_basico USING btree (id_contrato) ;
CREATE UNIQUE INDEX pkey_02_tb02_contrato ON tmp_mfj_01_tb_02_a_contrato_basico (num_contr, cod_empresa, cod_credor, cod_entid_credor) ;
CREATE INDEX idx_tb02_01_idcliente ON tmp_mfj_01_tb_02_a_contrato_basico USING btree (id_cliente) ;
CREATE INDEX idx_tb02_02_idcarteira ON tmp_mfj_01_tb_02_a_contrato_basico USING btree (id_carteira) ;
CREATE INDEX idx_tb02_03_idstatus_ctt ON tmp_mfj_01_tb_02_a_contrato_basico USING btree (id_status_ctt) ;
CREATE INDEX idx_tb02_04_idfx_flux_estoq ON tmp_mfj_01_tb_02_a_contrato_basico USING btree (id_fx_flux_estoq) ;
CREATE INDEX idx_tb02_05_per_contr ON tmp_mfj_01_tb_02_a_contrato_basico USING btree (per_ent_contr) ;
CREATE INDEX idx_tb02_06_status_ctt ON tmp_mfj_01_tb_02_a_contrato_basico USING btree (flg_status_ctt) ;
CREATE INDEX idx_tb02_07_numcontr ON tmp_mfj_01_tb_02_a_contrato_basico USING btree (num_contr) ;
CREATE INDEX idx_tb02_08_cpfcnpj ON tmp_mfj_01_tb_02_a_contrato_basico USING btree (num_cpf_cnpj) ;
CREATE INDEX idx_tb02_09_dtentcontr ON tmp_mfj_01_tb_02_a_contrato_basico USING btree (dat_ent_contr) ;
CREATE INDEX idx_tb02_10_poscontr ON tmp_mfj_01_tb_02_a_contrato_basico USING btree (cod_posicao_contr) ;
CREATE INDEX idx_tb02_11_numcontr_cred ON tmp_mfj_01_tb_02_a_contrato_basico (num_contr, cod_empresa, cod_credor) ;
CREATE INDEX idx_tb02_12_emp_cpfcnpj ON tmp_mfj_01_tb_02_a_contrato_basico (num_cpf_cnpj, cod_empresa) ;
CREATE INDEX idx_tb02_13_dtentcontr ON tmp_mfj_01_tb_02_a_contrato_basico 
(cod_empresa, cod_credor, cod_entid_credor, num_contr, dat_ent_contr);
--<m--::: VINCULOS {REFERENCES} :::-->--
--id_contrato = {tmp_mfj_01_id_02_a_contrato}
ALTER TABLE public.tmp_mfj_01_tb_02_a_contrato_basico
ADD CONSTRAINT fkey_tb_02_a_contrato_basico_id_contrato
FOREIGN KEY (id_contrato)
REFERENCES public.tmp_mfj_01_id_02_a_contrato (id_contrato) ON UPDATE CASCADE ;
--id_cliente = {tmp_mfj_01_id_01_a_cliente}
ALTER TABLE public.tmp_mfj_01_tb_02_a_contrato_basico
ADD CONSTRAINT fkey_tb_02_a_contrato_basico_id_cliente
FOREIGN KEY (id_cliente)
REFERENCES public.tmp_mfj_01_id_01_a_cliente (id_cliente) ON UPDATE CASCADE ;
--id_carteira = {tmp_mfj_01_dp_01_a_carteira}
ALTER TABLE public.tmp_mfj_01_tb_02_a_contrato_basico
ADD CONSTRAINT fkey_tb_02_a_contrato_basico_id_carteira
FOREIGN KEY (id_carteira)
REFERENCES public.tmp_mfj_01_dp_01_a_carteira (id_carteira) ON UPDATE CASCADE ;
--id_status_ctt = {tmp_mfj_01_dp_03_a_ctt_status}
ALTER TABLE public.tmp_mfj_01_tb_02_a_contrato_basico
ADD CONSTRAINT fkey_tb_02_a_contrato_basico_id_status_ctt
FOREIGN KEY (id_status_ctt)
REFERENCES public.tmp_mfj_01_dp_03_a_ctt_status (id_status_ctt) ON UPDATE CASCADE ;
--id_fx_flux_estoq = {tmp_mfj_01_dp_09_b_resumo_fx_entrada_fluxo}
ALTER TABLE public.tmp_mfj_01_tb_02_a_contrato_basico
ADD CONSTRAINT fkey_tb_02_a_contrato_basico_id_fx_flux_estoq
FOREIGN KEY (id_fx_flux_estoq)
REFERENCES public.tmp_mfj_01_dp_09_b_resumo_fx_entrada_fluxo (id_fx_flux_estoq) ON UPDATE CASCADE ;
--
-------------------------------------------------------------------------------------------------------------------
--
-->Tabela Parcela - FATO:
--{03}-A = {tmp_mfj_01_tb_03_a_parcela_resumo_contrato}
    /*
        03-A = {tmp_mfj_01_tb_03_a_parcela_resumo_contrato}
                {
                    >Tabela Parcela - FATO:
                        [id_contrato] = identificador {origem==tmp_mfj_01_id_02_a_contrato}
                        [id_atraso] = identificador {origem==tmp_mfj_01_dp_06_a_fx_atraso}
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
--<m>DROP TABLE IF EXISTS public.tmp_mfj_01_tb_03_a_parcela_resumo_contrato ;
CREATE TABLE public.tmp_mfj_01_tb_03_a_parcela_resumo_contrato (
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
--CREATE UNIQUE INDEX pkey_01_tb_03_id_contrato ON tmp_mfj_01_tb_03_a_parcela_resumo_contrato USING btree (id_contrato) ;
CREATE INDEX idx_tb03_01_atraso ON tmp_mfj_01_tb_03_a_parcela_resumo_contrato USING btree (atraso) ;
CREATE INDEX idx_tb03_02_idatraso ON tmp_mfj_01_tb_03_a_parcela_resumo_contrato USING btree (id_atraso) ;
--<m--::: VINCULOS {REFERENCES} :::-->--
--id_contrato = {tmp_mfj_01_id_02_a_contrato}
ALTER TABLE public.tmp_mfj_01_tb_03_a_parcela_resumo_contrato
ADD CONSTRAINT fkey_tb_03_a_parcela_resumo_ctt_id_contrato
FOREIGN KEY (id_contrato)
REFERENCES public.tmp_mfj_01_id_02_a_contrato (id_contrato) ON UPDATE CASCADE ;
--id_atraso = {tmp_mfj_01_dp_06_a_fx_atraso}
ALTER TABLE public.tmp_mfj_01_tb_03_a_parcela_resumo_contrato
ADD CONSTRAINT fkey_tb_03_a_parcela_resumo_ctt_id_atraso
FOREIGN KEY (id_atraso)
REFERENCES public.tmp_mfj_01_dp_06_a_fx_atraso (id_atraso) ON UPDATE CASCADE ;
--
-------------------------------------------------------------------------------------------------------------------
--
-->Tabela Historico Coleta - FATO:
--{04}-A = {tmp_mfj_01_tb_04_a_historico_basico}
    /*
        04-A = {tmp_mfj_01_tb_04_a_historico_basico}
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
--<m>DROP TABLE IF EXISTS public.tmp_mfj_01_tb_04_a_historico_basico ;
CREATE TABLE public.tmp_mfj_01_tb_04_a_historico_basico (
id_historico int PRIMARY KEY,
id_cod_hst int NOT NULL,
id_contrato int NOT NULL,
id_cliente int NOT NULL,
cod_empresa int NOT NULL,
cod_credor int NOT NULL,
cod_entid_credor int NOT NULL,
num_contr varchar(50) NOT NULL,
num_cpf_cnpj numeric(17) NOT NULL,
cod_hist int NOT NULL,
dat_data_hist timestamp NOT NULL,
cod_user int NOT NULL
) WITH (OIDS=TRUE);
--CREATE UNIQUE INDEX pkey_01_tb04_id_historico ON tmp_mfj_01_tb_04_a_historico_basico USING btree (id_historico) ;
CREATE INDEX idx_tb04_01_codhst ON tmp_mfj_01_tb_04_a_historico_basico USING btree (id_cod_hst) ;
CREATE INDEX idx_tb04_02_idcontr ON tmp_mfj_01_tb_04_a_historico_basico USING btree (id_contrato) ;
CREATE INDEX idx_tb04_03_idcli ON tmp_mfj_01_tb_04_a_historico_basico USING btree (id_cliente) ;
CREATE INDEX idx_tb04_04_numcontr ON tmp_mfj_01_tb_04_a_historico_basico USING btree (num_contr) ;
CREATE INDEX idx_tb04_05_cpfcnpj ON tmp_mfj_01_tb_04_a_historico_basico USING btree (num_cpf_cnpj) ;
CREATE INDEX idx_tb04_06_codhist ON tmp_mfj_01_tb_04_a_historico_basico USING btree (cod_hist) ;
CREATE INDEX idx_tb04_07_dthist ON tmp_mfj_01_tb_04_a_historico_basico USING btree (dat_data_hist) ;
CREATE INDEX idx_tb04_08_coduser ON tmp_mfj_01_tb_04_a_historico_basico USING btree (cod_user) ;
CREATE INDEX idx_tb04_09_emp_cpfcnpj ON tmp_mfj_01_tb_04_a_historico_basico (num_cpf_cnpj, cod_empresa) ;
CREATE INDEX idx_tb04_10_numcontr_ent ON tmp_mfj_01_tb_04_a_historico_basico (num_contr, cod_empresa, cod_credor, cod_entid_credor) ;
CREATE INDEX idx_tb04_11_numcontr_cred ON tmp_mfj_01_tb_04_a_historico_basico (num_contr, cod_empresa, cod_credor) ;
--<m--::: VINCULOS {REFERENCES} :::-->--
--id_contrato = {tmp_mfj_01_id_02_a_contrato}
ALTER TABLE public.tmp_mfj_01_tb_04_a_historico_basico
ADD CONSTRAINT fkey_tb_04_a_historico_basico_id_contrato
FOREIGN KEY (id_contrato)
REFERENCES public.tmp_mfj_01_id_02_a_contrato (id_contrato) ON UPDATE CASCADE ;
--id_cliente = {tmp_mfj_01_id_01_a_cliente}
ALTER TABLE public.tmp_mfj_01_tb_04_a_historico_basico
ADD CONSTRAINT fkey_tb_04_a_historico_basico_id_cliente
FOREIGN KEY (id_cliente)
REFERENCES public.tmp_mfj_01_id_01_a_cliente (id_cliente) ON UPDATE CASCADE ;
--
-------------------------------------------------------------------------------------------------------------------
--
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
--<m>DROP TABLE IF EXISTS public.tmp_mfj_01_tb_04_b_historico_ult_ocorr_ctt ;
CREATE TABLE public.tmp_mfj_01_tb_04_b_historico_ult_ocorr_ctt (
id_historico int PRIMARY KEY,
id_cod_hst int NOT NULL,
id_contrato int NOT NULL,
id_cliente int NOT NULL,
dat_data_hist timestamp NOT NULL,
d_defasagem int NOT NULL,
cod_user int NOT NULL
) WITH (OIDS=TRUE);
--CREATE UNIQUE INDEX pkey_01_tb04_id_historico ON tmp_mfj_01_tb_04_b_historico_ult_ocorr_ctt USING btree (id_historico) ;
CREATE INDEX idx_tb04b_01_codhst ON tmp_mfj_01_tb_04_b_historico_ult_ocorr_ctt USING btree (id_cod_hst) ;
CREATE INDEX idx_tb04b_02_idcontr ON tmp_mfj_01_tb_04_b_historico_ult_ocorr_ctt USING btree (id_contrato) ;
CREATE INDEX idx_tb04b_03_idcli ON tmp_mfj_01_tb_04_b_historico_ult_ocorr_ctt USING btree (id_cliente) ;
CREATE INDEX idx_tb04b_04_dthist ON tmp_mfj_01_tb_04_b_historico_ult_ocorr_ctt USING btree (dat_data_hist) ;
CREATE INDEX idx_tb04b_04_coduser ON tmp_mfj_01_tb_04_b_historico_ult_ocorr_ctt USING btree (cod_user) ;
--<m--::: VINCULOS {REFERENCES} :::-->--
--id_contrato = {tmp_mfj_01_id_02_a_contrato}
ALTER TABLE public.tmp_mfj_01_tb_04_b_historico_ult_ocorr_ctt
ADD CONSTRAINT fkey_tb_04_b_historico_basico_id_contrato
FOREIGN KEY (id_contrato)
REFERENCES public.tmp_mfj_01_id_02_a_contrato (id_contrato) ON UPDATE CASCADE ;
--id_cliente = {tmp_mfj_01_id_01_a_cliente}
ALTER TABLE public.tmp_mfj_01_tb_04_b_historico_ult_ocorr_ctt
ADD CONSTRAINT fkey_tb_04_b_historico_basico_id_cliente
FOREIGN KEY (id_cliente)
REFERENCES public.tmp_mfj_01_id_01_a_cliente (id_cliente) ON UPDATE CASCADE ;
--
-------------------------------------------------------------------------------------------------------------------
--
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
--<m>DROP TABLE IF EXISTS public.tmp_mfj_01_tb_05_a_boleto_basico ;
CREATE TABLE public.tmp_mfj_01_tb_05_a_boleto_basico (
id_contrato int NOT NULL,
id_cliente int NOT NULL,
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
CREATE INDEX idx_tb05_01_idcontr ON tmp_mfj_01_tb_05_a_boleto_basico USING btree (id_contrato) ;
CREATE INDEX idx_tb05_02_idcli ON tmp_mfj_01_tb_05_a_boleto_basico USING btree (id_cliente) ;
CREATE INDEX idx_tb05_03_numcontr ON tmp_mfj_01_tb_05_a_boleto_basico USING btree (num_contr) ;
CREATE INDEX idx_tb05_04_cpfcnpj ON tmp_mfj_01_tb_05_a_boleto_basico USING btree (num_cpf_cnpj) ;
CREATE INDEX idx_tb05_05_codoperador ON tmp_mfj_01_tb_05_a_boleto_basico USING btree (cod_operador) ;
CREATE INDEX idx_tb05_06_emissao ON tmp_mfj_01_tb_05_a_boleto_basico USING btree (dat_emissao_boleto) ;
CREATE INDEX idx_tb05_07_vencto ON tmp_mfj_01_tb_05_a_boleto_basico USING btree (dat_vencto_boleto) ;
CREATE INDEX idx_tb05_08_pagto ON tmp_mfj_01_tb_05_a_boleto_basico USING btree (dat_pagamento) ;
CREATE INDEX idx_tb05_09_emp_cpfcnpj ON tmp_mfj_01_tb_05_a_boleto_basico (num_cpf_cnpj, cod_empresa) ;
CREATE INDEX idx_tb05_10_numcontr_ent ON tmp_mfj_01_tb_05_a_boleto_basico (num_contr, cod_empresa, cod_credor, cod_entid_credor) ;
CREATE INDEX idx_tb05_11_numcontr_cred ON tmp_mfj_01_tb_05_a_boleto_basico (num_contr, cod_empresa, cod_credor) ;
--<m--::: VINCULOS {REFERENCES} :::-->--
--id_contrato = {tmp_mfj_01_id_02_a_contrato}
ALTER TABLE public.tmp_mfj_01_tb_05_a_boleto_basico
ADD CONSTRAINT fkey_tb_05_a_boleto_basico_id_contrato
FOREIGN KEY (id_contrato)
REFERENCES public.tmp_mfj_01_id_02_a_contrato (id_contrato) ON UPDATE CASCADE ;
--id_cliente = {tmp_mfj_01_id_01_a_cliente}
ALTER TABLE public.tmp_mfj_01_tb_05_a_boleto_basico
ADD CONSTRAINT fkey_tb_05_a_boleto_basico_id_cliente
FOREIGN KEY (id_cliente)
REFERENCES public.tmp_mfj_01_id_01_a_cliente (id_cliente) ON UPDATE CASCADE ;
--
-------------------------------------------------------------------------------------------------------------------
--
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
--<m>DROP TABLE IF EXISTS public.tmp_mfj_01_tb_06_a_foto_diaria ;
CREATE TABLE public.tmp_mfj_01_tb_06_a_foto_diaria (
--:::{Key}:::--
dt_foto date NOT NULL,
id_foto int NOT NULL,
dat_ent_contr date NOT NULL,
--:::{Identificadores}:::--
per_ent_contr int NOT NULL,
id_contrato int NOT NULL,
id_cliente int NOT NULL,
id_carteira int NOT NULL,
id_status_ctt int NULL,
id_fx_flux_estoq int NULL,
id_atraso int NULL,
id_historico int NULL,
--:::{Parcela}:::--
atraso int NULL,
menor_vcto date NULL,
maior_vcto date NULL,
maior_dt_vencido date NULL,
ult_parc_pg int NULL,
menor_parc int NULL,
maior_parc int NULL,
qtd_parc_ab int NULL,
menor_vlr_parc numeric(15,6) NULL,
med_vlr_parc numeric(15,6) NULL,
maior_vlr_parc numeric(15,6) NULL,
vlr_risco_parc numeric(15,6) NULL,
vlr_vencido numeric(15,6) NULL,
vlr_a_vencer numeric(15,6) NULL,
--:::{Historico - Ultimo da Foto}:::--
id_cod_hst int NULL,
dat_data_hist timestamp NULL,
d_defasagem int NULL,
cod_user int NULL
) WITH (OIDS=TRUE);
CREATE UNIQUE INDEX pkey_01_tb06_id_foto ON tmp_mfj_01_tb_06_a_foto_diaria (dt_foto, id_foto, dat_ent_contr) ;
CREATE INDEX idx_tb06_01_dtfoto ON tmp_mfj_01_tb_06_a_foto_diaria USING btree (dt_foto) ;
CREATE INDEX idx_tb06_02_idfoto ON tmp_mfj_01_tb_06_a_foto_diaria USING btree (id_foto) ;
CREATE INDEX idx_tb06_03_dtent_ctt ON tmp_mfj_01_tb_06_a_foto_diaria USING btree (dat_ent_contr) ;
CREATE INDEX idx_tb06_04_idctt ON tmp_mfj_01_tb_06_a_foto_diaria USING btree (id_contrato) ;
CREATE INDEX idx_tb06_05_idcli ON tmp_mfj_01_tb_06_a_foto_diaria USING btree (id_cliente) ;
CREATE INDEX idx_tb06_06_idcart ON tmp_mfj_01_tb_06_a_foto_diaria USING btree (id_carteira) ;
CREATE INDEX idx_tb06_07_idsts_ctt ON tmp_mfj_01_tb_06_a_foto_diaria USING btree (id_status_ctt) ;
CREATE INDEX idx_tb06_08_id_flx_estoq ON tmp_mfj_01_tb_06_a_foto_diaria USING btree (id_fx_flux_estoq) ;
CREATE INDEX idx_tb06_09_idfoto ON tmp_mfj_01_tb_06_a_foto_diaria USING btree (id_atraso) ;
CREATE INDEX idx_tb06_10_idhst ON tmp_mfj_01_tb_06_a_foto_diaria USING btree (id_historico) ;
CREATE INDEX idx_tb06_11_id_codhst ON tmp_mfj_01_tb_06_a_foto_diaria USING btree (id_cod_hst) ;
CREATE INDEX idx_tb06_12_id_coduser ON tmp_mfj_01_tb_06_a_foto_diaria USING btree (cod_user) ;
CREATE INDEX idx_tb06_13_idft_dtft ON tmp_mfj_01_tb_06_a_foto_diaria (dt_foto, id_foto) ;
--<m--::: VINCULOS {REFERENCES} :::-->--
--SOMENTE ID FOTO --- OS DEMAIS NAO VOU TRAVAR
--id_foto = {tmp_mfj_01_id_03_a_foto_diaria}
ALTER TABLE public.tmp_mfj_01_tb_06_a_foto_diaria
ADD CONSTRAINT fkey_tb_06_a_foto_diaria_id_foto
FOREIGN KEY (id_foto)
REFERENCES public.tmp_mfj_01_id_03_a_foto_diaria (id_foto) ON UPDATE CASCADE ;
--
-------------------------------------------------------------------------------------------------------------------
--