include <HausCommon.scad>;


EDGING_WIDTH = 0.1;
EDGING_SUNK = 0.03;

WINDOWFRAME_WIDTH = 0.04;
WINDOWFRAME_OFFSET = 0.04;
BLIND_WIDTH = 0.03;


module window_frame(width, height, thickness, subdivisions = 1, blind = 0.5) {
    module frame(inset, pos, frame_thickness) {
        difference() {
        e = EDGING_WIDTH;
        translate([-e,0,-e])
            cube([width + e * 2, thickness - EDGING_SUNK, height + e * 2]);
        translate([0,-e,0])
        cube([width, thickness + e*2, height]);
    }
    }
    
    // Edging
    colored_part("EDGING", "White") difference() {
        e = EDGING_WIDTH;
        translate([-e,0,-e])
            cube([width + e * 2, thickness - EDGING_SUNK, height + e * 2]);
        translate([0,-thickness,0])
        cube([width, thickness*3, height]);
    }
    
    colored_part("WINDOWFRAME", "DimGray") { 
        difference() {
            e = WINDOWFRAME_WIDTH;
            translate([0,thickness*0.5,0])
                cube([width, 0.04, height]);
            translate([e,-thickness,e])
                cube([width - e * 2, thickness*3, height - e * 2]);
        }
        
        difference() {
            inset = WINDOWFRAME_OFFSET;
            e = WINDOWFRAME_WIDTH;
            translate([inset,thickness*0.5 + 0.04,inset])
                cube([width - inset*2, 0.04, height - inset*2]);
            translate([e + inset,-thickness,e + inset])
                cube([width - (e + inset) * 2, thickness*3, height - (e + inset) * 2]);
        }
        
        if (subdivisions >= 2) {
            for (i = [1:subdivisions-1]) {
                inset = WINDOWFRAME_OFFSET;
                e = WINDOWFRAME_WIDTH;
                translate([inset+ i * (width - inset*2) / subdivisions - e / 2,thickness*0.5 + 0.02 ,inset])
                cube([e, 0.04, height - (e) * 2]);
            }
        }
    }
    
    colored_part("WINDOWSILL", "Black") {
        translate([0, thickness/2,-0.02]) rotate([-6,0,0]) cube([width, thickness*0.5, 0.06]);
    }
    
    colored_part("WINDOWGLASS", [0.3,0.3,0.3,0.1]) {
        translate([0,thickness*0.5,0])
                cube([width, 0.04, height]);
    }
    
    colored_part("BLIND", "White") {
        blindcount = floor(blind*height/BLIND_WIDTH);
        for (i = [0:blindcount]) {
            translate([0,thickness*0.75, height - i*BLIND_WIDTH - BLIND_WIDTH]) {
                intersection() {
                    cube([width, 0.02, BLIND_WIDTH]);
                    translate([0,-BLIND_WIDTH*0.35,BLIND_WIDTH*0.5]) rotate([0,90,0]) cylinder(r = BLIND_WIDTH, h = width, $fn = 32);
                }
                
                if (i == blindcount)
                translate([0,0.005, -BLIND_WIDTH*0.3]) cube([width, 0.025, BLIND_WIDTH*0.4]);
            }
        }
        
    }
    
}


window_frame(0.885, 1.0, 0.365);

