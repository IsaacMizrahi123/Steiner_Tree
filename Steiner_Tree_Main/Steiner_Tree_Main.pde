import javax.swing.JOptionPane;
import javax.swing.JFrame;

Map<Point, ArrayList<Point>> neighbours = new HashMap<Point, ArrayList<Point>>();
Map<Point, ArrayList<Point>> nodes 		= new HashMap<Point, ArrayList<Point>>();

ArrayList<Button>	buttons 	= new ArrayList<Button>();
ArrayList<Point>    points     	= new ArrayList<Point>();
ArrayList<Edge>     edges 		= new ArrayList<Edge>();
ArrayList<Point> 	solNodes 	= new ArrayList<Point>();
ArrayList<Edge> 	solEdges 	= new ArrayList<Edge>();

boolean notButtonPressed = true;
Point start = null;
Point end 	= null;
Point sel 	= null;
int stage = 1;

void setup(){
	size(800,800,P3D);
	frameRate(30);

	//Create buttons:
	//Button (String text_, int x, int y, int width_, int height_, int value_)
	float ycord = 10;
	buttons.add( new Button("Add Vertices", 			5, ycord, 		180, 25, 1) );
	buttons.add( new Button("Remove Vertices", 			5, ycord += 33, 180, 25, 2) );
	buttons.add( new Button("Add Edges", 				5, ycord += 33, 180, 25, 3) );
	buttons.add( new Button("Remove Edges", 			5, ycord += 33, 180, 25, 4) );
	buttons.add( new Button("Mark Terminal Vertices", 	5, ycord += 33, 180, 25, 5) );
	buttons.add( new Button("Run Streiner Tree",		5, ycord += 33, 180, 25, 6) );
	buttons.add( new Button("Run Kruscal Approach", 	5, ycord += 33, 180, 25, 7) );
	buttons.add( new Button("Clear Graph", 				5, ycord += 33, 180, 25, 8) );
}

void draw(){
	background(255);

	for (Button b : buttons) { b.draw(mouseX,mouseY); }

	translate( 0, height, 0);
	scale( 1, -1, 1 );

	strokeWeight(3);
	noStroke();
	for (Point p : points) { p.draw(); }

	if (start != null) {
		fill(255,0,0);
		ellipse( start.x(), start.y(), 10,10);  
	}

	for (Edge e : edges) { e.draw(); }

	fill(0);
	switch (stage){
		case 1: textRHC( 	"Current stage: Adding vertices.", 			400, height-20 ); break;
		case 2: textRHC( 	"Current stage: Removing vertices.",		400, height-20 ); break;
		case 3: textRHC( 	"Current stage: Adding edges.", 			400, height-20 ); break;
		case 4: textRHC( 	"Current stage: Removing edges.", 			400, height-20 ); break;
		case 5: textRHC(	"Current stage: Marking terminal vertices.",400, height-20 ); break;
		default: textRHC( 	"Current stage: Error.", 					400, height-20 );
	}

	//Labelling vertices and edges
	for (int i = 0; i < points.size(); i++) {
  		textRHC( i+1, points.get(i).p.x+5, points.get(i).p.y+15 );
	}
	for (Edge e : edges) {
		textRHC( e.weight, (e.p0.p.x+e.p1.p.x)/2 , (e.p0.p.y+e.p1.p.y)/2 );
	}

}

void textRHC (int s, float x, float y) {
	textRHC( Integer.toString(s), x, y );
}

void textRHC (String s, float x, float y) {
	pushMatrix();
	translate(x,y);
	scale(1,-1,1);
	text( s, 0, 0 );
	popMatrix();
}

void mousePressed(){
	notButtonPressed = true;
	for (Button b : buttons) {
		if (b.selected){
			switch (b.value) {
				case 1: stage = 1; start = null; break;
				case 2: stage = 2; start = null; break;
				case 3: stage = 3; break;
				case 4: stage = 4; start = null; break;
				case 5: stage = 5; start = null; break;
				case 6: Shortest_Path_Dijkstra(); break;
				case 7: Shortest_Path_based_Approximate_Algorithm(points, edges); break;
				case 8: points.clear(); edges.clear(); break;
				default:
			}
			notButtonPressed = false;
			break;
		}
	}

	if (notButtonPressed) {
		int mouseXRHC = mouseX;
		int mouseYRHC = height-mouseY;

		float dT = 6;
		for (Point p : points) {
			float d = dist( p.p.x, p.p.y, mouseXRHC, mouseYRHC );
			if (d < dT) { dT = d; sel = p; }
		}
		switch (stage) {
			case 1: if (sel == null) { points.add( new Point(mouseXRHC,mouseYRHC) );} break;
			case 2: if (sel != null) {
					int i = 0;
					while (i<edges.size() && !edges.isEmpty()) {
						if (edges.get(i).has(sel)) {
							edges.remove(i);
						}
						else { i++; }
					}
					points.remove(sel);
				} break;
			case 3: if (sel != null) {
						if (start == null) { start = sel; }
						else {
							if (start == sel) { start = null; }
							else { 
								end = sel;
								JFrame jf = new JFrame();
								jf.setAlwaysOnTop(true);
								String weight = JOptionPane.showInputDialog(jf,"Enter the edge weight.");
								if ( isInt(weight) ){ edges.add( new Edge(start, end, Integer.parseInt(weight) ) );  }
								else { JOptionPane.showMessageDialog(null, "The weight have to be a positive number. Try again.", "Error", JOptionPane.ERROR_MESSAGE); }
								start = end = null; 
							}
						}
					} break;
			case 4:	Edge selectedEdge = null;
					for (Edge e : edges) {
						float d = e.distance(mouseXRHC,mouseYRHC);
						if (d < dT) { dT = d; selectedEdge = e; }
					}
					if (selectedEdge != null) { edges.remove(selectedEdge);	} break;
			case 5: if (sel != null) { sel.mark(); } break;
			default:
		}
	}
}

boolean isInt (String s) {
	if (s == null || s.isEmpty()) { return false; }
	for(char c : s.toCharArray()) {
		if (c!='0' && c!='1' && c!='2' && c!='3' && c!='4' && c!='5' && c!='6' && c!='7' && c!='8' && c!='9') {
			return false;
		}
	}
	return true;
}

void mouseDragged(){
	int mouseXRHC = mouseX;
	int mouseYRHC = height-mouseY;
	if( sel != null ){
		sel.p.x = mouseXRHC;   
		sel.p.y = mouseYRHC;
	}
}

void mouseReleased(){
	sel = null;
}
