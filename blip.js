function Blip(x, y) {
    this.x = x;
    this.y = y;
    this.rad = 10;
    this.alpha = 200;

    this.draw = function() {
        noStroke();
        fill(255, 255, 255, this.alpha);
        ellipse(x, y, this.rad);
    }

    this.grow = function() {
        this.rad += 5;
        this.alpha -= 9;
    }

    this.isAlive = function() {
        return this.alpha > 0;
    }

}
