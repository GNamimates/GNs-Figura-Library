for (let x = 0; x < 16; x++) {
    for (let y = 0; y < 16; y++) {
        new Cube({from: [x, y, 0], to: [x+1, y+1, 1],name: "x"+x.toString()+"y"+y.toString(), faces: {up: {texture:null},down: {texture:null},south: {texture:null},east: {texture:null},west: {texture:null}}}).init()
    }
}