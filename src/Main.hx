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
        var randomSeed;
        var pixels:Array<Int> = [];
        var colors = [ '#000', '#030', '#240', '#350', '#600', '#700', '#999', '#aaa' ];
        var w = 256;
        var h = 128;
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
        function random():Float {
            var x = (Math.sin(randomSeed++) + 1) * 99;
            return x - Std.int(x);
        }
        inline function setPixel(x, y, c) {
            pixels[y * w+ x] = c;
        }
        function loop(t:Float) {
            {
                Shim.canvas.width = screenSize;
                scale(2);

                for(y in 0...h) {
                    for(x in 0...w) {
                        drawPixel(x, y, pixels[y * w + x]);
                    }
                }
            }
            untyped requestAnimationFrame(loop);
        }

        for(y in 0...h) {
            for(x in 0...w) {
                setPixel(x, y, Std.int(Math.random() * 8));
            }
        }

        loop(0);
    }
}
