include <HausCommon.scad>;

// Südseite
outer_wall(10.49, 0) {
    // Fenster Flur
    window(1.13, 0.86, 1.42);
    
    // Fenster Arbeitszimmer
    window(1.51, 4.115, 1.42);
    
    // Fenster Wohnzimmer
    window(1.01, 4.115 + 1.51 + 2.74, 1.42);
}

thin_inner_wall(3.765 + 0.175*2, 2.135, 2.76) {
    door(1.8);

}
thick_inner_wall(2.135 + 0.175 + 3.765 + 0.175, 0.0, 5.07) {
    door(2.0);
    door(3.50, 0.76);

}

horizontal() {
    // Westseite
    outer_wall(8.61, 0, 0) {
        door(0.76, 1.0);
        window(0.885, 3.74, 2.26, 3.16);
    }

    // Ostseite
    outer_wall(8.61, 0, 10.125) {
        // Wohnzimmerfenster
        window(1.51, 1.11, 1.42);
        // Terrassentür
        door(1.11 + 1.51 + 1.865, 3.01, 2.26);
    }

    thin_inner_wall(2.64, 5.07 + 0.175, 3.135);
    thin_inner_wall(2.64, 5.07 + 0.175, 3.135 + 1.095 + 0.115);
    thick_inner_wall(2.64, 5.07 + 0.175, 3.135 + 1.095 + 0.115*2 + 1.615) {
        door(1.4, 0.63);
    }
    
    thick_inner_wall(2.76, 0.0, 2.135);
    thick_inner_wall(2.76, 0.0, 2.135 + 3.765 + 0.175);
}



// Nordseite
outer_wall(10.49, 0, 8.615 - OUTER_WALL_THICKNESS) {
    // Fenster HWR
    window(1.13, 1.49, 0.635, 1.63);
    
    // Fenster Gäste-WC
    window(0.76, 1.49 + 1.13 + 1.24, 0.635, 1.63);
    
    // Fenster Vorratskammer
    window(0.88, 1.49 + 1.13 + 1.24 + 0.76 + 0.615, 0.635, 1.63);
    
    // Küche Festverglasung
    window(1.50, 1.49 + 1.13 + 1.24 + 0.76 + 0.615 + 0.885 + 1.615, 0.35, 1.0);
}

// Flur
color("SaddleBrown") group() {
    ground(2.135, 2.76 + 0.115);
    ground(2.135 + 0.175 + 0.175 + 3.765, 2.19, 0, 2.76 + 0.115);
}

// HWR
color ("Silver") {
    ground(3.135, 2.64, 0, 2.76 + 0.115 + 2.19 + 0.175);
}

// Gäste WC
color ("Silver") {
    ground(1.095, 2.64, 3.135 + 0.115, 2.76 + 0.115 + 2.19 + 0.175);
}

// Vorratskammer
color ("Silver") {
    ground(1.615, 2.64, 3.135 + 0.115 + 0.115 + 1.095, 2.76 + 0.115 + 2.19 + 0.175);
}

// Küche
color ("Orange") {
    ground(3.51, 2.64 + 0.175, 3.135 + 0.115 + 0.115 + 1.095 + 1.615 + 0.175, 2.76 + 0.115 + 2.19);
}

// Wohnzimmer
color ("SaddleBrown") {
    ground(3.51, 5.07, 3.135 + 0.115 + 0.115 + 1.095 + 1.615 + 0.175, 0.0);
}

// Arbeitszimmer
color ("SaddleBrown") {
    ground(3.765, 2.76, 2.135 + 0.175, 0.0);
}

