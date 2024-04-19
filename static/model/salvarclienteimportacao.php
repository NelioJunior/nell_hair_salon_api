<?php

 	$getJson =  json_decode($_POST['jsonParametros']);

	$avatar =  $getJson->{'avatar'} ;
	
	if (substr($avatar, -4) != ".png") {		
		echo "Formato de arquivo de imagem não reconhecido.\ntipo permitido de avatar é o PNG";
		return;				
	}   

	require('acesso.php');	

	$conn->set_charset("utf8");
	
    $telefone = $getJson->{'telefone'};  

    $query = "select * from cliente where telefone = '$telefone' limit 1;";

    $result = $conn->query($query);

    $row = mysqli_fetch_assoc($result);

    if(trim($row['id_cliente']) != "") {
    	$getJson->{'id_cliente'} = $row['id_cliente']; 
		$getJson->{'aniversario'} = $row['aniversario']; 
		$getJson->{'genero'} = $row['genero']; 		
		$getJson->{'observacaoCli'} = $row['observacaoCli']; 
    }

    $parametros = "";

    foreach ($getJson as $value) {
        $parametros .= "'{$value}',";
    }
    
    $parametros = substr($parametros, 0, -1);
        
    $sql = "call prc_atualizar_cliente ($parametros)";

	try {	
		$conn->query($sql) ; 	
	} catch (PDOException $e){
		echo $e->getMessage();
	}
		
	$conn->close();

	// echo $sql;
		
	/* Salvamento da avatar para o repositorio no servidor */
	
	$fileNome = $_POST['fileNome'];
	if ($fileNome != "") {
		$img = $_POST['imgBase64'];
		$img = str_replace('data:image/png;base64,', '', $img);
		$img = str_replace(' ', '+', $img);
		$fileData = base64_decode($img);
			
		$target_dir = "./cliente/";	
		$target_file = $target_dir . $fileNome;		
		file_put_contents($target_file, $fileData);			
	}		
		
?>