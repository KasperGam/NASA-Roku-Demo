sub content_set() ' invoked when item metadata retrieved
    content = m.top.poster_content
    if content <> invalid
        m.top.FindNode("poster").uri = content.thumbnail
    end if
end sub