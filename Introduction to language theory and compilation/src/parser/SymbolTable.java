package parser;

import java.util.Hashtable;
import java.util.Vector;



public class SymbolTable implements SymbolTableInterface {
	
	private	Vector<Function> functions = new Vector <Function>();
	
	private Hashtable<String, Character> variables = new Hashtable<String, Character>();
	
	public SymbolTable(){
		
	}
	
	public void addFunction(Function f){
		functions.add(f);
	}
	
	public void addVariable(String name, char type){
		variables.put(name,type);
	}
	
	public char getVariableType(String name){
		return variables.get(name);
	}
	
	public char getFunctionType(String fname){
		char result = '.';
		for (Function f : functions){
			if(f.getName().equals(fname)){
				result = f.getType();
				}
		}
		return result;
	}
	
	public int getArgsNumber (String fname){
		for (Function f : functions){
			if (f.getName().equals(fname)){
				return f.getArgsNumber();
			}
		}
		return 125; 
	}
	public char getArgType(String fname, int index){
		for (Function f : functions){
			if (f.getName().equals(fname)){
				return f.getArgType(index);
			}
		}
		return '.';
	}
	
	public char getType(String name){
		if (variables.containsKey(name))
			return variables.get(name);
		else
			for (Function f : functions){
				if (f.containsArg(name))
					return f.getArgType(name);
			}
		return '.';
	}
	public void print(){
		System.out.println("Table des fonctions [nom, type]");
		for (Function f : functions){
			System.out.println("\t" + f.getName() + " , " +f.getType());
		}
		System.out.println("Table des variables [nom, type]");
		System.out.println(variables.entrySet()); 
	}
	
}

