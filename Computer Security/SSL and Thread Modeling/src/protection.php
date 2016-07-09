
<?php

//permet de se proteger des injection sql et javascript
function blindage($champ){
  	//si le champ est un type numérique on laisse tel quel
  	if (ctype_digit($champ))
		$temp = $champ;
	else	
		$temp = mysql_real_escape_string(htmlentities($champ));
	return $temp;
}




/*

FONCTIONS DE CRYPTAGE DE DONNEES AVEC MCRYPT
function crypt($cleartext){
 
 	 On calcule la taille de la clé pour l'algo triple des
 	$cle_taille = mcrypt_module_get_algo_key_size(MCRYPT_3DES);
 	$cle ="AlVin corporation";
 	 On retaille la clé pour qu'elle ne soit pas trop longue
 	$cle = substr($cle, 0, $cle_taille);
	$algo = MCRYPT_3DES; 
	$mode = MCRYPT_MODE_CBC;
	$iv_taille = mcrypt_get_iv_size($algo, $mode); 
	$iv = mcrypt_create_iv($iv_taille, MCRYPT_RAND); 
	$crypttext = mcrypt_encrypt($algo, $cle, $cleartext, $mode, $iv);
	return $crypttext;
}

function decrypt($crypttext){
	 On calcule la taille de la clé pour l'algo triple des
	$cle_taille = mcrypt_module_get_algo_key_size(MCRYPT_3DES);
	$cle ="AlVin corporation";
	 On retaille la clé pour qu'elle ne soit pas trop longue
	$cle = substr($cle, 0, $cle_taille);
	$algo = MCRYPT_3DES; 
	$mode = MCRYPT_MODE_CBC;
	$iv_taille = mcrypt_get_iv_size($algo, $mode); 
	$iv = mcrypt_create_iv($iv_taille, MCRYPT_RAND); 
	$cleartext = mcrypt_decrypt($algo, $cle, $crypttext, $mode, $iv);
	return $cleartext;
	
}
*/

?>


