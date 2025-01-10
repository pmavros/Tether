
# Tether

## Getting started!
* TOC
{:toc}



![](docs/assets/diagram.png)

## Description
TETHER enables the connection of a video playback in Processing and a CAD drawing in Rhinoceros. Behind the scenes, the Processing script relies on the OSC protocol to broadcast the playback position (i.e. the timestamp of the current frame, expressed as milliseconds from start, and as a percentage of the total movie duration). On the Rhinoceros side, a Grasshopper script, receive the timestamp information and allows the user to control the movie playback. When the user adds a new point on the current drawing on Rhino, the timestamp gets appended to the point as the object name as well as a separate attribute.  

## Getting started!

### Why would I want to use Tether?
Tether allows you to manually create trajectories or trace other behaviours in a spatial format that includes timestamps obtained from a video source.

![](docs/assets/screenshot_tutorial.png)

The data are then saved as a Rhino file (.3dm) as points with xyz coordinate and additional attributes (ID, timestamp, behaviour type). Tether helps to then export this point data into a csv file for further processing, e.g. in QGIS or R.

![](docs/assets/csvexport_screenshot.png)

### How to install?
1. If you don't have it installed already, download and install [Rhinoceros 3D](https://www.rhino3d.com/) **version 8** for Windows (license or use up to 90 days on trial version). At the moment the tool does not work on Rhino for Mac or earlier versions of Rhino. 
2. Download the latest release of Tether or get the whole repository as a zip file. Unpack zip.
3. Start Rhino, start Grasshopper (enter command grasshopper). From Grasshopper > Open File > [... folder where you saved the Tether]/tether.gh
4. Rhino will then prompt you to install the dependencies of Tether using its own package manager. This typically covers some of them, but you need to install the rest manually.
5. Go to the Grasshopper Window, File > Special Folders > Components Folder. Then drag-and-drop the following files: Human.gha, TreeFrog.gha, gHowl_r50.gha 'Tether/Tether_Grasshopper/dependencies' to the 'Components Folder'
6. Restart Rhino.
   
4. To run the Tether Video.

## Requirements

TETHER consists of two parts:




### #1 Processing http://processing.org

A lightweigh script plays a movie, broadcasts the timestampt to the localhost using OSC and receives playback commands from the keyboard and also using OSC.

The following external libraries are used. You can directly install both libraries from Processing (Tools > Add Tool > ...)

1. Andreas Schlegel 's OscP5 and NetP5 libraries - http://www.sojamo.de/libraries/oscP5/. This allows us to send / receive messages with other applications using the [OSC protocol](http://opensoundcontrol.org/introduction-osc)
1. Oleg Sidorov 's VLCJVideo library - https://github.com/icanhazbroccoli/VLCJVideo

### #2 Rhinoceros 3D modeling software https://www.rhino3d.com/

A Grasshopper (GH) Script does four things:

1. It creates a simple UI to control the type of input and movie playback.
1. It listens to the localhost for incoming OSC messages, and receives the timestamp of the current frame using (sent by Processing).
1. It sends OSC messages with playback commands ( go +/- 5 seconds, use a slider to move in the movie).
1. It listens to the Rhino runtime environment for the addition of new *point* objects. When a new point is detected, the information from the timestamp, as well as other information determined by the user are appended.

The GH script relies on the following dependencies (external plugins that need to be loaded) and credit goes to their authors:
1. Human UI - [https://www.food4rhino.com/en/app/human-ui](https://www.food4rhino.com/en/app/human-ui)
1. gHowln - [https://www.food4rhino.com/en/app/ghowl](https://www.food4rhino.com/en/app/ghowl)
1. Heteroptera - [https://www.food4rhino.com/en/app/heteroptera](https://www.food4rhino.com/en/app/heteroptera)
