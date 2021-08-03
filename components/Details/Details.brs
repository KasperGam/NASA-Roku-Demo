function init()
    ' check if we can see the Details screen
    m.top.ObserveField("visible", "visibility_changed")
    ' check what is in focus
    m.top.ObserveField("itemFocused", "item_focus")
    ' set references to child fields
    m.description = m.top.FindNode("descriptiveText")
    m.title = m.top.FindNode("title")
    'save default bkg
    m.defaul_bkg = m.top.backgroundUri


end function

sub visibility_changed()
    ' set focus to scrollable text when Details are displayed
    if m.top.visible = true
        m.description.SetFocus(true)
        m.top.focused = m.top.chosen
    end if
end sub

sub item_focus(event as Object)
    focused_item = event.GetData() ' get focused item
    content = m.top.content.GetChild(focused_item) ' get item metadata
    add_content(content) ' populate Details with metadata
end sub

' Populate content details information
sub add_content(content as Object)
    'set title, description, and bkg
    m.description.text = content.description
    m.title.text = content.title
    'get orig image and set background
    ' bkg = get_details_bkg(content.collectionURL)
    ' m.top.backgroundUri = bkg
end sub

sub item_selected()
    content = m.top.content
    if content <> invalid and m.top.chosen >= 0 and content.GetChildCount() > m.top.chosen
        m.top.focused = m.top.chosen
    end if
end sub

function get_details_bkg(url as String) as String
    'make a sub?

end function
