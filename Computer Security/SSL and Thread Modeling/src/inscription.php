<?php
include("protection.php");
$con = mysql_connect("localhost","root","root");
mysql_select_db("secu3",$con);

//réinitialiser les champs après enregistrement
function init(){
	$_POST['email']="";
	$_POST['mdp']="";
	$_POST['mdpconf'] = "";
	$_POST['pseudo']="";
	$_POST['ville']="";
	$_POST['pays']="";
	$_POST['rue'] = "";
	$_POST['numero']= "";
	$_POST['codepostal'] = "";
	$_POST['nom'] = "";
	$_POST['prenom'] = "";
	$_POST['telephone'] = "";
	$_POST['fax'] = "";
	
}

//si l'utilisateur s'est incrit on vérifie les informations données	
if (isset($_POST['action']) && $_POST['action']=="inscrire")
{
	//utilisation de la fonction de blindage pour éviter les injections sql et javascript
	$email=blindage($_POST['email']);
	//hashage des mots de passe grâce à la fonction md5 
	$motDePasse=md5(blindage($_POST['mdp']));
	$mdpconf = md5(blindage($_POST['mdpconf']));
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
	
	$reponse = mysql_query("select * from utilisateur",$con) or die(mysql_error());
	$userExist=false;	
	//on vérifie que l'utilisateur n'existe pas déjà dans la bdd
	while ($donnees = mysql_fetch_array($reponse))
	{
		if ($email==$donnees['email'])
		{
			$userExist=true;
			break;
		}
	}
	
	//si il y a assez d'entrées et que les mots de passe correspondent et que le user exist alors on entre ses données dans la base
	if ($email!= '' && $motDePasse != '' && $pseudo != '' && !$userExist && $motDePasse == $mdpconf){
		mysql_query("INSERT INTO utilisateur (email,motdepasse,pseudo,ville,pays,codepostal,rue,numero,nom,prenom,telephone,fax) Values ('$email','$motDePasse','$pseudo','$ville','$pays','$codepostal','$rue','$numero','$nom','$prenom','$telephone','$fax')",$con) or die (mysql_error());
		echo "Enregistrement effectué";
		//réinitialise les champs
		init();
		}
	elseif($userExist)
		echo "Cette adresse e-mail est deja utilisee";
	elseif($motDePasse != $mdpconf)
		echo "Les deux mots de passe ne correspondent pas";
	else 
		echo "Manque pseudo, mot de passe ou adresse e-mail";			
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
	<form method="post" action="inscription.php">
		<fieldset>
		<legend>Inscription</legend>
		   <input type="hidden" name="action" value="inscrire"/>
	       <label for="pseudo">Pseudo*</label> : <input type="text" name="pseudo" id="pseudo" value="<?php echo $_POST['pseudo'] ?>" /><br />
		   <label for="mdp">Mot de passe*</label> : <input type="password" name="mdp" id="mdp" value="<?php echo $_POST['mdp'] ?>" /><br />
		   <label for="mdpconf">Mot de passe (Confirmation)*</label> : <input type="password" name="mdpconf" id="mdpconf" value="<?php echo $_POST['mdpconf'] ?>" /><br />
		   <label for="email">Adresse email*</label> : <input type="text" name="email" id="email" value="<?php echo $_POST['email'] ?>"/><br />
		   <label for="nom">Nom</label> : <input type="text" name="nom" id="nom" value="<?php echo $_POST['nom'] ?>"/><br />
		   <label for="prenom">Prénom</label> : <input type="text" name="prenom" id="prenom" value="<?php echo $_POST['prenom'] ?>"/><br />
		   <label for="telephone">Numéro de téléphone</label> : <input type="text" name="telephone" id="telephone" value="<?php echo $_POST['telephone'] ?>" /><br />
		   <label for="fax">Numéro de fax</label> : <input type="text" name="fax" id="fax" value="<?php echo $_POST['fax'] ?>" /><br />
		   
		   <fieldset>
		       <legend>Votre Adresse (optionel)</legend> 
			   <label for="numero">Numéro de rue</label> : <input type="text" name="numero" id="numero" value="<?php echo $_POST['numero'] ?>" /><br />
			   <label for="rue">Rue</label> : <input type="text" name="rue" id="rue" value="<?php echo $_POST['rue'] ?>"/><br />
			   <label for="ville">Ville</label> : <input type="text" name="ville" id="ville" value="<?php echo $_POST['ville'] ?>"/><br />
			   <label for="codepostal">Code Postal</label> : <input type="text" name="codepostal" id="codepostal" value="<?php echo $_POST['codepostal'] ?>"/><br />
			   <label for="pays">Pays</label> : <input type="text" name="pays" id="pays" value="<?php echo $_POST['pays'] ?>"/><br />
		   </fieldset>   
	       <input type="submit" /> <input type="reset" onclick="init()" />
	</fieldset>
	    
	</form>
	<form method="post" action="accueil.php">
		<input type="hidden" name="email" value="<?php echo $_POST['email']?>" />
		<input type="hidden" name="mdp" value="<?php echo $_POST['mdp']?>" />
	 <input type="submit" value="connexion" onclick="accueil.php"/>
	 </form>
	</body>
</html> 	
