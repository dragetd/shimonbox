// Copyright (c) 2017 Michael Gajda <draget@speciesm.net>
//
// Permission to use, copy, modify, and distribute this software for any
// purpose with or without fee is hereby granted, provided that the above
// copyright notice and this permission notice appear in all copies.
//
// THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
// WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
// MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
// ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
// WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
// ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
// OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

include <../globals.scad>

use <../case.scad>
use <../utils.scad>
use <../electronics/button.scad>
use <../electronics/hdmi.scad>
use <../electronics/header.scad>
use <../electronics/misc.scad>
use <../electronics/network.scad>
use <../electronics/sd.scad>
use <../electronics/usb.scad>
use <../electronics/cpu.scad>
use <../electronics/jack.scad>

board_dim = [126.8, 79.5, 1.12];


/* Plate holes */
hole_d = 3;
hole_orig = [board_dim[0], board_dim[1]] * -0.5;
ring_off = 4;
holes_pos = [
    hole_orig + [4.4, 4.4],
    hole_orig + [4.4, board_dim[1] - 4.4],
    hole_orig + [board_dim[0] - 4.4, board_dim[1] - 4.4],
    hole_orig + [board_dim[0] - 4.4, 4.4],
];


/* Components bounding box dimensions */
cpu_dim         = [  15,  15,1.25];
hdmi_dim        = [11.5,  15, 6.5];
ethernet_dim    = [  21,  16,13.5];
gpio_dim        = [  51,   5, 8.5];
hdmi_dim        = [11.5,  15, 6.5];
jack_dim        = [14.5,   7,   6];
microsdcard_dim = [  15,  11,   1];
microsdslot_dim = [  15,  15,1.25];
microusb_dim    = [   6,   8,   3];
usbx2_dim       = [17.4,13.4,14.5];
powerbtn_dim    = [ 7.4, 7.4, 11.];


module pine64_b_plate_2d() {
    plate_2d(board_dim[0], board_dim[1], 4);
}

comp_info = [
    /* info function        box dimensions   comp-corner rotate  board-corner    position  */
    [cpu_info(),            cpu_dim,         [-1, 1,-1], [0,0, 0], [-1, 1, 1], [   47,-24.5, 0]],
    [hdmi_info(),           hdmi_dim,        [ 1,-1,-1], [0,0, 2], [-1, 1, 1], [   -2,-11.1, 0]],
    [ethernet_info(),       ethernet_dim,    [ 1, 0,-1], [0,0, 2], [-1, 0, 1], [   -3,    0, 0]],
    [microusb_info(),       microusb_dim,    [ 1, 0,-1], [0,0, 2], [-1, 0, 1], [   -1,-22.5, 0]],
    [microsdslot_info(),    microsdslot_dim, [ 1,-1,-1], [0,0,-1], [ 1,-1, 1], [-29.8,    0, 1]],
    [microsdcard_info(),    microsdcard_dim, [ 1,-1,-1], [0,0,-1], [ 1,-1, 1], [-28.8,   -3, 1]],
    [jack_info(),           jack_dim,        [ 1,-1,-1], [0,0, 0], [ 1,-1, 1], [    2,  9.8, 0]],
    [usbx2_info(),          usbx2_dim,       [ 1,-1,-1], [0,0, 0], [ 1, 1, 1], [  4.8,  -24, 0]],
    [button_drill_info(),   powerbtn_dim,    [ 1, 1, 1], [0,1, 0], [ 1, 1, 1], [  1.2,-35.5, 0]],
];

module pine64_b() {
    extrude_plate(board_dim[2], holes_pos, hole_d, ring_off)
        pine64_b_plate_2d();

    set_components(board_dim, comp_info) {
        cpu(dim=cpu_dim);
        hdmi(dim=hdmi_dim);
        ethernet(dim=ethernet_dim);
        microusb(dim=microusb_dim);
        microsdslot(dim=microsdslot_dim);
        microsdcard(dim=microsdcard_dim);
        jack(dim=jack_dim);
        usbx2(dim=usbx2_dim);
        button(dim=powerbtn_dim);
    }
}

function pine64_b_info() = [
    ["board_dim",  board_dim],
    ["components", comp_info],
    ["holes_d",    hole_d],
    ["holes_pos",  holes_pos],
];

demo_board(board_dim) {
   pine64_b();
   *#bounding_box(board_dim, comp_info);
}
