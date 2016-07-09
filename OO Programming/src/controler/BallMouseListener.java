package controler;

import java.awt.Dimension;
import java.awt.event.MouseEvent;
import java.awt.event.MouseListener;
import java.awt.event.MouseMotionListener;
import java.awt.geom.Point2D;


import model.Ball;
import model.BallsList;
import model.Queue;
import model.__Pool;

//Cette classe s'occupe de recuperer les deplacements de la souris pour faire bouger la boule blanche en consequence.

abstract class BallMouseListener implements MouseListener, MouseMotionListener {

	protected Queue queue;
	protected Ball whiteBall = null;
	protected Point2D.Double posTable;
	protected Dimension dimTable;
	protected BallsList ballsList;
	protected boolean ballPositionning = true;
	protected __Pool pool;
	protected boolean WBInHole = false;

	public BallMouseListener(__Pool pool){
		this.queue = pool.getQueue();
		this.posTable = pool.getTable().getPosition();
		this.dimTable = pool.getTable().getDimension();
		this.ballsList = pool.getBallsList();
		this.whiteBall = ballsList.getWhiteBall();
		this.pool = pool;
	}

	@Override
	public void mousePressed(MouseEvent e) {
		// TODO Auto-generated method stub
		if(whiteBall.isMoving())
			WBInHole = false;
		if(ballPositionning)
		{// on va verifier que la BB ne soit placee sur aucune autre boule
			int i = 0;
			for( ; i < ballsList.size() && (!whiteBall.isOnShape(ballsList.get(i)) || ballsList.get(i).equals(whiteBall)) ; i++);
			
			if(i == ballsList.size())
			{
				ballPositionning = false;
				pool.setWBinHole(false);	
			}
		}
		else
		{
			if(whiteBall.isOnPoint(e.getPoint()) && (!pool.isInGame() || WBInHole)) {
				ballPositionning = true;
				pool.setWBinHole(false);
				
			}
		}		
	}

	@Override
	public void mouseMoved(MouseEvent e) {
		// TODO Auto-generated method stub
		if(pool.isWBinHole())
		{
			ballPositionning = true;
			WBInHole = true;
		}
		if(whiteBall.isMoving())
			WBInHole = false;
		if(ballPositionning)
		{
			queue.setPosition(whiteBall.getPosition());
			testBallPos(e);
			
		}	
	}
	
	public void testBallPos(MouseEvent mouse){
		//Cette fonction sera redefinie dans une sous-classe car la position autorisee pour la boule blanche depend du jeu implemente
	}
	
	@Override
	public void mouseReleased(MouseEvent e) {
		// TODO Auto-generated method stub
		if(whiteBall.isMoving())
			WBInHole = false;
	}

	@Override
	public void mouseDragged(MouseEvent e) {
		// TODO Auto-generated method stub
		
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
	public boolean isBallPositionning() {
		return ballPositionning;
	}

	public void setBallPositionning(boolean ballPositionning) {
		this.ballPositionning = ballPositionning;
	}
}
