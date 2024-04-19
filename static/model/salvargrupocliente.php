<?php
	
	if (isset($_POST["jsonParametros"])) {
		$getJson = json_decode($_POST['jsonParametros']);
	}	

    $parametros = "";

    foreach ($getJson as $value) {
        $parametros .= utf8_decode("'{$value}',");
    }
    
    $parametros = substr($parametros, 0, -1);
        
    $sql = "call prc_atualizar_grupoCliente ($parametros);";
	
	require('acesso.php');	
			
	try {	
		$conn->query($sql) ; 			
	} catch (PDOException $e){
		echo $e->getMessage();
	}
	
	$conn->close();
		
?>