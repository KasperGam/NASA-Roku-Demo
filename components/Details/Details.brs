function init()
    ' check if we can see the Details screen
    m.top.ObserveField("visible", "visibility_changed")
    ' check what is in focus
    m.top.observeField("focusedChild", "item_focus")
    m.top.ObserveField("content", "add_content")
    ' set references to child fields
    m.description = m.top.FindNode("descriptiveText")
    m.title = m.top.FindNode("title")
    'save default bkg
    m.screen = m.top.GetScene()
    m.default_bkg = m.screen.backgroundUri

    'add_content()

end function

sub visibility_changed()
    ' set focus to scrollable text when Details are displayed
    if m.top.visible = false
        'm.screen.backgroundUri = m.defalut_bkd
        m.screen.callfunc("set_default_bkg")
    end if
end sub

sub item_focus(event as Object)
    if m.top.visible and m.top.hasFocus()
        m.description.setFocus(true)
    end if
end sub

sub add_content()
    ' Populate content details information
    ' Get orig image and set background
    'screen = GetCurrentScreen()
    ' set title, description, and bkg
    m.description.text = m.top.content.description
    m.title.text = m.top.content.title
    'm.screen.backgroundUri = "pkg:/images/splash.jpeg"
    ?"set new image"
    m.screen.callfunc("set_image_bkg")
end sub

function get_details_bkg(url as String) as String
    'make a sub?

end function
