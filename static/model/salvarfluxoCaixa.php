<?php

	$getJson =  json_decode($_POST['jsonParam'], true);
	$getJsonItem  =  json_decode($_POST['jsonParamItem'], true);

	$id = $getJson['id_fluxoCaixa']; 

	require('acesso.php');	

	if ($id != 0) {
		$sql = "call prc_deletar_fluxoCaixa('$id');" ;

		$result = $conn->query($sql);

		if(!$result) {
			echo(mysqli_error($conn));
			return ; 
		}
	}
	
    $parcelas = 0; 
    $valorCadaParcela = $getJson['valor'];

	if ($getJson['meioPgto'] == 'CR') {
        $parcelas = $getJson['parcelas']; 
        $valorCadaParcela  = $getJson['valor'] / $parcelas; 
	} 

    $getJson['dataHora'] = date("Y-m-d H:i:s", strtotime($getJson['dataHora']));   
    $id_principal = 0 ; 
    
    for ($idx = 0; $idx <= $parcelas; $idx++) {

        $parametros = "";
        foreach ($getJson as $value) {
            $parametros .= utf8_decode("'{$value}',");
        }

        $parametros = substr($parametros, 0, -1);
        $sql = "call prc_atualizar_fluxoCaixa ($parametros);";

        $result = mysqli_query($conn, $sql);

        if(!$result) {
           echo(mysqli_error($conn));
           return;
        }

	    $row = mysqli_fetch_array($result);
        $id = $row['id']; 
	    
	    if ($id_principal == 0) {
	       $id_principal = $id ;
	    }
	    
        free_all_results($conn) ; 
        //  mysqli_free_result($result);  

        $getJson['id_fluxoCaixa'] = 0 ; 
        $getJson['id_parcela'] = $idx+1;     
        $getJson['valor'] = $valorCadaParcela; 
        $getJson['id_principal'] = $id_principal; 
        $getJson['dataHora'] = substr($getJson['dataHora'],0,8).$getJson['diaPgtoCartao'].' '.substr($getJson['dataHora'],10);
        $getJson['dataHora'] = date("Y-m-d H:i:s", strtotime("+1 month", strtotime($getJson['dataHora'])));

        foreach ($getJsonItem as $item) {
            if ($item['valor'] != 0 ) {
				$item['id_fluxoCaixa'] = $id ; 
				$parametros = "";
				foreach ($item as $value) {
					 $parametros .= utf8_decode("'$value',");           	
				}
				$parametros = substr($parametros, 0, -1);        
				$sql = "call prc_atualizar_fluxoCaixaItem ($parametros);";

				$result = $conn->query($sql);

				if(!$result) {
				   echo(mysqli_error($conn));
				   return;
				}

				free_all_results($conn) ;
				//  mysqli_free_result($result);   	   
            } 
        }                
    }
    
    $conn->close();

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
