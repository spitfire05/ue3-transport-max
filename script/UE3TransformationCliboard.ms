----------------------------------------------------------------------------------------------
-- UE3 to 3ds Max Rotation cliboard script
-- A script reading objects' rotation from UE3 clipboard and applying it to objects in 3ds Max
-- https://github.com/spitfire05/ue3-2-max-transformation-clipboard
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

clearlistener()

Assembly = dotNetClass "System.Reflection.Assembly"
-- DLL path is not script dependant, until I find a solution to do so
Assembly.loadfrom("Scripts\Startup\UE3Handler.dll")
parser = dotNetClass "UE3Handler.ParserStub"
format "Parser version: %\n" (parser.getVersion())

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

fn ApplyUE pos rot relPos =
(
	try
	(
		result = parser.parseFromClipboard()
		if (pos and relPos) then
		(
			result = parser.convertVectorsToRelativeFromGeometricalCenter(result)
		)--end if
		r = result.ToArray()
		for obj in (r) do
		(
			print obj.Name
			print (obj.Location.ToString())
			print (obj.Rotation.ToString())
			
			maxObj = (getNodeByName obj.Name)
			if maxObj != undefined then
			(
				if pos then
				(
					maxObj.position = [obj.Location.x, obj.Location.y, obj.Location.z]
				)--end if
				if rot then
				(
					SetObjectRotation maxObj obj.Rotation.z obj.Rotation.x obj.Rotation.y
				)--end if
			)--end if
			else
			(
				messagebox ("No object found: " + obj.Name)
			)--end else
		)--end for
	) catch (
		messagebox (getCurrentException())
	)
)--end function

-- main macroscript
macroscript UE3ClipBoardRotation category:"spitfire" \
tooltip:"Open dialog..." \
buttontext: "Open dialog..."
(
	global cmImp
	on execute do
	(
		try (removeRollout rUE) catch ()
		try (removeRollout rAbout) catch ()
		try (closeRolloutFloter cmImp) catch ()
		cmImp = newRolloutFloater "UE3 Transformation Clipboard" 240 180
		print cmImp
		print rUE
		print rAbout
		addRollout rUE cmImp
		addRollout rAbout cmImp rolledup:true
	)--end on execute
)--end macroscript

-- GUI
rollout rUE "UE3 Transformation Clipboard"
(
	group "Import"
	(
		checkbox posCbox "Import position" checked: true
		checkbox rotCbox "Import rotation" checked: true
		checkbox relPosCbox "Make positions relative to geom. center" checked: true		
		button cmdImport "Apply UE3 transformation" width: 140
	)
	on cmdImport pressed do
	(
		ApplyUE posCbox.state rotCbox.state relPosCbox.state
	)
)

rollout rAbout "About"
(
	label lab1 "UE3 Transformation Clipboard Importer"
	label lab2 "Author: michal@traal.eu"
	label lab3 "http://traal.eu"
	label lab4 "Script version: 0.2.0"
	-- needs parser Version!
)

subMenuName = "UE3 Transformation Clipboard"

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

subMenuItem = menuMan.createSubMenuItem "Test Menu" subMenu
subMenuIndex = mainMenuBar.numItems() - 1
mainMenuBar.addItem subMenuItem subMenuIndex
menuMan.updateMenuBar()