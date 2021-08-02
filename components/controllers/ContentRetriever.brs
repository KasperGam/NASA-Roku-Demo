sub get_data()
    rem Create data retriever, set observer for data_loaded, execute task
    m.data_retriever = CreateObject("roSGNode", "DataRetriever")
    m.data_retriever.ObserveField("content", "data_loaded")
    m.data_retriever.control = "run"
    m.loadingText.visible = true
end sub

sub data_loaded()
    m.LoadingText.visible = false ' done loading hide loading text
    m.GridScreen.SetFocus(true) ' set the focus to grid screen
    m.GridScreen.content = m.data_retriever.content 'set grid content to data
end sub