# Tether

## Description
TETHER enables the connection of a video playback in Processing and a CAD drawing in Rhinoceros. Behind the scenes, the Processing script relies on the OSC protocol to broadcast the playback position (i.e. the timestamp of the current frame, expressed as milliseconds from start, and as a percentage of the total movie duration). On the Rhinoceros side, a Grasshopper script, receive the timestamp information and allows the user to control the movie playback. When the user adds a new point on the current drawing on Rhino, the timestamp gets appended to the point as the object name as well as a separate attribute.  

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

The GH script relies on the following external plugins:

1. gHowl
1. Human UI
1. Human
1. Heteroptera

## Credits

Tether was conceived and put together by Panos Mavros. Thanks goes to the authors of the various libraries used for providing examples that I used to implement the final system.
