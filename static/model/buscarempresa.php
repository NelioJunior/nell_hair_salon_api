<?php 
	/*
	
		Teste:  	
				http://localhost/mysite/empresasParceirosNell/gestorPai_SalaoConsultorio/buscarempresa.php?apenasAtivos=1
				
			Onde:  

				apenasAtivos = 1 Exibe SÓ os registros ativos, 0 exibe todos.

		   
		   Importante:


		      Palhativamente , os updates serao direcionados para ../model/jsonFiles/configuracao.json  e para a tabela empresa no mysql - Nell Jr - Jan/24
	
	*/

	
	header('Content-Type: text/html; charset=utf-8'); 

	require('acesso.php');	

	$conn->set_charset("utf8");
	
	$apenasAtivos = $_GET["apenasAtivos"];
			
	$query  = "call prc_buscar_empresa('$apenasAtivos');" ;
			
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

