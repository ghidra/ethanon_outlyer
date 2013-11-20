#include "actor.angelscript"

class projectile : actor
{
	private float m_maxrange = 10.0f;//this is so that it dies at some point regarless of landing
	private bool m_exploding = false;//flag for weather this is has hit, or reached its max distance or sexploding or not
	private bool m_hit = false; //weather this hit a target set from the weapon

	private bool m_explosion_done = false;
	private uint m_explosion_frames = 15;

	private ETHEntity@ m_explosion;//this will hold the explosion graphic

	projectile(const string &in entityName, const vector2 &in pos, const vector2 &in destination){
		super(entityName,pos);
		m_spd = 1.0f;
		set_scale(0.25f);
		set_destination(destination);
	}

	void update(){
		actor::update();
		DrawText( m_pos , m_destination.x+":"+m_destination.y, m_font, m_red);

		if(!m_hit){//if we havent hit anything yet
			move(m_destination_direction);//move
		}else{//if we have hit something
			if(!m_exploding){//then we need to check if we have initialized the exploding
				//remove projectile graphic, set explode graphic
				delete_entity();
				init_entity("explosion_01.ent",m_pos);
				m_entity.Scale(2);
				m_exploding = true;
			}else{//we did start the explosion, update the frames, until we reach the end, then remove it, and allow weapon class to remove us from its array
				m_frametimer.update(0, m_explosion_frames, 18);
				const uint frame = m_frametimer.getCurrentFrame(); 
				m_entity.SetFrame(frame);
				if(frame>=m_explosion_frames){
					m_explosion_done = true;
				}
			}
		}
	}
	//------
	void set_hit(){//this is one way, if it hit something it hit something
		m_hit = true;
	}
	bool get_hit(){
		return m_hit;
	}
	bool get_explosion_done(){
		return m_explosion_done;
	}
	//bool get_exploding(){
	//	return m_exploding;
	//}
}
