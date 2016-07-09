package crypto;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileWriter;
import java.io.IOException;
import java.security.InvalidAlgorithmParameterException;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;

import javax.crypto.BadPaddingException;
import javax.crypto.Cipher;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.NoSuchPaddingException;
import javax.crypto.SecretKey;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.SecretKeySpec;

public class Attack {

		private Cipher eCipher;
		private Cipher dCipher;
		private String addressX1 = "./tmp/x1.txt";
		private String addressY1 = "./tmp/y1.txt";
		private String addressX2 = "./tmp/x2.txt";
		private String addressY2 = "./tmp/y2.txt";
		private int numberOfKeys = 0;
		private FileInputStream fisX1;
		private FileInputStream fisY1;
		private byte[] byteX1 ;
		private byte[] byteY1 ;
		private int lengthX1;
		private int lengthY1;
		private byte[][] result1 = new byte[(int)java.lang.Math.pow(2,16)][];
		private byte[][] result2 = new byte[(int)java.lang.Math.pow(2,16)][];
		private SecretKey[] keyArray = new SecretKey[(int)java.lang.Math.pow(2,16)];
        private String IVstr;
        private FileWriter fw;
		private String[][][] keys = new String[16][2][2];
     
		
		//Initialise la méthode d'attaque
		public void init (){
			try {
				
				fisX1 = new FileInputStream(addressX1);
				fisY1 = new FileInputStream(addressY1);
				IVstr="00000000";
				//lecture fichier x1
//				int i = 0;
//				int iByte = 0;
//				byteX1 = new byte[(int)(new File(addressX1).length())];
//				while ((i=fisX1.read()) != -1 ) {
//			    	byteX1[iByte]=(byte)i;
//			    	iByte++;
//				}
				
				byte[] buf1= new byte[1024];
		    	int read1=fisX1.read(buf1);
		    	if (read1==-1)
		    		read1=buf1.length;
		    	byte[] tempByteX1 = buf1;
		    	lengthX1 = read1;
		    	byteX1 = new byte[lengthX1];
		    	for (int j = 0 ; j < lengthX1 ; j++)
		    		byteX1[j] = tempByteX1[j];
		    	
//				int j=0;
//				int jByte = 0;
//				byteY1 = new byte[(int)(new File(addressY1).length())];
//				while ((j=fisY1.read()) != -1 ) {
//			    	byteY1[jByte]=(byte)j;
//			    	jByte++;
//				}
				//lecture fichier y1
				byte[] buf= new byte[1024];
		    	int read=fisY1.read(buf);
		    	if (read==-1)
		    		read=buf.length;
		    	byte[] tempByteY1 = buf;
		    	lengthY1 = read;
		    	byteY1 = new byte[lengthY1];
		    	for (int j = 0 ; j < lengthY1 ; j++)
		    		byteY1[j] = tempByteY1[j];
			} catch (FileNotFoundException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		
		//attaque
		public void listing (){

			try {
				eCipher = Cipher.getInstance("DES/CBC/PKCS5Padding");
				dCipher = Cipher.getInstance("DES/CBC/NoPadding");

			    init () ;
		        createTables();  
		        compareTables();
		        File file = new File("./tmp/clés.txt");
				 try {
					 fw = new FileWriter(file);
				for (int i=0; i<numberOfKeys; i++){
					
					fw.write(i +" | clé 1 : " + keys[i][0][0] + " : " + keys[i][0][1] + " | clé 2 : " + keys[i][1][0] + " : " + keys[i][1][1]  + " \n" );
				}
				 
				 
				 } catch (IOException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			    try {
					fw.close();
				} catch (IOException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
	
		    }catch (NoSuchAlgorithmException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (NoSuchPaddingException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} 
			System.out.println("listing done");
		}
		
		//création des tables avec les résultats 
		private void createTables(){
				SecretKey key ;    
//				byte[] ivBytes = IVstr.getBytes();
				 byte[] ivBytes = new byte[]{
				            (byte)0x8E, 0x12, 0x39, (byte)0x9C,
				            0x07, 0x72, 0x6F, 0x5A
				        };
		        IvParameterSpec IV = new IvParameterSpec(ivBytes);
		        
		        byte[] keyByte = new byte[8];
		        
		        for (int i =0  ;i<java.lang.Math.pow(2,8); i++) { // 7e bit 
		        	for (int j = 0 ;j<java.lang.Math.pow(2,8) ; j++) {// 8e bit
			 				keyByte = createKey(i,j);
			 				key = new SecretKeySpec(keyByte,"DES");
			 	 			try {
								eCipher.init(Cipher.ENCRYPT_MODE, key, IV);
								byte[] encrypted1 = encrypt	(byteX1, eCipher);
				 	 			result1[i*255 + j] = encrypted1;
				 				dCipher.init(Cipher.DECRYPT_MODE, key, IV);
				 	 			byte[] decrypted1 = decrypt(byteY1, dCipher);
				 	 			result2[i*255 + j]= decrypted1;
				 	 			keyArray[i*255 + j]= key;
							} catch (InvalidKeyException e) {
								// TODO Auto-generated catch block
								e.printStackTrace();
							} catch (InvalidAlgorithmParameterException e) {
								// TODO Auto-generated catch block
								e.printStackTrace();
							}
		        		}
		        }    
		}
		
		//Comparaison des entrées des deux tables
		private void compareTables(){
	       
		    for (int i =0  ;i<java.lang.Math.pow(2,8); i++) { // 7e bit 
		    	System.out.println(" i : " + i + " | " + i/java.lang.Math.pow(2,8)*100 + " %");// " i : " + i);
	        	for (int j = 0 ;j<java.lang.Math.pow(2,8) ; j++) {// 8e bit
	    
	        		for (int k =0  ; k<java.lang.Math.pow(2,8); k++) { // 7e bit
				      
		        		for (int l = 0 ;l<java.lang.Math.pow(2,8); l++) { // 8e bit
		        			 boolean equal1 = isTheSame(result1[i*255+j], result2[k*255+l]);
			        		 if (equal1) {
			        			 System.out.println("OK1");
			        			 DES2 cryptoTool = new DES2();
			        			 cryptoTool.init(keyArray[i*255 + j],keyArray[k*255 + l],IVstr);
			        			 cryptoTool.encrypt(addressX2, "./tmp/Attaque.txt");
			        			 
			        			 boolean equal2= isTheSame("./tmp/Attaque.txt",addressY2);
			        			 
			        			 if(equal2){
			        				 System.out.println("OK2");
			        				 System.out.println("key 1 : " + new String(keyArray[i*255+j].getEncoded()) + "  key 2 : " + new String(keyArray[k*255+l].getEncoded()));	
			        				 
			        				 keys[numberOfKeys][0][0]= new String(keyArray[i*255+j].getEncoded());
			        				 keys[numberOfKeys][1][0]= new String(keyArray[k*255+l].getEncoded());
			        				 
			        				 System.out.print("key 1 :  ");
			        				 for ( int iBytes = 0; iBytes < keyArray[i*255+j].getEncoded().length; iBytes++){
			        				    	System.out.print(keyArray[i*255+j].getEncoded()[iBytes] + " ");
			        				    	keys[numberOfKeys][0][1] += new String(keyArray[i*255+j].getEncoded()[iBytes] + " ");
			        				    }
			        				 
			        				 System.out.print("key 2 :  ");
			        				 for ( int iBytes = 0; iBytes < keyArray[k*255+l].getEncoded().length; iBytes++){
			        				    	System.out.print(keyArray[k*255+l].getEncoded()[iBytes] + " ");
			        				    	keys[numberOfKeys][1][1] += new String(keyArray[k*255+l].getEncoded()[iBytes] + " ");

			        				    }
			        				
			        				 System.out.println("");
			        				 numberOfKeys++;
			        				 System.out.println("numberOfKeys : " + numberOfKeys);
			        			 }
			        		 }
		        		}
	        		}
        		}
        	}
		  
		}
		
		//crée le byteArray qui sera transformé en clé
		private byte[] createKey(int seventh, int eighth){
		
			byte[] byteArray = new byte[8];
			for (int iByte = 0; iByte <6 ; iByte ++)
				byteArray[iByte]=0;
			byteArray[6]=(byte) seventh;
			byteArray[7]=(byte) eighth;
			
			return byteArray;
		}
		
		//crypte le message
		 public byte[] encrypt(byte[] code, Cipher eCipher) {
		    byte[] result = null;
			try {
				result = eCipher.doFinal(code);
			} catch (IllegalBlockSizeException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (BadPaddingException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			 return result;
		}
		
		 //décrypte le message
		public byte[] decrypt (byte[] code, Cipher c) {
			byte[] result = null;
			try {
				result = c.doFinal(code,0,lengthY1);
			}catch (IllegalBlockSizeException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (BadPaddingException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			 return result;
		}
		
		//vérifie si le contenu de deux fichiers sont les mêmes
		private boolean isTheSame(String address1, String address2){
			boolean result=true;
			try {
		
				FileInputStream fis1 = new FileInputStream(address1);
				FileInputStream fis2 = new FileInputStream(address2);
				int i=0;
				int j=0;
				byte[] buf = new byte[8];
				result = true;
				while ((i = fis1.read(buf))!= -1 && ( j = fis2.read(buf))!= -1) {
					if (i != j){
						result = false;
						break;
					}
				}
				
			} catch (FileNotFoundException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		
			return result;
			
		}
		
		//vérifie si deux entrées des tables sont les mêmes
		private boolean isTheSame(byte[] E, byte[] D){
			boolean result=true;
			for (int iByte = 0 ; iByte < E.length && iByte < D.length ; iByte++ ){
				if (E[iByte]!=D[iByte]){
					result = false;
					break;
				}
			}
			return result;
		}
		
	}


