#include "grid.angelscript"

class grid_map : grid{

	//private graph@ m_graph;
	//private bool m_temp = false;

	grid_map(const uint xdiv=10, const uint ydiv=10, const float width=1000.0f, const float height=1000.0f ){
		super(xdiv,ydiv,width,height);
		//m_graph = new graph(point,edges);
	}

	/*void init( const uint xdiv=10, const uint ydiv=10, const float width=100.0f, const float height=100.0f ){

	}

	void construct(){

	}*/

	/*
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
			for(uint t = 0; t < m_poly_center_origin.length(); t++){
				draw_point(multiply(m_poly_center_origin[t],multiply(t_m,m_isomatrix))-m_camerapos);
			}

			//now i can save the mouses position relative to this grids transforms, and iso metric matrix
			//so i will know what square the mouse is over
			m_isomousepos = multiply((m_relativemousepos*(1.0f/m_gscale)),m_isomatrix_inverted)+m_offset;//scale the relative mouse position.mutipled by the inverted matrix

			//determine which poly we are over.
			m_mousecell = ((floor(max(m_isomousepos.x,0.0f)/m_xstep)+1)+( floor(max(m_isomousepos.y,0.0f)/m_ystep)*(m_xdiv-1) ) )-1;

			//now draw line around cell mouse is over
			if(m_mousecell<=m_polys.length())
			for (uint t = 0; t < 4; t++){
				draw_line( multiply(m_points[m_polys[m_mousecell][t]],t_m)-m_camerapos, multiply(m_points[m_polys[m_mousecell][(t+1)%4]],t_m)-m_camerapos, m_whitelines, m_white, 1.0f );
			}

			DrawText( vector2(0,264) , m_mousecell+"", "Verdana14_shadow.fnt", ARGB(250,255,255,255));
			DrawText( vector2(0,284) , m_isomousepos.x+":"+m_isomousepos.y, "Verdana14_shadow.fnt", ARGB(250,255,255,255));
		}
	}
	*/

}
