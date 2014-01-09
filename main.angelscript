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

use minimap to allow a free camera. add temporary plottable objects, that dont effect the overall map scale.

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
