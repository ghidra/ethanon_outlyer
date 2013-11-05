#include "weapon.angelscript"

class inventory{

	private string m_label;

	private weapon@[] m_weapons;
	//private list@ m_armor;
	//private list@ m_vehicles;
	//private list@ m_items;

	inventory(const string label = "inventory"){
		m_label = label;
	}

	void add_weapon(weapon@ o){
		m_weapons.insertLast(o);
	}
	weapon@ get_weapon(const uint index){
		return m_weapons[index];
	}
}
