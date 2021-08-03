sub init()
    m.top.functionName = "getCollectionImage"
end sub

function getCollectionImage()
    url = m.top.collectionURL

    ' Create message port to listen for events
    port = CreateObject("roMessagePort")
    if url <> ""
        ' Create request
        request = createObject("roURLTransfer")
        request.setCertificatesFile("common:/certs/ca-bundle.crt")
        request.setMessagePort(port)
        request.setURL(url)

        ' Async example- listen for response on message port
        request.asyncGetToString()
        while true
            ' Waits until a message is posted on the message port
            msg = wait(0, port)
            ' Test if this message is from the correct request
            if msg <> Invalid and type(msg) = "roUrlEvent" and msg.GetSourceIdentity() = request.GetIdentity()
                ' Get the HTTP response code and body
                code = msg.getResponseCode()
                response = msg.getString()
                ' If valid response
                if response <> Invalid and code >= 200 and code < 300
                    ' Try to decode the body
                    try
                    jsonImages = parseJSON(response)
                    m.top.imageURL = jsonImages[0]
                    catch e
                        ' Error decoding
                        m.top.error = "Error: " + e.message
                    end try
                else
                    ' Error in http response
                    m.top.error = "Error fetching image, invalid response"
                end if
                exit while
            end if
        end while
    else
        ' No valid url set
        m.top.error = "invalid url"
    end if
end function
