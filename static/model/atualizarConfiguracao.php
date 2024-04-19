<?php

    file_put_contents('./jsonFiles/configuracao.json', $_POST['jsonConfig']);

    $postJson =  json_decode($_POST['jsonConfig']);

    $parametros = "";
    foreach ($postJson as $key => $value) {
        if (is_object($value)) {
        	$value = json_encode($value);
        }    
        $parametros .= "'{$value}',";
    }

    $parametros = substr($parametros, 0, -1);
        
    $sql = "call prc_atualizar_empresa ($parametros)";

    require('acesso.php');	

    $result = $conn->query($sql) ; 	

    if(!$result) {
       echo(mysqli_error($conn));
       return;
    }

    $row = mysqli_fetch_array($result);
    echo $row['id']; 
	
    $conn->close();


?>
