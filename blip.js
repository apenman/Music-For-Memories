function Blip(x, y, colVal) {
    this.x = x;
    this.y = y;
    this.rad = 10;
    this.alpha = 200;
    this.colVal = colVal;

    this.draw = function() {
        fill(255, 255, 255, this.alpha);
        ellipse(x, y, this.rad);
        fill(colVal[0], colVal[1], colVal[2]);
        ellipse(x, y, this.rad / 1.5);
    }

    this.grow = function() {
        this.rad += 3;
        this.alpha -= 2;
    }

    this.isAlive = function() {
        return this.alpha > 0;
    }

}
