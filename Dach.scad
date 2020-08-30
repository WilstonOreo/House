include <HausCommon.scad>;



module roof_transform(angle = 20.0, offset = 0.0) {
    translate([-0.36,-0.3,4.13]) rotate([0,angle,0]) translate([0.0,0.0,offset]) children();
}

module roof_translate() {
    translate([12.0,0.0,0.0]) mirror([1,0,0]) children();
}

module dormer_transform(angle = 9.0, offset = 0.0) {
    translate([0.0,-0.25 + 2.575,4.03]) rotate([0,angle,0]) translate([0.0,0.0,offset]) children();
}

module solar_panel(width = 1.640, height = 0.992) {
    depth = 0.035;
    part("ROOF_SOLARPANEL") cube([width,height,depth]);
}

module roof_ladder() {
    for (i = [0:14]) {
        roof_translate() translate([i*0.3, (i % 2) * 0.2, 0.19]) rotate([0, 20, 0]) cube([0.15, 0.15, 0.05]);
    }
}

module downpipe_circle(diameter = 0.1) {
    difference() {
        circle(d = diameter, $fn = 32);
        circle(d = diameter * 0.9, $fn = 32);
    }
}


module downpipe_part45deg(diameter = 0.1, distance = 0.3) {
    rotate_extrude(angle = 45, $fn = 64) translate([distance,0.0,0.0]) {
        difference() {
            downpipe_circle(diameter);
        }
    }
}


module downpipe(diameter = 0.1, height = 2.7, distance = 0.3, length = 0.3) {
    rotate([90,0,0]) translate([0,height,0]) {
        translate([-distance,-height + distance,0]) mirror([0,1,0]) downpipe_part45deg(diameter = diameter, distance = distance);
        rotate([90,0,0]) linear_extrude(height=height - distance) downpipe_circle(diameter);

        translate([-distance,0,0]) {
            downpipe_part45deg(diameter = diameter, distance = distance);
            translate([1* (distance) / sqrt(2), 1* (distance) / sqrt(2), 0])
                rotate([0,90,0]) rotate([-135,0,0]) linear_extrude(height=length) downpipe_circle(diameter);
    
            translate([distance*sqrt(2) - length / sqrt(2), distance*sqrt(2) + length / sqrt(2), 0])
                mirror([1,1,0]) rotate([0,0,45]) downpipe_part45deg(diameter = diameter, distance = distance);
        }
    }
}

module roof_downpipe() {
    diameter = 0.1;
    width = 9.2;
    part("ROOF_DOWNPIPE") roof_translate() 
        translate([-0.046,0.0,0.15]) rotate([-90,20,0]) {
            difference() {
                union() {
                    cylinder(d = diameter, h = width, $fn = 32);

                    distance = 0.5;
                    for (i = [0:9.2 / distance]) {
                        translate([0,0,distance*i]) cylinder(d = diameter*1.2, h = 0.02, $fn = 32);
                    }
                }
                translate([-diameter*0.75,-diameter*1.5,-0.1]) cube([diameter*1.5, diameter*1.5, width + 0.2]);
                translate([0.0,0.0,0.01]) cylinder(d = diameter*0.9, h = width - 0.02, $fn = 32);
                translate([0, 0, 8.8]) rotate([-90,0,0]) cylinder(d = diameter, h = 3.0, $fn = 32);
            }
        } 

    
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
            for (j = [0:2]) {
                translate([0.3 + j*1.68, 0.5 + i*1.03,0]) solar_panel();
            }
        }
    }

}


module roof_top(height = 0.15, offset = 0.0) {
    difference() {
        union() {
            roof_transform(offset = offset + 0.02) {
                part("ROOF_TOP") cube([12.0, 8.61 + 0.3 + 0.3,height - 0.02]);
                children();
            }
            roof_transform(offset = offset) {
                part("ROOF_BOTTOM") cube([12.0, 8.61 + 0.3 + 0.3,0.02]);
            }
        }
        translate([0.365 + 0.2,2.575, 1.0]) 
            color("gray") cube([6.0, 3.46, 3.0]);
    }
}

module dormer_top(height = 0.15) {
    dormer_transform(offset = 0.02)
    { 
        part("ROOF_TOP") cube([7.0, 3.46 + 0.25 + 0.25,height]);
    }
    dormer_transform()
    { 
        part("ROOF_BOTTOM") cube([7.0, 3.46 + 0.25 + 0.25,0.02]);
        children();
    }
}


module roof() {     
    translate([0,0, WALL_HEIGHT]) {
        difference() {
            translate([0,0, -WALL_HEIGHT]) chimney(WALL_HEIGHT + 1.5, 0.0);
            roof_transform(offset = -4.0)
                    cube([12.0, 8.61 + 0.3 + 0.3,4]);
        }

        difference() {
            window = [1.51, 0.8, 0.95, 1.63, undef]; // Badezimmerfenster

            group() {
                
                translate([0,0,2.4]) {
                    inner_walls([
                        ["S", 6.05 - BATHROOM_WIDTH, 0.0, 2.76],
                        ["N", 6.05 - BATHROOM_WIDTH, 0.0, 5.07],
                    ], 2.0);

                    inner_walls([
                        ["E", 3.46, 2.575 - 0.365, 6.05 - BATHROOM_WIDTH ]
                    ], 2.0, thickness = THIN_INNER_WALL_THICKNESS);
                };


            outer_walls([
                ["E", 3.46, 2.575, 6.01 + 0.365 + 0.24, [window]],
                ["N",  6.01 + 0.365 + 0.24, 0.0, 2.76 + 3.46 - 0.175],
                ["S",  6.01 + 0.365 + 0.24, 0.0, 2.76 - 0.24],
                ], 4.1, 0.24);
            }

            union() {
                roof_transform(offset = -4.0)
                    cube([12.0, 8.61 + 0.3 + 0.3,4]);
                dormer_top(3.0);
            }
        }
//        outer_walls([[  window]);

        part("ROOF_DOWNPIPE") translate([10.54,8.50,-WALL_HEIGHT]) mirror([1,0,0]) downpipe(height = 2.38, length = 0.4);

        roof_top() {
            roof_solar_panels();
            roof_downpipe();

            part("ROOF_LADDER") {
                translate([-0.2, 2.35,0.0]) roof_ladder();
                translate([-0.2, 6.8,0.0]) mirror([0,1,0]) roof_ladder();
            }
        }
        dormer_top() {
            dormer_solar_panels();
        }
    }
}
