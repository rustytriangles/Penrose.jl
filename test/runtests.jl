using Penrose
using Test

# Helper functions
# Returns length of an edge between 2 pts
edgelen_fcn(p) = sqrt((p[2][1]-p[1][1])*(p[2][1]-p[1][1])+(p[2][2]-p[1][2])*(p[2][2]-p[1][2]))
# Returns angle (in degrees) of an edge between 2 pts
angle_fcn(p) = (360 + atan(p[2][2]-p[1][2], p[2][1]-p[1][1]) * 180 / pi) % 360
# Returns the mid-point of an edge between 2 pts
midpt_fcn(p) = [(p[2][1]+p[1][1])/2, (p[2][2]+p[1][2])/2]
# Returns the distance between 2 pts
dist_fcn(p1,p2) = sqrt((p2[1]-p1[1])*(p2[1]-p1[1]) + (p2[2]-p1[2])*(p2[2]-p1[2]))

@testset "Dart angle" begin

    # Angles outside [0-360] should get fixed in ctor
    @testset "angle range" begin
        @test Dart(0,0,-40).angle == 320
        @test Dart(0,0,400).angle ==  40
    end

    @testset "angle internal" begin
        internal_angles = [36, 72, 36, 216]
        d = Dart(0,0,0)
        @test (edge_angle(d,1) + (540 - internal_angles[1]))%360 == edge_angle(d,2)
        @test (edge_angle(d,2) + (540 - internal_angles[2]))%360 == edge_angle(d,3)
        @test (edge_angle(d,3) + (540 - internal_angles[3]))%360 == edge_angle(d,4)
        @test (edge_angle(d,4) + (540 - internal_angles[4]))%360 == edge_angle(d,1)
    end

    @testset "angle 0" begin
        d0 = Dart(0,0,0)
        @test edge_angle(d0, 1) == 252
        @test edge_angle(d0, 2) ==  36
        @test edge_angle(d0, 3) == 144
        @test edge_angle(d0, 4) == 288
    end

    @testset "angle +90" begin
        d90 = Dart(0,0,90)
        @test edge_angle(d90, 1) == 342
        @test edge_angle(d90, 2) == 126
        @test edge_angle(d90, 3) == 234
        @test edge_angle(d90, 4) ==  18
    end

    # -270 should be the same as +90
    @testset "angle -270" begin
        m270 = Dart(0,0,-270)
        @test edge_angle(m270, 1) == 342
        @test edge_angle(m270, 2) == 126
        @test edge_angle(m270, 3) == 234
        @test edge_angle(m270, 4) ==  18
    end

    @testset "angle +180" begin
        d180 = Dart(0,0,180)
        @test edge_angle(d180, 1) ==  72
        @test edge_angle(d180, 2) == 216
        @test edge_angle(d180, 3) == 324
        @test edge_angle(d180, 4) == 108
    end

    # -180 should be the same as +180
    @testset "angle -180" begin
        m180 = Dart(0,0,-180)
        @test edge_angle(m180, 1) ==  72
        @test edge_angle(m180, 2) == 216
        @test edge_angle(m180, 3) == 324
        @test edge_angle(m180, 4) == 108
    end

end

@testset "Kite angle" begin

    @testset "angle internal" begin
        internal_angles = [72, 144, 72, 72]
        k = Kite(0,0,0)
        @test (edge_angle(k,1) + (540 - internal_angles[1]))%360 == edge_angle(k,2)
        @test (edge_angle(k,2) + (540 - internal_angles[2]))%360 == edge_angle(k,3)
        @test (edge_angle(k,3) + (540 - internal_angles[3]))%360 == edge_angle(k,4)
        @test (edge_angle(k,4) + (540 - internal_angles[4]))%360 == edge_angle(k,1)
    end

    @testset "angle 0" begin
        k0 = Kite(0,0,0)
        @test edge_angle(k0, 1) == 324
        @test edge_angle(k0, 2) ==  72
        @test edge_angle(k0, 3) == 108
        @test edge_angle(k0, 4) == 216
    end

    @testset "angle 90" begin
        k90 = Kite(0,0,90)
        @test edge_angle(k90, 1) ==  54
        @test edge_angle(k90, 2) == 162
        @test edge_angle(k90, 3) == 198
        @test edge_angle(k90, 4) == 306
    end

    @testset "angle -270" begin
        m0 = Kite(0,0,-270)
        @test edge_angle(m0, 1) ==  54
        @test edge_angle(m0, 2) == 162
        @test edge_angle(m0, 3) == 198
        @test edge_angle(m0, 4) == 306
    end

    @testset "angle 180" begin
        k180 = Kite(0,0,180)
        @test edge_angle(k180, 1) == 144
        @test edge_angle(k180, 2) == 252
        @test edge_angle(k180, 3) == 288
        @test edge_angle(k180, 4) ==  36
    end

    @testset "angle -180" begin
        m180 = Kite(0,0,-180)
        @test edge_angle(m180, 1) == 144
        @test edge_angle(m180, 2) == 252
        @test edge_angle(m180, 3) == 288
        @test edge_angle(m180, 4) ==  36
    end

end

@testset "Dart edge slopes" begin
    d = Dart(0,0,0)

    @test angle_fcn(edge_points(d,1)) == edge_angle(d,1)
    @test angle_fcn(edge_points(d,2)) == edge_angle(d,2)
    @test angle_fcn(edge_points(d,3)) == edge_angle(d,3)
    @test angle_fcn(edge_points(d,4)) == edge_angle(d,4)
end

@testset "Kite edge slopes" begin
    k = Kite(0,0,0)

    @test angle_fcn(edge_points(k,1)) == edge_angle(k,1)
    @test angle_fcn(edge_points(k,2)) == edge_angle(k,2)
    @test angle_fcn(edge_points(k,3)) == edge_angle(k,3)
    @test angle_fcn(edge_points(k,4)) == edge_angle(k,4)
end

@testset "Dart edge lengths" begin
    d = Dart(0,0,0)

    l1 = (1+sqrt(5))/2
    l2 = 1 + l1

    @test edgelen_fcn(edge_points(d,1)) == l1
    @test edgelen_fcn(edge_points(d,2)) == l2
    @test edgelen_fcn(edge_points(d,3)) == l2
    @test edgelen_fcn(edge_points(d,4)) == l1
end

@testset "Kite edge lengths" begin
    k = Kite(0,0,0)

    l1 = (1+sqrt(5))/2
    l2 = 1 + l1

    @test edgelen_fcn(edge_points(k,1)) == l2
    @test edgelen_fcn(edge_points(k,2)) == l1
    @test edgelen_fcn(edge_points(k,3)) == l1
    @test edgelen_fcn(edge_points(k,4)) == l2
end

@testset "Dart edge center" begin
    d = Dart(0,0,0)

    @test dist_fcn(midpt_fcn(edge_points(d,1)), edge_center(d,1)) == 0
    @test dist_fcn(midpt_fcn(edge_points(d,2)), edge_center(d,2)) == 0
    @test dist_fcn(midpt_fcn(edge_points(d,3)), edge_center(d,3)) == 0
    @test dist_fcn(midpt_fcn(edge_points(d,4)), edge_center(d,4)) == 0
end

@testset "Kite edge center" begin
    k = Kite(0,0,0)

    @test dist_fcn(midpt_fcn(edge_points(k,1)), edge_center(k,1)) == 0
    @test dist_fcn(midpt_fcn(edge_points(k,2)), edge_center(k,2)) == 0
    @test dist_fcn(midpt_fcn(edge_points(k,3)), edge_center(k,3)) == 0
    @test dist_fcn(midpt_fcn(edge_points(k,4)), edge_center(k,4)) == 0
end

@testset "Dart geometry" begin
    phi = (1+sqrt(5))/2
    h = sqrt(5+2*sqrt(5))/2

    @testset "Compare geometry to edge_points" begin
        d = Dart(0,0,0)

        pts = geometry(d)
        @test size(pts) == (4,)
        @test dist_fcn(pts[1], edge_points(d,1)[1]) < 5e-8
        @test dist_fcn(pts[2], edge_points(d,1)[2]) < 5e-8
        @test dist_fcn(pts[2], edge_points(d,2)[1]) < 5e-8
        @test dist_fcn(pts[3], edge_points(d,2)[2]) < 5e-8
        @test dist_fcn(pts[3], edge_points(d,3)[1]) < 5e-8
        @test dist_fcn(pts[4], edge_points(d,3)[2]) < 5e-8
        @test dist_fcn(pts[4], edge_points(d,4)[1]) < 5e-8
        @test dist_fcn(pts[1], edge_points(d,4)[2]) < 5e-8
    end

    @testset "Angle = 0" begin
        d = Dart(0,0,0)

        pts = geometry(d)

        @test size(pts) == (4,)
        @test dist_fcn(pts[1], [0, 0]) < 5e-8
        @test dist_fcn(pts[2], [-1/2, -h]) < 5e-8
        @test dist_fcn(pts[3], [phi, 0]) < 5e-8
        @test dist_fcn(pts[4], [-1/2, h]) < 5e-8
    end

    @testset "Angle = 90" begin
        d = Dart(0,0,90)

        pts = geometry(d)

        @test size(pts) == (4,)
        @test dist_fcn(pts[1], [0, 0]) < 5e-8
        @test dist_fcn(pts[2], [h, -1/2]) < 5e-8
        @test dist_fcn(pts[3], [0, phi]) < 5e-8
        @test dist_fcn(pts[4], [-h,-1/2]) < 5e-8
    end

    @testset "origin = 10,10" begin
        d = Dart(10,10,0)

        pts = geometry(d)
        @test size(pts) == (4,)
        # Why's the tolerance worse here?
        @test dist_fcn(pts[1], [10, 10]) < 5e-7
        @test dist_fcn(pts[2], [10-(1/2), 10-h]) < 5e-7
        @test dist_fcn(pts[3], [10+phi, 10]) < 5e-7
        @test dist_fcn(pts[4], [10-(1/2), 10+h]) < 5e-7
    end
end

@testset "Kite geometry" begin
    k = Kite(0,0,0)

    pts = geometry(k)
    @test size(pts) == (4,)
    @test dist_fcn(pts[1], edge_points(k,1)[1]) < 5e-8
    @test dist_fcn(pts[2], edge_points(k,1)[2]) < 5e-8
    @test dist_fcn(pts[2], edge_points(k,2)[1]) < 5e-8
    @test dist_fcn(pts[3], edge_points(k,2)[2]) < 5e-8
    @test dist_fcn(pts[3], edge_points(k,3)[1]) < 5e-8
    @test dist_fcn(pts[4], edge_points(k,3)[2]) < 5e-8
    @test dist_fcn(pts[4], edge_points(k,4)[1]) < 5e-8
    @test dist_fcn(pts[1], edge_points(k,4)[2]) < 5e-8
end

@testset "Vertex 1" begin
    phi = (1+sqrt(5))/2

    d1 = Dart(-phi, 0, 0)
    d2 = placeDartEdge(3, edge_center(d1, 2), edge_angle(d1, 2))
    d3 = placeDartEdge(3, edge_center(d2, 2), edge_angle(d2, 2))
    d4 = placeDartEdge(3, edge_center(d3, 2), edge_angle(d3, 2))
    d5 = placeDartEdge(3, edge_center(d4, 2), edge_angle(d4, 2))

    h = sqrt(5+2*sqrt(5))/2
    k = (2+sqrt(5)) / (1+sqrt(5))
    p = sqrt(10 + sqrt(20))/4

    @test dist_fcn([d1.cx, d1.cy], [-phi, 0]) < 5e-8
    @test d1.angle == 0

    @test dist_fcn([d2.cx, d2.cy], [-1/2,-h]) < 5e-8
    @test d2.angle == 72

    @test dist_fcn([d3.cx, d3.cy], [k,-p]) < 5e-8
    @test d3.angle == 144

    @test dist_fcn([d4.cx, d4.cy], [k,p]) < 5e-8
    @test d4.angle == 216

    @test dist_fcn([d5.cx, d5.cy], [-1/2, h]) < 5e-8
    @test d5.angle == 288

end

@testset "Vertex 2" begin
    d1 = Dart(0, 0, 0)
    k1 = placeKiteEdge(2, edge_center(d1, 4), edge_angle(d1, 4))
    k2 = placeKiteEdge(4, edge_center(k1, 1), edge_angle(k1, 1))

    phi = (1+sqrt(5))/2
    h = sqrt(5+2*sqrt(5))/2
    k = (2+sqrt(5)) / (1+sqrt(5))
    p = sqrt(10 + sqrt(20))/4

    @test dist_fcn([d1.cx, d1.cy], [0, 0]) < 5e-8
    @test d1.angle == 0

    @test dist_fcn([k1.cx, k1.cy], [-k, p]) < 5e-8
    @test k1.angle == 36

    @test dist_fcn([k2.cx, k2.cy], [-k,-p]) < 5e-8
    @test k2.angle == 324
end

@testset "Vertex 3" begin
    phi = (1+sqrt(5))/2

    k1 = Kite(phi, 0, 0)
    k2 = placeKiteEdge(1, edge_center(k1, 4), edge_angle(k1, 4))
    k3 = placeKiteEdge(1, edge_center(k2, 4), edge_angle(k2, 4))
    k4 = placeKiteEdge(1, edge_center(k3, 4), edge_angle(k3, 4))
    k5 = placeKiteEdge(1, edge_center(k4, 4), edge_angle(k4, 4))

    h = sqrt(5+2*sqrt(5))/2
    k = (2+sqrt(5)) / (1+sqrt(5))
    p = sqrt(10 + sqrt(20))/4

    @test dist_fcn([k1.cx, k1.cy], [phi, 0]) < 5e-8
    @test k1.angle == 0

    @test dist_fcn([k2.cx, k2.cy], [1/2, h]) < 5e-8
    @test k2.angle == 72

    @test dist_fcn([k3.cx, k3.cy], [-k, p]) < 5e-8
    @test k3.angle == 144

    @test dist_fcn([k4.cx, k4.cy], [-k,-p]) < 5e-8
    @test k4.angle == 216

    @test dist_fcn([k5.cx, k5.cy], [1/2,-h]) < 5e-8
    @test k5.angle == 288
end

@testset "Vertex 4" begin
    phi = (1+sqrt(5))/2

    d1 = Dart(-phi, 0, 0)
    d2 = placeDartEdge(3, edge_center(d1, 2), edge_angle(d1, 2))
    k1 = placeKiteEdge(1, edge_center(d2, 2), edge_angle(d2, 2))
    k2 = placeKiteEdge(1, edge_center(k1, 4), edge_angle(k1, 4))
    d3 = placeDartEdge(3, edge_center(k2, 4), edge_angle(k2, 4))

    h = sqrt(5+2*sqrt(5))/2
    k = (2+sqrt(5)) / (1+sqrt(5))
    p = sqrt(10 + sqrt(20))/4

    @test dist_fcn([d1.cx, d1.cy], [-phi, 0]) < 5e-8
    @test d1.angle == 0

    @test dist_fcn([d2.cx, d2.cy], [-1/2,-h]) < 5e-8
    @test d2.angle == 72

    @test dist_fcn([k1.cx, k1.cy], [k,-p]) < 5e-8
    @test k1.angle == 324

    @test dist_fcn([k2.cx, k2.cy], [k, p]) < 5e-8
    @test k2.angle == 36

    @test dist_fcn([d3.cx, d3.cy], [-1/2, h]) < 5e-8
    @test d3.angle == 288
end

@testset "Vertex 5" begin
    k1 = Kite(-1, 0, 0)
    d1 = placeDartEdge(4, edge_center(k1, 2), edge_angle(k1, 2))
    k2 = placeKiteEdge(1, edge_center(d1, 3), edge_angle(d1, 3))
    k3 = placeKiteEdge(1, edge_center(k2, 4), edge_angle(k2, 4))
    d2 = placeDartEdge(2, edge_center(k3, 4), edge_angle(k3, 4))

    h = sqrt(5+2*sqrt(5))/2
    k = (2+sqrt(5)) / (1+sqrt(5))
    p = sqrt(10 + sqrt(20))/4

    @test dist_fcn([k1.cx, k1.cy], [-1, 0]) < 5e-8
    @test k1.angle == 0

    @test dist_fcn([d1.cx, d1.cy], [-1/2, -h]) < 5e-8
    @test d1.angle == 324

    @test dist_fcn([k2.cx, k2.cy], [ k, -p]) < 5e-8
    @test k2.angle == 324

    @test dist_fcn([k3.cx, k3.cy], [ k, p]) < 5e-8
    @test k3.angle == 36

    @test dist_fcn([d2.cx, d2.cy], [-1/2, h]) < 5e-8
    @test d2.angle == 36
end

@testset "Vertex 6" begin
    phi = (1+sqrt(5))/2

    d1 = Dart(-phi, 0, 0)
    k1 = placeKiteEdge(4, edge_center(d1, 2), edge_angle(d1, 2))
    k2 = placeKiteEdge(2, edge_center(k1, 3), edge_angle(k1, 3))
    k3 = placeKiteEdge(4, edge_center(k2, 1), edge_angle(k2, 1))
    k4 = placeKiteEdge(2, edge_center(k3, 3), edge_angle(k3, 3))

    h = sqrt(5+2*sqrt(5))/2
    k = (2+sqrt(5)) / (1+sqrt(5))
    p = sqrt(10 + sqrt(20))/4

    @test dist_fcn([d1.cx, d1.cy], [-phi, 0]) < 5e-8
    @test d1.angle == 0

    @test dist_fcn([k1.cx, k1.cy], [-1/2,-h]) < 5e-8
    @test k1.angle == 0

    @test dist_fcn([k2.cx, k2.cy], [ k,-p]) < 5e-8
    @test k2.angle == 216

    @test dist_fcn([k3.cx, k3.cy], [ k, p]) < 5e-8
    @test k3.angle == 144

    @test dist_fcn([k4.cx, k4.cy], [-1/2, h]) < 5e-8
    @test k4.angle == 0
end

@testset "Vertex 7" begin
    phi = (1+sqrt(5))/2
    h = sqrt(5+2*sqrt(5))/2
    k = (2+sqrt(5)) / (1+sqrt(5))
    p = sqrt(10 + sqrt(20))/4

    k1 = Kite(k-1,-p, 108)
    pt = edge_center(k1, 2)
    ag = edge_angle(k1, 2)
    println("place k2 at $pt, $ag")
    k2 = placeKiteEdge(3, edge_center(k1, 2), edge_angle(k1, 2))
    d1 = placeDartEdge(4, edge_center(k2, 2), edge_angle(k2, 2))
    d2 = placeDartEdge(2, edge_center(d1, 3), edge_angle(d1, 3))

    @test dist_fcn([k1.cx, k1.cy], [k-1, -p]) < 5e-8
    @test k1.angle == 108

    @test dist_fcn([k2.cx, k2.cy], [k-1, p]) < 5e-8
    @test k2.angle == 252

    @test dist_fcn([d1.cx, d1.cy], [-k, p]) < 5e-8
    @test d1.angle == 216

    @test dist_fcn([d2.cx, d2.cy], [-k,-p]) < 5e-8
    @test d2.angle == 144
end

