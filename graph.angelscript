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
   	int index;
   	vector2 position;

   	int[] corner_ids;//i need to just get the ids first, before connecting it to the objects of these objects
   	int[] neighbor_ids;
   	int[] border_ids;

   	graph_corner@[] corners;
    graph_center@[] neighbors;
    graph_edge@[] borders;

    graph_center(const int id, const vector2 p, const int[] c, const int[] n, const int[] b){
    	index = id;
    	position = p;
    	
    	corner_ids = c;
    	neighbor_ids = n;
    	border_ids = b;
    }

    //void couple(){

    //}
}

class graph_corner : graph_point_data{
	int index;//this is every point in the grid already

    int[] touches_ids;//i need to just get the ids first, before connecting it to the objects of these objects
    int[] protrudes_ids;
    int[] adjacent_ids;

    graph_center@[] touches;
    graph_edge@[] protrudes;
    graph_corner@[] adjacent;
  
    //int river; // 0 if no river, or volume of water in river
    //graph_corner@ downslope; // pointer to adjacent corner most downhill

    graph_corner(const int id, const int[] t, const int[] p, const int[] a){
    	index = id;

        touches_ids = t;
        protrudes_ids = p;
        adjacent_ids = a;
    }
}

class graph_edge{
	int index;

	int[] voronoi_ids;
	int[] delaunay_ids;

	graph_corner@ v0; // Voronoi edge
    graph_corner@ v1;
    graph_center@ d0; // Delaunay edge
    graph_center@ d1;
    vector2 midpoint; // halfway between v0,v1

    graph_center@[] joins;//polys on either side of the voroni edge
    graph_edge@[] continues;//edges to either side // allow perpendicular?  // also know as loop
    //end points are given
    //int river; // volume of water, or 0

    graph_edge(const int id, const int[] v, const int[] d){
    	index = id;
    	voronoi_ids = v;
    	delaunay_ids = d;
    }
}

class graph{
	//private vector2[] grid_points;  // Only useful during graph construction

    graph_center@[] centers;
    graph_corner@[] corners;
    graph_edge@[] edges;

    graph(const vector2[] p, const int x, const int y){//give it all the points, and the x and y values to chop it up with
    	//grid_points = p;

        int nx = x-1;
        int ny = y-1;

        float off = 0.0f;
        float offb = 0.0f;

    	//each grid point is actually a corner
    	for( int t = 0; t < p.length(); t++ ){
    		//determine which polys it touches
    		//determine which edges come off this corner
    		//determine which points are adjacent -- allow diagonals?
            off = t/nx;
            offb = t/x;

            
            int t0 = (t-x+1%x>0)? t-x-offb : -1;;//(t+off%(nx-1)>0) ? t-nx-1 : -1;//this one is creating one when it shouldne at the end of the row
            int t1 = (t-x-1%x>0)? t-nx-offb : -1;//(t%(nx) > 0) ? t+1 : -1;//this one is broken, all the other ones work fine
            int t2 = (t+1%x>0)? t-offb : -1;//(t+(nx+1) < x*y) ? t+(nx+1) : -1;
            int t3 = (t%x>0)? t-offb-1 : -1;//(t+1%(nx) > 0 ) ? t-1 : -1;

            //int e0 = ;
            //int e1 = ;
            //int e2 = ;
            //int e3 = ;

            int a0 = (t+off%(nx-1)>0) ? t-nx-1 : -1;
            int a1 = (t%(nx) > 0) ? t+1 : -1;//this one is broken, all the other ones work fine
            int a2 = (t+(nx+1) < x*y) ? t+(nx+1) : -1;
            int a3 = (t+1%(nx) > 0 ) ? t-1 : -1;//this one is a bit wanky too

            int[] touches_ids = {t0,t1,t2,t3};//the centers that are touching to this corner point
            int[] protrudes_ids = {-1,-1,-1,-1};//the edges that protrude from this point
            int[] adjacent_ids = {a0,a1,a2,a3};//corners that are near // should i include diagonals?

            corners.insertLast( graph_corner( t,touches_ids,protrudes_ids,adjacent_ids ) );//add basic center
    	}


    	//centers
		//this is going to loop for each square, so each NODE, not every point of the grid
		//off = 0.0f;
		
		for( int t = 0 ; t < nx*ny ; t++ ){
			off = t/nx;
			
			//0,1,11,10-0  //1,2,12,11-1  //2,3,13,12-2  //8,9,19,18-8  //10,11,21,20-9  //20,21,31,30-18

			//corner point ids
			int p0 = t + off;
			int p1 = p0+1;
			int p2 = p0+x+1;
			int p3 = p0+x;

			//neighbor center ids
			int n0 = ((t+1)%nx > 0) ? t+1 : -1;
			int n1 = (t+nx < nx*ny) ? t+nx : -1;
			int n2 = (t%nx > 0) ? t-1 : -1;
			//int n3 = (t-nx > 0) ? t-nx : -1;
            int n3 = t-nx;
			//allow diagonals?
			//if so need for more
			
			//edges, i need to make 2 edges per center point, top edge and left edge
			//also need to make 2 more edges based on the corresponding edge that they cross, some wont have any
			//edge arrays //voronoi edge
			int[] v0 = {p0,p1};//top edge
			int[] v1 = {p3,p0};//left edge
			//now the dulany edge that crosses, which it may or maynot have
			int[] d0 = {n3,t};
			int[] d1 = {n2,t};

            //border edges
			int e0 = t*2;
			int e1 = e0+1;
            //these 2 are pulled from 2 different centers, just calculating the edge numbesr they will be based on our system
            int e2 = (t+nx < nx*ny) ? ((nx)*2)+(t*2) : -1;
			int e3 = ((t+1)%nx > 0)? e0+3 : -1;//( t%nx > 0 ) ? e0+3 : -1;
			//int e3 = ( t < (2*(nx-1))*(nx-1) ) ? (t+1)*(2*(nx-1)) : -1;
            

			int[] corner_ids = {p0,p1,p2,p3};//graph_corner@[] corn = {corners[p0],corners[p1],corners[p2],corners[p3]};//sets the squares corner points
			int[] neighbor_ids = {n0,n1,n2,n3};//
			int[] border_ids = {e0,e1,e2,e3};//edge ids


			//get my center points for each square
			vector2 add = p[p0] + p[p1] + p[p2] + p[p3];//center

			//centers.insertLast( graph_center( centers.length(),add/4.0f, corn ) );//add basic center 
			centers.insertLast( graph_center( centers.length(),add/4.0f, corner_ids, neighbor_ids, border_ids ) );//add basic center 
			
			//edges
			//i need to send more data to the edgs, centers and edges next and before
			edges.insertLast( graph_edge(edges.length(),v0,d0) );
			edges.insertLast( graph_edge(edges.length(),v1,d1) );
			//this does not get the edges on the far right
			//and very bottom

			
		}
    }

    //void center(const vector2 p){
    //	centers.insertLast();
    //}
}
