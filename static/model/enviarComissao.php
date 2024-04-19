<?php 
	
	header('Content-Type: text/html; charset=utf-8'); 

	require('acesso.php');	

	$conn->set_charset("utf8");
	
	$id = $_GET["id"];
	
	$matriz =  explode("/", dirname($_SERVER['PHP_SELF']));
	$folder = $matriz[count($matriz)-1 ];
				
	$query  = "call prc_enviar_comissao('$id');" ;

	$result = mysqli_query($conn, $query);

    if(!$result) {
       echo(mysqli_error($conn));
       return;
    }

	$rows = array();

	while($each = mysqli_fetch_assoc($result)){
		$each['pasta'] = $folder;
		$rows[] = $each;			
	}

	file_put_contents('../../fila/enviarComissao.json', json_encode($rows));		
	
	$conn->close();
	echo $id;	
?>