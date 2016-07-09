package memory;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.io.Serializable;
import java.security.PrivateKey;
import java.security.PublicKey;

import javax.crypto.SecretKey;

import communication.Mail;

public class Memory implements Serializable {
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	private byte[] rByte;
	private byte[] iByte;
	private byte[] jByte;
	private SecretKey sessionKey1;
	private SecretKey sessionKey2;
	private int myGroupNumber;
	private int otherGroupNumber;
	private boolean initializedMain;
	private PrivateKey myEncryptionPrivateKey;
	private PrivateKey mySignaturePrivateKey;
	private PublicKey otherEncryptionPublicKey;
	private PublicKey otherSignaturePublicKey;
	private String address;
	private Mail mail;
	
	public String getAddress() {
		return address;
	}

	public void setAddress(String address) {
		this.address = address;
	}

	public boolean isInitializedMain() {
		return initializedMain;
	}

	public void setInitializedMain(boolean initializedMain) {
		this.initializedMain = initializedMain;
	}

	public void save(){
		try {
			ObjectOutputStream oos = new ObjectOutputStream(new FileOutputStream("memory/memory.txt"));
			oos.writeObject(this);
			oos.close();
		} catch (FileNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
	public static Memory load(){
		ObjectInputStream ois;
		Memory result = null;
		try {
			ois = new ObjectInputStream(new FileInputStream ("memory/memory.txt"));
			result = (Memory) ois.readObject();

		} catch (FileNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return result;
	}
	public void setOtherGroupNumber(int otherGroupNumber) {
		this.otherGroupNumber = otherGroupNumber;
	}
	public int getOtherGroupNumber() {
		return otherGroupNumber;
	}
	public void setMyGroupNumber(int myGroupNumber) {
		this.myGroupNumber = myGroupNumber;
	}
	public int getMyGroupNumber() {
		return myGroupNumber;
	}
	public byte[] getrByte() {
		return rByte;
	}
	public void setrByte(byte[] rByte) {
		this.rByte = rByte;
	}
	public byte[] getiByte() {
		return iByte;
	}
	public void setiByte(byte[] iByte) {
		this.iByte = iByte;
	}
	public byte[] getjByte() {
		return jByte;
	}
	public void setjByte(byte[] jByte) {
		this.jByte = jByte;
	}
	public SecretKey getSessionKey1() {
		return sessionKey1;
	}
	public void setSessionKey1(SecretKey sessionKey1) {
		this.sessionKey1 = sessionKey1;
	}
	public SecretKey getSessionKey2() {
		return sessionKey2;
	}
	public void setSessionKey2(SecretKey sessionKey2) {
		this.sessionKey2 = sessionKey2;
	}

	public PrivateKey getMyEncryptionPrivateKey() {
		return myEncryptionPrivateKey;
	}

	public void setMyEncryptionPrivateKey(PrivateKey myEncryptionPrivateKey) {
		this.myEncryptionPrivateKey = myEncryptionPrivateKey;
	}

	public PrivateKey getMySignaturePrivateKey() {
		return mySignaturePrivateKey;
	}

	public void setMySignaturePrivateKey(PrivateKey mySignaturePrivateKey) {
		this.mySignaturePrivateKey = mySignaturePrivateKey;
	}

	public PublicKey getOtherEncryptionPublicKey() {
		return otherEncryptionPublicKey;
	}

	public void setOtherEncryptionPublicKey(PublicKey otherEncryptionPublicKey) {
		this.otherEncryptionPublicKey = otherEncryptionPublicKey;
	}

	public PublicKey getOtherSignaturePublicKey() {
		return otherSignaturePublicKey;
	}

	public void setOtherSignaturePublicKey(PublicKey otherSignaturePublicKey) {
		this.otherSignaturePublicKey = otherSignaturePublicKey;
	}

	public void setMail(Mail mail) {
		this.mail = mail;
	}

	public Mail getMail() {
		return mail;
	}
	
}
