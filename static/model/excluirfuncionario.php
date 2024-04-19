<?php

	$codigo =  $_POST['id_funcionario'];  
	
	require('acesso.php');	
	
	$sql = "call prc_deletar_funcionario('$codigo');" ;
	
	$result = $conn->query($sql);

	if(!$result) {
		echo(mysqli_error($conn));
	}
						
	$conn->close();
		
?>