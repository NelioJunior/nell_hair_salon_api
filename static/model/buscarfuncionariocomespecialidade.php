<?php 
	/*
	
		Teste:  	
				http://localhost/mysite/ClientesParceirosNell/gestorPai_SalaoConsultorio/buscarfuncionario.php?apenasAtivos=1
				
			Onde:  

				apenasAtivos = 1 Exibe SÓ os registros ativos, 0 exibe todos.
	
	*/
	
	header('Content-Type: text/html; charset=utf-8'); 

	require('acesso.php');	

	$conn->set_charset("utf8");
	
	$apenasAtivos = $_GET["apenasAtivos"];
			
	$query  = "call prc_buscar_funcionario_com_especialidade('$apenasAtivos');" ;
			
	try {	

		$result = mysqli_query($conn, $query);
			
		$rows = array();
			
		while($each = mysqli_fetch_assoc($result)){
			$rows[] = $each;
		}
						
		echo json_encode($rows); 
	
	} catch (PDOException $e){
		echo $e->getMessage();
	}
				
	$conn->close();
		
?>

