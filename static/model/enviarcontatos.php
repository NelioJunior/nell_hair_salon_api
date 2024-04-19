<?php
	
	$jsonItem = json_decode(file_get_contents("php://input"));	
    $jsonPrincipal = json_decode(file_get_contents('./jsonFiles/contatos.json'));

	$blnNotFound = true;	
		
	foreach($jsonPrincipal as $item)	{			
		if($item->telefone == $jsonItem->telefone) {								
			$blnNotFound = false;        
			break;	
		}
	}	
	
	if ($blnNotFound) {
		array_push($jsonPrincipal, $jsonItem);	
	}		

	$jsonPrincipal = json_encode($jsonPrincipal);

    $jsonPrincipal = json_decode($jsonPrincipal, true);
    
    $sort = array();
    foreach($jsonPrincipal as $k => $v) {
        $sort['nome'][$k] = $v['nome'];
    }
   
    array_multisort($sort['nome'], SORT_ASC,$jsonPrincipal);

	file_put_contents('./jsonFiles/contatos.json', json_encode($jsonPrincipal));
?>
