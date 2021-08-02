sub init()
    screen_manager()

    m.top.backgroundURI = "pkg:/images/bkg-fhd.jpeg"
    ' set the loading indicator so we can use it later
    m.loadingIcon = m.top.findNode("loadingIcon")
    configure_loading()
    m.loadingIcon.control = "start"
    get_data()
end sub

function configure_loading()
    m.loadingIcon.poster.loadSync = true
    m.loadingIcon.poster.uri = "pkg:/images/loading.png"
    ' set explicit width/height for resizing
    m.loadingIcon.poster.width = 50
    m.loadingIcon.poster.height = 50
    ' Center on screen
    m.loadingIcon.translation = [(1920 - 50) / 2, (1080 - 50) / 2]
end function

sub get_data()
    rem Create data retriever, set observer for data_loaded, execute task
    m.data_task = CreateObject("roSGNode", "NASADataTask")
    m.data_task.ObserveField("content", "data_loaded")
    m.data_task.ObserveField("error", "data_error")
    m.data_task.control = "run"
end sub

sub data_loaded()
    m.data_task.unobserveField("content")
    m.data_task.unobserveField("error")

    m.loadingIcon.control = "stop"
    m.loadingIcon.visible = false

    ' TODO: Show list with items on home
    content = m.data_task.content
    ' rowlist = createObject("roSGNode", "RowList")
    ' rowlist.content = content
end sub

sub data_error()
    m.data_task.unobserveField("content")
    m.data_task.unobserveField("error")

    print "ERROR- cannot load NASA data!"

    m.loadingIcon.control = "stop"
    m.loadingIcon.visible = false

    m.errorDialog = createObject("roSGNode", "Dialog")
    m.errorDialog.title = "Error"
    m.errorDialog.message = "There was an error fetching images from NASA. Please exit and try again."
    m.errorDialog.buttons = ["OK"]
    m.errorDialog.observeField("buttonSelected", "close_dilaog")

    m.top.dialog = m.errorDialog
end sub

sub close_dilaog(msg as Object)
    msg.getRoSGNode().close = true
end sub
