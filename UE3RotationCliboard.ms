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
Assembly.loadfrom("C:\Users\spitfire\Documents\UE3Handler\UE3Handler\bin\Release\UE3Handler.dll")


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
				
				--select (getNodeByName obj.Name)
				--$.rotation = (eulerangles obj.Rotation.z obj.Rotation.x obj.Rotation.y)
				--rotate $ (eulerangles obj.Rotation.z obj.Rotation.x obj.Rotation.y)
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