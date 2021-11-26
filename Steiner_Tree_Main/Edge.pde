class Edge implements Comparable<Edge>{
	
	Point p0,p1;
	int weight;
	boolean partOfTree = false;

	Edge (Point _p0, Point _p1, int _weight) {
		p0 = _p0; p1 = _p1; weight = _weight;
	}

	void draw(){
		if (partOfTree){ stroke(255,0,0); }
		else { stroke(100); }
		line( p0.p.x, p0.p.y, 
			p1.p.x, p1.p.y );
	}

	void drawDotted(){
		float steps = p0.distance(p1)/6;
		for (int i=0; i<=steps; i++) {
			float x = lerp(p0.p.x, p1.p.x, i/steps);
			float y = lerp(p0.p.y, p1.p.y, i/steps);
			 //noStroke();
			ellipse(x,y,3,3);
		}
	}

	public String toString(){
		return "<" + p0 + "" + p1 + "> With weight "+str(this.weight);
	}

	@Override
	public int compareTo (Edge e) {
		return e.weight < this.weight ? 1 : -1;
	}

	public boolean has(Point p){
		if (p0 == p || p1 == p) {
			return true;
		}
		return false;
	}

	public float distance (float x, float y) {
		float x_1 = p0.p.x;
		float y_1 = p0.p.y;
		float x_2 = p1.p.x;
		float y_2 = p1.p.y;

		float dx = x_2 - x_1; 
		float dy = y_2 - y_1; 
		float d = sqrt( dx*dx + dy*dy ); 
		float c = dx/d;
		float s = dy/d; 
		float mX = (-x_1+x)*c + (-y_1+y)*s;

		float distanceX;
		float distanceY; 
		if (mX <= 0) 		{	distanceX = x_1; 		distanceY = y_1; }
		else if (mX >= d) 	{	distanceX = x_2; 		distanceY = y_2; }
		else 				{	distanceX = x_1 + mX*c;	distanceY = y_1 + mX*s;	}

		dx = x - distanceX; 
		dy = y - distanceY; 

		return sqrt( dx*dx + dy*dy ); 
	}

}
