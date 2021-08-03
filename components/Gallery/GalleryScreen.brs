sub init()
    m.row_list = m.top.FindNode("rowlist")
    m.row_list.SetFocus(true)
    m.top.ObserveField("visible", "visibilty_changed")
    m.row_list.ObserveField("rowItemSelected", "item_selected")
    m.row_list.ObserveField("rowItemFocused", "item_focused")

    m.title = m.top.FindNode("title")
    m.screen = m.top.GetScene()
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
    if item.title <> Invalid
        m.title.text = item.title
    else
        m.title.text = ""
    end if
end sub

sub item_selected()
    content = m.row_list.rowItemSelected

        selected_index = m.row_list.rowItemSelected
        ?selected_index
        row = m.row_list.content.GetChild(selected_index[0])
        item = row.GetChild(selected_index[1])
        ?item
        detail_node = CreateObject("roSGNode", "Details")
        detail_node.content = item
        m.screen.callfunc("Push", detail_node)
end sub
