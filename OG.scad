include <HausCommon.scad>;
include <Dach.scad>;


BATHROOM_WIDTH = 2.50;

difference() {
    translate([0,0, WALL_HEIGHT]) {
max_wall_height = 4.135;

// Südseite
outer_wall(10.49, 0, 0, max_wall_height) {
    // Fenster Arbeitszimmer
    window(1.13, 0.86, 1.42);
}

thick_inner_wall(6.05 - BATHROOM_WIDTH, 0.0, 2.76, max_wall_height) {
    door(2.45, 0.9);

}
thick_inner_wall(6.05 - BATHROOM_WIDTH, 0.0, 5.07, max_wall_height) {
    door(2.45, 0.9);
}

thick_inner_wall(BATHROOM_WIDTH, 6.05 - BATHROOM_WIDTH, 2.575 - 0.365, max_wall_height); 

thick_inner_wall(BATHROOM_WIDTH, 6.05 - BATHROOM_WIDTH, 2.575 - 0.365 - 0.175 + 3.46, max_wall_height); 


horizontal() {
    // Westseite
    outer_wall(8.61, 0, 0, max_wall_height) {
        window(0.885, 3.74, 2.26, 3.16 - WALL_HEIGHT);
        window(1.51, 0.74, 1.72);
        window(1.51, 8.615 - 0.74 - 1.51, 1.72);
    }

    // Ostseite
    outer_wall(8.61, 0, 10.125, 0.30) {
    }
        // Ostseite
    wall(8.61, 0.24, 0, 6.01 + 0.365, 1.7) {
    }

        // Ostseite
    wall(3.46, 0.24, 2.575, 6.01 + 0.365, 3.0) {
        // Badezimmerfenster
        window(1.51, 0.95, 0.8, 1.60);
    }
    
    thin_inner_wall(3.46, 2.575 - 0.365, 6.05 - BATHROOM_WIDTH, max_wall_height) {
        door(1.8, 0.9);
    }
}


// Nordseite
outer_wall(10.49, 0, 8.615 - OUTER_WALL_THICKNESS, max_wall_height) {
}
color("SaddleBrown") group() {
    // Gästezimmer
    ground(6.05 - BATHROOM_WIDTH, 2.76);
    ground(BATHROOM_WIDTH, 2.575 - 0.365, 6.05 - BATHROOM_WIDTH);
    
    // Schlafzimmer
    ground(6.05 - BATHROOM_WIDTH, 2.76, 0, 2.76 + 0.175 * 2 + 2.135);
    ground(BATHROOM_WIDTH, 2.575 - 0.36, 6.05 - BATHROOM_WIDTH, 2.575 + 3.46 - 0.365 );

    // Galerie    
    ground(1.45, 2.135, 6.05 - BATHROOM_WIDTH - 1.45, 0.175 + 2.76);
   // ground(2.135 + 0.175 + 0.175 + 3.765, 2.19, 0, 2.76 + 0.115);
}

color("White") group() {
    ground(BATHROOM_WIDTH - 0.115, 3.46 - 0.175 * 2, 6.05 - BATHROOM_WIDTH 
     + 0.115, 2.575 - 0.19);
}

}





    translate([0,0, WALL_HEIGHT])
        roof_top(20.0);

    translate([0,0, WALL_HEIGHT])
        dormer_top(2.0);

}
