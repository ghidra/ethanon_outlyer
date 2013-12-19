#include "FrameTimer.angelscript"
#include "isPointInRect.angelscript"

class obj
{

	private vector2 m_size;
	private vector2 m_pos;
	private vector2 m_origin = vector2(0.5f,0.5f);
	private float m_gscale = 1.0f;

	private uint m_uid;//this can be used as a unique id identifier

	private string m_font = "Verdana14_shadow.fnt";

	private ETHInput@ m_input;

	private bool m_mouseover=false;
	private bool m_mousedown=false;
	private bool m_pressed=false;

	private bool m_onscreen=false;

	private vector2 m_relativemousepos;
	private vector2 m_mousepos;
	private vector2 m_camerapos;
	private vector2 m_screensize;

	private vector2 m_vo = vector2(1.0f,0.0f);//the 0 direction angle vector
	private vector2 m_vu = vector2(0.0f,-1.0f);//vector that points up, these are to check angles against

	private string m_label = "none";

	private uint m_white = ARGB(255,255,255,255);
	private uint m_grey = ARGB(180,180,180,180);
	private uint m_red = ARGB(255,255,0,0);
	private uint m_black = ARGB(255,0,0,0);


	//-----------------

	obj(){}

	void update(){
		//ETHInput@ input = GetInputHandle();
		@m_input = GetInputHandle();
		m_mousepos = m_input.GetCursorPos();
		m_screensize = GetScreenSize();
		m_camerapos = GetCameraPos();

		m_relativemousepos = m_mousepos+m_camerapos;//the mouse position relative to the camera
		//const vector2 screencenter = screensize*0.5f;
		//const vector2 relscreenpos = camerapos;//the position relative to the camera

		//trying to figure out if this object is even visible on screen
		m_onscreen = isPointInRect(m_pos, m_camerapos, m_screensize, vector2(0.0f,0.0f));

		if( is_point_in_bb(m_relativemousepos) && m_onscreen){
			m_mouseover=true;
		}else{
			m_mouseover=false;
		}

		m_gscale = GetScale();

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
	bool isPointInRect(const vector2 &in p, const vector2 &in pos, const vector2 &in size, const vector2 &in origin)
	{	
		vector2 posRelative = vector2(pos.x - size.x * origin.x, pos.y - size.y * origin.y);
		if (p.x < posRelative.x || p.x > posRelative.x + size.x || p.y < posRelative.y || p.y > posRelative.y + size.y)
			return false;
		else
			return true;
	}
	vector2 get_screen_position(){//get the position of this on screen for drawing of UI elements
		const vector2 camerapos = GetCameraPos();
		return m_pos-camerapos;
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
	void draw_line(const vector2 p1, const vector2 p2, const uint c1, const uint c2, const float w){
		//DrawLine();

		//i need to determine the direction this line is going
		const float a = draw_angle(normalize(p2-p1));
		const float l = length(p2-p1);

		DrawShapedSprite("sprites/pixel_white.png", p1, vector2(l, w), c1,a);
	}
	//get the dot product between 2 vectors
	float dot(const vector2 v1, const vector2 v2){
		return v1.x*v2.x + v1.y* v2.y;
	}
	float angle_between(const vector2 v1, const vector2 v2){
		return acos(dot(v1,v2))*(180/PI);
	}
	float draw_angle(const vector2 dir){
		const float neg = dot(dir, m_vu);//determine if we need to negate the angle value
		float a = angle_between(dir,m_vo);
		if(neg<0.0f){
			a*=-1;
		}
		return a;
	}
}