#include "obj.angelscript"
class minimap : obj
{
	//this class will be a minimap in the corner of he screen. It will allow us to move the camera around indipendant of the character
	//as well as giving us an option to zoom in and out 

	private float m_format = 100.0f;//this is the height of the map at the corner
	private float m_aspect;

	//private float m_intmargin = 200.0f;//this is the margin to the interior edge of the map, so that nothing lives on the very edge, in world size
	private float m_extmargin = 20.0f;//the margin of this to the edge of the screen

	private vector2 m_tl;//top left vector position
	private vector2 m_br;//bottom right position
	private vector2 m_tr;//top right
	private vector2 m_bl;//bottom left

	private float m_zoom = 4;//this is the zoom factor, 1, is one to one, what is on screen, higher numbers zoomz out, lower than one might make it zoom in

	private vector2[] m_plottable_positions;//positions
	private uint[] m_plottable_colors;//colors

	minimap(){
		set_format(m_format);
	}

	void set_format(const float f){
		const vector2 ss = GetScreenSize();
		m_format = f;
		m_aspect = ss.x/ss.y;
		m_size = vector2(f*m_aspect,f);

		m_tl = vector2( ss.x-(m_size.x+m_extmargin), ss.y-(m_size.y+m_extmargin) );
		m_br = vector2( ss.x-m_extmargin, ss.y-m_extmargin );

		m_tr = vector2(m_br.x,m_tl.y);
		m_bl = vector2(m_tl.x,m_br.y);

	}

	void plottable(const vector2 p){//positions and color
		
		m_plottable_positions.insertLast(p);
		//m_plottable_colors.inserLast(c);

	}

	void update(){
		//here is where we draw the maps data, starting with the edges
		draw_line( m_tl, m_tr, m_white, m_white, 1.0f );//top
		draw_line( m_tr, m_br, m_white, m_white, 1.0f );//right
		draw_line( m_bl, m_br, m_white, m_white, 1.0f );//bottom
		draw_line( m_tl, m_bl, m_white, m_white, 1.0f );//left


		//after everything, empty the arrays
		//m_plottable_positions = vector2[];
	}
	
}
