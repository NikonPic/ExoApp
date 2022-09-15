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
@Article{s22134804,
AUTHOR = {Wilhelm, Nikolas Jakob and Haddadin, Sami and Lang, Jan Josef and Micheler, Carina and Hinterwimmer, Florian and Reiners, Anselm and Burgkart, Rainer and Glowalla, Claudio},
TITLE = {Development of an Exoskeleton Platform of the Finger for Objective Patient Monitoring in Rehabilitation},
JOURNAL = {Sensors},
VOLUME = {22},
YEAR = {2022},
NUMBER = {13},
ARTICLE-NUMBER = {4804},
URL = {https://www.mdpi.com/1424-8220/22/13/4804},
PubMedID = {35808299},
ISSN = {1424-8220},
ABSTRACT = {This paper presents the application of an adaptive exoskeleton for finger rehabilitation. The system consists of a force-controlled exoskeleton of the finger and wireless coupling to a mobile application for the rehabilitation of complex regional pain syndrome (CRPS) patients. The exoskeleton has sensors for motion detection and force control as well as a wireless communication module. The proposed mobile application allows to interactively control the exoskeleton, store collected patient-specific data, and motivate the patient for therapy by means of gamification. The exoskeleton was applied to three CRPS patients over a period of six weeks. We present the design of the exoskeleton, the mobile application with its game content, and the results of the performed preliminary patient study. The exoskeleton system showed good applicability; recorded data can be used for objective therapy evaluation.},
DOI = {10.3390/s22134804}
}
```
