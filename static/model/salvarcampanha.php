<?php

    $postJson =  json_decode($_POST['jsonParametros']);
    $fileNome = $_POST['fileNome'];

    if ($fileNome != "") {
        if (substr($fileNome, -4) != ".png") {		
            echo "Formato de arquivo de imagem não reconhecido.\ntipo permitido de imagem é o PNG";
            return;				
        }   
    }

    $parametros = "";

    foreach ($postJson as $value) {
        $parametros .= utf8_decode("'{$value}',");
    }
    
    $parametros = substr($parametros, 0, -1);
        
    $sql = "call prc_atualizar_campanha ($parametros)";
	
    require('acesso.php');	

    $result = $conn->query($sql) ; 	

    if(!$result) {
       echo(mysqli_error($conn));
       return;
    }

    $row = mysqli_fetch_array($result);
    echo $row['id']; 
	
    $conn->close();
		
    /* Salvamento da imagem para o repositorio no servidor */
	
    $fileNome = $_POST['fileNome'];
    if ($fileNome != "") {
	$img = $_POST['imgBase64'];
	$img = str_replace('data:image/png;base64,', '', $img);
	$img = str_replace(' ', '+', $img);
	$fileData = base64_decode($img);

	$target_dir = "../../fila/";				
	$target_file = $target_dir . $fileNome;		
	file_put_contents($target_file, $fileData);			
    }		
		
?>
