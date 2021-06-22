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
        function drawCircle(x, y, r) {
            Shim.context.beginPath();
            Shim.context.arc(x, y, r, 0, 7);
            Shim.context.fill();
        }
        function random():Float {
            var x = (Math.sin(randomSeed++) + 1) * 99;
            return x - Std.int(x);
        }
        function loop(t:Float) {
            {
                // World
                col("#6bf");
                drawRect(screenSize/2, screenSize/2, screenSize, screenSize);
            }
            untyped requestAnimationFrame(loop);
        }
        loop(0);
    }
}
