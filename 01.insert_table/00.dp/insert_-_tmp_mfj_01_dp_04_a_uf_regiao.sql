--
-------------------------------------------------------------------------------------------------------------------
--
-->Regiao / Estado:
--{04} = {tmp_mfj_01_dp_04_a_uf_regiao}
    /*
        04 = {tmp_mfj_01_dp_04_a_uf_regiao}
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
--SELECT * FROM public.tmp_mfj_01_dp_04_a_uf_regiao;
INSERT INTO public.tmp_mfj_01_dp_04_a_uf_regiao 
(id_uf, desc_uf, cod_uf, id_regiao, desc_regiao)
VALUES
(1, 'Acre', 'AC', 3, 'Região Norte'),
(2, 'Alagoas', 'AL', 2, 'Região Nordeste'),
(3, 'Amazonas', 'AM', 3, 'Região Norte'),
(4, 'Amapá', 'AP', 3, 'Região Norte'),
(5, 'Bahia', 'BA', 2, 'Região Nordeste'),
(6, 'Ceará', 'CE', 2, 'Região Nordeste'),
(7, 'Distrito Federal', 'DF', 1, 'Região Centro-Oeste'),
(8, 'Espírito Santo', 'ES', 4, 'Região Sudeste'),
(9, 'Goiás', 'GO', 1, 'Região Centro-Oeste'),
(10, 'Maranhão', 'MA', 2, 'Região Nordeste'),
(11, 'Minas Gerais', 'MG', 4, 'Região Sudeste'),
(12, 'Mato Grosso do Sul', 'MS', 1, 'Região Centro-Oeste'),
(13, 'Mato Grosso', 'MT', 1, 'Região Centro-Oeste'),
(14, 'Pará', 'PA', 3, 'Região Norte'),
(15, 'Paraíba', 'PB', 2, 'Região Nordeste'),
(16, 'Pernambuco', 'PE', 2, 'Região Nordeste'),
(17, 'Piauí', 'PI', 2, 'Região Nordeste'),
(18, 'Paraná', 'PR', 5, 'Região Sul'),
(19, 'Rio de Janeiro', 'RJ', 4, 'Região Sudeste'),
(20, 'Rio Grande do Norte', 'RN', 2, 'Região Nordeste'),
(21, 'Rondônia', 'RO', 3, 'Região Norte'),
(22, 'Roraima', 'RR', 3, 'Região Norte'),
(23, 'Rio Grande do Sul', 'RS', 5, 'Região Sul'),
(24, 'Santa Catarina', 'SC', 5, 'Região Sul'),
(25, 'Sergipe', 'SE', 2, 'Região Nordeste'),
(26, 'São Paulo', 'SP', 4, 'Região Sudeste'),
(27, 'Tocantins', 'TO', 3, 'Região Norte'),
--SEM UF:::
(99, 'Sem UF', 'SS', 9, 'Sem Região')
;
--
-------------------------------------------------------------------------------------------------------------------
--