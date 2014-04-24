class graph_point_data{
	/*bool water; // lake or ocean
    bool ocean; // ocean
    bool coast; // land polygon touching an ocean
    bool border; // at the edge of the map
    float elevation; // 0.0-1.0
    float moisture; // 0.0-1.0*/
}

class graph_center : graph_point_data{
   // string biome; // biome type (see article)
   	uint index;
   	vector2 position;
   	graph_corner@[] corners;

    graph_center@[] neighbors;
    graph_edge@[] borders;

    graph_center(const uint id, const vector2 p, const graph_corner@[] c){
    	index = id;
    	position = p;
    	corners = c;
    }
}

class graph_corner : graph_point_data{
	uint index;//this is every point in the grid already

    graph_center@[] touches;
    graph_edge@[] protrudes;
    graph_corner@[] adjacent;
  
    //int river; // 0 if no river, or volume of water in river
    //graph_corner@ downslope; // pointer to adjacent corner most downhill

    graph_corner(const uint id){
    	index = id;
    }
}

class graph_edge{
	int index;

    graph_center@ d0; // Delaunay edge
    graph_center@ d1;
    graph_corner@ v0; // Voronoi edge
    graph_corner@ v1;
    vector2 midpoint; // halfway between v0,v1
    //int river; // volume of water, or 0
}

class graph{
	private vector2[] grid_points;  // Only useful during graph construction

    graph_center@[] centers;
    graph_corner@[] corners;
    graph_edge@[] edges;

    graph(const vector2[] p, const uint x, const uint y){//give it all the points, and the x and y values to chop it up with
    	grid_points = p;

    	//each grid point is actually a corner
    	for( uint t = 0; t < p.length(); t++ ){
    		corners.insertLast( graph_corner( t ) );//add basic center
    	}

		//this is going to loop for each square, so each NODE, not every point of the grid
		float off = 0.0f;
		for( uint t = 0 ; t < (x-1)*(y-1) ; t++ ){
			off = t/(x-1);
			
			//0,1,11,10-0
			//1,2,12,11-1
			//2,3,13,12-2
			//8,9,19,18-8
			//10,11,21,20-9
			//20,21,31,30-18

			uint p0 = t + off;
			uint p1 = p0+1;
			uint p2 = p0+x+1;
			uint p3 = p0+x;

			//get my center points for each square
			vector2 add = grid_points[p0] + grid_points[p1] + grid_points[p2] + grid_points[p3];//center
			graph_corner@[] corn = {corners[p0],corners[p1],corners[p2],corners[p3]};//sets the squares corner points
			

			centers.insertLast( graph_center( centers.length(),add/4.0f, corn ) );//add basic center 
			

			//edge arrays
			//uint[] e0 = {p0,p1};//top edge
			//uint[] e1 = {p3,p0};//left edge
		}
    }

    //void center(const vector2 p){
    //	centers.insertLast();
    //}
}
