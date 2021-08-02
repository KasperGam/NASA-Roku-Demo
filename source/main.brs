REM launch/entry point
sub main()
    load_screen()
end sub

sub load_screen()
    ' load in intial screen node
    screen = CreateObject("roSGScreen")
    ' set the message port so we can get events during runtime & use it
    m.msg_port = CreateObject("roMessagePort")
    screen.SetMessagePort(m.msg_port)
    ' create & call the scence
    scene = screen.CreateScene("MainScene")
    screen.Show()

    while(true)
        ' wait indef until event received from the screen
        msg = wait(0, m.port)
        msgType = type(msg)
        if msgType = "roSGScreenEvent"
            if msg.IsScreenClosed() then return
        end if
    end while
end sub
