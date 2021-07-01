@:native("")
extern class Shim {
    @:native("a") static var canvas:js.html.CanvasElement;
    @:native("c") static var context:js.html.CanvasRenderingContext2D;
}

class Main {
    static inline var screenSize = 512;
    static function main() {
        Shim.canvas.width = Shim.canvas.height = screenSize;
        var time:Int = 0;
        var pixels:Array<Int> = [];
        var colors = [ '#000', '#030', '#111', '#240', '#350', '#400', '#450', '#640', '#650', '#700', '#750', '#800', '#999', '#aaa', '#baa', '#bbb', '#caa', '#daa', '#dda', '#faa'];
        var w = 256;
        var h = 32;
        var mx:Int;
        var bx;
        var by = 190;
        var vx = 1;
        var vy = -1;
        var py = 200;
        var hits:Array<Int> = [];
        var stick = true;
        inline function scale(s) {
            Shim.context.scale(s, s);
        }
        function col(n:Dynamic) {
            Shim.context.fillStyle = n;
        }
        function alpha(n) {
            Shim.context.globalAlpha = n;
        }
        function drawRect(x:Float, y:Float, w:Float, h:Float) {
            Shim.context.fillRect(x-w/2, y-h/2, w, h);
        }
        inline function drawPixel(x:Int, y:Int, c:Int) {
            col(colors[c]);
            Shim.context.fillRect(x, y, 1, 1);
        }
        untyped onmousemove = function(e) {
            mx = Std.int(e.clientX / 2);

            if(e.buttons) {
                stick = false;
            }
        }
        function drawCircle(x, y, r) {
            Shim.context.beginPath();
            Shim.context.arc(x, y, r, 0, 7);
            Shim.context.fill();
        }
        inline function setPixel(x, y, c) {
            pixels[y * w + x] = c;
        }
        inline function spread(x, y) {
            var src = x + w * y;
            var p = pixels[src];

            if(p == 0) {
                setPixel(x, y - 1, 0);
            } else {
                var r = Std.int(Math.random() * 7 - 3);
                var dst = src - r;
                setPixel(x - r, y - 1, p - (r == 3 ? 0 : 1));
            }
        }
        function collision(x, y, i, j) {
            Shim.context.fillRect(x, y, i, j);

            if(bx >= x && bx <= x + i) {
                if(by == y || by == y + j) { vy *= -1; return true;}
            }

            if(by >= y && by <= y + j) {
                if(bx == x || bx == x + i) { vx *= -1; return true;}
            }

            return false;
        }
        function loop(t:Float) {
            {
                scale(2);
                col('#000');
                Shim.context.fillRect(0, 0, w, w);
                col('#a44');

                if(stick) {
                    bx = mx;
                } else {
                    bx += vx;
                    by += vy;

                    if(by > py +10) {
                        stick = true;
                        by = 190;
                        vy = -1;
                    }
                }

                for(j in 0...10) {
                    for(i in 0...13) {
                        if(untyped !hits[i * w + j]) {
                            if(collision(14 + i * 18, 15 + j * 10, 16, 4)) {
                                hits[i * w + j] = 1;
                            }
                        }
                    }
                }

                col('#888');
                collision(mx-7, 200, 20, 4);
                collision(0, 0, w, 4);
                collision(0, 0, 4, py);
                collision(w-4, 0, 4, py);
                Shim.context.fillRect(bx, by, 1, 1);

                for(y in 0...h) {
                    for(x in 0...w) {
                        spread(x, y);
                        drawPixel(x, w - h + y, pixels[y * w + x]);
                    }
                }

                scale(0.5);
            }
            // untyped setTimeout(loop, 10);
            untyped requestAnimationFrame(loop);
        }

        for(y in 0...h) {
            for(x in 0...w) {
                setPixel(x, y, 0);
                setPixel(x, h - 1, 18);
            }
        }

        loop(0);
    }
}
