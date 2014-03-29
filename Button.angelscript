#include "obj.angelscript"

class Button : obj
{

	private vector2 m_offset; //this is to hold the value that we need to offset this by, using size and origin, then adding it to pos to give it the new pos
	private vector2 m_margin = vector2(4.0f,4.0f);
	private vector2 m_lpos; //the label position taking the margin into account

	Button(const string _label, const vector2 &in _pos, const vector2 &in _origin = vector2(0.5f, 0.5f)){
		m_origin = _origin;
		m_label = _label;

		set_size(ComputeTextBoxSize(m_font, m_label) + m_margin);
		//m_size = ComputeTextBoxSize(m_font, m_label) + m_margin;//GetSpriteFrameSize(m_spriteName);
		//m_offset = m_size*m_origin;

		set_position(_pos);
		//m_pos = _pos;
		//m_lpos = _pos+(m_margin*0.5f);
	}

	void update()
	{
		obj::update();
		//ETHInput@ input = GetInputHandle();

		m_pressed=false;
		// check if any touch (or mouse) input is pressing the button
		const uint touchCount = m_input.GetMaxTouchCount();
		for (uint t = 0; t < touchCount; t++)
		{
			if (m_input.GetTouchState(t) == KS_HIT)
			{
				//if (isPointInButton(input.GetTouchPos(t)))
				if (is_point_in_bb(m_input.GetTouchPos(t)))
				{
					m_pressed = true;
				}
			}
		}

		///---draw
		if( this.is_point_in_bb(m_input.GetCursorPos()) ){
			DrawShapedSprite("sprites/pixel_white.png", m_pos-m_offset, m_size, m_white);
		}else{
			DrawShapedSprite("sprites/pixel_white.png", m_pos-m_offset, m_size, m_grey);
		}
		DrawText( m_lpos-m_offset , m_label, m_font, m_white);
		
	}

	//when setting the size, we also need to set the origin
	void set_size(const vector2 s){
		m_size = s;
		m_offset = m_size*m_origin;//justified the button
	}
	//when setting the position, we need to set the lable position too
	void set_position(const vector2 pos){
		m_pos = pos;
		m_lpos = pos+(m_margin*0.5f);
	}

	vector2 get_margin(){
		return m_margin;
	}

}

