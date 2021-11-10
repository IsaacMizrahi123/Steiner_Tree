import java.util.*;

void Shortest_Path_based_Approximate_Algorithm (ArrayList<Point> vertices, ArrayList<Edge> edges) {
	//ArrayList<Point> solNodes = new ArrayList<Point>();
	//ArrayList<Edge> solEdges = new ArrayList<Edge>();
	solNodes.clear();
	solEdges.clear();
	nodes.clear();

	PriorityQueue<Edge> queue = new PriorityQueue<Edge>();
	for (Edge edge : edges) {
		queue.add(edge);
	}

	// Kruskal Algorithm
	Edge e;
	while (!queue.isEmpty() && solNodes.size() != vertices.size()) {
		e = queue.poll();
		if (!(solNodes.contains(e.p0) && solNodes.contains(e.p1))) {
			solEdges.add(e);
			if (!solNodes.contains(e.p0)) { solNodes.add(e.p0); }
			if (!solNodes.contains(e.p1)) { solNodes.add(e.p1); }
		}
	}

	System.out.print("Nodes:\n");
	for (Point p : solNodes) {
		System.out.print(p.toString()+"\n");
	}
	System.out.print("Edges:\n");
	for (Edge edge : solEdges) {
		System.out.print(edge.toString()+" with weight "+str(edge.weight)+"\n");
	}

	//Create data structure to represent the minimum spaning tree
	//Map<Point, ArrayList<Point>> nodes = new HashMap<Point, ArrayList<Point>>();
	for (Edge edge : solEdges) {
		if (nodes.containsKey(edge.p0)) {
			nodes.get(edge.p0).add(edge.p1);
		}else{ 
			nodes.put(edge.p0, new ArrayList<Point>());
			nodes.get(edge.p0).add(edge.p1);
		}

		if (nodes.containsKey(edge.p1)) {
			nodes.get(edge.p1).add(edge.p0);
		}else{ 
			nodes.put(edge.p1, new ArrayList<Point>());
			nodes.get(edge.p1).add(edge.p0);
		}
	}

	System.out.print("Map:\n");
	for (Point p : nodes.keySet()) {
		System.out.print(p.toString()+": "+nodes.get(p)+"\n");
	}

	for (Point p : solNodes) {
		System.out.print("Trying to find marked.\n");
		if (p.marked) {
			System.out.print("Found marked node.\n");
			startPrunning(p);
			break;
		}		
	}

	System.out.print("Nodes:\n");
	for (Point p : solNodes) {
		System.out.print(p.toString()+"\n");
	}
	System.out.print("Edges:\n");
	for (Edge edge : solEdges) {
		System.out.print(edge.toString()+" with weight "+str(edge.weight)+"\n");
	}
	System.out.print("Map:\n");
	for (Point p : nodes.keySet()) {
		System.out.print(p.toString()+": "+nodes.get(p)+"\n");
	}
	System.out.print("\n \n");

}

void startPrunning(Point root) {
	ArrayList<Point> list = new ArrayList<Point>();
	for (Point p : nodes.get(root)) {
		list.add(p);
	}
	for (Point p : list) {
		cutTree(p,root);
	}

}

void cutTree(Point current, Point dad) {
	System.out.print("cutTree\n");
	if (nodes.get(current).size() > 1) {
		for (Point p : nodes.get(current)) { //Error here
			if (p!=dad) {
				cutTree(p,current);
			}
		}
	}
	System.out.print("After first if\n");
	if (nodes.get(current).size() == 1 && !current.marked) {
		nodes.get(dad).remove(current);
		solNodes.remove(current);
		nodes.remove(current);
		removeEdge(current, dad);
	}
	System.out.print("After second if\n");
}

void removeEdge(Point p0, Point p1) {
	System.out.print("Removing edge\n");
	Edge edge = null;
	for (Edge e : solEdges) {
		System.out.print("Looking for edge\n");
		if ( (e.p0==p0 && e.p1==p1) || (e.p0==p1 && e.p1==p0)) {
			edge = e;
			break;
		}
	}
	solEdges.remove(edge);
}
