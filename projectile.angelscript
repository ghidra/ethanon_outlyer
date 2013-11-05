#include "actor.angelscript"

class projectile : actor
{
	private float m_maxrange = 10.0f;//this is so that it dies at some point regarless of landing

	projectile(const string &in entityName, const vector2 &in pos, const vector2 &in destination){
		super(entityName,pos);
		m_spd = 1.0f;
		set_scale(0.25f);
		set_destination(destination);
	}

	void update(){
		actor::update();
		DrawText( m_pos , m_destination.x+":"+m_destination.y, m_font, m_red);
		move(m_destination_direction);
	}
}
