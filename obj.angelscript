#include "FrameTimer.angelscript"
#include "isPointInRect.angelscript"

class obj
{

	private vector2 m_size;
	private vector2 m_pos;
	private vector2 m_origin = vector2(0.5f,0.5f);

	private uint m_uid;//this can be used as a unique id identifier

	private string m_font = "Verdana14_shadow.fnt";

	private bool m_mouseover=false;
	private bool m_mousedown=false;
	private bool m_pressed=false;

	private string m_label = "none";

	private uint m_white = ARGB(255,255,255,255);
	private uint m_grey = ARGB(180,180,180,180);
	private uint m_red = ARGB(255,255,0,0);


	//-----------------

	obj(){}

	void update(){
		ETHInput@ input = GetInputHandle();

		if( is_point_in_bb(input.GetCursorPos()) ){
			//vector2 pos = get_relative_position();
			//DrawText( pos , m_label, m_font, m_white);
			//DrawText( pos , "something something", "Verdana14_shadow.fnt", ARGB(250,255,255,255));
			//DrawShapedSprite("sprites/pixel_white.png", vector2(100,200), vector2(100,20), RED);
			m_mouseover=true;
		}else{
			m_mouseover=false;
		}

	}

	vector2 get_position(){
		return m_pos;
	}
	void set_position(const vector2 pos){
		m_pos = pos;
	}
	void set_label(string label){
		m_label=label;
	}

	string get_label(){
		return m_label;
	}

	vector2 get_size(){
		return m_size;
	}
	uint get_uid(){
		return m_uid;
	}

	//------
	bool is_point_in_bb(const vector2 &in p) const{
		return (isPointInRect(p, m_pos, m_size, m_origin));
	}
	vector2 get_relative_position(){
		get_position();
		return vector2(m_pos.x - m_size.x * m_origin.x, m_pos.y - m_size.y * m_origin.y);
	}
	//----
	bool is_pressed(){
		return m_pressed;
	}
	bool is_mouseover(){
		return m_mouseover;
	}
	bool is_mousedown(){
		return m_mousedown;
	}
	//---------
}
