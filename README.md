RubensGUI
=========

This MATLAB program allows users to display an arbitrary shape on a Rubens' tube. Click on the GUI plot to add points to your shape, then hit the calculate and play sound buttons to see it on your Rubens' tube. It can also play a simple sine sweep from 50 to 1500 Hz.

It works by representing the polynomial with its Fourier Series and scaling all the sine and cosine terms to be multiples of the tube's fundamental frequency. Then, using superposition, these terms are added together to form a new standing wave that that looks like the drawn shape!

To run the code, you must use the [FourierSeries library by Matt Tearle](http://www.mathworks.com/matlabcentral/fileexchange/31013-simple-real-fourier-series-approximation) and place the folder in the ```RubensGUI``` directory.

Sample Shape
=============
Here is a triangle in the GUI:

![Triangle Shape](https://raw.githubusercontent.com/connor-k/RubensGUI/master/Triangle.png)

Video of the result:

<a href="http://www.youtube.com/watch?feature=player_embedded&v=5NoCDmW5T1c
" target="_blank"><img src="http://img.youtube.com/vi/5NoCDmW5T1c/0.jpg" 
alt="Rubens' Tube Triangle Shape" width="240" height="180" border="10" /></a>

License
=======
MIT
