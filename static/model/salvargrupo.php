<?php

 	$getJson =  json_decode($_POST['jsonParametros']);
	
    $parametros = "";

    foreach ($getJson as $value) {
        $parametros .= utf8_decode("'{$value}',");
    }
    
    $parametros = substr($parametros, 0, -1);
        
    $sql = "call prc_atualizar_grupo ($parametros)";
	
	require('acesso.php');	

    $conn->query($sql) ;
		
	$conn->close();

	// echo $sql;
			
?>