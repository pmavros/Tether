## Getting started!
*TOC
{{:toc}}

### Why would I want to use Tether?
Section in progress.

### How to install?
1. If you don't have it installed already, download and install [Rhinoceros 3D](https://www.rhino3d.com/) (license or use up to 90 days on trial version).
2. Download the latest release or get the whole repository as a zip file. Unpack zip.
3. Start Rhino, start Grasshopper (enter command grasshopper). From Grasshopper > Open File > [... folder where you saved the Tether]/tether.gh
4. Open the Tether Video.

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

1. gHowln - [https://www.food4rhino.com/en/app/ghowl](https://www.food4rhino.com/en/app/ghowl)
1. Human UI - [https://www.food4rhino.com/en/app/human-ui](https://www.food4rhino.com/en/app/human-ui)
1. Heteroptera - [https://www.food4rhino.com/en/app/heteroptera](https://www.food4rhino.com/en/app/heteroptera)
1. Pufferfish - [https://www.food4rhino.com/en/app/pufferfish](https://www.food4rhino.com/en/app/pufferfish)
1. geospatial for saving a csv (can be changed)


## Acknowledgements

Thanks goes to the authors of the various libraries used for providing examples that I used to implement the final system, and to my colleagues at the [Future Cities Laboratory](www.fcl.ethz.ch) for encouraging me to wrap this up!
