<?php

	$codigo =  $_POST['id_campanha'];  
	
	require('acesso.php');	
	
	$sql = "call prc_deletar_campanha('$codigo');" ;
	
	$result = $conn->query($sql);

	if(!$result) {
		echo(mysqli_errno($conn));
	}
					
	$conn->close();
		
?>