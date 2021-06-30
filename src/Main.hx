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
        var colors = [ '#000', '#030', '#111', '#240', '#350', '#600', '#650', '#700', '#750', '#800', '#999', '#aaa', '#baa', '#bbb', '#caa', '#daa', '#faa'];
        var w = 256;
        var h = 32;
        function scale(s) {
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
        function loop(t:Float) {
            {
                Shim.canvas.width = w*2;
                scale(2);

                col('#000');
                Shim.context.fillRect(0, 0, w, w);

                for(y in 0...h) {
                    for(x in 0...w) {
                        spread(x, y);
                        drawPixel(x, w - h + y, pixels[y * w + x]);
                    }
                }
            }
            // untyped requestAnimationFrame(loop);
            untyped setTimeout(loop, 30);
        }

        for(y in 0...h) {
            for(x in 0...w) {
                setPixel(x, y, 0);
                setPixel(x, h - 1, 16);
            }
        }

        loop(0);
    }
}
