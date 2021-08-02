sub init()
    m.top.backgroundUri= "pkg:/images/bkg-fhd.jpg"
    ' set the loading indicator so we can use it later
    m.loadingIndicator = m.top.FindNode("loadingText")
    screen_manager()
    load_grid()
    get_data()
end sub