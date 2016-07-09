package controler;

import java.awt.event.MouseEvent;
import java.awt.event.MouseListener;
import java.awt.event.MouseMotionListener;

import java.awt.geom.Point2D;


import model.Ball;
import model.Queue;
import model.__Pool;

//Cette classe s'occupe de recuperer les deplacements de la souris pour faire bouger la queue en consequence.
//Elle permettra notamment de faire demarrer la boule blanche en consequence.

public class QueueMouseListener implements MouseListener, MouseMotionListener{

	private Queue queue;
	private Ball whiteBall;
	private int backStartDist;
	private boolean WBisHit = false;
	private BallMouseListener ballControler;
	private __Pool pool;
	
	public QueueMouseListener(__Pool pool, BallMouseListener ballControler){
		this.queue = pool.getQueue();
		this.whiteBall = pool.getBallsList().getWhiteBall();
		this.ballControler = ballControler;
		this.pool = pool;
	}
	
	@Override
	public void mouseMoved(MouseEvent e) {
		// on fait tourner la queue en fonction de la position de la souris (en miroir)
		if(!pool.isInRound() && !ballControler.isBallPositionning())
		{
			queue.setPosition(whiteBall.getPosition());
			double distX = e.getX() - whiteBall.getPosition().x;
			double distY = e.getY() - whiteBall.getPosition().y;
			double arg = (double) (distY)/(double)(distX);
			double angle = Math.atan(arg);
			if(distX < 0)
				angle+=Math.PI;
			queue.setAngle(angle);
		}	
		
	}
	
	@Override
	public void mousePressed(MouseEvent e) {
		// TODO Auto-generated method stub		
		//Des que la souris est cliquee alors on va pouvoir faire reculer la queue.
		if(!ballControler.isBallPositionning() && !pool.isInRound())
		{
			Point2D.Double backStart = new Point2D.Double (e.getX() - whiteBall.getPosition().x, e.getY() - whiteBall.getPosition().y);
			backStartDist = (int) Math.sqrt((backStart.x * backStart.x) + (backStart.y * backStart.y));
		}
		
		
	}
	
	@Override
	public void mouseDragged(MouseEvent e) {
		// TODO Auto-generated method stub
		//On regarde de quelle distance la souris a recule et on fait reculer la queue de la meme distance
		
		if(!pool.isInRound() && !ballControler.isBallPositionning())
		{
			Point2D.Double backCur = new Point2D.Double (e.getX() - whiteBall.getPosition().x, e.getY() - whiteBall.getPosition().y);
			int backCurDist = (int) Math.sqrt((backCur.x * backCur.x) + (backCur.y * backCur.y));
			int backDist = backCurDist - backStartDist;
			if (backDist < 50 && backDist > 0) // pour limiter la force max
				queue.setDistWhiteBall(backDist);
			else if (backDist >= 50)
				queue.setDistWhiteBall(50);
			mouseMoved(e); // pour que l'angle continue à se modifier meme quand la souris est enfoncee
		}
	}

	@Override
	public void mouseReleased(MouseEvent e) {
		// TODO Auto-generated method stub
		//Evite que lorsqu'on clicke quand la blanche est en mouvement elle ne s'arrete
		
		if(pool.isInRound())
			WBisHit = true;
		else
			WBisHit = false;
		if(!WBisHit)
		{
			Point2D.Double speed = new Point2D.Double(-(queue.getDistWhiteBall() *  Math.cos(queue.getAngle())), -(queue.getDistWhiteBall() * Math.sin(queue.getAngle())));
			whiteBall.setSpeed(speed); // a voir en fct de la vitesse que ca donne
			queue.setDistWhiteBall(0);	
			
			if(whiteBall.isMoving())
				WBisHit = true;
		}
	}
	
	@Override
	public void mouseClicked(MouseEvent e) {
		// TODO Auto-generated method stub
	
	}

	@Override
	public void mouseEntered(MouseEvent e) {
		// TODO Auto-generated method stub

	}

	@Override
	public void mouseExited(MouseEvent e) {
		// TODO Auto-generated method stub
		
	}



	

}
