#include "Button.angelscript"

class button_menu : Button{

	private Button@[] m_buttons;
	private string[] m_labels;//hold the labels to the buttons

	private bool m_open = false;//wether this thing is open
	private float m_timer = 0.0f;//the timer to start counting if it is open, so we can close it afterward
	private float m_timer_duration = 4.0f;//how long to keep the menu open

	private float m_width = 0.0f;//this is the overall width, incase we want to keep it all consistent, which seems only right

	button_menu(const string _label, const vector2 &in _pos, const string[] _labels, const vector2 &in _origin = vector2(0.5f, 0.5f))
	{
		super(_label,_pos,_origin);//i have to do this, cause the base class does not have a constructor
		
		m_width = m_size.x;//get the width of the main button, to start off the size.

		set_buttons(_labels);

		//m_size = ComputeTextBoxSize(m_font, m_label) + m_margin;//GetSpriteFrameSize(m_spriteName);

		//m_pos = _pos;
		//m_lpos = _pos+(m_margin*0.5f);
	}

	void update()
	{
		Button::update();
		//ETHInput@ input = GetInputHandle();

		//m_pressed=false;
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
		for (uint t =0; t<m_buttons.length(); t++){
			m_buttons[t].update();
		}
		
	}

	void set_buttons( const string[] _labels){
		//remove the buttons first before making new buttons
		const uint tbuttons = m_buttons.length();
		for(uint t=0; t<tbuttons; t++){
			m_buttons.removeAt(tbuttons-(t+1));//remove them from the back end
		}

		//make new buttons
		//float widest = 0.0f;// figure out which is the largest button, so we can make them all the same width
		for (uint t =0; t<_labels.length(); t++){
			m_buttons.insertLast( Button( _labels[t], vector2()) );//make a button but done place it
			const vector2 size = m_buttons[t].get_size();
			if(size.x>m_width){
				m_width = size.x;
			}
		}
		//now set them all to the same size
		for (uint t =0; t<_labels.length(); t++){
			const vector2 size = m_buttons[t].get_size();
			if(size.x<m_width){
				m_buttons[t].set_size(vector2(m_width,size.y));
			}
		}
		set_size(vector2(m_width,m_size.y));//go ahead and set it for the header button too

		//set the labels array
		m_labels = _labels;
	}

	//setting the position, also nees to set the position of all the buttons under neith this
	void set_position(const vector2 pos){
		Button::set_position(pos);
		//now loop the buttons
		for (uint t =0; t<m_buttons.length(); t++){
			const vector2 size = m_buttons[t].get_size();
			m_buttons[t].set_position( m_pos+vector2(0.0f,(size.y+m_margin.y)*(t+1)) );
		}
	}
}

