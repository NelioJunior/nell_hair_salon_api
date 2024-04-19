<?php

	$codigo =  $_POST['id_cliente'];  
	
	require('acesso.php');	
	
	$sql = "call prc_deletar_cliente('$codigo');" ;
	
	$result = $conn->query($sql);

	if(!$result) {
		echo(mysqli_errno($conn));
	}
					
	$conn->close();
		
?>