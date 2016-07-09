package BalonPerinKristoffersen.DistributedSolver;

// This class is the node in the Abstract Syntax Tree used by the Parser
public class Node{
	Node left;
	Node right;
	char operator;
	int value;
	
	public boolean isValue(){
		return left == null;
	}
	
	public Node getLeft(){
		return left;
	}
	public Node getRight(){
		return right;
	}
	public char getOperator(){
		return operator;
	}
	public int getValue(){
		return value;
	}
	
	public void setLeft(Node n){
		this.left = n;
	}
	public void setRight(Node n){
		this.right = n;
	}
	public void setOperator(char n){
		this.operator = n;
	}
	public void setValue(int n){
		this.value = n;
	}
}
