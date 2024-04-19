<?php

	$codigo =  $_POST['id_produto'];  
	
	require('acesso.php');	
	
	$sql = "call prc_deletar_produto('$codigo');" ;
	
	$result = $conn->query($sql);

	if(!$result) {
		echo(mysqli_errno($conn));
	}
					
	$conn->close();
		
?>