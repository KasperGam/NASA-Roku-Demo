sub init()
    m.row_list = m.top.FindNode("row_list")
    m.row_list.SetFocus(true)
    m.top.ObserveField("visible", "visibilty_changed")
    m.row_list.ObserveField("rowItemFocused", "item_focused")

    m.title = m.top.FindNode("title")
    m.description = m.top.FindNode("description")
end sub

sub visibilty_changed()
    if m.top.visible = true
        m.row_list.SetFocus(true)
    end if
end sub

sub item_focused()
    focusedIndex = m.row_list.rowItemFocused
    row = m.row_list.content.GetChild(focusedIndex[0])
    item = row.GetChild(focusedIndex[1])
    m.description.text = item.description
    m.title.text = item.title

end sub