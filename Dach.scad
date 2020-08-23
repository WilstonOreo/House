include <HausCommon.scad>;

module roof_top(height = 0.15) {
    angle = 20.0;
    
    difference() {
        translate([-0.3,-0.3,4.13]) rotate([0,angle,0]) 
            cube([12.0, 8.61 + 0.3 + 0.3,height]);
        translate([0.365 + 0.2,2.575, 1.0]) 
            cube([6.0, 3.46, 3.0]);
    }
}

module dormer_top(height = 0.15) {
    angle = 9.0;
    
    translate([0.0,-0.25 + 2.575,4.03])     rotate([0,angle,0])
        cube([7.0, 3.46 + 0.25 + 0.25,height]);
}

translate([0,0, WALL_HEIGHT]) {
    #roof_top();
    #dormer_top();
}
/*


difference() {
translate([-0.3,-0.3,4.23])     rotate([0,20,0]) 
#cube([12.0, 8.61 + 0.3 + 0.3,0.3]);
    translate([0.365 + 0.2,2.575, 1.5]) #cube([6.0, 3.46, 6.0]);
}
    translate([-0.0,-0.25 + 2.575,4.03])     rotate([0,9,0])
#cube([7.0, 3.46 + 0.25 + 0.25,0.3]); */
