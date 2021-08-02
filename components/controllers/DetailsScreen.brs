sub show_details(content as Object)
    ' create new instance of details screen
    details_screen = CreateObject("roSGNode", "DetailsScreen")
    details_screen.content = content
    details_screen.ObserveField("visible", "details_visibility_changed")
    details_screen.ObserveField("buttonSelected", "button_selected")
    load_screen(details_screen)
end sub

sub button_selected(event) ' invoked when button in DetailsScreen is pressed
    details = event.GetRoSGNode()
    content = details.content
    button_index = event.getData() ' index of selected button
    selected = details.itemFocused
    if button_index = 0 ' check if "Play" button is pressed
        ' create Video node and start playback
        load_slide_show(content, selected)
    end if
end sub

sub details_visibility_changed(event as Object) ' invoked when DetailsScreen "visible" field is changed
    visible = event.GetData()
    details_screen = event.GetRoSGNode()
    ' update GridScreen's focus when navigate back from DetailsScreen
    if visible = false
        m.GridScreen.jumpToRowItem = [m.selectedIndex[0], details_screen.itemFocused]
    end if
end sub
