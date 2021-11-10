import javax.swing.JOptionPane;
import javax.swing.JFrame;

ArrayList<Point>    points     = new ArrayList<Point>();
ArrayList<Edge>     edges      = new ArrayList<Edge>();
int stage = 1; //1: add vertices. 2: add edges. 3: mark terminal vertices
Point start = null;
Point end = null;
Point sel = null;
Map<Point, ArrayList<Point>> nodes = new HashMap<Point, ArrayList<Point>>();
ArrayList<Point> solNodes = new ArrayList<Point>();
ArrayList<Edge> solEdges = new ArrayList<Edge>();


void setup(){
	size(800,800,P3D);
	frameRate(30);
}

void draw(){
	background(255);

	translate( 0, height, 0);
	scale( 1, -1, 1 );

	strokeWeight(3);

	noStroke();
	for (Point p : points) { p.draw(); }

	if (start != null) {
		fill(255,0,0);
		ellipse( start.x(), start.y(), 10,10);  
	}

	noFill();
	stroke(100);
	for (Edge e : edges) { e.draw(); }

	fill(0);
	stroke(0);
	textSize(18);

	textRHC( "Press 1) Add Vertices    2) Connect Vertices  3) Mark Terminal Vertices 4) Run Streiner Tree Algorithm", 10, height-20 );
	textRHC( "Press C to clear points", 10, height-40 );

	switch (stage){
		case 1: textRHC( "Current stage: Adding vertices.", 10, height-60 ); break;
		case 2: textRHC( "Current stage: Adding edges.", 10, height-60 ); break;
		case 3: textRHC( "Current stage: Marking terminal vertices.", 10, height-60 ); break;
		default: textRHC( "Current stage: Error.", 10, height-60 );
	}

	for (int i = 0; i < points.size(); i++) {
  		textRHC( i+1, points.get(i).p.x+5, points.get(i).p.y+15 );
	}
}

void keyPressed(){
	if( key == '1' ) {stage = 1; start = null; }
	if( key == '2' ) stage = 2;
	if( key == '3' ) {stage = 3; start = null; }
	if( key == '4' ) { Shortest_Path_based_Approximate_Algorithm(points, edges); } //Run Streiner Tree Algorithm
  	if( key == 'c' ) { points.clear(); edges.clear(); }
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
	int mouseXRHC = mouseX;
	int mouseYRHC = height-mouseY;

	float dT = 6;
	for ( Point p : points ) {
		float d = dist( p.p.x, p.p.y, mouseXRHC, mouseYRHC );
		if( d < dT ){
			dT = d;
			sel = p;
		}
	}

	switch (stage) {
		case 1: if (sel == null) { points.add( new Point(mouseXRHC,mouseYRHC) );} break;
		case 2: if (sel != null) {
			if (start == null) { start = sel; }
			else {
				if (start == sel) { start = null; }
				else { end = sel;
					JFrame jf = new JFrame();
					jf.setAlwaysOnTop(true);
					String weight = JOptionPane.showInputDialog(jf,"Enter the edge weight.");
					if ( isInt(weight) ){ 
						edges.add( new Edge(start, end, Integer.parseInt(weight) ) );  }
						else { JOptionPane.showMessageDialog(null, "The weight have to be a positive number. Try again.", "Error", JOptionPane.ERROR_MESSAGE); }
						start = end = null; }
					}
				} break;
		case 3: if (sel != null) { sel.mark(); } break;
		default:
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
