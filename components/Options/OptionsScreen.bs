sub init()
    m.top.observeField("visible", "update")
    m.top.observeField("focusedChild", "update")

    m.checklist = m.top.findNode("checklist")
    m.checklist.observeField("checkedState", "updateOptions")

    m.input = m.top.findNode("input")
    m.addButton = m.top.findNode("addButton")
    m.addButton.observeField("buttonSelected", "addQuery")
end sub

sub update()
    if m.top.visible and m.top.hasFocus()
        m.checklist.setFocus(true)
    end if
end sub

function setInitialOptions(options)
    m.top.options = options
    createChecklistContent()
end function

function updateOptions()
    newQueries = []
    checkedState = m.checklist.checkedState
    for index = 0 to checkedState.count() - 1
        newQueries.push({
            value: m.checklist.content.getChild(index).title
            enabled: checkedState[index]
        })
    end for

    m.top.options = {
        queries: newQueries
    }
end function

function addQuery() as void
    newQuery = m.input.text
    if newQuery <> ""
        newQueries = []
        for each query in m.top.options.queries
            ' Prevent duplicate queries
            if query.value = newQuery
                return
            end if
            newQueries.push(query)
        end for

        ' Add new query
        newQueries.push({
            value: newQuery
            enabled: true
        })

        m.top.options = {
            queries: newQueries
        }
    end if

    m.input.text = ""

    createChecklistContent()
end function

function createChecklistContent()
    content = createObject("roSGNode", "ContentNode")
    queries = m.top.options.queries
    checkedState = []
    for each query in queries
        child = content.createChild("ContentNode")
        child.title = query.value
        checkedState.push(query.enabled)
    end for

    m.checklist.content = content
    m.checklist.checkedState = checkedState
end function

function onKeyEvent(key as String, press as Boolean) as Boolean
    handled = false

    if press
        if key = "left"
            if m.input.isInFocusChain() or m.addButton.hasFocus()
                m.checklist.setFocus(true)
                handled = true
            end if
        else if key = "right"
            if m.checklist.isInFocusChain()
                m.input.setFocus(true)
                handled = true
            end if
        else if key = "down"
            if m.input.isInFocusChain()
                m.addButton.setFocus(true)
                handled = true
            end if
        else if key = "up"
            if m.addButton.hasFocus()
                m.input.setFocus(true)
                handled = true
            end if
        end if
    end if

    return handled
end function
