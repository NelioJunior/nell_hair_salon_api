<?php

	$codigo =  $_POST['id_grupo'];  
	
	require('acesso.php');	
	
	$sql = "call prc_deletar_grupo('$codigo');" ;
	
	$result = $conn->query($sql);

	if(!$result) {
		echo(mysqli_errno($conn));
	}
					
	$conn->close();
		
?>