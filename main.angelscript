﻿#include "SceneManager.angelscript"
#include "MainMenuScene.angelscript"
#include "scene_level.angelscript"
//#include "TestScene.angelscript"

void main()
{
	g_sceneManager.setCurrentScene(MainMenuScene());
}
/*
------------
when an enemy from a enemy factory is killed, it needs to also remove itself from the enemy array
when an enemy dies, it also needs to remove it self from code period, it is still around, just the entity is removed


level 1
	layout of bodies
	creation of boss, and how he eats bodies, and how enemies are created

use minimap to allow a free camera. 
collect miner shows cost to travel
projectiles need to shoot toward pawn, it is shooting to where the pawn was before actually shooting

-maybe put the explosion in its own class to make it more versitile for other weapons

weapon type classes
	missles that cost resources, and cause more damage
	phasers that cost no resources, but cause little damage




------------
----game play notes----
------------


-calculates path of travel (go around obstacles, turning speed)
-long journeys should be more cost effective, initial movement should cost more, like starting from a stopped position
-weapon projectile needs to exlode after max range reached
-kill screen
-load screen

//---bugs


*/
