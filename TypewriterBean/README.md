# BeanDemo for OSX

This is a little demo for using the LightBlue Bean SDK to control the LightBlue Bean.

* The LightBlue Bean can be found here: [http://punchthrough.com/bean/](http://punchthrough.com/bean/)). 
* The libBean SDK can be found here: [https://github.com/PunchThrough/Bean-iOS-OSX-SDK](https://github.com/PunchThrough/Bean-iOS-OSX-SDK).

Once the program is loaded, to start the demo, simply click on the red X, or open a new connection from the File->New Bean Connection menu.
This will open up a bean connection window, and your bean should show up.

You can change the scratch values by double-clicking on them in the scratch table.

# Known Bugs

There are a couple of bugs -- 

1. Disconnecting sometimes causes an exception. I believe this has to do with some thread safety issues, but I haven't figured them out yet.

2. The window is a bit cramped, but I was getting frustrated with Interface Builder, so I haven't adjusted it properly.

# Licensing

This SDK is covered under **The MIT License**. See `LICENSE.txt` for more details.