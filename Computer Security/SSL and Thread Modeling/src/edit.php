<?php session_start() ;	


include("protection.php");
$con = mysql_connect("localhost","root","root");
mysql_select_db("secu3",$con);
$adresseMail = $_SESSION['email'];

//si l'utilisateur veut modifier son profile on verifie les informations entrées	
if (isset($_POST['action']) && $_POST['action']=="edit")
{
	//utilisation de la fonction de blindage pour éviter les injections sql et javascript
	//hashage md5 des mots de passe
	$ancienMdp = md5(blindage($_POST['ancienMdp']));
	
	if($_POST['mdp']!="" && $_POST['mdpconf']!=""){
		$motDePasse= md5(blindage($_POST['mdp']));
		$mdpconf = md5(blindage($_POST['mdpconf']));
	}
	$pseudo=blindage($_POST['pseudo']);
	$ville=blindage($_POST['ville']);
	$pays=blindage($_POST['pays']);
	$rue = blindage($_POST['rue']);
	$numero= blindage($_POST['numero']);
	$codepostal = blindage($_POST['codepostal']);
	$nom = blindage($_POST['nom']);
	$prenom = blindage($_POST['prenom']);
	$telephone = blindage($_POST['telephone']);
	$fax = blindage($_POST['fax']);
	
	$reponse = mysql_query("select motdepasse from utilisateur WHERE email = '$adresseMail'",$con) or die(mysql_error());
	
	$mdpOk = false;	
	//verifie si l'ancien mot de passe correspond
	while ($donnees = mysql_fetch_array($reponse))
	{
		if ($ancienMdp==$donnees["motdepasse"])
		{
			$mdpOk=true;
			break;
		}
	}
	//si il y a assez d'entrées et que les mots de passe correspondent et que l'ancien mdp est ok alors on met à jours ses données dans la base
	if ( $ancienMdp != '' && $pseudo != '' && $mdpOk == true){
		if($_POST['mdp']!="" && $_POST['mdpconf']!=""){
			if($motDePasse == $mdpconf){
				
				mysql_query("UPDATE utilisateur SET motdepasse='$motDePasse', pseudo='$pseudo', ville='$ville', pays='$pays', codepostal='$codepostal', rue='$rue', numero='$numero',nom='$nom',prenom='$prenom',telephone='$telephone',fax='$fax' WHERE email='$adresseMail'",$con) or die (mysql_error());
				echo "modifications enregistrees";
				}
			elseif($motDePasse != $mdpconf)
				echo "Les deux mots de passes ne correspondent pas";
		}
		else
		{
				mysql_query("UPDATE utilisateur SET motdepasse='$ancienMdp', pseudo='$pseudo', ville='$ville', pays='$pays', codepostal='$codepostal', rue='$rue', numero='$numero',nom='$nom',prenom='$prenom',telephone='$telephone',fax='$fax' WHERE email='$adresseMail'",$con) or die (mysql_error());
				echo "modifications enregistrees";
		}
		
	}
	elseif($mdpOk == false)
		echo "L'ancien mot de passe est faux";			
}


$query = mysql_query("SELECT * FROM utilisateur WHERE email='$adresseMail'",$con) or die(mysql_error());
while ($donnees = mysql_fetch_array($query))
{
	//on récupère les données pour afficher les champs pré remplis
	if ($adresseMail==$donnees['email'])
	{
		$pseudo2=$donnees['pseudo'];
		$ville2=$donnees['ville'];
		$pays2= $donnees['pays'];
		$rue2 = $donnees['rue'];
		$numero2= $donnees['numero'];
		$codepostal2 = $donnees['codepostal'];
		$nom2 = $donnees['nom'];
		$prenom2 = $donnees['prenom'];
		$telephone2 =$donnees['telephone'];
		$fax2 = $donnees['fax'];	
		break;
	}
}
	mysql_close();

?>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="fr" >
   <head>
       <title>SQL injection</title>
		<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
	   <link rel="stylesheet" media="screen" type="text/css" title="Design" href="accueil.css" />
   </head>
   <body>
	<form method="post" action="edit.php">
	
	<fieldset>
	<legend>Modifier votre profile</legend> 
		
	   <input type="hidden" name="action" value="edit"/>
       
       <label for="pseudo">Pseudo</label> : <input type="text" name="pseudo" id="pseudo" value="<?php echo $pseudo2 ?>" /><br />
       <label for="ancienMdp">Mot de passe*</label> : <input type="password" name="ancienMdp" id="ancienMdp"  /><br />
	   <label for="mdp">Nouveau mot de passe</label> : <input type="password" name="mdp" id="mdp"  /><br />
	   <label for="mdpconf">Nouveau mot de passe (Confirmation)</label> : <input type="password" name="mdpconf" id="mdpconf"  /><br />
	   
	   <label for="nom">Nom</label> : <input type="text" name="nom" id="nom" value="<?php echo $nom2 ?>"/><br />
	   <label for="prenom">Prénom</label> : <input type="text" name="prenom" id="prenom" value="<?php echo $prenom2 ?>"/><br />
	   <label for="telephone">Numéro de téléphone</label> : <input type="text" name="telephone" id="telephone" value="<?php echo $telephone2 ?>" /><br />
	   <label for="fax">Numéro de fax</label> : <input type="text" name="fax" id="fax" value="<?php echo $fax2 ?>" /><br />
	   
	   <fieldset>
	       <legend>Votre Adresse (optionel)</legend> 
		   <label for="numero">Numéro de rue</label> : <input type="text" name="numero" id="numero" value="<?php echo $numero2 ?>" /><br />
		   <label for="rue">Rue</label> : <input type="text" name="rue" id="rue" value="<?php echo $rue2 ?>"/><br />
		   <label for="ville">Ville</label> : <input type="text" name="ville" id="ville" value="<?php echo $ville2 ?>"/><br />
		   <label for="codepostal">Code Postal</label> : <input type="text" name="codepostal" id="codepostal" value="<?php echo $codepostal2 ?>"/><br />
		   <label for="pays">Pays</label> : <input type="text" name="pays" id="pays" value="<?php echo $pays2 ?>"/><br />
	   </fieldset>   	
       <input type="submit" />	
	</fieldset>
	    
	</form>
	<form method="post" action="accueil.php">
		<input type="hidden" name="email" value="<?php echo $adresseMail?>" />
	 <input type="submit" value="connexion" onclick="accueil.php"/>
	 </form>
	</body>
</html> 	