<?php

	$codigo =  $_POST['id_especialidade'];  
	
	require('acesso.php');	
	
	$sql = "call prc_deletar_especialidade('$codigo');" ;
	
	$result = $conn->query($sql);

	if(!$result) {
		echo(mysqli_errno($conn));
	}
					
	$conn->close();
		
?>