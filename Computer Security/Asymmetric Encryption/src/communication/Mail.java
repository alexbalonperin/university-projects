package communication;

import java.io.File;
import java.io.IOException;
import java.util.Properties;

import javax.mail.Folder;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.NoSuchProviderException;
import javax.mail.Part;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Store;
import javax.mail.Transport;
import javax.mail.internet.AddressException;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeBodyPart;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeMultipart;

import memory.Memory;

public class Mail {
	private static String user = "pandaziatic";
	private static String password = "samourai";
	private static String email ="pandaziatic@gmail.com";
	public static void sendMail(String address) {
		Memory memory = Memory.load();
		System.out.println(memory.getAddress());
		System.out.println("sending email: "+address);
		Properties props = new Properties();
    	props.put("mail.smtp.host", "smtp.gmail.com");
    	props.put("mail.smtp.socketFactory.port", "465");
    	props.put("mail.smtp.socketFactory.class","javax.net.ssl.SSLSocketFactory");
    	props.put("mail.smtp.auth", "true");
    	props.put("mail.smtp.port", "465");
 
		Session session = Session.getDefaultInstance(props,
		new javax.mail.Authenticator() 
		{
			protected PasswordAuthentication getPasswordAuthentication()
			{ return new PasswordAuthentication(user,password);	}
		});		
 
    	try {
    		Message message = setMail(address, memory, session);
		    Transport.send(message);
 
	    System.out.println("Done");
 
    	} catch (MessagingException e) {
    	    throw new RuntimeException(e);
    	} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	private static Message setMail(String address, Memory memory,
			Session session) throws MessagingException, AddressException,
			IOException {
		File file = new File(address);
		Message message = new MimeMessage(session);
		message.setFrom(new InternetAddress(email));
		message.setRecipients(Message.RecipientType.TO, 
		            InternetAddress.parse(memory.getAddress()));
		if (address == "toSend/connection_request.txt")
			message.setSubject("Connection Request");
		else if (address == "toSend/key_proposal.txt")
			message.setSubject("Key Proposal");
		else if (address == "tmp/secure_communication.txt")
			message.setSubject("Secure Communication");
		else if (address == "toSend/key_confirmation.txt")
			message.setSubject("Key Confirmation");
		if (file != null) {
			MimeBodyPart mbp1 = new MimeBodyPart();
			mbp1.setText("groupe 15");
			MimeBodyPart mbp2 = new MimeBodyPart();
			mbp2.attachFile(file);
			MimeMultipart mp = new MimeMultipart();
			mp.addBodyPart(mbp1);
			mp.addBodyPart(mbp2);
			message.setContent(mp);
		}
		return message;
	}
	
	public static void receiveMail(String title){

		String host = "209.85.227.109";
	
		Properties properties = new Properties();
		properties.put("mail.imap.host", "imap.gmail.com");
    	properties.put("mail.imap.socketFactory.port", "993");
    	properties.put("mail.imap.socketFactory.class","javax.net.ssl.SSLSocketFactory");
    	properties.put("mail.imap.socketFactory.fallback", "false");
    	properties.put("mail.imap.auth", "true");
    	properties.put("mail.imap.port", "993");
    	properties.put("mail.imap.auth", "true");
    	properties.put("mail.imap.user", email);
    	properties.put("mail.imap.starttls.enable", "true");
    	properties.put("mail.debug", "false");

		//récupère la session par défaut et authentifie l'utilisateur
		Session session = Session.getInstance(properties,new javax.mail.Authenticator() 
		{
			protected PasswordAuthentication getPasswordAuthentication()
			{ return new PasswordAuthentication(user,password);	}
		});

		try {
			// permet d'implémenter le protocol imap
			Store store = session.getStore("imap");
			//connecte au host spécifié (ici gmail) avec le login (user,password)
		    store.connect(host, user, password);
		
		    Folder folder = getFolder(store);
		    
		    getAttachment(title, folder);
		    folder.close(true);
		    store.close();
		} catch (NoSuchProviderException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (MessagingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	private static Folder getFolder(Store store) throws MessagingException {
		//Crée un dossier dans lequel on récupère les mails qui existent dans le dossier "Crypto" sur gmail
		Folder folder = store.getFolder("Crypto");

		//si le nom de dossier n'existe pas on le spécifie
		if (folder == null) {
			System.out.println("Invalid folder");
			System.exit(1);
		}

		//ouvre le dossier en lecture seule
		folder.open(Folder.READ_ONLY);

		int totalMessages = folder.getMessageCount();
		//vérifie que le dossier n'est pas vide
		if (totalMessages == 0) {
			System.out.println("Empty folder");
			folder.close(false);
			store.close();
			System.exit(1);
		}
		return folder;
	}

	private static void getAttachment(String title, Folder folder)
			throws MessagingException, IOException {
		//récupère les messages du dossier "Crypto"
		Message[] message = folder.getMessages();
		
		//Inverse l'ordre des messages pour avoir les plus récents au-dessus
		message = reverse(message,folder);
		
		//parcours les mails
		for (int a = 0; a < message.length; a++) {
			
			String subject = message[a].getSubject();
			//si il y a un sujet au mail et que ce sujet correspond au sujet recherché on récupère la pièce jointe
			if(subject != null){
		    	if(subject.equals(title)){
		    	
		           MimeMultipart multipart = (MimeMultipart) message[a].getContent();
		           String disposition = message[a].getDisposition();
		           if (disposition == null || disposition.equalsIgnoreCase(Part.ATTACHMENT)) {
		               for(int j = 0; j<multipart.getCount(); j++){ 
			        	   MimeBodyPart bodyPart = (MimeBodyPart) multipart.getBodyPart(j);
			                String fileName = bodyPart.getFileName();
			                File file = new File("received/"+fileName);
			                bodyPart.saveFile(file);
		               }
		          }
		          break;
		    	}
			}
		}
	}

	
	private static Message[] reverse(Message[] message, Folder folder){
		Message[] reverse = null;
		try {
			reverse = folder.getMessages();
			int counter = 0;
			
			for(int i  = (message.length-1) ; i>=0;i--){
				reverse[counter] = message[i]; 
				counter++;
			}
			return reverse;
		} catch (MessagingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return null;
		
	}
}
