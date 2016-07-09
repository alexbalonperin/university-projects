package parser;

import java.util.Hashtable;

public class Function {
	int nbArgs = 0;
	private String name;
	private char type;
	private Hashtable<String, Character> args = new Hashtable <String, Character>();
	private Hashtable<Integer,String> argsOrder = new Hashtable <Integer,String>();
	
	public Function(String n, char t){
		this.name = n;
		this.type = t;
	}
	
	public String getName(){
		return this.name;
	}
	
	public char getType(){
		return this.type;
	}
	
	public void addArg(String n, char type){
		args.put(n,type);
		argsOrder.put(nbArgs,n);
		nbArgs++;
	}
	
	
	public boolean containsArg(String name){
		return args.containsKey(name);
	}
	
	public char getArgType(int index){
		
		if (index >= args.size()){
			System.err.println("not right amount of parameters" + " " + index + " "  + name);
			System.exit(0);
		}
		String name = argsOrder.get(index);
		return args.get(name);
		
	}
	public int getArgsNumber(){
		return args.size();
	}
	public char getArgType(String name){
		return args.get(name);
	}
}
