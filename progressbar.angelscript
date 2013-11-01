#include "obj.angelscript"

class progressbar : obj
{
	private vector2 m_offset; //this is to hold the value that we need to offset this by, using size and origin, then adding it to pos to give it the new pos
	private vector2 m_margin = vector2(4.0f,4.0f);
	private vector2 m_lpos; //the label position taking the margin into account
	private vector2 m_lsize;

	private vector2 m_bounds; //the lower and upper bounds of the bar
	private float m_value;
	private int m_decimal=1;//the decimal i want to show to

	progressbar(const string _label, const float _value, const float _min, const float _max, const vector2 &in _pos, const vector2 &in _origin = vector2(0.0f, 0.0f), const vector2 &in _size = vector2(50.0f,2.0f),const int &in _dec=1)
	{
		//label,value,min,max,pos,origin,size
		m_origin = _origin;
		m_label = _label;

		m_size = _size;//ComputeTextBoxSize(m_font, m_label) + m_margin;//GetSpriteFrameSize(m_spriteName);
		m_offset = m_size*m_origin;
		//m_lsize = ComputeTextBoxSize(m_font, m_label) + m_margin;//get the size of the label

		m_pos = _pos;
		m_lpos = _pos;//_pos+(m_margin*0.5f);

		set_bounds(_min,_max);
		m_value = _value;

		m_decimal = _dec;
	}

	void update()
	{
		const float bar_width = m_size.x * ( rescale(m_value,0.0f,m_bounds.y,0.0f,1.0f));
		//draw the bar part
		DrawShapedSprite("sprites/pixel_white.png", m_pos, vector2(bar_width, m_size.y), m_white);
		//draw the ending marker
		DrawShapedSprite("sprites/pixel_white.png", m_pos+vector2(m_size.x,0.0f), vector2(1.0f,m_size.y), m_red);
		//then draw the label 
		DrawText( m_pos , m_label, m_font, m_white);
		DrawText( m_pos+vector2(0.0f,12.0f), decimal(m_value)+"/"+decimal(m_bounds.y), m_font, m_white);
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
	float decimal(const float v){
		return floor(v*m_decimal)/m_decimal;
	}
}

//------------------
//------------------
