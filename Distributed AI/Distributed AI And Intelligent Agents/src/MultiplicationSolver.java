package BalonPerinKristoffersen.DistributedSolver;

public class MultiplicationSolver extends ComputeAgent{
	
	public MultiplicationSolver(){
		super("compute*");
	}
	
	protected int compute(String operation){
		int[] result = getOperands(operation);
		return result[0]*result[1];
	}
}
