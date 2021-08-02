sub load_grid()
    m.GridScreen = CreateObject("roSGNode", "GridScreen")
    m.GridScreen.ObserveField("rowItemSelected", "grid_item_chosen")
    load_screen(m.GridScreen) ' show GridScreen
end sub

sub grid_item_chosen(event as Object)
    grid = event.GetRoSGNode()
    ' extract the row and column indexes of the item the user selected
    m.selected = event.GetData()
    ' the entire row from the RowList will be used by the Video node
    content = grid.content.GetChild(m.selected[0])
    show_details(content, m.selected[1])
end sub