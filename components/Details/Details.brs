function init()
    ' check if we can see the Details screen
    m.top.ObserveField("visible", "item_focus")
    ' check what is in focus
    m.top.observeField("focusedChild", "item_focus")
    m.top.ObserveField("content", "add_content")
    ' set references to child fields
    m.description = m.top.FindNode("descriptiveText")
    m.title = m.top.FindNode("title")
    m.poster = m.top.FindNode("bkg_poster")

end function

sub item_focus(event as Object)
    if m.top.visible and m.top.hasFocus()
        m.description.setFocus(true)
    end if
end sub

sub add_content()
    ' Populate content details information
    ' set title, description, and bkg
    m.description.text = m.top.content.description
    m.title.text = m.top.content.title
    ' ?"set new image as background"
    get_details_bkg(m.top.content.collectionurl)
end sub

sub get_details_bkg(url as String)
    if m.image_task <> Invalid
        m.image_task.control = "stop"
        m.image_task.unobserveField("imageURL")
        m.image_task.unobserveField("error")
    end if

    m.image_task = CreateObject("roSGNode", "ImageCollectionDataTask")
    m.image_task.collectionURL = url
    m.image_task.ObserveField("imageURL", "image_loaded")
    m.image_task.ObserveField("error", "image_error")
    m.image_task.control = "run"
end sub

sub image_loaded()
    m.image_task.unobserveField("imageURL")
    m.image_task.unobserveField("error")
    m.poster.uri = m.image_task.imageURL
end sub

sub image_error()
    m.image_task.unobserveField("content")
    m.image_task.unobserveField("error")

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