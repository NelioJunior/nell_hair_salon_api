<?php

 	$getJson =  json_decode($_POST['jsonParametros']);

	
    $parametros = "";

    foreach ($getJson as $value) {
        $parametros .= utf8_decode("'{$value}',");
    }
    
    $parametros = substr($parametros, 0, -1);
        
    $sql = "call prc_atualizar_especialidade ($parametros)";
	
	require('acesso.php');	

	try {	
		$conn->query($sql) ; 	
	} catch (PDOException $e){
		echo $e->getMessage();
	}
		
	$conn->close();

	// echo $sql;
			
?>