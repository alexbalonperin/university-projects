package BalonPerinKristoffersen.DistributedSolver;

import java.util.*;

/*
 * The parser handles parsing of the expression string as well as finding the next sub-expression to compute
 */
public class Parser{
	// Available operators
	private ArrayList<Character> operators = new ArrayList<Character>(Arrays.asList('+','-','/','*'));
	// stack is both used in the LR(0) parser as well as traversing the AST
	private ArrayList<Node> stack;
	// When doing per character operations it is conveniant to have the input string as a char array
	private char[] expr_char;
	
	// LR(0) parser
	public Node parseExpression(String expression) throws Exception{
		stack = new ArrayList<Node>();
		expr_char = expression.toCharArray();
		for(int i=0; i < expression.length(); i++){
			if(operators.contains(expr_char[i])){
				// We are dealing with an operator; reduce
				Node node = new Node();
				
				// If the stack is empty, stack.remove() will throw an exception, which is
				// what we want because it can only be empty if the expression is invalid
				node.setRight(stack.remove(stack.size()-1));
				node.setLeft(stack.remove(stack.size()-1));
				node.setOperator(expr_char[i]);
				stack.add(node);
			}
			else if(expr_char[i] <= '9' && expr_char[i] >= '0'){
				// We are dealing with a number; shift
				int result = 0;
				// Build up the result int as long as the next character is a digit
				while(expr_char[i] <= '9' && expr_char[i] >= '0'){
					result = result*10 + expr_char[i]-'0';
					i++;
				}
				i--;
				Node node = new Node();
				node.setLeft(null);
				node.setRight(null);
				node.setValue(result);
				stack.add(node);
			}
			else if(expr_char[i] == ' '){
				// Ignore space
			}
			else{
				// Invalid character
				throw new Exception(); 
			}
		}
		
		// If the expression is valid, the root node will be the only one left at the stack 
		if (stack.size() !=1)
			throw new Exception(); 
		return stack.get(0);
	}
	
	public int getStackSize(){
		return stack.size();
	}
	
	public Node getNextNode(){
		if(stack.size() == 0)
			return null;
		Node n = stack.get(stack.size()-1);

		// Keep "recurse" until we find the next node where both children are values
		// This will be the next sub-expression to compute
		while(!((n.getLeft()).isValue() && (n.getRight()).isValue())){
			if(!(n.getLeft()).isValue())
				stack.add(n.getLeft());
			if(!(n.getRight()).isValue())
				stack.add(n.getRight());
			n = stack.get(stack.size()-1);	
		}
		return stack.remove(stack.size()-1);	
	}
}
