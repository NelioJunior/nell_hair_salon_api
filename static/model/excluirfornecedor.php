<?php

	$codigo =  $_POST['id_fornecedor'];  
	
	require('acesso.php');	
	
	$sql = "call prc_deletar_fornecedor('$codigo');" ;
	
	$result = $conn->query($sql);

	if(!$result) {
		echo(mysqli_errno($conn));
	}
					
	$conn->close();
		
?>