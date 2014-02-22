#include "minimap.angelscript"

class global
{
	private float m_time_multiplier = 1.0f;
	private minimap@ m_minimap;//this is the main minimap

	global(){}

	//--------time (for time manipulation and pausing) 
	float time_multiplier(){
		return m_time_multiplier;
	}
	void set_time_multiplier(const float &in t){
		m_time_multiplier = t;
	}
	//---------minimap
	void set_minimap(minimap @m){
		@m_minimap = m;
	}
	bool has_minimap(){
		bool v = false;
		if(m_minimap !is null){
			v = true;
		}
		return v;
	}
	void plottable(pawn @p){//here we give this object a pawn to plot on the miniman
		m_minimap.plottable(p);
	}
	//----------------
	
}
