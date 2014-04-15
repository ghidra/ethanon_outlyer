#include "obj.angelscript"

class grid : obj{

	private uint m_xdiv;
	private uint m_ydiv;
	private float m_width;
	private float m_height;
	private vector2 m_offset;

	private vector2[] m_points;
	private vector2[] m_points_origin;

	private matrix4x4 m_isomatrix;

	//private uint[][] m_poly;//this should be an array of arrays, for each square
	private uint[][] m_lines;//this is an array of lines that we want to draw, that is 2 element arrays, from point 0 to point 1
	private uint m_whitelines = ARGB(50,255,255,255);
	//private bool m_temp = false;

	grid(const uint xdiv=10, const uint ydiv=10, const float width=1000.0f, const float height=1000.0f ){
		m_isomatrix = multiply(scale(1.0f,0.5f,1.0f),rotateZ(degreeToRadian(45)));
		init(xdiv,ydiv,width,height);
		construct();
	}

	void init( const uint xdiv=10, const uint ydiv=10, const float width=100.0f, const float height=100.0f ){
		m_xdiv = xdiv;
		m_ydiv = ydiv;
		m_width = width;
		m_height = height;
		m_offset = vector2(width/2.0f,height/2.0f);
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
				m_points.insertLast( multiply(p,m_isomatrix) );

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
	}

	void update(){
		obj::update();
		for (uint t = 0; t < m_lines.length(); t++){
			//subtract camera pos to put it in camera space
			draw_line( m_points[m_lines[t][0]]-m_camerapos, m_points[m_lines[t][1]]-m_camerapos, m_whitelines, m_whitelines, 1.0f );
		}
		
		/*
		DrawText( vector2(0,264) , m_lines[7][0]+":"+m_lines[7][1], "Verdana14_shadow.fnt", ARGB(250,255,255,255));
		DrawText( vector2(0,284) , m_lines[8][0]+":"+m_lines[8][1], "Verdana14_shadow.fnt", ARGB(250,255,255,255));
		DrawText( vector2(0,304) , m_lines[9][0]+":"+m_lines[9][1], "Verdana14_shadow.fnt", ARGB(250,255,255,255));
		DrawText( vector2(0,324) , m_lines[10][0]+":"+m_lines[10][1], "Verdana14_shadow.fnt", ARGB(250,255,255,255));
		
		DrawText( vector2(0,264) , m_points_origin[0].x+":"+m_points_origin[0].y, "Verdana14_shadow.fnt", ARGB(250,255,255,255));
		DrawText( vector2(0,284) , m_points_origin[1].x+":"+m_points_origin[10].y, "Verdana14_shadow.fnt", ARGB(250,255,255,255));
		DrawText( vector2(0,304) , m_points_origin[2].x+":"+m_points_origin[20].y, "Verdana14_shadow.fnt", ARGB(250,255,255,255));
		DrawText( vector2(0,324) , m_points_origin[3].x+":"+m_points_origin[30].y, "Verdana14_shadow.fnt", ARGB(250,255,255,255));
		*/
	}

}
