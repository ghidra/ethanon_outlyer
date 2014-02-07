class global
{
	private float m_time_multiplier = 1.0f;

	global(){}

	float time_multiplier(){
		return m_time_multiplier;
	}
	void set_time_multiplier(const float &in t){
		m_time_multiplier = t;
	}
	
}
