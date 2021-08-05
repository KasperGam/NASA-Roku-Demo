sub init()
    m.top.observeField("focusedChild", "updateFocus")
    m.keyboard = createObject("roSGNode", "StandardKeyboardDialog")
    m.keyboard.buttons = ["OK"]
    m.top.maxTextLength = 25
    m.top.clearOnDownKey = false
end sub

function updateFocus()
    if m.top.isInFocusChain()
        m.top.active = true
    else
        m.top.active = false
    end if
end function

function openKeyboard()
    m.keyboard.text = m.top.text
    m.keyboard.observeField("buttonSelected", "closeKeyboard")
    m.top.getScene().dialog = m.keyboard
end function

function closeKeyboard()
    m.top.text = m.keyboard.text
    m.keyboard.close = true
end function

function onKeyEvent(key as String, press as Boolean) as Boolean
    handled = false

    if press and key = "OK"
        openKeyboard()
        handled = true
    end if

    return handled
end function
