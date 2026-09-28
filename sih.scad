// ====================================================================
// CELESTIAL MISSION CONSOLE - FIXED LABEL POSITIONS & SPACING
// ====================================================================

$fn = 60; // Smooth curves

// Overall Box Dimensions
w = 220; // Width
d = 140; // Depth
h = 120; // Height

// Wall Thickness
wall = 4;

// Colors
c_wood  = [0.55, 0.35, 0.20];
c_metal = [0.12, 0.16, 0.22];
c_brass = [0.85, 0.68, 0.25];
c_screen= [0.03, 0.05, 0.08];
c_cyan  = [0.20, 0.70, 0.95];
c_text  = [0.95, 0.95, 0.95]; // Off-white for screen-printed labels

main_console();

module main_console() {

    // 1. RECTANGULAR WOODEN BOX (FULLY ENCLOSED WITH TOP CAP)
    color(c_wood) {
        difference() {
            // Solid Outer Box
            translate([0, 0, h/2])
                cube([w, d, h], center = true);

            // Hollow Internal Cavity (Leaves top wall intact)
            translate([0, 0, (h - wall)/2])
                cube([w - 2*wall, d - 2*wall, h - wall], center = true);

            // Top Card Reader Pass-Through Slot
            translate([0, 0, h - wall/2])
                cube([40, 6, wall + 2], center = true);
        }
    }

    // 2. FRONT FACEPLATE & COMPONENTS (Flat on Front Y-Face)
    translate([0, -d/2 - 2, h/2]) {
        
        // Base Dark Metal Plate
        color(c_metal)
            cube([w - 16, 1, h - 16], center = true);

        // Brass Corner Screws
        color(c_brass) {
            for (x = [-(w-30)/2, (w-30)/2], z = [-(h-30)/2, (h-30)/2])
                translate([x, -1, z]) 
                    rotate([90, 0, 0]) cylinder(r = 2, h = 1.5, center = true);
        }

        // --- Main Title Header ---
        color(c_text)
            translate([0, -1, 44])
                rotate([90, 0, 0])
                    linear_extrude(height = 1)
                        text("CELESTIAL MISSION CONSOLE", size = 4.5, halign = "center", valign = "center", font = "Liberation Sans:style=Bold");

        // --- Celestial Dial (Upper Left) & Label ---
        translate([-45, -3, 14]) {
            rotate([90, 0, 0]) {
                color(c_brass) cylinder(r = 24, h = 4, center = true);
                color(c_metal) translate([0, 0, 1.5]) cylinder(r = 20, h = 2, center = true);
                color(c_brass) translate([0, 0, 7]) cylinder(r = 7, h = 10, center = true);
                
                // LED Indicator Beads
                color(c_cyan)
                    for (a = [30 : 25 : 210])
                        rotate([0, 0, a]) translate([16, 0, 2.8]) cylinder(r = 1.3, h = 1, center = true);
            }

            // Dial Label (Shifted below dial with proper clearance)
            color(c_text)
                translate([0, 1.5, -29])
                    rotate([90, 0, 0])
                        linear_extrude(height = 1)
                            text("ALIGNMENT", size = 3, halign = "center", valign = "center", font = "Liberation Sans:style=Bold");
        }

        // --- OLED Display Screen (Upper Right) & Label ---
        translate([40, -2, 12]) {
            rotate([90, 0, 0]) {
                color(c_brass) cube([62, 34, 3], center = true);
                color(c_screen) translate([0, 0, 1]) cube([56, 28, 2.5], center = true);
            }

            // Screen Header Label (Positioned cleanly above screen frame)
            color(c_text)
                translate([0, 0.5, 23])
                    rotate([90, 0, 0])
                        linear_extrude(height = 1)
                            text("SYSTEM TELEMETRY", size = 3, halign = "center", valign = "center", font = "Liberation Sans:style=Bold");
        }

        // --- Control Buttons (Middle Right) & Labels ---
        translate([0, -3, -12]) {
            rotate([90, 0, 0]) {
                for (i = [0 : 3]) {
                    translate([14 + (i * 17), 0, 4]) {
                        color(c_brass) cylinder(r = 3.5, h = 7, center = true);
                        color(c_metal) translate([0, 0, -2.5]) cylinder(r = 5, h = 1.5, center = true);
                    }
                }
            }

            // Button Function Labels (Placed cleanly below individual buttons)
            btn_labels = ["PWR", "SCAN", "LINK", "EXEC"];
            color(c_text) {
                for (i = [0 : 3]) {
                    translate([14 + (i * 17), 1.5, -7])
                        rotate([90, 0, 0])
                            linear_extrude(height = 1)
                                text(btn_labels[i], size = 2.2, halign = "center", valign = "center", font = "Liberation Sans:style=Bold");
                }
            }
        }

        // --- Lower Code Rail & 8 Tiles & Label ---
        translate([0, -2, -38]) {
            rotate([90, 0, 0]) {
                color(c_metal) cube([w - 28, 22, 3], center = true);

                block_colors = [
                    [0.9, 0.7, 0.2], [0.2, 0.5, 0.8], 
                    [0.9, 0.7, 0.2], [0.2, 0.5, 0.8], 
                    [0.9, 0.7, 0.2], [0.8, 0.2, 0.2], 
                    [0.5, 0.3, 0.7], [0.2, 0.6, 0.3]
                ];

                for (i = [0 : 7]) {
                    x_pos = -(w - 60)/2 + (i * 21);
                    
                    // Receiver Slot
                    color([0.2, 0.2, 0.25]) 
                        translate([x_pos, -5, 2]) cube([18, 8, 2], center = true);
                        
                    // Code Block Tile
                    color(block_colors[i]) 
                        translate([x_pos, 3, 4]) cube([18, 11, 6], center = true);
                }
            }

            // Code Rail Section Label (Shifted above sequence rail to prevent overlap)
            color(c_text)
                translate([0, 0.5, 15])
                    rotate([90, 0, 0])
                        linear_extrude(height = 1)
                            text("PROGRAM SEQUENCE", size = 2.8, halign = "center", valign = "center", font = "Liberation Sans:style=Bold");
        }
    }

    // 3. TOP CARD READER SLOT, MISSION CARD & LABEL
    translate([0, 0, h + 3]) {
        color(c_brass)
            difference() {
                cube([48, 16, 6], center = true);
                cube([40, 6, 8], center = true);
            }
        color(c_metal) translate([0, 0, 14]) cube([36, 3, 28], center = true);

        // Top Slot Label
        color(c_text)
            translate([0, 11, 0])
                rotate([90, 0, 0])
                    linear_extrude(height = 1)
                        text("MISSION CARD SLOT", size = 2.5, halign = "center", valign = "center", font = "Liberation Sans:style=Bold");
    }
}