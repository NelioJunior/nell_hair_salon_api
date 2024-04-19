<?php

	$codigo =  $_GET['id'];  
	
	require('acesso.php');	
	
	$sql = "call prc_deletar_grupoCliente('$codigo');" ;
	
	$result = $conn->query($sql);

	if(!$result) {
		echo(mysqli_errno($conn));
	}
					
	$conn->close();
		
?>