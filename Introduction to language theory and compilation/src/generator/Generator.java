package generator;

import fileWriter.OutputCode;
import fileWriter.OutputCodeInterface;

public class Generator implements GeneratorInterface {

	OutputCodeInterface output = new OutputCode("output.txt");
	public Generator(){
		
	}
	
	public void jumpToMain(){
		write("ujp @main");
	}
	
	public void defineMain(){
		write ("define @main");
	}
	
	public void stop(){
		write ("stp");
	}
	
	public void defineFunctionID(String tokenID){
		write ("define @"+tokenID);
	}
	
	public void endOfScope(boolean typedFunction){
		if (typedFunction)
			write ("retf");
		else 
			write ("retp");
	}
	
	public void defineID(int value, char type){
		write ("ldc " + type + " " + value);
	}
	
	public void read(int address, char type){
		write ("read");
		write ("str " + type + " 0 " +  address);
	}
	
	public void print(){
		write ("prin");
	}
	
	public void returnValue(char type){
		write ("str " + type + " 0 0");
	}
	
	public void pass(){
		write ("pass");
	}
	
	
	public void functionCall(boolean fromFunction, int nbArgs, String name){
		write ("cup " + nbArgs + " @" + name);
	}
	
	public void else_(boolean hasElse){
		if (hasElse)
			write ("fjp @else");
	}
	public void afterIf(){
		write ("define @after_if");
	}
	
	public void defineElse(){
		write ("define @else");
	}
	
	public void while_(){
		write ("fjp @after_while");
	}
	
	public void afterWhile(){
		write ("define @after_while");
	}
	
	public void release(){
		write ("rls");
	}
	
	public void reset(){
		write ("rst");
	}
	
	public void or (){
		write ("or b");
	}
	
	public void and(){
		write ("and b");
	}
	public void grt(){
		write ("grt i");
	}
	public void geq(){
		write ("geq i");
	}
	public void less(){
		write ("les i");
	}
	public void leq(){
		write ("leq i");
	}
	public void equal( char type){
		write ("equ " + type);
	}
	public void diff (char type){
		write ("neq " + type);
	}
	public void add (){
		write ("add i");
	}
	public void sub (){
		write ("sub i");
	}
	public void mul (){
		write ("mul i");
	}
	public void div (){
		write ("div i");
	}
	public void neg (){
		write ("neg i");
	}
	public void not (){
		write ("not b");
	}
	public void INTEGER_LITERAL(String value){
		write ("ldc i " + value);
	}
	public void BOOLEAN_LITERAL (String value){
		if (value == "False")
			write ("ldc b 0");
		else
			write ("ldc b 1");
	}
	
	
	private void write(String instruction){
		output.writeCode(instruction + "\n");
	}

	public void assignValue(int address, char type, boolean isGlobal) {
		if(isGlobal)
			write ("sro " + type  + " " + address);
		else
			write ("str " + type + " 0 " + address);
	}

	public void getIDValue(int address, char type, boolean isGlobal) {
		if(isGlobal)
			write("ldo "+type+" " +address);
		else
			write ("lod " + type + " 0 "  + address);
	}
	
	public void jumpAfterIf(){
		write("ujp @after_if");
	}
	public void endl(){
		write ("");
	}
	public void put (){
		write("put");
	}
	public void putr(){
		write ("putr");
	}
	public void get(){
		write ("get");
	}
	public void hold(){
		write ("hold");
	}
	public void createStackFrame(boolean fromFunction){
		if (fromFunction)
			write ("mst 1");
		else
			write ("mst 0");
	}
	
	public void defineWhile(){
		write ("define @while");
	}
	public void loopWhile(){
		write ("ujp @while");
	}
	
}
