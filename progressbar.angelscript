#include "obj.angelscript"

class progressbar : obj
{
	private vector2 m_dir;//this is the direction of the bar (if we want it on an angle to be cool)
	private vector2 m_pos2;//the second position that we determine at the creation time
	private vector2 m_dir2;//for building a border if we need it
	private vector2 m_pos3;
	private vector2 m_pos4;

	private vector2 m_offset; //this is to hold the value that we need to offset this by, using size and origin, then adding it to pos to give it the new pos
	private vector2 m_margin = vector2(4.0f,4.0f);
	private vector2 m_lpos; //the label position taking the margin into account
	//private vector2 m_lsize;

	private vector2 m_bounds; //the lower and upper bounds of the bar
	private float m_value;
	private uint m_decimal=1;//the decimal i want to show to

	private uint m_border;
	private uint m_showvalue;
	private uint m_showlabel;

	progressbar(
		const string _label, 
		const float _value, 
		const float _min, 
		const float _max, 
		const vector2 &in _pos, 
		const vector2 &in _origin = vector2(0.0f, 0.0f), 
		const vector2 &in _size = vector2(50.0f,2.0f), 
		const vector2 &in _dir = vector2(1.0f,0.0f), 
		const uint &in _border=0,
		const uint &in _showvalue=1,
		const uint &in _showlabel=1,
		const int &in _dec=1
		)
	{
		//label,value,min,max,pos,origin,size
		m_origin = _origin;
		m_label = _label;

		m_size = _size;//ComputeTextBoxSize(m_font, m_label) + m_margin;//GetSpriteFrameSize(m_spriteName);
		m_offset = m_size*m_origin;
		//m_lsize = ComputeTextBoxSize(m_font, m_label) + m_margin;//get the size of the label

		m_pos = _pos;
		m_dir = normalize(_dir);
		/*m_pos2 = m_pos+(m_dir*m_size.x);//this is max the end postion
		m_dir2 = multiply(m_dir,rotateZ(-90*(PI/180)));
		m_pos3 = m_pos2+(m_dir2*m_size.y);
		m_pos4 = m_pos+(m_dir2*m_size.y);*/
		set_border_positions();

		m_lpos = _pos;//_pos+(m_margin*0.5f);

		set_bounds(_min,_max);
		m_value = _value;

		m_border = _border;
		m_showvalue = _showvalue;
		m_showlabel = _showlabel;


		m_decimal = _dec;
	}

	void update()
	{
		const float bar_width = m_size.x * ( rescale(m_value,0.0f,m_bounds.y,0.0f,1.0f));//get the width of the bar
		const vector2 p2 = m_pos+(m_dir*bar_width);//this is where the bar should end up
		//draw the bar part
		//draw_line( m_pos, vector2(m_pos.x+bar_width, m_pos.y),m_white,m_white,m_size.y);
		draw_line( m_pos, p2,m_white,m_white,m_size.y);
		//draw the border
		if(m_border>0){
			draw_line( m_pos, m_pos2,m_white,m_white,1.0f);//top line
			draw_line( m_pos2, m_pos3,m_white,m_white,1.0f);//right line
			draw_line( m_pos4, m_pos3,m_white,m_white,1.0f);//bottom line
			draw_line( m_pos, m_pos4,m_white,m_white,1.0f);//left line
		}
		//const vector2 pos2 = m_pos+vector2(m_size.x,0.0f);
		//draw_line(pos2, pos2+vector2(1.0f,0.0f),m_red,m_red,m_size.y);
		//then draw the label
		if(m_showlabel>0){
			DrawText( m_pos , m_label, m_font, m_white);
		}
		if(m_showvalue>0){
			DrawText( m_pos+vector2(0.0f,12.0f), decimal(m_value,m_decimal)+"/"+decimal(m_bounds.y,m_decimal), m_font, m_white);
		}
	}
	void set_value(float v){
		m_value = min(max(v,0),m_bounds.y);
	}
	float get_value(){
		return m_value;
	}
	float clamp(float v) {
  		return min(max(v, 1.0f), m_size.x);
	}
	void set_bounds(const float _min, const float _max){
		m_bounds = vector2(_min,_max);
	}
	float rescale(const float v, const float l1, const float h1, const float l2, const float h2){
		return l2 + (v - l1) * (h2 - l2) / (h1 - l1);
	}
	void refresh(const float _value, const float _max, const float _min = 0.0f){
		set_bounds(_min,_max);
	 	m_value = _value;
	}
	//------look
	void set_border_positions(){
		m_pos2 = m_pos+(m_dir*m_size.x);//this is max the end postion
		m_dir2 = multiply(m_dir,rotateZ(-90*(PI/180)));
		m_pos3 = m_pos2+(m_dir2*m_size.y);
		m_pos4 = m_pos+(m_dir2*m_size.y);
	}
	void set_position(const vector2 pos){
		obj::set_position(pos);

		set_border_positions();
	}
}

//------------------
//------------------
