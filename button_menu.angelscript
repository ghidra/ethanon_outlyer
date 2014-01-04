#include "Button.angelscript"

class button_menu : Button{

	private Button@[] m_buttons;
	private string[] m_labels;//hold the labels to the buttons
	private string[] m_actions;//holds the actions to the buttons

	private bool m_open = false;//wether this thing is open
	private float m_timer = 0.0f;//the timer to start counting if it is open, so we can close it afterward
	private float m_timer_duration = 4.0f;//how long to keep the menu open

	button_menu(const string _label, const vector2 &in _pos, const string[] _labels, const string[] _actions, const vector2 &in _origin = vector2(0.5f, 0.5f))
	{
		super(_label,_pos,_origin);//i have to do this, cause the base class does not have a constructor
		
		set_buttons(_labels,_actions);

		//m_size = ComputeTextBoxSize(m_font, m_label) + m_margin;//GetSpriteFrameSize(m_spriteName);

		//m_pos = _pos;
		//m_lpos = _pos+(m_margin*0.5f);
	}

	void update()
	{
		Button::update();
		//ETHInput@ input = GetInputHandle();

		m_pressed=false;
		// check if any touch (or mouse) input is pressing the button
		/*const uint touchCount = m_input.GetMaxTouchCount();
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
		*/
		
	}

	void set_buttons( const string[] _labels, const string[] _actions ){
		m_labels = _labels;
		m_actions = _actions;
	}

}

