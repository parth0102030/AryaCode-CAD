// ==========================================
// OpenSCAD Model: Physical Computing Console
// Detailed Electronics, Wiring Harnesses & Components
// ==========================================

$fn = 32;

// --- Colors ---
color_wood   = [0.75, 0.45, 0.22];
color_rail   = [0.15, 0.15, 0.15];
color_pcb    = [0.08, 0.45, 0.22];
color_esp    = [0.12, 0.12, 0.12];
color_brass  = [0.85, 0.65, 0.25];
color_black  = [0.1, 0.1, 0.1];
color_metal  = [0.8, 0.8, 0.82];

// Wire Colors
color_red    = [0.85, 0.15, 0.15];
color_blue   = [0.15, 0.35, 0.85];
color_yellow = [0.9, 0.75, 0.1];
color_green  = [0.15, 0.7, 0.2];

// --- Dimensions (in mm) ---
base_w = 420;
base_d = 200;
wall_t = 10;
back_h = 100;
front_h = 25;

rail_x = 25;
rail_y = 20;
rail_w = base_w - 2 * rail_x;
slot_count = 8;
slot_pitch = rail_w / slot_count;
slot_w = 38;

main_assembly();

module main_assembly() {
    // 1. Wooden Enclosure
    color(color_wood) {
        cube([base_w, base_d, wall_t]);
        translate([0, base_d - wall_t, 0]) cube([base_w, wall_t, back_h]);
        side_panel();
        translate([base_w - wall_t, 0, 0]) side_panel();
    }

    // 2. Front Code Rail
    translate([rail_x, rail_y, wall_t])
        code_rail();

    // 3. 8x NFC Reader Modules + Individual Wire Run Lead Cables
    for (i = [0 : slot_count - 1]) {
        slot_center_x = rail_x + (i + 0.5) * slot_pitch;

        // NFC PCB
        translate([slot_center_x - 18, rail_y - 2, wall_t + 0.5])
            nfc_module();

        // Standoff Screws
        color(color_brass) {
            translate([slot_center_x - 12, rail_y - 8, wall_t]) cylinder(r=1.5, h=10);
            translate([slot_center_x + 12, rail_y - 8, wall_t]) cylinder(r=1.5, h=10);
        }

        // Cable routing from each NFC board toward backboard
        wire_color = (i % 4 == 0) ? color_red : (i % 4 == 1) ? color_blue : (i % 4 == 2) ? color_yellow : color_green;
        color(wire_color)
            translate([slot_center_x, rail_y + 20, wall_t + 1])
            rotate([0, 90, 90])
            cylinder(r=0.9, h=base_d - rail_y - wall_t - 20);

        // Wire guide clip along floor
        color(color_black)
            translate([slot_center_x - 3, base_d / 2, wall_t])
            cube([6, 5, 4]);
    }

    // 4. Backboard Electronics

    // Audio Buzzer
    translate([35, base_d - wall_t, back_h - 25])
        rotate([90, 0, 0])
        color(color_black) {
            cylinder(r=10, h=8);
            cylinder(r=2, h=9);
        }

    // ESP32 Board
    translate([120, base_d - wall_t, back_h - 45])
        rotate([90, 0, 0])
        esp32_board();

    // Raspberry Pi 4
    translate([270, base_d - wall_t, back_h - 60])
        rotate([90, 0, 0])
        raspberry_pi();

    // Power Terminal Distribution Block
    translate([180, base_d - wall_t, back_h - 85])
        rotate([90, 0, 0])
        terminal_block();

    // 5. Main Interconnecting Wire Bundles & Ribbons

    // Bus trunk wire harness running across the backboard
    color(color_black)
        translate([30, base_d - wall_t - 5, back_h - 75])
        rotate([0, 90, 0])
        cylinder(r=2.5, h=330);

    // Cable Zip-tie Holders along backboard
    for (x_pos = [60, 160, 260, 360]) {
        color(color_black)
            translate([x_pos, base_d - wall_t - 6, back_h - 78])
            cube([4, 6, 8]);
    }

    // Ribbon Cable (ESP32 to Raspberry Pi GPIO)
    color([0.8, 0.8, 0.8])
        translate([148, base_d - wall_t - 4, back_h - 40])
        rotate([90, 0, 0])
        cube([120, 1.2, 12]);

    // Red & Black Power Loop Wires to Terminal Block
    color(color_red)
        translate([170, base_d - wall_t - 3, back_h - 55])
        rotate([90, 0, 0])
        cylinder(r=1, h=25);

    color(color_black)
        translate([175, base_d - wall_t - 3, back_h - 55])
        rotate([90, 0, 0])
        cylinder(r=1, h=25);
}

// --- Sub-Modules ---

module side_panel() {
    rotate([90, 0, 90])
        linear_extrude(height = wall_t) {
            polygon(points=[
                [0, 0],
                [base_d, 0],
                [base_d, back_h],
                [0, front_h]
            ]);
        }
}

module code_rail() {
    rail_depth = 42;
    rail_height = 18;

    color(color_rail) {
        difference() {
            cube([rail_w, rail_depth, rail_height]);

            for (i = [0 : slot_count - 1]) {
                slot_x = (i + 0.5) * slot_pitch - (slot_w / 2);
                translate([slot_x, -1, 3])
                    cube([slot_w, rail_depth + 2, rail_height]);
            }
        }
    }
}

module nfc_module() {
    // Board
    color(color_pcb) {
        difference() {
            cube([36, 24, 1.6]);
            translate([3, 3, -0.5]) cube([30, 18, 2.6]);
        }
    }
    // NFC IC Chip
    color(color_black) translate([15, 9, 1.6]) cube([6, 6, 1]);

    // Header Pins & Soldered Joint Blocks
    color(color_black) translate([1, 20, 1.6]) cube([34, 3, 2.5]);
    color(color_brass) {
        for (p = [0:7]) {
            translate([3 + p*4, 21.5, 4.1]) cylinder(r=0.4, h=3);
        }
    }
}

module esp32_board() {
    color(color_black) cube([28, 52, 1.6]);
    color(color_metal) translate([5, 18, 1.6]) cube([18, 26, 3]);
    color(color_metal) translate([10, -2, 1.6]) cube([8, 6, 3]);

    // Pin Headers
    color(color_black) {
        translate([1, 0, 1.6]) cube([2.5, 52, 8]);
        translate([24.5, 0, 1.6]) cube([2.5, 52, 8]);
    }

    // Onboard LEDs & Capacitors
    color(color_red) translate([3, 4, 1.6]) cube([1.5, 2, 1]);
    color(color_blue) translate([23, 4, 1.6]) cube([1.5, 2, 1]);
}

module raspberry_pi() {
    pi_w = 85;
    pi_h = 56;

    color(color_pcb) cube([pi_w, pi_h, 1.6]);

    // Ports
    color(color_metal) {
        translate([pi_w - 17, 9, 1.6]) cube([17, 13, 16]);
        translate([pi_w - 17, 27, 1.6]) cube([17, 13, 16]);
        translate([pi_w - 21, 43, 1.6]) cube([21, 11, 13.5]);
    }

    // 40-Pin GPIO Pins
    color(color_black) translate([5, pi_h - 6, 1.6]) cube([51, 5, 8.5]);
    color(color_brass) {
        for (gx = [0:19]) {
            translate([6.5 + gx*2.5, pi_h - 4.5, 10.1]) cylinder(r=0.3, h=3);
            translate([6.5 + gx*2.5, pi_h - 2, 10.1]) cylinder(r=0.3, h=3);
        }
    }

    // Processor & SMD Components
    color(color_metal) translate([28, 22, 1.6]) cube([14, 14, 1.5]);
    color(color_black) translate([12, 10, 1.6]) cube([8, 8, 1.2]);
}

module terminal_block() {
    // Screw Terminal Breakout Block
    color([0.2, 0.6, 0.3]) cube([45, 12, 10]);
    color(color_metal) {
        for (t = [0:7]) {
            translate([3 + t*5, 3, 10]) cylinder(r=1.5, h=1);
            translate([3 + t*5, 9, 10]) cylinder(r=1.5, h=1);
        }
    }
}