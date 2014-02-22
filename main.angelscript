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
when an enemy from a enemy factory is killed, it needs to also remove itself from the enemy array
when an enemy dies, it also needs to remove it self from code period, it is still around, just the entity is removed


level 1
	layout of bodies
	creation of boss, and how he eats bodies, and how enemies are created

use minimap to allow a free camera. 

resource cost to travel
bodies need to tell you how much resources it will cost to travel there and drop a miner

starting on enemy pawn. basic ai

projectiles need to shoot toward pawn, basically it is shooting to where the pawn was before actually shooting, the position is not updating at time of fire

-maybe put the explosion in its own class to make it more versitile for other weapons

weapon type classes
	missles that cost resources, and cause more damage
	phasers that cost no resources, but cause little damage

//----to do more
-weapon projectile needs to exlode after max range reached
-path finding
-kill screen
-load screen

//---bug
there is a bug that after setting the characters destination, and you scale the scene (right click drag), you might miss the mark on go on forever






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
