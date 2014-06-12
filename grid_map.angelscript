#include "grid.angelscript"
#include "perlin.angelscript"

class grid_map : grid{

	//private graph@ m_graph;
	//private bool m_temp = false;
	private perlin@ m_perlin;
	private float[] m_pnoise;

	grid_map(const uint xdiv=10, const uint ydiv=10, const float size=100.0f ){
		super(xdiv,ydiv,xdiv*size,ydiv*size);
		//m_graph = new graph(point,edges);
		@m_perlin = perlin();
		m_perlin.init();

		for(uint t=0;t<m_points_origin.length();t++){
			m_pnoise.insertLast( m_perlin.noise2( m_points_origin[t].x, m_points_origin[t].y,0.0016f,0.0016f ) );
		}
	}

	void update(){
		grid::update();

		matrix4x4 tr_m = translate(-m_camerapos.x,-m_camerapos.y,0.0f);//this is not doing anything, maybe a bug
		matrix4x4 t_m = multiply(tr_m,scale(m_gscale,m_gscale,m_gscale));


		int debug_noise = 0;
		if(debug_noise > 0){

			//draw all the centers
			for(uint t = 0; t < m_centers.length(); t++){
				draw_point(multiply(m_centers[t],multiply(t_m,m_isomatrix))-m_camerapos, m_white, abs(m_pnoise[t])*8.0f);
			}
			//DrawText( vector2(0,304) , m_pnoise[0]+"", "Verdana14_shadow.fnt", ARGB(250,255,255,255));

		}
		
	}

}
