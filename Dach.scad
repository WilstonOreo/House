include <HausCommon.scad>;

module roof_transform(angle = 20.0) {
    translate([-0.36,-0.3,4.13]) rotate([0,angle,0]) children();
}

module dormer_transform(angle = 9.0) {
    translate([0.0,-0.25 + 2.575,4.03]) rotate([0,angle,0]) children();
}

module solar_panel(width = 1.640, height = 0.992) {
    depth = 0.035;
    part("ROOF_SOLARPANEL") cube([width,height,depth]);
}

module roof_solar_panels() {
    translate([0.0,0.0,0.16]) {

        for (i = [0:1]) {
            for (j = [0:6]) {
                translate([0.2 + j*1.68, 0.2 + i*1.03,0]) solar_panel();
            }
        }
    }

    translate([0.0,6.8,0.16]) {

        for (i = [0:1]) {
            for (j = [0:6]) {
                translate([0.2 + j*1.68, 0.2 + i*1.03,0]) solar_panel();
            }
        }
    }

    translate([7.8,2.9,0.16]) {
        for (i = [0:2]) {
            for (j = [0:1]) {
                translate([0.2 + j*1.68, 0.2 + i*1.03,0]) solar_panel();
            }
        }
    }
}

module dormer_solar_panels() {
    translate([0.0,0.0,0.16]) {
        for (i = [0:2]) {
            for (j = [0:3]) {
                translate([0.1 + j*1.68, 0.5 + i*1.03,0]) solar_panel();
            }
        }
    }

}


module roof_top(height = 0.15) {
    difference() {
        roof_transform() {
            part("ROOF_TOP") cube([12.0, 8.61 + 0.3 + 0.3,height]);
            children();
        }
        translate([0.365 + 0.2,2.575, 1.0]) 
            color("gray") cube([6.0, 3.46, 3.0]);
    }
}

module dormer_top(height = 0.15) {
    dormer_transform()
        { 
            part("ROOF_TOP") cube([7.0, 3.46 + 0.25 + 0.25,height]);
            children();
        }
}


translate([0,0, WALL_HEIGHT]) {
    roof_top() {
        roof_solar_panels();
    }
    dormer_top() {
        dormer_solar_panels();
    }
}
/*


difference() {
translate([-0.3,-0.3,4.23])     rotate([0,20,0]) 
#cube([12.0, 8.61 + 0.3 + 0.3,0.3]);
    translate([0.365 + 0.2,2.575, 1.5]) #cube([6.0, 3.46, 6.0]);
}
    translate([-0.0,-0.25 + 2.575,4.03])     rotate([0,9,0])
#cube([7.0, 3.46 + 0.25 + 0.25,0.3]); */
