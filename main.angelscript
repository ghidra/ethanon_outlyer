#include "SceneManager.angelscript"
#include "MainMenuScene.angelscript"
#include "GameScene.angelscript"
//#include "TestScene.angelscript"

void main()
{
	g_sceneManager.setCurrentScene(MainMenuScene());
}
/*
------------
notes
------------
-progress
------------
starting on enemy pawn. basic ai

-i need to relook at my m_action method of causing charcter to react. I cant have 2 actions at once
	-and i need to reset it when an action is finished.. just needs to be looked at.
	-some sort of object to handle actinos would be good potentially

-weapon projectile needs remove hit pints
-weapon projectile needs to exlode after max range reached
-maybe put the explosion in its own class to make it more versitile for other weapons
-i have weapons now, need to look at using different ones

look into a smaller font potentially.
then build base on planet

weapon type classes
	missles that cost resources, and cause more damage
	phasers that cost no resources, but cause little damage

------------
----game play notes----
------------

-travel to planets should cost resources.
-on hover over of planet, it should give the distance to reach and the cost in resources
-should be able to click on character and drag out a ghost to where you want to move to.
	-calculates the path (go around obstacles), and cost in resources. This allows for evasion
	-potentially, like a cab, just moving cost money. So short movements will cost you more in the long run
		-and long journeys may be more cost effective
*/
