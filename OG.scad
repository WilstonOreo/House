include <HausCommon.scad>;

translate([0,0, WALL_HEIGHT]) {

difference() {
    group() {
max_wall_height = 4.135;

// Südseite
outer_wall(10.49, 0, 0, max_wall_height) {
    // Fenster Arbeitszimmer
    window(1.13, 0.86, 1.42);
}

thick_inner_wall(3.6, 0.0, 2.76) {
    door(2.3, 0.9);

}
thick_inner_wall(3.6, 0.0, 5.07) {
    door(2.3, 0.9);
}

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
    wall(3.46, 0.24, 2.57, 6.01 + 0.365, 3.0) {
    }
    
    
}


// Nordseite
outer_wall(10.49, 0, 8.615 - OUTER_WALL_THICKNESS, max_wall_height) {
}

} 

/*
difference() {
translate([-0.3,-0.3,4.23])     rotate([0,20,0]) 
#cube([12.0, 8.61 + 0.3 + 0.3,5.3]);
    translate([0.365 + 0.2,2.575, 1.5]) #cube([6.0, 3.46, 6.0]);
}
}

difference() {
translate([-0.3,-0.3,4.23])     rotate([0,20,0]) 
#cube([12.0, 8.61 + 0.3 + 0.3,0.3]);
    translate([0.365 + 0.2,2.575, 1.5]) #cube([6.0, 3.46, 6.0]);
}
    translate([-0.0,-0.25 + 2.575,4.03])     rotate([0,9,0])
#cube([7.0, 3.46 + 0.25 + 0.25,0.3]); */
}

}
