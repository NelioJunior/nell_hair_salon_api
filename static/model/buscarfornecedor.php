<?php 
	
	header('Content-Type: text/html; charset=utf-8'); 

	require('acesso.php');	

	$conn->set_charset("utf8");
	
	$apenasAtivos = $_GET["apenasAtivos"];
			
	$query  = "call prc_buscar_fornecedor('$apenasAtivos');" ;
			
	$result = mysqli_query($conn, $query);

	$rows = array();

	while($each = mysqli_fetch_assoc($result)){
		$rows[] = $each;
	}

	echo json_encode($rows); 
	
	$conn->close();
		
?>

