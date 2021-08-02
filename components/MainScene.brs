sub init()
    screen_manager()

    ' Set scene background
    m.top.backgroundURI = "pkg:/images/bkg-fhd.jpeg"

    ' Get the main gallery
    m.galleryScreen = CreateObject("roSGNode", "GalleryScreen")

    ' Initial app state
    m.options = DefaultOptions()

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
    ' If we already have fetched data, make sure to tear down previous data task
    if m.data_task <> Invalid
        m.data_task.control = "stop"
        m.data_task.unobserveField("content")
        m.data_task.unobserveField("error")
    end if
    rem Create data retriever, set observer for data_loaded, execute task
    m.data_task = CreateObject("roSGNode", "NASADataTask")
    m.data_task.ObserveField("content", "data_loaded")
    m.data_task.ObserveField("error", "data_error")
    m.data_task.keywords = get_keywords(m.options.queries)
    m.data_task.control = "run"
end sub

sub data_loaded()
    m.data_task.unobserveField("content")
    m.data_task.unobserveField("error")

    m.loadingIcon.control = "stop"
    m.loadingIcon.visible = false

    content = m.data_task.content
    m.galleryScreen.content = content
    load_screen(m.galleryScreen)
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

function get_keywords(queries)
    keywords = []
    for each query in queries
        if query.enabled
            keywords.push(query.value)
        end if
    end for
    return keywords
end function

sub close_dilaog(msg as Object)
    msg.getRoSGNode().close = true
end sub

sub open_options()
    if m.optionsScreen = Invalid
        m.optionsScreen = createObject("roSGNode", "OptionsScreen")
        m.optionsScreen.visible = false
    end if

    if not m.optionsScreen.visible
        m.optionsScreen.callFunc("setInitialOptions", m.options)
        load_screen(m.optionsScreen)
    end if
end sub

sub update_options()
    m.options = m.optionsScreen.options
    m.loadingIcon.visible = true
    m.loadingIcon.control = "start"
    get_data()
end sub

function onKeyEvent(key as String, press as Boolean) as Boolean
    handled = false

    if press
        if key="options"
            open_options()
            handled = true
        else if key="back"
            root = getRootScreen()
            current = getCurrentScreen()
            if root <> Invalid and current <> Invalid and not root.isSameNode(current)
                close_screen(current)
                if m.optionsScreen <> Invalid and m.optionsScreen.isSameNode(current)
                    update_options()
                end if
                handled = true
            end if
        end if
    end if

    return handled
end function
