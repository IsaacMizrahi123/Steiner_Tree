import java.util.*;

void Shortest_Path_Dijkstra () {
	neighbours.clear();
	solNodes.clear();
	solEdges.clear();
	decolorTree();

	for (Edge edge : edges) {
		if (neighbours.containsKey(edge.p0)) { neighbours.get(edge.p0).add(edge.p1); }
		else{ neighbours.put(edge.p0, new ArrayList<Point>()); neighbours.get(edge.p0).add(edge.p1); }

		if (neighbours.containsKey(edge.p1)) { neighbours.get(edge.p1).add(edge.p0); }
		else{ neighbours.put(edge.p1, new ArrayList<Point>()); neighbours.get(edge.p1).add(edge.p0); }
	}

	ArrayList<Point> terminals = new ArrayList<Point>();
	for (Point p : points) {
		if (p.marked) { terminals.add(p); }
	}

	//Start with a subtree T consisting of one given terminal
	if (!terminals.isEmpty()) {
		solNodes.add(terminals.get(0));
		terminals.remove(0);

		while (!terminals.isEmpty()) {

			//Select the shortest path between a terminal to the solution
			Path closestTerminal = null;
			for (Point t : terminals) {
				Path path = Modify_Dijkstra(t);
				if (closestTerminal == null) { closestTerminal = path; }
				else{
					if (path.weight < closestTerminal.weight) {
						closestTerminal = path;
					}
				}
			}

			//Add path to solution
			Point base, conecting;
			for (int i = 1; i<closestTerminal.path.size(); i++) {
				base = closestTerminal.path.get(i-1);
				conecting = closestTerminal.path.get(i);
				if (conecting.marked && terminals.contains(conecting)) { terminals.remove(conecting); }
				solNodes.add(conecting);
				solEdges.add(findEdge(base,conecting));
			}

		}

		//printArray("Nodes", solNodes);
		//printArray("Edges", solEdges);

		colorTree();
	}
}

class Path {
	public ArrayList<Point> path;
	public int weight;

	public Path (ArrayList<Point> _path, int _weight) {
		path = _path;
		weight = _weight;
	}
}

Path Modify_Dijkstra (Point terminal) {

	Map<Point, Integer> distance = new HashMap<Point, Integer>();
	Map<Point, Point> previous = new HashMap<Point, Point>();

	for (Point p : points) {
		previous.put(p,null);
		if (p == terminal) { distance.put(p,0);	}
		else { distance.put(p,Integer.MAX_VALUE); }
	}

	//Modified Dijkstra
	ArrayList<Point> unvisited = new ArrayList<Point>(points);
	Point closestMarkedNode = null;
	Point visiting;
	while (!unvisited.isEmpty()) {
		visiting = nextToVisit(unvisited, distance);
		if (distance.get(visiting)==Integer.MAX_VALUE) { unvisited.clear();	}
		else {
			if (solNodes.contains(visiting)) {
				if (closestMarkedNode==null || distance.get(visiting)<distance.get(closestMarkedNode)) { closestMarkedNode =  visiting; }
			}
			else{
				for (Point neighbour : neighbours.get(visiting)) {
					if (unvisited.contains(neighbour) && distance.get(neighbour)>(distance.get(visiting)+findWeigthEdge(visiting,neighbour)) ) {
						distance.put(neighbour, distance.get(visiting)+findWeigthEdge(visiting,neighbour));
						previous.put(neighbour, visiting);
					}
				}
			}
			unvisited.remove(visiting);
		}
	}

	ArrayList<Point> path = new ArrayList<Point>();
	Point p = closestMarkedNode;
	int minWeight = distance.get(p);
	while (p!=null) {
		path.add(p);
		p = previous.get(p);
	}
	return new Path(path,minWeight);
}

int findWeigthEdge (Point p0, Point p1) {
	Edge edge = null;
	for (Edge e : edges) {
		if ( (e.p0==p0 && e.p1==p1) || (e.p0==p1 && e.p1==p0) ) {
			return e.weight;
		}
	}
	return 0;
}

Edge findEdge (Point p0, Point p1) {
	Edge edge = null;
	for (Edge e : edges) {
		if ( (e.p0==p0 && e.p1==p1) || (e.p0==p1 && e.p1==p0) ) {
			return e;
		}
	}
	return null;	
}

Point nextToVisit (ArrayList<Point> unvisited, Map<Point, Integer> distance) {
	Point minDistance = unvisited.get(0);
	for (Point p : unvisited) {
		if (distance.get(p)<distance.get(minDistance)) {
			minDistance = p;
		}
	}
	return minDistance;
}

void colorTree() {
	for (Point p : solNodes) {
		p.partOfTree = true;
	}
	for (Edge e : solEdges) {
		e.partOfTree = true;
	}
}

void decolorTree() {
	for (Point p : points) {
		p.partOfTree = false;
	}
	for (Edge e : edges) {
		e.partOfTree = false;
	}
}
