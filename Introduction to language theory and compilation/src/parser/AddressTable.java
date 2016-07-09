package parser;

import java.util.Hashtable;

public class AddressTable implements AddressTableInterface {
	Hashtable <String, Integer> table = new Hashtable <String,Integer>();
	Hashtable <String, Boolean> isGlobal = new Hashtable <String,Boolean>();
	Hashtable <String, Integer> args = new Hashtable <String, Integer> ();
	Hashtable <String, Integer> mp = new Hashtable <String,Integer>();
	
	int nbArg = 0;
	
	public int getAddress(String variable){
		return table.get(variable);
	}
	
	public boolean getGlobal (String variable){
		return isGlobal.get(variable);
	}
	
	public int getSizeOfStack(){
		return table.size();
	}
	public void addVariable(String variable, int address, boolean global){
		table.put(variable, address);
		isGlobal.put(variable, global);
	}
	
	public void removeVariable(String variable){
		table.remove(variable);
	}
	
	public void print(){
		System.out.println(table.entrySet());
		System.out.println(isGlobal.entrySet());
		System.out.println(args.entrySet());
		System.out.println(mp.entrySet());
	}
	
	public boolean contains(String variable){
		return table.containsKey(variable);
	}
	public void addArg(String variable){
		args.put(variable, nbArg);
		nbArg++;
	}
	public boolean containsArg(String variable){
		return args.containsKey(variable);
	}
	public void removeArgs(){
		args.clear();
		nbArg = 0;
	}
	
	public int getArgNumber(String variable){
		return args.get(variable);
	}
	
	public int getNumberOfArgs(){
		return args.size();
	}
	
	public void addMP(String variable, int address){
		mp.put(variable, address );
	}
	
	public int getMP(String variable){
		return mp.get(variable);
	}
}
