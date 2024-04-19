<?php

	$codigo =  $_POST['id_fluxoCaixa'];  
	
	require('acesso.php');	
	
	$sql = "call prc_deletar_fluxoCaixa('$codigo');" ;
	
	$result = $conn->query($sql);

	if(!$result) {
		echo(mysqli_errno($conn));
	}
					
	$conn->close();
		
?>