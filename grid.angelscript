#include "obj.angelscript"
#include "graph.angelscript"

class grid : obj{

	private uint m_xdiv;//we need this valus, cause in update we are looking for it to have something
	private uint m_ydiv;
	private float m_width;
	private float m_height;
	private vector2 m_offset;
	private float m_xstep;//the distance between x divisions
	private float m_ystep;

	private vector2[] m_points;
	private vector2[] m_points_origin;

	private matrix4x4 m_isomatrix;
	private matrix4x4 m_isomatrix_inverted;//go ahead and keet the inverted one too, since there is no function to do so

	//private uint[][] m_poly;//this should be an array of arrays, for each square
	private uint[][] m_lines;//this is an array of lines that we want to draw, that is 2 element arrays, from point 0 to point 1
	
	private graph@ m_graph;

	private uint[][] m_corners;//the squares
	private vector2[] m_centers;//the center point of the polygon
	private uint[][] m_edges;//the edges that belong, the first is the top, the second is the left. //by nature, the far right, and bottom edges are not represented

	private vector2 m_isomousepos;//the mouse position relative to the isometric grid
	private uint m_mousecell;//the polygon that we are in

	private uint m_whitelines = ARGB(50,255,255,255);
	//private bool m_temp = false;

	grid(const uint xdiv=10, const uint ydiv=10, const float width=1000.0f, const float height=1000.0f ){
		m_isomatrix = multiply(scale(1.0f,0.5f,1.0f),rotateZ(degreeToRadian(45)));
		m_isomatrix_inverted = multiply(rotateZ(degreeToRadian(-45)),scale(1.0f,2.0f,1.0f));

		init(xdiv,ydiv,width,height);
		construct();
	}

	void init( const uint xdiv=10, const uint ydiv=10, const float width=100.0f, const float height=100.0f ){
		m_xdiv = xdiv;
		m_ydiv = ydiv;
		m_width = width;
		m_height = height;
		m_offset = vector2(width/2.0f,height/2.0f);
		m_xstep = width/(xdiv-1.0f);
		m_ystep = height/(ydiv-1.0f);
	}

	void construct(){
		//build out the points
		//0,1,2,3,4
		//5,6,7,8,9
		uint count = 0;
		for (uint x = 0; x < m_xdiv; x++){
			for (uint y = 0; y < m_ydiv; y++){
				//x,y points
				const float px = (count%((m_xdiv)*1.0f)) * (m_width/(m_xdiv-1.0f));//x = modulo count by xdiv * width / xdiv-1
				const float py = floor(count/(m_ydiv*1.0f)) * (m_height/(m_ydiv-1.0f));//floor((y*1.0f)/(m_ydiv*1.0f)) * (m_height/(m_ydiv*1.0f));//y = floor(y/ ydiv) * (ydiv/height)
				const vector2 p = vector2(px-m_offset.x,py-m_offset.y);
				m_points_origin.insertLast( p );
				m_points.insertLast( multiply(p,m_isomatrix) );//go ahead and multiply into iso style here as well

				count ++;
			}
		}
		//now i need to get the horizontal lines
		for(uint t = 0; t < m_xdiv; t++){
			uint[] lp = {(t*m_xdiv),((t+1)*m_xdiv)-1};
			m_lines.insertLast(lp);
		}
		//now i need to get the vertical lines to draw
		for (uint t = 0; t < m_ydiv; t++){
			uint[] lp = {t,((m_xdiv*m_ydiv)*1.0f)-((m_ydiv-t)*1.0f)};
			m_lines.insertLast(lp);
		}

		@m_graph = graph(m_points_origin,m_xdiv,m_ydiv);//build the graph

		//now I can determine which 4 points make a square
		float off = 0.0f;
		//this is going to loop for each square, so each NODE, not every point of the grid
		for( uint t = 0 ; t < (m_xdiv-1)*(m_ydiv-1) ; t++ ){
			off = t/(m_xdiv-1);//max(floor(t/max((m_xdiv-2),1)),0);
			
			//0,1,11,10-0
			//1,2,12,11-1
			//2,3,13,12-2
			//8,9,19,18-8

			//10,11,21,20-9
			
			//20,21,31,30-18

			uint p0 = t + off;
			uint p1 = p0+1;
			uint p2 = p0+m_xdiv+1;
			uint p3 = p0+m_xdiv;

			//get my center points for each square
			vector2 add = m_points_origin[p0] + m_points_origin[p1] + m_points_origin[p2] + m_points_origin[p3];
			m_centers.insertLast(add/4.0f); 
			//m_graph.center();
			
			//sets the squares corner points
			uint[] pp = {p0,p1,p2,p3};
			m_corners.insertLast(pp);

			/*if( ==1 ){//if we are 1 less than the x divisions
				off ++;
			}*/
		}
	}

	void update(){
		obj::update();
		if(m_xdiv>0){//this ensures that something has been set before going on. the divide by m_xdiv will crash otherwise
			//build the view matrix from scale and camera pos
			matrix4x4 tr_m = translate(-m_camerapos.x,-m_camerapos.y,0.0f);//this is not doing anything, maybe a bug
			matrix4x4 t_m = multiply(tr_m,scale(m_gscale,m_gscale,m_gscale));

			//draw line of the grid
			for (uint t = 0; t < m_lines.length(); t++){
				//draw_line( m_points[m_lines[t][0]]-m_camerapos, m_points[m_lines[t][1]]-m_camerapos, m_whitelines, m_whitelines, 1.0f );
				draw_line( multiply(m_points[m_lines[t][0]],t_m)-m_camerapos, multiply(m_points[m_lines[t][1]],t_m)-m_camerapos, m_whitelines, m_whitelines, 1.0f );
			}

			//draw center points of grids
			//DEBUGGING
			//draw all the centers
			/*for(uint t = 0; t < m_centers.length(); t++){
				draw_point(multiply(m_centers[t],multiply(t_m,m_isomatrix))-m_camerapos);
			}*/

			//now i can save the mouses position relative to this grids transforms, and iso metric matrix
			//so i will know what square the mouse is over
			m_isomousepos = multiply((m_relativemousepos*(1.0f/m_gscale)),m_isomatrix_inverted)+m_offset;//scale the relative mouse position.mutipled by the inverted matrix

			//determine which poly we are over.
			m_mousecell = ((floor(max(m_isomousepos.x,0.0f)/m_xstep)+1)+( floor(max(m_isomousepos.y,0.0f)/m_ystep)*(m_xdiv-1) ) )-1;

			//now draw line around cell mouse is over
			if(m_mousecell<=m_corners.length()){
				//draw the center
				draw_point(multiply(m_centers[m_mousecell],multiply(t_m,m_isomatrix))-m_camerapos, m_white);
				//draw the whole sqaure
				/*for (uint t = 0; t < 4; t++){
					draw_line( multiply(m_points[m_corners[m_mousecell][t]],t_m)-m_camerapos, multiply(m_points[m_corners[m_mousecell][(t+1)%4]],t_m)-m_camerapos, m_whitelines, m_white, 1.0f );
				}*/

				//draw the corners
				draw_point( multiply( m_points[ m_graph.centers[m_mousecell].corner_ids[0] ], t_m)-m_camerapos, m_white, 4);
				draw_point( multiply( m_points[ m_graph.centers[m_mousecell].corner_ids[1] ], t_m)-m_camerapos, ARGB(255,255,0,0), 4);
				draw_point( multiply( m_points[ m_graph.centers[m_mousecell].corner_ids[2] ], t_m)-m_camerapos, ARGB(255,0,255,0), 4);
				draw_point( multiply( m_points[ m_graph.centers[m_mousecell].corner_ids[3] ], t_m)-m_camerapos, ARGB(255,100,100,255), 4);
				//draw_point( multiply( m_points[m_corners[ m_graph.centers[m_mousecell].corner_ids[0]][0]], t_m)-m_camerapos, ARGB(255,255,0,0), 4);
				//draw_point( multiply( m_points[m_corners[ m_graph.centers[m_mousecell].corner_ids[0]][1]], t_m)-m_camerapos, ARGB(255,255,0,0), 4);
				//draw_point( multiply( m_points[m_corners[ m_graph.centers[m_mousecell].corner_ids[0]][2]], t_m)-m_camerapos, ARGB(255,0,255,0), 4);
				//draw_point( multiply( m_points[m_corners[ m_graph.centers[m_mousecell].corner_ids[0]][3]], t_m)-m_camerapos, ARGB(255,100,100,255), 4);

				//draw neighbors
				if(m_graph.centers[m_mousecell].neighbor_ids[0]>0)
					draw_point( multiply( m_centers[ m_graph.centers[m_mousecell].neighbor_ids[0]], multiply(t_m,m_isomatrix))-m_camerapos, m_white, 4);
				if(m_graph.centers[m_mousecell].neighbor_ids[1]>0)
					draw_point( multiply( m_centers[ m_graph.centers[m_mousecell].neighbor_ids[1]], multiply(t_m,m_isomatrix))-m_camerapos, ARGB(255,255,0,0), 4);
				if(m_graph.centers[m_mousecell].neighbor_ids[2]>0)
					draw_point( multiply( m_centers[ m_graph.centers[m_mousecell].neighbor_ids[2]], multiply(t_m,m_isomatrix))-m_camerapos, ARGB(255,0,255,0), 4);
				if(m_graph.centers[m_mousecell].neighbor_ids[3]>0)
					draw_point( multiply( m_centers[ m_graph.centers[m_mousecell].neighbor_ids[3]], multiply(t_m,m_isomatrix))-m_camerapos, ARGB(255,100,100,255), 4);

			}

			DrawText( vector2(0,264) , m_mousecell+"", "Verdana14_shadow.fnt", ARGB(250,255,255,255));
			DrawText( vector2(0,284) , m_isomousepos.x+":"+m_isomousepos.y, "Verdana14_shadow.fnt", ARGB(250,255,255,255));
			//DrawText( vector2(0,304) , m_graph.centers[0].corners[0].index+":"+m_graph.centers[1].corners[3].index, "Verdana14_shadow.fnt", ARGB(250,255,255,255));
			//DrawText( vector2(0,324) , m_graph.corners[0].index+":"+m_graph.corners[1].index, "Verdana14_shadow.fnt", ARGB(250,255,255,255));
			/*
			DrawText( vector2(0,304) , m_corners[0][0]+":"+m_corners[0][1]+":"+m_corners[0][2]+":"+m_corners[0][3], "Verdana14_shadow.fnt", ARGB(250,255,255,255));
			DrawText( vector2(0,324) , m_corners[1][0]+":"+m_corners[1][1]+":"+m_corners[1][2]+":"+m_corners[1][3], "Verdana14_shadow.fnt", ARGB(250,255,255,255));
			DrawText( vector2(0,344) , m_corners[2][0]+":"+m_corners[2][1]+":"+m_corners[2][2]+":"+m_corners[2][3], "Verdana14_shadow.fnt", ARGB(250,255,255,255));
			DrawText( vector2(0,364) , m_corners[9][0]+":"+m_corners[9][1]+":"+m_corners[9][2]+":"+m_corners[9][3], "Verdana14_shadow.fnt", ARGB(250,255,255,255));
			
			DrawText( vector2(0,264) , t_m.a11+":"+t_m.a12+":"+t_m.a13+":"+t_m.a14, "Verdana14_shadow.fnt", ARGB(250,255,255,255));
			DrawText( vector2(0,284) , t_m.a21+":"+t_m.a22+":"+t_m.a23+":"+t_m.a24, "Verdana14_shadow.fnt", ARGB(250,255,255,255));
			DrawText( vector2(0,304) , t_m.a31+":"+t_m.a32+":"+t_m.a33+":"+t_m.a34, "Verdana14_shadow.fnt", ARGB(250,255,255,255));
			DrawText( vector2(0,324) , t_m.a41+":"+t_m.a42+":"+t_m.a43+":"+t_m.a44, "Verdana14_shadow.fnt", ARGB(250,255,255,255));
			
			DrawText( vector2(0,264) , m_points_origin[0].x+":"+m_points_origin[0].y, "Verdana14_shadow.fnt", ARGB(250,255,255,255));
			DrawText( vector2(0,284) , m_points_origin[1].x+":"+m_points_origin[10].y, "Verdana14_shadow.fnt", ARGB(250,255,255,255));
			DrawText( vector2(0,304) , m_points_origin[2].x+":"+m_points_origin[20].y, "Verdana14_shadow.fnt", ARGB(250,255,255,255));
			DrawText( vector2(0,324) , m_points_origin[3].x+":"+m_points_origin[30].y, "Verdana14_shadow.fnt", ARGB(250,255,255,255));
			*/
		}
	}

	//void draw_debug(){

	//}

}
