package BalonPerinKristoffersen.DistributedSolver;

public class AdditionSolver extends ComputeAgent{
	
	public AdditionSolver(){
		super("compute+");
	}
	
	protected int compute(String operation){
		int[] result = getOperands(operation);
		return result[0]+result[1];
	}
}
