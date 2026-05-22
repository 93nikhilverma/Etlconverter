The script below will silently download the required Microsoft decoder straight to your temporary folder.
Use it to convert your .etl files so your packets are intact, and name them (converted.pcap, converted1.pcap, etc.). 
You just double-click and run it.


When you run the script, it checks your C:\Users\Name\AppData\Local\Temp folder for etl2pcapng.exe.

Native Downloading: If the file isn't there, the script uses Windows' built-in curl command to reach out to Microsoft's official GitHub and download it directly into the temporary folder.

Seamless Execution: Once the tool is cached in your Temp folder, the script runs the conversion loop. The next time you run the script, it skips the download phase completely and goes straight to converting.
