<?php

 	$getJson =  json_decode($_POST['jsonParametros']);
	
    $parametros = "";

    foreach ($getJson as $value) {
        $parametros .= utf8_decode("'{$value}',");
    }
    
    $parametros = substr($parametros, 0, -1);
        
    $sql = "call prc_atualizar_feriado ($parametros)";
	
	require('acesso.php');	

	$result = $conn->query($sql) ; 	

    if(!$result) {
       echo(mysqli_error($conn));
       return;
    }
	
	$conn->close();

	// echo $sql;
			
?>