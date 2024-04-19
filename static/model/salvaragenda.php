<?php

    setlocale(LC_TIME, 'pt_BR', 'pt_BR.utf-8', 'pt_BR.utf-8', 'portuguese');
    date_default_timezone_set('America/Sao_Paulo');

    //python 
    $getJson = json_decode(file_get_contents("php://input"), true);

    
    //php  
    if (isset($_POST["jsonParametros"])) {
        $getJson = json_decode($_POST['jsonParametros'], true);
        $dataPesquisa = $_POST['dataPesquisa'];		
    }	

    if ($getJson === null) {
        echo "Erro ao decodificar o JSON";
        return;
    }

    $getJsonOriginal = $getJson;

    unset($getJson["itensSelecionados"]);


    $id_agenda =  $getJson["id_agenda"];  
    $id_agenda_original = $getJson["id_agenda_original"];
    $totalTempoNecessarioPorSessao = 30; 
    $totalSessoes = $getJson["totalSessoes"];
    $idCliente = $getJson["id_cliente"];
    $idFuncionario = $getJson["id_funcionario"];	
    $dataHoraInicio = date_create($getJson["dataHoraInicio"]);  
    $dataHoraFim = date_create($getJson["dataHoraFim"]); 

    $afetarVariasSessoes = false ; 
    if ($getJson["sessaoNumero"] == 1 and $totalSessoes != 1) {
        $afetarVariasSessoes =  true;	    	
    } 

    require('acesso.php');	


    if ($idCliente != "0") {
      	$conn->autocommit(false);    	
    }

    $conn->set_charset("utf8");
		
    if ($totalSessoes > 1 and $id_agenda != 0 and $id_agenda_original == 0) {
	$sql = "call prc_deletar_agenda('$id_agenda');" ;
	$result = $conn->query($sql);
        $getJson["id_agenda"] = 0;

	if(!$result) {
	   echo(mysqli_error($conn));
	   return;
	}
	free_all_results($conn) ;     	
    }

    $sql  = "call prc_buscar_feriado('1');" ;			

    $result = $conn->query($sql) ; 	
    $feriadosLst = array();

    while($each = mysqli_fetch_assoc($result)){
	array_push($feriadosLst, $each);
    }
	
    free_all_results($conn) ;
			
    $sql  = "call prc_buscar_compromissos_funcionarios;" ;			

    $result = $conn->query($sql); 	

    $compromissosFuncionariosLst = array();

    while($each = mysqli_fetch_assoc($result)){
        if ($each['id_funcionario'] == $idFuncionario) {
           array_push($compromissosFuncionariosLst, $each);        	
        }
    }

    free_all_results($conn);

    $sql  = "call prc_buscar_funcionario(1);" ;			

    $result = $conn->query($sql); 	

    $infoFuncionarioLst = array();

    while($each = mysqli_fetch_assoc($result)){
         if ($each['id_funcionario'] == $idFuncionario) {
                array_push($infoFuncionarioLst, $each);        	
         }
    }

    free_all_results($conn); 

    for ($idx = 1; $idx <= $totalSessoes; $idx++) {
         
	$totalTempoNecessarioPorSessao = 0; 
	foreach ($getJsonOriginal["itensSelecionados"] as $count => $itensSelecionado ) {
		if ($idx > $itensSelecionado['sessoes']) {
			unset($getJsonOriginal[$count]);
		} else {
			$totalTempoNecessarioPorSessao += $itensSelecionado['tempoNecessarioPorSessao'];
		}
	}

	$dataHoraFim = clone $dataHoraInicio;
	date_add($dataHoraFim, date_interval_create_from_date_string("$totalTempoNecessarioPorSessao minutes"));

	if ($dataPesquisa != date_format($dataHoraInicio,"Y-m-d") or $idx > 1) {
		$retorno = validar($getJson, $idx, $conn) ;
		if ($retorno != "") {
			echo $retorno;
			return;
		}        	        	
	} 
                  
        $parametros = "";

        foreach ($getJson as $value) {
            $parametros .= utf8_decode("'{$value}',");
        }

        $parametros = substr($parametros, 0, -1);    
        $sql = "call prc_atualizar_agenda ($parametros);"; 
             	                                                                   
        free_all_results($conn);
        $result = $conn->query($sql);

	$row = mysqli_fetch_array($result);
	$id_agenda =  $row['id'];

        if ($idx == 1) {
           $getJson["id_agenda_original"] = $id_agenda;	
        }    	
		
        foreach ($getJsonOriginal["itensSelecionados"] as $itensSelecionado ) {
            $id_especialidade = $itensSelecionado['id_especialidade'];

            if ($idx > $itensSelecionado['sessoes']) {
                unset($getJsonOriginal[$count]);
            } else {
                $sql = "call prc_atualizar_agenda_especialidade ('$id_agenda', '$id_especialidade');";  
		
                free_all_results($conn) ;                 
                $result = $conn->query($sql) ; 
		    if(!$result) {
		         echo(mysqli_error($conn));
		         return;
		    }                	
    		} 
    	}

        if ($afetarVariasSessoes == false) {
        	break; 
        }    						

    }                                                                               

    $conn->commit();
    $conn->close();

    echo $getJson["id_agenda_original"];

    function abortarOperacao($id_agenda, $nomeCliente , $diaConflito, $conn, $msg) {
    	$conn->rollback();

    	$retorno = "";

        if ($msg != "") {
        	$retorno = $msg; 
        } elseif ($nomeCliente == "") {
       	   $retorno = "A funcionária se encontrará indisponível neste horários no dia $diaConflito." ;
        } else {
    	   $retorno = "Houve um conflito de horários no dia $diaConflito,cujo cliente é $nomeCliente." ;       	
        }

        return $retorno;
    }

    function validar(&$getJson, $idx, $conn) {

        global $feriadosLst, $infoFuncionarioLst, $compromissosFuncionariosLst, $afetarVariasSessoes, $id_agenda, $totalSessoes, $idCliente, $idFuncionario, $dataHoraInicio, $dataHoraFim ;
 	
		$totalPreco = $getJson["totalPreco"];
		$parcelarPrecoPorSessao = $getJson["parcelarPrecoPorSessao"];

		$retorno = "";

		if ($afetarVariasSessoes and $idx > 1) {				
			$flagFicarEmLooping = true;            
			while ($flagFicarEmLooping) {
								
				date_add($dataHoraInicio,date_interval_create_from_date_string("7 days"));
				date_add($dataHoraFim,date_interval_create_from_date_string("7 days"));   

				$flagFicarEmLooping = false;  
				foreach ($feriadosLst as $item) {
					if (substr($item["dataFeriado"],0,10) == date_format($dataHoraInicio,"Y-m-d")){
						$flagFicarEmLooping = true ;      
						break;  
					}
				}

				if ($flagFicarEmLooping == false) {
					foreach ($compromissosFuncionariosLst as $item) {					
						if ($item["dataHoraInicio"] >= date_format($dataHoraInicio,"Y-m-d H:i:s") and $item["dataHoraInicio"] < date_format($dataHoraFim,"Y-m-d H:i:s")){
							$flagFicarEmLooping = true ;
							break ;       
						}
						if ($item["dataHoraFim"] > date_format($dataHoraInicio,"Y-m-d H:i:s") and $item["dataHoraFim"] <= date_format($dataHoraFim,"Y-m-d H:i:s")){
							$flagFicarEmLooping = true ;
							break ;       
						}
					}
				}
			} 

			$getJson["dataHoraInicio"] = date_format($dataHoraInicio,"Y-m-d H:i:s");

			if ($idx > 1) {
				 $getJson["dataHoraFim"] = date_format($dataHoraFim,"Y-m-d H:i:s");                	
			}

			$getJson["sessaoNumero"] = $idx; 


			if ($idx > 1 and $parcelarPrecoPorSessao == false ) {
				$getJson["totalPreco"] = 0;                   
			}

						
		} else {

			$flag = false;
			$diaSemanaSelecionado = strftime('%A', strtotime($getJson["dataHoraInicio"]));
			$diaSemanaSelecionadoAbreviado  = substr($diaSemanaSelecionado,0,3);

			if ($diaSemanaSelecionadoAbreviado == "dom") {
				if ($infoFuncionarioLst[0]["domingo"] == "0") {      
					$flag = true;  	                              
				}
			} 
			elseif  ($diaSemanaSelecionadoAbreviado == "seg") {       	                                              
				if ($infoFuncionarioLst[0]["segunda"] == "0") {      
					$flag = true;  	  	                              
				}
			} 
			elseif  ($diaSemanaSelecionadoAbreviado == "ter") {
				if ($infoFuncionarioLst[0]["terca"] == "0") {      
					$flag = true;  	 	                              
				}

			} 
			elseif  ($diaSemanaSelecionadoAbreviado == "qua") {
				if ($infoFuncionarioLst[0]["quarta"] == "0") {      
					$flag = true;  	  	                              
				}        	
			} 
			elseif  ($diaSemanaSelecionadoAbreviado == "qui") {
				if ($infoFuncionarioLst[0]["quinta"] == "0") {      
					$flag = true;  	   	                              
				}        	
			} 
			elseif  ($diaSemanaSelecionadoAbreviado == "sex") {
				if ($infoFuncionarioLst[0]["sexta"] == "0") {      
					$flag = true;  	   	                              
				}        	
			} 
			elseif  ($diaSemanaSelecionadoAbreviado == "sab") {
				if ($infoFuncionarioLst[0]["sabado"] == "0") {      
				   $flag = true;  	  	                              
				}        	
			}    

			if ($flag) {
				 $msg = "Profissional indisponível nos dias de $diaSemanaSelecionado. Selecione outro dia";
				 $retorno = abortarOperacao($id_agenda, "" , "", $conn, $msg);
				 return $retorno;       	
			} 

			foreach ($feriadosLst as $itemFeriado) {
				if (substr($itemFeriado["dataFeriado"],0,10) == date_format($dataHoraInicio,"Y-m-d")){
					$msg = "O dia escolhido é feriado, {$itemFeriado['nome']}. Escolha um outro dia."; 
					$retorno =  abortarOperacao($id_agenda, "" , "", $conn, $msg); 				
					return $retorno;  	
				}
			}

			foreach ($compromissosFuncionariosLst as $itemCompromisso) {

				if ($itemCompromisso["id_agenda"] != $id_agenda) {

					$flag = false ;

					if ($itemCompromisso["dataHoraInicio"] >= date_format($dataHoraInicio,"Y-m-d H:i:s") and $itemCompromisso["dataHoraInicio"] < date_format($dataHoraFim,"Y-m-d H:i:s")){
						$flag = true;
					}
					if ($itemCompromisso["dataHoraFim"] > date_format($dataHoraInicio,"Y-m-d H:i:s") and $itemCompromisso["dataHoraFim"] <= date_format($dataHoraFim,"Y-m-d H:i:s")){
						$flag = true;   
					}

					if ($flag) {
						$retorno =  abortarOperacao($id_agenda, $itemCompromisso['nomeCliente'] , date_format($dataHoraInicio,"d-m-Y"), $conn, ""); 
						break;
					}
				}                         
			}			
		}

		return $retorno;  	
    } 


	/* 
		supostamente o MariaDB esta com um "infamous error number 2014" 
		esta função resolve este problema. 

		                                           Nell - Novembro / 2019     
	*/

	function free_all_results(mysqli $dbCon)
	{
		do {
			if ($res = $dbCon->store_result()) {
				$res->fetch_all(MYSQLI_ASSOC);
				$res->free();
			}
		} while ($dbCon->more_results() && $dbCon->next_result());
	}

?>
