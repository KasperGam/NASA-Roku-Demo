sub init()
    m.top.functionName = "retrieve_data"
end sub

sub retrieve_data()
    ' retrieve the data, best comment ever
    request = CreateObject("roURLTransfer")
    request.setCertificatesFile("common:/certs/ca-bundle.crt")
    keywords = ["nebula", "Jupiter", "Sun", "Saturn"]
    categories = {}

    searchURL = "https://images-api.nasa.gov/search?q=[query]&media_type=[type]"

    try
        ' ContentNode for list on  Grid Screen
        content_node = CreateObject("roSGNode", "ContentNode")
        for each param in keywords
            hubbleSearchQuery = request.escape("hubble " + param)
            request.setURL(searchURL.replace("[query]", hubbleSearchQuery).replace("[type]", "image"))
            response = request.getToString()
            json = ParseJson(response)
            if json <> invalid
                childNode = content_node.createChild("ContentNode")
                childNode.setFields({
                    title: param
                    description: "Hubble images of " + param
                })

                items = json.collection.items
                if items <> invalid and items.count() > 0
                    'add data to content node

                    for each item in items
                        collectionChild = childNode.createChild("ContentNode")
                        collectionChild.title = item.data[0].title
                        collectionChild.description = item.data[0].description
                        collectionChild.addFields({
                            collectionURL: item.href
                            image: item.links[0].href
                        })
                    end for
                end if
            end if
        end for

        'set content equal to content node
        m.top.content = content_node
    catch e
        print "Error fetching data: " + e.message
        m.top.error = e.message
    end try
end sub
