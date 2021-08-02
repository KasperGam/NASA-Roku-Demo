sub init()
    m.top.functionName = "RetrieveData"
end sub

sub retrieve_data()
    ' retrieve the data, best comment ever
    data_url = CreateObject("roURLTransfer")
    keywords = ["nebula", "Jupiter", "Sun", "Saturn"]
    categories = {}

    ' ContentNode for list on  Grid Screen
    content_node = CreateObject("roSGNode", "ContentNode")
    for each param in keywords
        data_url.SetURL(
            "https://images-api.nasa.gov/search?q=hubble%20" + param +  "media_type=image"
        )
        respone = data_url.GetToString()
        json = ParseJson(response)
        if json <> invalid
            items = json.collection.items
            if items <> invalid and len(items) > 0
                categories.param = []
                data = {
                    images: [],
                    title: param,
                    thumbnail: items[0].links[0].href
                    details: "Hubble images of " + param
                }
                for each item in items
                    data_url.SetUrl(item.href)
                    respone = data_url.GetToString()
                    images = ParseJson(response)
                    if images <> invalid
                        ' add the orig image to the array
                        data.images.Push(images[0])
                    endif
                end for
                categories.param.Push(data)
            end if
        end if

        'add data to content node
        content_node.Update({children: categories.param}, true)

    end for

    'set content equal to content node
    m.top.content = content_node
end sub
