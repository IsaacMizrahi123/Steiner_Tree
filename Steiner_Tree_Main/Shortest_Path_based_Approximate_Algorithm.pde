import java.util.*;

void Shortest_Path_based_Approximate_Algorithm (ArrayList<Point> vertices, ArrayList<Edge> edges) {
	solNodes.clear();
	solEdges.clear();
	nodes.clear();
	decolorTree();

	PriorityQueue<Edge> queue = new PriorityQueue<Edge>(edges);

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

	printArray("Nodes", solNodes);
	printArray("Edges", solEdges);

	//Create data structure to represent the minimum spaning tree
	for (Edge edge : solEdges) {
		if (nodes.containsKey(edge.p0)) { nodes.get(edge.p0).add(edge.p1); }
		else{ nodes.put(edge.p0, new ArrayList<Point>()); nodes.get(edge.p0).add(edge.p1); }

		if (nodes.containsKey(edge.p1)) { nodes.get(edge.p1).add(edge.p0); }
		else{ nodes.put(edge.p1, new ArrayList<Point>()); nodes.get(edge.p1).add(edge.p0); }
	}

	printMap();

	for (Point p : solNodes) {
		if (p.marked) {
			startPrunning(p);
			break;
		}
	}

	printArray("Nodes", solNodes);
	printArray("Edges", solEdges);
	printMap();
	System.out.print("\n \n");

	colorTree();

}

void startPrunning (Point root) {
	for (Point p : new ArrayList<Point>(nodes.get(root))) {
		cutTree(p,root);
	}
}

void cutTree (Point current, Point dad) {
	if (nodes.get(current).size() > 1) {
		for (Point p : new ArrayList<Point>(nodes.get(current))) {
			if (p!=dad) {
				cutTree(p,current);
			}
		}
	}

	if (nodes.get(current).size() == 1 && !current.marked) {
		nodes.get(dad).remove(current);
		solNodes.remove(current);
		nodes.remove(current);
		removeEdge(current, dad);
	}
}

void removeEdge (Point p0, Point p1) {
	Edge edge = null;
	for (Edge e : solEdges) {
		if ( (e.p0==p0 && e.p1==p1) || (e.p0==p1 && e.p1==p0) ) {
			edge = e;
			break;
		}
	}
	solEdges.remove(edge);
}

void printArray (String title, ArrayList list) {
	System.out.print(title+":\n");
	for (Object p : list) {
		System.out.print(p.toString()+"\n");
	}
}

void printMap () {
	System.out.print("Map:\n");
	for (Point p : nodes.keySet()) {
		System.out.print(p.toString()+": "+nodes.get(p)+"\n");
	}
}
