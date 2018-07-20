Set objIE = CreateObject("InternetExplorer.Application")
objIE.Navigate("about:blank")
strTemp = objIE.document.parentwindow.clipboardData.GetData("text")
objIE.Quit
WScript.Echo strTemp

WScript.Echo(len(strTemp))
