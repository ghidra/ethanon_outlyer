#include "actor.angelscript"

class explosion : actor
{

	explosion( const vector2 &in pos = vector2(0.0f,0.0f) ){
		super("explosion.ent",pos);
	}

	void update(){
		m_frametimer.update(0, 3, 150);
		const uint currentframe = m_frametimer.getCurrentFrame();
		m_entity.SetFrame(currentframe);
	}
}
