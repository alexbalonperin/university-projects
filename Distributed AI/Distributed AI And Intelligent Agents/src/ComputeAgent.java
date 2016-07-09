package BalonPerinKristoffersen.DistributedSolver;

import jade.core.Agent;
import jade.core.behaviours.*;
import jade.lang.acl.ACLMessage;
import jade.lang.acl.MessageTemplate;
import jade.domain.DFService;
import jade.domain.FIPAException;
import jade.domain.FIPAAgentManagement.DFAgentDescription;
import jade.domain.FIPAAgentManagement.ServiceDescription;

import java.util.*;

/*
 * This class i largely based on the BookSellerAgent provided by JADE.
 * The compute agent receives CFPs or tasks from the Task Administrator
 * and reply with bids or results respectively.
 */
public abstract class ComputeAgent extends Agent {
	private int cost; // In milliseconds
	private String type;
	private ACLMessage msg;
	
	public ComputeAgent(String t){
		this.type = t;
	}
	
	protected void setup() {
		// Register the addition service in the yellow pages
		DFAgentDescription dfd = new DFAgentDescription();
		dfd.setName(getAID());
		ServiceDescription sd = new ServiceDescription();
		sd.setType(type);												
		sd.setName("JADE-computation");
		dfd.addServices(sd);
		try {
			DFService.register(this, dfd);
		}
		catch (FIPAException fe) {
			fe.printStackTrace();
		}

		// Add the behaviour serving CFPs from the Task Administrator
		addBehaviour(new OfferRequestsServer());

		// Add the behaviour serving compute tasks from the Task Administrator
		addBehaviour(new ComputeTaskServer());
	}

	protected void takeDown() {
		// Deregister from the yellow pages
		try {
			DFService.deregister(this);
		}
		catch (FIPAException fe) {
			fe.printStackTrace();
		}
		System.out.println("computing-agent "+getAID().getName()+" terminating.");
	}

	protected int[] getOperands(String operation){
		// operation is on the form "<int><operator><int>"
		char[] op_char = operation.toCharArray();
		int[] result = new int[2];
		int i = 0;
		for(int j = 0; j<2; j++){
			int sign = 1;
			if(op_char[i] == '-'){
				sign = -1;
				i++;
			}
			int tmp_res = 0;
			while(i < operation.length() && op_char[i] <= '9' && op_char[i] >= '0'){
				tmp_res = tmp_res*10 + op_char[i]-'0';
				i++;
			}
			result[j] = tmp_res*sign;
			i++;
		}
		return result;
	}
	
	public int getCost(){
		return this.cost;
	}
	
	public void setCost(int c){
		this.cost = c;
	}

	protected abstract int compute(String operation);

	/*
	 * This is the behaviour used by Computing agents to serve incoming requests 
	 * for proposal from taskmanager agents.
	 * The Computing agent replies with a PROPOSE message specifying the cost of computation. 
	*/
	public class OfferRequestsServer extends CyclicBehaviour {
		// The assigned tasks can be stored together with their associated cost in a hashtable.
		// In this exercise we do not actually store more than one task because
		// we only deal with one serial Task Manager (which is a serious limitation of the implementation)
		private Hashtable<ACLMessage,Integer> operations = new Hashtable<ACLMessage,Integer>();

		public void action() {
			MessageTemplate mt = MessageTemplate.MatchPerformative(ACLMessage.CFP);
			ACLMessage msg = myAgent.receive(mt);
			if (msg != null) {
				String operator = msg.getContent();
				ACLMessage reply = msg.createReply();

				// An obvious improvement would be not only to sum all costs, but to
				// subtract the part of the current task which is done
				int current_cost = getRand();
				int overall_cost = 0;
				Iterator<Integer> it = operations.values().iterator();
				while(it.hasNext()){
					overall_cost += it.next();
				}
				setCost(current_cost + overall_cost);
				reply.setPerformative(ACLMessage.PROPOSE);
				reply.setContent(String.valueOf(getCost()));
				myAgent.send(reply);
			}
			else {
				block();
			}
		}

		private int getRand(){
			int lower = 500;
			int upper = 2000;
			return (int)((Math.random()*(upper-lower))+lower);
		}
	}  // End of inner class OfferRequestsServer

	// Receive and process compute tasks
	private class ComputeTaskServer extends CyclicBehaviour {
		public void action() {
			MessageTemplate mt = MessageTemplate.MatchPerformative(ACLMessage.ACCEPT_PROPOSAL);
			ACLMessage tmp_msg = myAgent.receive(mt);
			if (tmp_msg != null) {
				msg = tmp_msg; // We need the message to be available in the WakerBehaviour

				// ACCEPT_PROPOSAL Message received. Process it after cost milliseconds.
				addBehaviour(new WakerBehaviour(myAgent,cost){
					protected void handleElapsedTimeout(){
						String operation = msg.getContent();
						ACLMessage reply = msg.createReply();
						int result = 0; 
						try{
							result = compute(operation);
						}catch (Exception e){
							String content= "Error: "+e.getMessage();
							reply.setPerformative(ACLMessage.FAILURE);
							reply.setContent(content);
							myAgent.send(reply);
						}
						reply.setPerformative(ACLMessage.INFORM);
						reply.setContent(String.valueOf(result));
						myAgent.send(reply);
					}
				});
			}
			else {
				block();
			}
		}
	}  // End of inner class ComputeTaskServer
}
