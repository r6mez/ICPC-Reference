/**
 * Author: Ramez
 * Description: cmath essentials for geometry. sin/cos/tan and
 * asin/acos/atan2 all work in RADIANS, never degrees.
 * Use double everywhere (never float).
 * Status: tested
 */
#pragma once

const double PI = acos(-1.0); // exact pi; M_PI also works
const double EPS = 1e-9;      // comparison tolerance
double degToRad(double d) { return d * PI / 180; }
double radToDeg(double r) { return r * 180 / PI; }
// never compare doubles with == or <; use these:
int sgn(double x) { return (x > EPS) - (x < -EPS); } // -1, 0, +1
bool eq(double a, double b) { return fabs(a - b) < EPS; }
struct P { double x, y; };
// dot = |a||b|cos t. >0 angle<90, =0 perpendicular, <0 angle>90
double dot(P a, P b) { return a.x * b.x + a.y * b.y; }
// cross = |a||b|sin t = 2*signed area of triangle (0,a,b).
// >0 b is ccw (left) of a, =0 collinear, <0 cw (right)
double cross(P a, P b) { return a.x * b.y - a.y * b.x; }
double len(P a) { return hypot(a.x, a.y); } // no overflow, vs sqrt
// angle of vector vs +x axis, in (-pi, pi]. NOT atan(y/x):
// atan loses the quadrant and divides by zero on x=0
double angleOf(P a) { return atan2(a.y, a.x); }
// signed ccw angle from a to b, in (-pi, pi]
double angleBetween(P a, P b) { return atan2(cross(a, b), dot(a, b)); }
P fromPolar(double r, double t) { return {r * cos(t), r * sin(t)}; }
P rotateCCW(P a, double t) { // around origin
	return {a.x * cos(t) - a.y * sin(t), a.x * sin(t) + a.y * cos(t)};
}
// clamp before acos/asin: rounding may give 1+1e-16 -> nan
double safeAcos(double v) { return acos(max(-1.0, min(1.0, v))); }
