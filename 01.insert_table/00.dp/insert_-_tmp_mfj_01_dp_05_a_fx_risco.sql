--
-------------------------------------------------------------------------------------------------------------------
--
-->Faixa de Risco:
--{05} = {tmp_mfj_01_dp_05_a_fx_risco}
    /*
        05 = {tmp_mfj_01_dp_05_a_fx_risco}
                {
                    >Faixa de Risco:
                        [id_risco] = identificador
                        [fx_risco] = faixa de risco {divisao por faixa de valores}
                        [fx_risco_res] = faixa resumida de risco {Nulo, Baixo, Médio, Médio-Alto, Alto, Alto Impacto}
                }><m
    */
--
--SELECT * FROM public.tmp_mfj_01_dp_05_a_fx_risco;
INSERT INTO public.tmp_mfj_01_dp_05_a_fx_risco 
( id_risco, fx_risco, fx_risco_res )
VALUES
( 1, '01.Risco 0-50', '00.Risco Nulo' ), 
( 2, '02.Risco 51-100', '00.Risco Nulo' ), 
( 3, '03.Risco 101-1.000', '01.Risco Baixo' ), 
( 4, '04.Risco 1.001-5.000', '01.Risco Baixo' ), 
( 5, '05.Risco 5.001-10.000', '02.Risco Médio' ), 
( 6, '06.Risco 10.001-20.000', '02.Risco Médio' ), 
( 7, '07.Risco 20.001-50.000', '03.Risco Médio-Alto' ), 
( 8, '08.Risco 50.001-100.000', '04.Rico Alto' ), 
( 9, '09.Risco 100.001-200.000', '05.Risco Alto Impacto' ), 
( 10, '10.Risco 200.001-999.999', '05.Risco Alto Impacto' )
;
--
-------------------------------------------------------------------------------------------------------------------
--