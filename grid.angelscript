#include "obj.angelscript"

class grid : obj{

	private uint m_xdiv;
	private uint m_ydiv;
	private float m_width;
	private float m_height;
	//private vector2 m_offset = vector2(0.5f,0.5f);

	private vector2[] m_points;
	private vector2[] m_points_origin;

	//private uint[] m_squares;//this should be an array of arrays, for each square
	private uint[][] m_lines;//this is an array of lines that we want to draw, that is 2 element arrays, from point 0 to point 1

	//private bool m_temp = false;

	grid(const uint xdiv=10, const uint ydiv=10, const float width=100.0f, const float height=100.0f ){
		init(xdiv,ydiv,width,height);
		construct();
	}

	void init( const uint xdiv=10, const uint ydiv=10, const float width=100.0f, const float height=100.0f ){
		m_xdiv = xdiv;
		m_ydiv = ydiv;
		m_width = width;
		m_height = height;
		//m_offset = offset;
	}
	/*void set_offset(const vector2 o){//this is if we want to explicitly set an offset to this thing.
		m_offset = o;
	}*/

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
				m_points_origin.insertLast( vector2(px,py) );

				//give me the horizontal lines to draw
				if( count%((m_xdiv)*1.0f) == 1  && count>1){//the count>1 cathces a bug that puts a huge value in the first element input
					uint[] lp = {count-(m_xdiv+1),count-2};
					m_lines.insertLast(lp);
				}

				count ++;
			}
		}
		//now i need to get the vertical lines to draw
		for (uint t = 0; t < m_ydiv; t++){
			//ep = ;//the end point, at the bottom of the grid
			uint[] lp = {t,((m_xdiv*m_ydiv)*1.0f)-((m_ydiv-t)*1.0f)};
			m_lines.insertLast(lp);
		}

	}

	void update(){
		//m_temp = true;
		obj::update();
		//for (uint t = 0; t < 4; t++){
		for (uint t = 0; t < m_lines.length(); t++){
			draw_line( m_points_origin[m_lines[t][0]], m_points_origin[m_lines[t][1]], m_white, m_white, 1.0f );
		}
		
		/*DrawText( vector2(0,264) , m_lines[0][0]+":"+m_lines[0][1], "Verdana14_shadow.fnt", ARGB(250,255,255,255));
		DrawText( vector2(0,284) , m_lines[1][0]+":"+m_lines[1][1], "Verdana14_shadow.fnt", ARGB(250,255,255,255));
		DrawText( vector2(0,304) , m_lines[2][0]+":"+m_lines[2][1], "Verdana14_shadow.fnt", ARGB(250,255,255,255));
		DrawText( vector2(0,324) , m_lines[3][0]+":"+m_lines[3][1], "Verdana14_shadow.fnt", ARGB(250,255,255,255));
		*/
		DrawText( vector2(0,264) , m_points_origin[0].x+":"+m_points_origin[0].y, "Verdana14_shadow.fnt", ARGB(250,255,255,255));
		DrawText( vector2(0,284) , m_points_origin[1].x+":"+m_points_origin[10].y, "Verdana14_shadow.fnt", ARGB(250,255,255,255));
		DrawText( vector2(0,304) , m_points_origin[2].x+":"+m_points_origin[20].y, "Verdana14_shadow.fnt", ARGB(250,255,255,255));
		DrawText( vector2(0,324) , m_points_origin[3].x+":"+m_points_origin[30].y, "Verdana14_shadow.fnt", ARGB(250,255,255,255));
	}

}
