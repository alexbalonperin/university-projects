package controler;

import java.awt.Point;
import java.awt.event.MouseEvent;
import java.awt.geom.Point2D;

import model._Snooker;

public class BallMouseListenerSnooker extends BallMouseListener {

	public BallMouseListenerSnooker(_Snooker snooker) {
		super(snooker);
	}

	public void testBallPos(MouseEvent mouse){
		Point mousePos = mouse.getPoint();
		double posXMouse = mousePos.x;
		double posYMouse = mousePos.y;
		double posXLine = posTable.x + dimTable.width - pool.getWhiteLinePos();
		int radiusCircle = 80;
		double posXCenter = posXLine;
		double posYCenter = posTable.y + dimTable.height/2;
		Point center = new Point((int)posXCenter, (int)posYCenter);
		if (posXMouse > posXLine) {
			if (mousePos.distance(center) < radiusCircle){
				whiteBall.setPosition(new Point2D.Double(whiteBall.getPosition().x, mousePos.y));
			}
			else
			{
				double angle = Math.asin((posYCenter - posYMouse)/(mousePos.distance(center)));
				double xBall = posXLine + radiusCircle*Math.cos(angle);
				double yBall = posYCenter - radiusCircle*Math.sin(angle);
				whiteBall.setPosition(new Point2D.Double(xBall, yBall));
			}
		}
		else{
			double yBall;
			if(posYMouse > posYCenter+radiusCircle)
				yBall = posYCenter+radiusCircle;
			else if (posYMouse < posYCenter-radiusCircle)
				yBall = posYCenter-radiusCircle;
			else
				yBall = posYMouse;
			whiteBall.setPosition(new Point2D.Double(posXLine, yBall));
		}
		queue.setPosition(whiteBall.getPosition());
	}
	
}
