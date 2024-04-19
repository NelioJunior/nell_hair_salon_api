<?php

	$codigo =  $_POST['id_funcionario'];  
	
	require('acesso.php');	
	
	$sql = "call prc_deletar_funcionario_especialidade('$codigo');" ;
	
	$result = $conn->query($sql);

	if(!$result) {
		echo(mysqli_errno($conn));
	}
					
	$conn->close();
		
?>