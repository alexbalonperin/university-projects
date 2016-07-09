package main;

import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.InputStreamReader;

import crypto.Protocol;



public class Main {
	
	private int user1GroupNumber =  15;
	private int user2GroupNumber;
	
	private	String addressConnectionRequest = "received/connection_request.txt";
	private String addressKeyProposal = "received/key_proposal.txt";
	private String addressKeyConfirmation = "received/key_confirmation.txt";
	private String addressSecureCommunication = "received/secure_communication.txt";
	
		private InputStreamReader isr;
	private BufferedReader br;
	private File file;
	
	public void init() {
		file = new File (addressConnectionRequest);
		file.delete();
		
		file = new File (addressKeyConfirmation);
		file.delete();
		
		file = new File (addressKeyProposal);
		file.delete();
		
		file = new File (addressSecureCommunication);
		file.delete();
		
		file = new File("received/clearTextFinal.txt");
		file.delete();
		
	
			
	}
	
	public void action(Protocol rsa){
	     int etape = 0;
	     
	     while (etape<5){
				 isr = new InputStreamReader(System.in);
			      br = new BufferedReader(isr);
				try {
					System.out.print("Etape : ");
					etape = Integer.parseInt(br.readLine());
				} catch (IOException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				if (etape==1){
					isr = new InputStreamReader(System.in);
				      br = new BufferedReader(isr);
				     int j = 0;
					try {
						System.out.print("Numero de l'autre Groupe : ");
						j = Integer.parseInt(br.readLine());
					} catch (IOException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
					this.user2GroupNumber = j;
					
					this.init();
					String s ="";
					try {
						System.out.print("adresse mail du contact de l'autre groupe : ");
						s = (br.readLine());
					} catch (IOException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
					//on initialise le numero du groupe 
					rsa.init(user1GroupNumber, user2GroupNumber, s);
				}
				
				else if (etape==2)
					rsa.initProtocol();
				
				else if (etape==3){
					boolean resultVerification = rsa.verifyProtocol( this.addressConnectionRequest);
			
					if (resultVerification)			
						rsa.sendSessionKey();
				
				}
				
				else if (etape==4){
					//l utilisateur 1 verifie la signature du message et recupere les deux clŽs envoyŽes par l utlisateur 2
					boolean resultVerification = rsa.receiveSessionKey(addressKeyProposal);
					if(resultVerification)
						rsa.keyConfirmation();
				}
				
				else if (etape==5)
					rsa.verifResult(addressKeyConfirmation);
				else if (etape>5);
			   }
	     while (etape < 8){
	    	 isr = new InputStreamReader(System.in);
		      br = new BufferedReader(isr);
			try {
				System.out.print("Etape : ");
				etape = Integer.parseInt(br.readLine());
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
	    	 	if (etape==6){
					String addressToSend = "tmp/secure_communication.txt";// + address;
					String addressTmp = "toSend/secure_communication.txt";// + address;
					rsa.sendMessage(addressTmp, addressToSend);
				}
					
				
				else if (etape==7){
					String address = "received/secure_communication.txt";// + address;
					rsa.readMessage(address);
				}
	     }
	}
	
	public static void main(String[] args) {
		// TODO Auto-generated method stub
		
		Protocol rsa = new Protocol();
		Main principal = new Main();
		
		principal.action(rsa);
		System.out.println("check");
		
	}

}
