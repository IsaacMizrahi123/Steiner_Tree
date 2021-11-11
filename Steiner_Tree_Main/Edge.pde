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

}
