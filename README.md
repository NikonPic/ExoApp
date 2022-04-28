# Development of an Exoskeleton Platform of the Finger for Objective Patient Monitoring
>This repository represents the source code for a novel mechatronic exoskeleton application for finger rehabilitation and patient monitoring.


 <img src="assets\images\app_structure.png" alt="Drawing" style="width: 1600;">


## Setup

* Install Flutter (2.10+)


## What do the most important files in src do? 

    .     
    ├── 01_presentation                  # Contains the screens and  design
    │   ├── Exoskeleton                  # Folder with logic for Exo 
    │   ├── DeviceScreen                 # Bluetooth logic
    │   ├── UserInformation              # User Details
    │   ├── MeasurementDetailPage        # Manage Measurements
    │   └── home                         # Home Screen
    |
    ├── 02_application                   # Contains the exoskeleton and game logic
    |   ├── exoskeleton.dart             # Kinematic and dynamic logic
    |   ├── exoskeletongame.dart         # Game logic of "Dodge Rectangles"
    |   ├── exo_catch.dart               # Game logic of "Bubble Collector"
    │   └── paths.dart                   # manage paths on device
    |
    ├── 03_database                      # Folder for solving the potentiometer calibration
    |   ├── user.dart                    # definition of required user parameters
    │   └── user_database.dart           # database strucutre
    |
    |
    ├── constants.dart                   # All constants used 
    └── main.dart                        # Main file to run the app

# Citation

If you use this project in any of your work, please cite:

```
tbd ...
```