----------------------------------------------------------------------------------------------
-- UE3 to 3ds Max Rotation cliboard script
-- A script reading objects' rotation from UE3 clipboard and applying it to objects in 3ds Max
-- https://github.com/spitfire05/ue3-2-max-rotation-clipboard
----------------------------------------------------------------------------------------------

--    This program is free software; you can redistribute it and/or modify
--    it under the terms of the GNU General Public License as published by
--    the Free Software Foundation; either version 2 of the License, or
--    (at your option) any later version.
--
--    This program is distributed in the hope that it will be useful,
--    but WITHOUT ANY WARRANTY; without even the implied warranty of
--    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--    GNU General Public License for more details.
--
--    You should have received a copy of the GNU General Public License
--    along with this program; if not, write to the Free Software
--    Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA

------------------------------------------------------
-- Set the given object's rotation to the given values
-- Source: http://lifeonthefrontier.blogspot.com/2009/04/it-is-very-surprising-to-me-how-hard-it.html
------------------------------------------------------
fn SetObjectRotation obj rx ry rz =
(
    -- Reset the object's transformation matrix so that 
    -- it only includes position and scale information. 
    -- Doing this clears out any previous object rotation.
    local translateMat = transMatrix obj.transform.pos
    local scaleMat = scaleMatrix obj.transform.scale
    obj.transform = scaleMat * translateMat
   
    -- Perform each axis rotation individually
    rotate obj (angleaxis rx [1,0,0])
    rotate obj (angleaxis ry [0,1,0])
    rotate obj (angleaxis rz [0,0,1])
)

clearlistener()

Assembly = dotNetClass "System.Reflection.Assembly"
-- DLL path is not script dependant, until I find a solution to do so
Assembly.loadfrom("Scripts\Startup\UE3Handler.dll")

rollout rAbout "About"
(
 label lab1 "BF2 ColMesh Importer"
 label lab2 "Version 1.2.0"
 label lab3 "Copyright © Martijn Buijs, 2008"
)

macroscript UE3ClipBoardRotation category:"spitfire" \
tooltip:"Get rotation from cliboard" \
buttontext: "Get rotation from cliboard"
(
	on execute do
	(
		try
		(
			parser = dotNetClass "UE3Handler.ParserStub"
			result = parser.parseFromClipboard()
			r = result.ToArray()
			for obj in (r) do
			(
				format "% -- % % %\n" obj.Name obj.Rotation.x obj.Rotation.y obj.Rotation.z
				
				maxObj = (getNodeByName obj.Name)
				if maxObj != undefined then
				(
					SetObjectRotation (getNodeByName obj.Name) obj.Rotation.z obj.Rotation.x obj.Rotation.y
				)--end if
				else
				(
					messagebox ("No object found: " + obj.Name)
				)--end else
			)--end for
		) catch (
			messagebox (getCurrentException())
		)
	)--end on execute
)--end macroscript

macroscript UE3ClipBoardRotationAbout category:"spitfire" \
tooltip:"About" \
buttontext: "About"
(
	on execute do
	(
		parser = dotNetClass "UE3Handler.ParserStub"
		messagebox ("UE3 Rotation Clipboard\n\nhttp://traal.eu\n\nAuthor: michal@traal.eu\nScript version: 0.1\nParser version: " + (parser.getVersion()))
	)--end on execute
)--end macroscript

-- add UI
subMenuName = "UE3 Rotation Clipboard"

-- clean up old menu
if ((menuMan.findMenu subMenuName) != undefined) then 
(
	menuMan.unRegisterMenu (menuMan.findMenu subMenuName)
	menuMan.updateMenuBar()
)

mainMenuBar = menuMan.getMainMenuBar()
subMenu = menuMan.createMenu subMenuName

testItem = menuMan.createActionItem "UE3ClipBoardRotation" "spitfire"
subMenu.addItem testItem -1
testItem = menuMan.createActionItem "UE3ClipBoardRotationAbout" "spitfire"
subMenu.addItem testItem -1

subMenuItem = menuMan.createSubMenuItem "Test Menu" subMenu
subMenuIndex = mainMenuBar.numItems() - 1
mainMenuBar.addItem subMenuItem subMenuIndex
menuMan.updateMenuBar()